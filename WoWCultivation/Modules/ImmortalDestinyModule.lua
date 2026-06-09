-- ============================================================
-- ImmortalDestinyModule.lua - 仙缘值系统
-- 游戏里打怪、采集、做任务都会增加仙缘值
-- 仙缘值用于好感度送礼系统
-- ============================================================
local Module = {}
Module.name = "ImmortalDestinyModule"
Module.enabled = false

Module.SOURCE = {
    KILL       = { min = 1,  max = 3,  name = "击杀妖兽" },
    ELITE_KILL = { min = 5,  max = 12, name = "击杀精英妖兽" },
    QUEST      = { min = 8,  max = 20, name = "历练功成" },
    GATHER     = { min = 2,  max = 5,  name = "采集灵材" },
    LEVEL_UP   = { min = 15, max = 25, name = "境界突破" },
    DUNGEON    = { min = 10, max = 30, name = "秘境探索" },
    DIALOG     = { min = 1,  max = 1,  name = "与灵儿对话" },
}

Module.DIALOG_FORTUNE_CHANCE = 0.1  -- 对话有10%概率获得仙缘

function Module:OnEnable()
    self.enabled = true
    self:InitData()
    self:RegisterEvents()
    self.lastSkillLevels = {}
    self.lastSkillCheck = 0
    WoWCultivation:Print("仙缘值系统已激活")
end

function Module:OnDisable()
    self.enabled = false
end

function Module:InitData()
    local db = WoWCultivationCharDB
    if not db.immortalDestiny then
        db.immortalDestiny = 0
    end
end

function Module:RegisterEvents()
    local EM = WoWCultivation.Core.EventManager

    -- 击杀怪物检测
    EM:Register("COMBAT_LOG_EVENT_UNFILTERED", function(timestamp, subEvent, _, sourceGUID, _, _, _, destGUID, destName, destFlags)
        if subEvent ~= "PARTY_KILL" then return end
        if sourceGUID ~= UnitGUID("player") then return end

        if destFlags and type(destFlags) == "number" then
            local eliteMask = 0x10
            if bit.band(destFlags, eliteMask) ~= 0 then
                self:Add(math.random(self.SOURCE.ELITE_KILL.min, self.SOURCE.ELITE_KILL.max),
                    "ELITE_KILL", destName or "精英妖兽")
                return
            end
        end
        self:Add(math.random(self.SOURCE.KILL.min, self.SOURCE.KILL.max),
            "KILL", destName or "妖兽")
    end)

    -- 任务完成
    if QuestComplete then
        EM:Register("QUEST_COMPLETE", function()
            self:Add(math.random(self.SOURCE.QUEST.min, self.SOURCE.QUEST.max), "QUEST")
        end)
    else
        EM:Register("CHAT_MSG_SYSTEM", function(msg)
            if type(msg) ~= "string" then return end
            if string.find(msg, "任务完成") or string.find(msg, "Quest complete") then
                self:Add(math.random(self.SOURCE.QUEST.min, self.SOURCE.QUEST.max), "QUEST")
            end
        end)
    end

    -- 升级获取仙缘
    EM:Register("PLAYER_LEVEL_UP", function(level)
        self:Add(math.random(self.SOURCE.LEVEL_UP.min, self.SOURCE.LEVEL_UP.max), "LEVEL_UP")
    end)

    -- 进入副本获取仙缘
    EM:Register("ZONE_CHANGED", function()
        local inInstance, instanceType = IsInInstance()
        if inInstance and (instanceType == "party" or instanceType == "raid") then
            self:Add(math.random(self.SOURCE.DUNGEON.min, self.SOURCE.DUNGEON.max), "DUNGEON")
        end
    end)
    EM:Register("ZONE_CHANGED_INDOORS", function()
        local inInstance, instanceType = IsInInstance()
        if inInstance and (instanceType == "party" or instanceType == "raid") then
            self:Add(math.random(self.SOURCE.DUNGEON.min, self.SOURCE.DUNGEON.max), "DUNGEON")
        end
    end)

    -- 采集检测 - 技能等级变化
    self.lastSkillLevels = {}
    self:UpdateSkillSnapshot()
    EM:Register("SKILL_LINES_CHANGED", function()
        self:OnSkillChanged()
    end)
end

function Module:UpdateSkillSnapshot()
    self.lastSkillLevels = {}
    local gatherSkills = { [182] = true, [186] = true, [393] = true }
    for i = 1, GetNumSkillLines() do
        local skillName, isHeader, _, skillRank, _, _, _, _, _, _, _, skillID = GetSkillLineInfo(i)
        if not isHeader and skillID and gatherSkills[skillID] then
            self.lastSkillLevels[skillID] = skillRank
        end
    end
end

function Module:OnSkillChanged()
    local now = GetTime() or time()
    if now - self.lastSkillCheck < 2 then return end
    self.lastSkillCheck = now

    local gatherSkills = { [182] = true, [186] = true, [393] = true }
    for i = 1, GetNumSkillLines() do
        local skillName, isHeader, _, skillRank, _, _, _, _, _, _, _, skillID = GetSkillLineInfo(i)
        if not isHeader and skillID and gatherSkills[skillID] then
            local oldRank = self.lastSkillLevels[skillID] or 0
            if skillRank > oldRank then
                self:Add(math.random(self.SOURCE.GATHER.min, self.SOURCE.GATHER.max),
                    "GATHER", skillName or "灵材")
            end
        end
    end
    self:UpdateSkillSnapshot()
end

function Module:Add(amount, source, detail)
    if not amount or amount <= 0 then return end
    local db = WoWCultivationCharDB
    if not db then return end
    db.immortalDestiny = (db.immortalDestiny or 0) + amount

    if source ~= "KILL" then
        local sourceInfo = self.SOURCE[source]
        if sourceInfo and WoWCultivation.UI and WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show(
                "仙缘 +" .. amount .. "（" .. (sourceInfo.name or source) .. "）", 3)
        end
    end

    WoWCultivation.Core.EventManager:Trigger("IMMORTAL_DESTINY_CHANGED", db.immortalDestiny, amount, source)
end

-- 对话时随机获得仙缘（概率 ~1/10）
function Module:OnSisterDialog()
    if math.random() < Module.DIALOG_FORTUNE_CHANCE then
        self:Add(1, "DIALOG")
    end
end

function Module:GetValue()
    local db = WoWCultivationCharDB
    return db and db.immortalDestiny or 0
end

function Module:Spend(amount)
    local db = WoWCultivationCharDB
    if not db then return false end
    if (db.immortalDestiny or 0) < amount then return false end
    db.immortalDestiny = db.immortalDestiny - amount
    return true
end

WoWCultivation.Modules.ImmortalDestinyModule = Module
