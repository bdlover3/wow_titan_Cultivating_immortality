local Module = {}
Module.name = "SectModule"
Module.enabled = false

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("PLAYER_ENTERING_WORLD", function()
        self:OnEnteringWorld()
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:OnEnteringWorld()
    local sectInfo = self:GetPlayerSectInfo()
    if sectInfo then
        WoWCultivation:Print("当前宗门: " .. sectInfo.name)
    end
end

function Module:GetPlayerSectInfo()
    local _, englishClass = UnitClass("player")
    return WoWCultivation.Data.Sect[englishClass]
end

function Module:GetSectName(englishClass)
    englishClass = englishClass or select(2, UnitClass("player"))
    local sect = WoWCultivation.Data.Sect[englishClass]
    if sect then
        return sect.name
    end
    return "散修"
end

function Module:GetSectTitle(englishClass, level)
    local sect = WoWCultivation.Data.Sect[englishClass]
    if not sect then return "散修" end
    local titleIndex
    if level >= 71 then
        titleIndex = 4
    elseif level >= 59 then
        titleIndex = 3
    elseif level >= 41 then
        titleIndex = 2
    else
        titleIndex = 1
    end
    return sect.titles[titleIndex] or sect.titles[1]
end

function Module:GetSpiritRoot(englishClass)
    local sect = WoWCultivation.Data.Sect[englishClass]
    if sect then
        return sect.spiritRoot
    end
    return "未知灵根"
end

function Module:GetMainTechnique(englishClass)
    local sect = WoWCultivation.Data.Sect[englishClass]
    if sect and sect.techniques and sect.techniques[1] then
        return sect.techniques[1].name
    end
    return "未知功法"
end

function Module:GetSect(englishClass)
    return self:GetSectName(englishClass)
end

function Module:GetRank(englishClass, level)
    englishClass = englishClass or select(2, UnitClass("player"))
    level = level or UnitLevel("player")
    return self:GetSectTitle(englishClass, level)
end

function Module:GetTechnique(englishClass)
    return self:GetMainTechnique(englishClass)
end

WoWCultivation.Modules.SectModule = Module
