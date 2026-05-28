local UI = {}
UI.name = "MainFrame"
WoWCultivation.UI.MainFrame = UI

UI.FEATURE_BUTTONS = {
    { id = "alchemy",      name = "炼丹术",     icon = "136243", desc = "炼制丹药，提升修为" },
    { id = "crafting",     name = "炼器术",     icon = "136244", desc = "锻造灵宝，增强实力" },
    { id = "dungeon",      name = "小秘境历练", icon = "136245", desc = "探索秘境，获取机缘" },
    { id = "sectwar",      name = "宗门争锋",   icon = "136246", desc = "宗门大战，争夺资源" },
    { id = "achievement",  name = "道果录",     icon = "136247", desc = "修行成就，记录道途" },
    { id = "treasure",     name = "灵宝鉴",     icon = "136248", desc = "灵宝图鉴，一览无遗" },
    { id = "divinesense",  name = "神识探查",   icon = "136249", desc = "以神识探查道友信息" },
    { id = "meditation",   name = "闭关修炼",   icon = "136250", desc = "闭关打坐，参悟大道" },
}

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationMainFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(520, 580)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 20,
        insets = { left = 6, right = 6, top = 6, bottom = 6 }
    })
    f:SetBackdropColor(0.06, 0.03, 0.1, 0.97)
    f:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function()
        UI:Hide()
    end)

    self:CreateHeader(f)
    self:CreateInfoSections(f)
    self:CreateFeatureGrid(f)
    self:CreateDialogArea(f)

    f:Hide()
end

function UI:CreateHeader(parent)
    local header = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10)
    header:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -10, -10)
    header:SetHeight(40)
    header:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tileSize = 12,
        edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    header:SetBackdropColor(0.1, 0.05, 0.15, 0.9)
    header:SetBackdropBorderColor(0.7, 0.5, 0.1, 1)

    local title = header:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
    title:SetPoint("CENTER", header, "CENTER", 0, 0)
    title:SetText("|cFFFFD700修 仙 录|r")
    self.headerTitle = title
end

function UI:CreateInfoSections(parent)
    local sectionY = -60
    local sectionH = 70
    local sectionGap = 6

    local sections = {
        { key = "realm", title = "境界信息", icon = "|cFFAA44FF☯|r" },
        { key = "sect",  title = "门派信息", icon = "|cFF4488FF⚔|r" },
        { key = "root",  title = "灵根功法", icon = "|cFF44AAFF✿|r" },
    }

    self.infoSections = {}

    for i, sec in ipairs(sections) do
        local yOffset = sectionY - (i - 1) * (sectionH + sectionGap)

        local section = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        section:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
        section:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -14, yOffset)
        section:SetHeight(sectionH)
        section:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8,
            edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        section:SetBackdropColor(0.04, 0.02, 0.06, 0.9)
        section:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.9)

        local secTitle = section:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        secTitle:SetPoint("TOPLEFT", section, "TOPLEFT", 10, -8)
        secTitle:SetText(sec.icon .. " |cFFEEDDAA" .. sec.title .. "|r")

        local line = section:CreateTexture(nil, "ARTWORK")
        line:SetPoint("TOPLEFT", section, "TOPLEFT", 10, -22)
        line:SetPoint("TOPRIGHT", section, "TOPRIGHT", -10, -22)
        line:SetHeight(1)
        line:SetColorTexture(0.55, 0.4, 0.08, 0.5)

        local content = section:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        content:SetPoint("TOPLEFT", section, "TOPLEFT", 14, -28)
        content:SetPoint("TOPRIGHT", section, "TOPRIGHT", -14, -28)
        content:SetWordWrap(true)
        content:SetJustifyH("LEFT")
        content:SetText("|cFF888888暂无信息|r")

        self.infoSections[sec.key] = content
    end
end

function UI:CreateFeatureGrid(parent)
    local gridY = -298
    local gridLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    gridLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, gridY)
    gridLabel:SetText("|cFFFFD700◆ 功法入口 ◆|r")

    local gridStartY = gridY - 20
    local btnSize = 56
    local btnGap = 8
    local cols = 4
    local startX = 18

    self.featureButtons = {}

    for i, feat in ipairs(self.FEATURE_BUTTONS) do
        local row = math.ceil(i / cols) - 1
        local col = (i - 1) % cols
        local xOff = startX + col * (btnSize + btnGap)
        local yOff = gridStartY - row * (btnSize + btnGap)

        local btn = CreateFrame("Button", "WoWCultivationBtn_" .. feat.id, parent, "BackdropTemplate")
        btn:SetSize(btnSize, btnSize)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff)
        btn:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8,
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        btn:SetBackdropColor(0.06, 0.03, 0.1, 0.9)
        btn:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.8)

        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", btn, "TOPLEFT", 6, -4)
        icon:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -6, 14)
        icon:SetTexture(feat.icon)

        local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("BOTTOM", btn, "BOTTOM", 0, 3)
        label:SetText("|cFFEEDDAA" .. feat.name .. "|r")

        btn:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("|cFFFFD700" .. feat.name .. "|r")
            GameTooltip:AddLine("|cFFEEDDAA" .. feat.desc .. "|r", 1, 1, 1)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.8)
            GameTooltip:Hide()
        end)
        btn:SetScript("OnClick", function()
            UI:OnFeatureClick(feat.id)
        end)

        self.featureButtons[feat.id] = btn
    end
end

function UI:CreateDialogArea(parent)
    local dialog = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    dialog:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 14, 14)
    dialog:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -14, 14)
    dialog:SetHeight(80)
    dialog:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        tileSize = 12,
        edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    dialog:SetBackdropColor(0.08, 0.04, 0.12, 0.9)
    dialog:SetBackdropBorderColor(0.7, 0.5, 0.1, 1)

    local portraitIcon = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    portraitIcon:SetPoint("LEFT", dialog, "LEFT", 8, 0)
    portraitIcon:SetText("|cFFFFD700☯|r")

    local dialogText = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialogText:SetPoint("TOPLEFT", portraitIcon, "TOPRIGHT", 8, -4)
    dialogText:SetPoint("BOTTOMRIGHT", dialog, "BOTTOMRIGHT", -8, 4)
    dialogText:SetWordWrap(true)
    dialogText:SetJustifyH("LEFT")
    dialogText:SetJustifyV("TOP")
    dialogText:SetText("|cFFEEDDAA小师妹：师兄，欢迎回来~|r")
    self.dialogText = dialogText
end

function UI:OnFeatureClick(featureId)
    if featureId == "divinesense" then
        if WoWCultivation.UI.DivineSenseFrame then
            local data = self:GetCurrentPlayerData()
            WoWCultivation.UI.DivineSenseFrame:Show(data)
        end
    elseif featureId == "alchemy" then
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("炼丹炉尚未开启，请等待后续更新", 3)
        end
    elseif featureId == "crafting" then
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("炼器台尚未开启，请等待后续更新", 3)
        end
    elseif featureId == "dungeon" then
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("秘境入口尚未开启，请等待后续更新", 3)
        end
    elseif featureId == "sectwar" then
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("宗门战场尚未开启，请等待后续更新", 3)
        end
    elseif featureId == "achievement" then
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("道果录尚未开启，请等待后续更新", 3)
        end
    elseif featureId == "treasure" then
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("灵宝鉴尚未开启，请等待后续更新", 3)
        end
    elseif featureId == "meditation" then
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("闭关石室尚未开启，请等待后续更新", 3)
        end
    end
end

function UI:GetCurrentPlayerData()
    local data = {
        name = UnitName("player") or "未知",
        realm = "凡人",
        sect = "散修",
        spiritRoot = "未知灵根",
        daoPoints = 0,
    }

    local RealmModule = WoWCultivation.Modules and WoWCultivation.Modules.RealmModule
    if RealmModule and RealmModule.GetRealm then
        data.realm = RealmModule:GetRealm() or "凡人"
    end

    local SectModule = WoWCultivation.Modules and WoWCultivation.Modules.SectModule
    if SectModule and SectModule.GetSect then
        data.sect = SectModule:GetSect() or "散修"
    end

    if SectModule and SectModule.GetSpiritRoot then
        data.spiritRoot = SectModule:GetSpiritRoot() or "未知灵根"
    end

    local CurrencyModule = WoWCultivation.Modules and WoWCultivation.Modules.CurrencyModule
    if CurrencyModule and CurrencyModule.GetSpiritStones then
        data.daoPoints = CurrencyModule:GetSpiritStones() or 0
    else
        data.daoPoints = GetTotalAchievementPoints() or 0
    end

    return data
end

function UI:RefreshInfo()
    if not self.infoSections then return end

    local RealmModule = WoWCultivation.Modules and WoWCultivation.Modules.RealmModule
    local SectModule = WoWCultivation.Modules and WoWCultivation.Modules.SectModule
    local CurrencyModule = WoWCultivation.Modules and WoWCultivation.Modules.CurrencyModule

    local realmName = "凡人"
    local realmExp = 0
    local realmMaxExp = 100
    if RealmModule then
        realmName = RealmModule.GetRealm and RealmModule:GetRealm() or "凡人"
        realmExp = RealmModule.GetExp and RealmModule:GetExp() or 0
        realmMaxExp = RealmModule.GetMaxExp and RealmModule:GetMaxExp() or 100
    end
    local spiritStones = 0
    if CurrencyModule and CurrencyModule.GetSpiritStones then
        spiritStones = CurrencyModule:GetSpiritStones() or 0
    end
    self.infoSections.realm:SetText(
        "|cFFAA44FF境界：|r|cFFFFFFFF" .. realmName .. "|r\n" ..
        "|cFFAA44FF修为：|r|cFFFFFFFF" .. BreakUpLargeNumbers(realmExp) .. " / " .. BreakUpLargeNumbers(realmMaxExp) .. "|r  |cFF4488FF灵石：|r|cFFFFFFFF" .. BreakUpLargeNumbers(spiritStones) .. "|r"
    )

    local sectName = "散修"
    local sectRank = "无"
    if SectModule then
        sectName = SectModule.GetSect and SectModule:GetSect() or "散修"
        sectRank = SectModule.GetRank and SectModule:GetRank() or "无"
    end
    self.infoSections.sect:SetText(
        "|cFF4488FF门派：|r|cFFFFFFFF" .. sectName .. "|r\n" ..
        "|cFF4488FF门派职位：|r|cFFFFFFFF" .. sectRank .. "|r"
    )

    local spiritRoot = "未知灵根"
    local technique = "无"
    if SectModule then
        spiritRoot = SectModule.GetSpiritRoot and SectModule:GetSpiritRoot() or "未知灵根"
        technique = SectModule.GetTechnique and SectModule:GetTechnique() or "无"
    end
    self.infoSections.root:SetText(
        "|cFF44AAFF灵根：|r|cFFFFFFFF" .. spiritRoot .. "|r\n" ..
        "|cFF44AAFF功法：|r|cFFFFFFFF" .. technique .. "|r"
    )
end

function UI:Toggle()
    if not self.frame then return end
    if self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

function UI:Show()
    if not self.frame then return end
    self:RefreshInfo()
    self.frame:Show()

    local ag = self.frame:CreateAnimationGroup()
    local fadeIn = ag:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.2)
    ag:Play()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
end

function UI:IsShown()
    return self.frame and self.frame:IsShown()
end
