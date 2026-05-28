# 魔兽修仙传 开发手册(5) — 神识探查与聊天修仙化

> 本手册是系列开发手册的第5份，定义右键菜单探查玩家修仙信息和聊天系统修仙化方案。
> AI识别标记：STRUCTURED_DEVELOPMENT_MANUAL_PART_05

---

## 五、特色系统设计

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

---

## 相关手册

- [开发手册(1) — 项目概述与核心概念映射](./DEV_MANUAL.md#一项目概述) — 项目架构、境界系统、门派系统、灵石系统等核心映射表
- [开发手册(2) — 灵宝系统与灵根功法](./DEV_MANUAL.md#24-灵宝系统-spirit-treasure-system) — 装备到灵宝映射、天赋到功法映射、属性修仙化
- [开发手册(3) — 道果系统与秘境系统](./DEV_MANUAL.md#26-道果系统-dao-fruit--achievement-system) — 成就道果化、副本秘境化、道号系统、百艺系统
- [开发手册(4) — 战场宗门争锋与里程碑系统](./DEV_MANUAL.md#四战场系统--宗门争锋-sect-battle-system) — 战场修仙化、斗法境界、里程碑引导、小师妹系统
- **开发手册(5) — 神识探查与聊天修仙化** (当前手册)
- [开发手册(6) — 修仙主界面与特色玩法](./DEV_MANUAL.md#54-修仙主界面-cultivation-main-interface) — 主界面布局、闭关系统、心魔系统、仙缘系统、丹药系统

---

*本文档基于 DEV_MANUAL.md v0.3.0 提取 | 2026-05-28*
