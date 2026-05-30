# 魔兽修仙传项目记忆

## 项目信息
- WoW Addon: 魔兽修仙传 (WoWCultivation)
- 目标: 泰坦时光服 3.80.1 (WotLK-based)
- 语言: Lua + WoW XML/TOC
- 目录: WoWCultivation/ (主插件), api手册/ (暴雪官方API参考)

## 关键技术发现

### WotLK 3.80.1 右键菜单系统
- **不用** `UnitPopup_ShowMenu` (Retail API)
- **不用** `UIDropDownMenu_AddButton` (旧API，3.80.1的UnitPopup不走这个)
- **正确方式**: `Menu.ModifyMenu(tag, callback)` — 暴雪官方API
  - tag: `"MENU_UNIT_SELF"`, `"MENU_UNIT_PARTY"`, `"MENU_UNIT_PLAYER"`, `"MENU_UNIT_RAID_PLAYER"`, `"MENU_UNIT_ENEMY_PLAYER"`, `"MENU_UNIT_TARGET"` 等
  - callback(ownerRegion, description, contextData) 中用 `description:CreateButton(text, onClick)` 追加按钮
  - contextData.unit 包含目标单位（"target", "party1" 等）
- 菜单调用链: `UnitPopup_OpenMenu(which, contextData)` → `UnitPopupManager:OpenMenu()` → `MenuUtil.CreateContextMenu()` → `rootDescription:SetTag("MENU_UNIT_"..which)` → generator callback
- 队友头像: `SecureUnitButton_OnLoad(frame, unitToken, OpenContextMenu)` → `UnitPopup_OpenMenu("PARTY", {unit=unit})`
- 目标头像: `TargetFrame_OpenMenu()` → `UnitPopup_OpenMenu(which, {unit="target"})`

### WoW Button 点击机制
- `SetNormalTexture(nil)` 的 Button **无法接收点击**，必须设置一个实际存在的纹理
- 正确做法: `CreateTexture()` + `SetTexture(1,1,1,0)` (透明但存在的纹理)
- HighlightTexture 也需要设置，否则悬停时会出白块
- `RegisterForDrag("LeftButton")` 会吞掉同框架的左键点击事件，拖拽和点击必须分离到不同框架

### WoW Frame 层级
- 子框架默认按创建顺序递增 frameLevel
- glowFrame、particle 等装饰层需要确保在 clickButton 之下
- 用 `SetFrameLevel(100)` 强制置顶交互层
