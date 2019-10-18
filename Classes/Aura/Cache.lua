local DMW = DMW
DMW.Tables.AuraCache = {}
DMW.Tables.AuraUpdate = {}
DMW.Functions.AuraCache = {}
local AuraCache = DMW.Functions.AuraCache
local Buff = DMW.Classes.Buff
local Debuff = DMW.Classes.Debuff
local DurationLib = LibStub("LibClassicDurationsDMW")
DurationLib:Register("DMW")
local UnitAura

function AuraCache.Refresh(Unit)
    if not UnitAura then
        UnitAura = _G.UnitAura
    end
    if DMW.Tables.AuraCache[Unit] then
        table.wipe(DMW.Tables.AuraCache[Unit])
    end
    local AuraReturn, Name, Source, DurationNew, ExpirationTimeNew
    for i = 1, 40 do
        AuraReturn = {UnitAura(Unit, i, "HELPFUL")}
        if AuraReturn[10] == nil then
            break
        end
        if DMW.Tables.AuraCache[Unit] == nil then
            DMW.Tables.AuraCache[Unit] = {}
        end
        Name, Source = GetSpellInfo(AuraReturn[10]), AuraReturn[7]
        DurationNew, ExpirationTimeNew = DurationLib:GetAuraDurationByUnit(Unit, AuraReturn[10], Source, Name)
        if AuraReturn[5] == 0 and DurationNew then
            AuraReturn[5] = DurationNew
            AuraReturn[6] = ExpirationTimeNew
        end
        if DMW.Tables.AuraCache[Unit][Name] == nil then
            DMW.Tables.AuraCache[Unit][Name] = {
                ["AuraReturn"] = AuraReturn,
                Type = "HELPFUL"
            }
        end
        if Source ~= nil and Source == "player" then
            DMW.Tables.AuraCache[Unit][Name]["player"] = {
                ["AuraReturn"] = AuraReturn,
                Type = "HELPFUL"
            }
        end
    end

    for i = 1, 40 do
        AuraReturn = {UnitAura(Unit, i, "HARMFUL")}
        if AuraReturn[10] == nil then
            break
        end
        if DMW.Tables.AuraCache[Unit] == nil then
            DMW.Tables.AuraCache[Unit] = {}
        end
        Name, Source = GetSpellInfo(AuraReturn[10]), AuraReturn[7]
        DurationNew, ExpirationTimeNew = DurationLib:GetAuraDurationByUnit(Unit, AuraReturn[10], Source, Name)
        if AuraReturn[5] == 0 and DurationNew then
            AuraReturn[5] = DurationNew
            AuraReturn[6] = ExpirationTimeNew
        end
        if DMW.Tables.AuraCache[Unit][Name] == nil then
            DMW.Tables.AuraCache[Unit][Name] = {
                ["AuraReturn"] = AuraReturn,
                Type = "HARMFUL"
            }
        end
        if Source ~= nil and Source == "player" then
            DMW.Tables.AuraCache[Unit][Name]["player"] = {
                ["AuraReturn"] = AuraReturn,
                Type = "HARMFUL"
            }
        end
    end
end

function AuraCache.Event(...)
	local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags,
          sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
    
    if destGUID and (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_AURA_REMOVED_DOSE" or event == "SPELL_AURA_REFRESH" or event == "SPELL_AURA_REMOVED" or event == "SPELL_PERIODIC_AURA_REMOVED") then
        local dest = GetObjectWithGUID(destGUID)
        if dest then
            DMW.Tables.AuraUpdate[dest] = true
        end
        --AuraCache.Refresh(dest)
    end
end

function Buff:Query(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or false
    if not Unit then
        return nil
    end
    Unit = Unit.Pointer
    if DMW.Tables.AuraCache[Unit] ~= nil and DMW.Tables.AuraCache[Unit][self.SpellName] ~= nil and (not OnlyPlayer or DMW.Tables.AuraCache[Unit][self.SpellName]["player"] ~= nil) then
        local AuraReturn
        if OnlyPlayer then
            AuraReturn = DMW.Tables.AuraCache[Unit][self.SpellName]["player"].AuraReturn
        else
            AuraReturn = DMW.Tables.AuraCache[Unit][self.SpellName].AuraReturn
        end
        return unpack(AuraReturn)
    end
    return nil
end

function Debuff:Query(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or false
    if not Unit then
        return nil
    end
    Unit = Unit.Pointer
    if DMW.Tables.AuraCache[Unit] ~= nil and DMW.Tables.AuraCache[Unit][self.SpellName] ~= nil and (not OnlyPlayer or DMW.Tables.AuraCache[Unit][self.SpellName]["player"] ~= nil) then
        local AuraReturn
        if OnlyPlayer then
            AuraReturn = DMW.Tables.AuraCache[Unit][self.SpellName]["player"].AuraReturn
        else
            AuraReturn = DMW.Tables.AuraCache[Unit][self.SpellName].AuraReturn
        end
        return unpack(AuraReturn)
    end
    return nil
end
