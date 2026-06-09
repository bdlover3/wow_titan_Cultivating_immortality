-- ============================================================
-- StorageFrame.lua - 储物袋
-- 修仙主题背包物品展示面板
-- 目标版本: 泰坦时光服 3.80.1
-- ============================================================
local UI = {}
UI.name = "StorageFrame"
WoWCultivation.UI.StorageFrame = UI

UI.BAG_NAMES = { "主储物袋", "副袋·壹", "副袋·贰", "副袋·叁", "副袋·肆" }
UI.BAG_COLORS = {
    [0] = { r = 0.6, g = 0.6, b = 0.6 },  -- poor
    [1] = { r = 1, g = 1, b = 1 },          -- common
    [2] = { r = 0.2, g = 1, b = 0.2 },      -- uncommon
    [3] = { r = 0.1, g = 0.5, b = 1 },      -- rare
    [4] = { r = 0.7, g = 0.2, b = 1 },      -- epic
    [5] = { r = 1, g = 0.5, b = 0.1 },      -- legendary
    [6] = { r = 1, g = 0.2, b = 0.2 },      -- artifact
}

function UI:OnEnable()
    self.frame = CreateFrame("Frame", "WoWCultivationStorageFrame", UIParent, "BackdropTemplate")
    local f = self.frame
    f:SetSize(420, 400)
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
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    f:SetFrameStrata("DIALOG")

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function() UI:Hide() end)

    -- 标题
    local title = f:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
    title:SetPoint("TOP", f, "TOP", 0, -12)
    title:SetText("|cFFFFD700◆ 灵 储 物 袋 ◆|r")
    f.titleText = title

    -- 状态栏：物品总数 + 剩余空位
    local statusBar = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusBar:SetPoint("TOP", title, "BOTTOM", 0, -4)
    statusBar:SetText("|cFF888888整理储物袋...|r")
    f.statusText = statusBar

    -- 储物袋切换标签
    self:CreateBagTabs(f)

    -- 物品列表滚动区域
    self:CreateScrollFrame(f)

    f:Hide()
end

function UI:CreateBagTabs(parent)
    local tabWidth = 72
    local tabHeight = 22
    local tabGap = 4
    local totalWidth = tabWidth * (#UI.BAG_NAMES) + tabGap * (#UI.BAG_NAMES - 1)
    local startX = -totalWidth / 2 + tabWidth / 2

    self.bagTabs = {}
    for i, bagName in ipairs(UI.BAG_NAMES) do
        local tab = CreateFrame("Button", nil, parent, "BackdropTemplate")
        tab:SetSize(tabWidth, tabHeight)
        tab:SetPoint("TOP", parent, "TOP", startX + (i - 1) * (tabWidth + tabGap), -38)
        tab:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tileSize = 8, edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        tab:SetBackdropColor(0.06, 0.03, 0.1, 0.85)
        tab:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)

        local tabText = tab:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        tabText:SetPoint("CENTER", tab, "CENTER", 0, 0)
        tabText:SetText(bagName)

        tab.bagIndex = i - 1  -- 0=背包, 1-4=行囊
        tab:SetScript("OnClick", function(self)
            UI:SelectBag(self.bagIndex)
        end)
        tab:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
        end)
        tab:SetScript("OnLeave", function(self)
            if UI.selectedBag ~= self.bagIndex then
                self:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)
            end
        end)

        self.bagTabs[i] = tab
    end
end

function UI:CreateScrollFrame(parent)
    local scrollBg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    scrollBg:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -72)
    scrollBg:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -28, 14)
    scrollBg:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    scrollBg:SetBackdropColor(0.04, 0.02, 0.08, 0.8)
    scrollBg:SetBackdropBorderColor(0.5, 0.35, 0.08, 0.5)

    -- ScrollFrame
    local sf = CreateFrame("ScrollFrame", "WoWCultivationStorageScroll", parent, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT", scrollBg, "TOPLEFT", 4, -4)
    sf:SetPoint("BOTTOMRIGHT", scrollBg, "BOTTOMRIGHT", -4, 4)
    self.scrollFrame = sf

    -- Content container
    local content = CreateFrame("Frame", nil, sf)
    content:SetSize(360, 300)
    sf:SetScrollChild(content)
    self.contentFrame = content

    -- Item frames pool
    self.itemFrames = {}
    self.itemSlots = {}
end

function UI:SelectBag(bagIndex)
    self.selectedBag = bagIndex
    -- Highlight active tab
    for _, tab in ipairs(self.bagTabs) do
        if tab.bagIndex == bagIndex then
            tab:SetBackdropBorderColor(0.85, 0.65, 0.13, 1)
            tab:SetBackdropColor(0.12, 0.06, 0.18, 0.9)
        else
            tab:SetBackdropBorderColor(0.55, 0.4, 0.08, 0.7)
            tab:SetBackdropColor(0.06, 0.03, 0.1, 0.85)
        end
    end
    self:RefreshItems()
end

function UI:RefreshItems()
    local bagIndex = self.selectedBag or 0
    local content = self.contentFrame
    if not content then return end

    -- Clear old item frames
    for _, f in ipairs(self.itemFrames) do
        f:Hide()
    end
    self.itemSlots = {}

    -- 3.80.1: 使用 C_Container API（手册确认原生支持）
    local numSlots = C_Container.GetContainerNumSlots(bagIndex)
    local items = {}
    for slot = 1, numSlots do
        local info = C_Container.GetContainerItemInfo(bagIndex, slot)
        local itemLink = C_Container.GetContainerItemLink(bagIndex, slot)
        if info and itemLink then
            local quality = info.quality or info.itemQuality or 1
            local itemCount = info.stackCount or 1
            local itemIcon = info.iconFileID or info.icon
            local itemName = itemLink
            -- 尝试获取物品名称
            local name = GetItemInfo(itemLink)
            if name then itemName = name end
            -- 如果没有图标，尝试通过C_Item获取
            if not itemIcon and info.itemID then
                itemIcon = C_Item.GetItemIconByID(info.itemID)
            end
            table.insert(items, {
                slot = slot,
                link = itemLink,
                name = itemName,
                quality = quality,
                icon = itemIcon or "Interface\\Icons\\INV_Misc_QuestionMark",
                count = itemCount,
            })
        end
    end

    -- Update status
    local usedSlots = #items
    local emptySlots = numSlots - usedSlots
    local bagLabel = UI.BAG_NAMES[bagIndex + 1] or "储物袋"
    self.frame.statusText:SetText(string.format("|cFFEEDDAA%s|r  灵物: |cFF1EFF00%d|r 件  空位: |cFF888888%d|r",
        bagLabel, usedSlots, emptySlots))

    -- Layout: 8 items per row
    local cols = 8
    local itemSize = 38
    local gap = 4
    local totalRowWidth = cols * itemSize + (cols - 1) * gap
    local startX = (360 - totalRowWidth) / 2

    local frameIdx = 0
    for _, itemData in ipairs(items) do
        frameIdx = frameIdx + 1
        local row = math.floor((frameIdx - 1) / cols)
        local col = (frameIdx - 1) % cols
        local x = startX + col * (itemSize + gap)
        local y = -8 - row * (itemSize + gap)

        local itemFrame = self.itemFrames[frameIdx]
        if not itemFrame then
            itemFrame = CreateFrame("Button", nil, content)
            itemFrame:SetSize(itemSize, itemSize)
            itemFrame:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2")
            itemFrame:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")

            local iconTex = itemFrame:CreateTexture(nil, "ARTWORK")
            iconTex:SetPoint("TOPLEFT", itemFrame, "TOPLEFT", 2, -2)
            iconTex:SetPoint("BOTTOMRIGHT", itemFrame, "BOTTOMRIGHT", -2, 2)
            itemFrame.icon = iconTex

            local countText = itemFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmallGray")
            countText:SetPoint("BOTTOMRIGHT", itemFrame, "BOTTOMRIGHT", -1, 1)
            itemFrame.countText = countText

            -- Quality border effect
            local border = itemFrame:CreateTexture(nil, "BORDER")
            border:SetAllPoints(itemFrame)
            border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
            border:SetBlendMode("ADD")
            itemFrame.border = border

            itemFrame:SetScript("OnEnter", function(self)
                if self.tipText then
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(self.itemLink)
                    GameTooltip:Show()
                end
            end)
            itemFrame:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
            itemFrame:SetScript("OnClick", function(self)
                if self.itemLink and IsAltKeyDown() then
                    -- Alt+Click: 在聊天框粘贴物品链接
                    if ChatFrameEditBox then
                        ChatFrameEditBox:Insert(self.itemLink)
                    end
                end
            end)

            self.itemFrames[frameIdx] = itemFrame
        end

        -- Set item data
        local iconPath = itemData.icon or "Interface\\Icons\\INV_Misc_QuestionMark"
        pcall(function() itemFrame.icon:SetTexture(iconPath) end)

        if itemData.count > 1 then
            itemFrame.countText:SetText(tostring(itemData.count))
            itemFrame.countText:Show()
        else
            itemFrame.countText:Hide()
        end

        -- Quality border color
        local color = UI.BAG_COLORS[itemData.quality] or { r = 1, g = 1, b = 1 }
        itemFrame.border:SetVertexColor(color.r, color.g, color.b, 0.8)
        itemFrame.border:Show()

        itemFrame.itemLink = itemData.link
        itemFrame.tipText = true
        itemFrame:SetPoint("TOPLEFT", content, "TOPLEFT", x, y)
        itemFrame:Show()

        self.itemSlots[itemData.slot] = itemFrame
    end

    -- Update scroll child height
    local totalRows = math.ceil(frameIdx / cols)
    local contentHeight = math.max(300, totalRows * (itemSize + gap) + 16)
    content:SetHeight(contentHeight)
end

function UI:Show()
    if not self.frame then return end
    self.selectedBag = 0
    self:SelectBag(0)
    self.frame:Show()
end

function UI:Hide()
    if not self.frame then return end
    self.frame:Hide()
end

function UI:Toggle()
    if not self.frame then return end
    if self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

function UI:IsShown()
    return self.frame and self.frame:IsShown()
end

WoWCultivation.UI.StorageFrame = UI
