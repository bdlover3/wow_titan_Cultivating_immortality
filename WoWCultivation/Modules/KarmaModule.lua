local Module = {}
Module.name = "KarmaModule"
Module.enabled = false

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("COMBAT_LOG_EVENT_UNFILTERED", function(timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, ...)
        self:OnCombatLog(timestamp, subEvent, sourceGUID, destGUID, destName)
    end)
    EM:Register("UNIT_SPELLCAST_SUCCEEDED", function(unit, spellName, rank, lineID, spellId)
        self:OnSpellCastSucceeded(unit, spellName, spellId)
    end)
    EM:Register("QUEST_COMPLETE", function()
        self:OnQuestComplete()
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:GetGoodKarma()
    local data = WoWCultivation.Core.DB:GetChar("karma")
    return data and data.good or 0
end

function Module:GetEvilKarma()
    local data = WoWCultivation.Core.DB:GetChar("karma")
    return data and data.evil or 0
end

function Module:AddGoodKarma(amount)
    local data = WoWCultivationCharDB.karma
    if data then
        data.good = data.good + amount
        WoWCultivation:Print("善因+" .. amount .. "，累计善因: " .. data.good)
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("善因+" .. amount, 2)
        end
    end
end

function Module:AddEvilKarma(amount)
    local data = WoWCultivationCharDB.karma
    if data then
        data.evil = data.evil + amount
        WoWCultivation:Print("杀业+" .. amount .. "，累计杀业: " .. data.evil)
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("杀业+" .. amount, 2)
        end
    end
end

function Module:GetKarmaBalance()
    return self:GetGoodKarma() - self:GetEvilKarma()
end

function Module:GetKarmaTitle()
    local balance = self:GetKarmaBalance()
    if balance >= 100 then
        return "|cFF00FF00功德无量|r"
    elseif balance >= 50 then
        return "|cFF00FF00积善成德|r"
    elseif balance >= 20 then
        return "|cFFADFF2F小有善缘|r"
    elseif balance >= 0 then
        return "|cFFFFFF00善恶参半|r"
    elseif balance >= -20 then
        return "|cFFFF8C00业障初生|r"
    elseif balance >= -50 then
        return "|cFFFF4500杀业缠身|r"
    else
        return "|cFFFF0000万劫不复|r"
    end
end

function Module:OnCombatLog(timestamp, subEvent, sourceGUID, destGUID, destName)
    if subEvent ~= "PARTY_KILL" then return end
    if sourceGUID ~= UnitGUID("player") then return end

    local _, _, _, _, _, destClass = GetPlayerInfoByGUID(destGUID)
    if destClass then
        self:AddEvilKarma(1)
        WoWCultivation:Print("击杀道友" .. (destName or "") .. "，杀业+1")
    end
end

function Module:OnSpellCastSucceeded(unit, spellName, spellId)
    if unit ~= "player" then return end
    if not self.healThrottle then
        self.healThrottle = 0
    end
    local now = GetTime()
    if now - self.healThrottle < 5 then return end

    local target = "target"
    if UnitExists(target) and UnitIsFriend("player", target) and not UnitIsUnit("player", target) then
        self.healThrottle = now
        self:AddGoodKarma(1)
    end
end

function Module:OnQuestComplete()
    self:AddGoodKarma(1)
    WoWCultivation:Print("完成委托，善因+1")
end

function Module:GetKarmaText()
    local good = self:GetGoodKarma()
    local evil = self:GetEvilKarma()
    local title = self:GetKarmaTitle()
    return "善因: |cFF00FF00" .. good .. "|r  杀业: |cFFFF0000" .. evil .. "|r  " .. title
end

WoWCultivation.Modules.KarmaModule = Module
