-- ============================================================
-- CultivationBar.lua - 修仙状态栏
-- 目标版本: 3.80.1 — BackdropTemplate
-- ============================================================
local UI = {}
UI.name = "CultivationBar"
WoWCultivation.UI.CultivationBar = UI

UI.SAVED_VAR = "WoWCultivationBarPosition"

local REALM_ICON = "Interface\\Icons\\Spell_Holy_DivineSpirit"
local TOP_STONE_ICON = "Interface\\Icons\\INV_Misc_Coin_01"
local MID_STONE_ICON = "Interface\\Icons\\INV_Misc_Coin_03"
local LOW_STONE_ICON = "Interface\\Icons\\INV_Misc_Coin_05"
local DAO_ICON = "Interface\\Icons\\Spell_Holy_Restoration"

local function SetTextureSafe(tex, path)
    if not tex then return end
    local ok = pcall(function() tex:SetTexture(path) end)
    if not ok then
        pcall(function() tex:SetColorTexture(0.5, 0.5, 0.5, 1) end)
    end
end

local function CreateIconWithTooltip(parent, size, texturePath, tooltipText)
    local icon = parent:CreateTexture(nil, "ARTWORK")
    icon:SetSize(size, size)
    SetTextureSafe(icon, texturePath)

    local hover = CreateFrame("Frame", nil, parent)
    hover:SetSize(size, size)
    hover:SetAllPoints(icon)
    hover:EnableMouse(true)
    hover:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(tooltipText, 1, 1, 1)
        GameTooltip:Show()
    end)
    hover:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    return icon, hover
end

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationBarFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(520, 36)
    f:SetPoint("TOP", UIParent, "TOP", 0, -30)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    f:SetBackdropColor(0.08, 0.04, 0.12, 0.92)
    f:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        UI:SavePosition()
    end)

    local prev = nil

    local realmIcon, realmHover = CreateIconWithTooltip(f, 18, REALM_ICON, "修仙境界")
    realmIcon:SetPoint("LEFT", f, "LEFT", 10, 0)
    f.realmIcon = realmIcon
    prev = realmIcon

    local realmText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    realmText:SetPoint("LEFT", prev, "RIGHT", 4, 0)
    realmText:SetText("|cFFAA44FF凡人|r")
    f.realmText = realmText
    prev = realmText

    local separator1 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    separator1:SetPoint("LEFT", prev, "RIGHT", 6, 0)
    separator1:SetText("|cFF666666‖|r")
    prev = separator1

    local topStoneIcon, topStoneHover = CreateIconWithTooltip(f, 14, TOP_STONE_ICON, "上品灵石")
    topStoneIcon:SetPoint("LEFT", prev, "RIGHT", 6, 0)
    f.topStoneIcon = topStoneIcon
    prev = topStoneIcon

    local topStoneText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    topStoneText:SetPoint("LEFT", prev, "RIGHT", 2, 0)
    topStoneText:SetText("|cFFFFD7000|r")
    f.topStoneText = topStoneText
    prev = topStoneText

    local midStoneIcon, midStoneHover = CreateIconWithTooltip(f, 14, MID_STONE_ICON, "中品灵石")
    midStoneIcon:SetPoint("LEFT", prev, "RIGHT", 6, 0)
    f.midStoneIcon = midStoneIcon
    prev = midStoneIcon

    local midStoneText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    midStoneText:SetPoint("LEFT", prev, "RIGHT", 2, 0)
    midStoneText:SetText("|cFFC0C0C00|r")
    f.midStoneText = midStoneText
    prev = midStoneText

    local lowStoneIcon, lowStoneHover = CreateIconWithTooltip(f, 14, LOW_STONE_ICON, "下品灵石")
    lowStoneIcon:SetPoint("LEFT", prev, "RIGHT", 6, 0)
    f.lowStoneIcon = lowStoneIcon
    prev = lowStoneIcon

    local lowStoneText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lowStoneText:SetPoint("LEFT", prev, "RIGHT", 2, 0)
    lowStoneText:SetText("|cFFCD853F0|r")
    f.lowStoneText = lowStoneText
    prev = lowStoneText

    local separator2 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    separator2:SetPoint("LEFT", prev, "RIGHT", 6, 0)
    separator2:SetText("|cFF666666‖|r")
    prev = separator2

    local daoIcon, daoHover = CreateIconWithTooltip(f, 18, DAO_ICON, "道行（成就点数）")
    daoIcon:SetPoint("LEFT", prev, "RIGHT", 6, 0)
    f.daoIcon = daoIcon
    prev = daoIcon

    local daoText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    daoText:SetPoint("LEFT", prev, "RIGHT", 4, 0)
    daoText:SetText("|cFFFF88000|r")
    f.daoText = daoText

    f:Show()
    self:LoadPosition()
    self:StartUpdateLoop()
end

function UI:UpdateData()
    if not self.frame then return end

    local realmName = "凡人"
    local RealmModule = WoWCultivation.Modules and WoWCultivation.Modules.RealmModule
    if RealmModule and RealmModule.GetRealm then
        realmName = RealmModule:GetRealm() or "凡人"
    end
    self.frame.realmText:SetText("|cFFAA44FF" .. realmName .. "|r")

    local topStones, midStones, lowStones = 0, 0, 0
    local CurrencyModule = WoWCultivation.Modules and WoWCultivation.Modules.CurrencyModule
    if CurrencyModule and CurrencyModule.GetSpiritStones then
        topStones, midStones, lowStones = CurrencyModule:GetSpiritStones()
    end
    self.frame.topStoneText:SetText("|cFFFFD700" .. BreakUpLargeNumbers(topStones) .. "|r")
    self.frame.midStoneText:SetText("|cFFC0C0C0" .. BreakUpLargeNumbers(midStones) .. "|r")
    self.frame.lowStoneText:SetText("|cFFCD853F" .. BreakUpLargeNumbers(lowStones) .. "|r")

    local daoPoints = 0
    if GetTotalAchievementPoints then
        daoPoints = GetTotalAchievementPoints() or 0
    end
    self.frame.daoText:SetText("|cFFFF8800" .. BreakUpLargeNumbers(daoPoints) .. "|r")
end

function UI:StartUpdateLoop()
    if C_Timer and C_Timer.NewTicker then
        local ok, ticker = pcall(function()
            return C_Timer.NewTicker(2, function()
                UI:UpdateData()
            end)
        end)
        if ok then
            self.updateTicker = ticker
        else
            self:StartFallbackUpdateLoop()
        end
    else
        self:StartFallbackUpdateLoop()
    end
    self:UpdateData()
end

function UI:StartFallbackUpdateLoop()
    local f = CreateFrame("Frame")
    local elapsed = 0
    f:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        if elapsed >= 2 then
            elapsed = 0
            UI:UpdateData()
        end
    end)
    self.updateTicker = f
end

function UI:SavePosition()
    if not self.frame then return end
    local point, _, relPoint, x, y = self.frame:GetPoint()
    WoWCultivationDB = WoWCultivationDB or {}
    WoWCultivationDB[self.SAVED_VAR] = {
        point = point,
        relPoint = relPoint,
        x = x,
        y = y
    }
end

function UI:LoadPosition()
    if not self.frame then return end
    WoWCultivationDB = WoWCultivationDB or {}
    local pos = WoWCultivationDB[self.SAVED_VAR]
    if pos then
        self.frame:ClearAllPoints()
        self.frame:SetPoint(pos.point, UIParent, pos.relPoint, pos.x, pos.y)
    end
end
