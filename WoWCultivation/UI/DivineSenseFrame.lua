-- ============================================================
-- DivineSenseFrame.lua - 神识探查窗口
-- 目标版本: 3.80.1 — BackdropTemplate + AnimationGroup
-- ============================================================
local UI = {}
UI.name = "DivineSenseFrame"
WoWCultivation.UI.DivineSenseFrame = UI

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationDivineSense", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(340, 420)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 18,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    f:SetBackdropColor(0.06, 0.03, 0.1, 0.96)
    f:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    f:SetClampedToScreen(true)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    local headerBg = CreateFrame("Frame", nil, f, "BackdropTemplate")
    headerBg:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -8)
    headerBg:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -8)
    headerBg:SetHeight(36)
    headerBg:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tileSize = 12,
        edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    headerBg:SetBackdropColor(0.1, 0.05, 0.15, 0.9)
    headerBg:SetBackdropBorderColor(0.7, 0.5, 0.1, 1)

    local title = f:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
    title:SetPoint("TOP", headerBg, "TOP", 0, -6)
    title:SetText("|cFFFFD700神识探查|r")

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function()
        UI:Hide()
    end)

    -- 查询输入区
    local searchLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    searchLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -52)
    searchLabel:SetText("|cFFEEDDAA探查道友:|r")

    local inputBg = CreateFrame("Frame", nil, f, "BackdropTemplate")
    inputBg:SetSize(180, 26)
    inputBg:SetPoint("LEFT", searchLabel, "RIGHT", 6, 0)
    inputBg:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    inputBg:SetBackdropColor(0.04, 0.02, 0.08, 0.9)
    inputBg:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)

    self.searchInput = CreateFrame("EditBox", nil, inputBg)
    self.searchInput:SetSize(158, 20)
    self.searchInput:SetPoint("CENTER", inputBg, "CENTER", 0, 0)
    self.searchInput:SetFontObject("GameFontHighlightSmall")
    self.searchInput:SetTextColor(1, 0.9, 0.7)
    self.searchInput:SetAutoFocus(false)
    self.searchInput:SetText("")
    self.searchInput:SetScript("OnEnterPressed", function(self)
        UI:SearchPlayer()
    end)

    local searchBtn = CreateFrame("Button", nil, f, "BackdropTemplate")
    searchBtn:SetSize(48, 24)
    searchBtn:SetPoint("LEFT", inputBg, "RIGHT", 6, 0)
    searchBtn:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    searchBtn:SetBackdropColor(0.1, 0.05, 0.18, 0.9)
    searchBtn:SetBackdropBorderColor(0.85, 0.65, 0.13, 0.8)

    local searchBtnLabel = searchBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    searchBtnLabel:SetPoint("CENTER", searchBtn, "CENTER", 0, 0)
    searchBtnLabel:SetText("|cFFFFD700探查|r")
    searchBtn:SetScript("OnClick", function()
        UI:SearchPlayer()
    end)
    searchBtn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, 0.85, 0.3, 1)
    end)
    searchBtn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.85, 0.65, 0.13, 0.8)
    end)

    -- 信息行区域
    self.infoRows = {}
    local rowLabels = { "道友名", "境界", "门派", "灵根", "道行", "等级", "种族", "职业" }
    local rowIcons = { "|cFFFFD700*|r", "|cFFAA44FF*|r", "|cFF4488FF*|r", "|cFF44AAFF*|r", "|cFFFF8800*|r", "|cFF1EFF00*|r", "|cFF0070DD*|r", "|cFFA335EE*|r" }

    for i, label in ipairs(rowLabels) do
        local yOffset = -(84 + (i - 1) * 34)

        local rowBg = CreateFrame("Frame", nil, f, "BackdropTemplate")
        rowBg:SetPoint("TOPLEFT", f, "TOPLEFT", 14, yOffset)
        rowBg:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, yOffset)
        rowBg:SetHeight(28)
        rowBg:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8,
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        rowBg:SetBackdropColor(0.05, 0.02, 0.08, 0.85)
        rowBg:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.9)

        local iconText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        iconText:SetPoint("LEFT", rowBg, "LEFT", 8, 0)
        iconText:SetText(rowIcons[i])

        local labelText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        labelText:SetPoint("LEFT", iconText, "RIGHT", 4, 0)
        labelText:SetText("|cFFEEDDAA" .. label .. "|r")

        local valueText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        valueText:SetPoint("RIGHT", rowBg, "RIGHT", -8, 0)
        valueText:SetText("|cFFFFFFFF--|r")
        valueText:SetJustifyH("RIGHT")

        tinsert(self.infoRows, {
            label = labelText,
            value = valueText,
        })
    end

    local footerDeco = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    footerDeco:SetPoint("BOTTOM", f, "BOTTOM", 0, 8)
    footerDeco:SetText("|cFF666666-- 神识流转 · 洞悉天机 --|r")

    f:Hide()
end

function UI:SearchPlayer()
    local name = self.searchInput and self.searchInput:GetText()
    if not name or name == "" then
        WoWCultivation:Print("|cFFFF0000请输入要探查的道友名|r")
        return
    end

    -- 尝试使用 /who 查询
    if SetWhoToUI then
        SetWhoToUI(1)
    end

    local queryName = name
    pcall(function()
        if SendWho then
            SendWho('n-"' .. queryName .. '"')
        end
    end)

    -- 尝试从目标获取信息
    local targetName = UnitName("target")
    if targetName and targetName == name then
        self:ShowTargetInfo("target")
    else
        -- 无法直接查询，显示提示
        WoWCultivation:Print("|cFF44AAFF正在探查道友: " .. name .. "...|r")
        -- 延迟尝试读取 who 结果
        C_Timer.After(1, function()
            self:TryReadWhoResults(name)
        end)
    end
end

function UI:ShowTargetInfo(unit)
    if not UnitExists(unit) then return end

    local name = UnitName(unit) or "未知"
    local level = UnitLevel(unit) or "?"
    local _, raceName = UnitRace(unit)
    local _, className, classFile = UnitClass(unit)
    local guildName = GetGuildInfo(unit) or "散修"
    local health = UnitHealth(unit) or 0
    local maxHealth = UnitHealthMax(unit) or 1

    -- 境界
    local realmName = "凡人"
    local RealmModule = WoWCultivation.Modules and WoWCultivation.Modules.RealmModule
    if RealmModule and RealmModule.GetData then
        local realmInfo = RealmModule:GetData(level)
        if realmInfo then
            realmName = realmInfo.bigRealm .. " · " .. realmInfo.name
        end
    end

    -- 灵根
    local spiritRoot = "未知灵根"
    local SectModule = WoWCultivation.Modules and WoWCultivation.Modules.SectModule
    if SectModule and SectModule.GetData then
        local sectInfo = SectModule:GetData(classFile)
        if sectInfo then
            spiritRoot = sectInfo.spiritRoot
        end
    end

    self.infoRows[1].value:SetText("|cFFFFD700" .. name .. "|r")
    self.infoRows[2].value:SetText("|cFFAA44FF" .. realmName .. "|r")
    self.infoRows[3].value:SetText("|cFF4488FF" .. guildName .. "|r")
    self.infoRows[4].value:SetText("|cFF44AAFF" .. spiritRoot .. "|r")
    self.infoRows[5].value:SetText("|cFFFF8800" .. tostring(level) .. "级|r")
    self.infoRows[6].value:SetText("|cFF1EFF00" .. tostring(level) .. "|r")
    self.infoRows[7].value:SetText("|cFF0070DD" .. (raceName or "未知") .. "|r")
    self.infoRows[8].value:SetText("|cFFA335EE" .. (className or "未知") .. "|r")

    self.frame:SetAlpha(1)
    self.frame:Show()
end

function UI:TryReadWhoResults(name)
    local numResults = 0
    pcall(function()
        numResults = GetNumWhoResults and GetNumWhoResults() or 0
    end)

    if numResults > 0 then
        for i = 1, numResults do
            local whoName, whoGuild, whoLevel, whoRace, whoClass, whoZone
            pcall(function()
                whoName, whoGuild, whoLevel, whoRace, whoClass, whoZone = GetWhoInfo(i)
            end)
            if whoName and whoName:lower() == name:lower() then
                -- 境界
                local realmName = "凡人"
                local RealmModule = WoWCultivation.Modules and WoWCultivation.Modules.RealmModule
                if RealmModule and RealmModule.GetData then
                    local realmInfo = RealmModule:GetData(whoLevel)
                    if realmInfo then
                        realmName = realmInfo.bigRealm .. " · " .. realmInfo.name
                    end
                end

                -- 灵根
                local spiritRoot = "未知灵根"
                local SectModule = WoWCultivation.Modules and WoWCultivation.Modules.SectModule
                if SectModule and SectModule.GetData then
                    local sectInfo = SectModule:GetData(whoClass)
                    if sectInfo then
                        spiritRoot = sectInfo.spiritRoot
                    end
                end

                self.infoRows[1].value:SetText("|cFFFFD700" .. whoName .. "|r")
                self.infoRows[2].value:SetText("|cFFAA44FF" .. realmName .. "|r")
                self.infoRows[3].value:SetText("|cFF4488FF" .. (whoGuild and whoGuild ~= "" and whoGuild or "散修") .. "|r")
                self.infoRows[4].value:SetText("|cFF44AAFF" .. spiritRoot .. "|r")
                self.infoRows[5].value:SetText("|cFFFF8800" .. (whoZone or "未知区域") .. "|r")
                self.infoRows[6].value:SetText("|cFF1EFF00" .. tostring(whoLevel) .. "|r")
                self.infoRows[7].value:SetText("|cFF0070DD" .. (whoRace or "未知") .. "|r")
                self.infoRows[8].value:SetText("|cFFA335EE" .. (whoClass or "未知") .. "|r")
                return
            end
        end
    end

    WoWCultivation:Print("|cFFFF0000未找到道友: " .. name .. "|r")
end

function UI:Show(data)
    if not self.frame then return end
    
    data = data or {}
    self.infoRows[1].value:SetText("|cFFFFD700" .. (data.name or "未知") .. "|r")
    self.infoRows[2].value:SetText("|cFFAA44FF" .. (data.realm or "凡人") .. "|r")
    self.infoRows[3].value:SetText("|cFF4488FF" .. (data.sect or "散修") .. "|r")
    self.infoRows[4].value:SetText("|cFF44AAFF" .. (data.spiritRoot or "未知灵根") .. "|r")
    self.infoRows[5].value:SetText("|cFFFF8800" .. BreakUpLargeNumbers(data.daoPoints or 0) .. "|r")
    self.infoRows[6].value:SetText("|cFF1EFF00" .. tostring(UnitLevel("player") or 0) .. "|r")
    self.infoRows[7].value:SetText("|cFF0070DD" .. (UnitRace("player") or "未知") .. "|r")
    local _, className = UnitClass("player")
    self.infoRows[8].value:SetText("|cFFA335EE" .. (className or "未知") .. "|r")
    
    self.frame:SetAlpha(1)
    self.frame:Show()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
end

function UI:IsShown()
    return self.frame and self.frame:IsShown()
end
