# 魔兽修仙传 (WoWCultivation) — AI开发手册

> 本手册是AI辅助开发的核心参考文档，定义了所有修仙概念与WoW API的映射关系、数据结构、模块架构和开发规范。
> 目标平台：魔兽世界泰坦时光服 (3.3.5a / 80级)
> AI识别标记：STRUCTURED_DEVELOPMENT_MANUAL

---

## 一、项目概述

### 1.1 项目名称
- 英文ID: `WoWCultivation`
- 中文名: `魔兽修仙传`
- 版本: `1.0`

### 1.2 核心理念
将魔兽世界的游戏信息通过WoW API获取后，转换为修仙小说中的概念体系，为玩家提供沉浸式的修仙体验。插件不修改任何游戏原有功能，仅在展示层进行概念替换和增强。

### 1.3 目标客户端
- 泰坦时光服 (3.3.5a / 80级)
- TOC Interface版本: `30300`
- 支持的客户端版本后缀: `_Titan`

### 1.4 系统架构图

```
┌──────────────────────────────────────────────────────────────┐
│                    魔兽修仙传 核心架构                         │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐   │
│  │ 概念映射引擎  │    │ 事件监听系统  │    │  数据存储层   │   │
│  │ ConceptMapper │    │ EventManager  │    │  DataStore   │   │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘   │
│         │                   │                   │           │
│         └───────────────────┼───────────────────┘           │
│                             │                               │
│  ┌──────────────────────────┼─────────────────────────────┐ │
│  │                          ▼                             │ │
│  │                    核心功能模块                         │ │
│  │  ┌────────┬────────┬────────┬────────┬────────┐       │ │
│  │  │小师妹  │境界系统│灵宝系统│灵根功法│宗门系统│       │ │
│  │  └────────┴────────┴────────┴────────┴────────┘       │ │
│  │  ┌────────┬────────┬────────┬────────┬────────┐       │ │
│  │  │神识探查│聊天系统│修仙主界│里程碑系│战场系统│       │ │
│  │  │        │        │  面    │  统    │宗门争锋│       │ │
│  │  └────────┴────────┴────────┴────────┴────────┘       │ │
│  │  ┌────────┬────────┬────────┬────────┬────────┐       │ │
│  │  │天劫系统│心魔系统│仙缘系统│闭关系统│因果系统│       │ │
│  │  └────────┴────────┴────────┴────────┴────────┘       │ │
│  └────────────────────────────────────────────────────────┘ │
│                             │                               │
│                             ▼                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                  WoW 原生 API 层                        │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

### 1.5 技术栈
- **核心语言**: Lua 5.1
- **UI框架**: WoW原生 XML + Lua UI (CreateFrame / PlayerModel)
- **数据持久化**: SavedVariables
- **事件驱动**: WoW Event System + 自定义事件管理器
- **钩子机制**: hooksecurefunc

---

## 二、核心概念映射表

### 2.1 境界系统 (Realm System)

将玩家等级映射为修仙境界。每个大境界内细分小阶段。

| 等级范围 | 大境界 | 小阶段细分规则 | 特殊标记 |
|---------|--------|--------------|---------|
| 1-10 | 练气期 | 练气一层~练气十层 | 10级: 灵根觉醒(天赋解锁) |
| 11-20 | 练气期 | 练气十一层~练气二十层 | 15级: 小秘境历练(随机副本) |
| 21-30 | 练气期 | 练气二十一层~练气三十层 | 30级: 宗门争锋(战场开放) |
| 31-40 | 练气期 | 练气三十一层~练气四十层(大圆满) | |
| 41-50 | 筑基期 | 筑基初期~中期 | |
| 51-57 | 筑基期 | 筑基后期 | |
| 58 | 筑基期 | 筑基大圆满 | 天门已开，可入外域 |
| 59-60 | 结丹期 | 结丹初期 | 金丹初凝 |
| 61-67 | 结丹期 | 结丹中期~后期 | |
| 68 | 结丹期 | 结丹大圆满 | 北域之门已开，可入诺森德 |
| 69-70 | 元婴期 | 元婴初期 | 丹破婴生 |
| 71-75 | 元婴期 | 元婴中期 | |
| 76-79 | 元婴期 | 元婴后期 | |
| 80 | 元婴期 | 元婴巅峰 | 当世巅峰 |

**API调用**: `UnitLevel("player")` 或 `UnitLevel("target")`

**数据结构**:
```lua
XiuxianRealm = {
    [1]  = { name = "练气一层", bigRealm = "练气期", stage = "初期" },
    [2]  = { name = "练气二层", bigRealm = "练气期", stage = "初期" },
    -- ... 自动生成
    [10] = { name = "练气十层", bigRealm = "练气期", stage = "初期", special = "灵根觉醒", milestone = "TALENT_UNLOCK" },
    [15] = { name = "练气十五层", bigRealm = "练气期", stage = "中期", special = "小秘境历练", milestone = "RANDOM_DUNGEON" },
    [20] = { name = "练气二十层", bigRealm = "练气期", stage = "中期", special = "灵兽认主", milestone = "MOUNT" },
    [30] = { name = "练气三十层", bigRealm = "练气期", stage = "后期", special = "宗门争锋", milestone = "PVP" },
    [40] = { name = "练气大圆满", bigRealm = "练气期", stage = "大圆满", special = "可拜入宗门" },
    [41] = { name = "筑基初期", bigRealm = "筑基期", stage = "初期" },
    -- ...
    [58] = { name = "筑基大圆满", bigRealm = "筑基期", stage = "大圆满", special = "天门已开" },
    -- ...
    [68] = { name = "结丹大圆满", bigRealm = "结丹期", stage = "大圆满", special = "北域之门已开" },
    -- ...
    [80] = { name = "元婴巅峰", bigRealm = "元婴期", stage = "巅峰" },
}
```

### 2.2 门派系统 (Sect System)

将职业映射为修仙门派。每个门派有独特的修仙背景描述。

| 职业英文名 | classId | 门派名称 | 门派描述 | 修炼方向 |
|-----------|---------|---------|---------|---------|
| WARRIOR | 1 | 玄武战宗 | 炼体宗门，近战肉盾 | 体修/玄武 |
| PALADIN | 2 | 光明圣宗 | 正道领袖，治疗+坦克 | 圣道/光明 |
| HUNTER | 3 | 万兽仙宗 | 御兽宗门，远程输出 | 御兽/兽道 |
| ROGUE | 4 | 暗影魔宗 | 刺客宗门，爆发输出 | 暗杀/暗影 |
| PRIEST | 5 | 天医谷 | 医道宗门，治疗辅助 | 治疗/医道 |
| DEATHKNIGHT | 6 | 幽冥鬼宗 | 亡灵宗门，坦克+输出 | 冥道/幽冥 |
| SHAMAN | 7 | 自然神殿 | 元素宗门，治疗+输出 | 元素/自然 |
| MAGE | 8 | 玄天法宗 | 法术宗门，远程爆发 | 法道/玄天 |
| WARLOCK | 9 | 血魂魔宗 | 邪道宗门，召唤+DOT | 魔道/血魂 |
| DRUID | 11 | 万木仙宗 | 自然宗门，全能变形 | 自然/万木 |

**API调用**: `UnitClass("player")` 返回 `localizedClass, englishClass, classId`

**门派详细背景**:

#### 玄武战宗 (WARRIOR)
传承自上古玄武神兽，弟子皆以炼体为主，主修肉身成圣之道。宗门信奉"力量即是正义"，铜皮铁骨，力大无穷，能以肉身硬抗法术轰击，是修仙界最坚实的守护者。主修：炼体、金钟罩、玄武真身，功法《玄武炼体诀》《霸王举鼎》。境界称号：武徒→武者→武师→武宗。

#### 光明圣宗 (PALADIN)
修仙界第一正道大宗，传承自上古光明神。宗门弟子主修圣光之力，既能净化邪祟，又能治愈伤痛，更能化身金甲战神斩妖除魔。以守护苍生为己任，是正义的化身。主修：圣光、净化、神恩，功法《光明圣典》《神圣护体》。境界称号：圣徒→圣骑士→圣堂武士→圣光使者。

#### 万兽仙宗 (HUNTER)
修仙界唯一的御兽宗门，传承《万兽谱》，记载天下万种妖兽。宗门弟子皆能与妖兽沟通，契约灵兽共同作战，宗门弟子既能百步穿杨，又能驱使灵兽，是修仙界最灵活的存在。主修：御兽、箭术、陷阱，功法《万兽御灵诀》《穿云箭法》。境界称号：兽徒→猎师→御兽师→兽王。

#### 暗影魔宗 (ROGUE)
修仙界最神秘的宗门，传承自上古暗影魔神。宗门弟子主修暗影之力，擅长潜行、暗杀、下毒，宗门弟子亦正亦邪，行事只凭本心，是修仙界最令人闻风丧胆的存在。主修：暗影、潜行、刺杀，功法《暗影绝杀》《隐遁术》。境界称号：暗影学徒→刺客→暗影行者→影杀尊者。

#### 天医谷 (PRIEST)
修仙界第一医道宗门，传承自上古神农氏。宗门弟子主修生命之力，既能起死回生，又能驱散邪咒，谷中弟子以救死扶伤为己任，是修仙界最受尊敬的存在。主修：生命、驱散、真言，功法《天医圣经》《九转还魂术》。境界称号：药童→医师→大医→医圣。

#### 幽冥鬼宗 (DEATHKNIGHT)
传承自上古幽冥大帝，弟子皆是死而复生的亡灵修士。主修死亡之力，能召唤亡灵大军，施放死亡凋零，以冰霜和邪秽之力作战，是修仙界最特殊的存在。主修死亡、冰霜、邪秽，功法《幽冥死经》《亡灵召唤》。特点：鲜血坦克、冰霜输出、邪秽DD。境界称号：亡灵学徒→死亡骑士→死亡使者→幽冥大帝。

#### 自然神殿 (SHAMAN)
传承自上古元素之神，弟子沟通天地元素，召唤先祖之魂。既能引动风雷水火，又能召唤图腾加持队友，是修仙界最接近自然的存在。主修元素、图腾、先祖，功法《元素召唤》《先祖之魂》。特点：元素输出、治疗、增强三系。境界称号：图腾学徒→萨满→元素使者→大祭司。

#### 玄天法宗 (MAGE)
修仙界第一法术大宗，传承自上古玄天道尊。弟子主修天地灵气，操控冰火奥三系法术，是修仙界破坏力最强的存在，举手投足间山崩地裂。主修法术、传送、结界，功法《玄天秘录》《三系法术真解》。特点：高爆发、范围伤害、控制强。境界称号：法术学徒→法师→大法师→法尊。

#### 血魂魔宗 (WARLOCK)
修仙界最神秘的邪道宗门，传承自上古血神。弟子主修血魂之力，能召唤恶魔，施放诅咒，以敌人的生命力滋养自身，亦正亦邪，追求力量极致。主修诅咒、召唤、血魂，功法《血魂魔典》《恶魔召唤术》。特点：持续伤害、宠物坦克、自我恢复。境界称号：血徒→术士→咒师→血魔尊者。

#### 万木仙宗 (DRUID)
传承自上古生命之树，弟子与自然融为一体，能化身各种形态。既能化身巨熊抗敌，又能化身猎豹刺杀，更能化身古树治愈队友，是修仙界最全能的存在。主修自然、变形、生命，功法《万木长春诀》《百变千化》。特点：坦克、治疗、物理、法术四系全能。境界称号：自然学徒→德鲁伊→自然守护者→森林之王。

**数据结构**:
```lua
XiuxianSect = {
    WARRIOR     = { name = "玄武战宗", desc = "炼体宗门，近战肉盾", path = "体修/玄武", titles = {"武徒","武者","武师","武宗"} },
    PALADIN     = { name = "光明圣宗", desc = "正道领袖，治疗+坦克", path = "圣道/光明", titles = {"圣徒","圣骑士","圣堂武士","圣光使者"} },
    HUNTER      = { name = "万兽仙宗", desc = "御兽宗门，远程输出", path = "御兽/兽道", titles = {"兽徒","猎师","御兽师","兽王"} },
    ROGUE       = { name = "暗影魔宗", desc = "刺客宗门，爆发输出", path = "暗杀/暗影", titles = {"暗影学徒","刺客","暗影行者","影杀尊者"} },
    PRIEST      = { name = "天医谷", desc = "医道宗门，治疗辅助", path = "治疗/医道", titles = {"药童","医师","大医","医圣"} },
    DEATHKNIGHT = { name = "幽冥鬼宗", desc = "亡灵宗门，坦克+输出", path = "冥道/幽冥", titles = {"亡灵学徒","死亡骑士","死亡使者","幽冥大帝"} },
    SHAMAN      = { name = "自然神殿", desc = "元素宗门，治疗+输出", path = "元素/自然", titles = {"图腾学徒","萨满","元素使者","大祭司"} },
    MAGE        = { name = "玄天法宗", desc = "法术宗门，远程爆发", path = "法道/玄天", titles = {"法术学徒","法师","大法师","法尊"} },
    WARLOCK     = { name = "血魂魔宗", desc = "邪道宗门，召唤+DOT", path = "魔道/血魂", titles = {"血徒","术士","咒师","血魔尊者"} },
    DRUID       = { name = "万木仙宗", desc = "自然宗门，全能变形", path = "自然/万木", titles = {"自然学徒","德鲁伊","自然守护者","森林之王"} },
}
```

### 2.3 灵石系统 (Spirit Stone System)

将金币转换为灵石体系。

| 魔兽货币 | 修仙货币 | 换算 |
|---------|---------|------|
| 金 (Gold) | 上品灵石 | 1金 = 1上品灵石 |
| 银 (Silver) | 中品灵石 | 1银 = 1中品灵石 |
| 铜 (Copper) | 下品灵石 | 1铜 = 1下品灵石 |

**API调用**: `GetMoney()` 返回铜币总数

**显示格式**: `XX上品灵石 XX中品灵石 XX下品灵石`

**数据结构**:
```lua
function Xiuxian_GetSpiritStones()
    local money = GetMoney()
    local spiritStones = floor(money / 10000)
    local spiritJade = floor((money % 10000) / 100)
    local spiritDust = money % 100
    return spiritStones, spiritJade, spiritDust
end
```

### 2.4 灵宝系统 (Spirit Treasure System)

将装备品质映射为灵宝品阶。

| 魔兽品质 | quality值 | 灵宝等级 | 颜色 | 描述 |
|---------|----------|---------|------|------|
| 粗糙 (Poor) | 0 | 凡器 | 灰色 | 凡人所用，无灵气 |
| 普通 (Common) | 1 | 法器 | 白色 | 注入微薄灵气 |
| 优秀 (Uncommon) | 2 | 灵器 | 绿色 | 灵气充盈，可御使 |
| 精良 (Rare) | 3 | 宝器 | 蓝色 | 蕴含阵法，威力不凡 |
| 史诗 (Epic) | 4 | 灵宝 | 紫色 | 通灵之宝，拥有器灵 |
| 传说 (Legendary) | 5 | 仙器 | 橙色 | 仙家至宝，威力无穷 |
| 神器 (Artifact) | 6 | 先天灵宝 | 红色 | 天地所生，大道所钟 |

**灵宝鉴定系统**:
- 获得装备时自动鉴定，Tooltip显示"已鉴定"标记
- 根据物品等级计算灵宝评分
- 套装效果重命名为"阵法共鸣"

**灵宝强化系统**:
- 附魔 → 灵宝祭炼
- 宝石镶嵌 → 灵石镶嵌
- 装备升级 → 灵宝进阶

**装备部位映射**:

| 魔兽部位 | 修仙称呼 |
|---------|---------|
| 头盔 | 灵冠 |
| 项链 | 灵链 |
| 肩甲 | 灵肩 |
| 披风 | 灵氅 |
| 胸甲 | 灵甲 |
| 护腕 | 灵镯 |
| 手套 | 灵手 |
| 腰带 | 灵带 |
| 腿甲 | 灵裙/灵裤 |
| 靴子 | 灵靴 |
| 戒指 | 灵戒 |
| 饰品 | 灵符 |
| 主手 | 本命灵宝 |
| 副手 | 护身灵宝 |
| 远程 | 暗器灵宝 |

**属性映射**:

| 魔兽属性 | 修仙属性 | 说明 |
|---------|---------|------|
| 力量 (Strength) | 肉身之力 | 炼体修为 |
| 敏捷 (Agility) | 身法 | 遁速与闪避 |
| 耐力 (Stamina) | 气血 | 生命力与防御力 |
| 智力 (Intellect) | 神识 | 灵觉与法术威力 |
| 精神 (Spirit) | 灵根资质 | 修炼速度与回蓝 |
| 法术强度 | 灵力 | 法术伤害加成 |
| 攻击强度 | 罡气 | 物理伤害加成 |
| 暴击 | 会心一击 | 攻击暴击 |
| 急速 | 遁速 | 攻击与施法速度 |
| 命中 | 灵识锁定 | 命中率 |

**API调用**:
- `GetInventoryItemLink("player", slotId)` — 获取装备链接
- `GetItemQualityColor(quality)` — 获取品质颜色
- `GetItemInfo(itemLink)` — 获取物品信息

### 2.5 灵根/功法系统 (Spirit Root / Cultivation Method)

将天赋系统映射为灵根和功法体系。

#### 灵根属性 (基于职业)

| 职业 | 灵根属性 | 灵根描述 |
|------|---------|---------|
| WARRIOR | 金灵根 | 金行之力，刚猛无匹 |
| PALADIN | 光灵根 | 光明之力，浩然正气 |
| HUNTER | 木灵根 | 木行之力，生生不息 |
| ROGUE | 影灵根 | 暗影之力，无影无踪 |
| PRIEST | 光灵根 | 光明之力，沟通天地 |
| DEATHKNIGHT | 冥灵根 | 冥界之力，生死之间 |
| SHAMAN | 雷灵根 | 雷霆之力，天威莫测 |
| MAGE | 水灵根 | 水行之力，变化万千 |
| WARLOCK | 火灵根 | 火行之力，焚天煮海 |
| DRUID | 木灵根 | 木行之力，生生不息 |

#### 功法系统 (基于天赋树)

每个天赋树对应一部功法，三系天赋 = 三部功法。

| 职业 | 天赋树1 | 功法1 | 天赋树2 | 功法2 | 天赋树3 | 功法3 |
|------|--------|-------|--------|-------|--------|-------|
| WARRIOR | 武器 | 玄武炼体诀 | 狂暴 | 霸王举鼎 | 防护 | 金钟罩 |
| PALADIN | 神圣 | 光明圣典 | 防护 | 神圣护体 | 惩戒 | 神恩 |
| HUNTER | 野兽控制 | 万兽御灵诀 | 射击 | 穿云箭法 | 生存 | 陷阱术 |
| ROGUE | 刺杀 | 暗影绝杀 | 战斗 | 隐遁术 | 敏锐 | 潜行术 |
| PRIEST | 戒律 | 天医圣经 | 神圣 | 九转还魂术 | 暗影 | 真言术 |
| DEATHKNIGHT | 鲜血 | 幽冥死经 | 冰霜 | 冰霜之力 | 邪恶 | 亡灵召唤 |
| SHAMAN | 元素 | 元素召唤 | 增强 | 先祖之魂 | 恢复 | 图腾加持 |
| MAGE | 奥术 | 玄天秘录 | 火焰 | 焚天诀 | 冰霜 | 玄冰诀 |
| WARLOCK | 痛苦 | 血魂魔典 | 恶魔 | 恶魔召唤术 | 毁灭 | 毁灭术 |
| DRUID | 平衡 | 万木长春诀 | 野性战斗 | 百变千化 | 恢复 | 生命之树 |

**天赋点数 → 修为**: 已分配天赋点 = 已投入修为，未分配天赋点 = 可用修为

**功法术语映射**:
- 学习天赋 → 领悟功法
- 天赋重置 → 重修功法
- 双天赋 → 双修功法
- 天赋点 → 灵气点

**API调用**:
- `GetNumTalentTabs()` — 天赋树数量
- `GetTalentTabInfo(tabIndex)` — 天赋树信息
- `GetTalentInfo(tabIndex, talentIndex)` — 天赋详情
- `UnitCharacterPoints("player")` — 未分配天赋点

### 2.6 道果系统 (Dao Fruit / Achievement System)

将成就系统映射为道果体系。

| 魔兽概念 | 修仙概念 | 说明 |
|---------|---------|------|
| 成就 | 道果 | 每完成一个成就 = 结出一枚道果 |
| 成就点数 | 道行 | 道行越高，修行越深 |
| 成就分类 | 道果类别 | 不同类别的道果 |
| 成就标题 | 道果名 | 成就名称的修仙化 |

**道果类别映射**:

| 魔兽成就分类 | 道果类别 |
|-------------|---------|
| 综合 | 修行道果 |
| 任务 | 历练道果 |
| 探索 | 游历道果 |
| PvP | 斗法道果 |
| 副本/团队 | 秘境道果 |
| 专业 | 百艺道果 |
| 声望 | 人缘道果 |
| 世界事件 | 天时道果 |

**修仙专属成就**:
- **初入仙途**: 达到10级（练气十层，灵根觉醒）
- **小秘境历练**: 首次完成随机副本
- **灵兽认主**: 首次学习骑术
- **宗门争锋**: 首次进入战场
- **筑基成功**: 达到40级
- **金丹大道**: 达到60级
- **元婴出窍**: 达到80级
- **炼丹大师**: 炼金满450
- **炼器宗师**: 附魔满450
- **神识如海**: 探查100名玩家
- **宗门栋梁**: 完成100个宗门任务

**API调用**:
- `GetNumCompletedAchievements()` — 完成成就数
- `GetTotalAchievementPoints()` — 成就点数
- `GetCategoryList()` — 成就分类

### 2.7 道号系统 (Dao Title / Title System)

将头衔映射为道号。

| 魔兽头衔类型 | 道号类型 | 示例 |
|------------|---------|------|
| PvP头衔 | 斗法道号 | "战场先锋" → "斗法尊者" |
| 副本头衔 | 秘境道号 | "歼灭者" → "秘境征服者" |
| 成就头衔 | 道果道号 | "博学者" → "博道真人" |
| 声望头衔 | 人缘道号 | "崇拜" → "道友敬仰" |
| 事件头衔 | 天时道号 | "酒仙" → "醉道人" |

**头衔修仙化映射**:

| 魔兽头衔 | 修仙头衔 | 获得条件 |
|---------|---------|---------|
| 探险者 | 云游修士 | 探索完成 |
| 大使 | 宗门使者 | 声望崇拜 |
| 审判者 | 执法长老 | PvP成就 |
| 征服者 | 秘境征服者 | 副本成就 |
| 不朽者 | 长生不老 | 团队成就 |
| 火车王 | 灭团之星 | 经典成就 |

**API调用**:
- `GetCurrentTitle()` — 当前头衔
- `GetTitleName(titleId)` — 头衔名称

### 2.8 秘境系统 (Secret Realm / Instance System)

将副本映射为秘境。

| 魔兽概念 | 修仙概念 |
|---------|---------|
| 副本 | 秘境 |
| 团队副本 | 大秘境 |
| 英雄副本 | 凶险秘境 |
| 随机副本 | 小秘境历练 |
| Boss | 秘境守卫/秘境之主 |
| 副本进度 | 秘境探索度 |
| 副本锁定 | 秘境冷却 |

**经典秘境映射表** (部分示例):

| 副本名 | 秘境名 | 秘境描述 |
|-------|--------|---------|
| 影牙城堡 | 暗影古堡 | 亡灵骑士盘踞的阴森古堡 |
| 死亡矿井 | 亡灵矿洞 | 藏有宝藏的废弃灵矿 |
| 监狱 | 天牢 | 囚禁着叛逆修士的牢狱 |
| 血色修道院 | 血色圣殿 | 狂热信徒的修炼圣地 |
| 祖尔法拉克 | 沙漠古墓 | 黄沙之下的远古遗迹 |
| 斯坦索姆 | 亡灵之城 | 被瘟疫侵蚀的古城 |
| 熔火之心 | 地火秘境 | 火焰之主沉睡的熔岩深渊 |
| 黑翼之巢 | 龙巢秘境 | 黑龙一族的最后堡垒 |
| 纳克萨玛斯 | 浮空冥城 | 巫妖王的亡灵堡垒 |
| 黑暗神殿 | 暗神殿 | 黑暗力量的至高殿堂 |
| 太阳井高地 | 日源秘境 | 太阳之力的源泉所在 |

**API调用**:
- `GetInstanceInfo()` — 当前副本信息
- `GetRealZoneText()` — 当前区域名
- `GetNumSavedInstances()` — 副本锁定数
- `GetSavedInstanceInfo(index)` — 副本锁定详情

### 2.9 百艺系统 (Hundred Arts / Profession System)

将专业映射为修仙百艺。

| 魔兽专业 | 修仙百艺 | 百艺描述 |
|---------|---------|---------|
| 炼金术 | 炼丹术 | 炼制灵丹妙药 |
| 附魔 | 炼器术 | 祭炼法宝 |
| 铭文 | 制符术 | 绘制符箓 |
| 珠宝加工 | 阵法之道 | 镶嵌灵石 |
| 锻造 | 铸兵术 | 打造兵器 |
| 制皮 | 炼皮术 | 炼制皮甲 |
| 裁缝 | 织袍术 | 缝制法袍 |
| 工程学 | 机关术 | 制造精巧机关 |
| 采药 | 灵植采集 | 采集灵草 |
| 采矿 | 灵矿开采 | 开采矿石 |
| 剥皮 | 妖兽取材 | 采集妖兽材料 |
| 钓鱼 | 灵水垂钓 | 垂钓灵物 |
| 烹饪 | 灵食制作 | 烹制灵食 |

**API调用**:
- `GetProfessions()` — 获取专业索引
- `GetProfessionInfo(index)` — 专业详情
- `GetTradeSkillLine()` — 当前打开的专业

### 2.10 功德系统 (Merit / Reputation System)

将声望映射为功德。

| 魔兽声望等级 | 功德等级 |
|-------------|---------|
| 仇恨 | 宿怨 |
| 敌对 | 结怨 |
| 冷淡 | 疏远 |
| 中立 | 初识 |
| 友善 | 善缘 |
| 尊敬 | 敬仰 |
| 崇敬 | 崇拜 |
| 崇拜 | 功德圆满 |

**API调用**:
- `GetNumFactions()` — 声望阵营数
- `GetFactionInfo(index)` — 声望详情

### 2.11 修仙术语替换总表

| 魔兽术语 | 修仙术语 |
|---------|---------|
| 经验值 | 修为 |
| 升级 | 突破/晋升 |
| 死亡 | 陨落 |
| 复活 | 重塑肉身 |
| 灵魂医者 | 地府接引 |
| 传送 | 缩地成寸 |
| 飞行点 | 灵脉驿站 |
| 拍卖行 | 仙市 |
| 银行 | 储物戒 |
| 邮箱 | 传音符 |
| 任务 | 历练 |
| 副本 | 秘境 |
| Boss | 秘境之主 |
| 小怪 | 妖兽 |
| 掉落 | 天降机缘 |
| 修理 | 灵宝修复 |
| 绑定 | 认主 |
| 装绑 | 灵宝认主 |
| 拾取 | 收取 |
| 需求 | 争夺 |
| 贪婪 | 贪念 |
| 分解 | 灵宝解构 |
| 附魔 | 灵宝铭刻 |
| 宝石 | 灵石 |
| 插槽 | 灵穴 |
| 套装 | 仙器套装 |
| Buff | 灵气加持 |
| Debuff | 邪气侵蚀 |
| CD | 术法冷却 |
| 施法 | 诵咒 |
| 引导 | 聚灵 |
| 瞬发 | 灵光一闪 |
| 暴击 | 天赋异禀 |
| 闪避 | 身法灵动 |
| 格挡 | 灵盾护体 |
| 招架 | 以力破力 |
| 吸血 | 吞噬之术 |
| 护甲 | 灵甲 |
| 天赋 | 灵根/功法 |
| 技能 | 术法 |
| 药水 | 丹药 |
| 合剂 | 天元丹 |
| 食物 | 灵膳 |
| 坐骑 | 灵兽坐骑 |
| 宠物 | 灵兽伙伴 |
| 战场 | 宗门争锋 |
| 竞技场 | 斗法台 |
| 决斗 | 论道切磋 |
| 荣誉 | 斗法积分 |

---

## 三、修仙里程碑系统 (Milestone System)

### 3.1 里程碑总览

修仙之路上的关键节点，对应WoW游戏机制解锁时刻，为玩家提供沉浸式引导提示。

| 等级 | 里程碑ID | 里程碑名称 | 对应游戏机制 | 触发提示 |
|------|---------|-----------|------------|---------|
| 10 | MILESTONE_TALENT | 灵根觉醒 | 天赋系统解锁 | 小师妹引导选择功法方向 |
| 15 | MILESTONE_RANDOM_DUNGEON | 小秘境历练 | 随机副本查找器解锁 | 提示可进入小秘境历练 |
| 20 | MILESTONE_MOUNT | 灵兽认主 | 骑术学习/坐骑 | 提示可契约灵兽代步 |
| 30 | MILESTONE_PVP | 宗门争锋 | 战场开放 | 提示可参与宗门争锋 |
| 40 | MILESTONE_SECT | 拜入宗门 | 天赋树完善/高级天赋 | 提示可正式拜入宗门 |
| 40 | MILESTONE_FOUNDATION | 筑基天劫 | 进入筑基期 | 天劫特效+突破动画 |
| 58 | MILESTONE_OUTLAND | 天门已开 | 外域开放 | 提示外域秘境已开启 |
| 60 | MILESTONE_GOLDEN_CORE | 结丹天劫 | 进入结丹期 | 天劫特效+突破动画 |
| 68 | MILESTONE_NORTHREND | 北域之门 | 诺森德开放 | 提示北域秘境已开启 |
| 70 | MILESTONE_NASCENT_SOUL | 元婴天劫 | 进入元婴期 | 天劫特效+突破动画 |
| 80 | MILESTONE_PEAK | 飞升天劫 | 满级 | 全屏特效+巅峰庆典 |

### 3.2 里程碑详细设计

#### 3.2.1 灵根觉醒 (10级 — 天赋解锁)

**触发条件**: 玩家等级达到10级，首次获得天赋点

**小师妹引导剧情**:
```
小师妹: "师兄，恭喜你修为精进至练气十层！"
小师妹: "你的灵根已经觉醒，是时候选择修炼方向了。"
小师妹: "点击【灵根·功法】(天赋面板)，选择你要主修的功法吧。"
小师妹: "每部功法都有独特的术法，慎重选择哦！"
```

**界面提示**:
- 屏幕中央弹出"灵根觉醒"特效
- 侧边栏出现"灵根·功法"按钮闪烁提示
- 小师妹头顶出现感叹号引导

**技术实现**:
```lua
EventManager:Register("PLAYER_LEVEL_UP", function(level)
    if level == 10 and not WoWCultivationCharDB.milestones.talent then
        Xiuxian_ShowMilestone("MILESTONE_TALENT")
        WoWCultivationCharDB.milestones.talent = true
    end
end)

function Xiuxian_ShowMilestone(milestoneId)
    local data = XiuxianMilestones[milestoneId]
    Xiuxian_PlayMilestoneEffect(data.effectType)
    Xiuxian_SisterDialog(data.dialogSequence)
    if data.flashButton then
        Xiuxian_FlashUIElement(data.flashButton)
    end
end
```

#### 3.2.2 小秘境历练 (15级 — 随机副本解锁)

**触发条件**: 玩家等级达到15级，随机副本查找器可用

**小师妹引导剧情**:
```
小师妹: "师兄，你的修为已至练气十五层，可喜可贺！"
小师妹: "修仙之道，不可闭门造车。我感应到附近有小秘境出没..."
小师妹: "点击【小秘境历练】(随机副本)，与同道中人一起探索秘境吧！"
小师妹: "秘境中有妖兽守护，也有天材地宝，切莫错过！"
```

**界面提示**:
- 小地图周围出现"小秘境"图标闪烁
- 弹出"小秘境历练"快捷入口按钮
- 首次完成随机副本后额外弹出"秘境首通"道果

**技术实现**:
```lua
EventManager:Register("PLAYER_LEVEL_UP", function(level)
    if level == 15 and not WoWCultivationCharDB.milestones.randomDungeon then
        Xiuxian_ShowMilestone("MILESTONE_RANDOM_DUNGEON")
        WoWCultivationCharDB.milestones.randomDungeon = true
    end
end)

EventManager:Register("LFG_PROPOSAL_SHOW", function()
    if not WoWCultivationCharDB.milestones.firstRandomDungeon then
        Xiuxian_SisterSay("师兄，秘境之门已开启，速速前往！")
    end
end)

EventManager:Register("LFG_COMPLETION_REWARD", function()
    if not WoWCultivationCharDB.milestones.firstRandomDungeon then
        Xiuxian_ShowDaoFruit("秘境首通", "首次完成小秘境历练")
        WoWCultivationCharDB.milestones.firstRandomDungeon = true
    end
end)
```

#### 3.2.3 灵兽认主 (20级 — 骑术/坐骑)

**触发条件**: 玩家等级达到20级，可学习骑术

**小师妹引导剧情**:
```
小师妹: "师兄修为精进，已可契约灵兽代步了！"
小师妹: "前往灵脉驿站(骑术训练师)，学习御兽之术吧。"
小师妹: "有了灵兽相伴，修仙之路更加便捷！"
```

#### 3.2.4 宗门争锋 (30级 — 战场开放)

**触发条件**: 玩家等级达到30级，可进入战场

**小师妹引导剧情**:
```
小师妹: "师兄，修仙界风云变幻，宗门争锋即将开始！"
小师妹: "点击【宗门争锋】(战场)，代表我宗出战吧！"
小师妹: "斗法胜绩可换取斗法积分，兑换灵宝丹药！"
```

#### 3.2.5 天劫突破 (40/58/60/68/70/80级)

| 触发条件 | 天劫类型 | 表现 |
|---------|---------|------|
| 升级到40级 | 筑基天劫 | 屏幕雷电特效+小师妹提示"师兄，筑基天劫已至！" |
| 升级到58级 | 外域天门 | 提示"天门已开，外域秘境向你敞开！" |
| 升级到60级 | 结丹天劫 | 屏幕雷电特效+小师妹提示"师兄，结丹天劫降临！" |
| 升级到68级 | 北域天门 | 提示"北域之门已开，诺森德秘境等你探索！" |
| 升级到70级 | 元婴天劫 | 屏幕雷电特效+小师妹提示"师兄，元婴天劫降临！" |
| 升级到80级 | 飞升天劫 | 全屏特效+小师妹提示"师兄，你已到达元婴巅峰！" |

**API调用**: 监听 `PLAYER_LEVEL_UP` 事件

### 3.3 里程碑数据结构

```lua
XiuxianMilestones = {
    MILESTONE_TALENT = {
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
    MILESTONE_RANDOM_DUNGEON = {
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
    MILESTONE_MOUNT = {
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
    MILESTONE_PVP = {
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
    MILESTONE_SECT = {
        level = 40,
        name = "拜入宗门",
        desc = "天赋树完善，正式拜入宗门",
        effectType = "sect",
        dialogSequence = {
            "师兄，练气大圆满！你已可正式拜入宗门！",
        },
        flashButton = nil,
    },
}

WoWCultivationCharDB.milestones = {
    talent = false,
    randomDungeon = false,
    firstRandomDungeon = false,
    mount = false,
    pvp = false,
    sect = false,
    foundation = false,
    outland = false,
    goldenCore = false,
    northrend = false,
    nascentSoul = false,
    peak = false,
}
```

---

## 四、战场系统 — 宗门争锋 (Sect Battle System)

### 4.1 概念映射

| 魔兽概念 | 修仙概念 | 说明 |
|---------|---------|------|
| 战场 (Battleground) | 宗门争锋 | 宗门之间的斗法争端 |
| 竞技场 (Arena) | 斗法台 | 修士之间的论道切磋 |
| 决斗 (Duel) | 论道切磋 | 一对一斗法 |
| 荣誉击杀 | 斗法胜绩 | 击败对手的战绩 |
| 荣誉点数 | 斗法积分 | 可兑换灵宝丹药 |
| PvP等级 | 斗法境界 | 斗法修为等级 |
| 战场胜利 | 宗门大捷 | 为宗门争得荣耀 |
| 战场失败 | 宗门惜败 | 虽败犹荣 |
| 旗帜争夺 | 灵脉争夺 | 争夺灵脉控制权 |
| 资源点 | 灵石矿脉 | 采集灵石资源 |

### 4.2 战场映射表

| 魔兽战场 | 修仙名称 | 修仙描述 | 机制修仙化 |
|---------|---------|---------|-----------|
| 战歌峡谷 | 灵脉峡谷 | 两宗争夺灵脉之地的峡谷 | 夺旗 → 夺取灵脉核心 |
| 阿拉希盆地 | 灵石盆地 | 四宗争夺灵石矿脉的盆地 | 占点 → 占领灵石矿脉 |
| 奥特兰克山谷 | 万妖山谷 | 两宗在妖兽横行的山谷中决战 | 击杀将军 → 斩杀妖王 |
| 风暴之眼 | 风暴秘境 | 浮空秘境中的灵脉争夺 | 夺旗+占点 → 灵脉争夺 |
| 远征海滩 | 远征滩头 | 两宗抢滩登陆的战场 | 攻防 → 宗门远征 |
| 古代海滩 | 远古海滩 | 远古遗迹中的灵宝争夺 | 载具 → 灵宝运输 |

### 4.3 斗法境界 (PvP等级映射)

| PvP等级 | 斗法境界 | 斗法称号(联盟) | 斗法称号(部落) |
|---------|---------|--------------|--------------|
| 1 | 初入斗法 | 修士 | 修士 |
| 2 | 斗法入门 | 列兵 | 步兵 |
| 3 | 斗法小成 | 下士 | 勇士 |
| 4 | 斗法有成 | 中士 | 中士 |
| 5 | 斗法大成 | 军士长 | 首席军士 |
| 6 | 斗法精通 | 士官长 | 资深军士 |
| 7 | 斗法宗师 | 骑士 | 血卫士 |
| 8 | 斗法至尊 | 骑士中尉 | 军团士兵 |
| 9 | 斗法化境 | 骑士队长 | 百夫长 |
| 10 | 斗法超凡 | 骑士统帅 | 督军 |
| 11 | 斗法入圣 | 统帅 | 高阶督军 |
| 12 | 斗法封神 | 大元帅 | 部落大元帅 |

### 4.4 战场事件修仙化

| 魔兽事件 | 修仙提示 |
|---------|---------|
| 进入战场 | "宗门争锋已开启，为宗门荣耀而战！" |
| 战场开始 | "斗法开始！夺取灵脉核心！" |
| 击杀敌人 | "斗法胜绩+1，道友威武！" |
| 被击杀 | "道友陨落，速速重塑肉身再战！" |
| 夺取旗帜 | "灵脉核心已夺取！" |
| 丢失旗帜 | "灵脉核心被夺，速速夺回！" |
| 占领资源点 | "灵石矿脉已占领！" |
| 战场胜利 | "宗门大捷！道行精进！" |
| 战场失败 | "宗门惜败，来日再战！" |
| 获得荣誉 | "获得斗法积分XX" |

### 4.5 技术实现

```lua
XiuxianBattleground = {
    ["战歌峡谷"] = { name = "灵脉峡谷", desc = "两宗争夺灵脉之地的峡谷" },
    ["阿拉希盆地"] = { name = "灵石盆地", desc = "四宗争夺灵石矿脉的盆地" },
    ["奥特兰克山谷"] = { name = "万妖山谷", desc = "两宗在妖兽横行的山谷中决战" },
    ["风暴之眼"] = { name = "风暴秘境", desc = "浮空秘境中的灵脉争夺" },
    ["远征海滩"] = { name = "远征滩头", desc = "两宗抢滩登陆的战场" },
    ["古代海滩"] = { name = "远古海滩", desc = "远古遗迹中的灵宝争夺" },
}

EventManager:Register("PLAYER_ENTERING_BATTLEGROUND", function()
    local bgName = GetRealZoneText()
    local xiuxianBg = XiuxianBattleground[bgName]
    if xiuxianBg then
        Xiuxian_SisterSay("师兄，欢迎来到" .. xiuxianBg.name .. "！" .. xiuxianBg.desc)
    end
end)

EventManager:Register("PLAYER_PVP_KILLS_CHANGED", function()
    Xiuxian_ShowToast("斗法胜绩+1，道友威武！")
end)
```

**API调用**:
- `GetPVPRankInfo(rank)` — PvP等级信息
- `UnitPVPRank("player")` — PvP等级ID
- `GetHonorCurrency()` — 荣誉点数
- `GetRealZoneText()` — 当前区域(判断战场)
- `IsInInstance()` — 是否在副本/战场中
- `GetZonePVPInfo()` — 区域PvP信息

**相关事件**:
- `PLAYER_ENTERING_BATTLEGROUND` — 进入战场
- `PLAYER_PVP_KILLS_CHANGED` — PvP击杀变化
- `PLAYER_PVP_RANK_CHANGED` — PvP等级变化
- `HONOR_CURRENCY_UPDATE` — 荣誉点数更新
- `ZONE_CHANGED_NEW_AREA` — 进入新区域(检测战场)

---

## 五、特色系统设计

### 5.1 小师妹系统 (Junior Sister Guide)

#### 5.1.1 功能描述
- 使用血精灵女性3D模型作为小师妹形象
- 小师妹悬浮在屏幕可拖拽位置
- 点击小师妹打开修仙主界面
- 首次加载时播放引导剧情
- 里程碑触发时主动对话提示

#### 5.1.2 模型实现
```lua
local model = CreateFrame("PlayerModel", "WoWCultivationSisterModel", UIParent)
model:SetSize(200, 300)
model:SetPoint("CENTER")
model:SetCreature(模型ID)
model:SetPosition(0, 0, 0)
model:SetRotation(0)
model:SetCamera(0)
```

#### 5.1.3 交互设计
- 左键点击: 打开修仙主界面
- 右键点击: 弹出快捷菜单(设置/隐藏/重置位置)
- 鼠标悬停: 显示小师妹对话气泡
- 拖拽: 移动小师妹位置

#### 5.1.4 引导剧情 (首次加载)

```
场景1: 小师妹出现
  小师妹: "师兄，你终于醒了！我是你的引路师妹·灵儿。"
  小师妹: "你尚在练气初期，修仙之路漫漫，且听我道来..."

场景2: 境界介绍
  小师妹: "修仙之道，境界为先。你目前是[当前境界]。"
  小师妹: "提升修为(等级)，方能突破境界，踏入更高层次。"

场景3: 门派介绍
  小师妹: "你已拜入[当前门派]，修炼[灵根属性]之力。"
  小师妹: "勤修功法(天赋)，方能掌握更强大的术法。"

场景4: 功能介绍
  小师妹: "以后有什么不懂的，随时点击我即可。"
  小师妹: "修仙界广阔，愿师兄早日飞升！"
```

**API调用**:
- `UnitLevel("player")` — 获取等级用于剧情分支
- `UnitClass("player")` — 获取职业用于门派介绍

### 5.2 神识探查系统 (Divine Sense Investigation)

#### 5.2.1 功能描述
- 在目标玩家的右键菜单中添加"神识探查"选项
- 探查后显示目标玩家的修仙信息面板
- 在目标玩家姓名板/目标框上显示境界标签

#### 5.2.2 实现方式

**右键菜单注入**:
```lua
hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
    if unit and UnitIsPlayer(unit) and UnitIsFriend("player", unit) then
        local info = UIDropDownMenu_CreateInfo()
        info.text = "神识探查"
        info.func = function() Xiuxian_DivineSenseInspect(unit) end
        UIDropDownMenu_AddButton(info)
    end
end)
```

**探查信息面板**:
```
┌─────────────────────────────┐
│     神 识 探 查             │
├─────────────────────────────┤
│  道友: [玩家名]             │
│  境界: [修仙境界]           │
│  门派: [修仙门派]           │
│  灵根: [灵根属性]           │
│  功法: [主修功法]           │
│  道行: [成就点数]           │
│  道号: [当前头衔]           │
└─────────────────────────────┘
```

**API调用**:
- `UnitGUID("target")` — 获取目标GUID
- `GetPlayerInfoByGUID(guid)` — 获取玩家详细信息
- `UnitLevel("target")` — 获取目标等级
- `UnitClass("target")` — 获取目标职业
- `NotifyInspect("target")` — 请求检视
- `GetTalentTabInfo(tabIndex)` — 获取目标天赋信息(需先检视)

#### 5.2.3 境界标签显示
- 在目标框体上添加境界文字
- 格式: `[玩家名] · [境界]`
- 颜色随境界变化

### 5.3 修仙界频道 (Cultivation World Channel)

#### 5.3.1 功能描述
- 登录时自动加入名为"修仙界"的自定义聊天频道
- 频道中玩家名称前显示门派标签
- 私聊消息替换为"XX道友传音入密"
- 公会聊天替换为"宗门传音"

#### 5.3.2 实现方式

**自动加入频道**:
```lua
local CHANNEL_NAME = "修仙界"

local function JoinCultivationChannel()
    JoinChannelByName(CHANNEL_NAME)
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            ChatFrame_AddChannel(chatFrame, CHANNEL_NAME)
        end
    end
end
```

**聊天消息替换映射**:

| 魔兽消息类型 | 修仙消息类型 |
|------------|------------|
| 说 | 道友曰 |
| 喊 | 道友怒喝 |
| 密语 | 传音入密 |
| 密语回复 | 回音入密 |
| 频道 | 修仙界传音 |
| 公会 | 宗门传音 |
| 团队 | 秘境传音 |
| 小队 | 同修传音 |
| 表情 | 道友动作 |

**频道消息前缀**: `[门派名] 道友名: 消息内容`

**API调用**:
- `JoinChannelByName("修仙界")` — 加入频道
- `ChatFrame_AddChannel()` — 添加频道到聊天窗口
- `ChatFrame_AddMessageEventFilter()` — 聊天消息过滤器
- `ChatFrame_MessageEventHandler` — 聊天消息处理

### 5.4 修仙主界面 (Cultivation Main Interface)

#### 5.4.1 功能描述
点击小师妹后打开的修仙主界面，整合所有修仙功能的入口。

#### 5.4.2 界面布局

```
┌──────────────────────────────────────────────────┐
│            魔 兽 修 仙 传                         │
├──────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  境界信息  │  │  门派信息  │  │  灵根功法  │      │
│  │          │  │          │  │          │      │
│  │ 练气期    │  │ 玄天法宗  │  │ 水灵根    │      │
│  │ 练气廿层  │  │          │  │ 太虚奥义  │      │
│  └──────────┘  └──────────┘  └──────────┘      │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │           修 仙 功 能 入 口               │   │
│  │                                          │   │
│  │  [炼丹术]  [炼器术]  [符箓术]  [灵草学]   │   │
│  │  [灵矿学]  [灵兽学]  [法袍术]  [鉴宝术]   │   │
│  │  [符文术]  [机关术]  [灵膳术]  [灵医术]   │   │
│  │                                          │   │
│  │  [小秘境历练] [宗门争锋] [道果录] [灵宝鉴]  │   │
│  │  [功德簿]  [仙途日志] [道号册] [修仙界]    │   │
│  │  [设置]                                   │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │ 小师妹：师兄，今日要修炼什么？             │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  上品灵石: 123  中品灵石: 45  下品灵石: 67         │
│  道行: 1234  道果: 56枚  心魔: 10                │
└──────────────────────────────────────────────────┘
```

#### 5.4.3 功能入口说明

| 入口名称 | 对应功能 | 点击行为 | 解锁等级 |
|---------|---------|---------|---------|
| 炼丹术 | 炼金专业 | 打开炼金界面 | 1 |
| 炼器术 | 锻造专业 | 打开锻造界面 | 1 |
| 符箓术 | 附魔专业 | 打开附魔界面 | 1 |
| 灵草学 | 草药专业 | 打开草药信息 | 1 |
| 灵矿学 | 采矿专业 | 打开采矿信息 | 1 |
| 灵兽学 | 剥皮专业 | 打开剥皮信息 | 1 |
| 法袍术 | 裁缝专业 | 打开裁缝界面 | 1 |
| 鉴宝术 | 珠宝专业 | 打开珠宝界面 | 1 |
| 符文术 | 铭文专业 | 打开铭文界面 | 1 |
| 机关术 | 工程专业 | 打开工程界面 | 1 |
| 灵膳术 | 烹饪专业 | 打开烹饪界面 | 1 |
| 灵医术 | 急救专业 | 打开急救界面 | 1 |
| 小秘境历练 | 随机副本 | 打开副本查找器 | 15 |
| 宗门争锋 | 战场 | 打开PvP面板 | 30 |
| 道果录 | 成就系统 | 打开成就界面 | 1 |
| 功德簿 | 声望系统 | 打开声望界面 | 1 |
| 灵宝鉴 | 装备信息 | 打开角色装备界面 | 1 |
| 仙途日志 | 任务日志 | 打开任务日志 | 1 |
| 道号册 | 头衔选择 | 打开头衔选择 | 1 |
| 修仙界 | 聊天频道 | 切换到修仙界频道 | 1 |
| 设置 | 插件设置 | 打开插件设置面板 | 1 |

**API调用**:
- `ToggleSpellBook("profession")` — 打开专业书
- `ToggleAchievementFrame()` — 打开成就
- `ToggleCharacter("ReputationFrame")` — 打开声望
- `ToggleCharacter("PaperDollFrame")` — 打开角色装备
- `ToggleQuestLog()` — 打开任务日志
- `TogglePVPFrame()` — 打开PvP面板
- `LFDParentFrame:Show()` — 打开副本查找器

### 5.5 闭关系统 (Secluded Cultivation)

- 当玩家在旅店休息时，显示"闭关修炼中"
- 休息经验加成 → 闭关感悟加成（仅做显示提示，不实际修改经验值）
- 登出时如果在旅店，记录闭关开始时间
- 再次登录时显示"闭关XX小时，感悟颇深，修炼进度加快"
- 注意：所有修为/修炼进度提示仅为沉浸式体验，不修改游戏实际经验值

**API调用**: `GetRestState()`, `GetXPExhaustion()`

### 5.6 心魔系统 (Inner Demon)

当玩家受到控制效果时，显示心魔入侵提示。

| 魔兽效果 | 修仙概念 |
|---------|---------|
| 恐惧 | 心魔入侵 |
| 魅惑 | 情劫降临 |
| 沉默 | 封印灵力 |
| 眩晕 | 神识震荡 |
| 变羊 | 化形之术 |
| 减速 | 灵力凝滞 |

**心魔值系统**:
- 死亡 +5 心魔值
- PvP击杀 -3 心魔值
- 完成任务 -1 心魔值
- 在线每小时 +1 心魔值

**心魔效果**:
- 0-20: 心境平和，无效果
- 21-50: 心浮气躁，属性-5%
- 51-80: 心魔滋生，属性-15%
- 81-100: 走火入魔，属性-30%

**心魔消除**: 打坐修炼(-1/分钟)、完成宗门任务(-5)、使用清心丹(-20)

**API调用**: 监听 `UNIT_AURA` 事件，遍历debuff检查控制效果类型

### 5.7 仙缘系统 (Karmic Destiny)

记录玩家的"仙缘时刻"——稀有掉落、稀有精英击杀等。

| 魔兽事件 | 仙缘类型 |
|---------|---------|
| 获得稀有/史诗掉落 | 天降灵宝 |
| 击杀稀有精英 | 仙缘际遇 |
| 完成困难成就 | 道心坚定 |
| 首次击杀Boss | 秘境首通 |
| 获得坐骑 | 灵兽认主 |

**API调用**: `CHAT_MSG_LOOT`, `CRITERIA_COMPLETE`, `COMBAT_LOG_EVENT_UNFILTERED`

### 5.8 道侣系统 (Dao Companion)

| 魔兽概念 | 修仙概念 |
|---------|---------|
| 好友 | 道友 |
| 好友上线 | 道友出关 |
| 好友下线 | 道友闭关 |
| 密语 | 传音入密 |
| 好友列表 | 道友录 |
| 忽略列表 | 绝交录 |

**API调用**: `GetNumFriends()`, `GetFriendInfo(index)`, `FRIENDLIST_UPDATE`

### 5.9 灵脉修炼 (Spirit Vein Cultivation)

| 区域类型 | 灵脉品质 | 描述 |
|---------|---------|------|
| 主城 | 灵脉汇聚 | 灵气充沛，修炼事半功倍 |
| 野外普通区域 | 灵脉稀薄 | 灵气稀薄，修炼缓慢 |
| 副本内 | 灵脉浓郁 | 秘境中灵气浓郁，修炼加速 |
| 休息区 | 灵脉温润 | 温润灵脉，适合闭关 |

**API调用**: `GetRealZoneText()`, `GetZonePVPInfo()`, `IsInInstance()`

### 5.10 因果系统 (Karma System)

| 行为 | 因果类型 | 因果值 |
|------|---------|-------|
| 击杀敌对玩家 | 杀业 | +1 |
| 治疗友方 | 善因 | +1 |
| 完成任务 | 善因 | +1 |
| 需求贪婪装备 | 执念 | 记录 |
| 帮助低等级玩家 | 善因 | +2 |

**API调用**: `CombatLog` 事件追踪，自定义SavedVariables存储

### 5.11 丹药系统 (Elixir System)

将药水/合剂/食物映射为丹药。

| 魔兽物品 | 修仙丹药 | 效果 |
|---------|---------|------|
| 治疗药水 | 回血丹 | 恢复生命值 |
| 法力药水 | 回气丹 | 恢复法力值 |
| 合剂 | 天元丹 | 长时间属性加成 |
| 食物 | 灵膳 | 恢复生命法力 |
| 清心丹(自定义) | 清心丹 | 消除心魔值 |
| 聚气丹(自定义) | 聚气丹 | 修炼感悟提升（仅提示，不修改经验） |
| 筑基丹(自定义) | 筑基丹 | 突破成功率提升（仅提示，不修改经验） |

### 5.12 灵兽系统 (Spirit Beast System)

| 魔兽概念 | 修仙概念 |
|---------|---------|
| 坐骑 | 灵兽坐骑 |
| 宠物 | 灵兽伙伴 |
| 猎人宠物 | 本命灵兽 |

### 5.13 天道法则提示

游戏规则提示修仙化：
- "你的灵力不足以施展此术" (法力不足)
- "此秘境需结丹以上修为方可进入" (等级不足)
- "你与该修士因果太深，无法攻击" (友方)
- "灵力凝滞，无法移动" (定身)

### 5.14 修炼日志

自动记录每日修炼历程：
- "今日修为精进XX点"
- "今日获得灵宝X件"
- "今日探索秘境X个"
- "今日斗法胜绩X次"

---

## 六、插件架构与模块设计

### 6.1 整体架构

```
WoWCultivation/
├── WoWCultivation.toc          # 插件描述文件
├── Init.lua                    # 全局初始化 & 命名空间
├── Core/
│   ├── EventManager.lua        # 事件管理器(统一注册/分发)
│   ├── Database.lua            # SavedVariables 数据持久化
│   ├── Utils.lua               # 工具函数库
│   └── Config.lua              # 插件配置(Slash命令/设置面板)
├── Modules/
│   ├── RealmModule.lua         # 境界系统(等级→修仙境界)
│   ├── SectModule.lua          # 宗门系统(职业→修仙门派)
│   ├── CurrencyModule.lua      # 灵石系统(货币→灵石)
│   ├── TreasureModule.lua      # 灵宝系统(装备→灵宝)
│   ├── ProfessionModule.lua    # 副职系统(专业→修仙副职)
│   ├── MilestoneModule.lua     # 里程碑系统(等级解锁引导)
│   ├── BattlegroundModule.lua  # 宗门争锋(战场→修仙化)
│   ├── SisterModule.lua        # 小师妹系统(3D模型引导)
│   ├── ChannelModule.lua       # 修仙界频道(聊天修仙化)
│   ├── DivineSenseModule.lua   # 神识探查(目标信息修仙化)
│   ├── InnerDemonModule.lua    # 心魔系统(CC效果→心魔)
│   ├── KarmaModule.lua         # 因果系统(行为追踪)
│   ├── KarmicDestinyModule.lua # 仙缘系统(稀有事件记录)
│   ├── DaoCompanionModule.lua  # 道侣系统(好友→道友)
│   ├── SpiritVeinModule.lua    # 灵脉系统(区域→灵脉)
│   ├── ElixirModule.lua        # 丹药系统(药水→丹药)
│   ├── SpiritBeastModule.lua   # 灵兽系统(坐骑/宠物→灵兽)
│   ├── CultivationLogModule.lua# 修炼日志(每日记录)
│   └── DaoTitleModule.lua      # 道号系统(头衔→道号)
├── UI/
│   ├── MainFrame.lua           # 修仙主界面
│   ├── SisterModel.lua         # 小师妹3D模型
│   ├── MilestonePopup.lua      # 里程碑弹窗
│   ├── DivineSenseFrame.lua    # 神识探查面板
│   ├── Toast.lua               # 轻提示系统
│   ├── RealmLabel.lua          # 境界标签(目标框)
│   └── CultivationBar.lua      # 修仙信息条(灵石/道行)
├── Data/
│   ├── RealmData.lua           # 境界映射数据
│   ├── SectData.lua            # 宗门映射数据
│   ├── BattlegroundData.lua    # 战场映射数据
│   ├── MilestoneData.lua       # 里程碑数据
│   ├── ProfessionData.lua      # 副职映射数据
│   ├── ElixirData.lua          # 丹药映射数据
│   └── TitleData.lua           # 道号映射数据
└── Locale/
    └── zhCN.lua                # 中文本地化
```

### 6.2 TOC 文件配置

```toc
## Interface: 30300
## Title: 魔兽修仙传
## Title-zhCN: 魔兽修仙传
## Notes: 修仙之路，道阻且长
## Notes-zhCN: 将魔兽世界化为修仙界
## Author: XiuxianDev
## Version: 1.0
## SavedVariables: WoWCultivationDB
## SavedVariablesPerCharacter: WoWCultivationCharDB

# Core
Init.lua
Core\EventManager.lua
Core\Database.lua
Core\Utils.lua
Core\Config.lua

# Data
Data\RealmData.lua
Data\SectData.lua
Data\BattlegroundData.lua
Data\MilestoneData.lua
Data\ProfessionData.lua
Data\ElixirData.lua
Data\TitleData.lua

# Locale
Locale\zhCN.lua

# Modules
Modules\RealmModule.lua
Modules\SectModule.lua
Modules\CurrencyModule.lua
Modules\TreasureModule.lua
Modules\ProfessionModule.lua
Modules\MilestoneModule.lua
Modules\BattlegroundModule.lua
Modules\SisterModule.lua
Modules\ChannelModule.lua
Modules\DivineSenseModule.lua
Modules\InnerDemonModule.lua
Modules\KarmaModule.lua
Modules\KarmicDestinyModule.lua
Modules\DaoCompanionModule.lua
Modules\SpiritVeinModule.lua
Modules\ElixirModule.lua
Modules\SpiritBeastModule.lua
Modules\CultivationLogModule.lua
Modules\DaoTitleModule.lua

# UI
UI\MainFrame.lua
UI\SisterModel.lua
UI\MilestonePopup.lua
UI\DivineSenseFrame.lua
UI\Toast.lua
UI\RealmLabel.lua
UI\CultivationBar.lua
```

### 6.3 核心框架设计

#### 6.3.1 命名空间 (Init.lua)

```lua
WoWCultivation = {}
WoWCultivation.version = "1.0"

WoWCultivation.Core = {}
WoWCultivation.Modules = {}
WoWCultivation.UI = {}
WoWCultivation.Data = {}
WoWCultivation.Locale = {}

WoWCultivation.debug = false

function WoWCultivation:Print(msg)
    print("|cFF00FF00[修仙传]|r " .. msg)
end

function WoWCultivation:Debug(msg)
    if self.debug then
        print("|cFFFF9900[修仙传·调试]|r " .. msg)
    end
end
```

#### 6.3.2 事件管理器 (EventManager.lua)

```lua
local EventManager = CreateFrame("Frame")
WoWCultivation.Core.EventManager = EventManager

local eventHandlers = {}

EventManager:SetScript("OnEvent", function(self, event, ...)
    if eventHandlers[event] then
        for _, handler in ipairs(eventHandlers[event]) do
            handler(...)
        end
    end
end)

function EventManager:Register(event, handler)
    if not eventHandlers[event] then
        eventHandlers[event] = {}
        self:RegisterEvent(event)
    end
    table.insert(eventHandlers[event], handler)
end

function EventManager:Unregister(event, handler)
    if eventHandlers[event] then
        for i, h in ipairs(eventHandlers[event]) do
            if h == handler then
                table.remove(eventHandlers[event], i)
                break
            end
        end
        if #eventHandlers[event] == 0 then
            self:UnregisterEvent(event)
            eventHandlers[event] = nil
        end
    end
end

function EventManager:Trigger(event, ...)
    if eventHandlers[event] then
        for _, handler in ipairs(eventHandlers[event]) do
            handler(...)
        end
    end
end
```

#### 6.3.3 数据持久化 (Database.lua)

```lua
local DB = {}
WoWCultivation.Core.DB = DB

local DEFAULT_ACCOUNT_DB = {
    version = WoWCultivation.version,
    settings = {
        sisterEnabled = true,
        channelEnabled = true,
        toastEnabled = true,
        realmLabelEnabled = true,
        chatFilterEnabled = true,
        innerDemonEnabled = true,
    },
}

local DEFAULT_CHAR_DB = {
    milestones = {
        talent = false,
        randomDungeon = false,
        firstRandomDungeon = false,
        mount = false,
        pvp = false,
        sect = false,
        foundation = false,
        outland = false,
        goldenCore = false,
        northrend = false,
        nascentSoul = false,
        peak = false,
    },
    innerDemon = {
        value = 0,
        lastUpdate = 0,
    },
    karma = {
        good = 0,
        evil = 0,
    },
    karmicDestiny = {},
    cultivationLog = {},
    firstLoad = true,
    sisterPosition = { point = "CENTER", x = 300, y = 0 },
}

function DB:Init()
    if not WoWCultivationDB then
        WoWCultivationDB = {}
    end
    if not WoWCultivationCharDB then
        WoWCultivationCharDB = {}
    end
    self:MergeDefaults(WoWCultivationDB, DEFAULT_ACCOUNT_DB)
    self:MergeDefaults(WoWCultivationCharDB, DEFAULT_CHAR_DB)
end

function DB:MergeDefaults(db, defaults)
    for k, v in pairs(defaults) do
        if db[k] == nil then
            db[k] = v
        elseif type(v) == "table" and type(db[k]) == "table" then
            self:MergeDefaults(db[k], v)
        end
    end
end

function DB:GetAccount(key)
    return WoWCultivationDB[key]
end

function DB:SetAccount(key, value)
    WoWCultivationDB[key] = value
end

function DB:GetChar(key)
    return WoWCultivationCharDB[key]
end

function DB:SetChar(key, value)
    WoWCultivationCharDB[key] = value
end
```

#### 6.3.4 工具函数 (Utils.lua)

```lua
local Utils = {}
WoWCultivation.Core.Utils = Utils

function Utils:GetPlayerRealmInfo()
    local level = UnitLevel("player")
    return WoWCultivation.Data.Realm[level] or {}
end

function Utils:GetPlayerSectInfo()
    local _, class = UnitClass("player")
    return WoWCultivation.Data.Sect[class] or {}
end

function Utils:GetCurrencyText()
    local gold = floor(GetMoney() / 10000)
    local silver = floor((GetMoney() % 10000) / 100)
    local copper = GetMoney() % 100
    return format("|cFFFFD700%d上品灵石|r |cFFC0C0C0%d中品灵石|r |cFFCD853F%d下品灵石|r", gold, silver, copper)
end

function Utils:FormatRealmName(level)
    local realm = WoWCultivation.Data.Realm[level]
    if not realm then return "未知境界" end
    return format("%s·%s", realm.bigRealm, realm.name)
end

function Utils:QualityToRank(quality)
    local ranks = {
        [0] = "凡器", [1] = "法器", [2] = "灵器",
        [3] = "宝器", [4] = "灵宝", [5] = "仙器",
        [6] = "先天灵宝",
    }
    return ranks[quality] or "未知品阶"
end

function Utils:QualityColor(quality)
    local colors = {
        [0] = "9d9d9d", [1] = "ffffff", [2] = "1eff00",
        [3] = "0070dd", [4] = "a335ee", [5] = "ff8000",
        [6] = "e6cc80", [7] = "e6cc80",
    }
    return colors[quality] or "ffffff"
end
```

### 6.4 模块注册机制

每个模块遵循统一接口：

```lua
local Module = {}
Module.name = "RealmModule"
Module.enabled = false

function Module:OnEnable()
    self.enabled = true
    WoWCultivation.Core.EventManager:Register("PLAYER_LEVEL_UP", function(level)
        self:OnLevelUp(level)
    end)
    WoWCultivation.Core.EventManager:Register("PLAYER_ENTERING_WORLD", function()
        self:OnEnteringWorld()
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:OnLevelUp(level)
    local realmInfo = WoWCultivation.Data.Realm[level]
    if realmInfo then
        WoWCultivation:Print("恭喜突破至 " .. realmInfo.name .. "！")
        if realmInfo.milestone then
            WoWCultivation.Modules.MilestoneModule:Trigger(realmInfo.milestone)
        end
    end
end

function Module:OnEnteringWorld()
    local level = UnitLevel("player")
    local realmInfo = WoWCultivation.Data.Realm[level]
    if realmInfo then
        WoWCultivation:Print("当前境界: " .. realmInfo.bigRealm .. " · " .. realmInfo.name)
    end
end

WoWCultivation.Modules.RealmModule = Module
```

### 6.5 模块加载顺序

```
1. Core (EventManager → Database → Utils → Config)
2. Data (所有数据表加载，无依赖)
3. Locale (本地化字符串)
4. Modules (按依赖顺序):
   - RealmModule (基础，无依赖)
   - SectModule (基础，无依赖)
   - CurrencyModule (基础，无依赖)
   - TreasureModule (基础，无依赖)
   - ProfessionModule (基础，无依赖)
   - MilestoneModule (依赖 RealmModule)
   - BattlegroundModule (依赖 RealmModule, SectModule)
   - SisterModule (依赖 MilestoneModule)
   - ChannelModule (依赖 SectModule)
   - DivineSenseModule (依赖 RealmModule, SectModule)
   - InnerDemonModule (依赖 EventManager)
   - KarmaModule (依赖 EventManager)
   - KarmicDestinyModule (依赖 EventManager)
   - DaoCompanionModule (依赖 EventManager)
   - SpiritVeinModule (依赖 RealmModule)
   - ElixirModule (基础，无依赖)
   - SpiritBeastModule (基础，无依赖)
   - CultivationLogModule (依赖 多个模块)
   - DaoTitleModule (依赖 RealmModule)
5. UI (依赖 Modules):
   - CultivationBar (依赖 CurrencyModule, RealmModule)
   - RealmLabel (依赖 RealmModule)
   - Toast (无模块依赖)
   - SisterModel (依赖 SisterModule)
   - MilestonePopup (依赖 MilestoneModule)
   - DivineSenseFrame (依赖 DivineSenseModule)
   - MainFrame (依赖 所有UI)
```

---

## 七、API参考速查

### 7.1 玩家信息 API

| API函数 | 用途 | 修仙映射 |
|--------|------|---------|
| `UnitLevel("player")` | 获取玩家等级 | → 境界层数 |
| `UnitClass("player")` | 获取玩家职业 | → 宗门 |
| `UnitRace("player")` | 获取玩家种族 | → 灵根属性 |
| `UnitName("player")` | 获取玩家名称 | → 道号 |
| `UnitGUID("player")` | 获取玩家GUID | → 仙籍编号 |
| `GetPlayerInfoByGUID(guid)` | 通过GUID获取信息 | → 神识探查 |
| `UnitSex("player")` | 获取性别 | → 仙姿 |
| `UnitFactionGroup("player")` | 获取阵营 | → 正道/魔道 |
| `GetMoney()` | 获取金钱 | → 上品灵石/中品灵石/下品灵石 |
| `GetXPExhaustion()` | 获取休息经验 | → 闭关感悟状态（仅显示） |
| `GetRestState()` | 获取休息状态 | → 闭关状态 |

### 7.2 天赋与专业 API

| API函数 | 用途 | 修仙映射 |
|--------|------|---------|
| `GetNumTalentTabs()` | 天赋树数量 | → 功法方向数 |
| `GetTalentTabInfo(tabIndex)` | 天赋树信息 | → 功法信息 |
| `GetNumTalents(tabIndex)` | 天赋数量 | → 术法数量 |
| `GetTalentInfo(tabIndex, talentIndex)` | 天赋详情 | → 术法详情 |
| `GetProfessions()` | 获取专业列表 | → 副职列表 |
| `GetProfessionInfo(index)` | 专业详情 | → 副职详情 |

### 7.3 装备与物品 API

| API函数 | 用途 | 修仙映射 |
|--------|------|---------|
| `GetInventoryItemQuality("player", slot)` | 装备品质 | → 灵宝品阶 |
| `GetInventoryItemLink("player", slot)` | 装备链接 | → 灵宝详情 |
| `GetItemQualityColor(quality)` | 品质颜色 | → 品阶颜色 |
| `GetItemInfo(itemID)` | 物品信息 | → 灵物信息 |
| `GetContainerItemInfo(bag, slot)` | 背包物品 | → 储物袋 |

### 7.4 PvP与战场 API

| API函数 | 用途 | 修仙映射 |
|--------|------|---------|
| `GetPVPRankInfo(rank)` | PvP等级信息 | → 斗法境界 |
| `UnitPVPRank("player")` | PvP等级ID | → 斗法境界ID |
| `GetHonorCurrency()` | 荣誉点数 | → 斗法积分 |
| `GetRealZoneText()` | 当前区域 | → 秘境/灵脉 |
| `IsInInstance()` | 是否副本/战场 | → 是否秘境 |
| `GetZonePVPInfo()` | 区域PvP信息 | → 灵脉争端 |

### 7.5 聊天与社交 API

| API函数 | 用途 | 修仙映射 |
|--------|------|---------|
| `JoinChannelByName(name)` | 加入频道 | → 进入修仙界 |
| `ChatFrame_AddChannel(frame, name)` | 添加频道 | → 开启修仙界传音 |
| `ChatFrame_AddMessageEventFilter()` | 消息过滤 | → 传音转化 |
| `GetNumFriends()` | 好友数量 | → 道友数量 |
| `GetFriendInfo(index)` | 好友信息 | → 道友信息 |
| `GetNumIgnores()` | 忽略数量 | → 绝交数量 |

### 7.6 UI 框架 API

| API函数 | 用途 | 修仙映射 |
|--------|------|---------|
| `CreateFrame(type, name, parent)` | 创建框架 | → 创建修仙界面 |
| `PlayerModel:SetCreature(id)` | 设置3D模型 | → 小师妹形象 |
| `PlayerModel:SetCamera(index)` | 设置镜头 | → 调整视角 |
| `FontString:SetText(text)` | 设置文字 | → 显示修仙信息 |
| `Texture:SetTexture(path)` | 设置贴图 | → 修仙特效 |

### 7.7 成就与声望 API

| API函数 | 用途 | 修仙映射 |
|--------|------|---------|
| `GetTotalAchievementPoints()` | 成就点数 | → 道行 |
| `GetNumCompletedAchievements()` | 完成成就数 | → 道果数 |
| `GetAchievementInfo(id)` | 成就详情 | → 道果详情 |
| `GetNumFactions()` | 声望阵营数 | → 功德簿 |
| `GetFactionInfo(index)` | 声望详情 | → 因果详情 |

---

## 八、事件参考速查

### 8.1 核心事件

| 事件名 | 触发时机 | 修仙用途 |
|-------|---------|---------|
| `PLAYER_ENTERING_WORLD` | 登录/加载界面 | 初始化修仙状态 |
| `PLAYER_LEVEL_UP` | 升级 | 境界突破/里程碑检测 |
| `PLAYER_XP_UPDATE` | 经验变化 | 修炼进度提示（仅显示层） |
| `PLAYER_DEAD` | 玩家死亡 | 心魔值增加/道心考验 |
| `PLAYER_ALIVE` | 玩家复活 | 重塑肉身 |

### 8.2 战斗事件

| 事件名 | 触发时机 | 修仙用途 |
|-------|---------|---------|
| `UNIT_AURA` | 光环变化 | 心魔检测(控制效果) |
| `COMBAT_LOG_EVENT_UNFILTERED` | 战斗日志 | 因果系统追踪 |
| `PLAYER_PVP_KILLS_CHANGED` | PvP击杀变化 | 斗法胜绩 |
| `PLAYER_PVP_RANK_CHANGED` | PvP等级变化 | 斗法境界突破 |

### 8.3 副本与战场事件

| 事件名 | 触发时机 | 修仙用途 |
|-------|---------|---------|
| `LFG_PROPOSAL_SHOW` | 副本邀请 | 秘境之门开启 |
| `LFG_COMPLETION_REWARD` | 副本完成 | 秘境首通道果 |
| `ZONE_CHANGED_NEW_AREA` | 区域变化 | 灵脉检测/战场检测 |
| `PLAYER_ENTERING_BATTLEGROUND` | 进入战场 | 宗门争锋开启 |

### 8.4 社交事件

| 事件名 | 触发时机 | 修仙用途 |
|-------|---------|---------|
| `FRIENDLIST_UPDATE` | 好友列表更新 | 道友出关/闭关 |
| `CHAT_MSG_WHISPER` | 收到密语 | 传音入密 |
| `CHAT_MSG_CHANNEL` | 频道消息 | 修仙界传音 |
| `CHAT_MSG_GUILD` | 公会消息 | 宗门传音 |
| `CHAT_MSG_LOOT` | 掉落消息 | 天降灵宝检测 |

### 8.5 成就事件

| 事件名 | 触发时机 | 修仙用途 |
|-------|---------|---------|
| `ACHIEVEMENT_EARNED` | 获得成就 | 道果获得 |
| `CRITERIA_COMPLETE` | 成就进度 | 道果精进 |
| `HONOR_CURRENCY_UPDATE` | 荣誉更新 | 斗法积分更新 |

---

## 九、开发规范与注意事项

### 9.1 编码规范

- **命名空间**: 所有全局变量挂载在 `WoWCultivation` 命名空间下，避免全局污染
- **变量命名**: 驼峰式 `camelCase`，常量全大写 `UPPER_SNAKE_CASE`
- **函数命名**: 模块方法使用 `PascalCase`，局部函数使用 `camelCase`
- **文件编码**: UTF-8 with BOM (确保中文正确显示)
- **缩进**: 4空格缩进
- **字符串**: 中文内容使用双引号，代码标识符使用单引号

### 9.2 性能优化

- **事件节流**: 高频事件(如 `UNIT_AURA`)使用节流处理，避免每帧触发
- **缓存机制**: 频繁查询的数据(境界/门派)使用本地缓存，减少API调用
- **懒加载**: 非核心模块按需加载，减少登录时开销
- **OnUpdate最小化**: 仅在必要时注册 `OnUpdate`，且逻辑尽量轻量
- **字符串池**: 频繁使用的修仙术语使用常量，避免重复创建字符串

### 9.3 兼容性注意

- **目标版本**: WotLK 3.3.5 (Interface: 30300)
- **API差异**: 注意泰坦时光服可能存在的API差异，需实际测试
- **事件差异**: 部分事件名可能与正式服不同，需验证
- **中文客户端**: 假设运行环境为中文客户端，部分API返回值依赖中文
- **SavedVariables**: 登出时自动保存，避免频繁写入

### 9.4 调试模式

```lua
SlashCmdList["XIUXIAN"] = function(msg)
    msg = msg:lower():trim()
    if msg == "debug" then
        WoWCultivation.debug = not WoWCultivation.debug
        WoWCultivation:Print("调试模式: " .. (WoWCultivation.debug and "开启" or "关闭"))
    elseif msg == "reset" then
        WoWCultivationCharDB = nil
        ReloadUI()
    elseif msg == "milestone" then
        local level = UnitLevel("player")
        WoWCultivation.Modules.MilestoneModule:CheckMilestones(level)
    elseif msg == "sister" then
        WoWCultivation.UI.SisterModel:Toggle()
    elseif msg == "realm" then
        local info = WoWCultivation.Core.Utils:GetPlayerRealmInfo()
        WoWCultivation:Print("当前境界: " .. (info.bigRealm or "未知") .. " · " .. (info.name or "未知"))
    end
end
SLASH_XIUXIAN1 = "/xiuxian"
SLASH_XIUXIAN2 = "/xxz"
```

### 9.5 版本规划

| 版本 | 功能范围 | 状态 |
|------|---------|------|
| v0.1.0 | 境界系统 + 宗门系统 + 灵石系统 | 已完成 |
| v0.2.0 | 里程碑系统 + 小师妹引导 + 副职系统 | 开发中 |
| v0.3.0 | 战场系统 + 神识探查 + 修仙界频道 | 计划中 |
| v0.4.0 | 心魔系统 + 因果系统 + 仙缘系统 | 计划中 |
| v0.5.0 | 修仙主界面 + 修炼日志 + 丹药系统 | 计划中 |
| v1.0.0 | 全功能整合 + UI美化 + 性能优化 | 远期目标 |

---

## 附录A：修仙术语速查表

| 修仙术语 | 魔兽对应 | 英文标识 |
|---------|---------|---------|
| 修为 | 等级 | Level |
| 境界 | 等级区间 | Realm |
| 灵根 | 种族/天赋 | SpiritRoot |
| 功法 | 天赋树 | Technique |
| 术法 | 天赋/技能 | Spell |
| 宗门 | 职业 | Sect |
| 灵石 | 银币 | SpiritStone |
| 上品灵石 | 金币 | SpiritGold |
| 下品灵石 | 铜币 | SpiritCopper |
| 灵宝 | 装备 | SpiritTreasure |
| 凡器 | 灰色品质 | Mortal |
| 法器 | 白色品质 | Artifact |
| 灵器 | 绿色品质 | SpiritTool |
| 宝器 | 蓝色品质 | Treasure |
| 灵宝(紫) | 紫色品质 | SpiritTreasure |
| 仙器 | 橙色品质 | Immortal |
| 先天灵宝 | 神器 | InnateTreasure |
| 秘境 | 副本 | SecretRealm |
| 小秘境 | 随机副本 | MinorRealm |
| 天劫 | 等级突破 | HeavenlyTribulation |
| 闭关 | 旅店休息 | SecludedCultivation |
| 心魔 | 控制效果 | InnerDemon |
| 道行 | 成就点数 | DaoMerit |
| 道果 | 成就 | DaoFruit |
| 道号 | 头衔 | DaoTitle |
| 斗法 | PvP | Dueling |
| 宗门争锋 | 战场 | SectBattle |
| 斗法台 | 竞技场 | DuelArena |
| 斗法胜绩 | 荣誉击杀 | DuelVictory |
| 斗法积分 | 荣誉点数 | DuelPoints |
| 斗法境界 | PvP等级 | DuelRealm |
| 传音入密 | 密语 | Whisper |
| 宗门传音 | 公会聊天 | GuildMessage |
| 神识探查 | 检视玩家 | DivineSense |
| 灵脉 | 区域灵气 | SpiritVein |
| 灵兽 | 坐骑/宠物 | SpiritBeast |
| 丹药 | 药水/合剂 | Elixir |
| 炼丹术 | 炼金 | Alchemy |
| 炼器术 | 附魔 | Enchanting |
| 制符术 | 铭文 | Inscription |
| 阵法之道 | 珠宝 | Jewelcrafting |
| 铸兵术 | 锻造 | Blacksmithing |
| 炼皮术 | 制皮 | Leatherworking |
| 织袍术 | 裁缝 | Tailoring |
| 机关术 | 工程 | Engineering |
| 灵植采集 | 草药 | Herbalism |
| 灵矿开采 | 采矿 | Mining |
| 妖兽取材 | 剥皮 | Skinning |
| 灵水垂钓 | 钓鱼 | Fishing |
| 灵食制作 | 烹饪 | Cooking |
| 因果 | 行为记录 | Karma |
| 仙缘 | 稀有事件 | KarmicDestiny |
| 道友 | 好友 | DaoCompanion |
| 灵脉驿站 | 骑术训练师 | SpiritVeinStation |
| 储物袋 | 背包 | StorageBag |
| 道心 | 心态/意志 | DaoHeart |

---

*文档版本: v0.3.0 | 最后更新: 2026-05-28 | 维护: XiuxianDev*
