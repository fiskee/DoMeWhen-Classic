local DMW = DMW
local libdraw = LibStub("libdraw-1.0")
DMW.Helpers.Navigation = {}
local Navigation = DMW.Helpers.Navigation
local Path = nil
local PathIndex = 1
local DestX, DestY, DestZ
local EndX, EndY, EndZ
local PathUpdated = false
local Pause = GetTime()
Navigation.WMRoute = {}
local WMRouteIndex = 1
local Settings
local Food

local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
Navigation.Frame = AceGUI:Create("Window")
local Frame = Navigation.Frame
local function Round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
Frame:SetTitle("Route")
Frame:SetWidth(300)
Frame:Hide()

local Modes = {
    Disabled = 0,
    Grinding = 1,
    Transport = 2
}
Navigation.Mode = Modes.Disabled
Navigation.CombatRange = 18

local function NextNodeRange()
    if IsMounted() then
        return 3
    end
    if PathIndex == #Path and DMW.Settings.profile.Helpers.AutoLoot and DMW.Player.Target and DMW.Player.Target.Dead and UnitCanBeLooted(DMW.Player.Target.Pointer) then
        return 0.7
    end
    return 2
end

local function DrawRoute()
    libdraw.SetWidth(4)
    libdraw.SetColorRaw(0, 128, 128, 100)
    for i = PathIndex, #Path do
        if i == PathIndex then
            libdraw.Line(DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ, Path[i][1], Path[i][2], Path[i][3])
        end
        if Path[i + 1] then
            libdraw.Line(Path[i][1], Path[i][2], Path[i][3], Path[i + 1][1], Path[i + 1][2], Path[i + 1][3])
        end
    end
end

function Navigation:Pulse()
    if not Settings then
        Settings = DMW.Settings.profile.Navigation
    end
    if not Food and Settings.FoodID > 0 then
        Food = DMW.Classes.Item(Settings.FoodID)
    end
    if not DMW.Player.Moving and not Path and DMW.Player.Target and DMW.Player.Target.ValidEnemy and not DMW.Player.Target.Facing and Navigation.Mode == Modes.Grinding then
        FaceDirection(DMW.Player.Target.Pointer)
    end
    if Navigation.Mode ~= Modes.Disabled and not DMW.Player.Casting and DMW.Time > Pause then
        if Navigation.Mode == Modes.Grinding then
            self:Grinding()
        end
        local NoMoveFlags = bit.bor(DMW.Enums.UnitFlags.Stunned, DMW.Enums.UnitFlags.Confused, DMW.Enums.UnitFlags.Pacified, DMW.Enums.UnitFlags.Feared)
        if Path and not DMW.Player:HasFlag(NoMoveFlags) and not DMW.Player:HasMovementFlag(DMW.Enums.MovementFlags.Root) then
            DestX = Path[PathIndex][1]
            DestY = Path[PathIndex][2]
            DestZ = Path[PathIndex][3]
            if sqrt(((DestX - DMW.Player.PosX) ^ 2) + ((DestY - DMW.Player.PosY) ^ 2)) < NextNodeRange() and math.abs(DestZ - DMW.Player.PosZ) < 4 then
                PathIndex = PathIndex + 1
                if PathIndex > #Path then
                    if Navigation.Mode == Modes.Transport then
                        Navigation.Mode = Modes.Disabled
                    end
                    self:ClearPath()
                    return
                end
            elseif not DMW.Player.Moving or PathUpdated then
                PathUpdated = false
                MoveTo(DestX, DestY, DestZ, true)
            end
            DrawRoute()
        end
    end
end

function Navigation:CalculatePath(mapID, fromX, fromY, fromZ, toX, toY, toZ)
    return CalculatePath(mapID, fromX, fromY, fromZ, toX, toY, toZ, true, false, 2)
end

function Navigation:MoveTo(toX, toY, toZ)
    PathIndex = 1
    Path = self:CalculatePath(GetMapId(), DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ, toX, toY, toZ)
    if Path then
        EndX, EndY, EndZ = toX, toY, toZ
        PathUpdated = true
        return true
    end
    return false
end

function Navigation:ClearPath()
    Path = nil
    PathIndex = 1
end

function Navigation:MoveToCursor()
    local x, y = GetMousePosition()
    local PosX, PosY, PosZ = ScreenToWorld(x, y)
    self:MoveTo(PosX, PosY, PosZ)
end

function Navigation:MoveToCorpse()
    if StaticPopup1 and StaticPopup1:IsVisible() and (StaticPopup1.which == "DEATH" or StaticPopup1.which == "RECOVER_CORPSE") and StaticPopup1Button1 and StaticPopup1Button1:IsEnabled() then
        StaticPopup1Button1:Click()
        self:ClearPath()
        Pause = DMW.Time + 1
        return
    end
    local PosX, PosY, PosZ = GetCorpsePosition()
    if not Path or (PosX ~= EndX or PosY ~= EndY) then
        self:MoveTo(PosX, PosY, PosZ)
    end
end

function Navigation:SearchNext()
    local Table = {}
    for _, Unit in pairs(DMW.Units) do
        table.insert(Table, Unit)
    end
    if #Table > 1 then
        table.sort(
            Table,
            function(x, y)
                return x.Distance < y.Distance
            end
        )
    end
    if DMW.Settings.profile.Helpers.AutoLoot and DMW.Player:GetFreeBagSlots() > 0 then
        for _, Unit in ipairs(Table) do
            if Unit.Distance <= 100 and Unit.Dead and UnitCanBeLooted(Unit.Pointer) then
                if self:MoveTo(Unit.PosX, Unit.PosY, Unit.PosZ) then
                    TargetUnit(Unit.Pointer)
                    DMW.Player.Target = Unit
                    return true
                end
            end
        end
    end
    for _, Unit in ipairs(Table) do
        if Unit.Distance <= 100 and not Unit.Dead and not Unit.Player and math.abs(DMW.Player.Level - Unit.Level) <= Settings.LevelRange and UnitCanAttack("player", Unit.Pointer) and not UnitIsTapDenied(Unit.Pointer) then
            if self:MoveTo(Unit.PosX, Unit.PosY, Unit.PosZ) then
                TargetUnit(Unit.Pointer)
                DMW.Player.Target = Unit
                return true
            end
        end
    end
    if not Path and #Navigation.WMRoute > 0 then
        local x, y, z = unpack(Navigation.WMRoute[WMRouteIndex])
        if sqrt(((x - DMW.Player.PosX) ^ 2) + ((y - DMW.Player.PosY) ^ 2)) < 30 then
            WMRouteIndex = WMRouteIndex + 1
            if WMRouteIndex > #Navigation.WMRoute then
                WMRouteIndex = 1
            end
            x, y, z = unpack(Navigation.WMRoute[WMRouteIndex])
        end
        if self:MoveTo(x, y, z) then
            return true
        end
    end
end

function Navigation:SearchEnemy()
    for _, Unit in ipairs(DMW.Enemies) do
        if Unit.Distance <= 100 then
            if self:MoveTo(Unit.PosX, Unit.PosY, Unit.PosZ) then
                TargetUnit(Unit.Pointer)
                DMW.Player.Target = Unit
                return true
            end
        end
    end
end

function Navigation:Grinding()
    if UnitIsDeadOrGhost("player") then
        return self:MoveToCorpse()
    end
    if DMW.Player.Target and DMW.Player.Target.ValidEnemy and DMW.Player.Target.Distance <= Settings.AttackDistance then
        self:ClearPath()
        if DMW.Player.Moving then
            MoveForwardStart()
            MoveForwardStop()
        end
        return
    end
    if DMW.Player.Combat and (not DMW.Player.Target or not UnitAffectingCombat(DMW.Player.Target.Pointer)) then
        self:SearchEnemy()
    elseif (not DMW.Player.Looting or DMW.Player:GetFreeBagSlots() == 0) and (not DMW.Player.Target or (DMW.Player.Target.Dead and (not DMW.Settings.profile.Helpers.AutoLoot or DMW.Player:GetFreeBagSlots() == 0 or not UnitCanBeLooted(DMW.Player.Target.Pointer))) or UnitIsTapDenied(DMW.Player.Target.Pointer)) and DMW.Player.HP > Settings.FoodHP and (DMW.Player:Standing() or DMW.Player.HP == 100) then
        self:SearchNext()
    elseif not DMW.Player.Looting and not DMW.Player.Moving and Food and DMW.Player.HP <= Settings.FoodHP and DMW.Player:Standing() and Food:Use(DMW.Player) then
        Pause = DMW.Time + 1
        return
    end
    if not DMW.Player.Looting and DMW.Player.Target and ((DMW.Player.Target.Distance > Settings.MaxDistance and not DMW.Player.Target.Dead) or (DMW.Settings.profile.Helpers.AutoLoot and DMW.Player.Target.Dead and UnitCanBeLooted(DMW.Player.Target.Pointer) and DMW.Player:GetFreeBagSlots() > 0)) and (DMW.Player.Target.PosX ~= EndX or DMW.Player.Target.PosY ~= EndY or DMW.Player.Target.PosZ ~= EndZ) then
        self:MoveTo(DMW.Player.Target.PosX, DMW.Player.Target.PosY, DMW.Player.Target.PosZ)
    end
end

function Navigation:MapCursorPosition()
    if WorldMapFrame:IsVisible() then
        local x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
        local continentID, worldPosition = C_Map.GetWorldPosFromMapPos(WorldMapFrame:GetMapID(), CreateVector2D(x, y))
        local WX, WY = worldPosition:GetXY()
        local WZ = select(3, TraceLine(WX, WY, 10000, WX, WY, -10000, 0x110))
        if not WZ and WorldPreload(WX, WY, DMW.Player.PosZ) then
            WZ = select(3, TraceLine(WX, WY, 9999, WX, WY, -9999, 0x110))
        end
        if WZ then
            return WX, WY, WZ, WorldMapFrame:GetMapID(), x, y
        end
    end
    return nil
end

function Navigation:MoveToMapCursorPosition()
    local x, y, z = self:MapCursorPosition()
    if z and self:MoveTo(x, y, z) then
        Navigation.Mode = Modes.Transport
        return true
    end
    return false
end

function Frame:AddRoutePoint(Index, X, Y, Z)
    local Label = AceGUI:Create("Label")
    Label:SetFullWidth(true)
    Label.RouteIndex = Index
    Label:SetText(string.format("%s - %s - %s", Round(X, 2), Round(Y, 2), Round(Z, 2)))
    Frame:AddChild(Label)
end

function Navigation:AddMapCursorPosition()
    local Pos = {self:MapCursorPosition()}
    if Pos[3] then
        if #Navigation.WMRoute == 0 then
            if self:CalculatePath(GetMapId(), DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ, Pos[1], Pos[2], Pos[3]) then
                table.insert(Navigation.WMRoute, Pos)
                Frame:AddRoutePoint(#Navigation.WMRoute, Pos[1], Pos[2], Pos[3])
            end
        else
            local LastWMIndex = Navigation.WMRoute[#Navigation.WMRoute]
            if self:CalculatePath(GetMapId(), LastWMIndex[1], LastWMIndex[2], LastWMIndex[3], Pos[1], Pos[2], Pos[3]) then
                table.insert(Navigation.WMRoute, Pos)
                Frame:AddRoutePoint(#Navigation.WMRoute, Pos[1], Pos[2], Pos[3])
            end
        end
    end
end

function Navigation:InitWorldMap()
    WorldMapFrame.ScrollContainer:HookScript(
        "OnMouseDown",
        function(self, button)
            if (button == "LeftButton") and IsLeftControlKeyDown() then
                Navigation:MoveToMapCursorPosition()
            elseif (button == "LeftButton") and IsLeftShiftKeyDown() then
                Navigation:AddMapCursorPosition()
                if not Frame:IsShown() then
                    Frame:Show()
                end
            end
        end
    )
end
