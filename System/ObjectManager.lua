local DMW = DMW
DMW.Enemies, DMW.Attackable, DMW.Units, DMW.Friends, DMW.GameObjects = {}, {}, {}, {}, {}
DMW.Friends.Units = {}
DMW.Friends.Tanks = {}
local Enemies, Attackable, Units, Friends, GameObjects = DMW.Enemies, DMW.Attackable, DMW.Units, DMW.Friends.Units, DMW.GameObjects
local Unit, LocalPlayer, GameObject = DMW.Classes.Unit, DMW.Classes.LocalPlayer, DMW.Classes.GameObject

function DMW.Remove(Pointer)
    local GUID
    if Units[Pointer] ~= nil then
        GUID = Units[Pointer].GUID
        Units[Pointer] = nil
    end
    if DMW.Tables.Swing.Units[Pointer] ~= nil then
        DMW.Tables.Swing.Units[Pointer] = nil
    end
    if DMW.Tables.TTD[Pointer] ~= nil then
        DMW.Tables.TTD[Pointer] = nil
    end
    if GUID and DMW.Tables.AuraCache[GUID] ~= nil then
        DMW.Tables.AuraCache[GUID] = nil
    end
    if GameObjects[Pointer] ~= nil then
        GameObjects[Pointer] = nil
    end
    if DMW.Tables.AuraUpdate[Pointer] then
        DMW.Tables.AuraUpdate[Pointer] = nil
    end
end

local function SortEnemies()
    local LowestHealth, HighestHealth, HealthNorm, EnemyScore, RaidTarget
    for _, v in pairs(Enemies) do
        if not LowestHealth or v.Health < LowestHealth then
            LowestHealth = v.Health
        end
        if not HighestHealth or v.Health > HighestHealth then
            HighestHealth = v.Health
        end
    end
    for _, v in pairs(Enemies) do
        HealthNorm = (10 - 1) / (HighestHealth - LowestHealth) * (v.Health - HighestHealth) + 10
        if HealthNorm ~= HealthNorm or tostring(HealthNorm) == tostring(0 / 0) then
            HealthNorm = 0
        end
        EnemyScore = HealthNorm
        if v.TTD > 1.5 then
            EnemyScore = EnemyScore + 5
        end
        RaidTarget = GetRaidTargetIndex(v.Pointer)
        if RaidTarget ~= nil then
            EnemyScore = EnemyScore + RaidTarget * 3
            if RaidTarget == 8 then
                EnemyScore = EnemyScore + 5
            end
        end
        v.EnemyScore = EnemyScore
    end
    if #Enemies > 1 then
        table.sort(
            Enemies,
            function(x, y)
                return x.EnemyScore > y.EnemyScore
            end
        )
        if UnitIsVisible("target") then
            table.sort(
                Enemies,
                function(x)
                    if UnitIsUnit(x.Pointer, "target") then
                        return true
                    else
                        return false
                    end
                end
            )
        end
    end
end

local function HandleFriends()
    table.wipe(DMW.Friends.Tanks)
    if #Friends > 1 then
        table.sort(
            Friends,
            function(x, y)
                return x.HP < y.HP
            end
        )
    end
    -- for _, Unit in pairs(Friends) do
    --     Unit.Role = UnitGroupRolesAssigned(Unit.Pointer)
    --     if Unit.Role == "TANK" then
    --         table.insert(DMW.Friends.Tanks, Unit)
    --     end
    -- end
end

local function UpdateUnits()
    table.wipe(Attackable)
    table.wipe(Enemies)
    table.wipe(Friends)
    DMW.Player.Target = nil
    -- DMW.Player.Focus = nil
    DMW.Player.Mouseover = nil
    DMW.Player.Pet = nil

    for Pointer, Unit in pairs(Units) do
        if not Unit.NextUpdate or Unit.NextUpdate < DMW.Time then
            Unit:Update()
        end
        if not DMW.Player.Target and UnitIsUnit(Pointer, "target") then
            DMW.Player.Target = Unit
        end
        if not DMW.Player.Mouseover and UnitIsUnit(Pointer, "mouseover") then
            DMW.Player.Mouseover = Unit
        end
        -- elseif not DMW.Player.Focus and UnitIsUnit(Pointer, "focus") then
        --     DMW.Player.Focus = Unit
        if DMW.Player.PetActive and not DMW.Player.Pet and UnitIsUnit(Pointer, "pet") then
            DMW.Player.Pet = Unit
        end
        if Unit.Attackable then
            table.insert(Attackable, Unit)
        end
        if Unit.ValidEnemy then
            table.insert(Enemies, Unit)
        end
        if Unit.Player and UnitIsUnit(Pointer, "player") then
            Unit:CalculateHP()
            table.insert(Friends, Unit)
        elseif DMW.Player.InGroup and Unit.Player and not Unit.Attackable and Unit.LoS and (UnitInRaid(Pointer) or UnitInParty(Pointer)) then
            Unit:CalculateHP()
            table.insert(Friends, Unit)
        end
    end
    SortEnemies()
    HandleFriends()
end

local function UpdateGameObjects()
    for _, Object in pairs(GameObjects) do
        if not Object.NextUpdate or Object.NextUpdate < DMW.Time then
            Object:Update()
        end
    end
end

function DMW.UpdateOM()
    local _, updated, added, removed = GetObjectCount(true)
    if updated and #removed > 0 then
        for _, v in pairs(removed) do
            DMW.Remove(v)
        end
    end
    if updated and #added > 0 then
        for _, v in pairs(added) do
            if ObjectIsUnit(v) and not Units[v] and UnitCreatureTypeID(v) ~= 8 then
                Units[v] = Unit(v)
            elseif ObjectIsGameObject(v) and not GameObjects[v] then
                GameObjects[v] = GameObject(v)
            end
        end
    end
    DMW.Player:Update()
    UpdateUnits()
    UpdateGameObjects()
end
