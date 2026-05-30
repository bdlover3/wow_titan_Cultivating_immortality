local UI = {}
UI.name = "FavorFrame"
WoWCultivation.UI.FavorFrame = UI

UI.FRAME_WIDTH = 380
UI.FRAME_HEIGHT = 520

function UI:OnEnable()
    self:CreateFrame()
end

function UI:CreateFrame()
    local f = CreateFrame("Frame", "WoWCultivationFavorFrame", UIParent, "BackdropTemplate")
    f:SetSize(UI.FRAME_WIDTH, UI.FRAME_HEIGHT)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    f:SetBackdropColor(0.05, 0.03, 0.1, 0.95)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetClampedToScreen(true)
    f:Hide()
    self.frame = f

    local titleBar = CreateFrame("Frame", nil, f, "BackdropTemplate")
    titleBar:SetHeight(30)
    titleBar:SetPoint("TOPLEFT", f, "TOPLEFT", 4, -4)
    titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    titleBar:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    titleBar:SetBackdropColor(0.15, 0.08, 0.25, 0.9)

    local titleText = titleBar:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    titleText:SetPoint("CENTER", titleBar, "CENTER", 0, 0)
    titleText:SetText("|cFFFFD700小师妹·好感度|r")

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)

    self:CreateFavorSection(f)
    self:CreatePreferenceSection(f)
    self:CreateGiftSection(f)
    self:CreateStatsSection(f)

    self.choiceFrame = self:CreateChoiceDialog()
end

function UI:CreateFavorSection(parent)
    local section = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    section:SetSize(UI.FRAME_WIDTH - 24, 80)
    section:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, -40)
    section:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    section:SetBackdropColor(0.1, 0.05, 0.15, 0.8)

    local favorTitle = section:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    favorTitle:SetPoint("TOPLEFT", section, "TOPLEFT", 10, -8)
    favorTitle:SetText("|cFFEEDDAA好感度|r")

    self.favorLevelText = section:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    self.favorLevelText:SetPoint("TOPLEFT", favorTitle, "BOTTOMLEFT", 0, -4)

    self.favorTitleText = section:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    self.favorTitleText:SetPoint("TOPLEFT", self.favorLevelText, "BOTTOMLEFT", 0, -2)

    self.favorBar = CreateFrame("StatusBar", nil, section)
    self.favorBar:SetSize(UI.FRAME_WIDTH - 50, 14)
    self.favorBar:SetPoint("BOTTOMLEFT", section, "BOTTOMLEFT", 10, 8)
    self.favorBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.favorBar:SetStatusBarColor(1, 0.4, 0.7, 0.9)
    self.favorBar:SetMinMaxValues(0, 100)
    self.favorBar:SetValue(0)

    local barBg = self.favorBar:CreateTexture(nil, "BACKGROUND")
    barBg:SetAllPoints(self.favorBar)
    barBg:SetColorTexture(0.1, 0.05, 0.1, 0.5)
end

function UI:CreatePreferenceSection(parent)
    local section = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    section:SetSize(UI.FRAME_WIDTH - 24, 90)
    section:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, -128)
    section:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    section:SetBackdropColor(0.1, 0.05, 0.15, 0.8)

    local prefTitle = section:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    prefTitle:SetPoint("TOPLEFT", section, "TOPLEFT", 10, -8)
    prefTitle:SetText("|cFFEEDDAA灵儿喜好|r |cFF888888（送对礼物好感度翻倍！）|r")

    self.prefText = section:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    self.prefText:SetPoint("TOPLEFT", prefTitle, "BOTTOMLEFT", 0, -4)
    self.prefText:SetPoint("RIGHT", section, "RIGHT", -10, 0)
    self.prefText:SetJustifyH("LEFT")
    self.prefText:SetWordWrap(true)
    self.prefText:SetHeight(60)
end

function UI:CreateGiftSection(parent)
    local section = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    section:SetSize(UI.FRAME_WIDTH - 24, 200)
    section:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, -226)
    section:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    section:SetBackdropColor(0.1, 0.05, 0.15, 0.8)

    local giftTitle = section:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    giftTitle:SetPoint("TOPLEFT", section, "TOPLEFT", 10, -8)
    giftTitle:SetText("|cFFEEDDAA赠送礼物|r |cFF888888（消耗仙缘值）|r")

    self.giftButtons = {}
    local FavorModule = WoWCultivation.Modules and WoWCultivation.Modules.FavorModule
    local gifts = FavorModule and FavorModule.GIFTS or {}

    local cols = 4
    local btnSize = 36
    local spacing = 8
    local startX = 10
    local startY = -30

    for i, gift in ipairs(gifts) do
        local row = math.floor((i - 1) / cols)
        local col = (i - 1) % cols
        local x = startX + col * (btnSize + spacing)
        local y = startY - row * (btnSize + spacing + 14)

        local btn = CreateFrame("Button", nil, section)
        btn:SetSize(btnSize, btnSize)
        btn:SetPoint("TOPLEFT", section, "TOPLEFT", x, y)

        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints(btn)
        icon:SetTexture(gift.icon)

        btn:SetNormalTexture(icon)
        btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        btn:SetPushedTexture(gift.icon)

        local nameText = section:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        nameText:SetPoint("TOP", btn, "BOTTOM", 0, -1)
        nameText:SetText(gift.name)

        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(gift.name, 1, 1, 1)
            GameTooltip:AddLine(gift.desc, 0.8, 0.8, 0.8, true)
            GameTooltip:AddLine("消耗仙缘: " .. gift.cost, 0.4, 0.8, 1)
            GameTooltip:AddLine("好感度: 未知（因人而异）", 0.5, 1, 0.5)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
        btn:SetScript("OnClick", function()
            if FavorModule then
                FavorModule:GiveGift(gift.id)
                UI:RefreshInfo()
            end
        end)

        table.insert(self.giftButtons, btn)
    end
end

function UI:CreateStatsSection(parent)
    local section = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    section:SetSize(UI.FRAME_WIDTH - 24, 70)
    section:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, -434)
    section:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    section:SetBackdropColor(0.1, 0.05, 0.15, 0.8)

    local statsTitle = section:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    statsTitle:SetPoint("TOPLEFT", section, "TOPLEFT", 10, -8)
    statsTitle:SetText("|cFFEEDDAA统计|r")

    self.statsText = section:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    self.statsText:SetPoint("TOPLEFT", statsTitle, "BOTTOMLEFT", 0, -4)
    self.statsText:SetPoint("RIGHT", section, "RIGHT", -10, 0)
    self.statsText:SetJustifyH("LEFT")
    self.statsText:SetWordWrap(true)
end

function UI:CreateChoiceDialog()
    local f = CreateFrame("Frame", "WoWCultivationChoiceDialog", UIParent, "BackdropTemplate")
    f:SetSize(340, 200)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    f:SetBackdropColor(0.08, 0.04, 0.15, 0.95)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetClampedToScreen(true)
    f:Hide()

    f.questionText = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    f.questionText:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -16)
    f.questionText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -16, -16)
    f.questionText:SetJustifyH("LEFT")
    f.questionText:SetWordWrap(true)

    f.optionButtons = {}
    f.currentDialogId = nil

    return f
end

function UI:ShowChoiceDialog(dialog)
    local cf = self.choiceFrame
    if not cf then return end

    cf.currentDialogId = dialog.id
    cf.questionText:SetText("|cFFFFD700灵儿：|r" .. dialog.text)

    for _, btn in ipairs(cf.optionButtons) do
        btn:Hide()
    end

    for i, option in ipairs(dialog.options) do
        local btn = cf.optionButtons[i]
        if not btn then
            btn = CreateFrame("Button", nil, cf, "BackdropTemplate")
            btn:SetSize(300, 28)
            btn:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tile = true, tileSize = 16, edgeSize = 8,
                insets = { left = 2, right = 2, top = 2, bottom = 2 },
            })
            btn:SetBackdropColor(0.12, 0.06, 0.2, 0.9)
            btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
            cf.optionButtons[i] = btn
        end

        btn:ClearAllPoints()
        btn:SetPoint("TOPLEFT", cf, "TOPLEFT", 20, -50 - (i - 1) * 34)
        btn:Show()

        -- 好感数值隐藏，不显示具体加减值，保持探索感
        local btnText = btn:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        btnText:SetAllPoints(btn)
        btnText:SetJustifyH("LEFT")
        btnText:SetPoint("LEFT", btn, "LEFT", 8, 0)
        btnText:SetText(option.text)

        local dialogId = dialog.id
        local optIdx = i
        btn:SetScript("OnClick", function()
            local FavorModule = WoWCultivation.Modules and WoWCultivation.Modules.FavorModule
            if FavorModule then
                FavorModule:SelectDialogChoice(dialogId, optIdx)
            end
            cf:Hide()
        end)
    end

    local totalHeight = 60 + #dialog.options * 34 + 10
    cf:SetHeight(totalHeight)
    cf:Show()
end

function UI:RefreshInfo()
    local FavorModule = WoWCultivation.Modules and WoWCultivation.Modules.FavorModule
    if not FavorModule then return end

    local favor = FavorModule:GetFavor()
    local level = FavorModule:GetFavorLevel()
    local nextLvl = FavorModule:GetNextLevelInfo()
    local title = FavorModule:GetTitle()

    if self.favorLevelText then
        self.favorLevelText:SetText(level.color .. level.name .. "|r")
    end
    if self.favorTitleText then
        self.favorTitleText:SetText("称呼: |cFFFFD700" .. title .. "|r")
    end

    if self.favorBar and nextLvl then
        local currentLevelMin = level.min
        local nextLevelMin = nextLvl.min
        local range = nextLevelMin - currentLevelMin
        local progress = favor - currentLevelMin
        self.favorBar:SetMinMaxValues(0, range)
        self.favorBar:SetValue(progress)
    elseif self.favorBar then
        self.favorBar:SetMinMaxValues(0, 1)
        self.favorBar:SetValue(1)
    end

    if self.prefText then
        self.prefText:SetText(FavorModule:GetPreferenceText())
    end

    if self.statsText then
        local stats = FavorModule:GetGiftStats()
        self.statsText:SetText(
            "赠送礼物次数: " .. stats.count
        )
    end
end

function UI:Toggle()
    if not self.frame then return end
    if self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

function UI:Show()
    if not self.frame then return end
    self:RefreshInfo()
    self.frame:Show()
end

function UI:Hide()
    if self.frame then
        self.frame:Hide()
    end
    if self.choiceFrame then
        self.choiceFrame:Hide()
    end
end

WoWCultivation.UI.FavorFrame = UI
