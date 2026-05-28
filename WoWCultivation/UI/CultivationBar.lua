local UI = {}
UI.name = "CultivationBar"
WoWCultivation.UI.CultivationBar = UI

UI.SAVED_VAR = "WoWCultivationBarPosition"

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationBarFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(360, 36)
    f:SetPoint("TOP", UIParent, "TOP", 0, -30)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
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

    local realmIcon = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    realmIcon:SetPoint("LEFT", f, "LEFT", 10, 0)
    realmIcon:SetText("|cFFFFD700☯|r")
    f.realmIcon = realmIcon

    local realmText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    realmText:SetPoint("LEFT", realmIcon, "RIGHT", 4, 0)
    realmText:SetText("|cFFAA44FF练气一层|r")
    f.realmText = realmText

    local separator1 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    separator1:SetPoint("LEFT", realmText, "RIGHT", 6, 0)
    separator1:SetText("|cFF666666‖|r")

    local spiritIcon = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    spiritIcon:SetPoint("LEFT", separator1, "RIGHT", 6, 0)
    spiritIcon:SetText("|cFF4488FF◆|r")
    f.spiritIcon = spiritIcon

    local spiritText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    spiritText:SetPoint("LEFT", spiritIcon, "RIGHT", 4, 0)
    spiritText:SetText("|cFF4488FF0|r")
    f.spiritText = spiritText

    local separator2 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    separator2:SetPoint("LEFT", spiritText, "RIGHT", 6, 0)
    separator2:SetText("|cFF666666‖|r")

    local daoIcon = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    daoIcon:SetPoint("LEFT", separator2, "RIGHT", 6, 0)
    daoIcon:SetText("|cFFFF8800✦|r")
    f.daoIcon = daoIcon

    local daoText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    daoText:SetPoint("LEFT", daoIcon, "RIGHT", 4, 0)
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

    local spiritCount = 0
    local CurrencyModule = WoWCultivation.Modules and WoWCultivation.Modules.CurrencyModule
    if CurrencyModule and CurrencyModule.GetSpiritStones then
        spiritCount = CurrencyModule:GetSpiritStones() or 0
    end
    self.frame.spiritText:SetText("|cFF4488FF" .. BreakUpLargeNumbers(spiritCount) .. "|r")

    local daoPoints = 0
    local SectModule = WoWCultivation.Modules and WoWCultivation.Modules.SectModule
    if SectModule and SectModule.GetDaoPoints then
        daoPoints = SectModule:GetDaoPoints() or 0
    else
        daoPoints = GetTotalAchievementPoints() or 0
    end
    self.frame.daoText:SetText("|cFFFF8800" .. BreakUpLargeNumbers(daoPoints) .. "|r")
end

function UI:StartUpdateLoop()
    C_Timer.NewTicker(2, function()
        self:UpdateData()
    end)
    self:UpdateData()
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
