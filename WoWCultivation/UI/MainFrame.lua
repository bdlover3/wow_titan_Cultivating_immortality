-- ============================================================
-- MainFrame.lua - 修仙宝典（原修仙录）
-- 重新设计布局: 法宝/机缘/师门/功法 + 生活技能 + 功能入口
-- 目标版本: 3.80.1 — BackdropTemplate
-- ============================================================
local UI = {}
UI.name = "MainFrame"
WoWCultivation.UI.MainFrame = UI

UI.FRAME_WIDTH = 520
UI.FRAME_HEIGHT = 580

-- Row 1: 四大核心入口
UI.ROW1_BUTTONS = {
    { id = "treasure",   name = "法宝",   icon = "Interface\\Icons\\INV_Chest_Chain_03", sub = "装备信息", action = "equipment" },
    { id = "quest",      name = "机缘",   icon = "Interface\\Icons\\INV_Misc_Book_03",  sub = "任务日志", action = "questlog" },
    { id = "sect",       name = "师门",   icon = "Interface\\Icons\\INV_Banner_01",    sub = "宗门帮派", action = "guild" },
    { id = "technique",  name = "功法",   icon = "Interface\\Icons\\INV_Misc_Book_09", sub = "法术书",   action = "spellbook" },
}

-- Row 3: 功能入口
UI.ROW3_BUTTONS = {
    { id = "storage",    name = "储物袋",     icon = "Interface\\Icons\\INV_Misc_Bag_10_Green",             sub = "随身行囊",   action = "storage" },
    { id = "bg",         name = "仙域冲突",   icon = "Interface\\Icons\\Ability_Warrior_OffensiveStance", sub = "随机战场",   action = "random_bg" },
    { id = "dungeon",    name = "小秘境夺宝", icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Blue",        sub = "随机组队",   action = "dungeon_finder" },
    { id = "achievement",name = "道果录",     icon = "Interface\\Icons\\INV_Misc_Book_09",                  sub = "修行成就",   action = "achievement" },
    { id = "treasure2",  name = "灵宝鉴",     icon = "Interface\\Icons\\INV_Chest_Chain_03",                sub = "灵宝图鉴",   action = "treasure_frame" },
    { id = "divinesense",name = "神识探查",   icon = "Interface\\Icons\\Spell_Holy_MindVision",              sub = "探查道友",   action = "divinesense" },
    { id = "meditation", name = "闭关修炼",   icon = "Interface\\Icons\\Spell_Nature_Meditation",           sub = "闭关打坐",   action = "meditation" },
    { id = "arena",      name = "斗法台",     icon = "Interface\\Icons\\Ability_DualWield",                 sub = "竞技场",     action = "arena" },
    { id = "channel",    name = "修仙界",     icon = "Interface\\Icons\\Spell_Holy_MindVision",              sub = "修仙频道",   action = "channel" },
    { id = "spiritpet",  name = "灵宠",       icon = "Interface\\Icons\\Ability_Hunter_BeastCall",           sub = "本命灵宠",   action = "spiritpet", hunterOnly = true },
}

-- 采集物数据: 技能要求 → 采集物列表
UI.GATHER_DATA = {
    herb = {
        title = "灵植采集",
        items = {
            { skill = 1,   name = "宁神花",       icon = "Interface\\Icons\\INV_Misc_Herb_06" },
            { skill = 1,   name = "银叶草",       icon = "Interface\\Icons\\INV_Misc_Herb_07" },
            { skill = 1,   name = "地根草",       icon = "Interface\\Icons\\INV_Misc_Herb_08" },
            { skill = 50,  name = "魔皇草",       icon = "Interface\\Icons\\INV_Misc_Herb_03" },
            { skill = 50,  name = "石南草",       icon = "Interface\\Icons\\INV_Misc_Herb_04" },
            { skill = 70,  name = "雨燕草",       icon = "Interface\\Icons\\INV_Misc_Herb_05" },
            { skill = 100, name = "跌打草",       icon = "Interface\\Icons\\INV_Misc_Herb_19" },
            { skill = 100, name = "荆棘藻",       icon = "Interface\\Icons\\INV_Misc_Herb_15" },
            { skill = 125, name = "野钢花",       icon = "Interface\\Icons\\INV_Misc_Herb_12" },
            { skill = 150, name = "皇血草",       icon = "Interface\\Icons\\INV_Misc_Herb_09" },
            { skill = 160, name = "活根草",       icon = "Interface\\Icons\\INV_Misc_Herb_16" },
            { skill = 170, name = "卡德加的胡须", icon = "Interface\\Icons\\INV_Misc_Herb_17" },
            { skill = 185, name = "枯叶草",       icon = "Interface\\Icons\\INV_Misc_Herb_11" },
            { skill = 205, name = "金棘草",       icon = "Interface\\Icons\\INV_Misc_Herb_01" },
            { skill = 230, name = "太阳草",       icon = "Interface\\Icons\\INV_Misc_Herb_02" },
            { skill = 250, name = "盲目草",       icon = "Interface\\Icons\\INV_Misc_Herb_14" },
            { skill = 260, name = "格罗姆之血",   icon = "Interface\\Icons\\INV_Misc_Herb_10" },
            { skill = 285, name = "黄金参",       icon = "Interface\\Icons\\INV_Misc_Herb_18" },
            { skill = 290, name = "梦叶草",       icon = "Interface\\Icons\\INV_Misc_Herb_20" },
            { skill = 300, name = "山鼠草",       icon = "Interface\\Icons\\INV_Misc_Herb_22" },
            { skill = 300, name = "冰盖草",       icon = "Interface\\Icons\\INV_Misc_Herb_23" },
            { skill = 325, name = "魔草",         icon = "Interface\\Icons\\INV_Misc_Herb_24" },
            { skill = 350, name = "噩梦藤",       icon = "Interface\\Icons\\INV_Misc_Herb_25" },
            { skill = 375, name = "泰罗果",       icon = "Interface\\Icons\\INV_Misc_Herb_26" },
            { skill = 425, name = "金苜蓿",       icon = "Interface\\Icons\\INV_Misc_Herb_28" },
            { skill = 450, name = "冰棘",         icon = "Interface\\Icons\\INV_Misc_Herb_27" },
        }
    },
    mine = {
        title = "灵矿开采",
        items = {
            { skill = 1,   name = "铜矿石",   icon = "Interface\\Icons\\INV_Ore_Copper_01" },
            { skill = 65,  name = "锡矿石",   icon = "Interface\\Icons\\INV_Ore_Tin_01" },
            { skill = 75,  name = "银矿石",   icon = "Interface\\Icons\\INV_Ore_Silver_01" },
            { skill = 125, name = "铁矿石",   icon = "Interface\\Icons\\INV_Ore_Iron_01" },
            { skill = 155, name = "金矿石",   icon = "Interface\\Icons\\INV_Ore_Gold_01" },
            { skill = 175, name = "秘银矿石", icon = "Interface\\Icons\\INV_Ore_Mithril_01" },
            { skill = 230, name = "真银矿石", icon = "Interface\\Icons\\INV_Ore_TrueSilver_01" },
            { skill = 245, name = "瑟银矿石", icon = "Interface\\Icons\\INV_Ore_Thorium_01" },
            { skill = 300, name = "魔铁矿石", icon = "Interface\\Icons\\INV_Ore_FelIron" },
            { skill = 325, name = "精金矿石", icon = "Interface\\Icons\\INV_Ore_Adamantite" },
            { skill = 350, name = "氪金矿石", icon = "Interface\\Icons\\INV_Ore_Eternium" },
            { skill = 375, name = "钴矿石",   icon = "Interface\\Icons\\INV_Ore_Cobalt" },
            { skill = 400, name = "萨隆邪铁", icon = "Interface\\Icons\\INV_Ore_Saronite" },
            { skill = 450, name = "泰坦矿石", icon = "Interface\\Icons\\INV_Ore_Platinum_01" },
        }
    },
    skin = {
        title = "妖兽取材",
        items = {
            { skill = 1,   name = "轻皮",       icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_01" },
            { skill = 25,  name = "轻毛皮",     icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_02" },
            { skill = 100, name = "中皮",       icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_03" },
            { skill = 100, name = "中毛皮",     icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_02" },
            { skill = 150, name = "重皮",       icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_01" },
            { skill = 150, name = "重毛皮",     icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_02" },
            { skill = 200, name = "厚皮",       icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_03" },
            { skill = 200, name = "厚毛皮",     icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_02" },
            { skill = 250, name = "硬甲皮",     icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_01" },
            { skill = 250, name = "硬甲毛皮",   icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_03" },
            { skill = 300, name = "结缔皮",     icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_02" },
            { skill = 350, name = "魔鳞皮",     icon = "Interface\\Icons\\INV_Misc_Slime_01" },
            { skill = 375, name = "北地皮",     icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_01" },
            { skill = 425, name = "重北地皮",   icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_03" },
        }
    },
}

-- 制造类专业 → CastSpellByName
UI.CRAFT_SPELLS = {
    ["锻造"] = "锻造", ["制皮"] = "制皮", ["炼金术"] = "炼金术",
    ["裁缝"] = "裁缝", ["附魔"] = "附魔", ["铭文"] = "铭文",
    ["珠宝加工"] = "珠宝加工", ["工程学"] = "工程学",
    ["急救"] = "急救", ["烹饪"] = "烹饪",
    ["铸兵术"] = "锻造", ["炼皮术"] = "制皮", ["炼丹术"] = "炼金术",
    ["织袍术"] = "裁缝", ["炼器术"] = "附魔", ["铭文术"] = "铭文",
    ["阵法之道"] = "珠宝加工", ["机关术"] = "工程学",
    ["灵医术"] = "急救", ["灵食制作"] = "烹饪",
}

-- 采集类技能ID
UI.GATHER_SKILL_IDS = {
    [182] = "herb", [186] = "mine", [393] = "skin",
}

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationMainFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(UI.FRAME_WIDTH, UI.FRAME_HEIGHT)
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
    self:CreateStatusBar(f)
    self:CreateRow1(f)
    self:CreateRow2(f)
    self:CreateRow3(f)
    self:CreateDialogArea(f)
    self:CreateGatherPanel(f)

    f:Hide()
end

-- ============================================================
-- Header
-- ============================================================
function UI:CreateHeader(parent)
    local header = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10)
    header:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -10, -10)
    header:SetHeight(35)
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
    title:SetText("|cFFFFD700✦ 修 仙 宝 典 ✦|r")
    self.headerTitle = title
end

-- ============================================================
-- Status Bar - 境界 | 灵石 | 仙缘值
-- ============================================================
function UI:CreateStatusBar(parent)
    local bar = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    bar:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -50)
    bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -14, -50)
    bar:SetHeight(28)
    bar:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    bar:SetBackdropColor(0.04, 0.02, 0.06, 0.85)
    bar:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)

    local statusText = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    statusText:SetPoint("CENTER", bar, "CENTER", 0, 0)
    statusText:SetText("|cFF888888加载中...|r")
    self.statusText = statusText
end

-- ============================================================
-- Row 1: 法宝 / 机缘 / 师门 / 功法
-- ============================================================
function UI:CreateRow1(parent)
    local titleLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -90)
    titleLabel:SetText("|cFFFFD700◆ 修仙根基 ◆|r")

    local startY = -112
    local btnW = 110
    local btnH = 90
    local gap = 10
    local startX = 14

    for i, btnData in ipairs(UI.ROW1_BUTTONS) do
        local xOff = startX + (i - 1) * (btnW + gap)

        local btn = CreateFrame("Button", "WoWCultivationBtn_" .. btnData.id, parent, "BackdropTemplate")
        btn:SetSize(btnW, btnH)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, startY)
        btn:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8, edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        btn:SetBackdropColor(0.06, 0.03, 0.1, 0.85)
        btn:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)

        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetSize(40, 40)
        icon:SetPoint("TOP", btn, "TOP", 0, -10)
        icon:SetTexture(btnData.icon)

        local nameLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameLabel:SetPoint("TOP", icon, "BOTTOM", 0, -4)
        nameLabel:SetText("|cFFFFD700" .. btnData.name .. "|r")

        local subLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        subLabel:SetPoint("TOP", nameLabel, "BOTTOM", 0, -2)
        subLabel:SetText("|cFF888888" .. btnData.sub .. "|r")

        btn:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        end)
        btn:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)
        end)
        btn:SetScript("OnClick", function()
            UI:OnRow1Click(btnData.action)
        end)

        self["row1_" .. btnData.id] = btn
    end
end

-- ============================================================
-- Row 2: 生活技能
-- ============================================================
function UI:CreateRow2(parent)
    local titleLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -212)
    titleLabel:SetText("|cFFFFD700◆ 修仙百艺 ◆|r")
    self.row2Title = titleLabel

    self.row2Container = CreateFrame("Frame", nil, parent)
    self.row2Container:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -232)
    self.row2Container:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -14, -232)
    self.row2Container:SetHeight(70)
    self.row2Buttons = {}
end

-- ============================================================
-- Row 3: 功能入口
-- ============================================================
function UI:CreateRow3(parent)
    local titleLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -315)
    titleLabel:SetText("|cFFFFD700◆ 仙途指引 ◆|r")

    local startY = -335
    local btnSize = 56
    local btnGap = 8
    local cols = 4
    local startX = 14
    self.row3Buttons = {}

    -- Check if player is Hunter for pet button visibility
    local _, englishClass = UnitClass("player")
    local isHunter = (englishClass == "HUNTER")

    for i, btnData in ipairs(UI.ROW3_BUTTONS) do
        local row = math.floor((i - 1) / cols)
        local col = (i - 1) % cols
        local xOff = startX + col * (btnSize + btnGap)
        local yOff = startY - row * (btnSize + btnGap)

        local btn = CreateFrame("Button", "WoWCultivationRow3_" .. btnData.id, parent, "BackdropTemplate")
        btn:SetSize(btnSize, btnSize)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff)
        btn:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8, edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        btn:SetBackdropColor(0.06, 0.03, 0.1, 0.85)
        btn:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)

        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", btn, "TOPLEFT", 6, -4)
        icon:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -6, 14)
        icon:SetTexture(btnData.icon)

        local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("BOTTOM", btn, "BOTTOM", 0, 3)
        label:SetText("|cFFEEDDAA" .. btnData.name .. "|r")

        btn:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        end)
        btn:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)
        end)
        btn:SetScript("OnClick", function()
            UI:OnRow3Click(btnData.action)
        end)

        -- Hide hunter-only buttons for non-hunters
        if btnData.hunterOnly and not isHunter then
            btn:Hide()
        end

        self.row3Buttons[btnData.id] = btn
    end
end

-- ============================================================
-- Dialog Area
-- ============================================================
function UI:CreateDialogArea(parent)
    local dialog = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    dialog:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 14, 14)
    dialog:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -14, 14)
    dialog:SetHeight(65)
    dialog:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tileSize = 12, edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    dialog:SetBackdropColor(0.08, 0.04, 0.12, 0.88)
    dialog:SetBackdropBorderColor(0.7, 0.5, 0.1, 1)

    local dialogText = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialogText:SetPoint("TOPLEFT", dialog, "TOPLEFT", 10, -8)
    dialogText:SetPoint("BOTTOMRIGHT", dialog, "BOTTOMRIGHT", -10, 8)
    dialogText:SetWordWrap(true)
    dialogText:SetJustifyH("LEFT")
    dialogText:SetJustifyV("TOP")
    dialogText:SetText("|cFFEEDDAA小师妹：师兄，欢迎回来~|r")
    self.dialogText = dialogText
end

-- ============================================================
-- Gather Panel
-- ============================================================
function UI:CreateGatherPanel(parent)
    local gp = CreateFrame("Frame", "WoWCultivationGatherPanel", UIParent, "BackdropTemplate")
    gp:SetSize(350, 320)
    gp:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    gp:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    gp:SetBackdropColor(0.06, 0.03, 0.12, 0.95)
    gp:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    gp:SetMovable(true)
    gp:EnableMouse(true)
    gp:RegisterForDrag("LeftButton")
    gp:SetScript("OnDragStart", gp.StartMoving)
    gp:SetScript("OnDragStop", gp.StopMovingOrSizing)
    gp:SetClampedToScreen(true)

    local gpTitle = gp:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    gpTitle:SetPoint("TOP", gp, "TOP", 0, -12)
    gpTitle:SetText("|cFFFFD700灵植采集|r")
    gp.titleText = gpTitle

    local gpSkill = gp:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    gpSkill:SetPoint("TOP", gpTitle, "BOTTOM", 0, -4)
    gpSkill:SetText("当前技能: 0")
    gp.skillText = gpSkill

    local closeBtn = CreateFrame("Button", nil, gp, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", gp, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function() gp:Hide() end)

    -- Scroll content area
    local contentBg = CreateFrame("Frame", nil, gp, "BackdropTemplate")
    contentBg:SetPoint("TOPLEFT", gp, "TOPLEFT", 12, -55)
    contentBg:SetPoint("BOTTOMRIGHT", gp, "BOTTOMRIGHT", -12, 12)
    contentBg:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    contentBg:SetBackdropColor(0.04, 0.02, 0.08, 0.8)
    contentBg:SetBackdropBorderColor(0.5, 0.35, 0.08, 0.5)

    gp.contentBg = contentBg
    gp.itemFrames = {}

    gp:Hide()
    self.gatherPanel = gp
end

function UI:ShowGatherPanel(gatherType)
    local gp = self.gatherPanel
    if not gp then return end

    local data = UI.GATHER_DATA[gatherType]
    if not data then return end

    gp.titleText:SetText("|cFFFFD700" .. data.title .. " - 采集图谱|r")

    -- Get current skill level
    local skillLevel = 0
    for i = 1, GetNumSkillLines() do
        local sn, isH, _, sr, _, _, _, _, _, _, _, sID = GetSkillLineInfo(i)
        if not isH and sID == (gatherType == "herb" and 182 or gatherType == "mine" and 186 or gatherType == "skin" and 393 or 0) then
            skillLevel = sr
            break
        end
    end
    gp.skillText:SetText("当前技能: |cFF1EFF00" .. skillLevel .. "|r")

    -- Clear old items
    for _, frame in ipairs(gp.itemFrames) do
        frame:Hide()
    end

    -- Create item list
    local yOffset = -10
    for i, item in ipairs(data.items) do
        local itemFrame
        if gp.itemFrames[i] then
            itemFrame = gp.itemFrames[i]
            itemFrame:Show()
        else
            itemFrame = CreateFrame("Frame", nil, gp.contentBg)
            itemFrame:SetSize(310, 18)
            itemFrame:SetPoint("TOPLEFT", gp.contentBg, "TOPLEFT", 8, 0)

            local skillText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            skillText:SetPoint("LEFT", itemFrame, "LEFT", 0, 0)
            skillText:SetWidth(50)
            skillText:SetJustifyH("RIGHT")
            itemFrame.skillText = skillText

            local itemText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            itemText:SetPoint("LEFT", itemFrame, "LEFT", 55, 0)
            itemFrame.itemText = itemText

            gp.itemFrames[i] = itemFrame
        end

        local unlocked = skillLevel >= item.skill
        local color = unlocked and "|cFF1EFF00" or "|cFFFF0000"
        local statusIcon = unlocked and "✓" or "✗"

        itemFrame.skillText:SetText(color .. item.skill .. "|r")
        itemFrame.itemText:SetText(color .. statusIcon .. " " .. item.name .. "|r")
        itemFrame:SetPoint("TOPLEFT", gp.contentBg, "TOPLEFT", 8, yOffset)
        yOffset = yOffset - 16
    end

    gp:Show()
end

-- ============================================================
-- Row 1 Click Handlers
-- ============================================================
function UI:OnRow1Click(action)
    if action == "equipment" then
        if ToggleCharacter then
            ToggleCharacter("PaperDollFrame")
        end
    elseif action == "questlog" then
        if ToggleQuestLog then
            ToggleQuestLog()
        end
    elseif action == "guild" then
        if ToggleGuildFrame then
            ToggleGuildFrame()
        elseif GuildFrame and GuildFrame:IsShown() then
            GuildFrame:Hide()
        else
            GuildMicroButton:Click()
        end
    elseif action == "spellbook" then
        if ToggleSpellBook then
            ToggleSpellBook("spell")
        end
    end
end

-- ============================================================
-- Row 2 Profession Click Handler
-- ============================================================
function UI:OnProfClick(profData)
    if profData.isGather then
        self:ShowGatherPanel(profData.gatherType)
    else
        local spellName = UI.CRAFT_SPELLS[profData.wowName]
        if spellName and CastSpellByName then
            CastSpellByName(spellName)
        end
    end
end

-- ============================================================
-- Row 3 Click Handlers
-- ============================================================
function UI:OnRow3Click(action)
    if action == "storage" then
        if WoWCultivation.UI and WoWCultivation.UI.StorageFrame then
            WoWCultivation.UI.StorageFrame:Toggle()
        end
    elseif action == "random_bg" then
        if TogglePVPFrame then
            TogglePVPFrame()
        end
    elseif action == "dungeon_finder" then
        -- WotLK 3.80.1: 直接用 LFDParentFrame
        if LFDParentFrame then
            if LFDParentFrame:IsShown() then
                LFDParentFrame:Hide()
            else
                LFDParentFrame:Show()
            end
        elseif ToggleLFDParent then
            ToggleLFDParent()
        end
    elseif action == "achievement" then
        if ToggleAchievementFrame then
            ToggleAchievementFrame()
        end
    elseif action == "treasure_frame" then
        -- 打开灵宝鉴（装备图鉴面板）
        if WoWCultivation.UI and WoWCultivation.UI.TreasureFrame then
            WoWCultivation.UI.TreasureFrame:Toggle()
        end
    elseif action == "divinesense" then
        if WoWCultivation.UI and WoWCultivation.UI.DivineSenseFrame then
            local data = self:GetCurrentPlayerData()
            WoWCultivation.UI.DivineSenseFrame:Show(data)
        end
    elseif action == "meditation" then
        if WoWCultivation.UI and WoWCultivation.UI.MeditationFrame then
            WoWCultivation.UI.MeditationFrame:Toggle()
        end
    elseif action == "arena" then
        if TogglePVPFrame then
            TogglePVPFrame()
        end
    elseif action == "channel" then
        -- Focus channel "修仙界"
        if WoWCultivation.Modules and WoWCultivation.Modules.ChannelModule then
            WoWCultivation:Print("已切换至修仙界频道")
        end
    elseif action == "spiritpet" then
        -- 猎人灵宠面板
        local _, englishClass = UnitClass("player")
        if englishClass == "HUNTER" then
            -- WotLK: 尝试多种方式打开宠物面板
            if TogglePetStable then
                TogglePetStable()
            elseif PetStableFrame then
                PetStableFrame:Show()
            elseif ToggleCharacter then
                -- 打开角色面板的宠物标签页
                ToggleCharacter("PetPaperDollFrame")
            elseif PetPaperDollFrame then
                PetPaperDollFrame:Show()
            else
                -- 最终回退：打开角色面板
                if ToggleCharacter then
                    ToggleCharacter("PaperDollFrame")
                end
            end
            -- 如果有在线的宠物，显示宠物信息
            if UnitExists("pet") then
                local petName = UnitName("pet") or "未知"
                local petLevel = UnitLevel("pet") or 0
                local petHealth = UnitHealth("pet") or 0
                local petMaxHealth = UnitHealthMax("pet") or 1
                local healthPct = math.floor(petHealth / petMaxHealth * 100)
                WoWCultivation:Print(string.format("|cFF44AAFF灵宠·%s|r Lv.%d 气血: %d%%",
                    petName, petLevel, healthPct))
            else
                WoWCultivation:Print("|cFFFFD700灵宠未召唤，你可以前往兽栏管理员处领取~|r")
            end
        end
    end
end

-- ============================================================
-- Get Current Player Data (for Divine Sense)
-- ============================================================
function UI:GetCurrentPlayerData()
    local data = {
        name = UnitName("player") or "未知",
        realm = "凡人", sect = "散修", spiritRoot = "未知灵根", daoPoints = 0,
    }
    local RealmModule = WoWCultivation.Modules and WoWCultivation.Modules.RealmModule
    if RealmModule and RealmModule.GetRealm then
        data.realm = RealmModule:GetRealm() or "凡人"
    end
    local SectModule = WoWCultivation.Modules and WoWCultivation.Modules.SectModule
    if SectModule and SectModule.GetSect then
        data.sect = SectModule:GetSect() or "散修"
    end
    if SectModule and SectModule.GetSpiritRoot then
        data.spiritRoot = SectModule:GetSpiritRoot() or "未知灵根"
    end
    return data
end

-- ============================================================
-- Refresh Info
-- ============================================================
function UI:RefreshInfo()
    -- Status bar
    if self.statusText then
        local realmName = "凡人"
        local RealmModule = WoWCultivation.Modules and WoWCultivation.Modules.RealmModule
        if RealmModule and RealmModule.GetRealm then
            realmName = RealmModule:GetRealm() or "凡人"
        end

        local topStones, midStones, lowStones = 0, 0, 0
        local CurrencyModule = WoWCultivation.Modules and WoWCultivation.Modules.CurrencyModule
        if CurrencyModule and CurrencyModule.GetSpiritStones then
            topStones, midStones, lowStones = CurrencyModule:GetSpiritStones()
        end

        local destinyVal = 0
        local DestinyModule = WoWCultivation.Modules and WoWCultivation.Modules.ImmortalDestinyModule
        if DestinyModule then
            destinyVal = DestinyModule:GetValue()
        end

        local faction = UnitFactionGroup("player") or ""
        local realmStr = faction == "Horde" and "灵界" or faction == "Alliance" and "天界" or "未知"

        self.statusText:SetText(
            "|cFFAA44FF境界: " .. realmName .. "|r  |cFF666666‖|r  "
            .. "|cFFFFD700灵石: " .. BreakUpLargeNumbers(topStones) .. "/" .. BreakUpLargeNumbers(midStones) .. "/" .. BreakUpLargeNumbers(lowStones) .. "|r  |cFF666666‖|r  "
            .. "|cFF44AAFF仙缘: " .. BreakUpLargeNumbers(destinyVal) .. "|r"
        )
    end

    -- Row 2 - Refresh professions
    self:RefreshRow2()

    -- Update 仙域冲突 button label based on faction
    if self.row3Buttons and self.row3Buttons.bg then
        local faction = UnitFactionGroup("player") or ""
        local label = self.row3Buttons.bg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        -- Update existing label
        for _, child in ipairs({self.row3Buttons.bg:GetRegions()}) do
            if child and child.GetObjectType and child:GetObjectType() == "FontString" then
                local factionName = faction == "Horde" and "灵界" or faction == "Alliance" and "天界" or ""
                if factionName ~= "" then
                    child:SetText("|cFFEEDDAA" .. factionName .. "冲突|r")
                end
                break
            end
        end
    end
end

function UI:RefreshRow2()
    if not self.row2Container then return end

    -- Clear old buttons
    for _, btn in pairs(self.row2Buttons) do
        btn:Hide()
    end

    local profs = {}
    if WoWCultivation.Modules and WoWCultivation.Modules.ProfessionModule then
        profs = WoWCultivation.Modules.ProfessionModule:GetPlayerProfessions() or {}
    end

    if #profs == 0 then
        if self.row2Title then
            self.row2Title:SetText("|cFFFFD700◆ 修仙百艺 ◆|r |cFF888888（尚未学习）|r")
        end
        return
    end

    if self.row2Title then
        self.row2Title:SetText("|cFFFFD700◆ 修仙百艺 ◆|r")
    end

    local btnW = 150
    local btnH = 28
    local cols = 3
    local gap = 8
    local startX = 0

    for i, prof in ipairs(profs) do
        local row = math.floor((i - 1) / cols)
        local col = (i - 1) % cols
        local xOff = startX + col * (btnW + gap)
        local yOff = 0 - row * (btnH + 4)

        local btn = self.row2Buttons[i]
        if not btn then
            btn = CreateFrame("Button", nil, self.row2Container, "BackdropTemplate")
            btn:SetSize(btnW, btnH)
            btn:SetBackdrop({
                bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tileSize = 8, edgeSize = 8,
                insets = { left = 2, right = 2, top = 2, bottom = 2 }
            })
            btn:SetBackdropColor(0.06, 0.03, 0.1, 0.8)
            btn:SetBackdropBorderColor(0.5, 0.35, 0.08, 0.6)

            local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            btnText:SetPoint("CENTER", btn, "CENTER", 0, 0)
            btn.textWidget = btnText

            btn:SetScript("OnEnter", function(self)
                self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
            end)
            btn:SetScript("OnLeave", function(self)
                self:SetBackdropBorderColor(0.5, 0.35, 0.08, 0.6)
            end)

            self.row2Buttons[i] = btn
        end

        btn:SetPoint("TOPLEFT", self.row2Container, "TOPLEFT", xOff, yOff)
        btn:Show()

        -- Determine if gathering or crafting
        local isGather = false
        local gatherType = nil
        if prof.wowName == "草药学" or prof.wowName == "草药" or prof.xiuxianName == "灵植采集" then
            isGather = true; gatherType = "herb"
        elseif prof.wowName == "采矿" or prof.xiuxianName == "灵矿开采" then
            isGather = true; gatherType = "mine"
        elseif prof.wowName == "剥皮" or prof.xiuxianName == "妖兽取材" then
            isGather = true; gatherType = "skin"
        end

        -- 通过 skillLine ID 兜底判断采集类
        if not isGather and prof.skillLine then
            if prof.skillLine == 182 or prof.skillLine == 755 then
                isGather = true; gatherType = "herb"
            elseif prof.skillLine == 186 or prof.skillLine == 762 then
                isGather = true; gatherType = "mine"
            elseif prof.skillLine == 393 then
                isGather = true; gatherType = "skin"
            end
        end

        -- Get skill level
        local skillLevel = "?"
        for j = 1, GetNumSkillLines() do
            local sn, isH, _, sr = GetSkillLineInfo(j)
            if not isH and (sn == prof.wowName) then
                skillLevel = sr
                break
            end
        end

        local labelText = "|cFFEEDDAA" .. prof.xiuxianName .. "|r |cFF888888" .. skillLevel .. "|r"
        if isGather then
            labelText = "|cFF1EFF00" .. prof.xiuxianName .. "|r |cFF888888Lv." .. skillLevel .. "|r"
        end

        btn.textWidget:SetText(labelText)

        local pData = { wowName = prof.wowName, xiuxianName = prof.xiuxianName, isGather = isGather, gatherType = gatherType }
        btn:SetScript("OnClick", function()
            UI:OnProfClick(pData)
        end)
    end
end

-- ============================================================
-- Toggle / Show / Hide
-- ============================================================
function UI:Toggle()
    if not self.frame then return end
    if self.frame:IsShown() and self.frame:GetAlpha() > 0.5 then
        self:Hide()
    else
        self:Show()
    end
end

function UI:Show()
    if not self.frame then return end
    self:RefreshInfo()
    self.frame:SetAlpha(1)
    self.frame:Show()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
    if self.gatherPanel then self.gatherPanel:Hide() end
end

function UI:IsShown()
    return self.frame and self.frame:IsShown()
end
