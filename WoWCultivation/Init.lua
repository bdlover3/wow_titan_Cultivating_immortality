-- ============================================================
-- WoWCultivation Init.lua
-- 魔兽修仙传 - 插件入口
-- 目标版本: 泰坦时光服 3.80.1 (Interface: 38001)
-- ============================================================

WoWCultivation = {}
WoWCultivation.version = "1.0"

WoWCultivation.Core = {}
WoWCultivation.Modules = {}
WoWCultivation.UI = {}
WoWCultivation.Data = {}
WoWCultivation.Locale = {}

WoWCultivation.debug = false

-- ============================================================
-- 核心函数
-- ============================================================
local ADDON_NAME = "修仙传"
local COLOR_GREEN = "|cFF00FF00"
local COLOR_ORANGE = "|cFFFF9900"
local COLOR_RESET = "|r"

function WoWCultivation:Print(msg)
    print(COLOR_GREEN .. "[" .. ADDON_NAME .. "]" .. COLOR_RESET .. " " .. msg)
end

function WoWCultivation:Debug(msg)
    if self.debug then
        print(COLOR_ORANGE .. "[" .. ADDON_NAME .. "·调试]" .. COLOR_RESET .. " " .. msg)
    end
end

-- ============================================================
-- 插件加载入口
-- ============================================================
local function OnEvent(self, event, addonName)
    if addonName ~= "WoWCultivation" then return end

    WoWCultivation.Core.DB:Init()
    WoWCultivation:Print("已加载 v" .. WoWCultivation.version)

    WoWCultivation.Core.Config:Init()

    -- 启用所有模块
    for _, module in pairs(WoWCultivation.Modules) do
        if module.OnEnable then
            local ok, err = pcall(module.OnEnable, module)
            if not ok then
                print("|cFFFF0000[修仙传错误]|r 模块 [" .. (module.name or "未知") .. "] 启用失败: " .. tostring(err))
            end
        end
    end

    for _, ui in pairs(WoWCultivation.UI) do
        if ui.OnEnable then
            local ok, err = pcall(ui.OnEnable, ui)
            if not ok then
                print("|cFFFF0000[修仙传错误]|r UI [" .. (ui.name or "未知") .. "] 启用失败: " .. tostring(err))
            else
                WoWCultivation:Debug("UI [" .. (ui.name or "未知") .. "] 启用成功")
            end
        end
    end

    -- 特别检查小师妹模型
    if WoWCultivation.UI.SisterModel then
        if WoWCultivation.UI.SisterModel.frame then
            WoWCultivation:Print("小师妹模型已加载")
        else
            WoWCultivation:Print("警告: 小师妹模型未正确初始化")
        end
    end

    self:UnregisterEvent("ADDON_LOADED")
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", OnEvent)
