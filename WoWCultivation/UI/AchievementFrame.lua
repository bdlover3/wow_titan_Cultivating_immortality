-- ============================================================
-- AchievementFrame.lua - 道果录面板
-- 展示玩家成就，修仙化分类和称号
-- Titan Time Server 3.80.1 (Interface: 38001)
-- ============================================================
local UI = {}
UI.name = "AchievementFrame"
WoWCultivation.UI.AchievementFrame = UI

-- 成就分类修仙化
UI.CATEGORY_MAP = {
    ["综合"]    = { name = "修行道果", icon = "Interface\\Icons\\Spell_Holy_BlessingOfStrength", desc = "修仙之路的里程碑" },
    ["任务"]    = { name = "历练道果", icon = "Interface\\Icons\\INV_Misc_Book_11", desc = "历练中积累的感悟" },
    ["探索"]    = { name = "游历道果", icon = "Interface\\Icons\\INV_Misc_Map_01", desc = "探索修仙界的足迹" },
    ["PvP"]     = { name = "斗法道果", icon = "Interface\\Icons\\Ability_Warrior_OffensiveStance", desc = "斗法中领悟的真谛" },
    ["副本/团队"] = { name = "秘境道果", icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Blue", desc = "秘境探索的收获" },
    ["专业"]    = { name = "百艺道果", icon = "Interface\\Icons\\INV_Hammer_20", desc = "百艺修炼的成果" },
    ["声望"]    = { name = "人缘道果", icon = "Interface\\Icons\\Spell_Holy_ChampionsBond", desc = "结交四方道友" },
    ["世界事件"] = { name = "天时道果", icon = "Interface\\Icons\\Spell_Nature_WispSplode", desc = "顺应天时的机缘" },
    ["地下城和团队"] = { name = "秘境道果", icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Blue", desc = "秘境探索的收获" },
    ["玩家对玩家"] = { name = "斗法道果", icon = "Interface\\Icons\\Ability_Warrior_OffensiveStance", desc = "斗法中领悟的真谛" },
}

-- 道果里程碑 — 对应成就ID，修仙化描述
UI.ACHIEVEMENT_MILESTONES = {
    [6]   = { name = "初入仙途", desc = "达到10级，灵根觉醒" },
    [7]   = { name = "小有成就", desc = "达到20级，筑基入门" },
    [8]   = { name = "道心初成", desc = "达到30级，道心稳固" },
    [9]   = { name = "金丹大道", desc = "达到40级，金丹初成" },
    [10]  = { name = "金丹圆满", desc = "达到50级，金丹大成" },
    [11]  = { name = "元婴初显", desc = "达到60级，元婴初凝" },
    [12]  = { name = "元婴大成", desc = "达到70级，元婴大成" },
    [13]  = { name = "渡劫飞升", desc = "达到80级，天劫已渡" },
    [545] = { name = "秘境初探", desc = "首次进入随机秘境" },
    [546] = { name = "秘境老手", desc = "完成50次秘境探索" },
    [547] = { name = "秘境宗师", desc = "完成500次秘境探索" },
    [621] = { name = "初涉斗法", desc = "首次在战场中取胜" },
    [622] = { name = "斗法高手", desc = "赢得100场斗法" },
    [623] = { name = "斗法至尊", desc = "赢得1000场斗法" },
    [889] = { name = "灵兽认主", desc = "首次学习骑术" },
    [890] = { name = "御兽有术", desc = "获得50只灵兽" },
    [891] = { name = "御兽宗师", desc = "获得100只灵兽" },
}

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationAchievementFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(520, 540)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 16, edgeSize = 20,
        insets = { left = 6, right = 6, top = 6, bottom = 6 }
    })
    f:SetBackdropColor(0.06, 0.03, 0.1, 0.97)
    f:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function() UI:Hide() end)

    self:CreateHeader(f)
    self:CreateSummary(f)
    self:CreateCategoryTabs(f)
    self:CreateAchievementList(f)

    self.currentCategory = nil

    f:Hide()
end

function UI:CreateHeader(parent)
    local header = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10)
    header:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -10, -10)
    header:SetHeight(36)
    header:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tileSize = 12, edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    header:SetBackdropColor(0.1, 0.05, 0.15, 0.9)
    header:SetBackdropBorderColor(0.7, 0.5, 0.1, 1)

    local title = header:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
    title:SetPoint("CENTER", header, "CENTER", 0, 0)
    title:SetText("|cFF00AAFF◆ 道果录 ◆|r")
end

function UI:CreateSummary(parent)
    self.summaryText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.summaryText:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -54)
    self.summaryText:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, -54)
    self.summaryText:SetJustifyH("LEFT")
    self.summaryText:SetText("|cFFAAAAAA正在观想道果...|r")
end

function UI:CreateCategoryTabs(parent)
    local categories = {
        { key = "修行道果", name = "修行", icon = "|cFFFFD700☯|r" },
        { key = "历练道果", name = "历练", icon = "|cFF44FF44📜|r" },
        { key = "秘境道果", name = "秘境", icon = "|cFF4488FF🐉|r" },
        { key = "斗法道果", name = "斗法", icon = "|cFFFF4444⚔|r" },
        { key = "百艺道果", name = "百艺", icon = "|cFFFFAA00🔨|r" },
        { key = "人缘道果", name = "人缘", icon = "|cFF44AAFF🤝|r" },
    }

    self.categoryButtons = {}
    local tabWidth = 75
    local tabHeight = 24
    local startX = 14
    local gap = 2

    for i, cat in ipairs(categories) do
        local xOff = startX + (i - 1) * (tabWidth + gap)
        local tab = CreateFrame("Button", nil, parent, "BackdropTemplate")
        tab:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -74)
        tab:SetSize(tabWidth, tabHeight)
        tab:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8, edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        tab:SetBackdropColor(0.06, 0.03, 0.1, 0.9)
        tab:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)
        tab.catKey = cat.key

        local label = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("CENTER", tab, "CENTER", 0, 0)
        label:SetText(cat.icon .. " " .. cat.name)

        tab:SetScript("OnClick", function(self)
            UI:SelectCategory(self.catKey)
        end)
        tab:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        end)
        tab:SetScript("OnLeave", function(self)
            if UI.currentCategory ~= self.catKey then
                self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)
            end
        end)

        self.categoryButtons[cat.key] = tab
    end
end

function UI:CreateAchievementList(parent)
    local scrollFrame = CreateFrame("ScrollFrame", "WoWCultivationAchievementScroll", parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -106)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -30, 14)

    self.achievementContent = CreateFrame("Frame", nil, scrollFrame)
    self.achievementContent:SetSize(450, 1)
    scrollFrame:SetScrollChild(self.achievementContent)

    self.achievementItems = {}
end

function UI:Refresh()
    if not self.frame then return end

    local totalAchievements, totalPoints, numCompleted = self:GetAchievementStats()
    self.summaryText:SetText(
        "|cFFEEDDAA道果总数：|r|cFFFFFFFF" .. totalAchievements .. "|r  "
        .. "|cFFEEDDAA已获道果：|r|cFF00FF00" .. numCompleted .. "|r  "
        .. "|cFFEEDDAA道行：|r|cFFFFD700" .. totalPoints .. "|r"
    )

    if self.currentCategory then
        self:ShowCategory(self.currentCategory)
    else
        self:SelectCategory("修行道果")
    end
end

function UI:GetAchievementStats()
    local totalPoints = GetTotalAchievementPoints() or 0
    local totalAchievements = GetNumCompletedAchievements() or 0
    local numCompleted = totalAchievements

    -- 获取分类统计
    local totalCat = 0
    local completedCat = 0
    for i = 1, GetNumAchievementCategories() do
        local _, _, numInCat, numCompletedInCat = GetAchievementCategoryInfo(i)
        if numInCat then
            totalCat = totalCat + numInCat
        end
        if numCompletedInCat then
            completedCat = completedCat + numCompletedInCat
        end
    end

    -- 使用分类统计如果更准确
    if totalCat > totalAchievements then
        totalAchievements = totalCat
    end
    if completedCat > numCompleted then
        numCompleted = completedCat
    end

    return totalAchievements, totalPoints, numCompleted
end

function UI:SelectCategory(catKey)
    self.currentCategory = catKey

    -- 更新标签高亮
    for key, tab in pairs(self.categoryButtons) do
        if key == catKey then
            tab:SetBackdropColor(0.15, 0.08, 0.2, 0.95)
            tab:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        else
            tab:SetBackdropColor(0.06, 0.03, 0.1, 0.9)
            tab:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)
        end
    end

    self:ShowCategory(catKey)
end

function UI:ShowCategory(catKey)
    -- 清除旧内容
    for _, item in pairs(self.achievementItems) do
        item:Hide()
    end

    local achievements = {}
    for i = 1, GetNumAchievementCategories() do
        local id, name, _, numCompleted = GetAchievementCategoryInfo(i)
        if id and name then
            local xiuxianName = UI.CATEGORY_MAP[name]
            local mappedName = xiuxianName and xiuxianName.name or name
            if mappedName == catKey then
                table.insert(achievements, {
                    categoryId = id,
                    categoryName = name,
                    numCompleted = numCompleted or 0,
                })
            end
        end
    end

    -- 也检查各个分类的成就
    local allAchievements = {}
    for _, catInfo in ipairs(achievements) do
        for i = 1, GetAchievementNumAchievements(catInfo.categoryId) do
            local achId = GetAchievementInfo(catInfo.categoryId, i)
            if achId then
                local _, name, _, completed, _, _, _, description = GetAchievementInfo(achId)
                if name and completed then
                    table.insert(allAchievements, {
                        id = achId,
                        name = name,
                        description = description or "",
                        completed = true,
                    })
                end
            end
        end
    end

    -- 显示成就
    local content = self.achievementContent
    local itemHeight = 32
    local totalHeight = math.max(#allAchievements * itemHeight + 10, 400)
    content:SetHeight(totalHeight)

    local itemIndex = 1
    for _, ach in ipairs(allAchievements) do
        local yOff = -(itemIndex - 1) * itemHeight
        local item = self.achievementItems[itemIndex]
        if not item then
            item = self:CreateAchievementItem(content, itemIndex, yOff)
            self.achievementItems[itemIndex] = item
        else
            item:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOff)
            item:Show()
        end
        self:UpdateAchievementItem(item, ach)
        itemIndex = itemIndex + 1
    end
end

function UI:CreateAchievementItem(parent, index, yOffset)
    local item = CreateFrame("Frame", nil, parent)
    item:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset)
    item:SetSize(440, 28)

    local bgAlpha = (index % 2 == 0) and 0.04 or 0.07
    local bg = item:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(item)
    bg:SetTexture(0, 0, 0, bgAlpha)

    local nameText = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    nameText:SetPoint("LEFT", item, "LEFT", 6, 0)
    nameText:SetPoint("RIGHT", item, "RIGHT", -6, 0)
    nameText:SetJustifyH("LEFT")

    item.nameText = nameText
    return item
end

function UI:UpdateAchievementItem(item, ach)
    item.nameText:SetText("|cFF00FF00✓|r |cFFFFFFFF" .. ach.name .. "|r  |cFF888888" .. (ach.description or "") .. "|r")
end

function UI:Show()
    if not self.frame then return end
    self:Refresh()
    self.frame:SetAlpha(1)
    self.frame:Show()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
end

function UI:Toggle()
    if not self.frame then return end
    if self.frame:IsShown() and self.frame:GetAlpha() > 0.5 then
        self:Hide()
    else
        self:Show()
    end
end
