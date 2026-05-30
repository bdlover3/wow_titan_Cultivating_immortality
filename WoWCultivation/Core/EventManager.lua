local EventManager = {}
WoWCultivation.Core.EventManager = EventManager

local gameEvents = {}
local customEvents = {}
local frame = CreateFrame("Frame")

frame:SetScript("OnEvent", function(self, event, ...)
    if gameEvents[event] then
        for _, handler in ipairs(gameEvents[event]) do
            local ok, err = pcall(handler, ...)
            if not ok then
                WoWCultivation:Debug("事件处理错误 [" .. event .. "]: " .. tostring(err))
            end
        end
    end
end)

local validGameEvents = {
    PLAYER_LOGIN = true,
    PLAYER_ENTERING_WORLD = true,
    PLAYER_LEVEL_UP = true,
    PLAYER_DEAD = true,
    PLAYER_REGEN_DISABLED = true,
    PLAYER_REGEN_ENABLED = true,
    UNIT_AURA = true,
    UNIT_HEALTH = true,
    UNIT_POWER = true,
    UNIT_POWER_UPDATE = true,
    UNIT_COMBAT = true,
    UNIT_DESTROYED = true,
    PARTY_MEMBERS_CHANGED = true,
    PARTY_MEMBER_DISABLE = true,
    PARTY_MEMBER_ENABLE = true,
    CHAT_MSG_LOOT = true,
    CHAT_MSG_SYSTEM = true,
    CHAT_MSG_CHANNEL = true,
    LFG_COMPLETION_REWARD = true,
    UPDATE_BATTLEFIELD_STATUS = true,
    ZONE_CHANGED = true,
    ZONE_CHANGED_NEW_AREA = true,
    ZONE_CHANGED_INDOORS = true,
    BAG_UPDATE = true,
    ITEM_LOCKED = true,
    ITEM_UNLOCKED = true,
    DISPLAY_SIZE_CHANGED = true,
    UI_SCALE_CHANGED = true,
}

function EventManager:Register(event, handler)
    if not event or not handler then return end
    
    if validGameEvents[event] then
        if not gameEvents[event] then
            gameEvents[event] = {}
            pcall(function() frame:RegisterEvent(event) end)
        end
        table.insert(gameEvents[event], handler)
    else
        if not customEvents[event] then
            customEvents[event] = {}
        end
        table.insert(customEvents[event], handler)
    end
end

function EventManager:Unregister(event, handler)
    if not event then return end
    
    if validGameEvents[event] and gameEvents[event] then
        for i, h in ipairs(gameEvents[event]) do
            if h == handler then
                table.remove(gameEvents[event], i)
                break
            end
        end
        if #gameEvents[event] == 0 then
            pcall(function() frame:UnregisterEvent(event) end)
            gameEvents[event] = nil
        end
    elseif customEvents[event] then
        for i, h in ipairs(customEvents[event]) do
            if h == handler then
                table.remove(customEvents[event], i)
                break
            end
        end
        if #customEvents[event] == 0 then
            customEvents[event] = nil
        end
    end
end

function EventManager:Trigger(event, ...)
    if not event then return end
    
    if customEvents[event] then
        for _, handler in ipairs(customEvents[event]) do
            local ok, err = pcall(handler, ...)
            if not ok then
                WoWCultivation:Debug("自定义事件处理错误 [" .. event .. "]: " .. tostring(err))
            end
        end
    end
end

function EventManager:TriggerGameEvent(event, ...)
    if not event then return end
    
    if gameEvents[event] then
        for _, handler in ipairs(gameEvents[event]) do
            local ok, err = pcall(handler, ...)
            if not ok then
                WoWCultivation:Debug("游戏事件处理错误 [" .. event .. "]: " .. tostring(err))
            end
        end
    end
end
