local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local DMW = DMW
local UI = DMW.UI
local RotationOrder = 1

local TrackingOptionsTable = {
    name = "Tracking",
    handler = Track123,
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
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Helpers.QuestieHelper
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.QuestieHelper = value
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
                        return DMW.Settings.profile.Helpers.QuestieHelperLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.QuestieHelperLine = value
                    end
                },
                QuestieHelperAlert = {
                    type = "input",
                    order = 3,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Helpers.QuestieHelperAlert
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.QuestieHelperAlert = value
                    end
                },
                QuestieHelperColor = {
                    type = "color",
                    order = 4,
                    name = "",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Helpers.QuestieHelperColor[1],DMW.Settings.profile.Helpers.QuestieHelperColor[2],DMW.Settings.profile.Helpers.QuestieHelperColor[3],DMW.Settings.profile.Helpers.QuestieHelperColor[4]
                    end,
                    set = function(info, r,g,b,a)
                        DMW.Settings.profile.Helpers.QuestieHelperColor = {r,g,b,a}
                    end
                },
                Herbs = {
                    type = "toggle",
                    order = 5,
                    name = "Herbs",
                    desc = "Mark herbs in the world",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Helpers.Herbs
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.Herbs = value
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
                        return DMW.Settings.profile.Helpers.HerbsLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.HerbsLine = value
                    end
                },
                HerbsAlert = {
                    type = "input",
                    order = 7,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Helpers.HerbsAlert
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.HerbsAlert = value
                    end
                },
                HerbsColor = {
                    type = "color",
                    order = 8,
                    name = "",
                    desc = "",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Helpers.HerbsColor[1],DMW.Settings.profile.Helpers.HerbsColor[2],DMW.Settings.profile.Helpers.HerbsColor[3],DMW.Settings.profile.Helpers.HerbsColor[4]
                    end,
                    set = function(info, r,g,b,a)
                        DMW.Settings.profile.Helpers.HerbsColor = {r,g,b,a}
                    end
                },
                Ore = {
                    type = "toggle",
                    order = 9,
                    name = "Ores",
                    desc = "Mark ores in the world",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Helpers.Ore
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.Ore = value
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
                        return DMW.Settings.profile.Helpers.OreLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.OreLine = value
                    end
                },
                OreAlert = {
                    type = "input",
                    order = 11,
                    name = "Sound",
                    desc = "",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Helpers.OreAlert
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.OreAlert = value
                    end
                },
                OreColor = {
                    type = "color",
                    order = 12,
                    name = "",
                    desc = "",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Helpers.OreColor[1],DMW.Settings.profile.Helpers.OreColor[2],DMW.Settings.profile.Helpers.OreColor[3],DMW.Settings.profile.Helpers.OreColor[4]
                    end,
                    set = function(info, r,g,b,a)
                        DMW.Settings.profile.Helpers.OreColor = {r,g,b,a}
                    end
                },
                Trackable = {
                    type = "toggle",
                    order = 13,
                    name = "Track Special Objects",
                    desc = "Mark special objects in the world (chests, containers ect.)",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.Trackable
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.Trackable = value
                    end
                },
                TrackNPC = {
                    type = "toggle",
                    order = 14,
                    name = "Track NPCs",
                    desc = "Track important NPCs",
                    width = 0.5,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackNPC
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackNPC = value
                    end
                },
                TrackNPCColor = {
                    type = "color",
                    order = 15,
                    name = "",
                    desc = "",
                    width = 0.5,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackNPCColor[1],DMW.Settings.profile.Helpers.TrackNPCColor[2],DMW.Settings.profile.Helpers.TrackNPCColor[3],DMW.Settings.profile.Helpers.TrackNPCColor[4]
                    end,
                    set = function(info, r,g,b,a)
                        DMW.Settings.profile.Helpers.TrackNPCColor = {r,g,b,a}
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
                    desc = "Mark units by name or part of name, seperated by comma",
                    width = "full",
                    multiline = true ,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackUnits
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackUnits = value
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
                        return DMW.Settings.profile.Helpers.TrackUnitsLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackUnitsLine = value
                    end
                },
                TrackUnitsAlert = {
                    type = "input",
                    order = 3,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackUnitsAlert
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackUnitsAlert = value
                    end
                },
                TrackUnitsColor = {
                    type = "color",
                    order = 4,
                    name = "",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackUnitsColor[1],DMW.Settings.profile.Helpers.TrackUnitsColor[2],DMW.Settings.profile.Helpers.TrackUnitsColor[3],DMW.Settings.profile.Helpers.TrackUnitsColor[4]
                    end,
                    set = function(info, r,g,b,a)
                        DMW.Settings.profile.Helpers.TrackUnitsColor = {r,g,b,a}
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
                    desc = "Mark objects by name or part of name, seperated by comma",
                    width = "full",
                    multiline = true ,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackObjects
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackObjects = value
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
                        return DMW.Settings.profile.Helpers.TrackObjectsLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackObjectsLine = value
                    end
                },
                TrackObjectsAlert = {
                    type = "input",
                    order = 3,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackObjectsAlert
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackObjectsAlert = value
                    end
                },
                TrackObjectsColor = {
                    type = "color",
                    order = 4,
                    name = "",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackObjectsColor[1],DMW.Settings.profile.Helpers.TrackObjectsColor[2],DMW.Settings.profile.Helpers.TrackObjectsColor[3],DMW.Settings.profile.Helpers.TrackObjectsColor[4]
                    end,
                    set = function(info, r,g,b,a)
                        DMW.Settings.profile.Helpers.TrackObjectsColor = {r,g,b,a}
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
                    desc = "Mark Players by name or part of name, seperated by comma, to track all players put in a space",
                    width = "full",
                    multiline = true ,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackPlayers
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackPlayers = value
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
                        return DMW.Settings.profile.Helpers.TrackPlayersLine
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackPlayersLine = value
                    end
                },
                TrackPlayersAlert = {
                    type = "input",
                    order = 3,
                    name = "Alert",
                    desc = "Sound for Alert, 416 = Murlocs",
                    width = 0.4,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackPlayersAlert
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackPlayersAlert = value
                    end
                },
                TrackPlayersColor = {
                    type = "color",
                    order = 4,
                    name = "",
                    desc = "Color",
                    width = 0.4,
                    hasAlpha = true,
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackPlayersColor[1],DMW.Settings.profile.Helpers.TrackPlayersColor[2],DMW.Settings.profile.Helpers.TrackPlayersColor[3],DMW.Settings.profile.Helpers.TrackPlayersColor[4]
                    end,
                    set = function(info, r,g,b,a)
                        DMW.Settings.profile.Helpers.TrackPlayersColor = {r,g,b,a}
                    end
                },
                TrackPlayersNameplates = {
                    type = "toggle",
                    order = 5,
                    name = "Track Enemy Players Nameplates",
                    desc = "Track enemy players outside nameplate range",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackPlayersNamePlates
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackPlayersNamePlates = value
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
            args = {}
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
                    order = 9,
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
                    order = 19,
                    name = "Advanced Tracking",
                    desc = "Track options",
                    width = "full",
                    func = function() 
                        if not TrackingFrame:IsShown() then
                            LibStub("AceConfigDialog-3.0"):Open("Track123", TrackingFrame)
                        else
                            TrackingFrame:Hide()
                        end
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

function UI.Init()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("DMW", Options)
    LibStub("AceConfigDialog-3.0"):SetDefaultSize("DMW", 400, 750)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Track123", TrackingOptionsTable)
    LibStub("AceConfigDialog-3.0"):SetDefaultSize("Track123", 400, 350)
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
        Options.args.RotationTab.args["Blank" .. RotationOrder] = {
            type = "description",
            order = RotationOrder,
            name = " ",
            width = "full"
        }
        RotationOrder = RotationOrder + 1
    end
    local Setting = Text:gsub("%s+", "")
    Options.args.RotationTab.args[Setting .. "Header"] = {
        type = "header",
        order = RotationOrder,
        name = Text
    }
    RotationOrder = RotationOrder + 1
end

function UI.AddToggle(Name, Desc, Default, FullWidth)
    local Width = FullWidth and "full" or 0.9
    Options.args.RotationTab.args[Name] = {
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
    Options.args.RotationTab.args[Name] = {
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
    Options.args.RotationTab.args[Name] = {
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
    Options.args.RotationTab.args["Blank" .. RotationOrder] = {
        type = "description",
        order = RotationOrder,
        name = " ",
        width = Width
    }
    RotationOrder = RotationOrder + 1
end

function UI.InitQueue()
    for k, v in pairs(DMW.Player.Spells) do
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
