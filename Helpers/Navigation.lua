local DMW = DMW
local LibDraw = LibStub("LibDraw-1.0")
DMW.Helpers.Navigation = {}
local Navigation = DMW.Helpers.Navigation
local Path = nil
local PathIndex = 1
local DestX, DestY, DestZ
local EndX, EndY, EndZ
local PathUpdated = false
local Pause = GetTime()

local Modes = {
    Disabled = 0,
    Grinding = 1,
    Transport = 2
}
Navigation.Mode = Modes.Disabled
Navigation.CombatRange = 18

local function DrawRoute()
    LibDraw.SetWidth(4)
    LibDraw.SetColorRaw(0, 128, 128, 100)
    for i = PathIndex, #Path do
        if i == PathIndex then
            LibDraw.Line(DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ, Path[i][1], Path[i][2], Path[i][3])
        end
        if Path[i + 1] then
            LibDraw.Line(Path[i][1], Path[i][2], Path[i][3], Path[i + 1][1], Path[i + 1][2], Path[i + 1][3])
        end
    end
end

function Navigation:Pulse()
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
            if sqrt(((DestX - DMW.Player.PosX) ^ 2) + ((DestY - DMW.Player.PosY) ^ 2)) < 1 and math.abs(DestZ - DMW.Player.PosZ) < 4 then
                PathIndex = PathIndex + 1
                if PathIndex > #Path then
                    PathIndex = 1
                    Path = nil
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

function Navigation:MoveTo(toX, toY, toZ)
    PathIndex = 1
    Path = CalculatePath(GetMapId(), DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ, toX, toY, toZ)
    if Path then
        EndX, EndY, EndZ = toX, toY, toZ
        PathUpdated = true
        return true
    end
    return false
end

function Navigation:MoveToCursor()
    local x, y = GetMousePosition()
    local PosX, PosY, PosZ = ScreenToWorld(x, y)
    self:MoveTo(PosX, PosY, PosZ)
end

function Navigation:MoveToCorpse()
    if StaticPopup1 and StaticPopup1:IsVisible() and (StaticPopup1.which == "DEATH" or StaticPopup1.which == "RECOVER_CORPSE") and StaticPopup1Button1 and StaticPopup1Button1:IsEnabled() then
        StaticPopup1Button1:Click()
        Path = nil
        Pause = DMW.Time + 1
        return
    end
    local PosX, PosY, PosZ = GetCorpsePosition()
    if not Path or (PosX ~= EndX or PosY ~= EndY) then
        self:MoveTo(PosX, PosY, PosZ)
    end
end

function Navigation:SearchAttackable()
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
    for _, Unit in ipairs(Table) do
        if Unit.Distance <= 100 and not Unit.Dead and not Unit.Player and UnitCanAttack("player", Unit.Pointer) and not UnitIsTapDenied(Unit.Pointer) then
            if self:MoveTo(Unit.PosX, Unit.PosY, Unit.PosZ) then
                TargetUnit(Unit.Pointer)
                DMW.Player.Target = Unit
                return true
            end
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
    if DMW.Player.Target and DMW.Player.Target.ValidEnemy and DMW.Player.Target.Distance <= Navigation.CombatRange then
        Path = nil
        PathIndex = 1
        if DMW.Player.Moving then
            MoveForwardStart()
            MoveForwardStop()
        end
        return
    end
    if DMW.Player.Combat and (not DMW.Player.Target or not DMW.Player.Target.ValidEnemy) then
        self:SearchEnemy()
    elseif (not DMW.Player.Target or DMW.Player.Target.Dead or UnitIsTapDenied(DMW.Player.Target.Pointer)) and DMW.Player.HP > 70 then
        self:SearchAttackable()
    end
    if DMW.Player.Target and DMW.Player.Target.Distance > Navigation.CombatRange and (DMW.Player.Target.PosX ~= EndX or DMW.Player.Target.PosY ~= EndY or DMW.Player.Target.PosZ ~= EndZ) then
        self:MoveTo(DMW.Player.Target.PosX, DMW.Player.Target.PosY, DMW.Player.Target.PosZ)
    end
end