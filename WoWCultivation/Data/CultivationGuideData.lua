-- ============================================================
-- CultivationGuideData.lua - 修炼指引数据
-- 基于 WotLK 3.3.5 练级路线，提供分阶段修炼指导
-- ============================================================
local Guide = {}
WoWCultivation.Data.CultivationGuide = Guide

-- ============================================================
-- 练级指引：按等级区间给出最佳修炼地图
-- ============================================================
Guide.ZONE_GUIDE = {
    [1] = {
        range = "1-10",
        title = "炼气入门",
        alliance = { zone = "艾尔文森林 / 丹莫罗 / 泰达希尔", tip = "完成出生地任务，熟悉基础功法" },
        horde = { zone = "杜隆塔尔 / 提瑞斯法林地 / 莫高雷", tip = "完成出生地任务，熟悉基础功法" },
        general = "新入修仙界，先完成门派（种族）初始任务，修得基础功法。建议顺道采集灵草矿石，为日后炼丹铸器储备材料。",
    },
    [2] = {
        range = "10-20",
        title = "筑基期",
        alliance = { zone = "西部荒野 → 洛克莫丹", tip = "西部荒野任务线奖励优质法器" },
        horde = { zone = "银松森林 → 贫瘠之地", tip = "贫瘠之地任务丰富，可快速积累灵石" },
        general = "筑基阶段可尝试组队进入「怒焰裂谷」(13-18) 和「死亡矿井」(15-20) 秘境夺宝。记得在拍卖行购买几个小包裹扩充储物袋。",
        dungeon = "死亡矿井(15-20) / 怒焰裂谷(13-18) / 哀嚎洞穴(17-24)",
    },
    [3] = {
        range = "20-30",
        title = "开光期",
        alliance = { zone = "赤脊山 → 暮色森林", tip = "暮色森林任务集中，经验丰厚" },
        horde = { zone = "石爪山脉 → 灰谷", tip = "灰谷任务链经验不菲" },
        general = "开光期可挑战「影牙城堡」(18-25)、「黑暗深渊」(20-30) 秘境。30级即可学习骑术，灵石储备要跟上！",
        dungeon = "影牙城堡(18-25) / 黑暗深渊(20-30) / 剃刀沼泽(25-35)",
    },
    [4] = {
        range = "30-40",
        title = "融合期",
        alliance = { zone = "南海镇 → 阿拉希高地", tip = "南海镇任务密集高效" },
        horde = { zone = "千针石林 → 荆棘谷(北)", tip = "荆棘谷大量任务,+PVP注意安全" },
        general = "融合期秘境推荐「血色修道院」(30-40)，四大区域可反复刷取。开始关注拍卖行，出售多余灵药矿石换取灵石。",
        dungeon = "血色修道院(30-40) / 剃刀高地(35-45) / 玛拉顿(38-50)",
    },
    [5] = {
        range = "40-50",
        title = "心动期",
        alliance = { zone = "尘泥沼泽 → 悲伤沼泽", tip = "尘泥沼泽任务集中，跑路少" },
        horde = { zone = "荆棘谷(南) → 塔纳利斯", tip = "塔纳利斯+祖尔法拉克一条龙" },
        general = "心动期可进入「祖尔法拉克」(42-48)夺取灵宝。45级左右可前往「奥达曼」(35-45)。此阶段修炼速度开始放缓，加入有增益的公会可提速。",
        dungeon = "祖尔法拉克(42-48) / 奥达曼(35-45) / 玛拉顿(38-50)",
    },
    [6] = {
        range = "50-58",
        title = "金丹期",
        alliance = { zone = "灼热峡谷 → 安戈洛环形山", tip = "安戈洛任务集中，采集宝地" },
        horde = { zone = "辛特兰 → 安戈洛环形山", tip = "辛特兰任务奖励优质灵宝" },
        general = "金丹大成可挑战「黑石深渊」(48-58)、「斯坦索姆」(55-60)。安戈洛环形山是草药矿石的宝库，练级途中大量采集可赚取丰厚灵石。",
        dungeon = "黑石深渊(48-58) / 斯坦索姆(55-60) / 通灵学院(55-60)",
    },
    [7] = {
        range = "58-68",
        title = "元婴期",
        alliance = { zone = "地狱火半岛 → 赞加沼泽 → 泰罗卡森林", tip = "外域任务线完整，经验效率极高" },
        horde = { zone = "地狱火半岛 → 赞加沼泽 → 泰罗卡森林", tip = "外域任务线完整，经验效率极高" },
        general = "突破元婴踏入外域！58级即可穿越黑暗之门。按顺序攻略「地狱火半岛」(58-61)→「赞加沼泽」(62-63)→「泰罗卡森林」(64-65)→「纳格兰」(66-67)→「刀锋山/虚空风暴」(68-70)。飞天魔宠需68级学习飞行骑术。",
        dungeon = "地狱火城墙(58-62) / 鲜血熔炉(60-64) / 奴隶围栏(61-65) / 法力陵墓(64-67) / 塞泰克大厅(66-69)",
    },
    [8] = {
        range = "68-80",
        title = "化神期",
        alliance = { zone = "北风苔原 → 龙骨荒野 → 风暴峭壁", tip = "北风苔原起手，龙骨荒野任务多" },
        horde = { zone = "北风苔原 → 龙骨荒野 → 风暴峭壁", tip = "北风苔原起手，龙骨荒野任务多" },
        general = [[化神大圆满直指飞升！诺森德路线：
北风苔原/啸风峡湾(70-72) → 龙骨荒野(73-74) → 灰熊丘陵(75-76) → 祖达克(76-77) → 索拉查盆地(78) → 风暴峭壁(79-80)
77级可学习极寒飞行，灵石要提前备好(1000金)。风暴峭壁和冰冠冰川刷霍迪尔之子声望解锁强力附魔。]],
        dungeon = "乌特加德城堡(69-72) / 魔枢(69-73) / 艾卓-尼鲁布(72-74) / 达克萨隆要塞(74-76) / 古达克(76-78) / 岩石大厅(77-79) / 闪电大厅(78-80)",
    },
}

-- ============================================================
-- 满级指引 (80级)
-- ============================================================
Guide.ENDGAME = {
    title = "大乘期 · 飞升之后",
    dungeons = {
        "【英雄模式】每日随机英雄本奖励凯旋纹章，可兑换T9套装",
        "【新三本】灵魂洪炉、萨隆矿坑、映像大厅 — 产出232装等装备，团本前置",
        "【团本初阶】纳克萨玛斯(NAXX) — 200-213装等，飞升入门试炼",
        "【团本进阶】奥杜尔(ULD) — 219-239装等，机制丰富建议先看攻略",
        "【团本高阶】十字军的试炼(TOC) — 232-258装等，竞速天堂",
        "【团本巅峰】冰冠堡垒(ICC) — 251-284装等，巫妖王最终决战",
    },
    gold = {
        "每日25个日常任务(上限) → 约300-500金/天",
        "双采(采矿+采药) → 泰坦矿石/冰棘草等高价材料，时入500-1000金",
        "剥皮+制皮 → 北地皮/重北地皮持续供不应求",
        "拍卖行倒卖 → 低价收矿石、草药、布料，周末高价出售",
        "铭文 → 制作强力雕文卖出，成本极低",
        "珠宝加工 → 切紫色宝石卖给团本玩家",
        "每周团本G团打工 → 分金可观",
    },
    rep = {
        "霍迪尔之子 → 肩部附魔（必做！开启方式：风暴峭壁任务线）",
        "银色北伐军 → 头部附魔",
        "肯瑞托 → 法系头部附魔+达拉然传送戒指",
        "黑锋骑士团 → 物理头部附魔",
        "龙眠联军 → 治疗头部附魔+红龙坐骑",
    },
    daily = {
        "优先完成冰冠冰川的银色锦标赛日常",
        "风暴峭壁霍迪尔之子日常（解锁肩部附魔后日常才有意义）",
        "钓鱼日常每周六达拉然钓鱼大赛赢极品鱼竿",
        "达拉然烹饪日常获取烹饪牌子换大餐食谱",
    },
    tips = {
        "加入公会: 经验加成+炉石减半CD",
        "达拉然传送戒指: 肯瑞托崇敬8000金购买",
        "寒冷飞行: 77级学，第一个号的1000金要提前备好",
        "双天赋: 40级可开，100金，方便练级+副本双修",
        "拍卖行插件: 安装Auctioneer快速了解物价",
    },
}

-- ============================================================
-- 特殊等级的修炼小贴士
-- ============================================================
Guide.LEVEL_TIPS = {
    [10] = "你已初窥门径！此时可学习第一个天赋，选择适合你的修炼方向。",
    [20] = "筑基已成！可学习骑术(4金)获得坐骑。去拍卖行买几个包裹扩充储物袋吧。",
    [30] = "修炼小成！此时可学习中级骑术(50金)提速60%。可前往荆棘谷、阿拉希高地探索。",
    [40] = "可以使用双天赋(100金)！一套练级一套副本，效率翻倍。可装备板甲/锁甲的职业将获得新护甲类型。",
    [50] = "金丹大成！各大秘境等待你的挑战。此时应开始为外域之行储备灵石。",
    [58] = "突破元婴！立即前往诅咒之地的黑暗之门，踏入外域修炼圣境！",
    [60] = "恭喜元婴！可学习高级骑术(300金)获得100%速度飞行坐骑。也可以在拍卖行蹲一些外域蓝装。",
    [68] = "化神在即！此时可前往诺森德的北风苔原或啸风峡湾。去之前确认装备已更新到外域蓝装水平。",
    [70] = "化神已成！诺森德修炼圣地开启。此时可学习极寒飞行，请备好1000金。",
    [77] = "即将圆满！77级学习极寒飞行(1000金)解锁诺森德飞行。前往风暴峭壁开启霍迪尔之子声望。",
    [80] = "飞升大乘！修仙之路永无止境，现在开始尽情探索诺森德的团本秘境和日常修炼吧！",
}

-- ============================================================
-- 获取玩家当前阶段的指引
-- ============================================================
function Guide:GetGuideForLevel(level)
    level = level or UnitLevel("player") or 1

    -- 满级指引
    if level >= 80 then
        return self:GetEndgameGuide()
    end

    -- 分级指引
    for i = #self.ZONE_GUIDE, 1, -1 do
        local entry = self.ZONE_GUIDE[i]
        if entry and level >= tonumber(entry.range:match("^(%d+)")) then
            local faction = UnitFactionGroup("player") or ""
            local isHorde = (faction == "Horde")
            local factionData = isHorde and entry.horde or entry.alliance

            local lines = {}
            table.insert(lines, "|cFFFFD700【" .. entry.title .. "】" .. entry.range .. "级|r")
            table.insert(lines, "")
            table.insert(lines, "|cFF88CCFF◆ 修炼圣地：|r" .. factionData.zone)
            table.insert(lines, "|cFF88CCFF◆ 修炼要诀：|r" .. factionData.tip)
            table.insert(lines, "")
            table.insert(lines, entry.general)

            if entry.dungeon and entry.dungeon ~= "" then
                table.insert(lines, "")
                table.insert(lines, "|cFFFF6600◆ 秘境试炼：|r" .. entry.dungeon)
            end

            return table.concat(lines, "\n")
        end
    end

    return "小师妹暂时还没有这个境界的修炼心得..."
end

function Guide:GetEndgameGuide()
    local lines = {}
    table.insert(lines, "|cFFFFD700【大乘期 · 飞升之后】|r")
    table.insert(lines, "")
    table.insert(lines, "|cFF88CCFF◆ 秘境试炼：|r")
    for _, d in ipairs(self.ENDGAME.dungeons) do
        table.insert(lines, "  " .. d)
    end
    table.insert(lines, "")
    table.insert(lines, "|cFFFF6600◆ 赚取灵石：|r")
    for _, g in ipairs(self.ENDGAME.gold) do
        table.insert(lines, "  " .. g)
    end
    table.insert(lines, "")
    table.insert(lines, "|cFF44AAFF◆ 声望修炼：|r")
    for _, r in ipairs(self.ENDGAME.rep) do
        table.insert(lines, "  " .. r)
    end
    table.insert(lines, "")
    table.insert(lines, "|cFF1EFF00◆ 日常功课：|r")
    for _, d in ipairs(self.ENDGAME.daily) do
        table.insert(lines, "  " .. d)
    end
    table.insert(lines, "")
    table.insert(lines, "|cFFAAAAAA◆ 修炼要诀：|r")
    for _, t in ipairs(self.ENDGAME.tips) do
        table.insert(lines, "  " .. t)
    end

    return table.concat(lines, "\n")
end

function Guide:GetLevelTip(level)
    return self.LEVEL_TIPS[level]
end

WoWCultivation.Data.CultivationGuide = Guide
