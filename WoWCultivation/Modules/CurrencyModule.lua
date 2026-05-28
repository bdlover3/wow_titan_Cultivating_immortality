local Module = {}
Module.name = "CurrencyModule"
Module.enabled = false

function Module:OnEnable()
    self.enabled = true
end

function Module:OnDisable()
    self.enabled = false
end

function Module:GetSpiritStones()
    local money = GetMoney()
    if not money then return 0, 0, 0 end
    local spiritStones = floor(money / 10000)
    local spiritJade = floor((money % 10000) / 100)
    local spiritDust = money % 100
    return spiritStones, spiritJade, spiritDust
end

function Module:GetCurrencyText()
    local gold, silver, copper = self:GetSpiritStones()
    local parts = {}
    if gold > 0 then
        table.insert(parts, format("|cFFFFD700%d上品灵石|r", gold))
    end
    if silver > 0 then
        table.insert(parts, format("|cFFC0C0C0%d中品灵石|r", silver))
    end
    if copper > 0 or #parts == 0 then
        table.insert(parts, format("|cFFCD853F%d下品灵石|r", copper))
    end
    return table.concat(parts, " ")
end

function Module:GetCurrencyShortText()
    local gold, silver, copper = self:GetSpiritStones()
    if gold > 0 then
        return format("|cFFFFD700%d|r|cFFC0C0C0灵|r", gold)
    elseif silver > 0 then
        return format("|cFFC0C0C0%d|r|cFFC0C0C0灵|r", silver)
    else
        return format("|cFFCD853F%d|r|cFFCD853F灵尘|r", copper)
    end
end

WoWCultivation.Modules.CurrencyModule = Module
