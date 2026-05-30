local UI = {}
UI.name = "RealmLabel"
WoWCultivation.UI.RealmLabel = UI

UI.REALM_COLORS = {
    ["练气"] = "|cFF00FF00",
    ["筑基"] = "|cFF4488FF",
    ["结丹"] = "|cFFAA44FF",
    ["元婴"] = "|cFFFF8800",
}

UI.REALM_ORDER = { "练气", "筑基", "结丹", "元婴" }

function UI:OnEnable()
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
        UI:UpdateNamePlate(frame)
    end)
end

function UI:GetRealmForPlayer(unit)
    if not unit then return nil end
    local level = UnitLevel(unit)
    if not level or level <= 0 then return nil end
    local RealmModule = WoWCultivation.Modules.RealmModule
    if RealmModule and RealmModule.GetBigRealm then
        return RealmModule:GetBigRealm(level)
    end
    return nil
end

function UI:GetRealmColor(realmName)
    if not realmName then return "|cFFFFFFFF" end
    for pattern, color in pairs(self.REALM_COLORS) do
        if string.find(realmName, pattern) then
            return color
        end
    end
    return "|cFFFFFFFF"
end

function UI:UpdateNamePlate(frame)
    if not frame then return end
    if not frame.name then return end

    local unit = frame.unit
    if not unit then return end

    -- 玩家和NPC都显示境界前缀
    if UnitIsPlayer(unit) then
        local realmName = self:GetRealmForPlayer(unit)
        if not realmName then return end

        local color = self:GetRealmColor(realmName)
        local originalName = frame.name:GetText()
        if not originalName then return end

        if string.find(originalName, "%[") then return end

        frame.name:SetText(color .. "[" .. realmName .. "]|r " .. originalName)
    elseif not UnitIsPlayer(unit) then
        -- 怪物/NPC根据等级显示境界前缀
        local level = UnitLevel(unit)
        if not level or level <= 0 then return end

        local realmName = self:GetRealmForPlayer(unit)
        if not realmName then return end

        local color = self:GetRealmColor(realmName)
        local originalName = frame.name:GetText()
        if not originalName then return end

        if string.find(originalName, "%[") then return end

        -- 怪物用不同标记与玩家区分
        frame.name:SetText(color .. "[" .. realmName .. "·妖]|r " .. originalName)
    end
end
