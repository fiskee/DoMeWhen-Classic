local DMW = DMW
DMW.UI.HUD = {}
local HUD = DMW.UI.HUD
HUD.Frame = CreateFrame("BUTTON", "DMWHUD", UIParent)
local HUDFrame = HUD.Frame
local Settings

function HUD.Init()
    Settings = DMW.Settings.profile
    HUDFrame:SetWidth(120)
    HUDFrame:SetHeight(0)
    HUDFrame:SetPoint(Settings.HUDPosition.point, UIParent, Settings.HUDPosition.relativePoint, Settings.HUDPosition.xOfs, Settings.HUDPosition.yOfs)
    HUDFrame:SetMovable(true)
    HUDFrame:EnableMouse(true)
end

HUD.CoreOptions = {
    [4] = {
        Rotation = {
            [1] = {Text = "Rotation |cFF00FF00Enabled", Tooltip = ""},
            [2] = {Text = "Rotation |cffff0000Disabled", Tooltip = ""}
        }
    },
    [3] = {
        CDs = {
            [1] = {Text = "Cooldowns |cFF00FF00Auto", Tooltip = ""},
            [2] = {Text = "Cooldowns |cFFFFFF00Always On", Tooltip = ""},
            [3] = {Text = "Cooldowns |cffff0000Disabled", Tooltip = ""}
        }
    },
    [2] = {
        Mode = {
            [1] = {Text = "Rotation Mode |cFF00FF00Auto", Tooltip = ""},
            [2] = {Text = "Rotation Mode |cFFFFFF00Single", Tooltip = ""}
        }
    },
    [1] = {
        Interrupts = {
            [1] = {Text = "Interrupts |cFF00FF00Enabled", Tooltip = ""},
            [2] = {Text = "Interrupts |cffff0000Disabled", Tooltip = ""}
        }
    }
}

function HUD.Load()
    if not HUD.Options then
        HUD.Options = {}
    end
    Settings = DMW.Settings.profile
    local ofsy = 0
    local Frame
    for _, Option in ipairs(HUD.CoreOptions) do
        table.insert(HUD.Options, 1, Option)
    end
    for i = 1, #HUD.Options do
        for Name, Setting in pairs(HUD.Options[i]) do
            Frame = CreateFrame("BUTTON", "DMWHUD" .. strupper(Name), HUDFrame)
            Frame.HUDName = Name
            Frame.Options = Setting
            Frame.OptionsCount = #Setting
            Frame.Index = 1
            Frame.Toggle = function(self, Index)
                if Index and self.Options[Index] then
                    self:SetText(self.Options[Index].Text)
                    self.Index = Index
                    Settings.HUD[self.HUDName] = Index
                elseif not Index then
                    local NewIndex
                    if self.Index < self.OptionsCount then
                        NewIndex = self.Index + 1
                    else
                        NewIndex = 1
                    end
                    self:SetText(self.Options[NewIndex].Text)
                    self.Index = NewIndex
                    Settings.HUD[self.HUDName] = NewIndex
                else
                    print("HUD: Invalid Index Supplied")
                end
            end
            Frame:SetWidth(120)
            Frame:SetHeight(22)
            Frame:SetNormalFontObject(GameFontNormalSmall)
            Frame:SetHighlightFontObject(GameFontHighlightSmall)
            Frame:SetPoint("TOP", HUDFrame, "TOP", 0, ofsy)
            Frame:SetText(Frame.Options[1].Text)
            Frame:SetScript(
                "OnMouseDown",
                function(self, button)
                    if button == "LeftButton" and not HUDFrame.IsMoving and IsShiftKeyDown() then
                        HUDFrame:StartMoving()
                        HUDFrame.IsMoving = true
                    end
                end
            )
            Frame:SetScript(
                "OnMouseUp",
                function(self, button)
                    if button == "LeftButton" and HUDFrame.IsMoving then
                        HUDFrame:StopMovingOrSizing()
                        HUDFrame.IsMoving = false
                        local point, _, relativePoint, xOfs, yOfs = HUDFrame:GetPoint(1)
                        Settings.HUDPosition.point = point
                        Settings.HUDPosition.relativePoint = relativePoint
                        Settings.HUDPosition.xOfs = xOfs
                        Settings.HUDPosition.yOfs = yOfs
                    elseif button == "LeftButton" then
                        self:Toggle()
                    elseif button == "RightButton" then
                        local NewIndex
                        if self.Index > 1 then
                            NewIndex = self.Index - 1
                        else
                            NewIndex = self.OptionsCount
                        end
                        self:SetText(self.Options[NewIndex].Text)
                        self.Index = NewIndex
                        Settings.HUD[self.HUDName] = NewIndex
                    end
                end
            )
            if Settings.HUD[Name] then
                Frame:Toggle(Settings.HUD[Name])
            else
                Frame:Toggle(1)
            end
            ofsy = ofsy - 22
        end
    end
    HUDFrame:SetHeight(math.abs(ofsy))
    HUD.Loaded = true
end

HUDFrame:SetScript(
    "OnUpdate",
    function(self, elapsed)
        if DMW.Settings.profile then
            if HUDFrame:IsShown() and not DMW.Settings.profile.HUD.Show then
                HUDFrame:Hide()
            elseif not HUDFrame:IsShown() and DMW.Settings.profile.HUD.Show then
                HUDFrame:Show()
            end
        end
    end
)
