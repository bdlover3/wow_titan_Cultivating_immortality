-- ============================================================
-- DungeonFrame.lua - 小秘境历练面板
-- 显示副本入口、修仙化副本名称、排队按钮
-- Titan Time Server 3.80.1 (Interface: 38001)
-- ============================================================
local UI = {}
UI.name = "DungeonFrame"
WoWCultivation.UI.DungeonFrame = UI

-- 副本名称修仙化映射
UI.DUNGEON_MAP = {
    -- 经典旧世
    ["怒焰裂谷"]       = "炎魔秘境·初境",
    ["Ragefire Chasm"] = "炎魔秘境·初境",
    ["死亡矿井"]       = "亡魂秘境·初境",
    ["Deadmines"]     = "亡魂秘境·初境",
    ["哀嚎洞穴"]       = "蛇灵秘境·初境",
    ["Wailing Caverns"] = "蛇灵秘境·初境",
    ["影牙城堡"]       = "血族秘境·中境",
    ["Shadowfang Keep"] = "血族秘境·中境",
    ["血色修道院"]     = "血煞秘境·中境",
    ["Scarlet Monastery"] = "血煞秘境·中境",
    ["剃刀沼泽"]       = "荆棘秘境·中境",
    ["Razorfen Kraul"] = "荆棘秘境·中境",
    ["剃刀高地"]       = "荆棘秘境·高境",
    ["Razorfen Downs"] = "荆棘秘境·高境",
    ["玛拉顿"]         = "地灵秘境·中境",
    ["Maraudon"]      = "地灵秘境·中境",
    ["祖尔法拉克"]     = "沙灵秘境·中境",
    ["Zul'Farrak"]    = "沙灵秘境·中境",
    ["阿塔哈卡神庙"]   = "龙神遗迹·高境",
    ["Temple of Atal'Hakkar"] = "龙神遗迹·高境",
    ["黑石深渊"]       = "黑铁秘境·高境",
    ["Blackrock Depths"] = "黑铁秘境·高境",
    ["黑石塔下层"]     = "黑龙秘境·巅峰",
    ["Lower Blackrock Spire"] = "黑龙秘境·巅峰",
    ["黑石塔上层"]     = "黑龙秘境·绝境",
    ["Upper Blackrock Spire"] = "黑龙秘境·绝境",
    ["厄运之槌"]       = "厄运秘境·巅峰",
    ["Dire Maul"]     = "厄运秘境·巅峰",
    ["斯坦索姆"]       = "亡灵天灾·绝境",
    ["Stratholme"]    = "亡灵天灾·绝境",
    ["通灵学院"]       = "通灵秘境·绝境",
    ["Scholomance"]   = "通灵秘境·绝境",
    -- 燃烧的远征
    ["地狱火城墙"]     = "地狱火要塞·初境",
    ["Hellfire Ramparts"] = "地狱火要塞·初境",
    ["鲜血熔炉"]       = "地狱火要塞·中境",
    ["The Blood Furnace"] = "地狱火要塞·中境",
    ["破碎大厅"]       = "地狱火要塞·高境",
    ["The Shattered Halls"] = "地狱火要塞·高境",
    ["奴隶围栏"]       = "盘牙秘境·初境",
    ["The Slave Pens"] = "盘牙秘境·初境",
    ["幽暗沼泽"]       = "盘牙秘境·中境",
    ["The Underbog"]  = "盘牙秘境·中境",
    ["蒸汽地窟"]       = "盘牙秘境·高境",
    ["The Steamvault"] = "盘牙秘境·高境",
    ["法力陵墓"]       = "奥金顿·初境",
    ["Mana-Tombs"]    = "奥金顿·初境",
    ["奥金尼地穴"]     = "奥金顿·中境",
    ["Auchenai Crypts"] = "奥金顿·中境",
    ["塞泰克大厅"]     = "奥金顿·高境",
    ["Sethekk Halls"] = "奥金顿·高境",
    ["暗影迷宫"]       = "奥金顿·绝境",
    ["Shadow Labyrinth"] = "奥金顿·绝境",
    ["禁魔监狱"]       = "风暴要塞·绝境",
    ["The Arcatraz"]  = "风暴要塞·绝境",
    ["魔导师平台"]     = "魔导师秘境·巅峰",
    ["Magisters' Terrace"] = "魔导师秘境·巅峰",
    -- 巫妖王之怒
    ["乌特加德城堡"]   = "维库秘境·初境",
    ["Utgarde Keep"]  = "维库秘境·初境",
    ["乌特加德之巅"]   = "维库秘境·高境",
    ["Utgarde Pinnacle"] = "维库秘境·高境",
    ["魔枢"]           = "蓝龙秘境·中境",
    ["The Nexus"]     = "蓝龙秘境·中境",
    ["魔环"]           = "蓝龙秘境·高境",
    ["The Oculus"]    = "蓝龙秘境·高境",
    ["艾卓-尼鲁布"]    = "蛛魔秘境·中境",
    ["Azjol-Nerub"]   = "蛛魔秘境·中境",
    ["安卡赫特：古代王国"] = "蛛魔秘境·高境",
    ["Ahn'kahet: The Old Kingdom"] = "蛛魔秘境·高境",
    ["达克萨隆要塞"]   = "冰霜秘境·中境",
    ["Drak'Tharon Keep"] = "冰霜秘境·中境",
    ["紫罗兰监狱"]     = "魔禁秘境·中境",
    ["The Violet Hold"] = "魔禁秘境·中境",
    ["古达克"]         = "巨魔秘境·高境",
    ["Gundrak"]       = "巨魔秘境·高境",
    ["岩石大厅"]       = "土灵秘境·高境",
    ["Halls of Stone"] = "土灵秘境·高境",
    ["闪电大厅"]       = "雷灵秘境·高境",
    ["Halls of Lightning"] = "雷灵秘境·高境",
    ["净化斯坦索姆"]   = "时光秘境·巅峰",
    ["The Culling of Stratholme"] = "时光秘境·巅峰",
    ["冠军的试炼"]     = "冠军秘境·巅峰",
    ["Trial of the Champion"] = "冠军秘境·巅峰",
    ["萨隆矿坑"]       = "天灾秘境·绝境",
    ["Pit of Saron"]  = "天灾秘境·绝境",
    ["灵魂洪炉"]       = "天灾秘境·巅峰",
    ["The Forge of Souls"] = "天灾秘境·巅峰",
    ["映像大厅"]       = "巫妖王秘境·绝境",
    ["Halls of Reflection"] = "巫妖王秘境·绝境",
}

-- 随机副本名称映射
UI.LFD_TYPE_MAP = {
    random = { name = "随机小秘境", desc = "随机匹配一个小秘境，奖励丰厚" },
    specific = { name = "指定小秘境", desc = "选择特定小秘境进入" },
}

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationDungeonFrame", UIParent, "BackdropTemplate")
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
    self:CreateInfo(f)
    self:CreateLFDButtons(f)
    self:CreateDungeonList(f)

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
    title:SetText("|cFF4488FF◆ 小秘境历练 ◆|r")
end

function UI:CreateInfo(parent)
    self.infoText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.infoText:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -54)
    self.infoText:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, -54)
    self.infoText:SetJustifyH("LEFT")
    self.infoText:SetWordWrap(true)
    self.infoText:SetText("|cFFEEDDAA当前秘境：|r" .. (GetRealZoneText() or "未知"))
end

function UI:CreateLFDButtons(parent)
    -- 随机副本按钮
    local randomBtn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    randomBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -82)
    randomBtn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, -82)
    randomBtn:SetHeight(40)
    randomBtn:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tileSize = 12, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    randomBtn:SetBackdropColor(0.05, 0.08, 0.2, 0.9)
    randomBtn:SetBackdropBorderColor(0.3, 0.5, 0.8, 1)

    local rLabel = randomBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rLabel:SetPoint("CENTER", randomBtn, "CENTER", 0, 0)
    rLabel:SetText("|cFF4488FF◆ 随机小秘境 ◆|r  |cFFEEDDAA匹配随机秘境，获取额外机缘|r")

    randomBtn:SetScript("OnClick", function()
        if LFGDungeonList_JoinButton and LFGDungeonList_JoinButton:IsEnabled() then
            LFGDungeonList_JoinButton:Click()
            if WoWCultivation.UI.Toast then
                WoWCultivation.UI.Toast:Show("正在匹配小秘境...", 2)
            end
        else
            if WoWCultivation.UI.Toast then
                WoWCultivation.UI.Toast:Show("暂时无法匹配小秘境", 3)
            end
        end
    end)
    randomBtn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.5, 0.7, 1, 1)
    end)
    randomBtn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.3, 0.5, 0.8, 1)
    end)

    -- 打开副本查找器按钮
    local lfdBtn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    lfdBtn:SetPoint("TOP", randomBtn, "BOTTOM", 0, -6)
    lfdBtn:SetPoint("LEFT", parent, "LEFT", 16, 0)
    lfdBtn:SetPoint("RIGHT", parent, "RIGHT", -16, 0)
    lfdBtn:SetHeight(32)
    lfdBtn:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tileSize = 12, edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    lfdBtn:SetBackdropColor(0.08, 0.04, 0.12, 0.9)
    lfdBtn:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)

    local lfdLabel = lfdBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lfdLabel:SetPoint("CENTER", lfdBtn, "CENTER", 0, 0)
    lfdLabel:SetText("|cFFEEDDAA打开秘境入口（副本查找器）|r")

    lfdBtn:SetScript("OnClick", function()
        if ToggleLFDParent then
            ToggleLFDParent()
        end
    end)
    lfdBtn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
    end)
    lfdBtn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.6)
    end)
end

function UI:CreateDungeonList(parent)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -168)
    label:SetText("|cFFEEDDAA秘境一览：|r")

    local scrollFrame = CreateFrame("ScrollFrame", "WoWCultivationDungeonScroll", parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -186)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -30, 14)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(440, 1)
    scrollFrame:SetScrollChild(content)

    -- 展示一些代表性秘境
    local dungeons = {
        { orig = "怒焰裂谷", level = 15, type = "初境", color = "|cFF1eff00" },
        { orig = "死亡矿井", level = 15, type = "初境", color = "|cFF1eff00" },
        { orig = "血色修道院", level = 30, type = "中境", color = "|cFF0070dd" },
        { orig = "玛拉顿", level = 40, type = "中境", color = "|cFF0070dd" },
        { orig = "黑石深渊", level = 52, type = "高境", color = "|cFFa335ee" },
        { orig = "斯坦索姆", level = 56, type = "绝境", color = "|cFFff8000" },
        { orig = "地狱火城墙", level = 60, type = "初境", color = "|cFF1eff00" },
        { orig = "奴隶围栏", level = 62, type = "初境", color = "|cFF1eff00" },
        { orig = "法力陵墓", level = 64, type = "初境", color = "|cFF1eff00" },
        { orig = "魔导师平台", level = 70, type = "巅峰", color = "|cFFe6cc80" },
        { orig = "乌特加德城堡", level = 70, type = "初境", color = "|cFF1eff00" },
        { orig = "魔枢", level = 71, type = "中境", color = "|cFF0070dd" },
        { orig = "达克萨隆要塞", level = 74, type = "中境", color = "|cFF0070dd" },
        { orig = "古达克", level = 76, type = "高境", color = "|cFFa335ee" },
        { orig = "闪电大厅", level = 78, type = "高境", color = "|cFFa335ee" },
        { orig = "冠军的试炼", level = 80, type = "巅峰", color = "|cFFe6cc80" },
        { orig = "映像大厅", level = 80, type = "绝境", color = "|cFFff8000" },
    }

    local itemH = 22
    local playerLevel = UnitLevel("player")

    for i, d in ipairs(dungeons) do
        local yOff = -(i - 1) * itemH
        local item = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        item:SetPoint("TOPLEFT", content, "TOPLEFT", 4, yOff)
        item:SetPoint("TOPRIGHT", content, "TOPRIGHT", -4, yOff)
        item:SetJustifyH("LEFT")

        local xiuxianName = UI.DUNGEON_MAP[d.orig] or d.orig
        local levelColor = d.level <= playerLevel and "|cFF00FF00" or "|cFFFF4444"
        local levelText = levelColor .. "Lv" .. d.level .. "|r"

        item:SetText(d.color .. xiuxianName .. "|r  " .. levelText .. "  |cFFAAAAAA" .. d.orig .. "|r")
    end

    content:SetHeight(#dungeons * itemH + 10)
end

function UI:Refresh()
    if not self.frame then return end
    local zoneName = GetRealZoneText() or "未知"
    local xiuxianZone = UI.DUNGEON_MAP[zoneName] or zoneName
    self.infoText:SetText(
        "|cFFEEDDAA当前区域：|r" .. xiuxianZone .. "\n"
        .. "|cFFEEDDAA角色等级：|r" .. (UnitLevel("player") or 0) .. "级"
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
