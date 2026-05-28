local UI = {}
UI.name = "DivineSenseFrame"
WoWCultivation.UI.DivineSenseFrame = UI

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationDivineSense", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(320, 300)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 18,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    f:SetBackdropColor(0.06, 0.03, 0.1, 0.96)
    f:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    local headerBg = CreateFrame("Frame", nil, f, "BackdropTemplate")
    headerBg:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -8)
    headerBg:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -8)
    headerBg:SetHeight(36)
    headerBg:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tileSize = 12,
        edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    headerBg:SetBackdropColor(0.1, 0.05, 0.15, 0.9)
    headerBg:SetBackdropBorderColor(0.7, 0.5, 0.1, 1)

    local title = f:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
    title:SetPoint("TOP", headerBg, "TOP", 0, -6)
    title:SetText("|cFFFFD700神识探查|r")

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function()
        UI:Hide()
    end)

    self.infoRows = {}
    local rowLabels = { "道友名", "境界", "门派", "灵根", "道行" }
    local rowIcons = { "|cFFFFD700☯|r", "|cFFAA44FF◆|r", "|cFF4488FF⚔|r", "|cFF44AAFF✿|r", "|cFFFF8800✦|r" }

    for i, label in ipairs(rowLabels) do
        local yOffset = -(40 + (i - 1) * 42)

        local rowBg = CreateFrame("Frame", nil, f, "BackdropTemplate")
        rowBg:SetPoint("TOPLEFT", f, "TOPLEFT", 14, yOffset)
        rowBg:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, yOffset)
        rowBg:SetHeight(34)
        rowBg:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8,
            edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        rowBg:SetBackdropColor(0.05, 0.02, 0.08, 0.85)
        rowBg:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.9)

        local iconText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        iconText:SetPoint("LEFT", rowBg, "LEFT", 8, 0)
        iconText:SetText(rowIcons[i])

        local labelText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        labelText:SetPoint("LEFT", iconText, "RIGHT", 4, 0)
        labelText:SetText("|cFFEEDDAA" .. label .. "|r")

        local valueText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        valueText:SetPoint("RIGHT", rowBg, "RIGHT", -8, 0)
        valueText:SetText("|cFFFFFFFF—|r")
        valueText:SetJustifyH("RIGHT")

        tinsert(self.infoRows, {
            label = labelText,
            value = valueText,
        })
    end

    local footerDeco = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    footerDeco:SetPoint("BOTTOM", f, "BOTTOM", 0, 8)
    footerDeco:SetText("|cFF666666◇ 神识流转 · 洞悉天机 ◇|r")

    f:Hide()
end

function UI:Show(data)
    if not self.frame then return end
    data = data or {}
    self.infoRows[1].value:SetText("|cFFFFFFFF" .. (data.name or "未知") .. "|r")
    self.infoRows[2].value:SetText("|cFFAA44FF" .. (data.realm or "凡人") .. "|r")
    self.infoRows[3].value:SetText("|cFF4488FF" .. (data.sect or "散修") .. "|r")
    self.infoRows[4].value:SetText("|cFF44AAFF" .. (data.spiritRoot or "未知灵根") .. "|r")
    self.infoRows[5].value:SetText("|cFFFF8800" .. (BreakUpLargeNumbers(data.daoPoints) or "0") .. "|r")
    self.frame:Show()

    local ag = self.frame:CreateAnimationGroup()
    local fadeIn = ag:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.25)
    ag:Play()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
end

function UI:IsShown()
    return self.frame and self.frame:IsShown()
end
