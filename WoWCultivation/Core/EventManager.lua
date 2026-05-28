local EventManager = CreateFrame("Frame")
WoWCultivation.Core.EventManager = EventManager

local eventHandlers = {}

EventManager:SetScript("OnEvent", function(self, event, ...)
    if eventHandlers[event] then
        for _, handler in ipairs(eventHandlers[event]) do
            local ok, err = pcall(handler, ...)
            if not ok then
                WoWCultivation:Debug("事件处理错误 [" .. event .. "]: " .. tostring(err))
            end
        end
    end
end)

function EventManager:Register(event, handler)
    if not eventHandlers[event] then
        eventHandlers[event] = {}
        self:RegisterEvent(event)
    end
    table.insert(eventHandlers[event], handler)
end

function EventManager:Unregister(event, handler)
    if eventHandlers[event] then
        for i, h in ipairs(eventHandlers[event]) do
            if h == handler then
                table.remove(eventHandlers[event], i)
                break
            end
        end
        if #eventHandlers[event] == 0 then
            self:UnregisterEvent(event)
            eventHandlers[event] = nil
        end
    end
end

function EventManager:Trigger(event, ...)
    if eventHandlers[event] then
        for _, handler in ipairs(eventHandlers[event]) do
            handler(...)
        end
    end
end
