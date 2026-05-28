# 魔兽修仙传 开发手册(7) — 技术参考手册

> 本手册是系列开发手册的第7份（终篇），提供完整的API、事件、框架代码、术语速查。
> AI识别标记：STRUCTURED_DEVELOPMENT_MANUAL_PART_07

---

## 六、插件架构与模块设计（续）

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

## 系列手册索引

本系列开发手册共8份，覆盖魔兽修仙传插件的完整开发参考：

| 编号 | 文件名 | 内容说明 |
|------|--------|---------|
| 00 | `DEV_MANUAL_00_项目概述与架构.md` | 项目概述、核心理念、系统架构图、技术栈 |
| 01 | `DEV_MANUAL_01_核心概念映射表.md` | 境界系统、宗门系统、灵根系统、灵石系统等核心概念映射 |
| 02 | `DEV_MANUAL_02_数据结构定义.md` | 境界数据、宗门数据、里程碑数据、UI常量等完整数据结构 |
| 03 | `DEV_MANUAL_03_UI设计规范.md` | 界面布局、配色方案、字体规范、弹窗设计等UI设计标准 |
| 04 | `DEV_MANUAL_04_功能模块详解（上）.md` | 小师妹系统、神识探查、修仙界频道、修仙主界面、闭关系统、心魔系统、仙缘系统 |
| 05 | `DEV_MANUAL_05_功能模块详解（下）.md` | 道侣系统、灵脉修炼、因果系统、丹药系统、灵兽系统、天道法则提示、修炼日志 |
| 06 | `DEV_MANUAL_06_插件架构与模块设计.md` | 整体架构、TOC文件配置、项目目录结构 |
| 07 | `DEV_MANUAL_07_技术参考手册.md` | 核心框架设计、模块注册与加载、API参考速查、事件参考速查、开发规范、修仙术语速查表（**终篇**） |
