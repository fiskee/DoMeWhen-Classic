local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local DMW = DMW
local UI = DMW.UI
local RotationOrder = 1

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
                            UI.MinimapIcon:Show("MinimapIcon")
                        else
                            UI.MinimapIcon:Hide("MinimapIcon")
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
                        return IsHackEnabled(Hacks.AntiAfk)
                    end,
                    set = function(info, value)
                        SetHackEnabled(Hacks.AntiAfk, value)
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
                QuestieHelper = {
                    type = "toggle",
                    order = 8,
                    name = "Questie Helper",
                    desc = "Mark quest mobs using data from Questie addon",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.QuestieHelper
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.QuestieHelper = value
                    end
                },
                Herbs = {
                    type = "toggle",
                    order = 9,
                    name = "Track Herbs",
                    desc = "Mark herbs in the world",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.Herbs
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.Herbs = value
                    end
                },
                Ore = {
                    type = "toggle",
                    order = 10,
                    name = "Track Ore",
                    desc = "Mark ore in the world",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.Ore
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.Ore = value
                    end
                },
                Trackable = {
                    type = "toggle",
                    order = 11,
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
                LineToNodes = {
                    type = "toggle",
                    order = 12,
                    name = "Show Lines To Nodes",
                    desc = "Draw a line from player to herbs/ore",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.LineToNodes
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.LineToNodes = value
                    end
                },
                TrackUnits = {
                    type = "input",
                    order = 13,
                    name = "Track Units By Name",
                    desc = "Mark units by name or part of name, seperated by comma",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.Helpers.TrackUnits
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Helpers.TrackUnits = value
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
                    name = "Interrupt %",
                    desc = "Set desired % for interrupting enemy casts",
                    width = "full",
                    min = 0,
                    max = 100,
                    step = 1,
                    get = function()
                        return DMW.Settings.profile.Enemy.InterruptPct
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Enemy.InterruptPct = value
                    end
                },
                ChannelInterrupt = {
                    type = "range",
                    order = 5,
                    name = "Channel Interrupt",
                    desc = "Set seconds to wait before interrupting enemy channels",
                    width = "full",
                    min = 0.0,
                    max = 3.0,
                    step = 0.1,
                    get = function()
                        return DMW.Settings.profile.Enemy.ChannelInterrupt
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.Enemy.ChannelInterrupt = value
                    end
                },
                InterruptTarget = {
                    type = "select",
                    order = 6,
                    name = "Interrupt Target",
                    desc = "Select desired target setting for interrupts",
                    width = "full",
                    values = {"Any", "Target", "Focus", "Mouseover"},
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
    "MinimapIcon",
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
    UI.MinimapIcon = LibStub("LibDBIcon-1.0")
    UI.MinimapIcon:Register("MinimapIcon", MinimapIcon, DMW.Settings.profile.MinimapIcon)
end

function UI.AddHeader(Text)
    local Setting = Text:gsub("%s+", "")
    Options.args.RotationTab.args[Setting .. "Header"] = {
        type = "header",
        order = RotationOrder,
        name = Text
    }
    RotationOrder = RotationOrder + 1
end

function UI.AddToggle(Name, Desc, Default)
    Options.args.RotationTab.args[Name] = {
        type = "toggle",
        order = RotationOrder,
        name = Name,
        desc = Desc,
        width = "full",
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

function UI.AddRange(Name, Desc, Min, Max, Step, Default)
    Options.args.RotationTab.args[Name] = {
        type = "range",
        order = RotationOrder,
        name = Name,
        desc = Desc,
        width = "full",
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

function UI.AddDropdown(Name, Desc, Values, Default)
    Options.args.RotationTab.args[Name] = {
        type = "select",
        order = RotationOrder,
        name = Name,
        desc = Desc,
        width = "full",
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
