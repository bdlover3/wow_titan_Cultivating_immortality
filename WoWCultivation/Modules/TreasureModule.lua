local Module = {}
Module.name = "TreasureModule"
Module.enabled = false

Module.qualityToRank = {
    [0] = "凡器", [1] = "法器", [2] = "灵器",
    [3] = "宝器", [4] = "灵宝", [5] = "仙器",
    [6] = "先天灵宝",
}

Module.slotNames = {
    [1] = "灵冠",
    [2] = "灵链",
    [3] = "灵肩",
    [15] = "灵氅",
    [5] = "灵甲",
    [9] = "灵镯",
    [10] = "灵手",
    [6] = "灵带",
    [7] = "灵裙",
    [8] = "灵靴",
    [11] = "灵戒",
    [12] = "灵戒",
    [13] = "灵符",
    [14] = "灵符",
    [16] = "本命灵宝",
    [17] = "护身灵宝",
    [18] = "暗器灵宝",
}

Module.attributeMap = {
    ["力量"] = "肉身之力",
    ["敏捷"] = "身法",
    ["耐力"] = "气血",
    ["智力"] = "神识",
    ["精神"] = "灵根资质",
    ["法术强度"] = "灵力",
    ["攻击强度"] = "罡气",
    ["暴击"] = "会心一击",
    ["急速"] = "遁速",
    ["命中"] = "灵识锁定",
}

function Module:OnEnable()
    self.enabled = true
    self:HookTooltip()
end

function Module:OnDisable()
    self.enabled = false
end

function Module:QualityToRank(quality)
    return self.qualityToRank[quality] or "未知品阶"
end

function Module:SlotToName(slotId)
    return self.slotNames[slotId] or "灵物"
end

function Module:HookTooltip()
    GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
        if not self.enabled then return end
        local name, link = tooltip:GetItem()
        if not link then return end
        local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
        local quality = select(3, GetItemInfo(link))
        if quality then
            local rankName = self:QualityToRank(quality)
            local _, _, _, colorHex = GetItemQualityColor(quality)
            tooltip:AddLine("灵宝等级: |c" .. colorHex .. rankName .. "|r")
        end
    end)
end

WoWCultivation.Modules.TreasureModule = Module
