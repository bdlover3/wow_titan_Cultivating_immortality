local Config = {}
WoWCultivation.Core.Config = Config

function Config:Init()
    SlashCmdList["XIUXIAN"] = function(msg)
        self:HandleSlashCommand(msg)
    end
    SLASH_XIUXIAN1 = "/xiuxian"
    SLASH_XIUXIAN2 = "/xxz"
end

function Config:HandleSlashCommand(msg)
    msg = msg and msg:lower() or ""
    if msg == "debug" then
        WoWCultivation.debug = not WoWCultivation.debug
        WoWCultivation:Print("调试模式: " .. (WoWCultivation.debug and "|cFF00FF00开启|r" or "|cFFFF0000关闭|r"))
    elseif msg == "reset" then
        WoWCultivationCharDB = nil
        WoWCultivationDB = nil
        WoWCultivation:Print("数据已重置，请重新加载UI (/rl)")
    elseif msg == "realm" then
        local info = WoWCultivation.Core.Utils:GetPlayerRealmInfo()
        if info and info.name then
            WoWCultivation:Print("当前境界: " .. info.bigRealm .. " · " .. info.name)
        else
            WoWCultivation:Print("未知境界")
        end
    elseif msg == "sect" then
        local info = WoWCultivation.Core.Utils:GetPlayerSectInfo()
        if info and info.name then
            WoWCultivation:Print("当前宗门: " .. info.name)
        else
            WoWCultivation:Print("未知宗门")
        end
    elseif msg == "money" then
        local text = WoWCultivation.Core.Utils:GetCurrencyText()
        WoWCultivation:Print("灵石: " .. text)
    elseif msg == "milestone" then
        local level = UnitLevel("player")
        if WoWCultivation.Modules.MilestoneModule then
            WoWCultivation.Modules.MilestoneModule:CheckMilestones(level)
        end
    elseif msg == "sister" then
        if WoWCultivation.UI.SisterModel then
            WoWCultivation.UI.SisterModel:Toggle()
        end
    elseif msg == "help" then
        self:ShowHelp()
    else
        self:ShowHelp()
    end
end

function Config:ShowHelp()
    WoWCultivation:Print("===== 魔兽修仙传 命令列表 =====")
    WoWCultivation:Print("/xxz realm - 查看当前境界")
    WoWCultivation:Print("/xxz sect - 查看当前宗门")
    WoWCultivation:Print("/xxz money - 查看灵石")
    WoWCultivation:Print("/xxz milestone - 检查里程碑")
    WoWCultivation:Print("/xxz sister - 切换小师妹")
    WoWCultivation:Print("/xxz debug - 切换调试模式")
    WoWCultivation:Print("/xxz reset - 重置所有数据")
    WoWCultivation:Print("/xxz help - 显示帮助")
end
