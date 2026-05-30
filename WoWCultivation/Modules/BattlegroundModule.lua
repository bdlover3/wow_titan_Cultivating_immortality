local Module = {}
Module.name = "BattlegroundModule"
Module.enabled = false

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    -- 3.80.1: 使用 ZONE_CHANGED 替代 ZONE_CHANGED_NEW_AREA
    EM:Register("ZONE_CHANGED", function()
        self:OnZoneChanged()
    end)
    EM:Register("PLAYER_PVP_KILLS_CHANGED", function()
        self:OnPvPKill()
    end)
    EM:Register("PLAYER_PVP_RANK_CHANGED", function()
        self:OnPvPRankChanged()
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:OnZoneChanged()
    local zoneName = GetRealZoneText()
    local bgData = WoWCultivation.Data.Battleground.map[zoneName]
    if bgData then
        WoWCultivation:Print("进入宗门争锋: " .. bgData.name .. " — " .. bgData.desc)
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("宗门争锋: " .. bgData.name, 4)
        end
    end
end

function Module:OnPvPKill()
    if WoWCultivation.UI.Toast then
        WoWCultivation.UI.Toast:Show("斗法胜绩+1，道友威武！", 3)
    end
end

function Module:OnPvPRankChanged()
    local rank = UnitPVPRank("player")
    local rankData = WoWCultivation.Data.Battleground.pvpRanks[rank]
    if rankData then
        WoWCultivation:Print("斗法境界突破: " .. rankData.name)
    end
end

function Module:GetBattlegroundName(zoneName)
    local bgData = WoWCultivation.Data.Battleground.map[zoneName]
    if bgData then
        return bgData.name
    end
    return zoneName
end

function Module:GetPvPRankName(rank)
    local rankData = WoWCultivation.Data.Battleground.pvpRanks[rank]
    if rankData then
        return rankData.name
    end
    return "初入斗法"
end

function Module:IsInBattleground()
    -- WotLK: IsInInstance() 返回 inInstance, instanceType
    local inInstance, instanceType = IsInInstance()
    return inInstance and instanceType == "pvp"
end

WoWCultivation.Modules.BattlegroundModule = Module
