local DMW = DMW
local Unit = DMW.Classes.Unit
local PI = PI

function Unit:GetAngle(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    local Angle = rad(atan2(OtherUnit.PosY - self.PosY, OtherUnit.PosX - self.PosX))
    if Angle >= 0 then
        return Angle
    else
        return PI * 2 + Angle
    end
end

function Unit:InArc(Arc, OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    if OtherUnit == self then
        return true
    end
    local Angle = self:GetAngle(OtherUnit) - ObjectFacing(self.Pointer)
    if Angle > PI then
        Angle = Angle - (PI * 2)
    end
    local LeftBorder = -1 * Arc
    local RightBorder = Arc
    return Angle >= LeftBorder and Angle <= RightBorder
end

function Unit:IsBehind(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return not self:InArc(PI, OtherUnit)
end

function Unit:IsInFront(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return self:InArc(PI, OtherUnit)
end