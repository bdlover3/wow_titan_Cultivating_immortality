local Module = {}
Module.name = "SpiritBeastModule"
Module.enabled = false

Module.MOUNT_TYPE = {
    ground = "陆地灵兽",
    flying = "飞天灵兽",
    aquatic = "水行灵兽",
}

Module.PET_TYPE_NAMES = {
    [1]  = "灵兽·小鬼",
    [2]  = "灵兽·龙鹰",
    [3]  = "灵兽·陆行鸟",
    [4]  = "灵兽·夜刃豹",
    [5]  = "灵兽·蝙蝠",
    [6]  = "灵兽·食腐鸟",
    [7]  = "灵兽·蝎",
    [8]  = "灵兽·螃蟹",
    [9]  = "灵兽·猩猩",
    [10] = "灵兽·陆行鸟",
    [11] = "灵兽·猛禽",
    [12] = "灵兽·狼",
    [13] = "灵兽·猫科",
    [14] = "灵兽·爬行",
    [15] = "灵兽·虫",
    [16] = "灵兽·犀牛",
    [17] = "灵兽·魔暴龙",
    [18] = "灵兽·蠕虫",
    [19] = "灵兽·灵魂兽",
    [20] = "灵兽·石化蜥蜴",
    [21] = "灵兽·奇美拉",
    [22] = "灵兽·魔暴龙",
    [23] = "灵兽·熔岩犬",
    [24] = "灵兽·异种虫",
    [25] = "灵兽·水黾",
    [26] = "灵兽·羚羊",
    [27] = "灵兽·角鹰兽",
    [28] = "灵兽·蛾",
    [29] = "灵兽·蜥蜴",
    [30] = "灵兽·巨兽",
    [31] = "灵兽·土狼",
    [32] = "灵兽·野猪",
    [33] = "灵兽·乌龟",
    [34] = "灵兽·风蛇",
    [35] = "灵兽·掠食者",
    [36] = "灵兽·孢子蝠",
    [37] = "灵兽·虚空鳐",
    [38] = "灵兽·蛇",
    [39] = "灵兽·鳄鱼",
    [40] = "灵兽·龙龟",
    [41] = "灵兽·魁麟",
    [42] = "灵兽·水母",
    [43] = "灵兽·血兽",
    [44] = "灵兽·角蝇",
    [45] = "灵兽·畸体",
}

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    -- WotLK: 用 COMPANION_LEARNED/COMPANION_UNLEARNED 检测小宠物
    EM:Register("COMPANION_LEARNED", function()
        self:OnCompanionLearned()
    end)
    EM:Register("COMPANION_UNLEARNED", function()
        self:OnCompanionUnlearned()
    end)
    EM:Register("UNIT_PET", function(unit)
        self:OnUnitPet(unit)
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:GetPetSpiritName(petType)
    return self.PET_TYPE_NAMES[petType] or "灵兽伙伴"
end

function Module:GetHunterPetName()
    -- WotLK: GetPetInfo() 可能不可用，使用 UnitName("pet") 作为备选
    local petName = nil
    local petType = nil

    if GetPetInfo then
        petName, _, _, _, _, _, petType = GetPetInfo()
    end

    if not petName and UnitExists("pet") then
        petName = UnitName("pet")
    end

    local typeSuffix = petType and self.PET_TYPE_NAMES[petType] or "本命灵兽"
    return petName and (typeSuffix .. "·" .. petName) or "本命灵兽"
end

function Module:OnCompanionLearned()
    WoWCultivation:Print("新灵兽降临！")
    if WoWCultivation.UI.Toast then
        WoWCultivation.UI.Toast:Show("新灵兽降临！", 3)
    end
end

function Module:OnCompanionUnlearned()
    WoWCultivation:Print("灵兽离去...")
end

function Module:OnUnitPet(unit)
    if unit ~= "player" then return end
    if UnitExists("pet") then
        local petName = UnitName("pet")
        local _, englishClass = UnitClass("player")
        if englishClass == "HUNTER" then
            WoWCultivation:Print("本命灵兽·" .. (petName or "未知") .. "已召唤")
        else
            WoWCultivation:Print("灵兽伙伴·" .. (petName or "未知") .. "已召唤")
        end
    end
end

-- 3.80.1: 坐骑数量通过 C_MountJournal 或 GetNumCompanions 获取
function Module:GetMountCount()
    local count = 0
    if C_MountJournal then
        count = C_MountJournal.GetNumMounts() or 0
    elseif GetNumCompanions then
        count = GetNumCompanions("MOUNT") or 0
    end
    return count
end

function Module:GetMountSpiritName(index)
    if C_MountJournal then
        local mountIDs = C_MountJournal.GetMountIDs()
        if mountIDs and mountIDs[index] then
            local _, name = C_MountJournal.GetMountInfoByID(mountIDs[index])
            return name and ("灵兽坐骑·" .. name) or "灵兽坐骑"
        end
    elseif GetCompanionInfo then
        local _, mountName = GetCompanionInfo("MOUNT", index)
        return mountName and ("灵兽坐骑·" .. mountName) or "灵兽坐骑"
    end
    return "灵兽坐骑"
end

function Module:GetSpiritBeastText()
    local _, englishClass = UnitClass("player")
    if englishClass == "HUNTER" and UnitExists("pet") then
        return "本命灵兽: " .. (UnitName("pet") or "未知")
    end
    local mountCount = self:GetMountCount()
    return "灵兽坐骑: " .. mountCount .. "头"
end

WoWCultivation.Modules.SpiritBeastModule = Module
