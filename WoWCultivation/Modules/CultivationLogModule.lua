local Module = {}
Module.name = "CultivationLogModule"
Module.enabled = false

Module.LOG_TYPES = {
    CULTIVATION = "修为精进",
    TREASURE    = "获得灵宝",
    DUNGEON     = "探索秘境",
    PVP         = "斗法胜绩",
}

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("PLAYER_LEVEL_UP", function(level)
        self:OnLevelUp(level)
    end)
    EM:Register("CHAT_MSG_LOOT", function(msg)
        self:OnLoot(msg)
    end)
    EM:Register("LFG_COMPLETION_REWARD", function()
        self:OnDungeonComplete()
    end)
    EM:Register("PVP_MATCH_COMPLETE", function()
        self:OnPvPComplete()
    end)
    EM:Register("PLAYER_ENTERING_WORLD", function()
        self:CheckDailyReset()
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:CheckDailyReset()
    local data = WoWCultivationCharDB.cultivationLog
    if not data then return end
    local today = date("%Y-%m-%d")
    if data.lastDate ~= today then
        data.lastDate = today
        data.dailyCount = 0
    end
end

function Module:AddLog(logType, detail)
    local data = WoWCultivationCharDB.cultivationLog
    if not data then return end

    self:CheckDailyReset()

    local entry = {
        type = logType,
        detail = detail or "",
        time = time(),
        date = date("%Y-%m-%d %H:%M"),
    }
    table.insert(data, entry)
    data.dailyCount = (data.dailyCount or 0) + 1

    if #data > 500 then
        local trimmed = {}
        for i = (#data - 399), #data do
            table.insert(trimmed, data[i])
        end
        WoWCultivationCharDB.cultivationLog = trimmed
        WoWCultivationCharDB.cultivationLog.lastDate = data.lastDate
        WoWCultivationCharDB.cultivationLog.dailyCount = data.dailyCount
    end

    local typeName = self.LOG_TYPES[logType] or logType
    WoWCultivation:Print("【" .. typeName .. "】" .. (detail or ""))
end

function Module:OnLevelUp(level)
    self:AddLog("CULTIVATION", "修为精进，突破至" .. (WoWCultivation.Data.Realm[level] and WoWCultivation.Data.Realm[level].name or "新境界"))
end

function Module:OnLoot(msg)
    if not msg then return end
    local itemLink = msg:match("|c%x+|Hitem:.-|h%[.-%]|h|r")
    if not itemLink then return end
    local itemName, _, itemRarity = GetItemInfo(itemLink)
    if itemName and itemRarity and itemRarity >= 4 then
        self:AddLog("TREASURE", "获得灵宝: " .. itemName)
    end
end

function Module:OnDungeonComplete()
    local zoneName = GetRealZoneText()
    self:AddLog("DUNGEON", "探索秘境: " .. zoneName)
end

function Module:OnPvPComplete()
    self:AddLog("PVP", "斗法胜绩")
end

function Module:GetLogsByType(logType)
    local data = WoWCultivation.Core.DB:GetChar("cultivationLog")
    if not data then return {} end
    local result = {}
    for _, entry in ipairs(data) do
        if entry.type == logType then
            table.insert(result, entry)
        end
    end
    return result
end

function Module:GetRecentLogs(count)
    local data = WoWCultivation.Core.DB:GetChar("cultivationLog")
    if not data then return {} end
    count = count or 20
    local result = {}
    local startIdx = max(1, #data - count + 1)
    for i = startIdx, #data do
        table.insert(result, data[i])
    end
    return result
end

function Module:GetTodayLogCount()
    local data = WoWCultivation.Core.DB:GetChar("cultivationLog")
    return data and data.dailyCount or 0
end

function Module:GetLogSummary()
    local data = WoWCultivation.Core.DB:GetChar("cultivationLog")
    if not data then return "修炼日志: 暂无记录" end
    local counts = {}
    for k, v in pairs(self.LOG_TYPES) do
        counts[k] = 0
    end
    for _, entry in ipairs(data) do
        if counts[entry.type] then
            counts[entry.type] = counts[entry.type] + 1
        end
    end
    local parts = {}
    for k, v in pairs(self.LOG_TYPES) do
        if counts[k] and counts[k] > 0 then
            table.insert(parts, v .. ": " .. counts[k])
        end
    end
    if #parts == 0 then return "修炼日志: 暂无记录" end
    return "修炼日志: " .. table.concat(parts, "  ")
end

WoWCultivation.Modules.CultivationLogModule = Module
