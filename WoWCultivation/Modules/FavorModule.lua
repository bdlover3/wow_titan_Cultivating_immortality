local Module = {}
Module.name = "FavorModule"
Module.enabled = false

Module.FAVOR_LEVELS = {
    { min = 0,    name = "陌生",   title = "师兄",   color = "|cFF9D9D9D" },
    { min = 50,   name = "相识",   title = "师兄",   color = "|cFFFFFFFF" },
    { min = 200,  name = "友善",   title = "师兄",   color = "|cFF1EFF00" },
    { min = 500,  name = "好感",   title = "师弟",   color = "|cFF0070DD" },
    { min = 1000, name = "亲密",   title = "哥哥",   color = "|cFFA335EE" },
    { min = 2000, name = "倾心",   title = "哥哥",   color = "|cFFFF8000" },
    { min = 5000, name = "挚爱",   title = "夫君",   color = "|cFFE6CC80" },
}

Module.GIFTS = {
    {
        id = "spirit_tea", name = "灵茶", icon = "Interface\\Icons\\INV_Drink_05",
        cost = 15, favor = 5, desc = "一壶清香灵茶",
        favorTexts = {
            positive = "哇，灵茶！灵儿最喜欢了~谢谢师兄！",
            neutral  = "灵茶啊...谢谢师兄。",
            negative = "灵茶...灵儿不太喜欢喝茶呢...",
        }
    },
    {
        id = "spirit_stone", name = "灵石", icon = "Interface\\Icons\\INV_Misc_Gem_Variety_01",
        cost = 80, favor = 15, desc = "一块蕴含灵气的灵石",
        favorTexts = {
            positive = "灵石！师兄对灵儿真好~灵儿会好好保管的！",
            neutral  = "灵石...师兄破费了。",
            negative = "灵石...灵儿不太在意这些外物呢。",
        }
    },
    {
        id = "elixir", name = "丹药", icon = "Interface\\Icons\\INV_Potion_03",
        cost = 50, favor = 10, desc = "一枚珍贵丹药",
        favorTexts = {
            positive = "丹药！灵儿正好需要呢~谢谢师兄关心！",
            neutral  = "丹药...谢谢师兄。",
            negative = "丹药...灵儿现在不需要呢。",
        }
    },
    {
        id = "flower", name = "灵花", icon = "Interface\\Icons\\INV_Misc_Herb_04",
        cost = 10, favor = 8, desc = "一朵美丽的灵花",
        favorTexts = {
            positive = "好漂亮的花！灵儿好喜欢~师兄真懂灵儿！",
            neutral  = "花...挺好看的，谢谢师兄。",
            negative = "花...灵儿对花没什么感觉呢。",
        }
    },
    {
        id = "cake", name = "灵糕", icon = "Interface\\Icons\\INV_Misc_Food_11",
        cost = 25, favor = 12, desc = "一块精致灵糕",
        favorTexts = {
            positive = "灵糕！好甜好甜~灵儿最爱吃了！谢谢师兄！",
            neutral  = "灵糕...谢谢师兄。",
            negative = "灵糕...灵儿不太喜欢甜食呢。",
        }
    },
    {
        id = "jade", name = "玉佩", icon = "Interface\\Icons\\INV_Jewelry_Talisman_02",
        cost = 150, favor = 25, desc = "一块温润玉佩",
        favorTexts = {
            positive = "玉佩！好漂亮...灵儿会一直戴着的！谢谢师兄！",
            neutral  = "玉佩...挺精致的，谢谢师兄。",
            negative = "玉佩...灵儿不太喜欢戴饰物呢。",
        }
    },
    {
        id = "book", name = "功法", icon = "Interface\\Icons\\INV_Misc_Book_06",
        cost = 120, favor = 20, desc = "一本珍稀功法",
        favorTexts = {
            positive = "功法！灵儿正好想学新法术呢~师兄最懂灵儿了！",
            neutral  = "功法...谢谢师兄。",
            negative = "功法...灵儿现在不想修炼呢...",
        }
    },
    {
        id = "sword", name = "灵剑", icon = "Interface\\Icons\\INV_Sword_04",
        cost = 300, favor = 35, desc = "一把灵气逼人的灵剑",
        favorTexts = {
            positive = "灵剑！好强好帅！灵儿会用它保护师兄的！",
            neutral  = "灵剑...谢谢师兄。",
            negative = "灵剑...灵儿不喜欢打打杀杀的呢...",
        }
    },
}

Module.PREFERENCE_CATEGORIES = {
    { id = "food",   name = "食物偏好", options = { "甜食", "辣食", "清淡", "肉食" } },
    { id = "hobby",  name = "兴趣偏好", options = { "修炼", "炼丹", "探险", "安静" } },
    { id = "gift",   name = "礼物偏好", options = { "灵石", "花", "饰物", "书籍" } },
    { id = "color",  name = "颜色偏好", options = { "红色", "蓝色", "绿色", "紫色" } },
    { id = "season", name = "季节偏好", options = { "春天", "夏天", "秋天", "冬天" } },
}

Module.GIFT_PREFERENCE_MAP = {
    spirit_tea  = { food = "清淡", hobby = "安静" },
    spirit_stone = { gift = "灵石" },
    elixir      = { hobby = "炼丹" },
    flower      = { gift = "花", season = "春天" },
    cake        = { food = "甜食" },
    jade        = { gift = "饰物" },
    book        = { gift = "书籍", hobby = "修炼" },
    sword       = { hobby = "探险" },
}

Module.DIALOG_CHOICES = {
    {
        id = "greeting_1",
        trigger = "click",
        text = "灵儿，今天过得怎么样？",
        options = {
            { text = "你看起来很开心呢！", favor = 5,  response = "嘿嘿，被师兄看出来了~今天确实心情不错呢！" },
            { text = "是不是想我了？",      favor = 8,  response = "才...才没有！...好吧，有一点点想师兄..." },
            { text = "别烦我，忙着呢。",    favor = -10, response = "呜...师兄好凶...灵儿走开就是了..." },
        }
    },
    {
        id = "greeting_2",
        trigger = "click",
        text = "灵儿，你觉得这里怎么样？",
        options = {
            { text = "有你在哪里都好。",    favor = 10, response = "师兄...你说这种话，灵儿会害羞的啦..." },
            { text = "还行吧。",            favor = 1,  response = "嗯...师兄真是不解风情呢。" },
            { text = "太无聊了。",          favor = -5, response = "那...灵儿给师兄讲个故事好不好？" },
        }
    },
    {
        id = "greeting_3",
        trigger = "click",
        text = "师兄，灵儿有个问题想问你...",
        options = {
            { text = "你说，我听着呢。",    favor = 5,  response = "嗯...算了，没什么啦~谢谢师兄愿意听灵儿说。" },
            { text = "是不是又想偷懒了？",  favor = -3, response = "才不是！灵儿是很认真地在想问题呢！" },
            { text = "别磨磨蹭蹭的。",      favor = -8, response = "呜...师兄好凶...灵儿不说了..." },
        }
    },
    {
        id = "combat_1",
        trigger = "combat_end",
        text = "师兄刚才好厉害！灵儿在旁边看得心惊胆战的...",
        options = {
            { text = "有灵儿在旁边看着，我更有力量了。", favor = 12, response = "师...师兄！你说这种话...灵儿脸好红..." },
            { text = "小意思而已。",                    favor = 2,  response = "哼，师兄就知道逞强~" },
            { text = "差点翻车了。",                    favor = 3,  response = "师兄小心点嘛...灵儿会担心的..." },
        }
    },
    {
        id = "quest_1",
        trigger = "quest_complete",
        text = "师兄又完成了一个任务呢！灵儿好佩服~",
        options = {
            { text = "多亏有灵儿陪着我。",  favor = 8,  response = "嘿嘿~灵儿会一直陪着师兄的！" },
            { text = "这种任务太简单了。",  favor = 0,  response = "那...师兄能不能带灵儿去做更厉害的任务？" },
            { text = "赶紧下一个。",        favor = -2, response = "师兄好急...灵儿跟不上了..." },
        }
    },
    {
        id = "dungeon_1",
        trigger = "dungeon_complete",
        text = "秘境通关了！师兄好厉害！",
        options = {
            { text = "灵儿也辛苦了，一起休息吧。", favor = 10, response = "嗯！和师兄一起休息...灵儿好开心~" },
            { text = "这不算什么。",              favor = 1,  response = "师兄总是这么谦虚~" },
            { text = "走，继续下一个。",          favor = -3, response = "师兄...灵儿有点累了...能不能歇一歇？" },
        }
    },
    {
        id = "death_1",
        trigger = "player_dead",
        text = "师兄！你没事吧？！灵儿好担心...",
        options = {
            { text = "没事，让灵儿担心了。", favor = 5,  response = "师兄没事就好...灵儿差点吓哭了..." },
            { text = "只是小失误。",        favor = 0,  response = "师兄下次要小心啊...灵儿不想看到师兄受伤..." },
            { text = "别大惊小怪的。",      favor = -8, response = "灵儿才不是大惊小怪...灵儿是真的担心师兄嘛..." },
        }
    },
    {
        id = "idle_1",
        trigger = "idle",
        text = "师兄...灵儿好无聊啊...",
        options = {
            { text = "那我陪你聊聊天吧。",  favor = 6,  response = "好呀好呀！灵儿最喜欢和师兄说话了~" },
            { text = "你自己玩会儿。",      favor = -5, response = "呜...师兄不理灵儿了..." },
            { text = "去修炼就不会无聊了。", favor = -2, response = "灵儿知道啦...但是修炼好无聊嘛..." },
        }
    },
    {
        id = "gift_thanks",
        trigger = "gift",
        text = "师兄送灵儿礼物？",
        options = {
            { text = "看到就想到你了。",    favor = 5,  response = "师兄...灵儿好感动~" },
            { text = "顺手买的而已。",      favor = 0,  response = "哼，师兄就不能说点好听的嘛~" },
            { text = "别客气，收着吧。",    favor = 2,  response = "嗯！灵儿会好好珍惜的~" },
        }
    },
}

Module.FAVOR_MILESTONES = {
    [50]   = { text = "灵儿觉得师兄是个好人呢~",              level = "相识" },
    [200]  = { text = "和师兄在一起，灵儿觉得很安心。",        level = "友善" },
    [500]  = { text = "师兄...灵儿开始离不开你了...",          level = "好感" },
    [1000] = { text = "灵儿...想一直陪在哥哥身边...",          level = "亲密" },
    [2000] = { text = "哥哥...灵儿的心里只有你一个人...",      level = "倾心" },
    [5000] = { text = "夫君...此生此世，灵儿只愿与你相伴...",  level = "挚爱" },
}

Module.FAVOR_SOURCE = {
    PASSIVE       = { value = 1,  name = "陪伴" },
    QUEST         = { value = 10, name = "完成任务" },
    DUNGEON       = { value = 10, name = "通关秘境" },
    RAID_BOSS     = { value = 10, name = "击杀团本Boss" },
    GIFT          = { value = 0,  name = "赠送礼物" },
    DIALOG        = { value = 0,  name = "对话选择" },
    LEVEL_UP      = { value = 5,  name = "境界提升" },
    COMBAT_PROTECT= { value = 3,  name = "战斗守护" },
}

function Module:OnEnable()
    self.enabled = true
    self:InitFavorData()
    self:GeneratePreferences()
    self:StartPassiveTimer()
    self:RegisterEvents()
end

function Module:OnDisable()
    self.enabled = false
    if self.passiveTimer then
        self.passiveTimer:Cancel()
        self.passiveTimer = nil
    end
end

function Module:InitFavorData()
    local db = WoWCultivationCharDB
    if not db.favor then
        db.favor = {
            value = 0,
            totalEarned = 0,
            lastPassiveTime = time(),
            giftsGiven = {},
            preferences = {},
            dialogHistory = {},
            milestones = {},
        }
    end
    if not db.favor.value then db.favor.value = 0 end
    if not db.favor.totalEarned then db.favor.totalEarned = 0 end
    if not db.favor.lastPassiveTime then db.favor.lastPassiveTime = time() end
    if not db.favor.giftsGiven then db.favor.giftsGiven = {} end
    if not db.favor.preferences then db.favor.preferences = {} end
    if not db.favor.dialogHistory then db.favor.dialogHistory = {} end
    if not db.favor.milestones then db.favor.milestones = {} end

    local now = time()
    local elapsed = now - db.favor.lastPassiveTime
    if elapsed > 60 then
        local minutes = math.floor(elapsed / 60)
        local cappedMinutes = math.min(minutes, 120)
        if cappedMinutes > 0 then
            self:AddFavor(cappedMinutes, "PASSIVE")
            db.favor.lastPassiveTime = now
        end
    end
end

function Module:GeneratePreferences()
    local db = WoWCultivationCharDB
    if not db.favor.preferences then db.favor.preferences = {} end

    if next(db.favor.preferences) == nil then
        for _, cat in ipairs(self.PREFERENCE_CATEGORIES) do
            local idx = math.random(1, #cat.options)
            db.favor.preferences[cat.id] = cat.options[idx]
        end
    end

    self.preferences = db.favor.preferences
end

function Module:StartPassiveTimer()
    if self.passiveTimer then
        self.passiveTimer:Cancel()
    end
    self.passiveTimer = C_Timer.NewTicker(60, function()
        self:AddFavor(self.FAVOR_SOURCE.PASSIVE.value, "PASSIVE")
        WoWCultivationCharDB.favor.lastPassiveTime = time()
    end)
end

function Module:RegisterEvents()
    local EM = WoWCultivation.Core.EventManager
    EM:Register("PLAYER_LEVEL_UP", function()
        self:AddFavor(self.FAVOR_SOURCE.LEVEL_UP.value, "LEVEL_UP")
    end)
    EM:Register("PLAYER_DEAD", function()
        self:TriggerChoiceDialog("death_1")
    end)
    EM:Register("PLAYER_REGEN_ENABLED", function()
        self:TriggerChoiceDialog("combat_1")
    end)
    EM:Register("CHAT_MSG_SYSTEM", function(msg)
        if msg and type(msg) == "string" then
            if string.find(msg, "任务完成") or string.find(msg, "Quest") then
                self:AddFavor(self.FAVOR_SOURCE.QUEST.value, "QUEST")
                self:TriggerChoiceDialog("quest_1")
            end
        end
    end)
    EM:Register("UPDATE_BATTLEFIELD_STATUS", function()
        self:AddFavor(self.FAVOR_SOURCE.DUNGEON.value, "DUNGEON")
        self:TriggerChoiceDialog("dungeon_1")
    end)
end

function Module:GetFavor()
    local db = WoWCultivationCharDB
    if not db.favor then return 0 end
    return db.favor.value or 0
end

function Module:GetFavorLevel()
    local favor = self:GetFavor()
    local current = self.FAVOR_LEVELS[1]
    for _, lvl in ipairs(self.FAVOR_LEVELS) do
        if favor >= lvl.min then
            current = lvl
        end
    end
    return current
end

function Module:GetFavorLevelName()
    return self:GetFavorLevel().name
end

function Module:GetTitle()
    return self:GetFavorLevel().title
end

function Module:GetFavorColor()
    return self:GetFavorLevel().color
end

function Module:GetNextLevelInfo()
    local favor = self:GetFavor()
    for i, lvl in ipairs(self.FAVOR_LEVELS) do
        if favor < lvl.min then
            return {
                name = lvl.name,
                min = lvl.min,
                remaining = lvl.min - favor,
            }
        end
    end
    return nil
end

function Module:AddFavor(amount, source)
    if not amount or amount == 0 then return end
    local db = WoWCultivationCharDB
    if not db.favor then return end

    local oldLevel = self:GetFavorLevelName()
    db.favor.value = (db.favor.value or 0) + amount
    if amount > 0 then
        db.favor.totalEarned = (db.favor.totalEarned or 0) + amount
    end
    if db.favor.value < 0 then db.favor.value = 0 end

    local newLevel = self:GetFavorLevelName()
    if newLevel ~= oldLevel then
        self:OnFavorLevelUp(oldLevel, newLevel)
    end

    self:CheckMilestones()

    if amount > 0 then
        self:ShowFavorToast(amount, source)
    end

    WoWCultivation.Core.EventManager:Trigger("FAVOR_CHANGED", db.favor.value, source, amount)
end

function Module:OnFavorLevelUp(oldLevel, newLevel)
    local SisterModule = WoWCultivation.Modules and WoWCultivation.Modules.SisterModule
    local title = self:GetTitle()

    local messages = {
        ["相识"] = "师兄，灵儿觉得和你越来越熟了呢~",
        ["友善"] = "和师兄在一起，灵儿觉得很安心。",
        ["好感"] = "师兄...灵儿开始离不开你了...",
        ["亲密"] = title .. "...灵儿想一直陪在你身边...",
        ["倾心"] = title .. "...灵儿的心里只有你一个人...",
        ["挚爱"] = title .. "...此生此世，灵儿只愿与你相伴...",
    }

    local msg = messages[newLevel]
    if msg and SisterModule and SisterModule.Say then
        C_Timer.After(2, function()
            SisterModule:Say(msg)
        end)
    end

    if WoWCultivation.UI and WoWCultivation.UI.Toast then
        WoWCultivation.UI.Toast:Show("好感度升级！→ " .. newLevel, 5)
    end
end

function Module:CheckMilestones()
    local db = WoWCultivationCharDB
    if not db.favor or not db.favor.milestones then return end
    local favor = db.favor.value

    for threshold, data in pairs(self.FAVOR_MILESTONES) do
        if favor >= threshold and not db.favor.milestones[threshold] then
            db.favor.milestones[threshold] = true
            local SisterModule = WoWCultivation.Modules and WoWCultivation.Modules.SisterModule
            if SisterModule and SisterModule.Say then
                C_Timer.After(3, function()
                    SisterModule:Say(data.text)
                end)
            end
        end
    end
end

function Module:ShowFavorToast(amount, source)
    -- 好感度数值隐藏，仅显示等级变化提示
    -- 具体数值不展示，保持探索感
    if source == "PASSIVE" then return end
end

function Module:GiveGift(giftId)
    local gift = nil
    for _, g in ipairs(self.GIFTS) do
        if g.id == giftId then
            gift = g
            break
        end
    end
    if not gift then return false end

    local db = WoWCultivationCharDB
    if not db.favor then return false end

    -- 检查仙缘值
    local ImmortalModule = WoWCultivation.Modules and WoWCultivation.Modules.ImmortalDestinyModule
    local currentDestiny = ImmortalModule and ImmortalModule:GetValue() or 0
    if currentDestiny < gift.cost then
        if WoWCultivation.UI and WoWCultivation.UI.Toast then
            WoWCultivation.UI.Toast:Show("仙缘不足，无法赠送" .. gift.name .. "（需要" .. gift.cost .. "仙缘值）", 3)
        end
        return false
    end

    -- 扣除仙缘值
    if ImmortalModule then
        ImmortalModule:Spend(gift.cost)
    end

    local favorMultiplier = self:CalculateGiftFavorMultiplier(giftId)
    local finalFavor = math.floor(gift.favor * favorMultiplier)

    local sentiment = self:GetGiftSentiment(giftId)

    db.favor.giftsGiven = db.favor.giftsGiven or {}
    table.insert(db.favor.giftsGiven, {
        id = giftId,
        time = time(),
        favor = finalFavor,
    })

    self:AddFavor(finalFavor, "GIFT")

    local SisterModule = WoWCultivation.Modules and WoWCultivation.Modules.SisterModule
    if SisterModule and SisterModule.Say then
        local response = gift.favorTexts[sentiment] or gift.favorTexts.neutral
        SisterModule:Say(response)
    end

    self:TriggerChoiceDialog("gift_thanks")

    return true
end

function Module:CalculateGiftFavorMultiplier(giftId)
    local prefMap = self.GIFT_PREFERENCE_MAP[giftId]
    if not prefMap then return 1.0 end

    local prefs = self.preferences or {}
    local matchCount = 0
    local totalCategories = 0

    for catId, value in pairs(prefMap) do
        totalCategories = totalCategories + 1
        if prefs[catId] == value then
            matchCount = matchCount + 1
        end
    end

    if totalCategories == 0 then return 1.0 end

    local ratio = matchCount / totalCategories
    if ratio >= 1.0 then return 2.0 end
    if ratio >= 0.5 then return 1.5 end
    return 1.0
end

function Module:GetGiftSentiment(giftId)
    local prefMap = self.GIFT_PREFERENCE_MAP[giftId]
    if not prefMap then return "neutral" end

    local prefs = self.preferences or {}
    local matchCount = 0
    local totalCategories = 0

    for catId, value in pairs(prefMap) do
        totalCategories = totalCategories + 1
        if prefs[catId] == value then
            matchCount = matchCount + 1
        end
    end

    if totalCategories == 0 then return "neutral" end
    local ratio = matchCount / totalCategories
    if ratio >= 1.0 then return "positive" end
    if ratio >= 0.5 then return "neutral" end
    return "negative"
end

function Module:TriggerChoiceDialog(dialogId)
    local dialog = nil
    for _, d in ipairs(self.DIALOG_CHOICES) do
        if d.id == dialogId then
            dialog = d
            break
        end
    end
    if not dialog then return end

    local db = WoWCultivationCharDB
    if not db.favor then return end
    db.favor.dialogHistory = db.favor.dialogHistory or {}
    local now = time()
    local lastTime = db.favor.dialogHistory[dialogId] or 0
    if now - lastTime < 60 then return end

    if math.random() > 0.5 then return end

    db.favor.dialogHistory[dialogId] = now

    if WoWCultivation.UI and WoWCultivation.UI.FavorFrame then
        WoWCultivation.UI.FavorFrame:ShowChoiceDialog(dialog)
    end
end

function Module:SelectDialogChoice(dialogId, optionIndex)
    local dialog = nil
    for _, d in ipairs(self.DIALOG_CHOICES) do
        if d.id == dialogId then
            dialog = d
            break
        end
    end
    if not dialog then return end
    if not dialog.options[optionIndex] then return end

    local option = dialog.options[optionIndex]
    self:AddFavor(option.favor, "DIALOG")

    local SisterModule = WoWCultivation.Modules and WoWCultivation.Modules.SisterModule
    if SisterModule and SisterModule.Say then
        SisterModule:Say(option.response)
    end
end

function Module:GetPreferenceText()
    local prefs = self.preferences or {}
    local lines = {}
    for _, cat in ipairs(self.PREFERENCE_CATEGORIES) do
        local value = prefs[cat.id] or "未知"
        table.insert(lines, cat.name .. ": " .. value)
    end
    return table.concat(lines, "\n")
end

function Module:GetGiftStats()
    local db = WoWCultivationCharDB
    if not db.favor or not db.favor.giftsGiven then
        return { count = 0, totalFavor = 0 }
    end
    local count = #db.favor.giftsGiven
    local totalFavor = 0
    for _, g in ipairs(db.favor.giftsGiven) do
        totalFavor = totalFavor + (g.favor or 0)
    end
    return { count = count, totalFavor = totalFavor }
end

function Module:GetFavorInfoString()
    local favor = self:GetFavor()
    local level = self:GetFavorLevel()
    local nextLvl = self:GetNextLevelInfo()
    local title = self:GetTitle()

    local str = level.color .. "好感度: " .. favor .. " (" .. level.name .. ")|r"
    str = str .. "\n称呼: " .. title
    if nextLvl then
        str = str .. "\n距离" .. nextLvl.name .. "还需: " .. nextLvl.remaining
    end
    return str
end

WoWCultivation.Modules.FavorModule = Module
