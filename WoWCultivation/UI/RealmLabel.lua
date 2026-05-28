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
        self:UpdateNamePlate(frame)
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
        if strfind(realmName, pattern) then
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

    if not UnitIsPlayer(unit) then return end

    local realmName = self:GetRealmForPlayer(unit)
    if not realmName then return end

    local color = self:GetRealmColor(realmName)
    local originalName = frame.name:GetText()
    if not originalName then return end

    if strfind(originalName, "%[") then return end

    frame.name:SetText(color .. "[" .. realmName .. "]|r " .. originalName)
end
