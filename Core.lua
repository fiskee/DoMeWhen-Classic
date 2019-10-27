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
    InitializeNavigation()
    Initialized = true
end

local function ExecutePlugins()
    for _, Plugin in pairs(DMW.Plugins) do
        if type(Plugin) == "function" then
            Plugin()
        end
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
            ExecutePlugins()
            if not DMW.Player.Rotation then
                FindRotation()
                return
            else
                if DMW.Helpers.Queue.Run() then
                    return
                end
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
            DMW.Helpers.Navigation:Pulse()
            DMW.Timers.OM.Total = DMW.Timers.OM.Total and (DMW.Timers.OM.Total + DMW.Timers.OM.Last) or DMW.Timers.OM.Last
            DMW.Timers.QuestieHelper.Total = DMW.Timers.QuestieHelper.Total and (DMW.Timers.QuestieHelper.Total + DMW.Timers.QuestieHelper.Last) or DMW.Timers.QuestieHelper.Last
            DMW.Timers.Trackers.Total = DMW.Timers.Trackers.Total and (DMW.Timers.Trackers.Total + DMW.Timers.Trackers.Last) or DMW.Timers.Trackers.Last
            DMW.Timers.Gatherers.Total = DMW.Timers.Gatherers.Total and (DMW.Timers.Gatherers.Total + DMW.Timers.Gatherers.Last) or DMW.Timers.Gatherers.Last
            DMW.Timers.Rotation.Total = DMW.Timers.Rotation.Total and (DMW.Timers.Rotation.Total + DMW.Timers.Rotation.Last) or DMW.Timers.Rotation.Last or nil

            DMW.Timers.OM.Average = DMW.Timers.OM.Total / DMW.Pulses
            DMW.Timers.QuestieHelper.Average = DMW.Timers.QuestieHelper.Total / DMW.Pulses
            DMW.Timers.Trackers.Average = DMW.Timers.Trackers.Total / DMW.Pulses
            DMW.Timers.Gatherers.Average = DMW.Timers.Gatherers.Total / DMW.Pulses
        end
    end
)
