-- ============================================================
-- FishingFrame.lua - 灵钓宝鉴
-- 钓鱼指引面板 + 钓鱼统计
-- 目标版本: 泰坦时光服 3.80.1
-- ============================================================
local UI = {}
UI.name = "FishingFrame"
WoWCultivation.UI.FishingFrame = UI

UI.FRAME_WIDTH = 420
UI.FRAME_HEIGHT = 520

-- 钓鱼指引数据
UI.FISH_DATA = {
    { skill = 1,   name = "美味小鱼",       zone = "艾尔文森林/丹莫罗/杜隆塔尔" },
    { skill = 1,   name = "长嘴泥鳅",       zone = "各初级水域" },
    { skill = 50,  name = "刺须鲶鱼",       zone = "西部荒野/贫瘠之地/银松森林" },
    { skill = 75,  name = "小口鲤鱼",       zone = "湿地/希尔斯布莱德丘陵" },
    { skill = 100, name = "白鳞鲑鱼",       zone = "阿拉希高地/荆棘谷" },
    { skill = 130, name = "石鳞鳕鱼",       zone = "荆棘谷/悲伤沼泽" },
    { skill = 150, name = "大师级杂鱼",     zone = "塔纳利斯/菲拉斯" },
    { skill = 175, name = "红鳃鱼",         zone = "辛特兰/灼热峡谷" },
    { skill = 200, name = "阳鳞鲑鱼",       zone = "燃烧平原/东瘟疫之地" },
    { skill = 225, name = "夜鳞鲷鱼",       zone = "东瘟疫之地/冬泉谷" },
    { skill = 250, name = "电鳗",           zone = "东瘟疫之地(斯坦索姆旁)",   rarity = 2 },
    { skill = 275, name = "板鳞鱼",         zone = "东瘟疫/希利苏斯" },
    { skill = 300, name = "魔鲈鱼",         zone = "地狱火半岛/赞加沼泽" },
    { skill = 305, name = "刺鳃鲑鱼",       zone = "赞加沼泽/泰罗卡森林" },
    { skill = 325, name = "菲格鲁泥鱼",     zone = "纳格兰/泰罗卡森林" },
    { skill = 350, name = "狂暴龙虾",       zone = "泰罗卡森林(高地鱼群)",     rarity = 2 },
    { skill = 350, name = "黄牙河豚",       zone = "赞加沼泽" },
    { skill = 380, name = "冰鳍鱼",         zone = "北风苔原/嚎风峡湾" },
    { skill = 400, name = "深海鳗鱼",       zone = "龙骨荒野/灰熊丘陵" },
    { skill = 430, name = "月光墨鱼",       zone = "祖达克/索拉查盆地",       rarity = 2 },
    { skill = 450, name = "皇张大比目鱼",   zone = "冰冠冰川/风暴峭壁",       rarity = 2 },
    { skill = 450, name = "海地*帝王鱼",     zone = "冬拥湖",                   rarity = 3 },
}

function UI:OnEnable()
    self:CreateFrame()
    self:RegisterEvents()
end

function UI:CreateFrame()
    local f = CreateFrame("Frame", "WoWCultivationFishingFrame", UIParent, "BackdropTemplate")
    f:SetSize(UI.FRAME_WIDTH, UI.FRAME_HEIGHT)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    f:SetBackdropColor(0.05, 0.03, 0.1, 0.95)
    f:SetFrameStrata("DIALOG")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetClampedToScreen(true)
    f:Hide()
    self.frame = f

    local titleBar = CreateFrame("Frame", nil, f, "BackdropTemplate")
    titleBar:SetHeight(30)
    titleBar:SetPoint("TOPLEFT", f, "TOPLEFT", 4, -4)
    titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    titleBar:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    titleBar:SetBackdropColor(0.15, 0.08, 0.25, 0.9)

    local titleText = titleBar:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    titleText:SetPoint("CENTER", titleBar, "CENTER", 0, 0)
    titleText:SetText("|cFFFFD700◆ 灵钓宝鉴 ◆|r")

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)

    -- 技能等级
    self.skillText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.skillText:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -40)
    self.skillText:SetText("|cFF1EFF00钓鱼技能: 0|r")

    -- 总计统计
    self.totalText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.totalText:SetPoint("TOPLEFT", self.skillText, "TOPRIGHT", 40, 0)
    self.totalText:SetText("|cFF44AAFF累计钓鱼: 0 次|r")

    -- Tab buttons: 指引 / 统计
    local tabY = -62
    self.tabGuide = self:CreateTabButton(f, "钓鱼指引", "LEFT", 14, tabY)
    self.tabStats = self:CreateTabButton(f, "钓鱼统计", "LEFT", 120, tabY)
    self.currentTab = "guide"
    self.tabGuide:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)

    self.tabGuide:SetScript("OnClick", function()
        self.currentTab = "guide"
        self.tabGuide:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        self.tabStats:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)
        self:RefreshContent()
    end)
    self.tabStats:SetScript("OnClick", function()
        self.currentTab = "stats"
        self.tabStats:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        self.tabGuide:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)
        self:RefreshContent()
    end)

    -- ScrollFrame for content
    local scrollBg = CreateFrame("Frame", nil, f, "BackdropTemplate")
    scrollBg:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -90)
    scrollBg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 12)
    scrollBg:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    scrollBg:SetBackdropColor(0.04, 0.02, 0.08, 0.8)
    scrollBg:SetBackdropBorderColor(0.5, 0.35, 0.08, 0.5)

    local sf = CreateFrame("ScrollFrame", "WoWCultivationFishingScroll", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT", scrollBg, "TOPLEFT", 4, -4)
    sf:SetPoint("BOTTOMRIGHT", scrollBg, "BOTTOMRIGHT", -4, 4)
    self.scrollFrame = sf

    local content = CreateFrame("Frame", nil, sf)
    content:SetSize(370, 300)
    sf:SetScrollChild(content)
    self.contentFrame = content

    self.itemFrames = {}
end

function UI:CreateTabButton(parent, text, anchor, x, y)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(100, 24)
    btn:SetPoint("TOPLEFT", parent, anchor, x, y)
    btn:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    btn:SetBackdropColor(0.08, 0.04, 0.16, 0.9)
    btn:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)

    local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("CENTER", btn, "CENTER", 0, 0)
    label:SetText("|cFFEEDDAA" .. text .. "|r")

    btn:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1) end)
    btn:SetScript("OnLeave", function(self)
        if UI.currentTab ~= (text == "钓鱼指引" and "guide" or "stats") then
            self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)
        end
    end)
    return btn
end

function UI:RegisterEvents()
    local EM = WoWCultivation.Core.EventManager
    -- 检测钓鱼成功 - 聊天消息匹配
    EM:Register("CHAT_MSG_LOOT", function(msg)
        if not msg or type(msg) ~= "string" then return end
        -- 匹配自己钓到鱼的消息（中英文）
        local isMyCatch = msg:find("你钓到了") or msg:find("你收获了")
            or msg:find("You caught") or msg:find("You fished up")
        if not isMyCatch then return end

        -- 提取物品名称
        local fishName = msg:match("|c%x+|Hitem:.-|h%[(.-)%]|h|r")
        if not fishName then
            -- 尝试直接提取方括号内容
            fishName = msg:match("%[(.-)%]")
        end
        if fishName then
            self:OnFishCaught(fishName)
        end
    end)
end

function UI:OnFishCaught(fishName)
    if not fishName or fishName == "" then return end

    -- 清理名称（去掉方括号等）
    fishName = string.gsub(fishName, "[%[%]]", "")

    local db = WoWCultivationCharDB
    if not db then return end
    if not db.fishingStats then
        db.fishingStats = { totalCasts = 0, fishCaught = {} }
    end

    db.fishingStats.totalCasts = (db.fishingStats.totalCasts or 0) + 1
    db.fishingStats.fishCaught = db.fishingStats.fishCaught or {}
    db.fishingStats.fishCaught[fishName] = (db.fishingStats.fishCaught[fishName] or 0) + 1
end

function UI:RefreshContent()
    -- 隐藏所有旧条目
    for _, f in ipairs(self.itemFrames) do
        f:Hide()
    end

    -- 更新技能等级
    local skillLevel = 0
    for i = 1, GetNumSkillLines() do
        local skillName, isHeader, _, skillRank = GetSkillLineInfo(i)
        if not isHeader and skillName and (skillName == "钓鱼" or skillName == "Fishing") then
            skillLevel = skillRank or 0
            break
        end
    end
    self.skillText:SetText("|cFF1EFF00钓鱼技能: " .. skillLevel .. "|r")

    -- 更新总数
    local db = WoWCultivationCharDB
    local totalCasts = (db and db.fishingStats and db.fishingStats.totalCasts) or 0
    self.totalText:SetText("|cFF44AAFF累计钓鱼: " .. totalCasts .. " 次|r")

    if self.currentTab == "guide" then
        self:ShowGuide(skillLevel)
    else
        self:ShowStats()
    end
end

function UI:ShowGuide(skillLevel)
    local content = self.contentFrame
    local yOffset = -8

    for i, fish in ipairs(UI.FISH_DATA) do
        local itemFrame = self.itemFrames[i]
        if not itemFrame then
            itemFrame = CreateFrame("Frame", nil, content)
            itemFrame:SetSize(370, 20)

            local iconTex = itemFrame:CreateTexture(nil, "ARTWORK")
            iconTex:SetSize(16, 16)
            iconTex:SetPoint("LEFT", itemFrame, "LEFT", 2, 0)
            itemFrame.iconTex = iconTex

            local skillText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            skillText:SetPoint("LEFT", itemFrame, "LEFT", 22, 0)
            skillText:SetWidth(36)
            skillText:SetJustifyH("RIGHT")
            itemFrame.skillText = skillText

            local nameText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            nameText:SetPoint("LEFT", itemFrame, "LEFT", 62, 0)
            nameText:SetWidth(130)
            nameText:SetJustifyH("LEFT")
            itemFrame.nameText = nameText

            local zoneText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            zoneText:SetPoint("LEFT", itemFrame, "LEFT", 196, 0)
            zoneText:SetPoint("RIGHT", itemFrame, "RIGHT", -4, 0)
            zoneText:SetJustifyH("LEFT")
            itemFrame.zoneText = zoneText

            self.itemFrames[i] = itemFrame
        end

        local unlocked = skillLevel >= fish.skill
        local color = unlocked and "|cFF1EFF00" or "|cFFFF0000"
        local rarityColor = fish.rarity == 3 and "|cFFE6CC80" or fish.rarity == 2 and "|cFF0070DD" or ""

        -- 通过物品名获取图标
        local iconPath = nil
        pcall(function()
            local _, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(fish.name)
            if itemTexture then
                iconPath = itemTexture
            else
                -- 尝试带"新鲜的"前缀（很多鱼的物品名带此前缀）
                local _, _, _, _, _, _, _, _, _, altTexture = GetItemInfo("新鲜的" .. fish.name)
                if altTexture then iconPath = altTexture end
            end
        end)

        if iconPath then
            itemFrame.iconTex:SetTexture(iconPath)
        else
            pcall(function() itemFrame.iconTex:SetTexture("Interface\\Icons\\INV_Misc_Fish_02") end)
        end

        itemFrame.skillText:SetText(color .. fish.skill .. "|r")
        itemFrame.nameText:SetText(color .. rarityColor .. fish.name .. "|r")
        itemFrame.zoneText:SetText("|cFF88CCFF" .. (fish.zone or "") .. "|r")
        itemFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 4, yOffset)
        itemFrame:Show()
        yOffset = yOffset - 22
    end

    content:SetHeight(math.max(300, #UI.FISH_DATA * 22 + 20))
end

function UI:ShowStats()
    local content = self.contentFrame
    local db = WoWCultivationCharDB
    local fishCaught = (db and db.fishingStats and db.fishingStats.fishCaught) or {}

    -- 排序：按数量从多到少
    local sortedFish = {}
    for name, count in pairs(fishCaught) do
        table.insert(sortedFish, { name = name, count = count })
    end
    table.sort(sortedFish, function(a, b) return a.count > b.count end)

    local yOffset = -8

    if #sortedFish == 0 then
        local itemFrame = self.itemFrames[1]
        if not itemFrame then
            itemFrame = CreateFrame("Frame", nil, content)
            itemFrame:SetSize(370, 24)
            local emptyText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            emptyText:SetPoint("CENTER", itemFrame, "CENTER", 0, 0)
            itemFrame.emptyText = emptyText
            self.itemFrames[1] = itemFrame
        end
        itemFrame.emptyText:SetText("|cFF888888暂无钓鱼记录，去水边试试运气吧！|r")
        itemFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 4, yOffset)
        itemFrame:Show()
        content:SetHeight(300)
        return
    end

    for i, fishData in ipairs(sortedFish) do
        local itemFrame = self.itemFrames[i]
        if not itemFrame then
            itemFrame = CreateFrame("Frame", nil, content)
            itemFrame:SetSize(370, 20)

            local rankText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            rankText:SetPoint("LEFT", itemFrame, "LEFT", 4, 0)
            rankText:SetWidth(30)
            rankText:SetJustifyH("RIGHT")
            itemFrame.rankText = rankText

            local nameText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            nameText:SetPoint("LEFT", itemFrame, "LEFT", 40, 0)
            nameText:SetPoint("RIGHT", itemFrame, "RIGHT", -80, 0)
            nameText:SetJustifyH("LEFT")
            itemFrame.nameText = nameText

            local countText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            countText:SetPoint("RIGHT", itemFrame, "RIGHT", -4, 0)
            countText:SetWidth(70)
            countText:SetJustifyH("RIGHT")
            itemFrame.countText = countText

            self.itemFrames[i] = itemFrame
        end

        itemFrame.rankText:SetText("|cFFEEDDAA" .. i .. ".|r")
        itemFrame.nameText:SetText("|cFF1EFF00" .. fishData.name .. "|r")
        itemFrame.countText:SetText("|cFF44AAFF× " .. fishData.count .. "|r")
        itemFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 4, yOffset)
        itemFrame:Show()
        yOffset = yOffset - 22
    end

    content:SetHeight(math.max(300, #sortedFish * 22 + 20))
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
    self:RefreshContent()
    self.frame:Show()
end

function UI:Hide()
    if self.frame then self.frame:Hide() end
end

WoWCultivation.UI.FishingFrame = UI
