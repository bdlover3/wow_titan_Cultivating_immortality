local Module = {}
Module.name = "DivineSenseModule"
Module.enabled = false

function Module:OnEnable()
    self.enabled = true
    self:HookContextMenu()
end

function Module:OnDisable()
    self.enabled = false
end

function Module:HookContextMenu()
    hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
        if unit and UnitIsPlayer(unit) and UnitIsFriend("player", unit) then
            local info = UIDropDownMenu_CreateInfo()
            info.text = "神识探查"
            info.func = function()
                self:Inspect(unit)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)
end

function Module:Inspect(unit)
    if not unit then return end

    local name = UnitName(unit)
    local level = UnitLevel(unit)
    local _, englishClass = UnitClass(unit)

    local realmInfo = WoWCultivation.Data.Realm[level]
    local sectInfo = WoWCultivation.Data.Sect[englishClass]

    local realmName = realmInfo and (realmInfo.bigRealm .. " · " .. realmInfo.name) or "未知境界"
    local sectName = sectInfo and sectInfo.name or "散修"
    local spiritRoot = sectInfo and sectInfo.spiritRoot or "未知灵根"

    WoWCultivation:Print("===== 神识探查 =====")
    WoWCultivation:Print("道友: " .. (name or "未知"))
    WoWCultivation:Print("境界: " .. realmName)
    WoWCultivation:Print("门派: " .. sectName)
    WoWCultivation:Print("灵根: " .. spiritRoot)

    if WoWCultivation.UI.DivineSenseFrame then
        WoWCultivation.UI.DivineSenseFrame:Show({
            name = name,
            realm = realmName,
            sect = sectName,
            spiritRoot = spiritRoot,
            level = level,
        })
    end
end

WoWCultivation.Modules.DivineSenseModule = Module
