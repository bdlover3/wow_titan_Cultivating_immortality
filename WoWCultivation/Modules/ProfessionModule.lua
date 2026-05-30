local Module = {}
Module.name = "ProfessionModule"
Module.enabled = false

Module.SKILL_LINE_NAMES = {
    ["锻造"] = true, ["制皮"] = true, ["炼金术"] = true,
    ["草药学"] = true, ["采矿"] = true, ["裁缝"] = true,
    ["附魔"] = true, ["铭文"] = true, ["急救"] = true,
    ["烹饪"] = true, ["钓鱼"] = true, ["剥皮"] = true,
    ["珠宝加工"] = true, ["工程学"] = true,
}

function Module:OnEnable()
    self.enabled = true
end

function Module:OnDisable()
    self.enabled = false
end

function Module:GetProfessionName(wowName)
    local pData = WoWCultivation.Data.Profession
    return pData.chatNames[wowName] or wowName
end

function Module:GetPlayerProfessions()
    local profs = {}
    -- 3.80.1 不支持 GetProfessions/GetProfessionInfo，统一用 GetSkillLineInfo
    for i = 1, GetNumSkillLines() do
        local skillName, isHeader, _, rank, _, _, maxRank, _, _, _, _, skillLine = GetSkillLineInfo(i)
        if not isHeader and skillName and self.SKILL_LINE_NAMES[skillName] then
            local xiuxianName = self:GetProfessionName(skillName)
            table.insert(profs, {
                wowName = skillName,
                xiuxianName = xiuxianName,
                skillLine = skillLine,
                rank = rank,
                maxRank = maxRank,
            })
        end
    end
    return profs
end

WoWCultivation.Modules.ProfessionModule = Module
