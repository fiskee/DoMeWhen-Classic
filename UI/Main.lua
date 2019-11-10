local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local DMW = DMW
local UI = DMW.UI
local RotationOrder = 1
local TrackingFrame, TrackerConfig
local base64 = LibStub("LibBase64-1.0")
local serializer = LibStub("AceSerializer-3.0")
local CurrentTab = "GeneralTab"
local TabIndex = 2

local exportTypes = {
    ["rotation"] = "Rotation",
    ["tracker"] = "Tracker",
    ["queue"] = "Queue"
}

local exportTypesOrder = {
    "rotation",
    "tracker",
    "queue"
}

local exportString = ""
local function export(value)
    local Frame = AceGUI:Create("Frame")
    Frame:SetTitle("Import/Export")
    Frame:SetWidth(400)
    Frame:SetHeight(350)
    Frame.frame:SetFrameStrata("FULLSCREEN_DIALOG")
    Frame:SetLayout("Flow")

    local Box = AceGUI:Create("MultiLineEditBox")
    Box:SetNumLines(15)
    Box:DisableButton(true)
    Box:SetWidth(600)
    Box:SetLabel("")
    Frame:AddChild(Box)

    local ProfileTypeDropdown = AceGUI:Create("Dropdown")
    ProfileTypeDropdown:SetMultiselect(false)
    ProfileTypeDropdown:SetLabel("Settings To Export")
    ProfileTypeDropdown:SetList(exportTypes, exportTypesOrder)
    ProfileTypeDropdown:SetValue("rotation")
    Frame:AddChild(ProfileTypeDropdown)
    ProfileTypeDropdown:SetRelativeWidth(0.5)

    if value == "export" then
        -- ProfileTypeDropdown:SetCallback("OnValueChanged", function(self)
        --     exportButton:SetText("Export "..exportTypes[ProfileTypeDropdown:GetValue()])
        --     end
        -- )
        Frame:SetTitle("Export")
        local exportButton = AceGUI:Create("Button")
        exportButton:SetText("Export")
        local function OnClick(self)
            if ProfileTypeDropdown:GetValue() == "rotation" then
                Box:SetText(base64:encode(serializer:Serialize(DMW.Settings.profile.Rotation)))
            elseif ProfileTypeDropdown:GetValue() == "tracker" then
                Box:SetText(base64:encode(serializer:Serialize(DMW.Settings.profile.Tracker)))
            elseif ProfileTypeDropdown:GetValue() == "queue" then
                Box:SetText(base64:encode(serializer:Serialize(DMW.Settings.profile.Queue)))
            end
            Box.editBox:HighlightText()
            Box:SetFocus()
        end
        exportButton:SetCallback("OnClick", OnClick)
        Frame:AddChild(exportButton)
        exportButton:SetRelativeWidth(0.5)
    elseif value == "import" then
        Frame:SetTitle("Import")
        local importButton = AceGUI:Create("Button")
        importButton:SetText("Import")
        importButton:SetRelativeWidth(0.5)
        local function OnClick(self)
            if type(Box:GetText()) == "string" then
                local check, value = serializer:Deserialize(base64:decode(Box:GetText()))
                if check then
                    if ProfileTypeDropdown:GetValue() == "rotation" then
                        DMW.Settings.profile.Rotation = value
                    elseif ProfileTypeDropdown:GetValue() == "tracker" then
                        DMW.Settings.profile.Tracker = value
                    elseif ProfileTypeDropdown:GetValue() == "queue" then
                        DMW.Settings.profile.Queue = value
                    end
                    Box:SetText("Import Successful")
                else
                    Box:SetText(value)
                end
            end
        end
        importButton:SetCallback("OnClick", OnClick)
        Frame:AddChild(importButton)
    end
end

local TrackingOptionsTable = {
    name = "Tracking",
    handler = TrackerConfig,
    type = "group",
    childGroups = "tab",
    args = {
        FirstTab = {
            name = "General",
            type = "group",
            order = 1,
            args = {
                -- GeneralHeader = {
                --     type = "header",
                --     order = 1,
                --     name = "General"
                -- },
                QuestieHelper = {
                    type = "toggle",
                    order = 1,
                    name = "Questie",
                    desc = "Mark quest mobs using data from Questie addon",
                    width = 0.5,
                    get = function()
                        return DMW.Settings.profile.Tracker.QuestieHelper
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.QuestieHelper = value
                    end
                },
                QuestieHelperLine = {
                    type = "range",
                    order = 2,
                    name = "Line",
                    desc = "Width of line to Unit",
                    width = 0.6,
                    min = 0,
                    max = 5,
                    step = 1,
                    get = function()
                        return DMW.Settings.profile.Tracker.QuestieHelperLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.QuestieHelperLine = value
                    end
                },
                QuestieHelperAlert = {
                    type = "input",
                    order = 3,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return tostring(DMW.Settings.profile.Tracker.QuestieHelperAlert)
                    end,
                    set = function(info, value)
                        if tonumber(value) then
                            DMW.Settings.profile.Tracker.QuestieHelperAlert = tonumber(value)
                        else
                            DMW.Settings.profile.Tracker.QuestieHelperAlert = 0
                        end
                    end
                },
                QuestieHelperColor = {
                    type = "color",
                    order = 4,
                    name = "Color",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.QuestieHelperColor[1], DMW.Settings.profile.Tracker.QuestieHelperColor[2], DMW.Settings.profile.Tracker.QuestieHelperColor[3], DMW.Settings.profile.Tracker.QuestieHelperColor[4]
                    end,
                    set = function(info, r, g, b, a)
                        DMW.Settings.profile.Tracker.QuestieHelperColor = {r, g, b, a}
                    end
                },
                Herbs = {
                    type = "toggle",
                    order = 5,
                    name = "Herbs",
                    desc = "Mark herbs in the world",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Tracker.Herbs
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.Herbs = value
                    end
                },
                HerbsLine = {
                    type = "range",
                    order = 6,
                    name = "Line",
                    desc = "Width of line to Herb",
                    width = 0.6,
                    min = 0,
                    max = 5,
                    step = 1,
                    get = function()
                        return DMW.Settings.profile.Tracker.HerbsLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.HerbsLine = value
                    end
                },
                HerbsAlert = {
                    type = "input",
                    order = 7,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return tostring(DMW.Settings.profile.Tracker.HerbsAlert)
                    end,
                    set = function(info, value)
                        if tonumber(value) then
                            DMW.Settings.profile.Tracker.HerbsAlert = tonumber(value)
                        else
                            DMW.Settings.profile.Tracker.HerbsAlert = 0
                        end
                    end
                },
                HerbsColor = {
                    type = "color",
                    order = 8,
                    name = "Color",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.HerbsColor[1], DMW.Settings.profile.Tracker.HerbsColor[2], DMW.Settings.profile.Tracker.HerbsColor[3], DMW.Settings.profile.Tracker.HerbsColor[4]
                    end,
                    set = function(info, r, g, b, a)
                        DMW.Settings.profile.Tracker.HerbsColor = {r, g, b, a}
                    end
                },
                Ore = {
                    type = "toggle",
                    order = 9,
                    name = "Ores",
                    desc = "Mark ores in the world",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Tracker.Ore
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.Ore = value
                    end
                },
                OreLine = {
                    type = "range",
                    order = 10,
                    name = "Line Width",
                    desc = "Width of line to Ore",
                    width = 0.6,
                    min = 0,
                    max = 5,
                    step = 1,
                    get = function()
                        return DMW.Settings.profile.Tracker.OreLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.OreLine = value
                    end
                },
                OreAlert = {
                    type = "input",
                    order = 11,
                    name = "Sound",
                    desc = "",
                    width = 0.4,
                    get = function()
                        return tostring(DMW.Settings.profile.Tracker.OreAlert)
                    end,
                    set = function(info, value)
                        if tonumber(value) then
                            DMW.Settings.profile.Tracker.OreAlert = tonumber(value)
                        else
                            DMW.Settings.profile.Tracker.OreAlert = 0
                        end
                    end
                },
                OreColor = {
                    type = "color",
                    order = 12,
                    name = "Color",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.OreColor[1], DMW.Settings.profile.Tracker.OreColor[2], DMW.Settings.profile.Tracker.OreColor[3], DMW.Settings.profile.Tracker.OreColor[4]
                    end,
                    set = function(info, r, g, b, a)
                        DMW.Settings.profile.Tracker.OreColor = {r, g, b, a}
                    end
                },
                CheckLevel = {
                    type = "toggle",
                    order = 13,
                    name = "Check Skill Rank",
                    desc = "Check if you have high enough rank before tracking herbs/ore. Only english client support",
                    width = 0.9,
                    get = function()
                        return DMW.Settings.profile.Tracker.CheckRank
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.CheckRank = value
                    end
                },
                HideGrey = {
                    type = "toggle",
                    order = 14,
                    name = "Hide Grey",
                    desc = "Hide grey herbs/ore. Only english client support",
                    width = 0.9,
                    get = function()
                        return DMW.Settings.profile.Tracker.HideGrey
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.HideGrey = value
                    end
                },
                Trackable = {
                    type = "toggle",
                    order = 15,
                    name = "Track Special Objects",
                    desc = "Mark special objects in the world (chests, containers ect.)",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Tracker.Trackable
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.Trackable = value
                    end
                },
                TrackNPC = {
                    type = "toggle",
                    order = 16,
                    name = "Track NPCs",
                    desc = "Track important NPCs",
                    width = 0.7,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackNPC
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.TrackNPC = value
                    end
                },
                TrackNPCColor = {
                    type = "color",
                    order = 17,
                    name = "Color",
                    desc = "Color",
                    width = 0.5,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackNPCColor[1], DMW.Settings.profile.Tracker.TrackNPCColor[2], DMW.Settings.profile.Tracker.TrackNPCColor[3], DMW.Settings.profile.Tracker.TrackNPCColor[4]
                    end,
                    set = function(info, r, g, b, a)
                        DMW.Settings.profile.Tracker.TrackNPCColor = {r, g, b, a}
                    end
                }
            }
        },
        SecondTab = {
            name = "Units",
            type = "group",
            order = 2,
            args = {
                TrackUnits = {
                    type = "input",
                    order = 1,
                    name = "Track Units By Name",
                    desc = "Mark units by name or part of name, separated by comma",
                    width = "full",
                    multiline = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackUnits
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.TrackUnits = value
                    end
                },
                TrackUnitsLine = {
                    type = "range",
                    order = 2,
                    name = "Line",
                    desc = "Width of line to Unit",
                    width = 0.6,
                    min = 0,
                    max = 5,
                    step = 1,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackUnitsLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.TrackUnitsLine = value
                    end
                },
                TrackUnitsAlert = {
                    type = "input",
                    order = 3,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return tostring(DMW.Settings.profile.Tracker.TrackUnitsAlert)
                    end,
                    set = function(info, value)
                        if tonumber(value) then
                            DMW.Settings.profile.Tracker.TrackUnitsAlert = tonumber(value)
                        else
                            DMW.Settings.profile.Tracker.TrackUnitsAlert = 0
                        end
                    end
                },
                TrackUnitsColor = {
                    type = "color",
                    order = 4,
                    name = "Color",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackUnitsColor[1], DMW.Settings.profile.Tracker.TrackUnitsColor[2], DMW.Settings.profile.Tracker.TrackUnitsColor[3], DMW.Settings.profile.Tracker.TrackUnitsColor[4]
                    end,
                    set = function(info, r, g, b, a)
                        DMW.Settings.profile.Tracker.TrackUnitsColor = {r, g, b, a}
                    end
                }
            }
        },
        ThirdTab = {
            name = "Objects",
            type = "group",
            order = 3,
            args = {
                TrackObjects = {
                    type = "input",
                    order = 1,
                    name = "Track Objects By Name",
                    desc = "Mark objects by name or part of name, separated by comma",
                    width = "full",
                    multiline = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackObjects
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.TrackObjects = value
                    end
                },
                TrackObjectsLine = {
                    type = "range",
                    order = 2,
                    name = "Line",
                    desc = "Width of line to Object",
                    width = 0.6,
                    min = 0,
                    max = 5,
                    step = 1,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackObjectsLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.TrackObjectsLine = value
                    end
                },
                TrackObjectsAlert = {
                    type = "input",
                    order = 3,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return tostring(DMW.Settings.profile.Tracker.TrackObjectsAlert)
                    end,
                    set = function(info, value)
                        if tonumber(value) then
                            DMW.Settings.profile.Tracker.TrackObjectsAlert = tonumber(value)
                        else
                            DMW.Settings.profile.Tracker.TrackObjectsAlert = 0
                        end
                    end
                },
                TrackObjectsColor = {
                    type = "color",
                    order = 4,
                    name = "Color",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackObjectsColor[1], DMW.Settings.profile.Tracker.TrackObjectsColor[2], DMW.Settings.profile.Tracker.TrackObjectsColor[3], DMW.Settings.profile.Tracker.TrackObjectsColor[4]
                    end,
                    set = function(info, r, g, b, a)
                        DMW.Settings.profile.Tracker.TrackObjectsColor = {r, g, b, a}
                    end
                },
                TrackObjectsMailbox = {
                    type = "toggle",
                    order = 5,
                    name = "Track Mailbox",
                    -- desc = "Track important NPCs",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackObjectsMailbox
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.TrackObjectsMailbox = value
                    end
                }
            }
        },
        FourthTab = {
            name = "Players",
            type = "group",
            order = 4,
            args = {
                TrackPlayers = {
                    type = "input",
                    order = 1,
                    name = "Track Players By Name",
                    desc = "Mark Players by name or part of name, separated by comma",
                    width = "full",
                    multiline = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackPlayers
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.TrackPlayers = value
                    end
                },
                TrackPlayersLine = {
                    type = "range",
                    order = 2,
                    name = "Line",
                    desc = "Width of line to Player",
                    width = 0.6,
                    min = 0,
                    max = 5,
                    step = 1,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackPlayersLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.TrackPlayersLine = value
                    end
                },
                TrackPlayersAlert = {
                    type = "input",
                    order = 3,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return tostring(DMW.Settings.profile.Tracker.TrackPlayersAlert)
                    end,
                    set = function(info, value)
                        if tonumber(value) then
                            DMW.Settings.profile.Tracker.TrackPlayersAlert = tonumber(value)
                        else
                            DMW.Settings.profile.Tracker.TrackPlayersAlert = 0
                        end
                    end
                },
                TrackPlayersColor = {
                    type = "color",
                    order = 4,
                    name = "Color",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackPlayersColor[1], DMW.Settings.profile.Tracker.TrackPlayersColor[2], DMW.Settings.profile.Tracker.TrackPlayersColor[3], DMW.Settings.profile.Tracker.TrackPlayersColor[4]
                    end,
                    set = function(info, r, g, b, a)
                        DMW.Settings.profile.Tracker.TrackPlayersColor = {r, g, b, a}
                    end
                },
                Trackshit = {
                    type = "execute",
                    order = 5,
                    name = "Track Targeted Player",
                    desc = "Add targeted player name to list",
                    width = "full",
                    func = function()
                        if DMW.Player.Target and DMW.Player.Target.Player then
                            for k in string.gmatch(DMW.Settings.profile.Tracker.TrackPlayers, "([^,]+)") do
                                if strmatch(string.lower(DMW.Player.Target.Name), string.lower(string.trim(k))) then
                                    return
                                end
                            end
                            if DMW.Settings.profile.Tracker.TrackPlayers == nil or DMW.Settings.profile.Tracker.TrackPlayers == "" then
                                DMW.Settings.profile.Tracker.TrackPlayers = DMW.Player.Target.Name
                            else
                                DMW.Settings.profile.Tracker.TrackPlayers = DMW.Settings.profile.Tracker.TrackPlayers .. "," .. DMW.Player.Target.Name
                            end
                        end
                    end
                },
                TrackPlayersAny = {
                    type = "toggle",
                    order = 6,
                    name = "Track All Players",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackPlayersAny
                    end,
                    set = function(info, value)
                        if value and DMW.Settings.profile.Tracker.TrackPlayersEnemy then
                            DMW.Settings.profile.Tracker.TrackPlayersEnemy = false
                        end
                        DMW.Settings.profile.Tracker.TrackPlayersAny = value
                    end
                },
                TrackPlayersEnemy = {
                    type = "toggle",
                    order = 7,
                    name = "Track All Enemy Players",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackPlayersEnemy
                    end,
                    set = function(info, value)
                        if value and DMW.Settings.profile.Tracker.TrackPlayersAny then
                            DMW.Settings.profile.Tracker.TrackPlayersAny = false
                        end
                        DMW.Settings.profile.Tracker.TrackPlayersEnemy = value
                    end
                },
                TrackPlayersNameplates = {
                    type = "toggle",
                    order = 8,
                    name = "Track Enemy Players Nameplates",
                    desc = "Track enemy players outside nameplate range",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Tracker.TrackPlayersNamePlates
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Tracker.TrackPlayersNamePlates = value
                    end
                }
            }
        }
    }
}

local Options = {
    name = "DoMeWhen",
    handler = DMW,
    type = "group",
    childGroups = "tab",
    args = {
        RotationTab = {
            name = "Rotation",
            type = "group",
            order = 1,
            args = {
                GeneralTab = {
                    name = "General",
                    type = "group",
                    order = 1,
                    args = {}
                }
            }
        },
        GeneralTab = {
            name = "General",
            type = "group",
            order = 2,
            args = {
                GeneralHeader = {
                    type = "header",
                    order = 1,
                    name = "General"
                },
                HUDEnabled = {
                    type = "toggle",
                    order = 2,
                    name = "Show HUD",
                    desc = "Toggle to show/hide the HUD",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.HUD.Show
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.HUD.Show = value
                        if value then
                            DMW.UI.HUD.Frame:Show()
                        else
                            DMW.UI.HUD.Frame:Hide()
                        end
                    end
                },
                MMIconEnabled = {
                    type = "toggle",
                    order = 3,
                    name = "Show Minimap Icon",
                    desc = "Toggle to show/hide the minimap icon",
                    width = "full",
                    get = function()
                        return not DMW.Settings.profile.MinimapIcon.hide
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.MinimapIcon.hide = not value
                        if value then
                            UI.MinimapIcon:Show("DMWMinimapIcon")
                        else
                            UI.MinimapIcon:Hide("DMWMinimapIcon")
                        end
                    end
                },
                HelpersHeader = {
                    type = "header",
                    order = 4,
                    name = "Helpers"
                },
                AntiAfk = {
                    type = "toggle",
                    order = 5,
                    name = "Anti Afk",
                    desc = "Enable/Disable EWT Anti Afk",
                    width = "full",
                    get = function()
                        return IsHackEnabled("antiafk")
                    end,
                    set = function(info, value)
                        SetHackEnabled("antiafk", value)
                    end
                },
                AutoLoot = {
                    type = "toggle",
                    order = 6,
                    name = "Auto Loot",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.AutoLoot
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.AutoLoot = value
                    end
                },
                AutoSkinning = {
                    type = "toggle",
                    order = 7,
                    name = "Auto Skinning",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.AutoSkinning
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.AutoSkinning = value
                    end
                },
                AutoGather = {
                    type = "toggle",
                    order = 8,
                    name = "Auto Gather",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.AutoGather
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.AutoGather = value
                    end
                },
                Trackshit = {
                    type = "execute",
                    order = 9,
                    name = "Advanced Tracking",
                    desc = "Track options",
                    width = "full",
                    func = function()
                        if not TrackingFrame:IsShown() then
                            LibStub("AceConfigDialog-3.0"):Open("TrackerConfig", TrackingFrame)
                        else
                            TrackingFrame:Hide()
                        end
                    end
                },
                exportProfile = {
                    type = "execute",
                    name = "Export Settings",
                    width = 1,
                    order = 10,
                    func = function()
                        export("export")
                    end
                },
                importProfile = {
                    type = "execute",
                    name = "Import Settings",
                    width = 1,
                    order = 11,
                    func = function()
                        export("import")
                    end
                }
            }
        },
        EnemyTab = {
            name = "Enemy",
            type = "group",
            order = 3,
            args = {
                GeneralHeader = {
                    type = "header",
                    order = 1,
                    name = "General"
                },
                AutoFacing = {
                    type = "toggle",
                    order = 2,
                    name = "Auto Facing",
                    desc = "Will auto face instant cast spells on target",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Enemy.AutoFace
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Enemy.AutoFace = value
                    end
                },
                InterruptHeader = {
                    type = "header",
                    order = 3,
                    name = "Interrupts"
                },
                InterruptPct = {
                    type = "range",
                    order = 4,
                    name = "Interrupt Delay",
                    desc = "Set desired delay in sec for interrupting enemy casts, will randomize around value",
                    width = "full",
                    min = 0,
                    max = 2,
                    step = 0.1,
                    get = function()
                        return DMW.Settings.profile.Enemy.InterruptDelay
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Enemy.InterruptDelay = value
                    end
                },
                InterruptTarget = {
                    type = "select",
                    order = 6,
                    name = "Interrupt Target",
                    desc = "Select desired target setting for interrupts",
                    width = "full",
                    values = {"Any", "Target"},
                    style = "dropdown",
                    get = function()
                        return DMW.Settings.profile.Enemy.InterruptTarget
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Enemy.InterruptTarget = value
                    end
                }
            }
        },
        FriendTab = {
            name = "Friend",
            type = "group",
            order = 4,
            args = {
                DispelDelay = {
                    type = "range",
                    order = 1,
                    name = "Dispel Delay",
                    desc = "Set seconds to wait before casting dispel",
                    width = "full",
                    min = 0.0,
                    max = 3.0,
                    step = 0.1,
                    get = function()
                        return DMW.Settings.profile.Friend.DispelDelay
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Friend.DispelDelay = value
                    end
                }
            }
        },
        QueueTab = {
            name = "Queue",
            type = "group",
            order = 5,
            args = {
                QueueTime = {
                    type = "range",
                    order = 1,
                    name = "Queue Time",
                    desc = "Set maximum seconds to attempt casting queued spell",
                    width = "full",
                    min = 0,
                    max = 5,
                    step = 0.5,
                    get = function()
                        return DMW.Settings.profile.Queue.Wait
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Queue.Wait = value
                    end
                },
                QueueItems = {
                    type = "toggle",
                    order = 2,
                    name = "Items",
                    desc = "Enable item queue",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Queue.Items
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Queue.Items = value
                    end
                }
            }
        }
    }
}
local MinimapIcon =
    LibStub("LibDataBroker-1.1"):NewDataObject(
    "DMWMinimapIcon",
    {
        type = "data source",
        text = "DMW",
        icon = "Interface\\Icons\\Ability_Rogue_Ambush",
        OnClick = function(self, button)
            if button == "LeftButton" then
                UI.Show()
            elseif button == "RightButton" then
                UI.ShowTracking()
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("DoMeWhen", 1, 1, 1)
        end
    }
)

function UI.Show()
    if not UI.ConfigFrame then
        UI.ConfigFrame = AceGUI:Create("Frame")
        UI.ConfigFrame:Hide()
        _G["DMWConfigFrame"] = UI.ConfigFrame.frame
        table.insert(UISpecialFrames, "DMWConfigFrame")
    end
    if not UI.ConfigFrame:IsShown() then
        LibStub("AceConfigDialog-3.0"):Open("DMW", UI.ConfigFrame)
    else
        UI.ConfigFrame:Hide()
    end
end

function UI.ShowTracking()
    if not TrackingFrame:IsShown() then
        LibStub("AceConfigDialog-3.0"):Open("TrackerConfig", TrackingFrame)
    else
        TrackingFrame:Hide()
    end
end

function UI.Init()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("DMW", Options)
    LibStub("AceConfigDialog-3.0"):SetDefaultSize("DMW", 580, 750)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("TrackerConfig", TrackingOptionsTable)
    LibStub("AceConfigDialog-3.0"):SetDefaultSize("TrackerConfig", 400, 370)
    if not TrackingFrame then
        TrackingFrame = AceGUI:Create("Frame")
        TrackingFrame:Hide()
        _G["TrackingFrameConfig"] = TrackingFrame.frame
        table.insert(UISpecialFrames, "TrackingFrameConfig")
    end
    UI.MinimapIcon = LibStub("LibDBIcon-1.0")
    UI.MinimapIcon:Register("DMWMinimapIcon", MinimapIcon, DMW.Settings.profile.MinimapIcon)
end

function UI.AddHeader(Text)
    if RotationOrder > 1 then
        Options.args.RotationTab.args[CurrentTab].args["Blank" .. RotationOrder] = {
            type = "description",
            order = RotationOrder,
            name = " ",
            width = "full"
        }
        RotationOrder = RotationOrder + 1
    end
    local Setting = Text:gsub("%s+", "")
    Options.args.RotationTab.args[CurrentTab].args[Setting .. "Header"] = {
        type = "header",
        order = RotationOrder,
        name = Text
    }
    RotationOrder = RotationOrder + 1
end

function UI.AddToggle(Name, Desc, Default, FullWidth)
    local Width = FullWidth and "full" or 0.9
    Options.args.RotationTab.args[CurrentTab].args[Name] = {
        type = "toggle",
        order = RotationOrder,
        name = Name,
        desc = Desc,
        width = Width,
        get = function()
            return DMW.Settings.profile.Rotation[Name]
        end,
        set = function(info, value)
            DMW.Settings.profile.Rotation[Name] = value
        end
    }
    if Default and DMW.Settings.profile.Rotation[Name] == nil then
        DMW.Settings.profile.Rotation[Name] = Default
    end
    RotationOrder = RotationOrder + 1
end

function UI.AddRange(Name, Desc, Min, Max, Step, Default, FullWidth)
    local Width = FullWidth and "full" or 0.9
    Options.args.RotationTab.args[CurrentTab].args[Name] = {
        type = "range",
        order = RotationOrder,
        name = Name,
        desc = Desc,
        width = Width,
        min = Min,
        max = Max,
        step = Step,
        get = function()
            return DMW.Settings.profile.Rotation[Name]
        end,
        set = function(info, value)
            DMW.Settings.profile.Rotation[Name] = value
        end
    }
    if Default and DMW.Settings.profile.Rotation[Name] == nil then
        DMW.Settings.profile.Rotation[Name] = Default
    end
    RotationOrder = RotationOrder + 1
end

function UI.AddDropdown(Name, Desc, Values, Default, FullWidth)
    local Width = FullWidth and "full" or 0.9
    Options.args.RotationTab.args[CurrentTab].args[Name] = {
        type = "select",
        order = RotationOrder,
        name = Name,
        desc = Desc,
        width = Width,
        values = Values,
        style = "dropdown",
        get = function()
            return DMW.Settings.profile.Rotation[Name]
        end,
        set = function(info, value)
            DMW.Settings.profile.Rotation[Name] = value
        end
    }
    if Default and DMW.Settings.profile.Rotation[Name] == nil then
        DMW.Settings.profile.Rotation[Name] = Default
    end
    RotationOrder = RotationOrder + 1
end

function UI.AddBlank(FullWidth)
    local Width = FullWidth and "full" or 0.9
    Options.args.RotationTab.args[CurrentTab].args["Blank" .. RotationOrder] = {
        type = "description",
        order = RotationOrder,
        name = " ",
        width = Width
    }
    RotationOrder = RotationOrder + 1
end

function UI.AddTab(Name)
    Options.args.RotationTab.args[Name .. "Tab"] = {
        name = Name,
        type = "group",
        order = TabIndex,
        args = {}
    }
    TabIndex = TabIndex + 1
    CurrentTab = Name .. "Tab"
    RotationOrder = 1
end

function UI.InitQueue()
    for k, v in pairs(DMW.Player.Spells) do
        if v.CastType ~= "Profession" and v.CastType ~= "Toggle" then
            Options.args.QueueTab.args[k] = {
                type = "select",
                name = v.SpellName,
                --desc = Desc,
                width = "full",
                values = {"Disabled", "Normal", "Mouseover", "Cursor", "Cursor - No Cast"},
                style = "dropdown",
                get = function()
                    return DMW.Settings.profile.Queue[v.SpellName]
                end,
                set = function(info, value)
                    DMW.Settings.profile.Queue[v.SpellName] = value
                end
            }
            if DMW.Settings.profile.Queue[v.SpellName] == nil then
                DMW.Settings.profile.Queue[v.SpellName] = 1
            end
        end
    end
end
