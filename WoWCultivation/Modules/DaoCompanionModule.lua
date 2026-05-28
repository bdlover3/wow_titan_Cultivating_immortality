local Module = {}
Module.name = "DaoCompanionModule"
Module.enabled = false

Module.STATUS_MAP = {
    online  = "道友出关",
    offline = "道友闭关",
}

function Module:OnEnable()
    self.enabled = true
    self.friendStates = {}
    local EM = WoWCultivation.Core.EventManager
    EM:Register("FRIENDLIST_UPDATE", function()
        self:OnFriendListUpdate()
    end)
    EM:Register("PLAYER_ENTERING_WORLD", function()
        self:InitFriendStates()
    end)
end

function Module:OnDisable()
    self.enabled = false
    self.friendStates = {}
end

function Module:InitFriendStates()
    self.friendStates = {}
    for i = 1, GetNumFriends() do
        local name, _, _, _, connected = GetFriendInfo(i)
        if name then
            self.friendStates[name] = connected and "online" or "offline"
        end
    end
end

function Module:OnFriendListUpdate()
    for i = 1, GetNumFriends() do
        local name, _, _, _, connected = GetFriendInfo(i)
        if name then
            local prev = self.friendStates[name]
            local curr = connected and "online" or "offline"
            if prev and prev ~= curr then
                self:OnFriendStatusChanged(name, curr)
            end
            self.friendStates[name] = curr
        end
    end
end

function Module:OnFriendStatusChanged(name, status)
    local statusText = self.STATUS_MAP[status] or status
    if status == "online" then
        WoWCultivation:Print(name .. " — " .. statusText)
        if WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show(name .. " 道友出关了！", 3)
        end
    else
        WoWCultivation:Print(name .. " — " .. statusText)
    end
end

function Module:GetCompanionList()
    local list = {}
    for i = 1, GetNumFriends() do
        local name, level, class, area, connected = GetFriendInfo(i)
        if name then
            local status = connected and "online" or "offline"
            table.insert(list, {
                name = name,
                level = level,
                class = class,
                area = area,
                connected = connected,
                statusText = self.STATUS_MAP[status] or status,
            })
        end
    end
    return list
end

function Module:GetCompanionCount()
    local total = GetNumFriends()
    local online = 0
    for i = 1, total do
        local _, _, _, _, connected = GetFriendInfo(i)
        if connected then
            online = online + 1
        end
    end
    return total, online
end

function Module:GetCompanionText()
    local total, online = self:GetCompanionCount()
    return "道友: |cFF00FF00" .. online .. "|r/" .. total .. " (出关/总)"
end

WoWCultivation.Modules.DaoCompanionModule = Module
