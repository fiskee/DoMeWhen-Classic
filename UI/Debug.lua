local DMW = DMW
DMW.UI.Debug = {}
local Debug = DMW.UI.Debug
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
Debug.Frame = AceGUI:Create("Window")
local Frame = Debug.Frame

Frame:SetTitle("DMW Debug")
Frame:SetWidth(300)
Frame:Hide()

--General
local Label = AceGUI:Create("Heading")
Label:SetFullWidth(true)
Label:SetText("General:")
Frame:AddChild(Label)
--Pulses
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Pulses: " .. DMW.Pulses)
end
Frame:AddChild(Label)
--Units
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    local Count = 0
    for k,v in pairs(DMW.Units) do
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

--Player
Label = AceGUI:Create("Heading")
Label:SetFullWidth(true)
Label:SetText("Player:")
Frame:AddChild(Label)
--Position
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Position: " .. DMW.Player.PosX .. " - " .. DMW.Player.PosY .. " - " .. DMW.Player.PosZ)
end
Frame:AddChild(Label)
--Facing
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Facing: " .. ObjectFacing("player"))
end
Frame:AddChild(Label)
--Unit Flags
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    self:SetText("Unit Flags: " .. string.format("%X", ObjectDescriptor(DMW.Player.Pointer, GetOffset("CGUnitData__Flags"), "int")))
end
Frame:AddChild(Label)

--Target
Label = AceGUI:Create("Heading")
Label:SetFullWidth(true)
Label:SetText("Target:")
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
        self:SetText("Position: " .. DMW.Player.Target.PosX .. " - " .. DMW.Player.Target.PosY .. " - " .. DMW.Player.Target.PosZ)
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
        self:SetText("Facing: " .. ObjectFacing(DMW.Player.Target.Pointer))
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
        self:SetText("Unit Flags: " .. string.format("%X", ObjectDescriptor(DMW.Player.Target.Pointer, GetOffset("CGUnitData__Flags"), "int")))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)

--Mouseover
Label = AceGUI:Create("Heading")
Label:SetFullWidth(true)
Label:SetText("Mouseover:")
Frame:AddChild(Label)
--Pointer
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Mouseover then
        self:SetText("Pointer: " .. DMW.Player.Mouseover.Pointer)
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--Position
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Mouseover then
        self:SetText("Position: " .. DMW.Player.Mouseover.PosX .. " - " .. DMW.Player.Mouseover.PosY .. " - " .. DMW.Player.Mouseover.PosZ)
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--Facing
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Mouseover then
        self:SetText("Facing: " .. ObjectFacing(DMW.Player.Mouseover.Pointer))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)
--Unit Flags
Label = AceGUI:Create("Label")
Label:SetFullWidth(true)
Label.Update = function(self)
    if DMW.Player.Mouseover then
        self:SetText("Unit Flags: " .. string.format("%X", ObjectDescriptor(DMW.Player.Mouseover.Pointer, GetOffset("CGUnitData__Flags"), "int")))
    else
        self:SetText("")
    end
end
Frame:AddChild(Label)

function Debug.Run()
    if Frame:IsShown() then
        for k,v in pairs(Frame.children) do
            if v.Update then
                v:Update()
            end
        end
    end
end