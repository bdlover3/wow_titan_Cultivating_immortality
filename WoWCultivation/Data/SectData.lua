local Sect = {}
WoWCultivation.Data.Sect = Sect

Sect.WARRIOR = {
    name = "玄武战宗",
    desc = "炼体宗门，近战肉盾",
    path = "体修/玄武",
    background = "传承自上古玄武神兽，弟子皆以炼体为主，主修肉身成圣之道。",
    titles = { "武徒", "武者", "武师", "武宗" },
    spiritRoot = "金灵根",
    techniques = {
        { tree = "武器", name = "玄武炼体诀" },
        { tree = "狂暴", name = "霸王举鼎" },
        { tree = "防护", name = "金钟罩" },
    },
}

Sect.PALADIN = {
    name = "光明圣宗",
    desc = "正道领袖，治疗+坦克",
    path = "圣道/光明",
    background = "修仙界第一正道大宗，传承自上古光明神。",
    titles = { "圣徒", "圣骑士", "圣堂武士", "圣光使者" },
    spiritRoot = "光灵根",
    techniques = {
        { tree = "神圣", name = "光明圣典" },
        { tree = "防护", name = "神圣护体" },
        { tree = "惩戒", name = "神恩" },
    },
}

Sect.HUNTER = {
    name = "万兽仙宗",
    desc = "御兽宗门，远程输出",
    path = "御兽/兽道",
    background = "修仙界唯一的御兽宗门，传承《万兽谱》。",
    titles = { "兽徒", "猎师", "御兽师", "兽王" },
    spiritRoot = "木灵根",
    techniques = {
        { tree = "野兽控制", name = "万兽御灵诀" },
        { tree = "射击", name = "穿云箭法" },
        { tree = "生存", name = "陷阱术" },
    },
}

Sect.ROGUE = {
    name = "暗影魔宗",
    desc = "刺客宗门，爆发输出",
    path = "暗杀/暗影",
    background = "修仙界最神秘的宗门，传承自上古暗影魔神。",
    titles = { "暗影学徒", "刺客", "暗影行者", "影杀尊者" },
    spiritRoot = "影灵根",
    techniques = {
        { tree = "刺杀", name = "暗影绝杀" },
        { tree = "战斗", name = "隐遁术" },
        { tree = "敏锐", name = "潜行术" },
    },
}

Sect.PRIEST = {
    name = "天医谷",
    desc = "医道宗门，治疗辅助",
    path = "治疗/医道",
    background = "修仙界第一医道宗门，传承自上古神农氏。",
    titles = { "药童", "医师", "大医", "医圣" },
    spiritRoot = "光灵根",
    techniques = {
        { tree = "戒律", name = "天医圣经" },
        { tree = "神圣", name = "九转还魂术" },
        { tree = "暗影", name = "真言术" },
    },
}

Sect.DEATHKNIGHT = {
    name = "幽冥鬼宗",
    desc = "亡灵宗门，坦克+输出",
    path = "冥道/幽冥",
    background = "传承自上古幽冥大帝，弟子皆是死而复生的亡灵修士。",
    titles = { "亡灵学徒", "死亡骑士", "死亡使者", "幽冥大帝" },
    spiritRoot = "冥灵根",
    techniques = {
        { tree = "鲜血", name = "幽冥死经" },
        { tree = "冰霜", name = "冰霜之力" },
        { tree = "邪恶", name = "亡灵召唤" },
    },
}

Sect.SHAMAN = {
    name = "自然神殿",
    desc = "元素宗门，治疗+输出",
    path = "元素/自然",
    background = "传承自上古元素之神，弟子沟通天地元素，召唤先祖之魂。",
    titles = { "图腾学徒", "萨满", "元素使者", "大祭司" },
    spiritRoot = "雷灵根",
    techniques = {
        { tree = "元素", name = "元素召唤" },
        { tree = "增强", name = "先祖之魂" },
        { tree = "恢复", name = "图腾加持" },
    },
}

Sect.MAGE = {
    name = "玄天法宗",
    desc = "法术宗门，远程爆发",
    path = "法道/玄天",
    background = "修仙界第一法术大宗，传承自上古玄天道尊。",
    titles = { "法术学徒", "法师", "大法师", "法尊" },
    spiritRoot = "水灵根",
    techniques = {
        { tree = "奥术", name = "玄天秘录" },
        { tree = "火焰", name = "焚天诀" },
        { tree = "冰霜", name = "玄冰诀" },
    },
}

Sect.WARLOCK = {
    name = "血魂魔宗",
    desc = "邪道宗门，召唤+DOT",
    path = "魔道/血魂",
    background = "修仙界最神秘的邪道宗门，传承自上古血神。",
    titles = { "血徒", "术士", "咒师", "血魔尊者" },
    spiritRoot = "火灵根",
    techniques = {
        { tree = "痛苦", name = "血魂魔典" },
        { tree = "恶魔", name = "恶魔召唤术" },
        { tree = "毁灭", name = "毁灭术" },
    },
}

Sect.DRUID = {
    name = "万木仙宗",
    desc = "自然宗门，全能变形",
    path = "自然/万木",
    background = "传承自上古生命之树，弟子与自然融为一体，能化身各种形态。",
    titles = { "自然学徒", "德鲁伊", "自然守护者", "森林之王" },
    spiritRoot = "木灵根",
    techniques = {
        { tree = "平衡", name = "万木长春诀" },
        { tree = "野性战斗", name = "百变千化" },
        { tree = "恢复", name = "生命之树" },
    },
}
