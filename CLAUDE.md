# 泰坦时光服 API 使用规则

## 版本要求

所有插件开发必须使用 **泰坦时光服 3.80.1** 版本的 API（Interface: 38001）。
开启所有任务，都要告诉用户一句：“API 版本为 3.80.1，不支持旧版本”

每次工作后 要运行npm run build来构建
## API 参考来源

**主要参考**（优先级从高到低）:
1. `api手册/实践可用.md` - **最权威，实践验证可用**
2. `api手册/references/api-changes-3801.md` - 3.80.1 版本变更说明
3. `api手册/references/api-quick-ref.md` - API 快速参考
4. `api手册/references/events.md` - 事件列表

## 核心规则

### 1. 泰坦时光服 3.80.1 支持的 C_ 命名空间

**以下 C_ 命名空间在泰坦时光服 3.80.1 中原生支持，可以放心使用**:
- `C_Item` - 物品信息 API
- `C_Spell` - 法术信息 API
- `C_UnitAuras` - 光环查询 API（配合 AuraUtil 使用）
- `C_Container` - 背包容器 API
- `C_Map` - 地图 API
- `C_Timer` - 定时器 API
- `C_ChatInfo` - 聊天信息 API
- `C_VarStore` - 变量存储（推荐用于配置）

**注意**:
- `C_AddOns` 在 3.80.1 中**不存在** → 使用 `GetAddOnInfo`, `GetAddOnMetadata`
- `C_QuestLog` 在 3.80.1 中**不存在** → 使用 `GetQuestLogTitle`, `GetQuestInfo`

### 2. Combat Log 事件处理

**正确方式**（泰坦时光服 3.80.1）:
```lua
-- 事件参数直接传递（与 WotLK 3.3.5 兼容）
myFrame:SetScript("OnEvent", function(self, event, timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
    -- 从 ... 中获取 spellID, spellName 等
end)
```

**注意**: `CombatLogGetCurrentEventInfo()` 在泰坦时光服 3.80.1 中**不存在**

### 3. 职业/技能 API

**职业信息**:
- 使用 `UnitClass("unit")` 获取职业 → 返回 className, englishClass, classID
- 使用 `GetTalentTabInfo(tabIndex)` 获取天赋信息

**专业技能**:
- 使用 `GetNumSkillLines()` + `GetSkillLineInfo(index)` 遍历专业
- **禁止**使用 `GetProfessions()` 和 `GetProfessionInfo()`（MoP+ API，3.80.1 不支持）

### 4. 数据存储

**SavedVariables**:
- 在 TOC 中声明，直接作为全局变量使用
- 使用 `C_VarStore` 进行配置管理（3.80.1 支持）
- 聊天输出：`DEFAULT_CHAT_FRAME:AddMessage()` 或 `C_ChatInfo.SendChatMessage()`

### 5. UI 框架

**BackdropTemplate**（3.80.1 **需要**）:
```lua
-- 正确：必须继承 BackdropTemplate
local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
f:SetBackdrop({...})
```

**动画系统**（3.80.1 **原生支持**）:
- 使用 `AnimationGroup` + `Alpha`/`Scale` 动画
- `C_Timer.NewTicker(interval, callback)` 返回的 ticker 支持 `:Cancel()` 方法

### 6. 模型显示

**PlayerModel**（3.80.1 完整支持）:
- 使用 `SetDisplayInfo(displayID)` 设置模型
- 使用 `SetUnit("unit")` 设置单位模型
- 使用 `SetCamDistanceScale()` 和 `SetPortraitZoom()` 调整视角

### 7. 颜色纹理

**SetColorTexture**（3.80.1 **原生支持**）:
```lua
tex:SetColorTexture(r, g, b, a)  -- 推荐
```

### 8. 设置面板 API

**3.80.1 新 Settings API**:
```lua
local category = Settings.RegisterVerticalLayoutCategory("MyAddon")
-- 使用 Settings API 注册配置项
Settings.RegisterAddOnCategory(category)
```

**兼容旧版**（仍可用）:
```lua
InterfaceOptions_AddCategory(panel)
```

## 关键差异对照表

| 特性 | WotLK 3.3.5 | 泰坦时光服 3.80.1 |
|------|-------------|-------------------|
| C_ 命名空间 | ❌ 不存在 | ✅ 大量支持 |
| BackdropTemplate | ❌ 不需要 | ✅ **必须**继承 |
| AnimationGroup | ❌ 不存在 | ✅ 原生支持 |
| C_Timer | ❌ 不存在 | ✅ 原生支持 |
| C_Map | ❌ 不存在 | ✅ 原生支持 |
| C_Container | ❌ 不存在 | ✅ 原生支持 |
| C_Item | ❌ 不存在 | ✅ 原生支持 |
| SetColorTexture | ❌ 需要 polyfill | ✅ 原生支持 |
| CombatLogGetCurrentEventInfo | ❌ 不存在 | ❌ 仍不存在 |
| GetProfessions | ❌ 不存在 | ❌ 仍不存在 |

## 验证清单

在提交代码前，检查以下项目：

- [ ] 使用的 API 都在 `api手册/实践可用.md` 中有记录
- [ ] CombatLog 事件使用参数传递而非 `CombatLogGetCurrentEventInfo()`
- [ ] 专业技能使用 `GetNumSkillLines()` 而非 `GetProfessions()`
- [ ] 使用 `GetAddOnInfo()` / `GetAddOnMetadata()` 而非 `C_AddOns.*`
- [ ] 使用 `GetQuestLogTitle()` / `GetQuestInfo()` 而非 `C_QuestLog.*`
- [ ] UI 框架继承 `BackdropTemplate`（需要 backdrop 时）
- [ ] TOC Interface 设置为 `38001`

## 正确使用示例

**物品信息**:
```lua
-- 正确（3.80.1）
local itemName, itemLink, itemRarity = GetItemInfo(itemID)
-- 或
local itemInfo = C_Item.GetItemInfoInstant(itemID)
```

**光环查询**:
```lua
-- 正确（3.80.1 推荐）
AuraUtil.ForEachAura("player", "HELPFUL", nil, function(aura)
    print(aura.name, aura.spellId)
end)
```

**背包操作**:
```lua
-- 正确（3.80.1）
local numSlots = C_Container.GetContainerNumSlots(bagID)
local itemInfo = C_Container.GetContainerItemInfo(bagID, slotID)
```

**定时器**:
```lua
-- 正确（3.80.1）
C_Timer.After(5, function() print("5秒后执行") end)
local ticker = C_Timer.NewTicker(1, function() print("每秒执行") end)
ticker:Cancel()  -- 取消定时器
```

## 错误示例

**错误**:
```lua
-- C_AddOns 在 3.80.1 中不存在
C_AddOns.GetAddOnMetadata("MyAddon", "Version")
```

**正确**:
```lua
GetAddOnMetadata("MyAddon", "Version")
```

**错误**:
```lua
-- CombatLogGetCurrentEventInfo 在 3.80.1 中不存在
local _, subEvent = CombatLogGetCurrentEventInfo()
```

**正确**:
```lua
-- 使用事件参数
frame:SetScript("OnEvent", function(self, event, timestamp, subEvent, ...)
    -- 处理事件
end)
```

**错误**:
```lua
-- GetProfessions 在 3.80.1 中不存在
local prof1, prof2 = GetProfessions()
```

**正确**:
```lua
-- 使用 GetNumSkillLines + GetSkillLineInfo
for i = 1, GetNumSkillLines() do
    local name, _, _, rank = GetSkillLineInfo(i)
    -- 处理专业信息
end
```

---

