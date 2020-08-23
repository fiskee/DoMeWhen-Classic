local DMW = DMW
DMW.UI.Log = {}
local Log = DMW.UI.Log
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
Log.Frame = AceGUI:Create("Window")
local Frame = Log.Frame
local Logger = {}
local ID = 0
local Label

Frame:SetTitle("DMW Log")
Frame:SetWidth(300)
Frame:Hide()

local scroll = AceGUI:Create("ScrollFrame")
scroll.width = "fill"
scroll.height = "fill"
Frame:AddChild(scroll)

local function GetSpellDebugInfo()
    local debugstring = debugstack(4,1,0)
    if debugstring:len() < 60 then
        debugstring = debugstack(5,1,0)
    end
    local file, line = debugstring:match("Interface\\AddOns\\(.-).lua:(%d-):")
    if not file then
        return "Unknown", 0
    end
    return file, line
end

function Log.AddCast(SpellName, Target)
    ID = ID + 1
    if #Logger == 100 then
        tremove(Logger, 1)
    end
    if not Target then
        Target = "Unknown"
    end
    local LogEntry = {}
    local File, Line = GetSpellDebugInfo()
    LogEntry.ID = ID
    LogEntry.Text = DMW.Time .. " - Casted: " .. SpellName .. " - On: " .. Target .. " - " .. File .. " (" .. Line .. ")"
    tinsert(Logger, LogEntry)
    if Frame:IsShown() then
        if #Frame.children[1].children == 100 then
            tremove(Frame.children[1].children, 1)
        end
        Label = AceGUI:Create("Label")
        Label:SetFullWidth(true)
        Label:SetText(LogEntry.Text)
        Frame.children[1]:AddChild(Label)
        Frame.children[1]:DoLayout()
    end
end

function Log.AddEvent(EventText)
    ID = ID + 1
    if #Logger == 100 then
        tremove(Logger, 1)
    end
    local LogEntry = {}
    LogEntry.ID = ID
    LogEntry.Text = DMW.Time .. " - Event: " .. EventText
    tinsert(Logger, LogEntry)
    if Frame:IsShown() then
        if #Frame.children[1].children == 100 then
            tremove(Frame.children[1].children, 1)
        end
        if #Frame.children[1].children < 100 then
            Label = AceGUI:Create("Label")
            Label:SetFullWidth(true)
            Label:SetText(LogEntry.Text)
            Frame.children[1]:AddChild(Label)
        end
    end
end

function Log.LoadLog()
    for _, Entry in ipairs(Logger) do
        Label = AceGUI:Create("Label")
        Label:SetFullWidth(true)
        Label:SetText(Entry.Text)
        Frame.children[1]:AddChild(Label)
    end
end

Frame:SetCallback("OnShow", 
function(widget)
    Log.LoadLog()
end
)