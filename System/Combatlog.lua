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

local function nilWarriorUnit(destobj)
    if Player.OverpowerUnit[destobj] ~= nil then
        Player.OverpowerUnit[destobj] = nil
    end
    if Player.RevengeUnit[destobj] ~= nil then
        Player.RevengeUnit[destobj] = nil
    end
end

function frame:Reader(event, ...)
    if EWT then
        timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
        Locals()
        DMW.Functions.AuraCache.Event(...)
        if source == Player.GUID or destination == Player.GUID then
            local sourceobj = GetObjectWithGUID(source)
            local destobj = GetObjectWithGUID(destination)
            if Player.Class == "WARRIOR" and source == Player.GUID and destobj then
                if string.match(param, "_MISSED") then
                    local missType = param == "SWING_MISSED" and spell or spellType
                    if missType == "DODGE" then
                        Player.OverpowerUnit[destobj] = {}
                        Player.OverpowerUnit[destobj].time = DMW.Time + 5
                        Player.RevengeUnit[destobj] = {}
                        Player.RevengeUnit[destobj].time = DMW.Time + 5
                        C_Timer.After(5,  function () 
                            if Player.OverpowerUnit[destobj] ~= nil then
                                Player.OverpowerUnit[destobj] = nil
                            end
                            if Player.RevengeUnit[destobj] ~= nil then
                                Player.RevengeUnit[destobj] = nil
                            end
                        end)
                    elseif missType == "PARRY" or spellType == "BLOCK" then
                        Player.RevengeUnit[destobj] = {}
                        Player.RevengeUnit[destobj].time = DMW.Time + 5
                        C_Timer.After(5,  function () 
                            if Player.OverpowerUnit[destobj] ~= nil then
                                Player.OverpowerUnit[destobj] = nil
                            end
                            if Player.RevengeUnit[destobj] ~= nil then
                                Player.RevengeUnit[destobj] = nil
                            end
                        end)
                    end
                elseif (param == "SPELL_CAST_SUCCESS" and (spellName == Spell.Overpower.SpellName or spellName == Spell.Revenge.SpellName)) or param == "UNIT_DIED" then
                    nilWarriorUnit(destobj)
                end
            end
            if source == Player.GUID or DMW.Tables.Swing.Units[sourceobj] ~= nil then
                if param == "SWING_DAMAGE" then
                    -- if destination == Player.GUID and not sitenrage then StrafeLeftStart();C_Timer.After(.0000001, function() StrafeLeftStop();sitenrage = true end) end
                    local _, _, _, _, _, _, _, _, _, offhand = select(12, ...)
                    if offhand then
                        DMW.Helpers.Swing.SwingOHReset(sourceobj)
                    else
                        DMW.Helpers.Swing.SwingMHReset(sourceobj)
                    end
                elseif param == "SWING_MISSED" then
                    -- if destination == Player.GUID and not sitenrage then StrafeLeftStart();C_Timer.After(.0000001, function() StrafeLeftStop();sitenrage = true end) end
                    local missType, offhand = select(12, ...)
                    DMW.Helpers.Swing.MissHandler(sourceobj, missType, offhand, destobj)
                elseif source == Player.GUID and param == "SPELL_DAMAGE" or param == "SPELL_MISSED" then
                    if spellName and DMW.Tables.Swing.Reset[Player.Class] and DMW.Tables.Swing.Reset[Player.Class][spellName] then
                        DMW.Helpers.Swing.SwingMHReset(sourceobj)
                    end
                end
            end
        end
    end
end