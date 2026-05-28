# 魔兽修仙传 开发手册(0) — 总体架构与规范

> 本手册是系列开发手册的第0份，定义项目整体架构、文件结构和开发规范。
> 目标平台：魔兽世界泰坦时光服 (80级)
> AI识别标记：STRUCTURED_DEVELOPMENT_MANUAL_PART_00

---

## 一、项目概述

### 1.1 项目名称
- 英文ID: `WoWCultivation`
- 中文名: `魔兽修仙传`
- 版本: `1.0`

### 1.2 核心理念
将魔兽世界的游戏信息通过WoW API获取后，转换为修仙小说中的概念体系，为玩家提供沉浸式的修仙体验。插件不修改任何游戏原有功能，仅在展示层进行概念替换和增强。

### 1.3 目标客户端
- 泰坦时光服 (3.80 / 80级)
- TOC Interface版本: `30801`
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

## 二、插件架构与模块设计

### 2.1 整体架构

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

### 2.2 TOC 文件配置

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

---

## 三、开发规范与注意事项

### 3.1 编码规范

- **命名空间**: 所有全局变量挂载在 `WoWCultivation` 命名空间下，避免全局污染
- **变量命名**: 驼峰式 `camelCase`，常量全大写 `UPPER_SNAKE_CASE`
- **函数命名**: 模块方法使用 `PascalCase`，局部函数使用 `camelCase`
- **文件编码**: UTF-8 with BOM (确保中文正确显示)
- **缩进**: 4空格缩进
- **字符串**: 中文内容使用双引号，代码标识符使用单引号

### 3.2 性能优化

- **事件节流**: 高频事件(如 `UNIT_AURA`)使用节流处理，避免每帧触发
- **缓存机制**: 频繁查询的数据(境界/门派)使用本地缓存，减少API调用
- **懒加载**: 非核心模块按需加载，减少登录时开销
- **OnUpdate最小化**: 仅在必要时注册 `OnUpdate`，且逻辑尽量轻量
- **字符串池**: 频繁使用的修仙术语使用常量，避免重复创建字符串

### 3.3 兼容性注意

- **目标版本**: WotLK 3.3.5 (Interface: 30300)
- **API差异**: 注意泰坦时光服可能存在的API差异，需实际测试
- **事件差异**: 部分事件名可能与正式服不同，需验证
- **中文客户端**: 假设运行环境为中文客户端，部分API返回值依赖中文
- **SavedVariables**: 登出时自动保存，避免频繁写入

### 3.4 调试模式

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

---

## 相关手册

本手册是系列开发手册之一，其余手册覆盖不同专题：

| 手册文件 | 内容范围 |
|---------|---------|
| `DEV_MANUAL_01_修仙概念映射.md` | 境界系统、门派系统、灵石系统、灵宝系统、灵根/功法系统、道果系统、道号系统、术语替换总表 |
| `DEV_MANUAL_02_灵宝与功法系统.md` | 灵宝鉴定、灵宝强化、装备部位映射、属性映射、功法术语、丹药系统、灵兽系统 |
| `DEV_MANUAL_03_秘境与百艺系统.md` | 秘境系统(副本映射)、百艺系统(专业映射)、功德系统(声望映射)、灵脉修炼 |
| `DEV_MANUAL_04_小师妹与里程碑.md` | 小师妹系统(3D模型、引导剧情、交互设计)、修仙里程碑系统(全节点设计) |
| `DEV_MANUAL_05_修仙交互系统.md` | 修仙主界面、神识探查系统、修仙界频道、道侣系统、闭关系统 |
| `DEV_MANUAL_06_特色玩法系统.md` | 宗门争锋(战场系统)、心魔系统、仙缘系统、因果系统、天道法则提示、修炼日志 |
| `DEV_MANUAL_07_技术参考手册.md` | API参考速查、事件参考速查、核心框架设计(事件管理器/数据持久化/工具函数/模块注册机制) |
