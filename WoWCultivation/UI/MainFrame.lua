-- ============================================================
-- MainFrame.lua - 修仙宝典（原修仙录）
-- 重新设计布局: 法宝/机缘/师门/功法 + 生活技能 + 功能入口
-- 目标版本: 3.80.1 — BackdropTemplate
-- ============================================================
local UI = {}
UI.name = "MainFrame"
WoWCultivation.UI.MainFrame = UI

UI.FRAME_WIDTH = 520
UI.FRAME_HEIGHT = 640

-- Row 1: 修仙根基（核心+随身功能）
UI.ROW1_BUTTONS = {
    { id = "treasure",   name = "法宝",   icon = "Interface\\Icons\\INV_Chest_Chain_03", sub = "装备信息", action = "equipment" },
    { id = "quest",      name = "机缘",   icon = "Interface\\Icons\\INV_Misc_Book_03",  sub = "任务日志", action = "questlog" },
    { id = "sect",       name = "宗门",   icon = "Interface\\Icons\\INV_Banner_01",    sub = "宗门帮派", action = "guild" },
    { id = "technique",  name = "功法",   icon = "Interface\\Icons\\INV_Misc_Book_09", sub = "法术书",   action = "spellbook" },
    { id = "storage",    name = "储物袋", icon = "Interface\\Icons\\INV_Misc_Bag_10_Green",             sub = "随身行囊",   action = "storage" },
    { id = "mount",      name = "灵骑",   icon = "Interface\\Icons\\Ability_Mount_Charger",              sub = "坐骑收藏",   action = "mount_journal" },
    { id = "spiritpet",  name = "灵宠",   icon = "Interface\\Icons\\Ability_Hunter_BeastCall",           sub = "本命灵宠",   action = "spiritpet", hunterOnly = true },
}

-- Row 3: 仙途指引
UI.ROW3_BUTTONS = {
    { id = "fishing",    name = "灵钓宝鉴",   icon = "Interface\\Icons\\INV_Misc_Fish_02",                   sub = "钓鱼指引",   action = "fishing" },
    { id = "bg",         name = "仙域冲突",   icon = "Interface\\Icons\\Ability_Warrior_OffensiveStance", sub = "排战场",     action = "random_bg" },
    { id = "arena",      name = "斗法台",     icon = "Interface\\Icons\\Ability_DualWield",                 sub = "竞技排队",   action = "arena" },
    { id = "dungeon",    name = "秘境夺宝",   icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Blue",        sub = "随机副本",   action = "dungeon_finder" },
    { id = "achievement",name = "道果录",     icon = "Interface\\Icons\\INV_Misc_Book_09",                  sub = "修行成就",   action = "achievement" },
    { id = "treasure2",  name = "灵宝鉴",     icon = "Interface\\Icons\\INV_Chest_Chain_03",                sub = "灵宝图鉴",   action = "treasure_frame" },
}

-- Row 4: 道法玄机
UI.ROW4_BUTTONS = {
    { id = "divinesense",name = "神识探查",   icon = "Interface\\Icons\\Spell_Holy_MindVision",              sub = "探查道友",   action = "divinesense" },
    { id = "meditation", name = "闭关修炼",   icon = "Interface\\Icons\\Spell_Nature_Meditation",           sub = "闭关打坐",   action = "meditation" },
    { id = "channel",    name = "万里传音",   icon = "Interface\\Icons\\Spell_Holy_MindVision",              sub = "修仙频道",   action = "channel" },
}

-- 采集物数据: 技能要求 → 采集物列表（含分布地点+图标）
-- 图标路径来源: dvg.cn 80级WLK数据库
UI.GATHER_DATA = {
    herb = {
        title = "灵植采集",
        items = {
            { skill = 1,   name = "宁神花",       zone = "各族新手区域",           icon = "Interface\\Icons\\INV_Misc_Flower_02" },
            { skill = 1,   name = "银叶草",       zone = "各族新手区域",           icon = "Interface\\Icons\\INV_Misc_Herb_09" },
            { skill = 1,   name = "地根草",       zone = "各族新手区域",           icon = "Interface\\Icons\\INV_Misc_Root_01" },
            { skill = 50,  name = "魔皇草",       zone = "银松森林/贫瘠之地",     icon = "Interface\\Icons\\INV_Misc_Herb_07" },
            { skill = 50,  name = "石南草",       zone = "银松森林/贫瘠之地",     icon = "Interface\\Icons\\INV_Misc_Herb_04" },
            { skill = 70,  name = "雨燕草",       zone = "贫瘠之地(荆棘藻旁)",     icon = "Interface\\Icons\\INV_Misc_Herb_03" },
            { skill = 100, name = "跌打草",       zone = "暮色森林/湿地",         icon = "Interface\\Icons\\INV_Misc_Leaf_01" },
            { skill = 100, name = "荆棘藻",       zone = "各水域岸边",             icon = "Interface\\Icons\\INV_Misc_Herb_10" },
            { skill = 125, name = "野钢花",       zone = "荆棘谷/阿拉希高地",     icon = "Interface\\Icons\\INV_Misc_Flower_03" },
            { skill = 150, name = "皇血草",       zone = "荆棘谷/悲伤沼泽",       icon = "Interface\\Icons\\INV_Misc_Herb_05" },
            { skill = 160, name = "活根草",       zone = "悲伤沼泽/安戈洛环形山", icon = "Interface\\Icons\\INV_Misc_Root_02" },
            { skill = 170, name = "卡德加的胡须", zone = "悲伤沼泽/辛特兰",       icon = "Interface\\Icons\\INV_Misc_Herb_06" },
            { skill = 185, name = "枯叶草",       zone = "塔纳利斯/辛特兰",       icon = "Interface\\Icons\\INV_Misc_Herb_11" },
            { skill = 205, name = "金棘草",       zone = "燃烧平原/灼热峡谷",     icon = "Interface\\Icons\\INV_Misc_Herb_12" },
            { skill = 230, name = "太阳草",       zone = "燃烧平原/灼热峡谷",     icon = "Interface\\Icons\\INV_Misc_Herb_13" },
            { skill = 250, name = "盲目草",       zone = "安戈洛环形山/费伍德森林", icon = "Interface\\Icons\\INV_Misc_Herb_14" },
            { skill = 260, name = "格罗姆之血",   zone = "费伍德森林/诅咒之地",   icon = "Interface\\Icons\\INV_Misc_Herb_15" },
            { skill = 285, name = "黄金参",       zone = "希利苏斯/东瘟疫之地",   icon = "Interface\\Icons\\INV_Misc_Herb_16" },
            { skill = 290, name = "梦叶草",       zone = "希利苏斯/东瘟疫之地",   icon = "Interface\\Icons\\INV_Misc_Herb_17" },
            { skill = 300, name = "山鼠草",       zone = "东瘟疫之地/希利苏斯",   icon = "Interface\\Icons\\INV_Misc_Herb_19" },
            { skill = 300, name = "冰盖草",       zone = "冬泉谷",                 icon = "Interface\\Icons\\INV_Misc_Herb_18" },
            { skill = 325, name = "魔草",         zone = "地狱火半岛/赞加沼泽",   icon = "Interface\\Icons\\INV_Misc_Herb_20" },
            { skill = 350, name = "噩梦藤",       zone = "影月谷/虚空风暴",       icon = "Interface\\Icons\\INV_Misc_Herb_22" },
            { skill = 375, name = "泰罗果",       zone = "影月谷",                 icon = "Interface\\Icons\\INV_Misc_Herb_21" },
            { skill = 425, name = "金苜蓿",       zone = "北风苔原/嚎风峡湾",     icon = "Interface\\Icons\\INV_Misc_Herb_25" },
            { skill = 450, name = "冰棘",         zone = "冰冠冰川/风暴峭壁",     icon = "Interface\\Icons\\INV_Misc_Herb_27" },
        }
    },
    mine = {
        title = "灵矿开采",
        items = {
            { skill = 1,   name = "铜矿石",   zone = "各族新手区域",             icon = "Interface\\Icons\\INV_Ore_Copper_01" },
            { skill = 65,  name = "锡矿石",   zone = "银松森林/贫瘠之地",       icon = "Interface\\Icons\\INV_Ore_Tin_01" },
            { skill = 75,  name = "银矿石",   zone = "锡矿重生点随机",           icon = "Interface\\Icons\\INV_Ore_Silver_01" },
            { skill = 125, name = "铁矿石",   zone = "阿拉希高地/荆棘谷",       icon = "Interface\\Icons\\INV_Ore_Iron_01" },
            { skill = 155, name = "金矿石",   zone = "铁矿重生点随机",           icon = "Interface\\Icons\\INV_Ore_Gold_01" },
            { skill = 175, name = "秘银矿石", zone = "灼热峡谷/辛特兰",         icon = "Interface\\Icons\\INV_Ore_Mithril_01" },
            { skill = 230, name = "真银矿石", zone = "秘银/瑟银重生点随机",     icon = "Interface\\Icons\\INV_Ore_Truesilver_01" },
            { skill = 245, name = "瑟银矿石", zone = "燃烧平原/希利苏斯",       icon = "Interface\\Icons\\INV_Ore_Thorium_01" },
            { skill = 300, name = "魔铁矿石", zone = "地狱火半岛/赞加沼泽",     icon = "Interface\\Icons\\INV_Ore_FelIron" },
            { skill = 325, name = "精金矿石", zone = "纳格兰/刀锋山",           icon = "Interface\\Icons\\INV_Ore_Adamantium" },
            { skill = 350, name = "氪金矿石", zone = "外域各矿脉随机产出",       icon = "Interface\\Icons\\INV_Ore_Khorium" },
            { skill = 375, name = "钴矿石",   zone = "北风苔原/嚎风峡湾",       icon = "Interface\\Icons\\INV_Ore_Cobalt" },
            { skill = 400, name = "萨隆邪铁", zone = "龙骨荒野/灰熊丘陵/祖达克", icon = "Interface\\Icons\\INV_Ore_Saronite" },
            { skill = 450, name = "泰坦矿石", zone = "冰冠冰川/风暴峭壁(稀有)", icon = "Interface\\Icons\\INV_Ore_Titanium" },
        }
    },
    skin = {
        title = "妖兽取材",
        items = {
            { skill = 1,   name = "轻皮",       zone = "各族新手区域野兽",         icon = "Interface\\Icons\\INV_Misc_LeatherScrap_04" },
            { skill = 25,  name = "轻毛皮",     zone = "各族新手区域野兽(低概率)", icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_02" },
            { skill = 100, name = "中皮",       zone = "暮色森林狼人/赤脊山",     icon = "Interface\\Icons\\INV_Misc_LeatherScrap_06" },
            { skill = 100, name = "中毛皮",     zone = "暮色森林狼人(低概率)",     icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_02" },
            { skill = 150, name = "重皮",       zone = "荆棘谷猛兽/阿拉希高地",   icon = "Interface\\Icons\\INV_Misc_LeatherScrap_07" },
            { skill = 150, name = "重毛皮",     zone = "荆棘谷猛兽(低概率)",       icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_02" },
            { skill = 200, name = "厚皮",       zone = "塔纳利斯/安戈洛环形山",   icon = "Interface\\Icons\\INV_Misc_LeatherScrap_08" },
            { skill = 200, name = "厚毛皮",     zone = "塔纳利斯野兽(低概率)",     icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_03" },
            { skill = 250, name = "硬甲皮",     zone = "希利苏斯/冬泉谷",         icon = "Interface\\Icons\\INV_Misc_LeatherScrap_09" },
            { skill = 250, name = "硬甲毛皮",   zone = "希利苏斯/冬泉谷(低概率)", icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_04" },
            { skill = 300, name = "结缔皮",     zone = "外域各区域野兽",           icon = "Interface\\Icons\\INV_Misc_LeatherScrap_12" },
            { skill = 325, name = "重结缔皮",   zone = "纳格兰/刀锋山野兽",       icon = "Interface\\Icons\\INV_Misc_LeatherScrap_13" },
            { skill = 350, name = "北地皮",     zone = "北风苔原/嚎风峡湾野兽",   icon = "Interface\\Icons\\INV_Misc_LeatherScrap_15" },
            { skill = 425, name = "重北地皮",   zone = "冰冠冰川/风暴峭壁野兽",   icon = "Interface\\Icons\\INV_Misc_LeatherScrap_16" },
        }
    },
    fish = {
        title = "灵钓宝鉴",
        items = {
            { skill = 1,   name = "美味小鱼",       zone = "各族新手区域" },
            { skill = 1,   name = "长嘴泥鳅",       zone = "各初级水域" },
            { skill = 50,  name = "刺须鲶鱼",       zone = "西部荒野/贫瘠之地/银松森林" },
            { skill = 75,  name = "小口鲤鱼",       zone = "湿地/希尔斯布莱德丘陵" },
            { skill = 100, name = "白鳞鲑鱼",       zone = "阿拉希高地/荆棘谷" },
            { skill = 130, name = "石鳞鳕鱼",       zone = "荆棘谷/悲伤沼泽" },
            { skill = 150, name = "大师级杂鱼",     zone = "塔纳利斯/菲拉斯" },
            { skill = 175, name = "红鳃鱼",         zone = "辛特兰/灼热峡谷" },
            { skill = 200, name = "阳鳞鲑鱼",       zone = "燃烧平原/东瘟疫之地" },
            { skill = 225, name = "夜鳞鲷鱼",       zone = "东瘟疫之地/冬泉谷" },
            { skill = 250, name = "电鳗",           zone = "东瘟疫之地(斯坦索姆旁)" },
            { skill = 300, name = "魔鲈鱼",         zone = "地狱火半岛/赞加沼泽" },
            { skill = 305, name = "刺鳃鲑鱼",       zone = "赞加沼泽/泰罗卡森林" },
            { skill = 325, name = "菲格鲁泥鱼",     zone = "纳格兰/泰罗卡森林" },
            { skill = 350, name = "狂暴龙虾",       zone = "泰罗卡森林(高地鱼群)" },
            { skill = 380, name = "冰鳍鱼",         zone = "北风苔原/嚎风峡湾" },
            { skill = 400, name = "深海鳗鱼",       zone = "龙骨荒野/灰熊丘陵" },
            { skill = 430, name = "月光墨鱼",       zone = "祖达克/索拉查盆地" },
            { skill = 450, name = "皇张大比目鱼",   zone = "冰冠冰川/风暴峭壁" },
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
    self:CreateAttributePanel(f)
    self:CreateRow1(f)
    self:CreateRow2(f)
    self:CreateRow3(f)
    self:CreateRow4(f)
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
    title:SetText("|cFFFFD700◆ 修 仙 宝 典 ◆|r")
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
-- Attribute Panel - 修仙化属性汇总
-- ============================================================
UI.ATTR_NAMES = {
    { stat = "strength",     name = "力道",   color = "|cFFFF4444" },
    { stat = "agility",      name = "灵巧",   color = "|cFF44FF44" },
    { stat = "stamina",      name = "根骨",   color = "|cFFFF8800" },
    { stat = "intellect",    name = "悟性",   color = "|cFF4488FF" },
    { stat = "spirit",       name = "神识",   color = "|cFF8844FF" },
    { stat = "attackPower",  name = "战力",   color = "|cFFFF6600" },
    { stat = "spellPower",   name = "灵力",   color = "|cFF44AAFF" },
    { stat = "moveSpeed",    name = "身法",   color = "|cFF1EFF00" },
}

function UI:CreateAttributePanel(parent)
    local ap = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    ap:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -84)
    ap:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -14, -84)
    ap:SetHeight(22)
    ap:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    ap:SetBackdropColor(0.04, 0.02, 0.08, 0.7)
    ap:SetBackdropBorderColor(0.4, 0.3, 0.06, 0.5)

    local attrText = ap:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    attrText:SetPoint("LEFT", ap, "LEFT", 8, 0)
    attrText:SetPoint("RIGHT", ap, "RIGHT", -8, 0)
    attrText:SetJustifyH("LEFT")
    attrText:SetText("|cFF888888属性加载中...|r")
    self.attrText = attrText
    self.attrPanel = ap
end

function UI:RefreshAttributePanel()
    if not self.attrText then return end

    local parts = {}
    for _, attr in ipairs(UI.ATTR_NAMES) do
        local value = self:GetAttributeValue(attr.stat)
        if value and value > 0 then
            table.insert(parts, attr.color .. attr.name .. ": " .. value .. "|r")
        end
    end

    if #parts > 0 then
        self.attrText:SetText(table.concat(parts, "  "))
    else
        self.attrText:SetText("|cFF888888属性加载中...|r")
    end
end

function UI:GetAttributeValue(stat)
    if stat == "strength" then
        local ok, val = pcall(function() return select(2, UnitStat("player", 1)) end)
        return ok and val or 0
    elseif stat == "agility" then
        local ok, val = pcall(function() return select(2, UnitStat("player", 2)) end)
        return ok and val or 0
    elseif stat == "stamina" then
        local ok, val = pcall(function() return select(2, UnitStat("player", 3)) end)
        return ok and val or 0
    elseif stat == "intellect" then
        local ok, val = pcall(function() return select(2, UnitStat("player", 4)) end)
        return ok and val or 0
    elseif stat == "spirit" then
        local ok, val = pcall(function() return select(2, UnitStat("player", 5)) end)
        return ok and val or 0
    elseif stat == "attackPower" then
        local ok, base, posBuff, negBuff = pcall(UnitAttackPower, "player")
        if ok then return (base or 0) + (posBuff or 0) + (negBuff or 0) end
        return 0
    elseif stat == "spellPower" then
        local ok, sp = pcall(function()
            return GetSpellBonusDamage and GetSpellBonusDamage(2) or 0
        end)
        return ok and sp or 0
    elseif stat == "moveSpeed" then
        local ok, speed = pcall(function()
            return math.floor((GetUnitSpeed and GetUnitSpeed("player") or 7) / 7 * 100)
        end)
        return ok and speed or 100
    end
    return 0
end

-- ============================================================
-- Row 1: 法宝 / 机缘 / 宗门 / 功法 / 储物袋 / 灵骑 / 灵宠
-- ============================================================
function UI:CreateRow1(parent)
    local titleLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -96)
    titleLabel:SetText("|cFFFFD700◆ 修仙根基 ◆|r")

    local startY = -116
    local btnW = 64
    local btnH = 78
    local gap = 6
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
        icon:SetSize(32, 32)
        icon:SetPoint("TOP", btn, "TOP", 0, -8)
        icon:SetTexture(btnData.icon)

        local nameLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        nameLabel:SetPoint("TOP", icon, "BOTTOM", 0, -3)
        nameLabel:SetText("|cFFFFD700" .. btnData.name .. "|r")

        btn:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        end)
        btn:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)
        end)
        btn:SetScript("OnClick", function()
            UI:OnRow1Click(btnData.action)
        end)

        -- Hide hunter-only buttons for non-hunters
        if btnData.hunterOnly then
            local _, englishClass = UnitClass("player")
            if englishClass ~= "HUNTER" then
                btn:Hide()
            end
        end

        self["row1_" .. btnData.id] = btn
    end
end

-- ============================================================
-- Row 2: 生活技能
-- ============================================================
function UI:CreateRow2(parent)
    local titleLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -202)
    titleLabel:SetText("|cFFFFD700◆ 修仙百艺 ◆|r")
    self.row2Title = titleLabel

    self.row2Container = CreateFrame("Frame", nil, parent)
    self.row2Container:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -222)
    self.row2Container:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -14, -222)
    self.row2Container:SetHeight(70)
    self.row2Buttons = {}
end

-- ============================================================
-- Row 3: 仙途指引
-- ============================================================
function UI:CreateRow3(parent)
    local titleLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -305)
    titleLabel:SetText("|cFFFFD700◆ 仙途指引 ◆|r")

    local startY = -325
    local btnSize = 50
    local btnGap = 6
    local cols = 8
    local startX = 14
    self.row3Buttons = {}

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

        self.row3Buttons[btnData.id] = btn
    end
end

-- ============================================================
-- Row 4: 道法玄机
-- ============================================================
function UI:CreateRow4(parent)
    local titleLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -390)
    titleLabel:SetText("|cFFFFD700◆ 道法玄机 ◆|r")

    local startY = -410
    local btnSize = 50
    local btnGap = 6
    local startX = 14
    self.row4Buttons = {}

    for i, btnData in ipairs(UI.ROW4_BUTTONS) do
        local xOff = startX + (i - 1) * (btnSize + btnGap)

        local btn = CreateFrame("Button", "WoWCultivationRow4_" .. btnData.id, parent, "BackdropTemplate")
        btn:SetSize(btnSize, btnSize)
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
            UI:OnRow4Click(btnData.action)
        end)

        self.row4Buttons[btnData.id] = btn
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
    local targetSkillID = gatherType == "herb" and 182 or gatherType == "mine" and 186 or gatherType == "skin" and 393 or gatherType == "fish" and 356 or 0

    -- 方法1: 通过技能ID匹配
    for i = 1, GetNumSkillLines() do
        local skillName, isHeader, _, skillRank, _, _, _, _, _, _, _, skillID = GetSkillLineInfo(i)
        if not isHeader then
            if skillID == targetSkillID then
                skillLevel = skillRank or 0
                break
            end
        end
    end

    -- 方法2: 通过技能名称匹配
    if skillLevel == 0 then
        local skillNames = {
            herb = { "草药学", "草药" },
            mine = { "采矿", "矿业" },
            skin = { "剥皮" },
            fish = { "钓鱼" },
        }
        local names = skillNames[gatherType] or {}
        for i = 1, GetNumSkillLines() do
            local skillName, isHeader, _, skillRank = GetSkillLineInfo(i)
            if not isHeader and skillName and skillRank and skillRank > 0 then
                for _, n in ipairs(names) do
                    if skillName == n then
                        skillLevel = skillRank
                        break
                    end
                end
                if skillLevel > 0 then break end
            end
        end
    end

    gp.skillText:SetText("当前技能: |cFF1EFF00" .. skillLevel .. "|r")

    -- Clear old item frames
    for _, frame in ipairs(gp.itemFrames) do
        frame:Hide()
    end

    -- Create item list (icon + skill + name + zone)
    local yOffset = -8
    for i, item in ipairs(data.items) do
        local itemFrame
        if gp.itemFrames[i] then
            itemFrame = gp.itemFrames[i]
            itemFrame:Show()
        else
            itemFrame = CreateFrame("Frame", nil, gp.contentBg)
            itemFrame:SetSize(310, 20)
            itemFrame:SetPoint("TOPLEFT", gp.contentBg, "TOPLEFT", 4, 0)

            -- 图标 - 放在技能等级的位置(替换方框)
            local iconTex = itemFrame:CreateTexture(nil, "ARTWORK")
            iconTex:SetSize(16, 16)
            iconTex:SetPoint("LEFT", itemFrame, "LEFT", 2, 0)
            itemFrame.iconTex = iconTex

            local skillText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            skillText:SetPoint("LEFT", itemFrame, "LEFT", 22, 0)
            skillText:SetWidth(36)
            skillText:SetJustifyH("RIGHT")
            itemFrame.skillText = skillText

            local nameText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            nameText:SetPoint("LEFT", itemFrame, "LEFT", 62, 0)
            nameText:SetWidth(80)
            nameText:SetJustifyH("LEFT")
            itemFrame.nameText = nameText

            local zoneText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            zoneText:SetPoint("LEFT", itemFrame, "LEFT", 144, 0)
            zoneText:SetPoint("RIGHT", itemFrame, "RIGHT", -4, 0)
            zoneText:SetJustifyH("LEFT")
            itemFrame.zoneText = zoneText

            gp.itemFrames[i] = itemFrame
        end

        local unlocked = skillLevel >= item.skill
        local color = unlocked and "|cFF1EFF00" or "|cFFFF0000"

        -- 图标：优先使用硬编码icon字段，其次用GetItemInfo运行时获取
        if item.icon then
            pcall(function() itemFrame.iconTex:SetTexture(item.icon) end)
            itemFrame.iconTex:Show()
        else
            local iconPath = nil
            pcall(function()
                local _, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(item.name)
                if itemTexture then
                    iconPath = itemTexture
                else
                    -- 鱼类尝试"新鲜的"前缀
                    if gatherType == "fish" then
                        local _, _, _, _, _, _, _, _, _, altTexture = GetItemInfo("新鲜的" .. item.name)
                        if altTexture then iconPath = altTexture end
                    end
                end
            end)

            if iconPath then
                itemFrame.iconTex:SetTexture(iconPath)
            else
                local defaultIcons = {
                    herb = "Interface\\Icons\\INV_Misc_Herb_15",
                    mine = "Interface\\Icons\\INV_Ore_Copper_01",
                    skin = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
                    fish = "Interface\\Icons\\INV_Misc_Fish_02",
                }
                pcall(function() itemFrame.iconTex:SetTexture(defaultIcons[gatherType] or "") end)
            end
            itemFrame.iconTex:Show()
        end

        itemFrame.skillText:SetText(color .. item.skill .. "|r")
        itemFrame.nameText:SetText(color .. " " .. item.name .. "|r")
        itemFrame.zoneText:SetText("|cFF88CCFF" .. (item.zone or "") .. "|r")
        itemFrame:SetPoint("TOPLEFT", gp.contentBg, "TOPLEFT", 4, yOffset)
        yOffset = yOffset - 22
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
    elseif action == "storage" then
        pcall(function()
            if ToggleAllBags then
                ToggleAllBags()
            elseif OpenAllBags then
                OpenAllBags()
            elseif OpenBackpack then
                OpenBackpack()
            end
        end)
    elseif action == "mount_journal" then
        pcall(function()
            if ToggleCollectionsJournal then
                ToggleCollectionsJournal(1)
            elseif CollectionsJournal then
                CollectionsJournal:Show()
            end
        end)
    elseif action == "spiritpet" then
        local _, englishClass = UnitClass("player")
        if englishClass == "HUNTER" then
            pcall(function()
                if TogglePetStable then
                    TogglePetStable()
                elseif PetStableFrame then
                    PetStableFrame:Show()
                elseif ToggleCharacter then
                    ToggleCharacter("PetPaperDollFrame")
                end
            end)
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
    if action == "fishing" then
        if WoWCultivation.UI and WoWCultivation.UI.FishingFrame then
            WoWCultivation.UI.FishingFrame:Toggle()
        end
    elseif action == "random_bg" then
        -- 天界冲突：打开PVP排队界面（排战场）
        pcall(function()
            if TogglePVPUI then
                TogglePVPUI()
            elseif PVPUIFrame then
                if PVPUIFrame:IsShown() then PVPUIFrame:Hide() else PVPUIFrame:Show() end
            elseif PVPMicroButton then
                PVPMicroButton:Click()
            end
        end)
    elseif action == "arena" then
        -- 斗法台：打开竞技场排队界面
        pcall(function()
            if TogglePVPUI then
                TogglePVPUI()
            elseif PVPUIFrame then
                if PVPUIFrame:IsShown() then PVPUIFrame:Hide() else PVPUIFrame:Show() end
            elseif PVPParentFrame then
                PVPParentFrame:Show()
            end
        end)
    elseif action == "dungeon_finder" then
        pcall(function()
            if PVEFrame_ToggleFrame then
                PVEFrame_ToggleFrame("GroupFinderFrame", "LFDParentFrame")
            elseif ToggleLFDParent then
                ToggleLFDParent()
            elseif LFDParentFrame then
                if LFDParentFrame:IsShown() then
                    LFDParentFrame:Hide()
                else
                    LFDParentFrame:Show()
                end
            end
        end)
    elseif action == "achievement" then
        if ToggleAchievementFrame then
            ToggleAchievementFrame()
        end
    elseif action == "treasure_frame" then
        if WoWCultivation.UI and WoWCultivation.UI.TreasureFrame then
            WoWCultivation.UI.TreasureFrame:Toggle()
        end
    end
end

-- ============================================================
-- Row 4 Click Handlers
-- ============================================================
function UI:OnRow4Click(action)
    if action == "divinesense" then
        if WoWCultivation.UI and WoWCultivation.UI.DivineSenseFrame then
            local data = self:GetCurrentPlayerData()
            WoWCultivation.UI.DivineSenseFrame:Show(data)
        end
    elseif action == "meditation" then
        if WoWCultivation.UI and WoWCultivation.UI.MeditationFrame then
            WoWCultivation.UI.MeditationFrame:Toggle()
        end
    elseif action == "channel" then
        if WoWCultivation.Modules and WoWCultivation.Modules.ChannelModule then
            WoWCultivation:Print("已切换至万里传音频道")
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

    -- Attribute panel
    self:RefreshAttributePanel()

    -- Row 2 - Refresh professions
    self:RefreshRow2()
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
        elseif prof.wowName == "钓鱼" or prof.wowName == "Fishing" or prof.xiuxianName == "灵钓宝鉴" then
            isGather = true; gatherType = "fish"
        end

        -- 通过 skillLine ID 兜底判断采集类
        if not isGather and prof.skillLine then
            if prof.skillLine == 182 or prof.skillLine == 755 then
                isGather = true; gatherType = "herb"
            elseif prof.skillLine == 186 or prof.skillLine == 762 then
                isGather = true; gatherType = "mine"
            elseif prof.skillLine == 393 then
                isGather = true; gatherType = "skin"
            elseif prof.skillLine == 356 then
                isGather = true; gatherType = "fish"
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
