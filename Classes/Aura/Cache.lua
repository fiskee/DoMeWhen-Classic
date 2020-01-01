local DMW = DMW
DMW.Tables.AuraCache = {}
DMW.Tables.AuraUpdate = {}
DMW.Functions.AuraCache = {}
local AuraCache = DMW.Functions.AuraCache
local Buff = DMW.Classes.Buff
local Debuff = DMW.Classes.Debuff
local DurationLib = LibStub("LibClassicDurationsDMW")
DurationLib:Register("DMW")
local UnitAura = DurationLib.UnitAuraWithBuffs
local f = CreateFrame("Frame", nil, UIParent)
f:SetScript("OnEvent", function(self, event, ...) return self[event](self, event, ...) end)
DurationLib.RegisterCallback("DMW", "UNIT_BUFF", function(event, unit) end)

function AuraCache.Refresh(Pointer, GUID)
    if DMW.Tables.AuraCache[GUID] then table.wipe(DMW.Tables.AuraCache[GUID]) end
    local AuraReturn
    for i = 1, 40 do
        AuraReturn = {UnitAura(Pointer, i, "HELPFUL")}
        if AuraReturn[1] == nil then break end
        if DMW.Tables.AuraCache[GUID] == nil then DMW.Tables.AuraCache[GUID] = {} end
        if DMW.Tables.AuraCache[GUID][AuraReturn[1]] == nil then
            DMW.Tables.AuraCache[GUID][AuraReturn[1]] = {["AuraReturn"] = AuraReturn, Type = "HELPFUL"}
        end
        if AuraReturn[7] ~= nil and AuraReturn[7] == "player" then
            DMW.Tables.AuraCache[GUID][AuraReturn[1]]["player"] = {["AuraReturn"] = AuraReturn, Type = "HELPFUL"}
        end
    end

    for i = 1, 40 do
        AuraReturn = {UnitAura(Pointer, i, "HARMFUL")}
        if AuraReturn[1] == nil then break end
        if DMW.Tables.AuraCache[GUID] == nil then DMW.Tables.AuraCache[GUID] = {} end
        if DMW.Tables.AuraCache[GUID][AuraReturn[1]] == nil then
            DMW.Tables.AuraCache[GUID][AuraReturn[1]] = {["AuraReturn"] = AuraReturn, Type = "HARMFUL"}
        end
        if AuraReturn[7] ~= nil and AuraReturn[7] == "player" then
            DMW.Tables.AuraCache[GUID][AuraReturn[1]]["player"] = {["AuraReturn"] = AuraReturn, Type = "HARMFUL"}
        end
    end
end

function AuraCache.Event(...)
    local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags,
          spellID, spellName, spellSchool, auraType = ...
    if destGUID and
        (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_AURA_REMOVED_DOSE" or event ==
            "SPELL_AURA_REFRESH" or event == "SPELL_AURA_REMOVED" or event == "SPELL_PERIODIC_AURA_REMOVED" or
            (DurationLib.indirectRefreshSpells[spellName] and DurationLib.indirectRefreshSpells[spellName].events[event])) then
        DMW.Tables.AuraUpdate[destGUID] = true
    elseif event == "PARTY_KILL" then
        if DMW.Tables.AuraCache[destGUID] then DMW.Tables.AuraCache[destGUID] = nil end
    elseif event == "UNIT_DIED" or event == "UNIT_DESTROYED" then
        local guid = select(7, ...)
        if DMW.Tables.AuraCache[guid] then DMW.Tables.AuraCache[guid] = nil end
    elseif event == "SPELL_DISPEL" then
        local dispelledName = select(16, ...)
        if DMW.Tables.AuraCache[destGUID] and DMW.Tables.AuraCache[destGUID][dispelledName] then
            DMW.Tables.AuraCache[destGUID][dispelledName] = nil
        end
    end
end

function Buff:Query(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or false
    if not Unit then return nil end
    Unit = Unit.GUID
    if DMW.Tables.AuraCache[Unit] ~= nil and DMW.Tables.AuraCache[Unit][self.SpellName] ~= nil and
        (not OnlyPlayer or DMW.Tables.AuraCache[Unit][self.SpellName]["player"] ~= nil) then
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
    if not Unit then return nil end
    Unit = Unit.GUID
    if DMW.Tables.AuraCache[Unit] ~= nil and DMW.Tables.AuraCache[Unit][self.SpellName] ~= nil and
        (not OnlyPlayer or DMW.Tables.AuraCache[Unit][self.SpellName]["player"] ~= nil) then
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

