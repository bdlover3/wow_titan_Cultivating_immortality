local Module = {}
Module.name = "RealmModule"
Module.enabled = false

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("PLAYER_LEVEL_UP", function(level)
        self:OnLevelUp(level)
    end)
    EM:Register("PLAYER_ENTERING_WORLD", function()
        self:OnEnteringWorld()
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:OnLevelUp(level)
    local realmInfo = WoWCultivation.Data.Realm[level]
    if realmInfo then
        WoWCultivation:Print("恭喜突破至 " .. realmInfo.name .. "！")
        if realmInfo.milestone then
            if WoWCultivation.Modules.MilestoneModule then
                WoWCultivation.Modules.MilestoneModule:Trigger(realmInfo.milestone)
            end
        end
        if WoWCultivation.Data.Milestone.tribulationLevels[level] then
            local tribName = WoWCultivation.Data.Milestone.tribulationLevels[level]
            if WoWCultivation.UI.Toast then
                WoWCultivation.UI.Toast:Show("天劫降临！" .. tribName .. "！", 5)
            end
        end
    end
end

function Module:OnEnteringWorld()
    local level = UnitLevel("player")
    local realmInfo = WoWCultivation.Data.Realm[level]
    if realmInfo then
        WoWCultivation:Print("当前境界: " .. realmInfo.bigRealm .. " · " .. realmInfo.name)
    end
end

function Module:GetRealmInfo(level)
    level = level or UnitLevel("player")
    return WoWCultivation.Data.Realm[level]
end

function Module:GetRealmName(level)
    local info = self:GetRealmInfo(level)
    if info then
        return info.name
    end
    return "未知境界"
end

function Module:GetBigRealm(level)
    local info = self:GetRealmInfo(level)
    if info then
        return info.bigRealm
    end
    return "未知"
end

function Module:GetRealmTitle(level)
    local info = self:GetRealmInfo(level)
    if info then
        return info.bigRealm .. " · " .. info.name
    end
    return "未知境界"
end

function Module:GetRealm(level)
    return self:GetRealmTitle(level)
end

function Module:GetExp()
    local curXP = UnitXP("player")
    return curXP
end

function Module:GetMaxExp()
    local maxXP = UnitXPMax("player")
    return maxXP
end

WoWCultivation.Modules.RealmModule = Module
