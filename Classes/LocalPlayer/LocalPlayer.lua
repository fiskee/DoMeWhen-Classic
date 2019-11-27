local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer
local LibCC = LibStub("LibClassicCasterinoDMW", true)

function LocalPlayer:New(Pointer)
    self.Pointer = Pointer
    self.CombatReach = UnitCombatReach(Pointer)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(Pointer)
    self.GUID = ObjectGUID(Pointer)
    self.Class = select(2, UnitClass(Pointer)):gsub("%s+", "")
    self.Distance = 0
    self.Combat = UnitAffectingCombat(self.Pointer) and DMW.Time or false
    self.CombatLeft = false
    self.EID = false
    self.NoControl = false
    self.Level = UnitLevel(Pointer)
    self:GetSpells()
    self:GetTalents()
    self.Equipment = {}
    self.Items = {}
   
    self.Looting = false
    self:UpdateEquipment()
    self:GetItems()
    if self.Class == "WARRIOR" then
        self.OverpowerUnit = {}
        self.RevengeUnit = {}
    elseif self.Class == "SHAMAN" then
        self.Totems = {}
        self.Totems.Fire = {}
        self.Totems.Earth = {}
        self.Totems.Water = {}
        self.Totems.Air = {}
        for i = 1, MAX_TOTEMS do
            self:UpdateTotems(i)
        end
    end
    self.SwingMH = 0
    self.SwingOH = false
    DMW.Helpers.Queue.GetBindings()
end


-- local scanTool = CreateFrame( "GameTooltip", "ScanTooltip", nil, "GameTooltipTemplate" )
-- scanTool:SetOwner( WorldFrame, "ANCHOR_NONE" )
-- local function findOwnTotem(unit)
--     scanTool:ClearLines()
--     scanTool:SetUnit(unit)
--     local scanText = _G["ScanTooltipTextLeft2"]
--     local ownerText = scanText:GetText()
--     if not ownerText then return nil end
--     local owner, _ = string.split("'",ownerText)
--     if owner == UnitName("player") then
--         return true         
--     end
-- end

-- local tooltipAbuse = CreateFrame( "GameTooltip", "tooltipAbuse", nil, "GameTooltipTemplate" )
-- tooltipAbuse:SetOwner( WorldFrame, "ANCHOR_NONE" );

-- local function getOwner(unit)
--     tooltipAbuse:SetUnit(unit)
--     for i = 1, tooltipAbuse:NumLines() do
--         local mytext=_G["tooltipAbuseTextLeft"..i]
--         local text=mytext:GetText()

--         print(text)
--         local mytext=_G["tooltipAbuseTextRight"..i]
--         local text=mytext:GetText()
--         if text then
--         print("RRR"..text)
--         end
--     end
--     local ownerText = _G["tooltipAbuseTextLeft2"]:GetText()
--     if ownerText ~= nil then
--         local owner, _ = string.split("'",ownerText)
--         print(owner)
--         return owner
--     end
-- end

-- local oldFunction = getOwner
-- getOwner = function(...)
--    return EWTUnlock('getOwner', oldFunction, ...)
-- end



function LocalPlayer:Update()
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    DMW.Functions.AuraCache.Refresh(self.Pointer)
    self.Health = UnitHealth(self.Pointer)
    self.HealthMax = UnitHealthMax(self.Pointer)
    self.HP = self.Health / self.HealthMax * 100
    self.Casting = CastingInfo(self.Pointer) or ChannelInfo(self.Pointer)
    self.Power = UnitPower(self.Pointer)
    self.Power = self:PredictedPower()
    self.PowerMax = UnitPowerMax(self.Pointer)
    self.PowerDeficit = self.PowerMax - self.Power
    self.PowerPct = self.Power / self.PowerMax * 100
    self.PowerRegen = GetPowerRegen()
    if not self.Combat and UnitAffectingCombat("player") then
        self.Combat = DMW.Time
    end
    if self.Class == "ROGUE" or self.Class == "DRUID" then
        self.ComboPoints = GetComboPoints("player", "target")
        self.ComboMax = 5 --UnitPowerMax(self.Pointer, 4)
        self.ComboDeficit = self.ComboMax - self.ComboPoints
        if self.TickTime and DMW.Time >= self.TickTime then
            self.TickTime = self.TickTime + 2
        end
        if self.TickTime then
            self.NextTick = self.TickTime - DMW.Time
        end
    end
    self.Instance = select(2, IsInInstance())
    self.Moving = self:HasMovementFlag(DMW.Enums.MovementFlags.Moving)
    self.PetActive = UnitIsVisible("pet")
    self.InGroup = IsInGroup()
    self.CombatTime = self.Combat and (DMW.Time - self.Combat) or 0
    self.CombatLeftTime = self.CombatLeft and (DMW.Time - self.CombatLeft) or 0
    if self.DOTed then
        local count = 0
        for spell in pairs(self.DOTed) do
            count = count + 1
            if DMW.Time > self.DOTed[spell] then
                self.DOTed[spell] = nil
            end
        end
        if count == 0 then 
            self.DOTed = nil
        end
    end
    if CastingInfo() then
        local _,_,_,_,endTime = CastingInfo()
        self.CastLeft = endTime/1000 - DMW.Time
    elseif ChannelInfo() then
        local _,_,_,_,endTime = ChannelInfo()
        self.CastLeft = endTime/1000 - DMW.Time
    else
        self.CastLeft = nil
    end
end

function LocalPlayer:UpdateTotems(slot)
    local haveTotem, totemName, startTime, duration, icon = GetTotemInfo(slot)
    if slot == 1 then
        table.wipe(self.Totems.Fire)
    elseif slot == 2 then
        table.wipe(self.Totems.Earth)
    elseif slot == 3 then
        table.wipe(self.Totems.Water)
    elseif slot == 4 then
        table.wipe(self.Totems.Air)
    end
    if haveTotem then
        for k,v in pairs(DMW.Units) do
            if v.Name == totemName and ObjectCreator(v.Pointer) == self.Pointer then
                local shorty = string.gsub(totemName:match(".*Totem"), "%s", "")
                if slot == 1 then
                    self.Totems.Fire[shorty] = v
                    self.Totems.Fire[shorty]["Expire"] = startTime + duration
                    self.Totems.Fire["PosX"] = v.PosX
                    self.Totems.Fire["PosY"] = v.PosY
                    self.Totems.Fire["PosZ"] = v.PosZ
                elseif slot == 2 then
                    self.Totems.Earth[shorty] = v
                    self.Totems.Earth[shorty]["Expire"] = startTime + duration
                    self.Totems.Earth["PosX"] = v.PosX
                    self.Totems.Earth["PosY"] = v.PosY
                    self.Totems.Earth["PosZ"] = v.PosZ
                elseif slot == 3 then
                    self.Totems.Water[shorty] = v
                    self.Totems.Water[shorty]["Expire"] = startTime + duration
                    self.Totems.Water["PosX"] = v.PosX
                    self.Totems.Water["PosY"] = v.PosY
                    self.Totems.Water["PosZ"] = v.PosZ
                elseif slot == 4 then
                    self.Totems.Air[shorty] = v
                    self.Totems.Air[shorty]["Expire"] = startTime + duration
                    self.Totems.Air["PosX"] = v.PosX
                    self.Totems.Air["PosY"] = v.PosY
                    self.Totems.Air["PosZ"] = v.PosZ
                end
                break
            end
        end 
    end
end

function LocalPlayer:PredictedPower()
    if self.Casting then
        local SpellID = select(9, CastingInfo("player"))
        if SpellID then
            local CostTable = GetSpellPowerCost(SpellID)
            if CostTable then
                for _, CostInfo in pairs(CostTable) do
                    if CostInfo.cost > 0 then
                        return (self.Power - CostInfo.cost)
                    end
                end
            end
        end
    end
    return self.Power
end

local GCDList = {
    DRUID = {
        NONE = 5176,
        CAT = 5221,
    },
    HUNTER = 1978,
    MAGE = 133,
    PALADIN = 635,
    PRIEST = 2050,
    ROGUE = 1752,
    SHAMAN = 403,
    WARLOCK = 348,
    WARRIOR = 772,
}

function LocalPlayer:GCDRemain()
    local GCDSpell = 61304
    if self.Class == "DRUID" then
        if self:AuraByID(768,true) then GCDSpell = GCDList[self.Class].CAT else GCDSpell = GCDList[self.Class].NONE end
    else
        GCDSpell = GCDList[self.Class]
    end
    local Start, CD = GetSpellCooldown(GCDSpell)
    if Start == 0 then
        return 0
    end
    return math.max(0, (Start + CD) - DMW.Time)
end

function LocalPlayer:StanceGCDRemain()
    local GCDSpell = 2457
    -- if self.Class == "DRUID" then
    --     if self:AuraByID(768,true) then GCDSpell = GCDList[self.Class].CAT else GCDSpell = GCDList[self.Class].NONE end
    -- else
    --     GCDSpell = GCDList[self.Class]
    -- end
    local Start, CD = GetSpellCooldown(GCDSpell)
    if Start == 0 then
        return 0
    end
    return math.max(0, (Start + CD) - DMW.Time)
end

function LocalPlayer:GCD()
    if self.Class == "ROGUE" or (self.Class == "DRUID" and self:AuraByID(768,true)) then
        return 1
    else
        return 1.5
    end
end

function LocalPlayer:CDs()
    if DMW.Settings.profile.HUD.CDs and DMW.Settings.profile.HUD.CDs == 3 then
        return false
    elseif DMW.Settings.profile.HUD.CDs and DMW.Settings.profile.HUD.CDs == 2 then
        return true
    elseif self.Target and self.Target:IsBoss() then
        return true
    end
    return false
end

function LocalPlayer:CritPct()
    return GetCritChance()
end

function LocalPlayer:TTM()
    local PowerMissing = self.PowerMax - self.Power
    if PowerMissing > 0 then
        return PowerMissing / self.PowerRegen
    else
        return 0
    end
end

function LocalPlayer:Standing()
    if ObjectDescriptor("player", GetOffset("CGUnitData__AnimTier"), Types.Byte) == 0 then
        return true
    end
    return false
end

function LocalPlayer:Dispel(Spell)
    local AuraCache = DMW.Tables.AuraCache[self.Pointer]
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
        if Aura.Type == "HARMFUL" then
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

function LocalPlayer:HasFlag(Flag)
    return bit.band(ObjectDescriptor(self.Pointer, GetOffset("CGUnitData__Flags"), "int"), Flag) > 0
end

function LocalPlayer:IsFeared()
    return self:HasFlag(DMW.Enums.UnitFlags.PreventKneelingWhenLooting)
end

function LocalPlayer:AuraByID(SpellID, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or false
    local SpellName = GetSpellInfo(SpellID)
    local Pointer = self.Pointer
    if DMW.Tables.AuraCache[Pointer] ~= nil and DMW.Tables.AuraCache[Pointer][SpellName] ~= nil and (not OnlyPlayer or DMW.Tables.AuraCache[Pointer][SpellName]["player"] ~= nil) then
        local AuraReturn
        if OnlyPlayer then
            AuraReturn = DMW.Tables.AuraCache[Pointer][SpellName]["player"].AuraReturn
        else
            AuraReturn = DMW.Tables.AuraCache[Pointer][SpellName].AuraReturn
        end
        return unpack(AuraReturn)
    end
    return nil
end
function LocalPlayer:AuraByName(SpellName, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or false
    local SpellName = SpellName
    local Pointer = self.Pointer
    if DMW.Tables.AuraCache[Pointer] ~= nil and DMW.Tables.AuraCache[Pointer][SpellName] ~= nil and (not OnlyPlayer or DMW.Tables.AuraCache[Pointer][SpellName]["player"] ~= nil) then
        local AuraReturn
        if OnlyPlayer then
            AuraReturn = DMW.Tables.AuraCache[Pointer][SpellName]["player"].AuraReturn
        else
            AuraReturn = DMW.Tables.AuraCache[Pointer][SpellName].AuraReturn
        end
        return unpack(AuraReturn)
    end
    return nil
end

function LocalPlayer:HasMovementFlag(Flag)
    local SelfFlag = UnitMovementFlags(self.Pointer)
    if SelfFlag then
        return bit.band(UnitMovementFlags(self.Pointer), Flag) > 0
    end
    return false
end