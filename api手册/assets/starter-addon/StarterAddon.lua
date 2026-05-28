--[[
    StarterAddon - 时光服 3.80.1 入门插件模板
    主逻辑文件：初始化、事件处理、通用工具
]]

StarterAddon = StarterAddon or {}
StarterAddon.version = "1.0.0"

-- 默认配置
local defaults = {
    enabled = true,
    alpha = 0.8,
    scale = 1.0,
    locked = false,
    showMinimap = true,
    debug = false,
}

-- 初始化 SavedVariables
local function InitDB()
    StarterAddonDB = StarterAddonDB or {}
    for key, value in pairs(defaults) do
        if StarterAddonDB[key] == nil then
            StarterAddonDB[key] = value
        end
    end
end

-- 调试输出
function StarterAddon:Debug(msg)
    if StarterAddonDB and StarterAddonDB.debug then
        print("|cffff9900[StarterAddon Debug]|r " .. tostring(msg))
    end
end

-- 信息输出
function StarterAddon:Print(msg)
    print("|cff00ff00[StarterAddon]|r " .. tostring(msg))
end

-- 登录打招呼功能
function StarterAddon:Greet(name, level, class, realm)
    if not name then return end

    -- 职业颜色映射
    local classColors = {
        WARRIOR = "C79C6E",
        PALADIN = "F58CBA",
        HUNTER = "ABD473",
        ROGUE = "FFF569",
        PRIEST = "FFFFFF",
        DEATHKNIGHT = "C41F3B",
        SHAMAN = "0070DE",
        MAGE = "69CCF0",
        WARLOCK = "9482C9",
        DRUID = "FF7D0A",
    }

    local color = classColors[class] or "FFFFFF"

    -- 打印问候消息
    print(" ")
    print("|cffffd700═══════════════════════════════════════════|r")
    print("|cff00ff00  欢迎回来，道友！|r")
    print("|cff888888  ─────────────────────────────────────|r")
    print("|cff00ff00  角色: |r|cff" .. color .. name .. "|r|cff00ff00  等级: |r|cffffd700" .. tostring(level) .. "|r")
    print("|cff00ff00  职业: |r|cff" .. color .. class .. "|r")
    print("|cff00ff00  服务器: |r|cff888888" .. (realm or "未知") .. "|r")
    print("|cffffd700═══════════════════════════════════════════|r")
    print(" ")

    StarterAddon:Debug("打招呼完成: " .. name)
end

-- 主事件 Frame
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    local args = {...}

    if event == "ADDON_LOADED" then
        local addonName = args[1]
        if addonName == "StarterAddon" then
            InitDB()
            StarterAddon:Debug("ADDON_LOADED: 数据库已初始化")
        end

    elseif event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")

        -- 获取玩家信息
        local playerName = UnitName("player")
        local playerLevel = UnitLevel("player")
        local _, playerClass = UnitClass("player")
        local playerRealm = GetRealmName()

        -- 打招呼功能
        StarterAddon:Greet(playerName, playerLevel, playerClass, playerRealm)

        StarterAddon:Print("v" .. StarterAddon.version .. " 已加载!")
        StarterAddon:Print("输入 /sa 或 /starteraddon 打开设置面板")

        -- 初始化子模块
        if StarterAddon.InitConfig then
            StarterAddon:InitConfig()
            StarterAddon:Debug("配置面板已初始化")
        end
        if StarterAddon.InitCastButton then
            StarterAddon:InitCastButton()
            StarterAddon:Debug("施法按钮已初始化")
        end
        if StarterAddon.InitMinimap then
            StarterAddon:InitMinimap()
            StarterAddon:Debug("小地图按钮已初始化")
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        local isInitialLogin, isReloadingUi = args[1], args[2]
        StarterAddon:Debug("进入世界 (首次登录: " .. tostring(isInitialLogin) .. ", 重载UI: " .. tostring(isReloadingUi) .. ")")
    end
end)

-- 注册斜杠命令
SLASH_STARTERADDON1 = "/sa"
SLASH_STARTERADDON2 = "/starteraddon"
SlashCmdList["STARTERADDON"] = function(msg)
    msg = msg and msg:trim() or ""

    if msg == "" or msg == "config" then
        if StarterAddon.OpenConfig then
            StarterAddon:OpenConfig()
        else
            StarterAddon:Print("配置面板未加载")
        end
    elseif msg == "debug" then
        StarterAddonDB.debug = not StarterAddonDB.debug
        StarterAddon:Print("调试模式: " .. (StarterAddonDB.debug and "|cff00ff00开启|r" or "|cffff0000关闭|r"))
    elseif msg == "reset" then
        StarterAddonDB = {}
        InitDB()
        StarterAddon:Print("配置已重置为默认值，请 /reload")
    elseif msg == "reload" then
        ReloadUI()
    else
        StarterAddon:Print("可用命令:")
        StarterAddon:Print("  /sa          - 打开设置面板")
        StarterAddon:Print("  /sa debug    - 切换调试模式")
        StarterAddon:Print("  /sa reset    - 重置配置")
        StarterAddon:Print("  /sa reload   - 重载界面")
    end
end

-- 导出模块
StarterAddon.eventFrame = eventFrame
StarterAddon.defaults = defaults
StarterAddon.InitDB = InitDB