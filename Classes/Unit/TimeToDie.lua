local DMW = DMW
local Unit = DMW.Classes.Unit
DMW.Tables.TTD = {}

function Unit:GetTTD(targetPercentage)
    if targetPercentage == nil then targetPercentage = 0 end
    local value
    if self.HP == 0 then return -1 end
    if self.HP == 100 then return 999 end
    if self.Player then return 999 end
    local timeNow = DMW.Time
    -- Reset unit if HP is higher
    if DMW.Tables.TTD[self.Pointer] ~= nil and (DMW.Tables.TTD[self.Pointer].lasthp < self.HP or #DMW.Tables.TTD[self.Pointer].values == 0) then
        DMW.Tables.TTD[self.Pointer] = nil
    end
    -- initialize new unit
    if DMW.Tables.TTD[self.Pointer] == nil then
        DMW.Tables.TTD[self.Pointer] = { } -- create unit
        DMW.Tables.TTD[self.Pointer].values = { } -- create value table
        value = {time = 0, hp = self.HP} -- create initial values
        tinsert(DMW.Tables.TTD[self.Pointer].values, 1, value) -- insert unit
        DMW.Tables.TTD[self.Pointer].lasthp = self.HP -- store current hp pct
        DMW.Tables.TTD[self.Pointer].startTime = timeNow -- store current time
        DMW.Tables.TTD[self.Pointer].lastTime = 0 --store last time value
        return 999
    end
    local ttdUnit = DMW.Tables.TTD[self.Pointer]
    -- add current value to ttd table if HP changed or more than X sec since last update
    if self.HP ~= ttdUnit.lasthp or (timeNow - ttdUnit.startTime - ttdUnit.lastTime) > 0.5 then
        value = {time = timeNow - ttdUnit.startTime, hp = self.HP}
        tinsert(ttdUnit.values, 1, value)
        DMW.Tables.TTD[self.Pointer].lasthp = self.HP
        DMW.Tables.TTD[self.Pointer].lastTime = timeNow - ttdUnit.startTime
    end
    -- clean units
    local valueCount = #ttdUnit.values
    while valueCount > 0 and (valueCount > 100 or (timeNow - ttdUnit.startTime - ttdUnit.values[valueCount].time) > 10) do
        ttdUnit.values[valueCount] = nil
        valueCount = valueCount - 1
    end
    -- calculate ttd if more than 3 values
    valueCount = #ttdUnit.values
    if valueCount > 1 then
        -- linear regression calculation from https://github.com/herotc/hero-lib/
        local a, b = 0, 0
        local Ex2, Ex, Exy, Ey = 0, 0, 0, 0
        local x, y
        for i = 1, valueCount do
            x, y = ttdUnit.values[i].time, ttdUnit.values[i].hp
            Ex2 = Ex2 + x * x
            Ex = Ex + x
            Exy = Exy + x * y
            Ey = Ey + y
        end
        local invariant = 1 / (Ex2 * valueCount - Ex * Ex)
        a = (-Ex * Exy * invariant) + (Ex2 * Ey * invariant)
        b = (valueCount * Exy * invariant) - (Ex * Ey * invariant)
        if b ~= 0 then
            local ttdSec = (targetPercentage - a) / b
            ttdSec = math.min(999, ttdSec - (timeNow - ttdUnit.startTime))
            if ttdSec > 0 then
                return ttdSec
            end
            return -1 -- TTD under 0
        end
    end
    return 999 -- not enough values
end