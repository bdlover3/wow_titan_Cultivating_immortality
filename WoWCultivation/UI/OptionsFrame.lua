-- ============================================================
-- OptionsFrame.lua - 修仙设置面板
-- 目标版本: 泰坦时光服 3.80.1 (Interface: 38001)
-- 使用新版 Settings API
-- ============================================================
local UI = {}
UI.name = "OptionsFrame"
WoWCultivation.UI.OptionsFrame = UI

UI.OPTIONS = {
    { key = "sisterEnabled",     name = "小师妹",         desc = "显示小师妹3D模型",                       type = "toggle", default = true },
    { key = "channelEnabled",    name = "修仙频道",       desc = "自动加入修仙界频道",                     type = "toggle", default = true },
    { key = "toastEnabled",      name = "浮动提示",       desc = "显示修仙相关的浮动提示信息",              type = "toggle", default = true },
    { key = "realmLabelEnabled", name = "境界标签",       desc = "在队伍姓名板上显示境界标签",             type = "toggle", default = true },
    { key = "chatFilterEnabled", name = "聊天修仙化",     desc = "将聊天消息修仙化（如密语→传音入密）",    type = "toggle", default = true },
    { key = "innerDemonEnabled", name = "心魔系统",       desc = "启用控制技能触发心魔值系统",             type = "toggle", default = true },
    { key = "karmaEnabled",      name = "因果系统",       desc = "启用击杀/治疗/任务的善恶因果系统",       type = "toggle", default = true },
    { key = "treasureTooltip",   name = "灵宝提示",       desc = "在物品提示中显示灵宝品阶",               type = "toggle", default = true },
    { key = "elixirTooltip",     name = "丹药提示",       desc = "在物品提示中显示丹药名称",               type = "toggle", default = true },
    { key = "spiritVeinNotify",  name = "灵脉通知",       desc = "切换区域时显示灵脉品质通知",             type = "toggle", default = true },
    { key = "bgNameOverride",    name = "战场修仙化",     desc = "将战场名称修仙化",                        type = "toggle", default = true },
    { key = "miniMapIcon",       name = "小地图图标",     desc = "在小地图上显示修仙传图标",               type = "toggle", default = false },
}

function UI:OnEnable()
    self:CreateSettingsPanel()
end

function UI:CreateSettingsPanel()
    if not Settings or not Settings.RegisterVerticalLayoutCategory then
        WoWCultivation:Print("|cFFFF0000警告: Settings API 不可用，无法注册设置面板|r")
        return
    end

    local category = Settings.RegisterVerticalLayoutCategory("魔兽修仙传")

    for _, opt in ipairs(UI.OPTIONS) do
        local key = opt.key  -- Lua 5.1: capture loop var in a local to avoid closure sharing

        local getter = function()
            return WoWCultivation.Core.DB:GetSetting(key)
        end

        local setter
        if key == "sisterEnabled" then
            setter = function(value)
                WoWCultivation.Core.DB:SetSetting(key, value)
                if WoWCultivation.UI.SisterModel and WoWCultivation.UI.SisterModel.frame then
                    if value then
                        WoWCultivation.UI.SisterModel.frame:Show()
                    else
                        WoWCultivation.UI.SisterModel.frame:Hide()
                    end
                end
            end
        else
            setter = function(value)
                WoWCultivation.Core.DB:SetSetting(key, value)
            end
        end

        local setting = Settings.RegisterProxySetting(
            category,
            "WOW_CULTIVATION_" .. key:upper(),
            Settings.VarType.Boolean,
            opt.name,
            opt.default,
            getter,
            setter
        )
        Settings.CreateCheckbox(category, setting, opt.desc)
    end

    Settings.RegisterAddOnCategory(category)
    self.category = category
    WoWCultivation:Debug("设置面板已通过 Settings API 注册")
end

function UI:Toggle()
    if self.category then
        Settings.OpenToCategory(self.category:GetID())
    end
end

function UI:Show()
    self:Toggle()
end

function UI:Hide()
    if self.category then
        Settings.OpenToCategory(0)
    end
end

WoWCultivation.UI.OptionsFrame = UI
