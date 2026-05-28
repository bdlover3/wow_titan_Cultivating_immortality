local Utils = {}
WoWCultivation.Core.Utils = Utils

function Utils:GetPlayerRealmInfo()
    local level = UnitLevel("player")
    return WoWCultivation.Data.Realm[level] or {}
end

function Utils:GetPlayerSectInfo()
    local _, class = UnitClass("player")
    return WoWCultivation.Data.Sect[class] or {}
end

function Utils:GetCurrencyText()
    local money = GetMoney()
    if not money or money <= 0 then
        return "|cFFCD853F0下品灵石|r"
    end
    local gold = floor(money / 10000)
    local silver = floor((money % 10000) / 100)
    local copper = money % 100
    return format("|cFFFFD700%d上品灵石|r |cFFC0C0C0%d中品灵石|r |cFFCD853F%d下品灵石|r", gold, silver, copper)
end

function Utils:FormatRealmName(level)
    local realm = WoWCultivation.Data.Realm[level]
    if not realm then return "未知境界" end
    return format("%s·%s", realm.bigRealm, realm.name)
end

function Utils:QualityToRank(quality)
    local ranks = {
        [0] = "凡器", [1] = "法器", [2] = "灵器",
        [3] = "宝器", [4] = "灵宝", [5] = "仙器",
        [6] = "先天灵宝",
    }
    return ranks[quality] or "未知品阶"
end

function Utils:QualityColor(quality)
    local colors = {
        [0] = "9d9d9d", [1] = "ffffff", [2] = "1eff00",
        [3] = "0070dd", [4] = "a335ee", [5] = "ff8000",
        [6] = "e6cc80",
    }
    return colors[quality] or "ffffff"
end

function Utils:GetRealmByLevel(level)
    if not level or level < 1 then return nil end
    return WoWCultivation.Data.Realm[level]
end

function Utils:GetSectByClass(englishClass)
    if not englishClass then return nil end
    return WoWCultivation.Data.Sect[englishClass]
end

function Utils:GetSpiritRootByClass(englishClass)
    local roots = {
        WARRIOR = "金灵根",
        PALADIN = "光灵根",
        HUNTER = "木灵根",
        ROGUE = "影灵根",
        PRIEST = "光灵根",
        DEATHKNIGHT = "冥灵根",
        SHAMAN = "雷灵根",
        MAGE = "水灵根",
        WARLOCK = "火灵根",
        DRUID = "木灵根",
    }
    return roots[englishClass] or "未知灵根"
end

function Utils:GetRealmColor(level)
    if level >= 71 then
        return "|cFFFF8000"
    elseif level >= 59 then
        return "|cFFA335EE"
    elseif level >= 41 then
        return "|cFF0070DD"
    elseif level >= 1 then
        return "|cFF1EFF00"
    end
    return "|cFFFFFFFF"
end

function Utils:SafeCall(func, ...)
    local ok, err = pcall(func, ...)
    if not ok then
        WoWCultivation:Debug("安全调用错误: " .. tostring(err))
    end
    return ok, err
end

if not BreakUpLargeNumbers then
    function BreakUpLargeNumbers(value)
        if not value then return "0" end
        local formatted = tostring(value)
        while true do
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
            if k == 0 then break end
        end
        return formatted
    end
end
