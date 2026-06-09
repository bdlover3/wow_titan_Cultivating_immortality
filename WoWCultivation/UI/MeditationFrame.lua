-- ============================================================
-- MeditationFrame.lua - 闭关修炼面板
-- 打坐/冥想计时器，加速心魔衰减，显示修炼状态
-- Titan Time Server 3.80.1 (Interface: 38001)
-- ============================================================
local UI = {}
UI.name = "MeditationFrame"
WoWCultivation.UI.MeditationFrame = UI

-- 打坐状态
UI.MEDITATION_SPEEDS = {
    { name = "静坐调息", speed = 1, desc = "最基础的打坐，缓慢恢复", icon = "Interface\\Icons\\Spell_Nature_Meditation" },
    { name = "凝神静气", speed = 2, desc = "集中意念，加速调息", icon = "Interface\\Icons\\Spell_Shadow_MindSteal" },
    { name = "气沉丹田", speed = 3, desc = "将灵气沉入丹田，大幅提升恢复速度", icon = "Interface\\Icons\\Spell_Nature_WispSplode" },
    { name = "天人合一", speed = 5, desc = "与天地灵气合一，极速恢复", icon = "Interface\\Icons\\Spell_Holy_InnerFire" },
}

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationMeditationFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(400, 400)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 16, edgeSize = 20,
        insets = { left = 6, right = 6, top = 6, bottom = 6 }
    })
    f:SetBackdropColor(0.06, 0.03, 0.1, 0.97)
    f:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    f:SetClampedToScreen(true)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function() UI:Hide() end)

    self.isMeditating = false
    self.meditateStartTime = 0
    self.meditateSpeed = 1
    self.totalDecay = 0

    self:CreateHeader(f)
    self:CreateStatusDisplay(f)
    self:CreateSpeedButtons(f)
    self:CreateStartButton(f)
    self:CreateLog(f)

    f:Hide()
end

function UI:CreateHeader(parent)
    local header = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10)
    header:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -10, -10)
    header:SetHeight(36)
    header:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tileSize = 12, edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    header:SetBackdropColor(0.1, 0.05, 0.15, 0.9)
    header:SetBackdropBorderColor(0.7, 0.5, 0.1, 1)

    local title = header:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
    title:SetPoint("CENTER", header, "CENTER", 0, 0)
    title:SetText("|cFF44FF44◆ 闭关修炼 ◆|r")
end

function UI:CreateStatusDisplay(parent)
    -- 中心修炼状态区域
    local statusFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    statusFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -56)
    statusFrame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -14, -56)
    statusFrame:SetHeight(100)
    statusFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    statusFrame:SetBackdropColor(0.03, 0.05, 0.02, 0.9)
    statusFrame:SetBackdropBorderColor(0.4, 0.7, 0.2, 0.8)

    -- 状态文字
    self.statusText = statusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.statusText:SetPoint("CENTER", statusFrame, "CENTER", 0, 20)
    self.statusText:SetText("|cFF44FF44未开始修炼|r")

    -- 计时器
    self.timerText = statusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    self.timerText:SetPoint("CENTER", statusFrame, "CENTER", 0, -12)
    self.timerText:SetText("|cFFAAAAAA--:--:--|r")

    -- 心魔/灵脉信息
    self.infoText = statusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    self.infoText:SetPoint("BOTTOM", statusFrame, "BOTTOM", 0, 6)
    self.infoText:SetText("|cFF888888准备就绪|r")
end

function UI:CreateSpeedButtons(parent)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -164)
    label:SetText("|cFFEEDDAA修炼方式：|r")

    self.speedButtons = {}
    local btnW = 85
    local btnH = 28
    local startX = 16
    local gap = 4

    for i, speed in ipairs(UI.MEDITATION_SPEEDS) do
        local xOff = startX + (i - 1) * (btnW + gap)
        local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -184)
        btn:SetSize(btnW, btnH)
        btn:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8, edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        btn:SetBackdropColor(0.06, 0.03, 0.1, 0.9)
        btn:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)
        btn.speedIndex = i

        local btnLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btnLabel:SetPoint("CENTER", btn, "CENTER", 0, 0)
        btnLabel:SetText("|cFF44FF44x" .. speed.speed .. "|r " .. speed.name)

        btn:SetScript("OnClick", function(self)
            UI:SelectSpeed(self.speedIndex)
        end)
        btn:SetScript("OnEnter", function(self)
            if UI.isMeditating then return end
            self:SetBackdropBorderColor(0.4, 0.7, 0.2, 1)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText("|cFF44FF44" .. speed.name .. "|r")
            GameTooltip:AddLine(speed.desc, 1, 1, 1)
            GameTooltip:AddLine("心魔衰减速度: x" .. speed.speed, 0.6, 1, 0.6)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function(self)
            if self.speedIndex ~= UI.meditateSpeed then
                self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)
            end
            GameTooltip:Hide()
        end)

        self.speedButtons[i] = btn
    end

    self:SelectSpeed(1)
end

function UI:CreateStartButton(parent)
    self.startBtn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    self.startBtn:SetPoint("TOP", parent, "TOP", 0, -230)
    self.startBtn:SetSize(160, 40)
    self.startBtn:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tileSize = 12, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    self.startBtn:SetBackdropColor(0.05, 0.2, 0.05, 0.9)
    self.startBtn:SetBackdropBorderColor(0.3, 0.7, 0.3, 1)

    self.startBtnLabel = self.startBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.startBtnLabel:SetPoint("CENTER", self.startBtn, "CENTER", 0, 0)
    self.startBtnLabel:SetText("|cFF44FF44▶ 开始闭关 ◀|r")

    self.startBtn:SetScript("OnClick", function()
        if UI.isMeditating then
            UI:StopMeditating()
        else
            UI:StartMeditating()
        end
    end)
    self.startBtn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.5, 1, 0.5, 1)
    end)
    self.startBtn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.3, 0.7, 0.3, 1)
    end)
end

function UI:CreateLog(parent)
    local logLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    logLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -280)
    logLabel:SetText("|cFFEEDDAA修炼记录：|r")

    self.logText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    self.logText:SetPoint("TOPLEFT", logLabel, "BOTTOMLEFT", 0, -2)
    self.logText:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, -280)
    self.logText:SetPoint("BOTTOM", parent, "BOTTOM", 0, 14)
    self.logText:SetJustifyH("LEFT")
    self.logText:SetJustifyV("TOP")
    self.logText:SetWordWrap(true)
    self.logText:SetText("|cFF666666暂无修炼记录\n点击「开始闭关」开始修炼|r")
end

function UI:SelectSpeed(index)
    if self.isMeditating then return end
    self.meditateSpeed = index

    for i, btn in ipairs(self.speedButtons) do
        if i == index then
            btn:SetBackdropColor(0.05, 0.2, 0.05, 0.9)
            btn:SetBackdropBorderColor(0.3, 0.7, 0.3, 1)
        else
            btn:SetBackdropColor(0.06, 0.03, 0.1, 0.9)
            btn:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)
        end
    end
end

function UI:StartMeditating()
    self.isMeditating = true
    self.meditateStartTime = GetTime()
    self.totalDecay = 0

    local speedInfo = UI.MEDITATION_SPEEDS[self.meditateSpeed] or UI.MEDITATION_SPEEDS[1]
    self.statusText:SetText("|cFF44FF44正在修炼：" .. speedInfo.name .. "|r")
    self.infoText:SetText("|cFF44FF44心魔衰减速度 x" .. speedInfo.speed .. "|r")

    self.startBtn:SetBackdropColor(0.2, 0.05, 0.05, 0.9)
    self.startBtn:SetBackdropBorderColor(0.7, 0.3, 0.3, 1)
    self.startBtnLabel:SetText("|cFFFF4444■ 停止修炼 ■|r")

    -- 禁用速度选择
    for _, btn in ipairs(self.speedButtons) do
        btn:SetEnabled(false)
        btn:SetAlpha(0.5)
    end

    -- 启动计时器
    self:StartTimer()

    -- Toast 提示
    if WoWCultivation.UI.Toast then
        WoWCultivation.UI.Toast:Show("闭关修炼开始 — " .. speedInfo.name, 2)
    end

    -- 小师妹
    if WoWCultivation.Modules.SisterModule then
        WoWCultivation.Modules.SisterModule:Say("师兄开始闭关了，灵儿为你护法~")
    end
end

function UI:StopMeditating()
    self.isMeditating = false
    self.meditateStartTime = 0

    self.statusText:SetText("|cFF44FF44修炼已停止|r")
    self.infoText:SetText("|cFF888888准备就绪|r")

    self.startBtn:SetBackdropColor(0.05, 0.2, 0.05, 0.9)
    self.startBtn:SetBackdropBorderColor(0.3, 0.7, 0.3, 1)
    self.startBtnLabel:SetText("|cFF44FF44▶ 开始闭关 ◀|r")

    for _, btn in ipairs(self.speedButtons) do
        btn:SetEnabled(true)
        btn:SetAlpha(1)
    end
    self:SelectSpeed(self.meditateSpeed)

    -- 停止计时器
    if self.meditateTimer then
        self.meditateTimer:Cancel()
        self.meditateTimer = nil
    end
end

function UI:StartTimer()
    if self.meditateTimer then
        self.meditateTimer:Cancel()
    end

    self.meditateTimer = C_Timer.NewTicker(1, function()
        if not self.isMeditating then
            if self.meditateTimer then
                self.meditateTimer:Cancel()
                self.meditateTimer = nil
            end
            return
        end

        local elapsed = GetTime() - self.meditateStartTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = math.floor(elapsed % 60)
        self.timerText:SetText(string.format("|cFF44FF44%02d:%02d:%02d|r", hours, minutes, seconds))

        -- 每5秒心魔衰减一次（加速版）
        local speedInfo = UI.MEDITATION_SPEEDS[self.meditateSpeed] or UI.MEDITATION_SPEEDS[1]
        if math.floor(elapsed) % 5 == 0 and elapsed > 0 then
            local lastTick = self.lastMeditateTick or 0
            if math.floor(elapsed) > math.floor(lastTick) then
                self.lastMeditateTick = elapsed
                local decay = speedInfo.speed
                self.totalDecay = self.totalDecay + decay

                -- 应用心魔衰减
                if WoWCultivation.Modules.InnerDemonModule then
                    WoWCultivation.Modules.InnerDemonModule:Meditate(5 * speedInfo.speed)
                end

                -- 更新日志
                self:UpdateLog()
            end
        end
    end)
end

function UI:UpdateLog()
    local elapsed = GetTime() - self.meditateStartTime
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = math.floor(elapsed % 60)
    local timeStr = string.format("%02d:%02d:%02d", hours, minutes, seconds)

    -- 心魔状态
    local demonText = ""
    if WoWCultivation.Modules.InnerDemonModule then
        demonText = " | " .. WoWCultivation.Modules.InnerDemonModule:GetStateText()
    end

    -- 灵脉信息
    local veinText = ""
    if WoWCultivation.Modules.SpiritVeinModule then
        local quality = WoWCultivation.Modules.SpiritVeinModule:GetVeinQuality()
        local multiplier = WoWCultivation.Modules.SpiritVeinModule:GetCultivationMultiplier()
        veinText = " | 灵脉品质: " .. quality .. "/5 (x" .. multiplier .. ")"
    end

    self.logText:SetText(
        "|cFF44FF44修炼中...|r\n"
        .. "时间: " .. timeStr .. "\n"
        .. "心魔衰减: |cFF44FF44-" .. self.totalDecay .. "|r" .. demonText .. "\n"
        .. veinText .. "\n"
        .. "修炼方式: |cFF44FF44" .. (UI.MEDITATION_SPEEDS[self.meditateSpeed] or UI.MEDITATION_SPEEDS[1]).name .. "|r"
    )

    self.infoText:SetText(
        "心魔衰减总计: |cFF44FF44-" .. self.totalDecay .. "|r"
        .. " | 速度: x" .. (UI.MEDITATION_SPEEDS[self.meditateSpeed] or UI.MEDITATION_SPEEDS[1]).speed
    )
end

function UI:Refresh()
    if not self.frame then return end

    -- 更新心魔显示
    if WoWCultivation.Modules.InnerDemonModule then
        local state = WoWCultivation.Modules.InnerDemonModule:GetStateText()
        if not self.isMeditating then
            self.infoText:SetText("|cFFEEDDAA心魔状态：|r" .. state)
        end
    end
end

function UI:Show()
    if not self.frame then return end
    self:Refresh()
    self.frame:SetAlpha(1)
    self.frame:Show()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
end

function UI:Toggle()
    if not self.frame then return end
    if self.frame:IsShown() and self.frame:GetAlpha() > 0.5 then
        self:Hide()
    else
        self:Show()
    end
end
