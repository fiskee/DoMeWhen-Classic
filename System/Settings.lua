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

            AutoGather = false,
        },
        Tracker = {
            Herbs = false,
            Ore = false,
            CheckRank = false,
            HideGey = false,
            TrackNPC = false,
            QuestieHelper = false,
            QuestieHelperColor = {0,0,0,1},
            HerbsColor = {0,0,0,1},
            OreColor = {0,0,0,1},
            TrackUnitsColor = {0,0,0,1},
            TrackObjectsColor = {0,0,0,1},
            TrackPlayersColor = {0,0,0,1},
            TrackNPCColor = {1,0.6,0,1},
            OreAlert = 0,
            HerbsAlert = 0,
            QuestieHelperAlert = 0,
            TrackUnitsAlert = 0,
            TrackObjectsAlert = 0,
            TrackPlayersAlert = 0,
            OreLine = 0,
            HerbsLine = 0,
            QuestieHelperLine = 0,
            TrackUnitsLine = 0,
            TrackObjectsLine = 0,
            TrackPlayersLine = 0,
            TrackPlayersEnemy = false,
            TrackPlayersAny = false,
            TrackObjectsMailbox = false
        },
        Navigation = {
            WorldMapHook = false
        }
    },
    char = {
        SelectedProfile = select(2, UnitClass("player")):gsub("%s+", "")
    }
}

local function MigrateSettings()
    local Reload = false
    for k,v in pairs(DMW.Settings.profile.Tracker) do
        if string.match(k, "Alert") and type(v) == "string" then
            if tonumber(v) then
                DMW.Settings.profile.Tracker[k] = tonumber(v)
            else
                DMW.Settings.profile.Tracker[k] = 0
            end
            Reload = true
        end
    end

    if type(DMW.Settings.profile.Helpers.TrackPlayers) == "boolean" then
        DMW.Settings.profile.Helpers.TrackPlayers = nil
        Reload = true
    end
    for k,v in pairs(DMW.Settings.profile.Helpers) do
        local moveNew = true
        if k == "AutoGather" or k == "AutoLoot" or k == "AutoSkinning" then
            moveNew = false
        end
        if moveNew then
            DMW.Settings.profile.Tracker[k] = v
            DMW.Settings.profile.Helpers[k] = nil 
            Reload = true
        end
    end
    if Reload then
        ReloadUI()
    end
end

function DMW.InitSettings()
    DMW.Settings = LibStub("AceDB-3.0"):New("DMWSettings", defaults, "Default")
    DMW.Settings:SetProfile(DMW.Settings.char.SelectedProfile)
    DMW.Settings.RegisterCallback(DMW, "OnProfileChanged", "OnProfileChanged")
    MigrateSettings()
end

function DMW:OnProfileChanged(self, db, profile)
    DMW.Settings.char.SelectedProfile = profile
    ReloadUI()
end