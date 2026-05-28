local Battleground = {}
WoWCultivation.Data.Battleground = Battleground

Battleground.map = {
    ["战歌峡谷"] = { name = "灵脉峡谷", desc = "两宗争夺灵脉之地的峡谷", type = "夺旗" },
    ["阿拉希盆地"] = { name = "灵石盆地", desc = "四宗争夺灵石矿脉的盆地", type = "占点" },
    ["奥特兰克山谷"] = { name = "万妖山谷", desc = "两宗在妖兽横行的山谷中决战", type = "击杀将军" },
    ["风暴之眼"] = { name = "风暴秘境", desc = "浮空秘境中的灵脉争夺", type = "夺旗+占点" },
    ["远征海滩"] = { name = "远征滩头", desc = "两宗抢滩登陆的战场", type = "攻防" },
    ["古代海滩"] = { name = "远古海滩", desc = "远古遗迹中的灵宝争夺", type = "载具" },
}

Battleground.pvpRanks = {
    [1] = { name = "初入斗法", alliance = "修士", horde = "修士" },
    [2] = { name = "斗法入门", alliance = "列兵", horde = "步兵" },
    [3] = { name = "斗法小成", alliance = "下士", horde = "勇士" },
    [4] = { name = "斗法有成", alliance = "中士", horde = "中士" },
    [5] = { name = "斗法大成", alliance = "军士长", horde = "首席军士" },
    [6] = { name = "斗法精通", alliance = "士官长", horde = "资深军士" },
    [7] = { name = "斗法宗师", alliance = "骑士", horde = "血卫士" },
    [8] = { name = "斗法至尊", alliance = "骑士中尉", horde = "军团士兵" },
    [9] = { name = "斗法化境", alliance = "骑士队长", horde = "百夫长" },
    [10] = { name = "斗法超凡", alliance = "骑士统帅", horde = "督军" },
    [11] = { name = "斗法入圣", alliance = "统帅", horde = "高阶督军" },
    [12] = { name = "斗法封神", alliance = "大元帅", horde = "部落大元帅" },
}

Battleground.events = {
    enter = "宗门争锋已开启，为宗门荣耀而战！",
    start = "斗法开始！夺取灵脉核心！",
    kill = "斗法胜绩+1，道友威武！",
    death = "道友陨落，速速重塑肉身再战！",
    flagCapture = "灵脉核心已夺取！",
    flagLost = "灵脉核心被夺，速速夺回！",
    pointCapture = "灵石矿脉已占领！",
    victory = "宗门大捷！道行精进！",
    defeat = "宗门惜败，来日再战！",
    honor = "获得斗法积分",
}
