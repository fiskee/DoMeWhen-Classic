local DMW = DMW
local Unit = DMW.Classes.Unit
local LibCC = LibStub("LibClassicCasterinoDMW", true)
local DurationLib = LibStub("LibClassicDurationsDMW")

function Unit:New(Pointer)
    self.Pointer = Pointer
    self.Name = not UnitIsUnit(Pointer, "player") and UnitName(Pointer) or "LocalPlayer"
    self.GUID = UnitGUID(Pointer)
    self.Player = UnitIsPlayer(Pointer)
    if self.Player then
        self.Class = select(2, UnitClass(Pointer)):gsub("%s+", "")
    end
    self.LoSCache = {}
    self.Friend = UnitIsFriend("player", self.Pointer)
    self.CombatReach = UnitCombatReach(Pointer)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(Pointer)
    self.ObjectID = ObjectID(Pointer)
    self.Level = UnitLevel(Pointer)
    self.DistanceAggro = self:AggroDistance()
    self.CreatureType = DMW.Enums.CreatureType[UnitCreatureTypeID(Pointer)]
    self.Classification = UnitClassification(Pointer)
    DMW.Functions.AuraCache.Refresh(Pointer, self.GUID)
    --DurationLib
    DurationLib.nameplateUnitMap[self.GUID] = Pointer
    -- DurationLib.nameplateUnitMapBackwards[Pointer] = self.GUID
    DMW.Tables.guid2pointer[self.GUID] = Pointer
    DMW.Tables.pointer2guid[Pointer] = self.GUID
end

function Unit:Update()
    if DMW.Player.Resting then
        self.NextUpdate = DMW.Time + (math.random(100, 1500) / 1000)
    else
        self.NextUpdate = DMW.Time + (math.random(300, 1500) / 10000)
    end
    self:UpdatePosition()
    if DMW.Tables.AuraUpdate[self.GUID] then
        DMW.Functions.AuraCache.Refresh(self.Pointer, self.GUID)
        DMW.Tables.AuraUpdate[self.GUID] = nil
    end
    self.Distance = self:GetDistance()
    if RealMobHealth_CreatureHealthCache and self.ObjectID and RealMobHealth_CreatureHealthCache[self.ObjectID .. "-" .. self.Level] then
        self.HealthMax = RealMobHealth_CreatureHealthCache[self.ObjectID .. "-" .. self.Level]
        self.RealHealth = true
        self.Health = self.HealthMax * (UnitHealth(self.Pointer) / 100)
    else
        self.HealthMax = UnitHealthMax(self.Pointer)
        if self.HealthMax ~= 100 then
            self.RealHealth = true
        else
            self.RealHealth = false
        end
        self.Health = UnitHealth(self.Pointer)
    end
    self.HP = self.Health / self.HealthMax * 100
    self.Dead = self.HP == 0 or UnitIsDeadOrGhost(self.Pointer)
    self.TTD = self:GetTTD()
    self.LoS = false
    if self.Distance < 50 and not self.Dead then
        self.LoS = self:LineOfSight()
    end
    self.CanAttack = UnitCanAttack("player", self.Pointer)
    self.Attackable = self.LoS and self.CanAttack or false
    self.ValidEnemy = self.Attackable and self:IsEnemy() or false
    self.Target = UnitTarget(self.Pointer)
    self.Moving = self:HasMovementFlag(DMW.Enums.MovementFlags.Moving)
    self.Facing = UnitIsFacing("Player", self.Pointer, 90)
    self.Quest = self:IsQuest()
    self.Trackable = self:IsTrackable()
    if self.Name == "Unknown" then
        self.Name = UnitName(self.Pointer)
    end
    if self.Attackable and not self.Player then
        DMW.Helpers.Swing.AddUnit(self.Pointer)
    end
    -- if self.ValidEnemy and not self:AuraByID(1020) then
    --     self.ValidEnemy = false
    -- end
end

function Unit:UpdatePosition()
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
end

function Unit:LineOfSight(OtherUnit)
    if DMW.Enums.LoS[self.ObjectID] then
        return true
    end
    OtherUnit = OtherUnit or DMW.Player
    if self.LoSCache.Result ~= nil and self.PosX == self.LoSCache.PosX and self.PosY == self.LoSCache.PosY and self.PosZ == self.LoSCache.PosZ and OtherUnit.PosX == self.LoSCache.OPosX and OtherUnit.PosY == self.LoSCache.OPosY and OtherUnit.PosZ == self.LoSCache.OPosZ then
        return self.LoSCache.Result
    end
    self.LoSCache.Result = TraceLine(self.PosX, self.PosY, self.PosZ + 2, OtherUnit.PosX, OtherUnit.PosY, OtherUnit.PosZ + 2, 0x100010) == nil
    self.LoSCache.PosX, self.LoSCache.PosY, self.LoSCache.PosZ = self.PosX, self.PosY, self.PosZ
    self.LoSCache.OPosX, self.LoSCache.OPosY, self.LoSCache.OPosZ = OtherUnit.PosX, OtherUnit.PosY, OtherUnit.PosZ
    return self.LoSCache.Result
end

function Unit:IsEnemy()
    return self.LoS and self.Attackable and self:HasThreat() and ((not self.Friend and not self:CCed()) or UnitIsUnit(self.Pointer, "target"))
end

function Unit:IsBoss()
    if self.Classification == "worldboss" or self.Classification == "rareelite" then
        return true
    elseif LibStub("LibBossIDs-1.0").BossIDs[self.ObjectID] then
        return true
    elseif DMW.Player.EID then
        for i = 1, 5 do
            if UnitIsUnit("boss" .. i, self.Pointer) then
                return true
            end
        end
    end
    return false
end

function Unit:HasThreat()
    if DMW.Enums.Threat[self.ObjectID] then
        return true
    elseif DMW.Enums.EnemyBlacklist[self.ObjectID] then
        return false
    elseif DMW.Player.Instance ~= "none" and UnitAffectingCombat(self.Pointer) then
        return true
    elseif DMW.Player.Instance == "none" and (DMW.Enums.Dummy[self.ObjectID] or (UnitIsVisible("target") and UnitIsUnit(self.Pointer, "target"))) then
        return true
    end
    if not self.Player and self.Target and (UnitIsUnit(self.Target, "player") or UnitIsUnit(self.Target, "pet") or UnitInParty(self.Target) or UnitInRaid(self.Target) ~= nil) then
        return true
    end
    return false
end

function Unit:GetEnemies(Yards, TTD, RawDistance)
    local Table = {}
    local Count = 0
    TTD = TTD or 0
    for _, Unit in pairs(DMW.Enemies) do
        if RawDistance and self:RawDistance(v) <= Yards and Unit.TTD >= TTD then
            table.insert(Table, Unit)
            Count = Count + 1
        elseif self:GetDistance(Unit) <= Yards and Unit.TTD >= TTD then
            table.insert(Table, Unit)
            Count = Count + 1
        end
    end
    return Table, Count
end

function Unit:GetFriends(Yards, HP, RawDistance)
    local Table = {}
    local Count = 0
    -- local RawDist = RawDistance or false
    for _, v in pairs(DMW.Friends.Units) do
        if RawDistance and (not HP or v.HP < HP) and self:RawDistance(v) <= Yards then
            table.insert(Table, v)
            Count = Count + 1
        elseif (not HP or v.HP < HP) and self:GetDistance(v) <= Yards then
            table.insert(Table, v)
            Count = Count + 1
        end
    end
    return Table, Count
end

function Unit:HardCC()
    if DMW.Enums.HardCCUnits[self.ObjectID] then
        return true
    end
    local Settings = DMW.Settings.profile
    local StartTime, EndTime, SpellID, Type
    local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = self:CastingInfo()
    if name then
        StartTime = startTime / 1000
        SpellID = spellID
    else
        name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID = self:ChannelInfo()
        if name then
            StartTime = startTime / 1000
            SpellID = spellID
        end
    end
    if StartTime and SpellID and DMW.Enums.HardCCCasts[SpellID] then
        local Delay = Settings.Enemy.InterruptDelay - 0.2 + (math.random(1, 4) / 10)
        if Delay < 0.1 then
            Delay = 0.1
        end
        if (DMW.Time - StartTime) > Delay then
            return true
        end
    end
    return false
end

function Unit:Interrupt()
    local InterruptTarget = DMW.Settings.profile.Enemy.InterruptTarget
    if DMW.Settings.profile.HUD.Interrupts == 2 or (InterruptTarget == 2 and not UnitIsUnit(self.Pointer, "target")) then
        return false
    end
    local Settings = DMW.Settings.profile
    local StartTime, EndTime, SpellID, Type
    local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = self:CastingInfo()
    if name then
        if endTime and not notInterruptible then
            StartTime = startTime / 1000
            EndTime = endTime / 1000
            SpellID = spellID
            Type = "Cast"
        end
    else
        name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID = self:ChannelInfo()
        if name then
            if endTime and not notInterruptible then
                StartTime = startTime / 1000
                SpellID = spellID
                Type = "Channel"
            end
        else
            return false
        end
    end
    if not DMW.Enums.InterruptBlacklist[SpellID] then
        local Delay = 0
        if (DMW.Time - StartTime) > Delay then
            return true
        end
    end
    return false
end

function Unit:Dispel(Spell)
    local AuraCache = DMW.Tables.AuraCache[self.GUID]
    if not AuraCache or not Spell then
        return false
    end
    local DispelTypes = {}
    for k, v in pairs(DMW.Enums.DispelSpells[Spell.SpellID]) do
        DispelTypes[v] = true
    end
    local Elapsed
    local Delay = DMW.Settings.profile.Friend.DispelDelay - 0.2 + (math.random(1, 4) / 10)
    local ReturnValue = false
    --name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId
    local AuraReturn
    for _, Aura in pairs(AuraCache) do
        if (self.Friend and Aura.Type == "HARMFUL") or (not self.Friend and Aura.Type == "HELPFUL") then
            AuraReturn = Aura.AuraReturn
            Elapsed = AuraReturn[5] - (AuraReturn[6] - DMW.Time)
            if AuraReturn[4] and DispelTypes[AuraReturn[4]] and Elapsed > Delay then
                if DMW.Enums.NoDispel[AuraReturn[10]] then
                    ReturnValue = false
                    break
                elseif DMW.Enums.SpecialDispel[AuraReturn[10]] and DMW.Enums.SpecialDispel[AuraReturn[10]].Stacks then
                    if AuraReturn[3] >= DMW.Enums.SpecialDispel[AuraReturn[10]].Stacks then
                        ReturnValue = true
                    else
                        ReturnValue = false
                        break
                    end
                elseif DMW.Enums.SpecialDispel[AuraReturn[10]] and DMW.Enums.SpecialDispel[AuraReturn[10]].Range then
                    if select(2, self:GetFriends(DMW.Enums.SpecialDispel[AuraReturn[10]].Range)) < 2 then
                        ReturnValue = true
                    else
                        ReturnValue = false
                        break
                    end
                else
                    ReturnValue = true
                end
            end
        end
    end
    return ReturnValue
end

function Unit:PredictPosition(Time)
    local MoveDistance = GetUnitSpeed(self.Pointer) * Time
    if MoveDistance > 0 then
        local X, Y, Z = self.PosX, self.PosY, self.PosZ
        local Angle = ObjectFacing(self.Pointer)
        local UnitTargetDist = 0
        if self.Target then
            local TX, TY, TZ = ObjectPosition(self.Target)
            local TSpeed = GetUnitSpeed(self.Target)
            if TSpeed > 0 then
                local TMoveDistance = TSpeed * Time
                local TAngle = ObjectFacing(self.Target)
                TX = TX + cos(TAngle) * TMoveDistance
                TY = TY + sin(TAngle) * TMoveDistance
            end
            UnitTargetDist = sqrt(((TX - X) ^ 2) + ((TY - Y) ^ 2) + ((TZ - Z) ^ 2)) - ((self.CombatReach or 0) + (UnitCombatReach(self.Target) or 0))
            if UnitTargetDist < MoveDistance then
                MoveDistance = UnitTargetDist
            end
            Angle = rad(atan2(TY - Y, TX - X))
            if Angle < 0 then
                Angle = rad(360 + atan2(TY - Y, TX - X))
            end
        end
        X = X + cos(Angle) * MoveDistance
        Y = Y + cos(Angle) * MoveDistance
        return X, Y, Z
    end
    return self.X, self.Y, self.Z
end

function Unit:AuraByID(SpellID, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or false
    local SpellName = GetSpellInfo(SpellID)
    if DMW.Tables.AuraCache[self.GUID] ~= nil and DMW.Tables.AuraCache[self.GUID][SpellName] ~= nil and (not OnlyPlayer or DMW.Tables.AuraCache[self.GUID][SpellName]["player"] ~= nil) then
        local AuraReturn
        if OnlyPlayer then
            AuraReturn = DMW.Tables.AuraCache[self.GUID][SpellName]["player"].AuraReturn
        else
            AuraReturn = DMW.Tables.AuraCache[self.GUID][SpellName].AuraReturn
        end
        return unpack(AuraReturn)
    end
    return nil
end

function Unit:AuraByName(SpellName, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or false
    local SpellName = SpellName
    if DMW.Tables.AuraCache[self.GUID] ~= nil and DMW.Tables.AuraCache[self.GUID][SpellName] ~= nil and (not OnlyPlayer or DMW.Tables.AuraCache[self.GUID][SpellName]["player"] ~= nil) then
        local AuraReturn
        if OnlyPlayer then
            AuraReturn = DMW.Tables.AuraCache[self.GUID][SpellName]["player"].AuraReturn
        else
            AuraReturn = DMW.Tables.AuraCache[self.GUID][SpellName].AuraReturn
        end
        return unpack(AuraReturn)
    end
    return nil
end

function Unit:CCed()
    for SpellID, _ in pairs(DMW.Enums.CCBuffs) do
        if self:AuraByID(SpellID) then
            return true
        end
    end
    return false
end

function Unit:IsQuest()
    if self.ObjectID and DMW.Settings.profile.Tracker.QuestieHelper and DMW.QuestieTooltips and DMW.QuestieTooltips.tooltipLookup["m_" .. self.ObjectID] then
        for _, Tooltip in pairs(DMW.QuestieTooltips.tooltipLookup["m_" .. self.ObjectID]) do
            Tooltip.Objective:Update()
            if not Tooltip.Objective.Completed then
                return true
            end
        end
    end
    return false
end

function Unit:CastingInfo()
    return LibCC:UnitCastingInfo(self.Pointer)
end

function Unit:ChannelInfo()
    return LibCC:UnitChannelInfo(self.Pointer)
end

function Unit:IsTrackable()
    if DMW.Settings.profile.Tracker.TrackUnits ~= nil and DMW.Settings.profile.Tracker.TrackUnits ~= "" and not self.Player then
        for k in string.gmatch(DMW.Settings.profile.Tracker.TrackUnits, "([^,]+)") do
            if strmatch(string.lower(self.Name), string.lower(string.trim(k))) then
                return true
            end
        end
    elseif self.Player and (DMW.Settings.profile.Tracker.TrackPlayersAny and DMW.Player.Pointer ~= self.Pointer) or (DMW.Settings.profile.Tracker.TrackPlayersEnemy and UnitCanAttack("player", self.Pointer)) then
        return true
    elseif self.Player and DMW.Settings.profile.Tracker.TrackPlayers ~= nil and DMW.Settings.profile.Tracker.TrackPlayers ~= "" then
        for k in string.gmatch(DMW.Settings.profile.Tracker.TrackPlayers, "([^,]+)") do
            if strmatch(string.lower(self.Name), string.lower(string.trim(k))) then
                return true
            end
        end
    end
    return false
end

function Unit:PowerPct()
    local Power = UnitPower(self.Pointer)
    local PowerMax = UnitPowerMax(self.Pointer)
    return Power / PowerMax * 100
end

function Unit:HasFlag(Flag)
    return bit.band(ObjectDescriptor(self.Pointer, GetOffset("CGUnitData__Flags"), "int"), Flag) > 0
end

function Unit:IsFeared()
    return self:HasFlag(DMW.Enums.UnitFlags.Feared)
end

function Unit:HasNPCFlag(Flag)
    if not self.NPCFlags then
        self.NPCFlags = ObjectDescriptor(self.Pointer, GetOffset("CGUnitData__NPCFlags"), "int")
    end
    return bit.band(self.NPCFlags, Flag) > 0
end

function Unit:HasMovementFlag(Flag)
    local SelfFlag = UnitMovementFlags(self.Pointer)
    if SelfFlag then
        return bit.band(UnitMovementFlags(self.Pointer), Flag) > 0
    end
    return false
end

function Unit:CanBeFeared()
    local table = DMW.Enums.FearImmuneBuffs
    for i = 1, #table do
        if self:AuraByID(table[i]) then
            return false
        end
    end
    return self.Attackable and self:IsEnemy()
end

function Unit:IsImmune(immuneType)
    if not immuneType then return false end
    if immuneType == "Bleed" 
        and (self.CreatureType == "Mechanical" or self.CreatureType == "Elemental") 
    then
        return true
    end
    return false
end
