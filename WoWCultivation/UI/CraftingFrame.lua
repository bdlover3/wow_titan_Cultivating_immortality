-- ============================================================
-- CraftingFrame.lua - 炼器术面板
-- 显示当前装备灵宝品阶，装备强化概览
-- Titan Time Server 3.80.1 (Interface: 38001)
-- ============================================================
local UI = {}
UI.name = "CraftingFrame"
WoWCultivation.UI.CraftingFrame = UI

-- 装备槽位修仙化名称
UI.SLOT_NAMES = {
    HeadSlot      = "天灵冠",
    NeckSlot      = "护魂坠",
    ShoulderSlot  = "披风肩甲",
    BackSlot      = "飞天斗篷",
    ChestSlot     = "护体宝甲",
    ShirtSlot     = "内衬仙衣",
    TabardSlot    = "宗门徽记",
    WristSlot     = "护腕灵镯",
    HandsSlot     = "灵巧手套",
    WaistSlot     = "束灵腰带",
    LegsSlot      = "踏云腿甲",
    FeetSlot      = "御风靴",
    Finger0Slot   = "乾坤戒·左",
    Finger1Slot   = "乾坤戒·右",
    Trinket0Slot  = "护身法宝·左",
    Trinket1Slot  = "护身法宝·右",
    MainHandSlot  = "主手法器",
    SecondaryHandSlot = "副手法器",
    RangedSlot    = "远程灵器",
}

-- 装备品阶对应名称
UI.QUALITY_NAMES = {
    [0] = { name = "凡器",   color = "|cFF9d9d9d" },
    [1] = { name = "法器",   color = "|cFFFFFFFF" },
    [2] = { name = "灵器",   color = "|cFF1eff00" },
    [3] = { name = "宝器",   color = "|cFF0070dd" },
    [4] = { name = "灵宝",   color = "|cFFa335ee" },
    [5] = { name = "仙器",   color = "|cFFff8000" },
    [6] = { name = "先天灵宝", color = "|cFFe6cc80" },
}

UI.EQUIP_SLOTS = {
    "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot",
    "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot",
    "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot",
    "MainHandSlot", "SecondaryHandSlot", "RangedSlot",
}

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationCraftingFrame", UIParent, "BackdropTemplate")
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
    self:CreateEquipList(f)

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
    title:SetText("|cFFEEDD00◆ 炼器术 ◆|r")
end

function UI:CreateSummary(parent)
    self.summaryText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.summaryText:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -54)
    self.summaryText:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, -54)
    self.summaryText:SetWordWrap(true)
    self.summaryText:SetJustifyH("LEFT")
    self.summaryText:SetText("|cFFAAAAAA正在探查灵宝...|r")
end

function UI:CreateEquipList(parent)
    local scrollFrame = CreateFrame("ScrollFrame", "WoWCultivationCraftingScroll", parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -90)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -30, 14)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(450, 1)
    scrollFrame:SetScrollChild(content)

    self.equipItems = {}
    local itemHeight = 28
    for i, slotId in ipairs(UI.EQUIP_SLOTS) do
        local yOff = -(i - 1) * itemHeight
        local item = self:CreateEquipItem(content, slotId, i, yOff, 450)
        self.equipItems[slotId] = item
    end
    content:SetHeight(#UI.EQUIP_SLOTS * itemHeight + 10)
end

function UI:CreateEquipItem(parent, slotId, index, yOffset, width)
    local item = CreateFrame("Frame", nil, parent)
    item:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset)
    item:SetSize(width, 24)

    -- 槽位标签
    local slotLabel = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    slotLabel:SetPoint("LEFT", item, "LEFT", 6, 0)
    slotLabel:SetWidth(90)
    slotLabel:SetJustifyH("LEFT")
    slotLabel:SetText("|cFFEEDDAA" .. (UI.SLOT_NAMES[slotId] or slotId) .. "|r")

    -- 装备名称
    local equipLabel = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    equipLabel:SetPoint("LEFT", slotLabel, "RIGHT", 4, 0)
    equipLabel:SetPoint("RIGHT", item, "RIGHT", -6, 0)
    equipLabel:SetJustifyH("LEFT")
    equipLabel:SetText("|cFF888888空|r")

    item.slotLabel = slotLabel
    item.equipLabel = equipLabel
    return item
end

function UI:Refresh()
    if not self.frame then return end

    local totalItemLevel = 0
    local equippedCount = 0
    local bestQuality = 0
    local qualityCount = {}

    for _, slotId in ipairs(UI.EQUIP_SLOTS) do
        local itemLink = GetInventoryItemLink("player", GetInventorySlotInfo(slotId))
        local item = self.equipItems[slotId]
        if not item then
            -- skip
        elseif itemLink then
            local itemName, _, itemRarity, itemLevel = GetItemInfo(itemLink)
            if itemName then
                local qualityInfo = UI.QUALITY_NAMES[itemRarity] or UI.QUALITY_NAMES[0]
                item.equipLabel:SetText(qualityInfo.color .. "[" .. qualityInfo.name .. "] " .. itemName .. "|r")

                if itemLevel then
                    totalItemLevel = totalItemLevel + itemLevel
                end
                equippedCount = equippedCount + 1
                if itemRarity and itemRarity > bestQuality then
                    bestQuality = itemRarity
                end
                qualityCount[itemRarity] = (qualityCount[itemRarity] or 0) + 1
            end
        else
            item.equipLabel:SetText("|cFF888888空|r")
        end
    end

    -- 计算修炼者装备评价
    local avgItemLevel = equippedCount > 0 and math.floor(totalItemLevel / equippedCount) or 0
    local bestName = UI.QUALITY_NAMES[bestQuality] or UI.QUALITY_NAMES[0]

    local summaryParts = {}
    table.insert(summaryParts, "|cFFEEDDAA装备数量：|r" .. equippedCount .. " / " .. #UI.EQUIP_SLOTS)
    if avgItemLevel > 0 then
        table.insert(summaryParts, "|cFFEEDDAA平均品级：|r" .. avgItemLevel)
    end
    table.insert(summaryParts, "|cFFEEDDAA最高品阶：|r" .. bestName.color .. bestName.name .. "|r")

    -- 品阶分布
    local distParts = {}
    for q = 0, 6 do
        if qualityCount[q] and qualityCount[q] > 0 then
            local qi = UI.QUALITY_NAMES[q] or { name = "未知", color = "|cFFFFFFFF" }
            table.insert(distParts, qi.color .. qi.name .. " x" .. qualityCount[q] .. "|r")
        end
    end
    if #distParts > 0 then
        table.insert(summaryParts, "\n|cFFEEDDAA灵宝分布：|r" .. table.concat(distParts, "  "))
    end

    self.summaryText:SetText(table.concat(summaryParts, "  "))
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
