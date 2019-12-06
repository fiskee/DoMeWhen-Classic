local DMW = DMW
local Unit = DMW.Classes.Unit

function Unit:CalculateHP()
    if self.PredictedHeal then
        -- print(self.PredictedHeal)
        local afterHeal = self.Health + self.PredictedHeal
        
        self.Health = afterHeal < self.HealthMax and afterHeal or self.HealthMax
    end
    self.HealthDeficit = self.HealthMax - self.Health
    self.HP = self.Health / self.HealthMax * 100
end