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
            TrackNPC = false,
            QuestieHelperColor = {0,0,0,1},
            HerbsColor = {0,0,0,1},
            OreColor = {0,0,0,1},
            TrackUnitsColor = {0,0,0,1},
            TrackObjectsColor = {0,0,0,1},
            TrackPlayersColor = {0,0,0,1},
            OreAlert = false,
            HerbsAlert = false,
            QuestieHelperAlert = false,
            TrackUnitsAlert = false,
            TrackObjectsAlert = false,
            TrackPlayersAlert = false,
            OreLine = 0,
            HerbsLine = 0,
            QuestieHelperLine = 0,
            TrackUnitsLine = 0,
            TrackObjectsLine = 0,
            TrackPlayersLine = 0

        }
    },
    char = {
        SelectedProfile = select(2, UnitClass("player")):gsub("%s+", "")
    }
}

function DMW.InitSettings()
    DMW.Settings = LibStub("AceDB-3.0"):New("DMWSettings", defaults, "Default")
    DMW.Settings:SetProfile(DMW.Settings.char.SelectedProfile)
    DMW.Settings.RegisterCallback(DMW, "OnProfileChanged", "OnProfileChanged")
end

function DMW:OnProfileChanged(self, db, profile)
    DMW.Settings.char.SelectedProfile = profile
    ReloadUI()
end