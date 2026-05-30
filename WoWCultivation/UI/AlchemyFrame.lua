-- ============================================================
-- AlchemyFrame.lua - 炼丹术面板
-- Titan Time Server 3.80.1 (Interface: 38001)
-- ============================================================
local UI = {}
UI.name = "AlchemyFrame"
WoWCultivation.UI.AlchemyFrame = UI

-- 丹药配方数据：根据 ElixirModule 的识别逻辑展示
UI.RECIPES = {
    {
        name = "回血丹",
        icon = "Interface\\Icons\\INV_Potion_54",
        category = "丹药",
        desc = "恢复生命值，修仙之人必备良药",
        effect = "恢复生命值",
        grade = "凡品",
        quality = 1,
        materials = {
            { name = "宁神花", icon = "Interface\\Icons\\INV_Misc_Flower_02" },
            { name = "银叶草", icon = "Interface\\Icons\\INV_Misc_Herb_08" },
        },
    },
    {
        name = "回气丹",
        icon = "Interface\\Icons\\INV_Potion_82",
        category = "丹药",
        desc = "恢复法力值，施法者不可或缺",
        effect = "恢复法力值",
        grade = "凡品",
        quality = 1,
        materials = {
            { name = "魔皇草", icon = "Interface\\Icons\\INV_Misc_Herb_03" },
            { name = "石南草", icon = "Interface\\Icons\\INV_Misc_Herb_15" },
        },
    },
    {
        name = "清心丹",
        icon = "Interface\\Icons\\INV_Potion_27",
        category = "丹药",
        desc = "消除心魔值，静心凝神之丹",
        effect = "降低心魔值",
        grade = "上品",
        quality = 2,
        materials = {
            { name = "雨燕草", icon = "Interface\\Icons\\INV_Misc_Herb_01" },
            { name = "跌打草", icon = "Interface\\Icons\\INV_Misc_Herb_12" },
        },
    },
    {
        name = "聚气丹",
        icon = "Interface\\Icons\\INV_Potion_53",
        category = "丹药",
        desc = "提升修炼感悟，加速修为增长",
        effect = "提升修炼效率",
        grade = "上品",
        quality = 2,
        materials = {
            { name = "野钢花", icon = "Interface\\Icons\\INV_Misc_Herb_06" },
            { name = "墓地苔", icon = "Interface\\Icons\\INV_Misc_Herb_14" },
        },
    },
    {
        name = "天元丹",
        icon = "Interface\\Icons\\INV_Potion_83",
        category = "天元丹",
        desc = "长时间属性加成，突破瓶颈必备",
        effect = "长时间属性加成",
        grade = "极品",
        quality = 3,
        materials = {
            { name = "梦叶草", icon = "Interface\\Icons\\INV_Misc_Herb_18" },
            { name = "山鼠草", icon = "Interface\\Icons\\INV_Misc_Herb_10" },
            { name = "冰盖草", icon = "Interface\\Icons\\INV_Misc_Herb_17" },
        },
    },
    {
        name = "筑基丹",
        icon = "Interface\\Icons\\INV_Potion_71",
        category = "丹药",
        desc = "突破境界成功率大幅提升，破境至宝",
        effect = "突破成功率提升",
        grade = "仙品",
        quality = 4,
        materials = {
            { name = "黑莲花", icon = "Interface\\Icons\\INV_Misc_Herb_DragonbreathChili" },
            { name = "黄金参", icon = "Interface\\Icons\\INV_Misc_Herb_SansamRoot" },
            { name = "魔莲花", icon = "Interface\\Icons\\INV_Misc_Herb_FelLotus" },
        },
    },
    {
        name = "灵膳",
        icon = "Interface\\Icons\\INV_Misc_Food_15",
        category = "灵膳",
        desc = "恢复生命法力，果腹修仙之食",
        effect = "恢复生命法力",
        grade = "凡品",
        quality = 1,
        materials = {
            { name = "新鲜食材", icon = "Interface\\Icons\\INV_Misc_Food_08" },
        },
    },
}

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationAlchemyFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(500, 520)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 20,
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
    self:CreateInfo(f)
    self:CreateRecipeList(f)

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
        tileSize = 12,
        edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    header:SetBackdropColor(0.1, 0.05, 0.15, 0.9)
    header:SetBackdropBorderColor(0.7, 0.5, 0.1, 1)

    local title = header:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
    title:SetPoint("CENTER", header, "CENTER", 0, 0)
    title:SetText("|cFF9B59B6◆ 炼丹术 ◆|r")
end

function UI:CreateInfo(parent)
    local info = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    info:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -54)
    info:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, -54)
    info:SetWordWrap(true)
    info:SetJustifyH("LEFT")

    -- 检查玩家炼金技能
    local alchemySkill = 0
    local alchemyName = "炼金术"
    for i = 1, GetNumSkillLines() do
        local skillName, _, _, skillRank = GetSkillLineInfo(i)
        if skillName and (skillName == "炼金术" or skillName == "Alchemy") then
            alchemySkill = skillRank or 0
            break
        end
    end

    local gradeText = "炼丹学徒"
    local gradeColor = "|cFF9d9d9d"
    if alchemySkill >= 450 then
        gradeText = "炼丹宗师"
        gradeColor = "|cFFe6cc80"
    elseif alchemySkill >= 300 then
        gradeText = "炼丹大师"
        gradeColor = "|cFFa335ee"
    elseif alchemySkill >= 150 then
        gradeText = "炼丹高手"
        gradeColor = "|cFF0070dd"
    elseif alchemySkill >= 75 then
        gradeText = "炼丹弟子"
        gradeColor = "|cFF1eff00"
    end

    info:SetText("|cFFEEDDAA炼丹修为：|r" .. gradeColor .. gradeText .. "|r  |cFFEEDDAA炼金技能：|r" .. (alchemySkill > 0 and alchemySkill or "未学习"))
end

function UI:CreateRecipeList(parent)
    local scrollFrame = CreateFrame("ScrollFrame", "WoWCultivationAlchemyScroll", parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -90)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -30, 14)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(450, 1)
    scrollFrame:SetScrollChild(content)

    local itemHeight = 68
    local totalHeight = #UI.RECIPES * itemHeight + 10
    content:SetHeight(totalHeight)

    local yOffset = 0
    for i, recipe in ipairs(UI.RECIPES) do
        yOffset = -(i - 1) * itemHeight
        self:CreateRecipeItem(content, i, recipe, yOffset, 450)
    end
end

function UI:CreateRecipeItem(parent, index, recipe, yOffset, width)
    local item = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    item:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset)
    item:SetSize(width, 62)
    item:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    local bgAlpha = (index % 2 == 0) and 0.05 or 0.08
    item:SetBackdropColor(bgAlpha, bgAlpha * 0.5, bgAlpha * 2, 0.9)
    item:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)

    -- 图标
    local icon = item:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("LEFT", item, "LEFT", 8, 0)
    icon:SetSize(36, 36)
    icon:SetTexture(recipe.icon)

    local iconBorder = item:CreateTexture(nil, "BORDER")
    iconBorder:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
    iconBorder:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
    iconBorder:SetTexture("Interface\\Buttons\\UI-Quickslot2")

    -- 品质颜色
    local qualityColors = {
        [1] = { r = 1, g = 1, b = 1 },
        [2] = { r = 0.12, g = 1, b = 0 },
        [3] = { r = 0, g = 0.44, b = 0.87 },
        [4] = { r = 0.64, g = 0.21, b = 0.93 },
    }
    local qc = qualityColors[recipe.quality] or qualityColors[1]

    -- 丹药名称
    local nameText = item:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, -2)
    nameText:SetText(string.format("|cFF%02x%02x%02x%s|r  |cFFEEDDAA%s|r", qc.r * 255, qc.g * 255, qc.b * 255, recipe.name, recipe.grade))

    -- 效果描述
    local descText = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    descText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
    descText:SetPoint("RIGHT", item, "RIGHT", -10, 0)
    descText:SetText("|cFFAAAAAA" .. recipe.desc .. "|r")

    -- 材料标签
    local matText = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    matText:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 10, 4)
    matText:SetPoint("RIGHT", item, "RIGHT", -10, 0)
    local matNames = {}
    for _, m in ipairs(recipe.materials) do
        table.insert(matNames, "|cFF88BB88" .. m.name .. "|r")
    end
    matText:SetText("材料: " .. table.concat(matNames, "、"))

    -- 悬停提示
    item:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("|cFFFFD700" .. recipe.name .. "|r  |cFFEEDDAA" .. recipe.grade .. "|r")
        GameTooltip:AddLine("效果: " .. recipe.effect, 1, 1, 1)
        GameTooltip:AddLine("分类: " .. recipe.category, 1, 1, 1)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("所需材料:", 0.6, 1, 0.6)
        for _, m in ipairs(recipe.materials) do
            GameTooltip:AddLine("  · " .. m.name, 1, 1, 1)
        end
        GameTooltip:Show()
    end)
    item:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)
        GameTooltip:Hide()
    end)

    return item
end

function UI:Refresh()
    if not self.frame then return end
end

function UI:Show()
    if not self.frame then return end
    self:Refresh()
    
    if self.fadeAnim and self.fadeAnim:IsPlaying() then
        self.fadeAnim:Stop()
    end
    
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
