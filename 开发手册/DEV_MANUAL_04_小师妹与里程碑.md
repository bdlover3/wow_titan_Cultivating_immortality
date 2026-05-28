# 魔兽修仙传 开发手册(4) — 小师妹引导与里程碑系统

> 本手册是系列开发手册的第4份，定义小师妹3D模型交互、修仙主界面布局和里程碑触发系统。
> AI识别标记：STRUCTURED_DEVELOPMENT_MANUAL_PART_04

---

## 一、修仙里程碑系统 (Milestone System)

### 1.1 里程碑总览

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

### 1.2 里程碑详细设计

#### 1.2.1 灵根觉醒 (10级 — 天赋解锁)

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

#### 1.2.2 小秘境历练 (15级 — 随机副本解锁)

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

#### 1.2.3 灵兽认主 (20级 — 骑术/坐骑)

**触发条件**: 玩家等级达到20级，可学习骑术

**小师妹引导剧情**:
```
小师妹: "师兄修为精进，已可契约灵兽代步了！"
小师妹: "前往灵脉驿站(骑术训练师)，学习御兽之术吧。"
小师妹: "有了灵兽相伴，修仙之路更加便捷！"
```

#### 1.2.4 宗门争锋 (30级 — 战场开放)

**触发条件**: 玩家等级达到30级，可进入战场

**小师妹引导剧情**:
```
小师妹: "师兄，修仙界风云变幻，宗门争锋即将开始！"
小师妹: "点击【宗门争锋】(战场)，代表我宗出战吧！"
小师妹: "斗法胜绩可换取斗法积分，兑换灵宝丹药！"
```

#### 1.2.5 天劫突破 (40/58/60/68/70/80级)

| 触发条件 | 天劫类型 | 表现 |
|---------|---------|------|
| 升级到40级 | 筑基天劫 | 屏幕雷电特效+小师妹提示"师兄，筑基天劫已至！" |
| 升级到58级 | 外域天门 | 提示"天门已开，外域秘境向你敞开！" |
| 升级到60级 | 结丹天劫 | 屏幕雷电特效+小师妹提示"师兄，结丹天劫降临！" |
| 升级到68级 | 北域天门 | 提示"北域之门已开，诺森德秘境等你探索！" |
| 升级到70级 | 元婴天劫 | 屏幕雷电特效+小师妹提示"师兄，元婴天劫降临！" |
| 升级到80级 | 飞升天劫 | 全屏特效+小师妹提示"师兄，你已到达元婴巅峰！" |

**API调用**: 监听 `PLAYER_LEVEL_UP` 事件

### 1.3 里程碑数据结构

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

## 二、小师妹系统 (Junior Sister Guide)

### 2.1 功能描述
- 使用血精灵女性3D模型作为小师妹形象
- 小师妹悬浮在屏幕可拖拽位置
- 点击小师妹打开修仙主界面
- 首次加载时播放引导剧情
- 里程碑触发时主动对话提示

### 2.2 模型实现
```lua
local model = CreateFrame("PlayerModel", "WoWCultivationSisterModel", UIParent)
model:SetSize(200, 300)
model:SetPoint("CENTER")
model:SetCreature(模型ID)
model:SetPosition(0, 0, 0)
model:SetRotation(0)
model:SetCamera(0)
```

### 2.3 交互设计
- 左键点击: 打开修仙主界面
- 右键点击: 弹出快捷菜单(设置/隐藏/重置位置)
- 鼠标悬停: 显示小师妹对话气泡
- 拖拽: 移动小师妹位置

### 2.4 引导剧情 (首次加载)

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

---

## 三、修仙主界面 (Cultivation Main Interface)

### 3.1 功能描述
点击小师妹后打开的修仙主界面，整合所有修仙功能的入口。

### 3.2 界面布局

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

### 3.3 功能入口说明

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

---

## 相关手册

本手册是系列开发手册的第4份，其他手册如下：

| 手册编号 | 涵盖内容 | 文件 |
|---------|---------|------|
| 第1份 | 项目概述、核心概念映射表（境界/门派/灵石/灵宝/灵根功法/道果/道号/秘境/百艺/功德系统） | `DEV_MANUAL.md` |
| 第2份 | 灵宝鉴定与强化系统、功法系统、道果系统、道号系统 | `DEV_MANUAL_02_灵宝与功法系统.md` |
| 第3份 | 战场系统（宗门争锋）、神识探查系统、修仙界频道 | `DEV_MANUAL.md` |
| **第4份** | **小师妹系统、修仙主界面、里程碑系统（本手册）** | `DEV_MANUAL_04_小师妹与里程碑.md` |
| 第5份 | 插件架构、模块设计、API参考、事件参考、开发规范 | `DEV_MANUAL.md` |
| 第6份 | 闭关系统、心魔系统、仙缘系统、道侣系统、灵脉修炼、因果系统、丹药系统、灵兽系统 | `DEV_MANUAL_06_特色玩法系统.md` |

---

*文档版本: v0.3.0 | 最后更新: 2026-05-28 | 基于 DEV_MANUAL.md 提取*
