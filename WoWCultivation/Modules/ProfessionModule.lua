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
    if GetProfessions then
        local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
        local indices = { prof1, prof2, archaeology, fishing, cooking, firstAid }
        for _, idx in ipairs(indices) do
            if idx then
                local name, _, _, _, _, _, skillLine = GetProfessionInfo(idx)
                local xiuxianName = self:GetProfessionName(name)
                table.insert(profs, {
                    wowName = name,
                    xiuxianName = xiuxianName,
                    skillLine = skillLine,
                })
            end
        end
    else
        for i = 1, GetNumSkillLines() do
            local skillName, isHeader, _, _, _, _, _, _, _, _, _, _, _ = GetSkillLineInfo(i)
            if not isHeader and skillName and self.SKILL_LINE_NAMES[skillName] then
                local xiuxianName = self:GetProfessionName(skillName)
                table.insert(profs, {
                    wowName = skillName,
                    xiuxianName = xiuxianName,
                    skillLine = nil,
                })
            end
        end
    end
    return profs
end

WoWCultivation.Modules.ProfessionModule = Module
