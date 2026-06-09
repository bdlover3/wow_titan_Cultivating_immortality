-- ============================================================
-- TestFrame.lua - 测试面板
-- 用途：测试小师妹模型动画动作
-- 输入动画ID → 播放对应动作 → +1 递增播放下一个
-- ============================================================
local UI = {}
UI.name = "TestFrame"
WoWCultivation.UI.TestFrame = UI

function UI:OnEnable()
    self.animId = 1  -- 默认动画ID

    local f = CreateFrame("Frame", "WoWCultivationTestFrame", UIParent, "BackdropTemplate")
    f:SetSize(280, 200)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 16, edgeSize = 20,
        insets = { left = 6, right = 6, top = 6, bottom = 6 }
    })
    f:SetBackdropColor(0.06, 0.03, 0.1, 0.97)
    f:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    self.frame = f

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function() UI:Hide() end)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", f, "TOP", 0, -12)
    title:SetText("|cFFFFD700◆ 模型动作测试 ◆|r")

    -- 当前动作ID标签
    self.animLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.animLabel:SetPoint("TOP", title, "BOTTOM", 0, -12)
    self.animLabel:SetText("|cFF1EFF00当前动作: 1|r")

    -- 输入框
    local inputBg = CreateFrame("Frame", nil, f, "BackdropTemplate")
    inputBg:SetSize(180, 32)
    inputBg:SetPoint("TOP", self.animLabel, "BOTTOM", 0, -14)
    inputBg:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    inputBg:SetBackdropColor(0.04, 0.02, 0.08, 0.9)
    inputBg:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)

    self.inputBox = CreateFrame("EditBox", nil, inputBg)
    self.inputBox:SetSize(158, 20)
    self.inputBox:SetPoint("CENTER", inputBg, "CENTER", 0, 0)
    self.inputBox:SetFontObject("GameFontHighlightSmall")
    self.inputBox:SetTextColor(1, 0.9, 0.7)
    self.inputBox:SetAutoFocus(false)
    self.inputBox:SetNumeric(true)
    self.inputBox:SetText("1")
    self.inputBox:SetScript("OnEnterPressed", function(self)
        local id = tonumber(self:GetText())
        if id then
            UI:PlayAnim(id)
        end
    end)

    -- 播放按钮
    local playBtn = CreateFrame("Button", nil, f, "BackdropTemplate")
    playBtn:SetSize(100, 34)
    playBtn:SetPoint("TOP", inputBg, "BOTTOM", 0, -12)
    playBtn:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    playBtn:SetBackdropColor(0.08, 0.04, 0.16, 0.9)
    playBtn:SetBackdropBorderColor(0.85, 0.65, 0.13, 0.8)

    local playLabel = playBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playLabel:SetPoint("CENTER", playBtn, "CENTER", 0, 0)
    playLabel:SetText("|cFF88FF88▶ 播放|r")

    playBtn:SetScript("OnClick", function()
        local id = tonumber(UI.inputBox:GetText())
        if id then
            UI:PlayAnim(id)
        end
    end)
    playBtn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, 0.85, 0.3, 1)
    end)
    playBtn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.85, 0.65, 0.13, 0.8)
    end)

    -- +1 按钮
    local plusBtn = CreateFrame("Button", nil, f, "BackdropTemplate")
    plusBtn:SetSize(100, 34)
    plusBtn:SetPoint("TOP", playBtn, "BOTTOM", 0, -8)
    plusBtn:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    plusBtn:SetBackdropColor(0.08, 0.04, 0.16, 0.9)
    plusBtn:SetBackdropBorderColor(0.85, 0.65, 0.13, 0.8)

    local plusLabel = plusBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    plusLabel:SetPoint("CENTER", plusBtn, "CENTER", 0, 0)
    plusLabel:SetText("|cFFFFD700+1 递增|r")

    plusBtn:SetScript("OnClick", function()
        UI.animId = UI.animId + 1
        UI.inputBox:SetText(tostring(UI.animId))
        UI:PlayAnim(UI.animId)
    end)
    plusBtn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, 0.85, 0.3, 1)
    end)
    plusBtn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.85, 0.65, 0.13, 0.8)
    end)

    f:Hide()
    print("|cFF44AAFF[修仙传]|r 模型动作测试面板已就绪 (输入 /wctest 打开)")
end

function UI:PlayAnim(animId)
    self.animId = animId
    self.inputBox:SetText(tostring(animId))
    self.animLabel:SetText(string.format("|cFF1EFF00当前动作: %d|r", animId))

    local sisterModel = WoWCultivation.UI and WoWCultivation.UI.SisterModel
    local mf = sisterModel and sisterModel.modelFrame

    if mf then
        local ok = pcall(function()
            mf:SetAnimation(animId, 0)
        end)
        if ok then
            self:ShowComplete("动作 " .. animId .. " 播放完成")
        else
            self:ShowComplete("动作 " .. animId .. " 播放失败（ID可能无效）")
        end
    else
        self:ShowComplete("小师妹模型未加载，无法播放动作")
    end
end

function UI:ShowComplete(msg)
    -- 在对话框气泡中显示简单完成提示
    local sisterModel = WoWCultivation.UI and WoWCultivation.UI.SisterModel
    if sisterModel and sisterModel.ShowDialog then
        sisterModel:ShowDialog("|cFF88FF88[测试]|r " .. msg, 2)
    else
        WoWCultivation:Print("|cFF44AAFF[测试]|r " .. msg)
    end
end

function UI:Show()
    if not self.frame then return end
    self.frame:Show()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
end

function UI:Toggle()
    if not self.frame then return end
    if self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

-- Slash command: /wctest
SLASH_WCTEST1 = "/wctest"
SlashCmdList["WCTEST"] = function()
    UI:Toggle()
end
