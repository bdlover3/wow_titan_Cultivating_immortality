local Module = {}
Module.name = "SisterModule"
Module.enabled = false
Module.dialogQueue = {}
Module.isShowingDialog = false

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("PLAYER_ENTERING_WORLD", function()
        self:OnEnteringWorld()
    end)
end

function Module:OnDisable()
    self.enabled = false
end

function Module:OnEnteringWorld()
    if WoWCultivationCharDB.firstLoad then
        self:ShowFirstLoadDialog()
        WoWCultivationCharDB.firstLoad = false
    end
end

function Module:ShowFirstLoadDialog()
    local level = UnitLevel("player")
    local _, englishClass = UnitClass("player")
    local realmInfo = WoWCultivation.Data.Realm[level]
    local sectInfo = WoWCultivation.Data.Sect[englishClass]

    local realmName = realmInfo and realmInfo.bigRealm .. " · " .. realmInfo.name or "练气初期"
    local sectName = sectInfo and sectInfo.name or "散修"
    local spiritRoot = sectInfo and sectInfo.spiritRoot or "未知灵根"

    local dialog = {
        "师兄，你终于醒了！我是你的引路师妹·灵儿。",
        "你尚在" .. realmName .. "，修仙之路漫漫，且听我道来...",
        "你已拜入" .. sectName .. "，修炼" .. spiritRoot .. "之力。",
        "勤修功法，方能掌握更强大的术法。",
        "以后有什么不懂的，随时点击我即可。",
        "修仙界广阔，愿师兄早日飞升！",
    }
    self:ShowDialog(dialog)
end

function Module:ShowDialog(dialogSequence)
    if not dialogSequence or #dialogSequence == 0 then return end
    for _, line in ipairs(dialogSequence) do
        table.insert(self.dialogQueue, line)
    end
    if not self.isShowingDialog then
        self:ShowNextDialog()
    end
end

function Module:ShowNextDialog()
    if #self.dialogQueue == 0 then
        self.isShowingDialog = false
        if WoWCultivation.UI.SisterModel then
            WoWCultivation.UI.SisterModel:HideDialog()
        end
        return
    end

    self.isShowingDialog = true
    local text = table.remove(self.dialogQueue, 1)

    if WoWCultivation.UI.SisterModel then
        WoWCultivation.UI.SisterModel:ShowDialog(text)
    else
        WoWCultivation:Print("灵儿: " .. text)
    end

    C_Timer.After(3, function()
        self:ShowNextDialog()
    end)
end

function Module:Say(text)
    if WoWCultivation.UI.SisterModel then
        WoWCultivation.UI.SisterModel:ShowDialog(text)
    else
        WoWCultivation:Print("灵儿: " .. text)
    end
end

WoWCultivation.Modules.SisterModule = Module
