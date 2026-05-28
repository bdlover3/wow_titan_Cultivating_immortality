local UI = {}
UI.name = "SisterModel"
WoWCultivation.UI.SisterModel = UI

UI.SAVED_VAR = "WoWCultivationSisterPos"
UI.DIALOG_DURATION = 5

function UI:OnEnable()
    self.frame = CreateFrame("PlayerModel", "WoWCultivationSisterModel", UIParent)
    local f = self.frame
    f:SetSize(140, 200)
    f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -40, 120)
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
    f:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and not self.isDragging then
            if WoWCultivation.UI.MainFrame then
                WoWCultivation.UI.MainFrame:Toggle()
            end
        elseif button == "RightButton" then
            ToggleDropDownMenu(1, nil, UI.dropdown, "cursor", 0, 0)
        end
    end)
    f:SetDisplayInfo(137421)
    f:SetCamera(1)
    f:SetRotation(0.4)
    f:SetPosition(0, 0, 0)
    f:SetFacing(0.3)

    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetPoint("TOPLEFT", f, "TOPLEFT", -4, 4)
    bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 4, -4)
    bg:SetColorTexture(0.08, 0.04, 0.12, 0.6)

    local border = CreateFrame("Frame", nil, f, "BackdropTemplate")
    border:SetPoint("TOPLEFT", f, "TOPLEFT", -4, 4)
    border:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 4, -4)
    border:SetBackdrop({
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        edgeSize = 14,
    })
    border:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)

    local nameText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    nameText:SetPoint("TOP", f, "TOP", 0, 8)
    nameText:SetText("|cFFFFD700小师妹|r")
    f.nameText = nameText

    self.dialogBubble = CreateFrame("Frame", "WoWCultivationSisterDialog", UIParent, "BackdropTemplate")
    local db = self.dialogBubble
    db:SetSize(220, 60)
    db:SetPoint("BOTTOM", f, "TOP", 0, 10)
    db:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 6, right = 6, top = 6, bottom = 6 }
    })
    db:SetBackdropColor(0.08, 0.04, 0.12, 0.95)
    db:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    db:SetAlpha(0)
    db:Hide()

    db.text = db:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    db.text:SetPoint("CENTER", db, "CENTER", 0, 0)
    db.text:SetWidth(190)
    db.text:SetWordWrap(true)
    db.text:SetText("")

    self:CreateContextMenu()
    self:LoadPosition()
    f:Show()
end

function UI:CreateContextMenu()
    local menu = {
        { text = "|cFFFFD700小师妹|r", isTitle = true, notCheckable = true },
        { text = "设置", notCheckable = true, func = function()
            if WoWCultivation.UI.MainFrame then
                WoWCultivation.UI.MainFrame:Toggle()
            end
        end },
        { text = "隐藏", notCheckable = true, func = function()
            UI:Hide()
        end },
        { text = "重置位置", notCheckable = true, func = function()
            UI:ResetPosition()
        end },
    }
    self.dropdown = CreateFrame("Frame", "WoWCultivationSisterDropdown", UIParent, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(self.dropdown, function(self, level)
        for _, item in ipairs(menu) do
            local info = UIDropDownMenu_CreateInfo()
            for k, v in pairs(item) do
                info[k] = v
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
end

function UI:ShowDialog(text)
    local db = self.dialogBubble
    if not db then return end

    if db.dialogTimer then
        db.dialogTimer:Cancel()
    end

    db.text:SetText("|cFFFFD700" .. text .. "|r")
    db:Show()

    local ag = db:CreateAnimationGroup()
    local fadeIn = ag:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.3)
    fadeIn:SetOrder(1)

    local hold = ag:CreateAnimation("Alpha")
    hold:SetFromAlpha(1)
    hold:SetToAlpha(1)
    hold:SetDuration(self.DIALOG_DURATION - 0.6)
    hold:SetOrder(2)

    local fadeOut = ag:CreateAnimation("Alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetDuration(0.3)
    fadeOut:SetOrder(3)

    ag:SetScript("OnFinished", function()
        db:Hide()
    end)

    ag:Play()
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
    self.frame:Show()
    self.dialogBubble:Show()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
    self.dialogBubble:Hide()
end

function UI:ResetPosition()
    if not self.frame then return end
    self.frame:ClearAllPoints()
    self.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -40, 120)
    self:SavePosition()
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
