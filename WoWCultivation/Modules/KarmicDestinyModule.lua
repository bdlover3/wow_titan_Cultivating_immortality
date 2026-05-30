local Module = {}
Module.name = "KarmicDestinyModule"
Module.enabled = false

Module.RARE_MOB_IDS = {
    [142708] = true,
    [142709] = true,
    [142710] = true,
    [142711] = true,
    [142712] = true,
    [137388] = true,
    [137389] = true,
    [137390] = true,
    [137391] = true,
    [137392] = true,
}

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("CHAT_MSG_LOOT", function(msg)
        self:OnChatMsgLoot(msg)
    end)
    EM:Register("COMBAT_LOG_EVENT_UNFILTERED", function(timestamp, subEvent, _, sourceGUID, _, _, _, destGUID, destName, ...)
        self:OnCombatLog(subEvent, sourceGUID, destGUID, destName)
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:RecordDestiny(eventType, detail)
    local data = WoWCultivationCharDB.karmicDestiny
    if not data then return end

    -- 确保 entries 数组存在
    if not data.entries then
        data.entries = {}
    end

    local record = {
        type = eventType,
        detail = detail or "",
        time = time(),
        date = date("%Y-%m-%d %H:%M"),
    }
    table.insert(data.entries, record)

    WoWCultivation:Print("【仙缘际遇】" .. eventType .. " — " .. (detail or ""))
    if WoWCultivation.UI.Toast then
        WoWCultivation.UI.Toast:Show("仙缘际遇: " .. eventType, 4)
    end

    if WoWCultivation.Modules.SisterModule then
        WoWCultivation.Modules.SisterModule:Say("师兄，仙缘降临！")
    end
end

function Module:OnChatMsgLoot(msg)
    if not msg then return end

    local itemLink = msg:match("|c%x+|Hitem:.-|h%[.-%]|h|r")
    if not itemLink then return end

    local itemName, _, itemRarity = GetItemInfo(itemLink)
    if not itemName then return end

    if itemRarity and itemRarity >= 4 then
        local qualityNames = {
            [4] = "灵宝",
            [5] = "仙器",
            [6] = "先天灵宝",
        }
        local qualityName = qualityNames[itemRarity] or "至宝"
        self:RecordDestiny("天降灵宝", qualityName .. ": " .. itemName)
    end
end

function Module:OnCombatLog(subEvent, sourceGUID, destGUID, destName)
    if subEvent ~= "PARTY_KILL" then return end
    if sourceGUID ~= UnitGUID("player") then return end

    local destId = tonumber(destGUID:match("Creature%-.-%-.-%-.-%-.-%-(%d+)") or "0")
    if destId and self.RARE_MOB_IDS[destId] then
        self:RecordDestiny("仙缘际遇", "斩杀稀有灵兽: " .. (destName or "未知"))
    end
end

function Module:GetDestinyCount()
    local data = WoWCultivation.Core.DB:GetChar("karmicDestiny")
    if not data or not data.entries then return 0 end
    return #data.entries
end

function Module:GetDestinyByType(eventType)
    local data = WoWCultivation.Core.DB:GetChar("karmicDestiny")
    if not data or not data.entries then return {} end
    local result = {}
    for _, record in ipairs(data.entries) do
        if record.type == eventType then
            table.insert(result, record)
        end
    end
    return result
end

function Module:GetRecentDestiny(count)
    local data = WoWCultivation.Core.DB:GetChar("karmicDestiny")
    if not data or not data.entries then return {} end
    count = count or 10
    local entries = data.entries
    local result = {}
    local startIdx = math.max(1, #entries - count + 1)
    for i = startIdx, #entries do
        table.insert(result, entries[i])
    end
    return result
end

WoWCultivation.Modules.KarmicDestinyModule = Module
