local DMW = DMW
DMW.UI.Debug = {}
local Debug = DMW.UI.Debug
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
Debug.Frame = AceGUI:Create("Window")
local Frame = Debug.Frame

local function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

Frame:SetTitle("DMW Debug")
Frame:SetWidth(300)
Frame:Hide()

--General
local Label = AceGUI:Create("Heading")
Label:SetFullWidth(true)
Label:SetText("General:")
Frame:AddChild(Label)
--Units
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    local Count = 0
    for k, v in pairs(DMW.Units) do
        Count = Count + 1
    end
    self:SetText("Unit Table Count: " .. Count)
end
Frame:AddChild(Label)
--Attackable
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Attackable Unit Table Count: " .. #DMW.Attackable)
end
Frame:AddChild(Label)
--Enemies
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Enemy Table Count: " .. #DMW.Enemies)
end
Frame:AddChild(Label)
--Friends
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Friends Table Count: " .. #DMW.Friends.Units)
end
Frame:AddChild(Label)

--Timers
local Label = AceGUI:Create("Heading")
Label:SetFullWidth(true)
Label:SetText("Timers: (MS)")
Frame:AddChild(Label)
--OM
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Object Manager - Average: " .. round(DMW.Timers.OM.Average, 3) .. " - Last: " .. round(DMW.Timers.OM.Last, 3))
end
Frame:AddChild(Label)
--Questie Helper
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Questie Helper - Average: " .. round(DMW.Timers.QuestieHelper.Average, 3) .. " - Last: " .. round(DMW.Timers.QuestieHelper.Last, 3))
end
Frame:AddChild(Label)
--Trackers
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Trackers - Average: " .. round(DMW.Timers.Trackers.Average, 3) .. " - Last: " .. round(DMW.Timers.Trackers.Last, 3))
end
Frame:AddChild(Label)
--Gatherers
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Gatherers - Average: " .. round(DMW.Timers.Gatherers.Average, 3) .. " - Last: " .. round(DMW.Timers.Gatherers.Last, 3))
end
Frame:AddChild(Label)
--Rotation
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Timers.Rotation.Average then
        self:SetText("Rotation (Combat) - Average: " .. round(DMW.Timers.Rotation.Average, 3) .. " - Last: " .. round(DMW.Timers.Rotation.Last, 3))
    end
end
Frame:AddChild(Label)

--Player
Label = AceGUI:Create("Heading")
Label:SetFullWidth(true)
Label:SetText("Player:")
Frame:AddChild(Label)
--Position
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Position: " .. round(DMW.Player.PosX, 2) .. " - " .. round(DMW.Player.PosY, 2) .. " - " .. round(DMW.Player.PosZ, 2))
end
Frame:AddChild(Label)
--Facing
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Facing: " .. round(ObjectFacing("player"), 2))
end
Frame:AddChild(Label)
--Unit Flags
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Unit Flags: " .. string.format("%X", ObjectDescriptor(DMW.Player.Pointer, GetOffset("CGUnitData__Flags"), "int")) .. " - Unit Flags2: " .. string.format("%X", ObjectDescriptor(DMW.Player.Pointer, GetOffset("CGUnitData__Flags2"), "int")) .. " - Unit Flags3: " .. string.format("%X", ObjectDescriptor(DMW.Player.Pointer, GetOffset("CGUnitData__Flags3"), "int")))
end
Frame:AddChild(Label)

--Target
Label = AceGUI:Create("Heading")
Label:SetFullWidth(true)
Label:SetText("Target:")
Frame:AddChild(Label)
--Name
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Name: " .. DMW.Player.Target.Name)
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--GUID
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("GUID: " .. DMW.Player.Target.GUID)
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--Pointer
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Pointer: " .. DMW.Player.Target.Pointer)
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--Position
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Position: " .. round(DMW.Player.Target.PosX, 2) .. " - " .. round(DMW.Player.Target.PosY, 2) .. " - " .. round(DMW.Player.Target.PosZ, 2))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--Distance
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Distance: " .. round(DMW.Player.Target.Distance, 2) .. " - Raw Distance: " .. round(DMW.Player.Target:RawDistance(), 2))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--Facing
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Facing: " .. round(ObjectFacing(DMW.Player.Target.Pointer), 2))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--Unit Flags
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Unit Flags: " .. string.format("%X", ObjectDescriptor(DMW.Player.Target.Pointer, GetOffset("CGUnitData__Flags"), "int")) .. " - Unit Flags2: " .. string.format("%X", ObjectDescriptor(DMW.Player.Target.Pointer, GetOffset("CGUnitData__Flags2"), "int")) .. " - Unit Flags3: " .. string.format("%X", ObjectDescriptor(DMW.Player.Target.Pointer, GetOffset("CGUnitData__Flags3"), "int")) .. " - NPC Flags: " .. string.format("%X", ObjectDescriptor(DMW.Player.Target.Pointer, GetOffset("CGUnitData__NPCFlags"), "int")))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--TTD
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Time To Die: " .. DMW.Player.Target.TTD)
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--LoS
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Line of Sight: " .. tostring(DMW.Player.Target.LoS))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--Attackable
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Attackable: " .. tostring(DMW.Player.Target.Attackable))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--ValidEnemy
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Target then
        self:SetText("Valid Enemy: " .. tostring(DMW.Player.Target.ValidEnemy))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)

function Debug.Run()
    if Frame:IsShown() then
        for k, v in pairs(Frame.children) do
            if v.Update then
                v:Update()
            end
        end
    end
end
