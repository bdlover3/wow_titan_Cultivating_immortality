-- ============================================================
-- TreasureFrame.lua - 灵宝鉴面板
-- 展示玩家已获得的灵宝（装备收集图鉴）
-- Titan Time Server 3.80.1 (Interface: 38001)
-- ============================================================
local UI = {}
UI.name = "TreasureFrame"
WoWCultivation.UI.TreasureFrame = UI

-- 品阶信息
UI.QUALITY_INFO = {
    [0] = { name = "凡器",     color = "|cFF9d9d9d", bgColor = {0.38, 0.38, 0.38} },
    [1] = { name = "法器",     color = "|cFFFFFFFF", bgColor = {0.6, 0.6, 0.6} },
    [2] = { name = "灵器",     color = "|cFF1eff00", bgColor = {0.07, 0.5, 0} },
    [3] = { name = "宝器",     color = "|cFF0070dd", bgColor = {0, 0.22, 0.43} },
    [4] = { name = "灵宝",     color = "|cFFa335ee", bgColor = {0.32, 0.1, 0.47} },
    [5] = { name = "仙器",     color = "|cFFff8000", bgColor = {0.5, 0.25, 0} },
    [6] = { name = "先天灵宝", color = "|cFFe6cc80", bgColor = {0.45, 0.4, 0.25} },
}

-- 装备槽位图鉴信息
UI.SLOT_INFO = {
    { slotName = "HeadSlot",      displayName = "天灵冠",   icon = "Interface\\Icons\\INV_Helmet_24" },
    { slotName = "NeckSlot",      displayName = "护魂坠",   icon = "Interface\\Icons\\INV_Jewelry_Necklace_22" },
    { slotName = "ShoulderSlot",  displayName = "披风肩甲", icon = "Interface\\Icons\\INV_Shoulder_25" },
    { slotName = "ChestSlot",     displayName = "护体宝甲", icon = "Interface\\Icons\\INV_Chest_Chain" },
    { slotName = "WristSlot",     displayName = "护腕灵镯", icon = "Interface\\Icons\\INV_Bracer_07" },
    { slotName = "HandsSlot",     displayName = "灵巧手套", icon = "Interface\\Icons\\INV_Gauntlets_26" },
    { slotName = "WaistSlot",     displayName = "束灵腰带", icon = "Interface\\Icons\\INV_Belt_06" },
    { slotName = "LegsSlot",      displayName = "踏云腿甲", icon = "Interface\\Icons\\INV_Pants_06" },
    { slotName = "FeetSlot",      displayName = "御风靴",   icon = "Interface\\Icons\\INV_Boots_Chain_07" },
    { slotName = "Finger0Slot",   displayName = "乾坤戒",   icon = "Interface\\Icons\\INV_Jewelry_Ring_22" },
    { slotName = "Finger1Slot",   displayName = "乾坤戒",   icon = "Interface\\Icons\\INV_Jewelry_Ring_31" },
    { slotName = "Trinket0Slot",  displayName = "护身法宝", icon = "Interface\\Icons\\INV_Jewelry_Trinket_02" },
    { slotName = "Trinket1Slot",  displayName = "护身法宝", icon = "Interface\\Icons\\INV_Jewelry_Trinket_05" },
    { slotName = "MainHandSlot",  displayName = "主手法器", icon = "Interface\\Icons\\INV_Sword_27" },
    { slotName = "SecondaryHandSlot", displayName = "副手法器", icon = "Interface\\Icons\\INV_Shield_06" },
    { slotName = "RangedSlot",    displayName = "远程灵器", icon = "Interface\\Icons\\INV_Weapon_Rifle_01" },
}

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationTreasureFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(500, 520)
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
    self:CreateSummary(f)
    self:CreateSlotGrid(f)

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
    title:SetText("|cFFA335EE◆ 灵宝鉴 ◆|r")
end

function UI:CreateSummary(parent)
    self.summaryText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.summaryText:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -54)
    self.summaryText:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, -54)
    self.summaryText:SetJustifyH("LEFT")
    self.summaryText:SetText("|cFFAAAAAA正在鉴宝...|r")
end

function UI:CreateSlotGrid(parent)
    self.slotItems = {}
    local cols = 4
    local itemW = 108
    local itemH = 52
    local gap = 6
    local startX = 16
    local startY = -84

    for i, slotInfo in ipairs(UI.SLOT_INFO) do
        local row = math.floor((i - 1) / cols)
        local col = (i - 1) % cols
        local xOff = startX + col * (itemW + gap)
        local yOff = startY - row * (itemH + gap)

        local item = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        item:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff)
        item:SetSize(itemW, itemH)
        item:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8, edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        item:SetBackdropColor(0.04, 0.02, 0.06, 0.9)
        item:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.5)

        -- 图标
        local icon = item:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", item, "TOPLEFT", 4, -4)
        icon:SetSize(24, 24)
        icon:SetTexture(slotInfo.icon)

        -- 槽位名
        local slotLabel = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        slotLabel:SetPoint("TOPLEFT", icon, "TOPRIGHT", 4, -2)
        slotLabel:SetText("|cFFEEDDAA" .. slotInfo.displayName .. "|r")

        -- 灵宝名
        local equipLabel = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        equipLabel:SetPoint("TOPLEFT", slotLabel, "BOTTOMLEFT", 0, -2)
        equipLabel:SetPoint("RIGHT", item, "RIGHT", -4, 0)
        equipLabel:SetJustifyH("LEFT")
        equipLabel:SetText("|cFF666666未装备|r")

        item.slotName = slotInfo.slotName
        item.icon = icon
        item.equipLabel = equipLabel

        -- 悬停
        item:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        end)
        item:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.5)
        end)

        self.slotItems[i] = item
    end
end

function UI:Refresh()
    if not self.frame then return end

    local totalEquipped = 0
    local bestQuality = 0
    local qualityCount = {}

    for _, item in ipairs(self.slotItems) do
        local slotId = GetInventorySlotInfo(item.slotName)
        local itemLink = GetInventoryItemLink("player", slotId)
        if itemLink then
            local itemName, _, itemRarity = GetItemInfo(itemLink)
            if itemName then
                local qi = UI.QUALITY_INFO[itemRarity] or UI.QUALITY_INFO[0]
                item.equipLabel:SetText(qi.color .. itemName .. "|r")
                item:SetBackdropColor(qi.bgColor[1] * 0.3, qi.bgColor[2] * 0.3, qi.bgColor[3] * 0.3, 0.85)
                totalEquipped = totalEquipped + 1
                if itemRarity and itemRarity > bestQuality then
                    bestQuality = itemRarity
                end
                qualityCount[itemRarity] = (qualityCount[itemRarity] or 0) + 1
            else
                item.equipLabel:SetText("|cFF666666未装备|r")
                item:SetBackdropColor(0.04, 0.02, 0.06, 0.9)
            end
        else
            item.equipLabel:SetText("|cFF666666未装备|r")
            item:SetBackdropColor(0.04, 0.02, 0.06, 0.9)
        end
    end

    local bestQI = UI.QUALITY_INFO[bestQuality] or UI.QUALITY_INFO[0]
    local parts = {
        "|cFFEEDDAA灵宝装备：|r" .. totalEquipped .. " / " .. #UI.SLOT_INFO,
        "|cFFEEDDAA最高品阶：|r" .. bestQI.color .. bestQI.name .. "|r",
    }

    local distParts = {}
    for q = 1, 6 do
        if qualityCount[q] and qualityCount[q] > 0 then
            local qi = UI.QUALITY_INFO[q]
            table.insert(distParts, qi.color .. qi.name .. " x" .. qualityCount[q] .. "|r")
        end
    end
    if #distParts > 0 then
        table.insert(parts, "\n|cFFEEDDAA收集品阶：|r" .. table.concat(distParts, "  "))
    end

    self.summaryText:SetText(table.concat(parts, "  "))
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
