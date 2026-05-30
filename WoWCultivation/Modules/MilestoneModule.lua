local Module = {}
Module.name = "MilestoneModule"
Module.enabled = false

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("PLAYER_LEVEL_UP", function(level)
        self:CheckMilestones(level)
    end)
    EM:Register("PLAYER_ENTERING_WORLD", function()
        local level = UnitLevel("player")
        self:CheckMilestones(level)
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:CheckMilestones(level)
    if not level then return end
    local milestones = WoWCultivation.Data.Milestone.milestones
    for id, data in pairs(milestones) do
        if data.level == level then
            local key = self:MilestoneIdToDBKey(id)
            if key and not WoWCultivationCharDB.milestones[key] then
                self:Trigger(id)
            end
        end
    end
end

function Module:Trigger(milestoneId)
    local data = WoWCultivation.Data.Milestone.milestones[milestoneId]
    if not data then return end

    local key = self:MilestoneIdToDBKey(milestoneId)
    if not key then return end
    if WoWCultivationCharDB.milestones[key] then return end

    WoWCultivationCharDB.milestones[key] = true

    WoWCultivation:Print("【" .. data.name .. "】已解锁！")

    if WoWCultivation.UI.Toast then
        WoWCultivation.UI.Toast:Show("【" .. data.name .. "】" .. data.desc, 5)
    end

    if WoWCultivation.UI.MilestonePopup then
        WoWCultivation.UI.MilestonePopup:Show(data.name, data.desc)
    end

    if WoWCultivation.Modules.SisterModule then
        WoWCultivation.Modules.SisterModule:ShowDialog(data.dialogSequence)
    end

    if data.flashButton then
        self:FlashButton(data.flashButton)
    end
end

function Module:MilestoneIdToDBKey(milestoneId)
    local map = {
        TALENT_UNLOCK = "talent",
        RANDOM_DUNGEON = "randomDungeon",
        MOUNT = "mount",
        PVP = "pvp",
        SECT = "sect",
        FOUNDATION = "foundation",
        OUTLAND = "outland",
        GOLDEN_CORE = "goldenCore",
        NORTHREND = "northrend",
        NASCENT_SOUL = "nascentSoul",
        PEAK = "peak",
    }
    return map[milestoneId]
end

function Module:FlashButton(buttonName)
    local button = _G[buttonName]
    if not button then return end

    -- 3.80.1: 使用 AnimationGroup 实现闪烁
    local ag = button:CreateAnimationGroup()
    ag:SetLooping("REPEAT")

    local flashCount = 20  -- 10秒内闪烁20次
    for i = 1, flashCount do
        local fadeOut = ag:CreateAnimation("Alpha")
        fadeOut:SetFromAlpha(1)
        fadeOut:SetToAlpha(0.2)
        fadeOut:SetDuration(0.25)
        fadeOut:SetOrder((i - 1) * 2 + 1)

        local fadeIn = ag:CreateAnimation("Alpha")
        fadeIn:SetFromAlpha(0.2)
        fadeIn:SetToAlpha(1)
        fadeIn:SetDuration(0.25)
        fadeIn:SetOrder((i - 1) * 2 + 2)
    end

    ag:Play()

    -- 10秒后停止闪烁并恢复
    C_Timer.After(10, function()
        if ag and not ag:IsDone() then
            ag:Stop()
        end
        if button then
            button:SetAlpha(1)
        end
    end)
end

function Module:ResetAll()
    if WoWCultivationCharDB and WoWCultivationCharDB.milestones then
        for k, _ in pairs(WoWCultivationCharDB.milestones) do
            WoWCultivationCharDB.milestones[k] = false
        end
    end
end

WoWCultivation.Modules.MilestoneModule = Module
