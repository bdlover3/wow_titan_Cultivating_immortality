local DB = {}
WoWCultivation.Core.DB = DB

local DEFAULT_ACCOUNT_DB = {
    version = WoWCultivation.version,
    settings = {
        sisterEnabled = true,
        channelEnabled = true,
        toastEnabled = true,
        realmLabelEnabled = true,
        chatFilterEnabled = true,
        innerDemonEnabled = true,
    },
}

local DEFAULT_CHAR_DB = {
    milestones = {
        talent = false,
        randomDungeon = false,
        firstRandomDungeon = false,
        mount = false,
        pvp = false,
        sect = false,
        foundation = false,
        outland = false,
        goldenCore = false,
        northrend = false,
        nascentSoul = false,
        peak = false,
    },
    innerDemon = {
        value = 0,
        lastUpdate = 0,
    },
    karma = {
        good = 0,
        evil = 0,
    },
    karmicDestiny = {},
    cultivationLog = {},
    firstLoad = true,
    sisterPosition = { point = "CENTER", x = 300, y = 0 },
}

function DB:Init()
    if not WoWCultivationDB then
        WoWCultivationDB = {}
    end
    if not WoWCultivationCharDB then
        WoWCultivationCharDB = {}
    end
    self:MergeDefaults(WoWCultivationDB, DEFAULT_ACCOUNT_DB)
    self:MergeDefaults(WoWCultivationCharDB, DEFAULT_CHAR_DB)
end

function DB:MergeDefaults(db, defaults)
    for k, v in pairs(defaults) do
        if db[k] == nil then
            db[k] = v
        elseif type(v) == "table" and type(db[k]) == "table" then
            self:MergeDefaults(db[k], v)
        end
    end
end

function DB:GetAccount(key)
    return WoWCultivationDB[key]
end

function DB:SetAccount(key, value)
    WoWCultivationDB[key] = value
end

function DB:GetChar(key)
    return WoWCultivationCharDB[key]
end

function DB:SetChar(key, value)
    WoWCultivationCharDB[key] = value
end

function DB:GetSetting(key)
    if WoWCultivationDB and WoWCultivationDB.settings then
        return WoWCultivationDB.settings[key]
    end
    return nil
end

function DB:SetSetting(key, value)
    if WoWCultivationDB and WoWCultivationDB.settings then
        WoWCultivationDB.settings[key] = value
    end
end
