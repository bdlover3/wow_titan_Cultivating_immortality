local Module = {}
Module.name = "SpiritVeinModule"
Module.enabled = false

Module.ZONE_TYPE_MAP = {
    city     = { name = "灵脉汇聚", quality = 3, desc = "主城之中，灵脉交汇，修炼效率倍增", color = "|cFF00FF00" },
    outdoor  = { name = "灵脉稀薄", quality = 1, desc = "旷野荒原，灵气稀薄，需潜心修炼", color = "|cFFAAAAAA" },
    dungeon  = { name = "灵脉浓郁", quality = 4, desc = "秘境之中，灵脉浓郁，机缘与危险并存", color = "|cFFA335EE" },
    rest     = { name = "灵脉温润", quality = 2, desc = "休憩之所，灵脉温润，调息最佳", color = "|cFF4FC3F7" },
    pvp      = { name = "灵脉紊乱", quality = 1, desc = "斗法之地，灵脉紊乱，难以凝聚", color = "|cFFFF0000" },
    raid     = { name = "灵脉狂暴", quality = 5, desc = "上古秘境，灵脉狂暴，非大能者不可入", color = "|cFFFF8000" },
}

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("ZONE_CHANGED_NEW_AREA", function()
        self:OnZoneChanged()
    end)
    EM:Register("ZONE_CHANGED", function()
        self:OnZoneChanged()
    end)
    EM:Register("ZONE_CHANGED_INDOORS", function()
        self:OnZoneChanged()
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:GetCurrentZoneType()
    local inInstance, instanceType = IsInInstance()

    if inInstance then
        if instanceType == "party" then
            return "dungeon"
        elseif instanceType == "raid" then
            return "raid"
        elseif instanceType == "pvp" then
            return "pvp"
        end
    end

    if IsResting() then
        local _, _, _, _, _, _, _, _, _, inCity = GetZonePVPInfo()
        if inCity then
            return "city"
        end
        return "rest"
    end

    local pvpType = GetZonePVPInfo()
    if pvpType == "sanctuary" then
        return "city"
    end

    return "outdoor"
end

function Module:GetCurrentVeinInfo()
    local zoneType = self:GetCurrentZoneType()
    return self.ZONE_TYPE_MAP[zoneType] or self.ZONE_TYPE_MAP.outdoor
end

function Module:OnZoneChanged()
    local veinInfo = self:GetCurrentVeinInfo()
    local zoneName = GetRealZoneText()
    WoWCultivation:Print(zoneName .. " — " .. veinInfo.color .. veinInfo.name .. "|r: " .. veinInfo.desc)
    if WoWCultivation.UI.Toast then
        WoWCultivation.UI.Toast:Show(veinInfo.color .. veinInfo.name .. "|r — " .. veinInfo.desc, 3)
    end
end

function Module:GetVeinQuality()
    local veinInfo = self:GetCurrentVeinInfo()
    return veinInfo.quality
end

function Module:GetVeinText()
    local veinInfo = self:GetCurrentVeinInfo()
    local zoneName = GetRealZoneText()
    return zoneName .. " — " .. veinInfo.color .. veinInfo.name .. "|r"
end

function Module:GetCultivationMultiplier()
    local quality = self:GetVeinQuality()
    local multipliers = {
        [1] = 1.0,
        [2] = 1.2,
        [3] = 1.5,
        [4] = 2.0,
        [5] = 2.5,
    }
    return multipliers[quality] or 1.0
end

WoWCultivation.Modules.SpiritVeinModule = Module
