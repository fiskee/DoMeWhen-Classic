local DMW = DMW
local Unit = DMW.Classes.Unit

function Unit:RawFacing()
    return ReadMemory(tonumber(self.Pointer) + 0x19E8, "float")
end

function Unit:GetFacingAngle(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    local X = OtherUnit.PosX - self.PosX
    local Y = OtherUnit.PosY - self.PosY
    local Angle = self:RawFacing()
    local DX = math.cos(Angle)
    local DY = math.sin(Angle)
    return(math.abs(math.atan2(X * DY - Y * DX,  X * DX + Y * DY ) * (180 / math.pi)))
end


function Unit:InArc(Arc, OtherUnit)
    if self:GetFacingAngle() < Arc then
        return true
    end
    return false
end

function Unit:IsBehind(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return not self:InArc(90, OtherUnit)
end

function Unit:IsInFront(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return self:InArc(90, OtherUnit)
end