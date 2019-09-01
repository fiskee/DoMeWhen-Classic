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
                if param == "SWING_MISSED" or param == "SPELL_MISSED" then
                    if spellType == "DODGE" then
                        Player.overpowerUnit = destination
                        Player.overpowerTime = DMW.Time + 5
                    end
                    if spellType == "PARRY" or spellType == "BLOCK" or spellType == "DODGE" then
                        Player.revengeUnit = destination
                        Player.revengeTime = DMW.Time + 5
                    end
                elseif spell == Spell.Overpower.SpellName and param == "SPELL_CAST_SUCCESS" then
                    Player.overpowerTime = false
                    Player.overpowerUnit = nil
                elseif spell == Spell.Revenge.SpellName and param == "SPELL_CAST_SUCCESS" then
                    Player.revengeTime = false
                    Player.revengeUnit = nil
                end
            end
        end
    end
end
