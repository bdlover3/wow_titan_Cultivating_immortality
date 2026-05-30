local Module = {}
Module.name = "ApiCheckModule"
WoWCultivation.Modules.ApiCheckModule = Module

Module.API_TESTS = {
    { name = "UnitName", api = function() return UnitName("player") end, expect = "string" },
    { name = "UnitLevel", api = function() return UnitLevel("player") end, expect = "number" },
    { name = "UnitClass", api = function() return UnitClass("player") end, expect = "string" },
    { name = "UnitRace", api = function() return UnitRace("player") end, expect = "string" },
    { name = "UnitGUID", api = function() return UnitGUID("player") end, expect = "string" },
    { name = "UnitHealth", api = function() return UnitHealth("player") end, expect = "number" },
    { name = "UnitHealthMax", api = function() return UnitHealthMax("player") end, expect = "number" },
    { name = "UnitPower", api = function() return UnitPower("player") end, expect = "number" },
    { name = "UnitPowerMax", api = function() return UnitPowerMax("player") end, expect = "number" },
    { name = "UnitPowerType", api = function() return UnitPowerType("player") end, expect = "number" },
    { name = "UnitExists", api = function() return UnitExists("player") end, expect = "boolean" },
    { name = "UnitIsDead", api = function() return UnitIsDead("player") end, expect = "boolean" },
    { name = "UnitIsPlayer", api = function() return UnitIsPlayer("player") end, expect = "boolean" },
    { name = "UnitFactionGroup", api = function() return UnitFactionGroup("player") end, expect = "string" },
    { name = "UnitXP", api = function() return UnitXP("player") end, expect = "number" },
    { name = "UnitXPMax", api = function() return UnitXPMax("player") end, expect = "number" },
    { name = "GetMoney", api = function() return GetMoney() end, expect = "number" },
    { name = "GetRealmName", api = function() return GetRealmName() end, expect = "string" },
    { name = "GetTime", api = function() return GetTime() end, expect = "number" },
    { name = "IsInGuild", api = function() return IsInGuild() end, expect = "boolean" },
    { name = "IsInGroup", api = function() return IsInGroup() end, expect = "boolean" },
    { name = "IsInRaid", api = function() return IsInRaid() end, expect = "boolean" },
    { name = "GetNumGroupMembers", api = function() return GetNumGroupMembers() end, expect = "number" },
    { name = "GetInstanceInfo", api = function() return GetInstanceInfo() end, expect = "string" },
    { name = "IsInInstance", api = function() return IsInInstance() end, expect = "boolean" },
    { name = "GetRealZoneText", api = function() return GetRealZoneText() end, expect = "string" },
    { name = "GetZoneText", api = function() return GetZoneText() end, expect = "string" },
    { name = "IsResting", api = function() return IsResting() end, expect = "boolean" },
    { name = "GetNumSkillLines", api = function() return GetNumSkillLines() end, expect = "number" },
    { name = "GetNumTalentGroups", api = function() return GetNumTalentGroups() end, expect = "number" },
    { name = "GetActiveTalentGroup", api = function() return GetActiveTalentGroup() end, expect = "number" },
    { name = "GetTotalAchievementPoints", api = function() return GetTotalAchievementPoints() end, expect = "number" },
    { name = "GetNumSpellTabs", api = function() return GetNumSpellTabs() end, expect = "number" },
    { name = "GetInventorySlotInfo", api = function() return GetInventorySlotInfo("HeadSlot") end, expect = "number" },
    { name = "BreakUpLargeNumbers", api = function() return BreakUpLargeNumbers(1234567) end, expect = "string" },
    { name = "date", api = function() return date("%H:%M") end, expect = "string" },
    { name = "time", api = function() return time() end, expect = "number" },
    { name = "strsplit", api = function() return strsplit(",", "a,b,c") end, expect = "string" },
    { name = "strtrim", api = function() return strtrim("  hello  ") end, expect = "string" },
}

Module.C_NAMESPACE_TESTS = {
    { name = "C_Item.GetItemInfoInstant", api = function() return C_Item and C_Item.GetItemInfoInstant(25) end, expect = "table" },
    { name = "C_Item.GetItemIconByID", api = function() return C_Item and C_Item.GetItemIconByID(25) end, expect = "number" },
    { name = "C_Item.IsEquippableItem", api = function() return C_Item and C_Item.IsEquippableItem(25) end, expect = "boolean" },
    { name = "C_Container.GetContainerNumSlots", api = function() return C_Container and C_Container.GetContainerNumSlots(0) end, expect = "number" },
    { name = "C_Container.GetContainerNumFreeSlots", api = function() return C_Container and C_Container.GetContainerNumFreeSlots(0) end, expect = "number" },
    { name = "C_Map.GetBestMapForUnit", api = function() return C_Map and C_Map.GetBestMapForUnit("player") end, expect = "number" },
    { name = "C_Timer.After", api = function() return C_Timer and C_Timer.After end, expect = "function" },
    { name = "C_Timer.NewTicker", api = function() return C_Timer and C_Timer.NewTicker end, expect = "function" },
    { name = "C_ChatInfo.SendChatMessage", api = function() return C_ChatInfo and C_ChatInfo.SendChatMessage end, expect = "function" },
    { name = "AuraUtil.ForEachAura", api = function() return AuraUtil and AuraUtil.ForEachAura end, expect = "function" },
    { name = "C_UnitAuras.GetAuraDataByIndex", api = function() return C_UnitAuras and C_UnitAuras.GetAuraDataByIndex end, expect = "function" },
    { name = "C_Spell.GetSpellInfo", api = function() return C_Spell and C_Spell.GetSpellInfo end, expect = "function" },
    { name = "Settings.RegisterVerticalLayoutCategory", api = function() return Settings and Settings.RegisterVerticalLayoutCategory end, expect = "function" },
    { name = "CreateColor", api = function() local c = CreateColor(1,0,0,1); return c and c.r end, expect = "number" },
}

Module.MAY_EXIST_TESTS = {
    { name = "GetFPS", api = function() return GetFPS end, expect = "function" },
    { name = "GetAddOnInfo", api = function() return GetAddOnInfo end, expect = "function" },
    { name = "GetAddOnMetadata", api = function() return GetAddOnMetadata end, expect = "function" },
    { name = "IsAddOnLoaded", api = function() return IsAddOnLoaded end, expect = "function" },
    { name = "C_AddOns", api = function() return C_AddOns end, expect = "table" },
    { name = "C_QuestLog", api = function() return C_QuestLog end, expect = "table" },
    { name = "CombatLogGetCurrentEventInfo", api = function() return CombatLogGetCurrentEventInfo end, expect = "function" },
    { name = "GetProfessions", api = function() return GetProfessions end, expect = "function" },
    { name = "GetProfessionInfo", api = function() return GetProfessionInfo end, expect = "function" },
}

function Module:OnEnable()
end

function Module:RunAllTests()
    local pass = 0
    local fail = 0
    local results = {}
    local mayExistResults = {}

    local allTests = {}
    for _, t in ipairs(self.API_TESTS) do table.insert(allTests, t) end
    for _, t in ipairs(self.C_NAMESPACE_TESTS) do table.insert(allTests, t) end

    for _, test in ipairs(allTests) do
        local ok, result = pcall(test.api)
        local actualType = type(result)
        local passed = false

        if test.expect == "nil" then
            passed = (result == nil)
        elseif ok then
            if actualType == test.expect then
                passed = true
            elseif test.expect == "string" and (actualType == "string" or actualType == "nil") then
                passed = (result ~= nil)
            elseif test.expect == "number" and actualType == "number" then
                passed = true
            elseif test.expect == "boolean" then
                passed = (actualType == "boolean")
            elseif test.expect == "table" and (actualType == "table" or result ~= nil) then
                passed = (result ~= nil)
            elseif test.expect == "function" then
                passed = (type(result) == "function" or tostring(result):match("function"))
            end
        end

        if passed then
            pass = pass + 1
        else
            fail = fail + 1
        end

        table.insert(results, {
            name = test.name,
            passed = passed,
            actualType = actualType,
            expect = test.expect,
            value = result,
            error = not ok and tostring(result) or nil,
        })
    end

    for _, test in ipairs(self.MAY_EXIST_TESTS) do
        local ok, result = pcall(test.api)
        local actualType = type(result)
        local exists = (result ~= nil)

        table.insert(mayExistResults, {
            name = test.name,
            exists = exists,
            actualType = actualType,
            expect = test.expect,
            value = result,
        })
    end

    print("|cFFFFD700========== API 验证报告 ==========|r")
    print("|cFF00FF00通过: " .. pass .. "|r  |cFFFF0000失败: " .. fail .. "|r  |cFFFFFFFF总计: " .. (pass + fail) .. "|r")
    print("|cFF888888------------------------------|r")

    for _, r in ipairs(results) do
        if r.passed then
            print("  |cFF00FF00✓|r " .. r.name)
        else
            local detail = ""
            if r.error then
                detail = " |cFFFF4444错误: " .. r.error .. "|r"
            else
                detail = " |cFFFF8800期望:" .. r.expect .. " 实际:" .. r.actualType .. "|r"
                if r.value ~= nil then
                    local vs = tostring(r.value)
                    if #vs > 40 then vs = vs:sub(1, 40) .. "..." end
                    detail = detail .. " |cFF888888值=" .. vs .. "|r"
                end
            end
            print("  |cFFFF0000✗|r " .. r.name .. detail)
        end
    end

    print("|cFF888888------------------------------|r")
    print("|cFF88CCFF◆ 可选API检测 (可能存在)|r")
    for _, r in ipairs(mayExistResults) do
        if r.exists then
            print("  |cFF00FF00存在|r " .. r.name .. " |cFF888888(" .. r.actualType .. ")|r")
        else
            print("  |cFFFF0000不存在|r " .. r.name)
        end
    end

    print("|cFFFFD700================================|r")
    return pass, fail, results
end

SLASH_WOWCULTIVATIONAPICHECK1 = "/wcapi"
SlashCmdList["WOWCULTIVATIONAPICHECK"] = function(msg)
    if WoWCultivation.Modules.ApiCheckModule then
        WoWCultivation.Modules.ApiCheckModule:RunAllTests()
    end
end

WoWCultivation.Modules.ApiCheckModule = Module