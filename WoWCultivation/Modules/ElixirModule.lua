local Module = {}
Module.name = "ElixirModule"
Module.enabled = false

Module.ELIXIR_MAP = {
    potion = {
        category = "丹药",
        map = {
            [118]  = "回血丹",
            [4596] = "回血丹",
            [4597] = "回血丹",
            [4598] = "回血丹",
            [4599] = "回血丹",
            [4600] = "回血丹",
            [4601] = "回血丹",
            [4787] = "回血丹",
            [4788] = "回血丹",
            [4789] = "回血丹",
            [4790] = "回血丹",
            [4791] = "回血丹",
            [4792] = "回血丹",
            [33447] = "回血丹",
            [33448] = "回血丹",
            [40081] = "回血丹",
            [40087] = "回血丹",
            [41166] = "回血丹",
            [47869] = "回血丹",
        },
    },
    mana = {
        category = "丹药",
        map = {
            [2455] = "回气丹",
            [2456] = "回气丹",
            [2457] = "回气丹",
            [2458] = "回气丹",
            [2459] = "回气丹",
            [3385] = "回气丹",
            [3827] = "回气丹",
            [6149] = "回气丹",
            [6150] = "回气丹",
            [6151] = "回气丹",
            [6152] = "回气丹",
            [6153] = "回气丹",
            [6154] = "回气丹",
            [33449] = "回气丹",
            [33450] = "回气丹",
            [47870] = "回气丹",
        },
    },
    flask = {
        category = "天元丹",
        map = {},
    },
    food = {
        category = "灵膳",
        map = {},
    },
}

Module.ELIXIR_TYPE_NAMES = {
    [1] = "回血丹",
    [2] = "回气丹",
    [3] = "天元丹",
    [4] = "灵膳",
}

function Module:OnEnable()
    self.enabled = true
    self:HookTooltip()
end

function Module:OnDisable()
    self.enabled = false
end

function Module:GetElixirName(itemId)
    for _, category in pairs(self.ELIXIR_MAP) do
        if category.map[itemId] then
            return category.map[itemId]
        end
    end

    -- 3.80.1: GetItemInfo 接受 item link，需通过 item ID 构造 link
    local itemLink = "item:" .. itemId .. ":0:0:0:0:0:0:0"
    local itemName = GetItemInfo(itemLink)
    if not itemName then return nil end

    local isPotion = itemName:find("治疗药水") or itemName:find("Health Potion")
    if isPotion then return "回血丹" end

    local isMana = itemName:find("法力药水") or itemName:find("Mana Potion")
    if isMana then return "回气丹" end

    local isFlask = itemName:find("合剂") or itemName:find("Flask")
    if isFlask then return "天元丹" end

    local isFood = itemName:find("食物") or itemName:find("Food") or itemName:find("面包") or itemName:find(" conjured")
    if isFood then return "灵膳" end

    return nil
end

function Module:GetElixirCategory(itemId)
    local elixirName = self:GetElixirName(itemId)
    if not elixirName then return nil end
    for key, category in pairs(self.ELIXIR_MAP) do
        if category.map[itemId] then
            return category.category
        end
    end
    if elixirName == "回血丹" or elixirName == "回气丹" then return "丹药" end
    if elixirName == "天元丹" then return "天元丹" end
    if elixirName == "灵膳" then return "灵膳" end
    return "丹药"
end

function Module:HookTooltip()
    GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
        if not self.enabled then return end
        local _, link = tooltip:GetItem()
        if not link then return end
        local itemId = tonumber(link:match("item:(%d+)"))
        if not itemId then return end
        local elixirName = self:GetElixirName(itemId)
        if elixirName then
            local category = self:GetElixirCategory(itemId)
            tooltip:AddLine("|cFF9B59B6修仙丹药|r: " .. elixirName .. " (" .. category .. ")")
        end
    end)
end

function Module:OnUseElixir(itemId)
    local elixirName = self:GetElixirName(itemId)
    if elixirName then
        WoWCultivation:Print("服用" .. elixirName)
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("服用" .. elixirName, 2)
        end
    end
end

WoWCultivation.Modules.ElixirModule = Module
