local UI = {}
UI.name = "MilestonePopup"
WoWCultivation.UI.MilestonePopup = UI

UI.DISPLAY_DURATION = 5

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationMilestonePopup", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(340, 180)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 20,
        insets = { left = 6, right = 6, top = 6, bottom = 6 }
    })
    f:SetBackdropColor(0.08, 0.04, 0.12, 0.95)
    f:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    f:SetAlpha(0)
    f:SetScale(0.3)
    f:Hide()

    local glow = f:CreateTexture(nil, "BACKGROUND")
    glow:SetPoint("TOPLEFT", f, "TOPLEFT", -20, 20)
    glow:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 20, -20)
    glow:SetColorTexture(0.85, 0.65, 0.13, 0.15)
    f.glow = glow

    local topDeco = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    topDeco:SetPoint("TOP", f, "TOP", 0, -12)
    topDeco:SetText("|cFFFFD700✦ ✦ ✦|r")
    f.topDeco = topDeco

    local title = f:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
    title:SetPoint("TOP", topDeco, "BOTTOM", 0, -8)
    title:SetWidth(290)
    title:SetWordWrap(true)
    title:SetText("")
    f.title = title

    local separator = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    separator:SetPoint("TOP", title, "BOTTOM", 0, -4)
    separator:SetText("|cFF666666—————|r")
    f.separator = separator

    local desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    desc:SetPoint("TOP", separator, "BOTTOM", 0, -4)
    desc:SetWidth(290)
    desc:SetWordWrap(true)
    desc:SetText("")
    f.desc = desc

    local bottomDeco = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    bottomDeco:SetPoint("BOTTOM", f, "BOTTOM", 0, 10)
    bottomDeco:SetText("|cFFFFD700✦ ✦ ✦|r")
    f.bottomDeco = bottomDeco

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function()
        UI:Hide()
    end)
end

function UI:Show(milestoneName, milestoneDesc)
    if not self.frame then return end
    local f = self.frame

    f.title:SetText("|cFFFFD700" .. milestoneName .. "|r")
    f.desc:SetText("|cFFEEDDAA" .. milestoneDesc .. "|r")
    f:SetAlpha(0)
    f:SetScale(0.3)
    f:Show()

    local scaleAg = f:CreateAnimationGroup()
    local scaleUp = scaleAg:CreateAnimation("Scale")
    scaleUp:SetOrigin("CENTER", 0, 0)
    scaleUp:SetFromScale(0.3)
    scaleUp:SetToScale(1.1)
    scaleUp:SetDuration(0.35)
    scaleUp:SetOrder(1)

    local scaleBounce = scaleAg:CreateAnimation("Scale")
    scaleBounce:SetOrigin("CENTER", 0, 0)
    scaleBounce:SetFromScale(1.1)
    scaleBounce:SetToScale(1.0)
    scaleBounce:SetDuration(0.15)
    scaleBounce:SetOrder(2)

    scaleAg:Play()

    local alphaAg = f:CreateAnimationGroup()
    local fadeIn = alphaAg:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.3)
    fadeIn:SetOrder(1)

    local hold = alphaAg:CreateAnimation("Alpha")
    hold:SetFromAlpha(1)
    hold:SetToAlpha(1)
    hold:SetDuration(self.DISPLAY_DURATION - 0.8)
    hold:SetOrder(2)

    local fadeOut = alphaAg:CreateAnimation("Alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetDuration(0.5)
    fadeOut:SetOrder(3)

    alphaAg:SetScript("OnFinished", function()
        f:Hide()
    end)

    alphaAg:Play()

    if WoWCultivation.UI.SisterModel then
        WoWCultivation.UI.SisterModel:ShowDialog("恭喜道友达成「" .. milestoneName .. "」！")
    end
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
end
