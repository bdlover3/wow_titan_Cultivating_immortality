-- ============================================================
-- SectWarFrame.lua - 宗门争锋面板
-- PVP战场快捷入口，修仙化战场信息展示
-- Titan Time Server 3.80.1 (Interface: 38001)
-- ============================================================
local UI = {}
UI.name = "SectWarFrame"
WoWCultivation.UI.SectWarFrame = UI

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationSectWarFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(480, 500)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 16, edgeSize = 20,
        insets = { left = 6, right = 6, top = 6, bottom = 6 }
    })
    f:SetBackdropColor(0.06, 0.03, 0.1, 0.97)
    f:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function() UI:Hide() end)

    self:CreateHeader(f)
    self:CreatePVPStats(f)
    self:CreateJoinButton(f)
    self:CreateBattlegroundList(f)

    f:Hide()
end

function UI:CreateHeader(parent)
    local header = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10)
    header:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -10, -10)
    header:SetHeight(36)
    header:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tileSize = 12, edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    header:SetBackdropColor(0.1, 0.05, 0.15, 0.9)
    header:SetBackdropBorderColor(0.7, 0.5, 0.1, 1)

    local title = header:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
    title:SetPoint("CENTER", header, "CENTER", 0, 0)
    title:SetText("|cFFFF4444◆ 宗门争锋 ◆|r")
end

function UI:CreatePVPStats(parent)
    self.statsText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.statsText:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -54)
    self.statsText:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, -54)
    self.statsText:SetJustifyH("LEFT")
    self.statsText:SetWordWrap(true)
end

function UI:CreateJoinButton(parent)
    -- 排队战场按钮
    local joinBtn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    joinBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -110)
    joinBtn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, -110)
    joinBtn:SetHeight(40)
    joinBtn:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tileSize = 12, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    joinBtn:SetBackdropColor(0.2, 0.05, 0.05, 0.9)
    joinBtn:SetBackdropBorderColor(0.7, 0.3, 0.3, 1)

    local jLabel = joinBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    jLabel:SetPoint("CENTER", joinBtn, "CENTER", 0, 0)
    jLabel:SetText("|cFFFF4444⚔ 加入宗门争锋 ⚔|r  |cFFEEDDAA随机匹配斗法战场|r")

    joinBtn:SetScript("OnClick", function()
        -- 打开 PVP 界面
        if ToggleBattlefieldMinimap then
            ToggleBattlefieldMinimap()
        end
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("正在寻找宗门争锋...", 2)
        end
    end)
    joinBtn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, 0.4, 0.4, 1)
    end)
    joinBtn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.7, 0.3, 0.3, 1)
    end)
end

function UI:CreateBattlegroundList(parent)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -162)
    label:SetText("|cFFEEDDAA宗门争锋战场一览：|r")

    local scrollFrame = CreateFrame("ScrollFrame", "WoWCultivationSectWarScroll", parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -180)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -30, 14)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(440, 1)
    scrollFrame:SetScrollChild(content)

    local battlefields = {
        {
            name = "灵脉峡谷",
            orig = "战歌峡谷",
            level = "10+",
            type = "夺旗斗法",
            desc = "两宗争夺灵脉之地的峡谷",
            color = "|cFF1eff00",
            icon = "Interface\\Icons\\INV_BannerPVP_01",
        },
        {
            name = "灵石盆地",
            orig = "阿拉希盆地",
            level = "20+",
            type = "占点斗法",
            desc = "四宗争夺灵石矿脉的盆地",
            color = "|cFF0070dd",
            icon = "Interface\\Icons\\INV_BannerPVP_02",
        },
        {
            name = "万妖山谷",
            orig = "奥特兰克山谷",
            level = "51+",
            type = "大型斗法",
            desc = "两宗在妖兽横行的山谷中决战",
            color = "|cFFa335ee",
            icon = "Interface\\Icons\\INV_BannerPVP_03",
        },
        {
            name = "风暴秘境",
            orig = "风暴之眼",
            level = "61+",
            type = "混合斗法",
            desc = "浮空秘境中的灵脉争夺",
            color = "|cFFff8000",
            icon = "Interface\\Icons\\Ability_Druid_Typhoon",
        },
        {
            name = "远古海滩",
            orig = "古代海滩",
            level = "71+",
            type = "攻防斗法",
            desc = "远古遗迹中的灵宝争夺",
            color = "|cFFe6cc80",
            icon = "Interface\\Icons\\INV_Misc_Shell_04",
        },
    }

    local itemH = 60
    for i, bg in ipairs(battlefields) do
        local yOff = -(i - 1) * itemH
        self:CreateBattlefieldItem(content, bg, yOff, 440, i)
    end
    content:SetHeight(#battlefields * itemH + 10)
end

function UI:CreateBattlefieldItem(parent, bg, yOffset, width, index)
    local item = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    item:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset)
    item:SetSize(width, 54)
    local bgAlpha = (index % 2 == 0) and 0.04 or 0.07
    item:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    item:SetBackdropColor(bgAlpha, bgAlpha * 0.5, bgAlpha * 2, 0.9)
    item:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.5)

    -- 图标
    local icon = item:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("LEFT", item, "LEFT", 8, 0)
    icon:SetSize(32, 32)
    icon:SetTexture(bg.icon)

    -- 战场名
    local nameText = item:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 8, -2)
    nameText:SetText(bg.color .. bg.name .. "|r  |cFFAAAAAA(" .. bg.orig .. ")|r")

    -- 类型/等级
    local typeText = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    typeText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
    typeText:SetText("|cFFEEDDAA类型：|r" .. bg.type .. "  |cFFEEDDAA等级：|r" .. bg.level)

    -- 描述
    local descText = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    descText:SetPoint("TOPLEFT", typeText, "BOTTOMLEFT", 0, -1)
    descText:SetPoint("RIGHT", item, "RIGHT", -8, 0)
    descText:SetText("|cFF888888" .. bg.desc .. "|r")

    -- 悬停
    item:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(bg.color .. bg.name .. "|r")
        GameTooltip:AddLine(bg.orig, 1, 1, 1)
        GameTooltip:AddLine(bg.desc, 1, 1, 1)
        GameTooltip:AddLine("类型: " .. bg.type, 0.6, 1, 0.6)
        GameTooltip:AddLine("等级: " .. bg.level, 0.6, 1, 0.6)
        GameTooltip:Show()
    end)
    item:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.5)
        GameTooltip:Hide()
    end)

    return item
end

function UI:Refresh()
    if not self.frame then return end

    -- PVP 统计
    local todayHK = GetPVPLifetimeHK and GetPVPLifetimeHK() or 0
    local todayKills = GetPVPKills and GetPVPKills() or 0
    local honorPoints = GetHonorPoints and GetHonorPoints() or 0

    -- 斗法排名
    local pvpRank = UnitPVPRank and UnitPVPRank("player") or 0
    local rankName = "初入斗法"
    if pvpRank > 0 and pvpRank <= 12 then
        local rankData = WoWCultivation.Data.Battleground.pvpRanks[pvpRank]
        if rankData then
            rankName = rankData.name
        end
    end

    self.statsText:SetText(
        "|cFFEEDDAA斗法称号：|r|cFFFF4444" .. rankName .. "|r\n"
        .. "|cFFEEDDAA斗法荣誉：|r|cFFFFD700" .. BreakUpLargeNumbers(honorPoints) .. "|r"
        .. "  |cFFEEDDAA今日击杀：|r|cFFFF4444" .. todayKills .. "|r"
        .. "  |cFFEEDDAA总击杀：|r|cFFFF4444" .. BreakUpLargeNumbers(todayHK) .. "|r"
    )
end

function UI:Show()
    if not self.frame then return end
    self:Refresh()
    self.frame:SetAlpha(1)
    self.frame:Show()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
end

function UI:Toggle()
    if not self.frame then return end
    if self.frame:IsShown() and self.frame:GetAlpha() > 0.5 then
        self:Hide()
    else
        self:Show()
    end
end
