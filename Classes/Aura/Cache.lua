local DMW = DMW
DMW.Tables.AuraCache = {}
DMW.Tables.AuraUpdate = {}
DMW.Functions.AuraCache = {}
local AuraCache = DMW.Functions.AuraCache
local Buff = DMW.Classes.Buff
local Debuff = DMW.Classes.Debuff
local DurationLib = LibStub("LibClassicDurationsDMW")
DurationLib:Register("DMW")

local f = CreateFrame("Frame", nil, UIParent)
f:SetScript("OnEvent", function(self, event, ...) return self[event](self, event, ...) end)
DurationLib.RegisterCallback("DMW", "UNIT_BUFF", function(event, unit) f:UNIT_AURA(event, unit) end)

function f:UNIT_AURA(event, unit)
    local UnitAura = DurationLib.UnitAuraWithBuffs
    local unitGUID
    for i = 1, 100 do
        AuraReturn = {UnitAura(unit, i, "HELPFUL")}
        if AuraReturn[10] == nil then break end
        -- print(AuraReturn[10].."  ".. unit)
        if DMW.Enums.DispelTypes.Magic[AuraReturn[10]] then AuraReturn[4] = "Magic" end
        if not unitGUID then unitGUID = UnitGUID(unit) end
        -- print(AuraReturn[1] .. "  " .. unit)
        if DMW.Tables.AuraCache[unitGUID] == nil then DMW.Tables.AuraCache[unitGUID] = {} end
        -- if DMW.Tables.AuraCache[Unit] == nil then
        --     DMW.Tables.AuraCache[Unit] = {}
        -- end
        if DMW.Tables.AuraCache[unitGUID][AuraReturn[1]] == nil then
            DMW.Tables.AuraCache[unitGUID][AuraReturn[1]] = {["AuraReturn"] = AuraReturn, Type = "HELPFUL"}
        end
    end
end

function AuraCache.Refresh(Unit, GUID)
    if DMW.Tables.AuraCache[GUID] and not UnitCanAttack("player", Unit) then table.wipe(DMW.Tables.AuraCache[GUID]) end
    local AuraReturn, Name, Source, DurationNew, ExpirationTimeNew
    for i = 1, 40 do
        AuraReturn = {UnitAura(Unit, i, "HELPFUL")}
        if AuraReturn[10] == nil then break end
        if DMW.Tables.AuraCache[GUID] == nil then DMW.Tables.AuraCache[GUID] = {} end
        Name, Source = GetSpellInfo(AuraReturn[10]), AuraReturn[7]
        DurationNew, ExpirationTimeNew = DurationLib:GetAuraDurationByUnit(Unit, AuraReturn[10], Source, Name)
        if AuraReturn[5] == 0 and DurationNew then
            AuraReturn[5] = DurationNew
            AuraReturn[6] = ExpirationTimeNew
        end
        if DMW.Tables.AuraCache[GUID][Name] == nil then
            DMW.Tables.AuraCache[GUID][Name] = {["AuraReturn"] = AuraReturn, Type = "HELPFUL"}
        end
        if Source ~= nil and Source == "player" then
            DMW.Tables.AuraCache[GUID][Name]["player"] = {["AuraReturn"] = AuraReturn, Type = "HELPFUL"}
        end
    end

    for i = 1, 40 do
        AuraReturn = {UnitAura(Unit, i, "HARMFUL")}
        if AuraReturn[10] == nil then break end
        if DMW.Tables.AuraCache[GUID] == nil then DMW.Tables.AuraCache[GUID] = {} end
        Name, Source = GetSpellInfo(AuraReturn[10]), AuraReturn[7]
        DurationNew, ExpirationTimeNew = DurationLib:GetAuraDurationByUnit(Unit, AuraReturn[10], Source, Name)
        if AuraReturn[5] == 0 and DurationNew then
            AuraReturn[5] = DurationNew
            AuraReturn[6] = ExpirationTimeNew
        end
        if DMW.Tables.AuraCache[GUID][Name] == nil then
            DMW.Tables.AuraCache[GUID][Name] = {["AuraReturn"] = AuraReturn, Type = "HARMFUL"}
        end
        if Source ~= nil and Source == "player" then
            DMW.Tables.AuraCache[GUID][Name]["player"] = {["AuraReturn"] = AuraReturn, Type = "HARMFUL"}
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
        -- AuraCache.Refresh(dest)
    elseif event == "PARTY_KILL" then
        if DMW.Tables.AuraCache[destGUID] then DMW.Tables.AuraCache[destGUID] = nil end
    elseif event == "UNIT_DIED" or event == "UNIT_DESTROYED" then
        local guid = select(7, ...)
        -- print(...)
        if DMW.Tables.AuraCache[guid] then DMW.Tables.AuraCache[guid] = nil end
        -- elseif event:find("_DISPEL") then
    elseif event == "SPELL_DISPEL" then
        -- print(...)
        local dispelledName = select(16, ...)
        -- 1576667439.76 SPELL_DISPEL false Player-4467-0120155A Saaulgoodman 1297 0 Player-4467-0125A6DC Baddger 66888 0 0 Purge 8 0 Strength 8 BUFF
        -- 1575338566.183 SPELL_DISPEL false Player-4467-0125A6DC Baddger 1298 0 Creature-0-4469-429-19972-11458-000465C1E4 Petrified Treant 2632 0 0 Shield Slam 1 0 Harden Skin 8 BUFF
        if DMW.Tables.AuraCache[destGUID][dispelledName] then DMW.Tables.AuraCache[destGUID][dispelledName] = nil end
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

