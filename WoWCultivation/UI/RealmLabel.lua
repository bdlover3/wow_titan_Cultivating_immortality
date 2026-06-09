local UI = {}
UI.name = "RealmLabel"
WoWCultivation.UI.RealmLabel = UI

UI.REALM_COLORS = {
    ["练气"] = "|cFF00FF00",
    ["筑基"] = "|cFF4488FF",
    ["结丹"] = "|cFFAA44FF",
    ["元婴"] = "|cFFFF8800",
}

UI.REALM_ORDER = { "练气", "筑基", "结丹", "元婴" }

function UI:OnEnable()
    -- 1. CompactUnitFrame hook（队伍框架等）
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
        UI:UpdateCompactFrame(frame)
    end)

    -- 2. 姓名版 - 使用 NAME_PLATE_UNIT_ADDED 事件 + 延迟处理
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    eventFrame:SetScript("OnEvent", function(_, event, unit)
        if event == "NAME_PLATE_UNIT_ADDED" then
            -- 等待姓名版帧创建完成（ndui/plater 可能需要一点时间）
            C_Timer.After(0.1, function()
                if UnitExists(unit) then
                    UI:AttachRealmToNameplate(unit)
                end
            end)
        elseif event == "NAME_PLATE_UNIT_REMOVED" then
            UI.processedPlates[unit] = nil
        end
    end)

    self.processedPlates = {}

    -- 3. 回退扫描器：捕获事件未覆盖的姓名版（每1秒扫描）
    self.scanTimer = 0
    self.scanner = CreateFrame("Frame")
    self.scanner:SetScript("OnUpdate", function(_, elapsed)
        UI.scanTimer = UI.scanTimer + elapsed
        if UI.scanTimer < 1.0 then return end
        UI.scanTimer = 0
        UI:ScanAllNameplates()
    end)

    -- 初始扫描
    C_Timer.After(2, function() UI:ScanAllNameplates() end)
end

function UI:GetRealmForPlayer(unit)
    if not unit then return nil end
    local level = UnitLevel(unit)
    if not level or level <= 0 then return nil end
    local RealmModule = WoWCultivation.Modules.RealmModule
    if RealmModule and RealmModule.GetBigRealm then
        return RealmModule:GetBigRealm(level)
    end
    return nil
end

function UI:GetRealmColor(realmName)
    if not realmName then return "|cFFFFFFFF" end
    for pattern, color in pairs(self.REALM_COLORS) do
        if string.find(realmName, pattern) then
            return color
        end
    end
    return "|cFFFFFFFF"
end

-- ============================================================
-- 递归查找 Frame 及其子帧中某个属性的值
-- ============================================================
local function FindFieldDeep(frame, field, maxDepth)
    if not frame then return nil end
    maxDepth = maxDepth or 3
    if maxDepth <= 0 then return nil end

    -- 直接检查
    if frame[field] ~= nil then
        return frame[field]
    end

    -- 递归检查子帧
    local children = {frame:GetChildren()}
    for _, child in ipairs(children) do
        local val = FindFieldDeep(child, field, maxDepth - 1)
        if val ~= nil then return val end
    end
    return nil
end

-- ============================================================
-- 递归查找 Frame 及其子帧中可调用的 FontString（有 GetText）
-- ============================================================
local function FindNameTextDeep(frame, maxDepth)
    if not frame then return nil end
    maxDepth = maxDepth or 3
    if maxDepth <= 0 then return nil end

    -- 检查自己
    if frame.GetText and type(frame.GetText) == "function" then
        local txt = frame:GetText()
        if txt and txt ~= "" and not string.find(txt, "^|c%x%x%x%x%x%x%x%x%[") then
            -- 忽略已经带境界标签的
            return frame
        end
    end

    -- 检查子帧
    local children = {frame:GetChildren()}
    for _, child in ipairs(children) do
        local found = FindNameTextDeep(child, maxDepth - 1)
        if found then return found end
    end
    return nil
end

-- ============================================================
-- 找到指定 unit 的姓名版帧
-- ============================================================
function UI:FindNameplateFrame(unit)
    -- 方法1: 遍历 WorldFrame 子帧
    local children = {WorldFrame:GetChildren()}
    for _, child in ipairs(children) do
        if child:IsShown() then
            -- 检查 unit 字段（直接或深层查找）
            local plateUnit = FindFieldDeep(child, "unit", 4)
            if plateUnit == unit then
                return child
            end

            -- 备用：检查 displayedUnit
            local displayedUnit = FindFieldDeep(child, "displayedUnit", 4)
            if displayedUnit == unit then
                return child
            end

            -- 备用：检查 namePlateUnitToken
            local token = FindFieldDeep(child, "namePlateUnitToken", 4)
            if token == unit then
                return child
            end
        end
    end

    -- 方法2: 传统 NamePlate1-40
    for i = 1, 40 do
        local np = _G["NamePlate" .. i]
        if np and np:IsShown() then
            local plateUnit = FindFieldDeep(np, "unit", 3)
            if plateUnit == unit then
                return np
            end
        end
    end

    return nil
end

-- ============================================================
-- 在姓名版上附加境界标签
-- ============================================================
function UI:AttachRealmToNameplate(unit)
    if self.processedPlates[unit] then return end
    if not UnitIsPlayer(unit) then return end

    local realmName = self:GetRealmForPlayer(unit)
    if not realmName then return end

    local plate = self:FindNameplateFrame(unit)
    if not plate then
        -- 还没创建好，稍后再试一次
        C_Timer.After(0.3, function()
            if UnitExists(unit) and not self.processedPlates[unit] then
                self:AttachRealmToNameplate(unit)
            end
        end)
        return
    end

    local color = self:GetRealmColor(realmName)

    -- 尝试找到姓名文字区域（递归3层）
    local nameText = FindNameTextDeep(plate, 4)
    if nameText and nameText.SetText then
        local originalName = nameText:GetText() or ""
        if originalName == "" or string.find(originalName, "%[") then
            -- 已经有标签了，跳过
            self.processedPlates[unit] = true
            return
        end
        nameText:SetText(color .. "[" .. realmName .. "]|r " .. originalName)
        self.processedPlates[unit] = true
        return
    end

    -- 实在找不到名字文本 → 在姓名版上方创建浮动标签
    if not plate._wcRealmTag then
        local tag = plate:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        tag:SetPoint("BOTTOM", plate, "TOP", 0, 2)
        tag:SetText(color .. "[" .. realmName .. "]|r")
        tag:SetShadowColor(0, 0, 0, 0.8)
        tag:SetShadowOffset(1, -1)
        plate._wcRealmTag = tag
    else
        plate._wcRealmTag:SetText(color .. "[" .. realmName .. "]|r")
        plate._wcRealmTag:Show()
    end
    self.processedPlates[unit] = true
end

-- ============================================================
-- 扫描所有可见姓名版
-- ============================================================
function UI:ScanAllNameplates()
    local children = {WorldFrame:GetChildren()}
    for _, child in ipairs(children) do
        if child:IsShown() then
            local unit = FindFieldDeep(child, "unit", 4)
            if unit and UnitExists(unit) and UnitIsPlayer(unit) and not self.processedPlates[unit] then
                self:AttachRealmToNameplate(unit)
            end
        end
    end

    -- 也检查 NamePlate1-40
    for i = 1, 40 do
        local np = _G["NamePlate" .. i]
        if np and np:IsShown() then
            local unit = FindFieldDeep(np, "unit", 3)
            if unit and UnitExists(unit) and UnitIsPlayer(unit) and not self.processedPlates[unit] then
                self:AttachRealmToNameplate(unit)
            end
        end
    end

    -- 清理已消失的姓名版标签
    for unit, _ in pairs(self.processedPlates) do
        if not UnitExists(unit) then
            self.processedPlates[unit] = nil
        end
    end
end

-- ============================================================
-- CompactUnitFrame 处理（队伍框架等）
-- ============================================================
function UI:UpdateCompactFrame(frame)
    if not frame then return end
    if not frame.name then return end

    local unit = frame.unit
    if not unit then return end

    if UnitIsPlayer(unit) then
        local realmName = self:GetRealmForPlayer(unit)
        if not realmName then return end

        local color = self:GetRealmColor(realmName)
        local originalName = frame.name:GetText()
        if not originalName then return end
        if string.find(originalName, "%[") then return end

        frame.name:SetText(color .. "[" .. realmName .. "]|r " .. originalName)
    elseif not UnitIsPlayer(unit) then
        local level = UnitLevel(unit)
        if not level or level <= 0 then return end

        local realmName = self:GetRealmForPlayer(unit)
        if not realmName then return end

        local color = self:GetRealmColor(realmName)
        local originalName = frame.name:GetText()
        if not originalName then return end
        if string.find(originalName, "%[") then return end

        frame.name:SetText(color .. "[" .. realmName .. "·妖]|r " .. originalName)
    end
end
