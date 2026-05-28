local Realm = {}
WoWCultivation.Data.Realm = Realm

for i = 1, 40 do
    Realm[i] = {
        name = "练气" .. i .. "层",
        bigRealm = "练气期",
        stage = i <= 10 and "初期" or (i <= 20 and "中期" or (i <= 30 and "后期" or "大圆满")),
    }
end

Realm[10] = { name = "练气十层", bigRealm = "练气期", stage = "初期", special = "灵根觉醒", milestone = "TALENT_UNLOCK" }
Realm[15] = { name = "练气十五层", bigRealm = "练气期", stage = "中期", special = "小秘境历练", milestone = "RANDOM_DUNGEON" }
Realm[20] = { name = "练气二十层", bigRealm = "练气期", stage = "中期", special = "灵兽认主", milestone = "MOUNT" }
Realm[30] = { name = "练气三十层", bigRealm = "练气期", stage = "后期", special = "宗门争锋", milestone = "PVP" }
Realm[40] = { name = "练气大圆满", bigRealm = "练气期", stage = "大圆满", special = "可拜入宗门" }

for i = 41, 43 do
    Realm[i] = { name = "筑基初期", bigRealm = "筑基期", stage = "初期" }
end
for i = 44, 46 do
    Realm[i] = { name = "筑基中期", bigRealm = "筑基期", stage = "中期" }
end
for i = 47, 57 do
    Realm[i] = { name = "筑基后期", bigRealm = "筑基期", stage = "后期" }
end
Realm[58] = { name = "筑基大圆满", bigRealm = "筑基期", stage = "大圆满", special = "天门已开" }
Realm[59] = { name = "筑基巅峰", bigRealm = "筑基期", stage = "巅峰" }
Realm[60] = { name = "筑基巅峰", bigRealm = "筑基期", stage = "巅峰" }

for i = 61, 64 do
    Realm[i] = { name = "结丹初期", bigRealm = "结丹期", stage = "初期" }
end
for i = 65, 67 do
    Realm[i] = { name = "结丹中期", bigRealm = "结丹期", stage = "中期" }
end
Realm[68] = { name = "结丹大圆满", bigRealm = "结丹期", stage = "大圆满", special = "北域之门已开" }
Realm[69] = { name = "结丹巅峰", bigRealm = "结丹期", stage = "巅峰" }
Realm[70] = { name = "结丹巅峰", bigRealm = "结丹期", stage = "巅峰" }

for i = 71, 74 do
    Realm[i] = { name = "元婴初期", bigRealm = "元婴期", stage = "初期" }
end
for i = 75, 77 do
    Realm[i] = { name = "元婴中期", bigRealm = "元婴期", stage = "中期" }
end
for i = 78, 79 do
    Realm[i] = { name = "元婴后期", bigRealm = "元婴期", stage = "后期" }
end
Realm[80] = { name = "元婴巅峰", bigRealm = "元婴期", stage = "巅峰", special = "当世巅峰" }
