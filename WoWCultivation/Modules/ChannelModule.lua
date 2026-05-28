local Module = {}
Module.name = "ChannelModule"
Module.enabled = false

Module.CHANNEL_NAME = "修仙界"

Module.chatTypeMap = {
    ["CHAT_MSG_SAY"] = "道友曰",
    ["CHAT_MSG_YELL"] = "道友怒喝",
    ["CHAT_MSG_WHISPER"] = "传音入密",
    ["CHAT_MSG_WHISPER_INFORM"] = "回音入密",
    ["CHAT_MSG_GUILD"] = "宗门传音",
    ["CHAT_MSG_PARTY"] = "同修传音",
    ["CHAT_MSG_RAID"] = "秘境传音",
    ["CHAT_MSG_CHANNEL"] = "修仙界传音",
    ["CHAT_MSG_EMOTE"] = "道友动作",
}

function Module:OnEnable()
    self.enabled = true
    if not WoWCultivation.Core.DB:GetSetting("channelEnabled") then return end
    local EM = WoWCultivation.Core.EventManager
    EM:Register("PLAYER_ENTERING_WORLD", function()
        self:JoinChannel()
    end)
    self:SetupChatFilters()
end

function Module:OnDisable()
    self.enabled = false
end

function Module:JoinChannel()
    JoinChannelByName(self.CHANNEL_NAME)
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            ChatFrame_AddChannel(chatFrame, self.CHANNEL_NAME)
        end
    end
end

function Module:SetupChatFilters()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", function(self, event, msg, author, ...)
        local newMsg = msg .. "（" .. author .. "道友传音入密）"
        return false, newMsg, author, ...
    end)

    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", function(self, event, msg, author, ...)
        local _, englishClass = UnitClass(author)
        if englishClass then
            local sectInfo = WoWCultivation.Data.Sect[englishClass]
            if sectInfo then
                local newMsg = "【" .. sectInfo.name .. "】" .. msg
                return false, newMsg, author, ...
            end
        end
        return false, msg, author, ...
    end)
end

WoWCultivation.Modules.ChannelModule = Module
