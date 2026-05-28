local Module = {}
Module.name = "DaoTitleModule"
Module.enabled = false

Module.PVP_TITLES = {
    [1]  = "斗法初徒",
    [2]  = "斗法弟子",
    [3]  = "斗法修士",
    [4]  = "斗法真人",
    [5]  = "斗法长老",
    [6]  = "斗法宗师",
    [7]  = "斗法大能",
    [8]  = "斗法天尊",
    [9]  = "斗法道君",
    [10] = "斗法仙帝",
    [11] = "斗法至尊",
    [12] = "斗法天帝",
    [13] = "斗法圣皇",
    [14] = "斗法神尊",
}

Module.DUNGEON_TITLES = {
    ["探索者"]   = "秘境初探者",
    ["征服者"]   = "秘境征服者",
    ["地城勇士"] = "秘境勇者",
    ["地城大师"] = "秘境大师",
    ["团队副本"] = "秘境宗师",
    ["英雄"]     = "秘境英杰",
    ["史诗"]     = "秘境天尊",
    ["挑战者"]   = "秘境挑战者",
    ["灭绝者"]   = "秘境灭绝者",
    ["疯子"]     = "秘境狂人",
    ["千钧一发"] = "秘境惊险",
    ["地下城"]   = "秘境行者",
    ["团队"]     = "秘境统领",
}

Module.CLASS_TITLES = {
    WARRIOR  = "战道尊者",
    PALADIN  = "圣道真人",
    HUNTER   = "御兽天师",
    ROGUE    = "暗影刺客",
    PRIEST   = "灵修圣者",
    SHAMAN   = "萨满巫尊",
    MAGE     = "玄法天师",
    WARLOCK  = "邪修魔尊",
    MONK     = "武道宗师",
    DRUID    = "自然道者",
    DEMONHUNTER = "猎魔天尊",
    DEATHKNIGHT = "冥道鬼尊",
    EVOKER   = "唤灵道者",
}

function Module:OnEnable()
    self.enabled = true
    self:HookTitleDisplay()
end

function Module:OnDisable()
    self.enabled = false
end

function Module:GetPvPDaoTitle(pvpRank)
    return self.PVP_TITLES[pvpRank] or "无名散修"
end

function Module:GetDungeonDaoTitle(wowTitle)
    if not wowTitle then return nil end
    for pattern, daoTitle in pairs(self.DUNGEON_TITLES) do
        if wowTitle:find(pattern) then
            return daoTitle
        end
    end
    return nil
end

function Module:GetClassDaoTitle(englishClass)
    return self.CLASS_TITLES[englishClass] or "散修"
end

function Module:GetCurrentDaoTitle()
    local currentTitle = GetCurrentTitleName and GetCurrentTitleName()
    if currentTitle and currentTitle ~= "" then
        local dungeonTitle = self:GetDungeonDaoTitle(currentTitle)
        if dungeonTitle then return dungeonTitle end
    end

    local pvpRank = UnitPVPRank("player")
    if pvpRank and pvpRank > 0 then
        return self:GetPvPDaoTitle(pvpRank)
    end

    local _, englishClass = UnitClass("player")
    return self:GetClassDaoTitle(englishClass)
end

function Module:HookTitleDisplay()
    hooksecurefunc("UnitPVPName", function(unit)
        if not self.enabled then return end
        if unit ~= "player" then return end
    end)
end

function Module:GetTitleText()
    local daoTitle = self:GetCurrentDaoTitle()
    local _, englishClass = UnitClass("player")
    local classTitle = self:GetClassDaoTitle(englishClass)
    return "道号: |cFFFFD700" .. daoTitle .. "|r  门派: " .. classTitle
end

function Module:GetAllDaoTitles()
    local titles = {}
    local pvpRank = UnitPVPRank("player")
    if pvpRank and pvpRank > 0 then
        table.insert(titles, {
            type = "斗法道号",
            name = self:GetPvPDaoTitle(pvpRank),
        })
    end
    local currentTitle = GetCurrentTitleName and GetCurrentTitleName()
    if currentTitle and currentTitle ~= "" then
        local dungeonTitle = self:GetDungeonDaoTitle(currentTitle)
        if dungeonTitle then
            table.insert(titles, {
                type = "秘境道号",
                name = dungeonTitle,
            })
        end
    end
    local _, englishClass = UnitClass("player")
    table.insert(titles, {
        type = "门派道号",
        name = self:GetClassDaoTitle(englishClass),
    })
    return titles
end

WoWCultivation.Modules.DaoTitleModule = Module
