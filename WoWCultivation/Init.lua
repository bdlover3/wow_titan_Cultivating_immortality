WoWCultivation = {}
WoWCultivation.version = "1.0"

WoWCultivation.Core = {}
WoWCultivation.Modules = {}
WoWCultivation.UI = {}
WoWCultivation.Data = {}
WoWCultivation.Locale = {}

WoWCultivation.debug = false

if not C_Timer then
    C_Timer = {}
    function C_Timer.After(duration, callback)
        local frame = CreateFrame("Frame")
        local elapsed = 0
        frame:SetScript("OnUpdate", function(self, dt)
            elapsed = elapsed + dt
            if elapsed >= duration then
                self:SetScript("OnUpdate", nil)
                callback()
            end
        end)
    end
    function C_Timer.NewTicker(interval, callback)
        local frame = CreateFrame("Frame")
        local elapsed = 0
        frame:SetScript("OnUpdate", function(self, dt)
            elapsed = elapsed + dt
            if elapsed >= interval then
                elapsed = 0
                callback()
            end
        end)
        frame.Cancel = function(self)
            self:SetScript("OnUpdate", nil)
        end
        return frame
    end
end

if not BackdropTemplateMixin then
    local origCreateFrame = CreateFrame
    CreateFrame = function(frameType, name, parent, template, ...)
        if template == "BackdropTemplate" then
            template = nil
        end
        return origCreateFrame(frameType, name, parent, template, ...)
    end
end

do
    local testTex = UIParent:CreateTexture()
    if not testTex.SetColorTexture then
        local mt = getmetatable(testTex).__index
        function mt.SetColorTexture(self, r, g, b, a)
            self:SetTexture(r, g, b, a or 1)
        end
    end
end

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

local function OnEvent(self, event, addonName)
    if addonName ~= "WoWCultivation" then return end
    WoWCultivation.Core.DB:Init()
    WoWCultivation:Print("已加载 v" .. WoWCultivation.version)
    WoWCultivation.Core.Config:Init()
    for _, module in pairs(WoWCultivation.Modules) do
        if module.OnEnable then
            module:OnEnable()
        end
    end
    for _, ui in pairs(WoWCultivation.UI) do
        if ui.OnEnable then
            ui:OnEnable()
        end
    end
    self:UnregisterEvent("ADDON_LOADED")
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", OnEvent)
