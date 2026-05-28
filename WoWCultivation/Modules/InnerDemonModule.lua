local Module = {}
Module.name = "InnerDemonModule"
Module.enabled = false

Module.CC_MAP = {
    [228918] = "心魔入侵",
    [5782]  = "心魔入侵",
    [2094]  = "心魔入侵",
    [6358]  = "心魔入侵",
    [2637]  = "情劫降临",
    [33786] = "情劫降临",
    [605]   = "情劫降临",
    [15487] = "封印灵力",
    [28271] = "封印灵力",
    [31935] = "封印灵力",
    [108194] = "封印灵力",
    [105421] = "神识震荡",
    [853]   = "神识震荡",
    [408]   = "神识震荡",
    [118]   = "化形之术",
    [28272] = "化形之术",
    [61305] = "化形之术",
    [61780] = "化形之术",
    [61721] = "化形之术",
}

Module.CC_TYPE_MAP = {
    ["心魔入侵"] = { add = 8, desc = "恐惧缠身，心魔趁虚而入！" },
    ["情劫降临"] = { add = 6, desc = "魅惑之术，情劫降临！" },
    ["封印灵力"] = { add = 5, desc = "灵力被封，心魔暗生！" },
    ["神识震荡"] = { add = 7, desc = "神识震荡，心魔侵蚀！" },
    ["化形之术"] = { add = 4, desc = "化形之术，心魔幻象！" },
}

Module.THRESHOLDS = {
    { min = 0,  max = 20,  name = "心境平和", color = "|cFF00FF00" },
    { min = 21, max = 50,  name = "心浮气躁", color = "|cFFFFFF00" },
    { min = 51, max = 80,  name = "心魔滋生", color = "|cFFFF8C00" },
    { min = 81, max = 100, name = "走火入魔", color = "|cFFFF0000" },
}

Module.DECAY_INTERVAL = 60
Module.DECAY_AMOUNT = 1

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("UNIT_AURA", function(unit)
        self:OnUnitAura(unit)
    end)
    EM:Register("PLAYER_DEAD", function()
        self:OnPlayerDead()
    end)
    EM:Register("PLAYER_ENTERING_WORLD", function()
        self:StartDecayTimer()
    end)
end

function Module:OnDisable()
    self.enabled = false
    if self.decayTimer then
        self.decayTimer:Cancel()
        self.decayTimer = nil
    end
end

function Module:GetValue()
    local data = WoWCultivation.Core.DB:GetChar("innerDemon")
    return data and data.value or 0
end

function Module:SetValue(val)
    val = max(0, min(100, val))
    local data = WoWCultivationCharDB.innerDemon
    if data then
        local oldState = self:GetStateName()
        data.value = val
        data.lastUpdate = time()
        local newState = self:GetStateName()
        if oldState ~= newState then
            self:OnStateChanged(oldState, newState)
        end
    end
end

function Module:AddValue(amount)
    local current = self:GetValue()
    self:SetValue(current + amount)
end

function Module:GetState()
    local val = self:GetValue()
    for _, threshold in ipairs(self.THRESHOLDS) do
        if val >= threshold.min and val <= threshold.max then
            return threshold
        end
    end
    return self.THRESHOLDS[1]
end

function Module:GetStateName()
    local state = self:GetState()
    return state.name
end

function Module:GetStateText()
    local state = self:GetState()
    local val = self:GetValue()
    return state.color .. state.name .. "|r (" .. val .. "/100)"
end

function Module:OnUnitAura(unit)
    if unit ~= "player" then return end
    if not self.lastAuraCheck then
        self.lastAuraCheck = 0
    end
    local now = GetTime()
    if now - self.lastAuraCheck < 1 then return end
    self.lastAuraCheck = now

    for i = 1, 40 do
        local _, _, _, _, _, _, _, _, _, spellId = UnitAura("player", i, "HARMFUL")
        if not spellId then break end
        local ccType = self.CC_MAP[spellId]
        if ccType then
            local ccInfo = self.CC_TYPE_MAP[ccType]
            if ccInfo and not self.lastCCSpell or self.lastCCSpell ~= spellId then
                self.lastCCSpell = spellId
                self:AddValue(ccInfo.add)
                WoWCultivation:Print(ccInfo.desc .. " 心魔值+" .. ccInfo.add)
                if WoWCultivation.UI.Toast then
                    WoWCultivation.UI.Toast:Show(ccInfo.desc, 3)
                end
            end
            return
        end
    end
    self.lastCCSpell = nil
end

function Module:OnPlayerDead()
    self:AddValue(5)
    WoWCultivation:Print("肉身陨落，心魔值+5")
    if WoWCultivation.UI.Toast then
        WoWCultivation.UI.Toast:Show("肉身陨落，心魔滋生！", 3)
    end
end

function Module:OnStateChanged(oldState, newState)
    WoWCultivation:Print("心境变化: " .. oldState .. " → " .. newState)
    if newState == "走火入魔" then
        if WoWCultivation.Modules.SisterModule then
            WoWCultivation.Modules.SisterModule:Say("师兄！你已走火入魔，速速静心调息！")
        end
    elseif newState == "心魔滋生" then
        if WoWCultivation.Modules.SisterModule then
            WoWCultivation.Modules.SisterModule:Say("师兄，心魔渐生，需多加小心...")
        end
    end
end

function Module:StartDecayTimer()
    if self.decayTimer then
        self.decayTimer:Cancel()
    end
    self.decayTimer = C_Timer.NewTicker(self.DECAY_INTERVAL, function()
        if self.enabled then
            local val = self:GetValue()
            if val > 0 then
                self:SetValue(val - self.DECAY_AMOUNT)
            end
        end
    end)
end

function Module:Meditate(duration)
    local decay = floor(duration / 5)
    if decay > 0 then
        self:AddValue(-decay)
        WoWCultivation:Print("静心调息" .. duration .. "秒，心魔值-" .. decay)
    end
end

WoWCultivation.Modules.InnerDemonModule = Module
