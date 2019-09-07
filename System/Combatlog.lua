local DMW = DMW
local Player, Buff, Debuff, Spell
local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript(
    "OnEvent",
    function(self, event)
        self:Reader(event, CombatLogGetCurrentEventInfo())
    end
)

function frame:Reader(event, ...)
    if EWT then
        timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
        Locals()
        DMW.Functions.AuraCache.Event(...)

        if source == Player.GUID then
            if param == "SWING_DAMAGE" and source == Player.GUID then
                Player.SwingLast = DMW.Time
                Player.SwingNext = Player.SwingLast + UnitAttackSpeed("player")
            end
            if Player.Class == "WARRIOR" then
                if string.match(param, "_MISSED") then
                    local missType = param == "SWING_MISSED" and spell or spellType
                    if missType == "DODGE" then
                        local overpower = {
                            overpowerUnit = destination,
                            overpowerTime = DMW.Time + 5
                        }
                        table.insert(Player.OverpowerUnit, overpower)
                    end
                    if missType == "PARRY" or spellType == "BLOCK" or spellType == "DODGE" then
                        local revenge = {}
                        revenge.revengeUnit = destination
                        revenge.revengeTime = DMW.Time + 5
                        table.insert(Player.RevengeUnit, revenge)
                    end
                end
                if spellName == Spell.Overpower.SpellName and param == "SPELL_CAST_SUCCESS" then
                    for i = 1, #Player.OverpowerUnit do
                        if Player.OverpowerUnit[i] ~= nil and Player.OverpowerUnit[i].overpowerUnit == destination then
                            table.remove(Player.OverpowerUnit, i)
                        end
                    end                    
                elseif spellName == Spell.Revenge.SpellName and param == "SPELL_CAST_SUCCESS" then
                    for i = 1, #Player.RevengeUnit do
                        if Player.RevengeUnit[i] ~= nil and Player.RevengeUnit[i].revengeUnit == destination then
                            table.remove(Player.RevengeUnit, i)
                            table.remove(Player.OverpowerUnit, i)
                        end
                    end       
                end
                if param == "UNIT_DIED" then
                    for i = 1, #Player.revengeUnit do
                        if Player.RevengeUnit[i].revengeUnit == destination then
                            table.remove(Player.RevengeUnit, i)
                            table.remove(Player.OverpowerUnit, i)
                        end   
                    end
                    for i = 1, #Player.OverpowerUnit do
                        if Player.OverpowerUnit[i].overpowerUnit == destination then
                            table.remove(Player.OverpowerUnit, i)
                        end   
                    end
                end
                -- if #Player.OverpowerUnit > 0 and param == "UNIT_DIED" then
                --     for i = 1, #Player.OverpowerUnit do
                --         if Player.OverpowerUnit[i].overpowerUnit
                --     end
                -- end
            end
        end
    end
end