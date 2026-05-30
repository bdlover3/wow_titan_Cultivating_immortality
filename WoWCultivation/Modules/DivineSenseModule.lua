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
    -- ============================================================
    -- WotLK 3.80.1 右键菜单机制：
    --   UnitPopup_OpenMenu(which, contextData)
    --     → UnitPopupManager:OpenMenu(which, contextData)
    --       → MenuUtil.CreateContextMenu(parent, generatorFunc)
    --         generatorFunc 中 rootDescription:SetTag("MENU_UNIT_"..which)
    --         然后 rootDescription:CreateButton() 添加各项
    --
    -- 正确的注入方式：Menu.ModifyMenu(tag, callback)
    --   tag 匹配菜单标签（"MENU_UNIT_PARTY" 等）
    --   callback(ownerRegion, description, contextData) 中
    --     description:CreateButton(text, onClick) 追加按钮
    -- ============================================================

    if not Menu or not Menu.ModifyMenu then
        -- Menu API 不存在时的 fallback
        self:HookContextMenuFallback()
        return
    end

    -- 需要注入的菜单类型（对应 UnitPopup_OpenMenu 的 which 参数）
    local menuTags = {
        "MENU_UNIT_SELF",
        "MENU_UNIT_PARTY",
        "MENU_UNIT_PLAYER",
        "MENU_UNIT_RAID_PLAYER",
        "MENU_UNIT_ENEMY_PLAYER",
        "MENU_UNIT_TARGET",
    }

    for _, tag in ipairs(menuTags) do
        Menu.ModifyMenu(tag, function(ownerRegion, description, contextData)
            if not Module.enabled then return end
            if not contextData or not contextData.unit then return end
            if not UnitIsPlayer(contextData.unit) then return end

            local unit = contextData.unit
            description:CreateButton(
                "|cFFAA44FF神识探查|r",
                function()
                    Module:Inspect(unit)
                end
            )
        end)
    end
end

function Module:HookContextMenuFallback()
    -- 旧版兼容：hook UnitPopup_OpenMenu + 延迟注入 UIDropDownMenu 按钮
    if not UnitPopup_OpenMenu then return end

    hooksecurefunc("UnitPopup_OpenMenu", function(which, contextData)
        if not Module.enabled then return end
        local unit = contextData and contextData.unit
        if not unit or not UnitIsPlayer(unit) then return end

        -- 延迟一帧，等待原生菜单渲染完成
        C_Timer.After(0, function()
            Module:TryInjectDropDownMenu(unit)
        end)
    end)
end

function Module:TryInjectDropDownMenu(unit)
    for i = 1, 2 do
        local dropDown = _G["DropDownList" .. i]
        if dropDown and dropDown:IsVisible() then
            local info = UIDropDownMenu_CreateInfo()
            info.text = "|cFFAA44FF神识探查|r"
            info.func = function()
                Module:Inspect(unit)
            end
            info.notCheckable = true
            UIDropDownMenu_AddButton(info, i)
            return
        end
    end
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
