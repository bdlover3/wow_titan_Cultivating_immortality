local Milestone = {}
WoWCultivation.Data.Milestone = Milestone

Milestone.milestones = {
    TALENT_UNLOCK = {
        level = 10,
        name = "灵根觉醒",
        desc = "天赋系统解锁，可选择功法方向",
        effectType = "awakening",
        dialogSequence = {
            "师兄，恭喜你修为精进至练气十层！",
            "你的灵根已经觉醒，是时候选择修炼方向了。",
            "点击【灵根·功法】，选择你要主修的功法吧。",
        },
        flashButton = "XiuxianTalentButton",
    },
    RANDOM_DUNGEON = {
        level = 15,
        name = "小秘境历练",
        desc = "随机副本查找器解锁，可进入小秘境",
        effectType = "portal",
        dialogSequence = {
            "师兄，你的修为已至练气十五层，可喜可贺！",
            "修仙之道，不可闭门造车。我感应到附近有小秘境出没...",
            "点击【小秘境历练】，与同道中人一起探索秘境吧！",
        },
        flashButton = "XiuxianDungeonButton",
    },
    MOUNT = {
        level = 20,
        name = "灵兽认主",
        desc = "骑术学习，可契约灵兽代步",
        effectType = "mount",
        dialogSequence = {
            "师兄修为精进，已可契约灵兽代步了！",
            "前往灵脉驿站，学习御兽之术吧。",
        },
        flashButton = nil,
    },
    PVP = {
        level = 30,
        name = "宗门争锋",
        desc = "战场开放，可参与宗门争锋",
        effectType = "battle",
        dialogSequence = {
            "师兄，修仙界风云变幻，宗门争锋即将开始！",
            "点击【宗门争锋】，代表我宗出战吧！",
        },
        flashButton = "XiuxianPvPButton",
    },
    SECT = {
        level = 40,
        name = "拜入宗门",
        desc = "天赋树完善，正式拜入宗门",
        effectType = "sect",
        dialogSequence = {
            "师兄，练气大圆满！你已可正式拜入宗门！",
        },
        flashButton = nil,
    },
    FOUNDATION = {
        level = 40,
        name = "筑基天劫",
        desc = "进入筑基期，天劫降临",
        effectType = "tribulation",
        dialogSequence = {
            "师兄，筑基天劫已至！",
        },
        flashButton = nil,
    },
    OUTLAND = {
        level = 58,
        name = "天门已开",
        desc = "外域秘境已开启",
        effectType = "portal",
        dialogSequence = {
            "天门已开，外域秘境向你敞开！",
        },
        flashButton = nil,
    },
    GOLDEN_CORE = {
        level = 60,
        name = "结丹天劫",
        desc = "进入结丹期，天劫降临",
        effectType = "tribulation",
        dialogSequence = {
            "师兄，结丹天劫降临！",
        },
        flashButton = nil,
    },
    NORTHREND = {
        level = 68,
        name = "北域之门",
        desc = "诺森德秘境已开启",
        effectType = "portal",
        dialogSequence = {
            "北域之门已开，诺森德秘境等你探索！",
        },
        flashButton = nil,
    },
    NASCENT_SOUL = {
        level = 70,
        name = "元婴天劫",
        desc = "进入元婴期，天劫降临",
        effectType = "tribulation",
        dialogSequence = {
            "师兄，元婴天劫降临！",
        },
        flashButton = nil,
    },
    PEAK = {
        level = 80,
        name = "飞升天劫",
        desc = "满级，当世巅峰",
        effectType = "ascension",
        dialogSequence = {
            "师兄，你已到达元婴巅峰！修仙界广阔，愿师兄早日飞升！",
        },
        flashButton = nil,
    },
}

Milestone.tribulationLevels = {
    [40] = "筑基天劫",
    [60] = "结丹天劫",
    [70] = "元婴天劫",
    [80] = "飞升天劫",
}
