-- ============================================================
-- SisterModel.lua - 小师妹 3D 模型显示
-- 目标版本: 泰坦时光服 3.80.1
-- ============================================================
local UI = {}
UI.name = "SisterModel"
WoWCultivation.UI.SisterModel = UI

UI.SAVED_VAR = "WoWCultivationSisterPos"
UI.DIALOG_DURATION = 5
UI.MODEL_WIDTH = 140
UI.MODEL_HEIGHT = 200
UI.MODEL_REFRESH_INTERVAL = 5

UI.BLOOD_ELF_DISPLAY_ID = 30865

UI.BLOOD_ELF_NPC_IDS = {
    18591, 18592, 18593, 18594, 18595, 18596,
    18653, 18654, 18655, 18656, 18657, 18658,
    18661, 18662, 18663, 18664, 18665, 18666,
    18887, 18888, 18889, 18890, 18891, 18892,
    18945, 18946,
    19031, 19032, 19033, 19034,
}

UI.BLOOD_ELF_DISPLAY_IDS = {
    20370, 20371, 20372, 20373, 20374, 20375, 20376, 20377,
    20378, 20379, 20380, 20381, 20382, 20383, 20384, 20385,
    15483, 15484, 15485, 15486, 15487, 15488, 15489, 15490,
    15491, 15492, 15493, 15494, 15495, 15496, 15497, 15498,
    15475, 15476, 15477, 15478, 15479, 15480, 15481, 15482,
    13737, 16117, 16084,
}

UI.ANIM = {
    IDLE = 0,
    TALK = 1,
    LAUGH = 22,
    DANCE = 10,
    WAVE = 43,
    CHEER = 4,
    RUDE = 35,
    KISS = 23,
    SHY = 37,
    CRY = 7,
    POINT = 28,
    SALUTE = 33,
    YES = 39,
    NO = 26,
    SIT = 5,
    SLEEP = 5,
    EAT = 14,
    EMOTE_TALK = 60,
    EMOTE_DANCE = 94,
    EMOTE_LAUGH = 65,
    EMOTE_WAVE = 66,
    EMOTE_SHY = 63,
    EMOTE_KISS = 58,
    EMOTE_CHEER = 71,
    WALK = 60,
    RUN = 61,
}

UI.TALK_ANIMS = { 1, 60, 43, 28 }
UI.IDLE_ANIMS = { 0, 10, 22, 43, 37, 58 }

UI.RADIAL_MENU = {
    { label = "对话", icon = "Interface\\Icons\\INV_Misc_Book_07", action = "talk" },
    { label = "跳舞", icon = "Interface\\Icons\\Spell_Nature_MoonGlow", action = "dance" },
    { label = "好感度", icon = "Interface\\Icons\\INV_ValentinesCard02", action = "favor" },
    { label = "修炼面板", icon = "Interface\\Icons\\Spell_Holy_DivineSpirit", action = "panel" },
    { label = "设置", icon = "Interface\\Icons\\INV_Misc_Wrench_01", action = "settings" },
}

SLASH_WOWCULTIVATIONSISTER1 = "/wcsi"
SLASH_WOWCULTIVATIONSISTER2 = "/wcsister"
SlashCmdList["WOWCULTIVATIONSISTER"] = function(msg)
    UI:HandleSlashCommand(msg)
end

local function SafeCall(func, label)
    local ok, err = pcall(func)
    if not ok then
        print("|cFFFF0000[修仙传错误]|r " .. (label or "") .. ": " .. tostring(err))
    end
    return ok
end

local function SafeTimer(delay, func)
    if C_Timer and C_Timer.After then
        local ok = pcall(function()
            C_Timer.After(delay, func)
        end)
        if ok then return true end
    end
    local f = CreateFrame("Frame")
    local elapsed = 0
    f:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        if elapsed >= delay then
            func()
            self:SetScript("OnUpdate", nil)
            self:Hide()
        end
    end)
    return true
end

local function SafeTicker(interval, func)
    if C_Timer and C_Timer.NewTicker then
        local ok, ticker = pcall(function()
            return C_Timer.NewTicker(interval, func)
        end)
        if ok then return ticker end
    end
    local f = CreateFrame("Frame")
    local elapsed = 0
    f:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        if elapsed >= interval then
            elapsed = 0
            func()
        end
    end)
    return f
end

local function ModelIsLoaded(mf)
    if not mf then return false end
    local ok, result = pcall(function()
        return mf:GetModelFileID()
    end)
    if ok and result then return true end
    ok, result = pcall(function()
        return mf:GetDisplayInfo()
    end)
    if ok and result and result > 0 then return true end
    return false
end

local function TrySetAnimation(mf, animId, variation)
    if not mf then return false end
    variation = variation or 0
    local ok = pcall(function()
        mf:SetAnimation(animId, variation)
    end)
    return ok
end

function UI:OnEnable()
    self.modelFacing = 0
    self.modelCamScale = 1.0

    SafeCall(function()
        self.frame = CreateFrame("Frame", "WoWCultivationSisterFrame", UIParent)
        local f = self.frame
        f:SetSize(UI.MODEL_WIDTH, UI.MODEL_HEIGHT + 60)
        f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 180)
        f:SetClampedToScreen(true)
        f:SetMovable(true)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function(self)
            self.dragStartX, self.dragStartY = GetCursorPosition()
            self:StartMoving()
        end)
        f:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            local endX, endY = GetCursorPosition()
            local startX = self.dragStartX or endX
            local startY = self.dragStartY or endY
            local dist = math.sqrt((endX - startX)^2 + (endY - startY)^2)
            if dist < 10 then
                UI:OnLeftClick()
            end
            UI:SavePosition()
        end)
        f:SetScript("OnMouseDown", function(self, button)
            if button == "RightButton" then
                UI:OnRightClick()
            end
        end)

        local nameText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        nameText:SetPoint("TOP", f, "TOP", 0, -5)
        nameText:SetText("|cFFFFD700小师妹|r")
        nameText:SetShadowColor(0, 0, 0, 0.8)
        nameText:SetShadowOffset(1, -1)
        f.nameText = nameText
    end, "创建主框架")

    SafeCall(function()
        self.modelFrame = CreateFrame("PlayerModel", "WoWCultivationSisterModel", self.frame)
        local mf = self.modelFrame
        mf:SetSize(UI.MODEL_WIDTH, UI.MODEL_HEIGHT)
        mf:SetPoint("CENTER", self.frame, "CENTER", 0, -10)
        mf:EnableMouse(false)

        mf:RegisterEvent("DISPLAY_SIZE_CHANGED")
        mf:RegisterEvent("UI_SCALE_CHANGED")
        mf:RegisterEvent("PLAYER_ENTERING_WORLD")
        mf:SetScript("OnEvent", function(self, event)
            if event == "DISPLAY_SIZE_CHANGED" or event == "UI_SCALE_CHANGED" then
                UI:RefreshModel()
            elseif event == "PLAYER_ENTERING_WORLD" then
                SafeTimer(1, function() UI:RefreshModel() end)
            end
        end)
    end, "创建模型框架")

    SafeCall(function() self:CreateControlButtons() end, "创建控制按钮")
    SafeCall(function() self:CreateRadialMenu() end, "创建扇形菜单")
    SafeCall(function() self:LoadModel() end, "加载模型")

    SafeCall(function()
        self.glowFrame = CreateFrame("Frame", nil, self.frame)
        local glow = self.glowFrame
        glow:SetSize(UI.MODEL_WIDTH + 40, UI.MODEL_HEIGHT + 40)
        glow:SetPoint("CENTER", self.frame, "CENTER", 0, -10)
        if self.modelFrame then
            glow:SetFrameLevel(self.modelFrame:GetFrameLevel() - 1)
        end

        local bottomGlow = glow:CreateTexture(nil, "BACKGROUND")
        bottomGlow:SetSize(100, 80)
        bottomGlow:SetPoint("BOTTOM", glow, "BOTTOM", 0, -30)
        bottomGlow:SetTexture("Interface\\Cooldown\\star4")
        bottomGlow:SetVertexColor(0.3, 0.6, 1, 0.3)
        bottomGlow:SetBlendMode("ADD")
        bottomGlow:SetScale(2.5)
    end, "创建光效")

    SafeCall(function()
        self.particles = {}
        for i = 1, 6 do
            local particle = self.frame:CreateTexture(nil, "OVERLAY")
            particle:SetSize(8, 8)
            particle:SetTexture("Interface\\Icons\\INV_Misc_Star_02")
            particle:SetVertexColor(1, 0.8, 0.2, 0.5)
            particle:SetBlendMode("ADD")
            particle:SetPoint("CENTER", self.frame, "CENTER",
                math.cos((i-1)*(math.pi*2/6)) * 50,
                math.sin((i-1)*(math.pi*2/6)) * 20 - 10
            )
            particle:Show()
            table.insert(self.particles, {
                tex = particle,
                angle = (i-1)*(math.pi*2/6),
                radius = 50,
                speed = 0.3 + math.random()*0.2
            })
        end
    end, "创建粒子")

    SafeCall(function()
        self.dialogBubble = CreateFrame("Frame", "WoWCultivationSisterDialog", UIParent, "BackdropTemplate")
        local db = self.dialogBubble
        db:SetSize(240, 60)
        db:SetPoint("BOTTOM", self.frame, "TOP", 0, 10)
        db:SetFrameStrata("DIALOG")
        db:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 5, right = 5, top = 5, bottom = 5 },
        })
        db:SetBackdropColor(0.15, 0.1, 0.2, 0.95)
        db:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        db:Hide()

        db.text = db:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        db.text:SetPoint("TOPLEFT", db, "TOPLEFT", 10, -8)
        db.text:SetPoint("BOTTOMRIGHT", db, "BOTTOMRIGHT", -10, 8)
        db.text:SetWordWrap(true)
        db.text:SetJustifyH("LEFT")
        db.text:SetJustifyV("TOP")
        db.text:SetTextColor(1, 0.9, 0.7)
    end, "创建对话气泡")

    SafeCall(function()
        self.cultivationFlash = CreateFrame("Frame", "WoWCultivationFlashFrame", UIParent, "BackdropTemplate")
        local flash = self.cultivationFlash
        flash:SetSize(300, 80)
        flash:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
        flash:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 5, right = 5, top = 5, bottom = 5 },
        })
        flash:SetBackdropColor(0.15, 0.05, 0.25, 0.95)
        flash:SetBackdropBorderColor(0.5, 0.2, 0.8, 1)
        flash:Hide()

        flash.title = flash:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        flash.title:SetPoint("TOP", flash, "TOP", 0, -8)
        flash.title:SetText("|cFF8855FF【修仙录】|r")

        flash.content = flash:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        flash.content:SetPoint("CENTER", flash, "CENTER", 0, -5)
        flash.content:SetWidth(280)
        flash.content:SetWordWrap(true)
        flash.content:SetTextColor(0.9, 0.7, 1)
    end, "创建修仙录闪显")

    SafeCall(function() self:LoadPosition() end, "加载位置")
    SafeCall(function() self:StartAnimation() end, "启动动画")
    SafeCall(function() self:StartModelWatchdog() end, "启动看门狗")
    SafeCall(function() self:StartIdleAnimation() end, "启动空闲动画")
    SafeCall(function() self:RegisterCultivationLog() end, "注册修仙录")

    print("|cFF00FF00[修仙传]|r 小师妹已降临 (输入 /wcsi 查看模型信息)")
end

function UI:CreateControlButtons()
    local btnSize = 24
    local btnSpacing = 6
    local totalWidth = btnSize * 4 + btnSpacing * 3

    local buttons = {
        { icon = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up", tip = "向左转", action = function() UI:RotateModel(-0.3) end },
        { icon = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up", tip = "向右转", action = function() UI:RotateModel(0.3) end },
        { icon = "Interface\\Buttons\\UI-PlusButton-Up", tip = "放大", action = function() UI:ZoomModel(-0.2) end },
        { icon = "Interface\\Buttons\\UI-MinusButton-Up", tip = "缩小", action = function() UI:ZoomModel(0.2) end },
    }

    self.controlButtons = {}
    for i, btnData in ipairs(buttons) do
        local btn = CreateFrame("Button", nil, self.frame)
        btn:SetSize(btnSize, btnSize)
        local x = -totalWidth / 2 + (i - 1) * (btnSize + btnSpacing) + btnSize / 2
        btn:SetPoint("BOTTOM", self.frame, "BOTTOM", x, 4)

        btn:SetNormalTexture(btnData.icon)
        btn:SetPushedTexture(btnData.icon)
        btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        local pushedTex = btn:GetPushedTexture()
        if pushedTex then
            pushedTex:SetAlpha(0.5)
        end

        btn:SetScript("OnClick", btnData.action)
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(btnData.tip, 1, 1, 1)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        table.insert(self.controlButtons, btn)
    end
end

function UI:RotateModel(delta)
    self.modelFacing = (self.modelFacing or 0) + delta
    local mf = self.modelFrame
    if not mf then return end
    pcall(function() mf:SetFacing(self.modelFacing) end)
end

function UI:ZoomModel(delta)
    self.modelCamScale = (self.modelCamScale or 1.0) + delta
    if self.modelCamScale < 0.3 then self.modelCamScale = 0.3 end
    if self.modelCamScale > 3.0 then self.modelCamScale = 3.0 end
    local mf = self.modelFrame
    if not mf then return end
    pcall(function() mf:SetCamDistanceScale(self.modelCamScale) end)
end

function UI:CreateRadialMenu()
    self.radialMenu = CreateFrame("Frame", "WoWCultivationRadialMenu", UIParent)
    local rm = self.radialMenu
    rm:SetSize(280, 280)
    rm:SetFrameStrata("DIALOG")
    rm:EnableMouse(true)
    rm:Hide()

    self.radialButtons = {}
    local numItems = #UI.RADIAL_MENU
    local radius = 90
    local startAngle = math.pi
    local endAngle = 0
    local angleStep = (startAngle - endAngle) / (numItems - 1)

    for i, item in ipairs(UI.RADIAL_MENU) do
        local angle = startAngle - (i - 1) * angleStep
        local btn = CreateFrame("Button", nil, rm, "BackdropTemplate")
        btn:SetSize(44, 44)

        local x = math.cos(angle) * radius
        local y = math.sin(angle) * radius
        btn:SetPoint("CENTER", rm, "CENTER", x, y)

        btn:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 8, edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        btn:SetBackdropColor(0.06, 0.03, 0.1, 0.85)
        btn:SetBackdropBorderColor(0.85, 0.65, 0.13, 0.9)

        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", btn, "TOPLEFT", 6, -6)
        icon:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -6, 6)
        pcall(function() icon:SetTexture(item.icon) end)

        btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

        local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("BOTTOM", btn, "TOP", 0, 4)
        label:SetText(item.label)

        btn:SetScript("OnClick", function()
            UI:ExecuteRadialAction(item.action)
            UI:HideRadialMenu()
        end)
        btn:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(1, 0.85, 0.3, 1)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(item.label, 1, 1, 1)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0.85, 0.65, 0.13, 0.9)
            GameTooltip:Hide()
        end)

        table.insert(self.radialButtons, btn)
    end

    rm:SetScript("OnHide", function() end)

    local closeBtn = CreateFrame("Button", nil, rm, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", rm, "TOPRIGHT", 0, 0)
    closeBtn:SetSize(20, 20)
end

function UI:ShowRadialMenu()
    local rm = self.radialMenu
    if not rm then return end

    local scale = UIParent:GetEffectiveScale()
    local x, y = GetCursorPosition()
    x = x / scale
    y = y / scale

    rm:ClearAllPoints()
    rm:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y + 60)
    rm:Show()
end

function UI:HideRadialMenu()
    if self.radialMenu then
        self.radialMenu:Hide()
    end
end

function UI:ExecuteRadialAction(action)
    if action == "talk" then
        local SisterModule = WoWCultivation.Modules and WoWCultivation.Modules.SisterModule
        if SisterModule and SisterModule.OnSisterClick then
            SisterModule:OnSisterClick()
        end
        self:PlayTalkAnimation()
    elseif action == "dance" then
        self:PlayDanceAnimation()
    elseif action == "favor" then
        if WoWCultivation.UI.FavorFrame then
            WoWCultivation.UI.FavorFrame:Toggle()
        end
    elseif action == "panel" then
        if WoWCultivation.UI.MainFrame then
            WoWCultivation.UI.MainFrame:Toggle()
        end
    elseif action == "settings" then
        if WoWCultivation.UI.OptionsFrame then
            WoWCultivation.UI.OptionsFrame:Toggle()
        end
    end
end

function UI:ShowFavorInfo()
    local FavorModule = WoWCultivation.Modules and WoWCultivation.Modules.FavorModule
    if FavorModule then
        self:ShowDialog(FavorModule:GetFavorInfoString())
    else
        self:ShowDialog("好感度系统未加载")
    end
end

function UI:OnLeftClick()
    local SisterModule = WoWCultivation.Modules and WoWCultivation.Modules.SisterModule
    if SisterModule and SisterModule.OnSisterClick then
        SisterModule:OnSisterClick()
    end
    self:PlayTalkAnimation()
end

function UI:OnRightClick()
    self:ShowRadialMenu()
end

function UI:PlayTalkAnimation()
    local mf = self.modelFrame
    if not mf then return end
    if self.isDancing then
        self.isDancing = false
    end
    local anim = UI.TALK_ANIMS[math.random(1, #UI.TALK_ANIMS)]
    TrySetAnimation(mf, anim, 0)
    self.isTalking = true
    SafeTimer(4, function()
        self.isTalking = false
        if not self.isDancing then
            UI:PlayIdleAnimation()
        end
    end)
end

function UI:PlayIdleAnimation()
    local mf = self.modelFrame
    if not mf then return end
    TrySetAnimation(mf, UI.ANIM.IDLE, 0)
end

function UI:PlayDanceAnimation()
    local mf = self.modelFrame
    if not mf then return end
    self.isDancing = true
    TrySetAnimation(mf, UI.ANIM.DANCE, 0)
    SafeTimer(10, function()
        self.isDancing = false
        UI:PlayIdleAnimation()
    end)
end

function UI:PlayLaughAnimation()
    local mf = self.modelFrame
    if not mf then return end
    TrySetAnimation(mf, UI.ANIM.LAUGH, 0)
    SafeTimer(3, function()
        if not self.isTalking and not self.isDancing then
            UI:PlayIdleAnimation()
        end
    end)
end

function UI:StartIdleAnimation()
    if self.idleAnimTimer then return end
    self.lastIdleAnim = GetTime()
    self.nextIdleDelay = 20 + math.random() * 40

    self.idleAnimTimer = SafeTicker(5, function()
        if not UI.frame or not UI.frame:IsShown() then return end
        if UI.isTalking or UI.isDancing then return end

        local now = GetTime()
        if now - UI.lastIdleAnim < UI.nextIdleDelay then return end

        UI.lastIdleAnim = now
        UI.nextIdleDelay = 20 + math.random() * 60

        local mf = UI.modelFrame
        if not mf then return end

        local roll = math.random()
        if roll < 0.25 then
            UI:PlayDanceAnimation()
        elseif roll < 0.45 then
            UI:PlayLaughAnimation()
        elseif roll < 0.60 then
            TrySetAnimation(mf, UI.ANIM.WAVE, 0)
            SafeTimer(3, function() if not UI.isTalking and not UI.isDancing then UI:PlayIdleAnimation() end end)
        elseif roll < 0.72 then
            TrySetAnimation(mf, UI.ANIM.SHY, 0)
            SafeTimer(3, function() if not UI.isTalking and not UI.isDancing then UI:PlayIdleAnimation() end end)
        elseif roll < 0.82 then
            TrySetAnimation(mf, UI.ANIM.KISS, 0)
            SafeTimer(3, function() if not UI.isTalking and not UI.isDancing then UI:PlayIdleAnimation() end end)
        elseif roll < 0.90 then
            TrySetAnimation(mf, UI.ANIM.CHEER, 0)
            SafeTimer(3, function() if not UI.isTalking and not UI.isDancing then UI:PlayIdleAnimation() end end)
        else
            TrySetAnimation(mf, UI.ANIM.IDLE, 0)
        end
    end)
end

function UI:LoadModel()
    local mf = self.modelFrame
    if not mf then
        print("|cFFFF0000[修仙传错误]|r 模型框架不存在")
        return
    end

    local modelLoaded = false

    if WoWCultivationCharDB and WoWCultivationCharDB.sisterDisplayId then
        local savedId = WoWCultivationCharDB.sisterDisplayId
        local ok = pcall(function()
            mf:ClearModel()
            mf:SetDisplayInfo(savedId)
        end)
        if ok and ModelIsLoaded(mf) then
            self:ApplyModelSettings()
            self.currentMethod = "SetDisplayInfo"
            self.currentParam = savedId
            modelLoaded = true
            print("|cFF00FF00[修仙传]|r 模型加载: 已保存的DisplayInfo(" .. savedId .. ")")
        end
    end

    if not modelLoaded then
        local ok = pcall(function()
            mf:ClearModel()
            mf:SetDisplayInfo(UI.BLOOD_ELF_DISPLAY_ID)
        end)
        if ok and ModelIsLoaded(mf) then
            self:ApplyModelSettings()
            self.currentMethod = "SetDisplayInfo"
            self.currentParam = UI.BLOOD_ELF_DISPLAY_ID
            modelLoaded = true
            print("|cFF00FF00[修仙传]|r 模型加载: SetDisplayInfo(" .. UI.BLOOD_ELF_DISPLAY_ID .. ")")
        end
    end

    if not modelLoaded then
        for _, npcId in ipairs(UI.BLOOD_ELF_NPC_IDS) do
            local ok = pcall(function()
                mf:ClearModel()
                mf:SetCreature(npcId)
            end)
            if ok and ModelIsLoaded(mf) then
                self:ApplyModelSettings()
                self.currentMethod = "SetCreature"
                self.currentParam = npcId
                modelLoaded = true
                local displayId = "未知"
                pcall(function() displayId = tostring(mf:GetDisplayInfo()) end)
                print("|cFF00FF00[修仙传]|r 模型加载: SetCreature(" .. npcId .. ") DisplayID=" .. displayId)
                break
            end
        end
    end

    if not modelLoaded then
        for _, displayId in ipairs(UI.BLOOD_ELF_DISPLAY_IDS) do
            local ok = pcall(function()
                mf:ClearModel()
                mf:SetDisplayInfo(displayId)
            end)
            if ok and ModelIsLoaded(mf) then
                self:ApplyModelSettings()
                self.currentMethod = "SetDisplayInfo"
                self.currentParam = displayId
                modelLoaded = true
                print("|cFF00FF00[修仙传]|r 模型加载: SetDisplayInfo(" .. displayId .. ")")
                break
            end
        end
    end

    if not modelLoaded then
        local ok = pcall(function()
            mf:ClearModel()
            mf:SetUnit("player")
        end)
        if ok then
            self:ApplyModelSettings()
            self.currentMethod = "SetUnit"
            self.currentParam = "player"
            modelLoaded = true
            print("|cFF00FF00[修仙传]|r 使用玩家模型（备选）")
        else
            print("|cFFFF0000[修仙传错误]|r 所有模型加载方式失败")
        end
    end

    if modelLoaded then
        TrySetAnimation(mf, UI.ANIM.IDLE, 0)
    end
end

function UI:ApplyModelSettings()
    local mf = self.modelFrame
    if not mf then return end
    pcall(function()
        mf:SetModelScale(1.0)
        mf:SetPosition(0, 0, 0)
        mf:SetCamera(0)
        mf:SetCamDistanceScale(self.modelCamScale or 1.0)
        mf:SetPortraitZoom(0)
        mf:SetScale(1.0)
        mf:SetAlpha(0.95)
        mf:SetFacing(self.modelFacing or 0)
        mf:SetRotation(0)
    end)
end

function UI:RefreshModel()
    local mf = self.modelFrame
    if not mf then return end

    if ModelIsLoaded(mf) then
        return
    end

    print("|cFFFFFF00[修仙传]|r 检测到模型消失，重新加载...")

    if self.currentMethod == "SetDisplayInfo" and self.currentParam then
        local ok = pcall(function() mf:SetDisplayInfo(self.currentParam) end)
        if ok and ModelIsLoaded(mf) then
            self:ApplyModelSettings()
            TrySetAnimation(mf, UI.ANIM.IDLE, 0)
            print("|cFF00FF00[修仙传]|r 模型恢复成功")
            return
        end
    elseif self.currentMethod == "SetCreature" and self.currentParam then
        local ok = pcall(function() mf:SetCreature(self.currentParam) end)
        if ok and ModelIsLoaded(mf) then
            self:ApplyModelSettings()
            TrySetAnimation(mf, UI.ANIM.IDLE, 0)
            print("|cFF00FF00[修仙传]|r 模型恢复成功")
            return
        end
    end

    self:LoadModel()
end

function UI:StartModelWatchdog()
    if self.watchdogTimer then return end
    self.watchdogTimer = SafeTicker(UI.MODEL_REFRESH_INTERVAL, function()
        if not UI.frame or not UI.frame:IsShown() then return end
        UI:RefreshModel()
    end)
end

function UI:HandleSlashCommand(msg)
    msg = msg and msg:lower() or ""

    if msg == "" or msg == "info" then
        local mf = self.modelFrame
        if mf then
            local fileId = "无"
            pcall(function() fileId = tostring(mf:GetModelFileID()) end)
            local displayId = "无"
            pcall(function() displayId = tostring(mf:GetDisplayInfo()) end)
            print("|cFF00FF00[修仙传]|r === 小师妹模型信息 ===")
            print("  加载方式: " .. tostring(self.currentMethod or "未知") .. "(" .. tostring(self.currentParam or "") .. ")")
            print("  ModelFileID: " .. fileId)
            print("  DisplayInfo: " .. displayId)
            print("  Facing: " .. tostring(self.modelFacing or 0))
            print("  CamScale: " .. tostring(self.modelCamScale or 1.0))
            print("  可见: " .. tostring(mf:IsVisible()))
            print("  Frame显示: " .. tostring(UI.frame and UI.frame:IsShown()))
        else
            print("|cFFFF0000[修仙传]|r 模型框架不存在！")
        end

    elseif msg:find("^creature ") then
        local npcId = tonumber(msg:match("creature (%d+)"))
        if npcId then
            self:TestCreature(npcId)
        else
            print("|cFF00FF00[修仙传]|r 用法: /wcsi creature <NPC_ID>")
        end

    elseif msg:find("^display ") then
        local displayId = tonumber(msg:match("display (%d+)"))
        if displayId then
            self:TestDisplayInfo(displayId)
        else
            print("|cFF00FF00[修仙传]|r 用法: /wcsi display <DISPLAY_ID>")
        end

    elseif msg:find("^anim ") then
        local animId = tonumber(msg:match("anim (%d+)"))
        if animId then
            local mf = self.modelFrame
            if mf then
                TrySetAnimation(mf, animId, 0)
                print("|cFF00FF00[修仙传]|r 播放动画: " .. animId)
            end
        else
            print("|cFF00FF00[修仙传]|r 用法: /wcsi anim <ANIM_ID>")
        end

    elseif msg:find("^unit") then
        self:TestUnit()

    elseif msg == "reload" then
        self:LoadModel()

    elseif msg == "resetmodel" then
        WoWCultivationCharDB = WoWCultivationCharDB or {}
        WoWCultivationCharDB.sisterDisplayId = nil
        self.modelFacing = 0
        self.modelCamScale = 1.0
        self:LoadModel()
        print("|cFF00FF00[修仙传]|r 已清除保存的模型ID，重新加载")

    elseif msg == "scan" then
        self:ScanDisplayIds()

    elseif msg == "debug" then
        self:DumpDebugInfo()

    elseif msg == "dance" then
        self:PlayDanceAnimation()

    elseif msg == "talk" then
        self:PlayTalkAnimation()

    elseif msg == "laugh" then
        self:PlayLaughAnimation()

    elseif msg == "help" then
        print("|cFF00FF00[修仙传]|r === 小师妹命令 ===")
        print("  /wcsi - 查看模型信息")
        print("  /wcsi creature <ID> - 测试NPC模型")
        print("  /wcsi display <ID> - 测试DisplayInfo")
        print("  /wcsi anim <ID> - 播放动画")
        print("  /wcsi unit - 使用玩家模型")
        print("  /wcsi reload - 重新加载模型")
        print("  /wcsi resetmodel - 清除保存的模型ID并重新加载")
        print("  /wcsi dance - 跳舞")
        print("  /wcsi talk - 说话动画")
        print("  /wcsi laugh - 笑")
        print("  /wcsi scan - 扫描可用DisplayID")
        print("  /wcsi debug - 调试信息")
    end
end

function UI:TestCreature(npcId)
    local mf = self.modelFrame
    if not mf then print("|cFFFF0000[修仙传]|r 模型框架不存在") return end

    local ok = pcall(function()
        mf:ClearModel()
        mf:SetCreature(npcId)
    end)

    if ok and ModelIsLoaded(mf) then
        self:ApplyModelSettings()
        TrySetAnimation(mf, UI.ANIM.IDLE, 0)
        self.currentMethod = "SetCreature"
        self.currentParam = npcId
        local displayId = "未知"
        pcall(function() displayId = tostring(mf:GetDisplayInfo()) end)
        WoWCultivationCharDB = WoWCultivationCharDB or {}
        local did = tonumber(displayId)
        if did and did > 0 then
            WoWCultivationCharDB.sisterDisplayId = did
        end
        print("|cFF00FF00[修仙传]|r SetCreature(" .. npcId .. ") 成功! DisplayID: " .. displayId)
    else
        print("|cFFFF0000[修仙传]|r SetCreature(" .. npcId .. ") 失败")
    end
end

function UI:TestDisplayInfo(displayId)
    local mf = self.modelFrame
    if not mf then print("|cFFFF0000[修仙传]|r 模型框架不存在") return end

    local ok = pcall(function()
        mf:ClearModel()
        mf:SetDisplayInfo(displayId)
    end)

    if ok and ModelIsLoaded(mf) then
        self:ApplyModelSettings()
        TrySetAnimation(mf, UI.ANIM.IDLE, 0)
        self.currentMethod = "SetDisplayInfo"
        self.currentParam = displayId
        WoWCultivationCharDB = WoWCultivationCharDB or {}
        WoWCultivationCharDB.sisterDisplayId = displayId
        print("|cFF00FF00[修仙传]|r SetDisplayInfo(" .. displayId .. ") 成功! 已保存到配置")
    else
        print("|cFFFF0000[修仙传]|r SetDisplayInfo(" .. displayId .. ") 失败")
    end
end

function UI:TestUnit()
    local mf = self.modelFrame
    if not mf then print("|cFFFF0000[修仙传]|r 模型框架不存在") return end

    local ok = pcall(function()
        mf:ClearModel()
        mf:SetUnit("player")
    end)

    if ok then
        self:ApplyModelSettings()
        TrySetAnimation(mf, UI.ANIM.IDLE, 0)
        self.currentMethod = "SetUnit"
        self.currentParam = "player"
        print("|cFF00FF00[修仙传]|r SetUnit(player) 成功!")
    else
        print("|cFFFF0000[修仙传]|r SetUnit(player) 失败")
    end
end

function UI:ScanDisplayIds()
    local mf = self.modelFrame
    if not mf then print("|cFFFF0000[修仙传]|r 模型框架不存在") return end

    print("|cFF00FF00[修仙传]|r 开始扫描血精灵女性DisplayID...")

    local foundIds = {}
    local testRanges = {
        {20300, 20400},
        {15400, 15500},
        {13700, 13800},
        {16000, 16200},
    }

    for _, range in ipairs(testRanges) do
        for id = range[1], range[2] do
            local ok = pcall(function()
                mf:SetDisplayInfo(id)
            end)
            if ok and ModelIsLoaded(mf) then
                local fileId = nil
                pcall(function() fileId = mf:GetModelFileID() end)
                if fileId then
                    table.insert(foundIds, { id = id, fileId = fileId })
                    print("|cFF00FF00[修仙传]|r DisplayID=" .. id .. " FileID=" .. tostring(fileId))
                end
            end
        end
    end

    if #foundIds == 0 then
        print("|cFFFFFF00[修仙传]|r 未找到血精灵女性DisplayID")
    else
        print("|cFF00FF00[修仙传]|r 扫描完成，共找到 " .. #foundIds .. " 个")
    end

    self:LoadModel()
end

function UI:DumpDebugInfo()
    print("|cFF00FF00[修仙传]|r === 调试信息 ===")
    print("  frame存在: " .. tostring(self.frame ~= nil))
    print("  modelFrame存在: " .. tostring(self.modelFrame ~= nil))
    print("  currentMethod: " .. tostring(self.currentMethod))
    print("  currentParam: " .. tostring(self.currentParam))
    print("  modelFacing: " .. tostring(self.modelFacing))
    print("  modelCamScale: " .. tostring(self.modelCamScale))
    print("  C_Timer存在: " .. tostring(C_Timer ~= nil))

    if self.modelFrame then
        local ok1, fileId = pcall(function() return self.modelFrame:GetModelFileID() end)
        print("  GetModelFileID: " .. tostring(fileId) .. " (ok=" .. tostring(ok1) .. ")")
        local ok2, displayId = pcall(function() return self.modelFrame:GetDisplayInfo() end)
        print("  GetDisplayInfo: " .. tostring(displayId) .. " (ok=" .. tostring(ok2) .. ")")
        local ok3, hasAnim = pcall(function() return self.modelFrame:HasAnimation(0) end)
        print("  HasAnimation(0/idle): " .. tostring(hasAnim) .. " (ok=" .. tostring(ok3) .. ")")
        local ok4, hasDance = pcall(function() return self.modelFrame:HasAnimation(10) end)
        print("  HasAnimation(10/dance): " .. tostring(hasDance) .. " (ok=" .. tostring(ok4) .. ")")
        local ok5, hasTalk = pcall(function() return self.modelFrame:HasAnimation(1) end)
        print("  HasAnimation(1/talk): " .. tostring(hasTalk) .. " (ok=" .. tostring(ok5) .. ")")
        local ok6, hasEmoteDance = pcall(function() return self.modelFrame:HasAnimation(94) end)
        print("  HasAnimation(94/emote_dance): " .. tostring(hasEmoteDance) .. " (ok=" .. tostring(ok6) .. ")")
    end

    local raceName = UnitRace("player")
    print("  玩家种族: " .. tostring(raceName))
    local _, classFile = UnitClass("player")
    print("  玩家职业: " .. tostring(classFile))
end

function UI:StartAnimation()
    if self.animationFrame then return end

    self.floatOffset = 0
    self.floatDirection = 1

    self.animationFrame = CreateFrame("Frame")
    self.animationFrame:SetScript("OnUpdate", function(self, elapsed)
        UI.floatOffset = UI.floatOffset + 0.015 * UI.floatDirection
        if UI.floatOffset >= 4 or UI.floatOffset <= -4 then
            UI.floatDirection = -UI.floatDirection
        end

        local time = GetTime()
        for _, particle in ipairs(UI.particles) do
            local angle = time * particle.speed + particle.angle
            local x = math.cos(angle) * particle.radius
            local y = math.sin(angle) * particle.radius * 0.4 + UI.floatOffset - 10
            particle.tex:SetPoint("CENTER", UI.frame, "CENTER", x, y)
            particle.tex:SetAlpha(0.3 + math.sin(time * 2 + particle.angle) * 0.3)
        end
    end)
end

function UI:RegisterCultivationLog()
    local EM = WoWCultivation.Core.EventManager
    if EM and EM.Register then
        EM:Register("CULTIVATION_LOG", function(logType, detail)
            UI:ShowCultivationFlash(logType, detail)
        end)
    end
end

function UI:ShowCultivationFlash(logType, detail)
    local flash = self.cultivationFlash
    if not flash then return end

    local typeNames = {
        CULTIVATION = "修为精进",
        TREASURE    = "获得灵宝",
        DUNGEON     = "探索秘境",
        PVP         = "斗法胜绩",
    }
    local typeName = typeNames[logType] or logType

    flash.content:SetText("|cFFAAFF" .. typeName .. "|r\n" .. detail)
    flash:Show()

    flash:SetAlpha(0)
    pcall(function()
        local ag = flash:CreateAnimationGroup()
        local anim = ag:CreateAnimation("Alpha")
        anim:SetFromAlpha(0)
        anim:SetToAlpha(1)
        anim:SetDuration(0.3)
        ag:Play()
    end)

    SafeTimer(2, function()
        if not flash:IsShown() then return end
        pcall(function()
            local fadeOut = flash:CreateAnimationGroup()
            local fadeOutAnim = fadeOut:CreateAnimation("Alpha")
            fadeOutAnim:SetFromAlpha(1)
            fadeOutAnim:SetToAlpha(0)
            fadeOutAnim:SetDuration(0.5)
            fadeOut:SetScript("OnFinished", function() flash:Hide() end)
            fadeOut:Play()
        end)
    end)
end

function UI:ShowDialog(text)
    local db = self.dialogBubble
    if not db then return end

    if self.dialogTimer then
        self.dialogTimer:Cancel()
        self.dialogTimer = nil
    end

    db.text:SetText(text)
    db:Show()

    self:PlayTalkAnimation()

    self.dialogTimer = C_Timer.NewTimer(UI.DIALOG_DURATION, function()
        if db then db:Hide() end
        UI:PlayIdleAnimation()
        UI.dialogTimer = nil
    end)
end

function UI:HideDialog()
    local db = self.dialogBubble
    if db then db:Hide() end
end

function UI:Toggle()
    if not self.frame then return end
    if self.frame:IsShown() then self:Hide() else self:Show() end
end

function UI:Show()
    if not self.frame then return end
    self.frame:Show()
    if self.glowFrame then self.glowFrame:Show() end
    for _, p in ipairs(self.particles) do p.tex:Show() end
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
    if self.glowFrame then self.glowFrame:Hide() end
    for _, p in ipairs(self.particles) do p.tex:Hide() end
    if self.dialogBubble then self.dialogBubble:Hide() end
    self:HideRadialMenu()
end

function UI:SavePosition()
    if not self.frame then return end
    local point, _, _, x, y = self.frame:GetPoint()
    if WoWCultivationCharDB then
        WoWCultivationCharDB.sisterPosition = { point = point, x = x, y = y }
    end
end

function UI:LoadPosition()
    if not self.frame then return end
    if WoWCultivationCharDB and WoWCultivationCharDB.sisterPosition then
        local pos = WoWCultivationCharDB.sisterPosition
        if pos.point then
            self.frame:ClearAllPoints()
            self.frame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
        end
    end
end

function UI:ResetPosition()
    if not self.frame then return end
    self.frame:ClearAllPoints()
    self.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 180)
    self:SavePosition()
end

WoWCultivation.UI.SisterModel = UI
