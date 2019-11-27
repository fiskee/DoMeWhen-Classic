DMW = LibStub("AceAddon-3.0"):NewAddon("DMW", "AceConsole-3.0")
local DMW = DMW
DMW.Tables = {}
DMW.Enums = {}
DMW.Functions = {}
DMW.Rotations = {}
DMW.Player = {}
DMW.Plugins = {}
DMW.UI = {}
DMW.Settings = {}
DMW.Helpers = {}
DMW.Timers = {
    OM = {},
    QuestieHelper = {},
    Trackers = {},
    Gatherers = {},
    Rotation = {}
}
DMW.Pulses = 0
local Initialized = false
local DebugStart
local RotationCount = 0

local function FindRotation()
    if DMW.Rotations[DMW.Player.Class] and DMW.Rotations[DMW.Player.Class].Rotation then
        DMW.Player.Rotation = DMW.Rotations[DMW.Player.Class].Rotation
        if DMW.Rotations[DMW.Player.Class].Settings then
            DMW.Rotations[DMW.Player.Class].Settings()
        end
        DMW.UI.HUD.Load()
    end
end

local function Init()
    DMW.InitSettings()
    DMW.UI.Init()
    DMW.UI.HUD.Init()
    DMW.Player = DMW.Classes.LocalPlayer(ObjectPointer("player"))
    DMW.UI.InitQueue()
    Initialized = true
end

local function ExecutePlugins()
    for _, Plugin in pairs(DMW.Plugins) do
        if type(Plugin) == "function" then
            Plugin()
        end
    end
end

local mountedDcheck
local function itemSets()
    if mountedDcheck == nil then mountedDcheck = IsMounted()end 
    if mountedDcheck and not IsMounted() then
        -- RunMacro("geardps")
        if not DMW.Player.Combat then
            -- 0 = ammo 
            -- 1 = head 
            -- 2 = neck 
            -- 3 = shoulder 
            -- 4 = shirt 
            -- 5 = chest 
            -- 6 = waist 
            -- 7 = legs 
            -- 8 = feet 
            -- 9 = wrist 
            -- 10 = hands 
            -- 11 = finger 1 
            -- 12 = finger 2 
            -- 13 = trinket 1 
            -- 14 = trinket 2 
            -- 15 = back 
            -- 16 = main hand 
            -- 17 = off hand 
            -- 18 = ranged 
            -- 19 = tabard 
            -- EquipItemByName(15063)
            -- EquipItemByName(12555)
            -- EquipItemByName(19120)
            -- RunMacroText("/equipslot InvSlot item 19120 ") --10 hands
            -- if not IsEquippedItem()
            EquipItemByName("Battlechaser's Greaves", 8)
            EquipItemByName("Hand of Justice", 13)
            -- EquipItemByName("Seal of the Dawn", 13)
            -- RunMacroText("/equipslot 8  Battlechaser's Greaves")-- 8 feet
            -- RunMacroText("/equipslot 13 Rune of the Guard Captain") --trink1 13
        end
        mountedDcheck = false
    elseif IsMounted() and not mountedDcheck then
        if not DMW.Player.Combat then
            -- EquipItemByName(18722)
            -- EquipItemByName(13068)
            -- EquipItemByName(11122)
            -- RunMacroText("/equipslot InvSlot item 19120 ")+
            EquipItemByName("Obsidian Greaves", 8)
            EquipItemByName("Carrot on a Stick", 13)
            -- EquipItemByName("Battlechaser", 8)
            -- RunMacroText("/equipslot 8 Obsidian Greaves")
            -- RunMacroText("/equipslot 13 Carrot on a Stick")
        end
        mountedDcheck = true
    end
end

local f = CreateFrame("Frame", "DoMeWhen", UIParent)
f:SetScript(
    "OnUpdate",
    function(self, elapsed)
        if GetObjectWithGUID then
            LibStub("LibDraw-1.0").clearCanvas()
            DMW.Time = GetTime()
            DMW.Pulses = DMW.Pulses + 1
            if not Initialized and not DMW.UI.MinimapIcon then
                Init()
            end
            DebugStart = debugprofilestop()
            DMW.UpdateOM()
            DMW.Timers.OM.Last = debugprofilestop() - DebugStart
            DMW.UI.Debug.Run()
            DebugStart = debugprofilestop()
            DMW.Helpers.QuestieHelper.Run()
            DMW.Timers.QuestieHelper.Last = debugprofilestop() - DebugStart
            DebugStart = debugprofilestop()
            DMW.Helpers.Trackers.Run()
            DMW.Timers.Trackers.Last = debugprofilestop() - DebugStart
            DebugStart = debugprofilestop()
            DMW.Helpers.Gatherers.Run()
            DMW.Timers.Gatherers.Last = debugprofilestop() - DebugStart
            DMW.Helpers.Swing.Run(elapsed)
            -- if ExecutePlugins() then return end
            if not DMW.Player.Rotation then
                FindRotation()
                return
            else
                if DMW.Helpers.Queue.Run() then
                    return
                end
                -- if DMW.Player.Class == "WARRIOR" then
                --     itemSets()
                -- end
                if DMW.Helpers.Rotation.Active() then
                    if DMW.Player.Combat then
                        RotationCount = RotationCount + 1
                        DebugStart = debugprofilestop()
                    end
                    DMW.Player.Rotation()
                    if DMW.Player.Combat then
                        DMW.Timers.Rotation.Last = debugprofilestop() - DebugStart
                        DMW.Timers.Rotation.Total = DMW.Timers.Rotation.Total and (DMW.Timers.Rotation.Total + DMW.Timers.Rotation.Last) or DMW.Timers.Rotation.Last
                        DMW.Timers.Rotation.Average = DMW.Timers.Rotation.Total / RotationCount
                    end
                end
            end
            DMW.Timers.OM.Total = DMW.Timers.OM.Total and (DMW.Timers.OM.Total + DMW.Timers.OM.Last) or DMW.Timers.OM.Last
            DMW.Timers.QuestieHelper.Total = DMW.Timers.QuestieHelper.Total and (DMW.Timers.QuestieHelper.Total + DMW.Timers.QuestieHelper.Last) or DMW.Timers.QuestieHelper.Last
            DMW.Timers.Trackers.Total = DMW.Timers.Trackers.Total and (DMW.Timers.Trackers.Total + DMW.Timers.Trackers.Last) or DMW.Timers.Trackers.Last
            DMW.Timers.Gatherers.Total = DMW.Timers.Gatherers.Total and (DMW.Timers.Gatherers.Total + DMW.Timers.Gatherers.Last) or DMW.Timers.Gatherers.Last
            DMW.Timers.Rotation.Total = DMW.Timers.Rotation.Total and (DMW.Timers.Rotation.Total + DMW.Timers.Rotation.Last) or DMW.Timers.Rotation.Last or nil

            DMW.Timers.OM.Average = DMW.Timers.OM.Total / DMW.Pulses
            DMW.Timers.QuestieHelper.Average = DMW.Timers.QuestieHelper.Total / DMW.Pulses
            DMW.Timers.Trackers.Average = DMW.Timers.Trackers.Total / DMW.Pulses
            DMW.Timers.Gatherers.Average = DMW.Timers.Gatherers.Total / DMW.Pulses
            if ExecutePlugins() then return end
        end
    end
)
