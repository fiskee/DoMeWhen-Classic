local DMW = DMW
local AceGUI = LibStub("AceGUI-3.0")

local defaults = {
    profile = {
        MinimapIcon = {
            hide = false
        },
        HUDPosition = {
            point = "LEFT",
            relativePoint = "LEFT",
            xOfs = 40,
            yOfs = 100
        },
        HUD = {
            Rotation = 1,
            Show = true
        },
        Enemy = {
            InterruptDelay = 0.8,
            InterruptTarget = 1,
            AutoFace = false
        },
        Friend = {
            DispelDelay = 1
        },
        Rotation = {},
        Queue = {
            Wait = 2,
            Items = true
        },
        Helpers = {
            AutoLoot = false,
            AutoSkinning = false,
            QuestieHelper = false,
            AutoGather = false,
            Herbs = false,
            Ore = false,
            LineToNodes = false,
            TrackAlert = false
        }
    }
}

function DMW.InitSettings()
    DMW.Settings = LibStub("AceDB-3.0"):New("DMWSettings", defaults, "Default")
    DMW.Settings:SetProfile(select(2, UnitClass("player")):gsub("%s+", ""))
end
