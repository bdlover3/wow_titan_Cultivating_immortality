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
    if button then
        local flash = button:CreateAnimationGroup()
        local alpha1 = flash:CreateAnimation("Alpha")
        alpha1:SetFromAlpha(0.2)
        alpha1:SetToAlpha(1.0)
        alpha1:SetDuration(0.5)
        alpha1:SetOrder(1)
        local alpha2 = flash:CreateAnimation("Alpha")
        alpha2:SetFromAlpha(1.0)
        alpha2:SetToAlpha(0.2)
        alpha2:SetDuration(0.5)
        alpha2:SetOrder(2)
        flash:SetLooping("REPEAT")
        flash:Play()
        C_Timer.After(10, function()
            flash:Stop()
        end)
    end
end

function Module:ResetAll()
    if WoWCultivationCharDB and WoWCultivationCharDB.milestones then
        for k, _ in pairs(WoWCultivationCharDB.milestones) do
            WoWCultivationCharDB.milestones[k] = false
        end
    end
end

WoWCultivation.Modules.MilestoneModule = Module
