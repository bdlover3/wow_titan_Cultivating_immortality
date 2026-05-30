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
    -- 3.80.1: ChatFrame_AddMessageEventFilter 参数 (chatFrame, event, msg, author, ...)
    -- author 是玩家名字，3.80.1 中 UnitClass 接受 unit token 而非名字
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", function(chatFrame, event, msg, author, ...)
        local newMsg = msg .. "（" .. author .. "道友传音入密）"
        return newMsg, author, ...
    end)

    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", function(chatFrame, event, msg, author, ...)
        -- 3.80.1: UnitClass 接受 unit token，用 "player" 获取自己的宗门
        local _, englishClass = UnitClass("player")
        if englishClass then
            local sectInfo = WoWCultivation.Data.Sect[englishClass]
            if sectInfo then
                local newMsg = "【" .. sectInfo.name .. "】" .. msg
                return newMsg, author, ...
            end
        end
        return msg, author, ...
    end)
end

WoWCultivation.Modules.ChannelModule = Module
