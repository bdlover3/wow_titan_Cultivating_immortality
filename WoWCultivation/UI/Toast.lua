local UI = {}
UI.name = "Toast"
WoWCultivation.UI.Toast = UI

UI.MAX_TOASTS = 3
UI.toasts = {}
UI.queue = {}

function UI:OnEnable()
    self.anchor = CreateFrame("Frame", "WoWCultivationToastAnchor", UIParent)
    self.anchor:SetPoint("TOP", UIParent, "TOP", 0, -180)
    self.anchor:SetSize(1, 1)
end

function UI:Show(text, duration)
    duration = duration or 3
    if #self.toasts >= self.MAX_TOASTS then
        tinsert(self.queue, { text = text, duration = duration })
        return
    end
    self:CreateToast(text, duration)
end

function UI:CreateToast(text, duration)
    local index = #self.toasts + 1
    local toast = CreateFrame("Frame", "WoWCultivationToast" .. index, UIParent, "BackdropTemplate")
    toast:SetSize(320, 40)
    toast:SetPoint("TOP", self.anchor, "TOP", 0, -(index - 1) * 50)
    toast:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    toast:SetBackdropColor(0.1, 0.05, 0.15, 0.9)
    toast:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    toast:SetAlpha(0)

    local fontString = toast:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    fontString:SetPoint("CENTER", toast, "CENTER", 0, 0)
    fontString:SetText("|cFFFFD700" .. text .. "|r")
    fontString:SetWidth(290)
    fontString:SetWordWrap(true)
    toast.text = fontString

    local ag = toast:CreateAnimationGroup()
    ag:SetLooping("NONE")

    local fadeIn = ag:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.3)
    fadeIn:SetOrder(1)

    local hold = ag:CreateAnimation("Alpha")
    hold:SetFromAlpha(1)
    hold:SetToAlpha(1)
    hold:SetDuration(duration - 0.6)
    hold:SetOrder(2)

    local fadeOut = ag:CreateAnimation("Alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetDuration(0.3)
    fadeOut:SetOrder(3)

    ag:SetScript("OnFinished", function()
        toast:Hide()
        self:RemoveToast(toast)
    end)

    toast.animGroup = ag
    toast:Show()
    ag:Play()

    tinsert(self.toasts, toast)
end

function UI:RemoveToast(toast)
    for i, t in ipairs(self.toasts) do
        if t == toast then
            tremove(self.toasts, i)
            break
        end
    end
    for i, t in ipairs(self.toasts) do
        t:ClearAllPoints()
        t:SetPoint("TOP", self.anchor, "TOP", 0, -(i - 1) * 50)
    end
    if #self.queue > 0 then
        local next = tremove(self.queue, 1)
        self:CreateToast(next.text, next.duration)
    end
end
