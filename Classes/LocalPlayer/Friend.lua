local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer

function LocalPlayer:GetFriends(Yards, HP)
    local Table = {}
    local Count = 0
    for _, v in ipairs(DMW.Friends.Units) do
        if v.Distance <= Yards and (not HP or v.HP < HP) then
            table.insert(Table, v)
            Count = Count + 1
        end
    end
    return Table, Count
end

function LocalPlayer:GetFriendsCone(Length, Angle, HP)
    local Count = 0
    local Table, TableCount = self:GetFriends(Length)
    if TableCount > 0 then
        HP = HP or 100
        local Facing = ObjectFacing(self.Pointer)
        for _, Unit in pairs(Table) do
            if Unit.HP <= HP and UnitIsFacing(self.Pointer, Unit.Pointer, Angle/2) then
                Count = Count + 1
            end
        end
    end
    return Count
end