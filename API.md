Note not all functions work in classic yet

# Unit
## Constants
- .Pointer
- .Name
- .GUID
- .Player
- .Friend
- .CombatReach
- .ObjectID
- .Level
- .CreatureType

## Variables
- .PosX
- .PosY
- .PosZ
- .Distance
- .Dead
- .Health
- .HealthMax
- .HP
- .RealHealth
- .TTD
- .LoS
- .Attackable
- .ValidEnemy
- .Target
- .Moving
- .Facing
- .Quest

## Functions
- :GetDistance(OtherUnit)
- :LineOfSight(OtherUnit)
- :IsEnemy()
- :IsBoss()
- :HasThreat()
- :GetEnemies(Yards, TTD)
- :GetFriends(Yards, HP)
- :HardCC()
- :Interrupt()
- :Dispel(Spell)
- :PredictPosition(Time)
- :AuraByID(SpellID, OnlyPlayer)
- :CCed()
- :IsQuest()
- :GetTTD(targetPercentage)
- :CastingInfo()
- :ChannelInfo()
- :UnitDetailedThreatSituation(OtherUnit)
- :UnitThreatSituation(OtherUnit)
- :IsTanking()
- :HasMovementFlag(Flag)
- :UpdatePosition()

# Player
## Constants
- .Pointer
- .Name
- .GUID
- .Class
- .CombatReach

## Variables
- .PosX
- .PosY
- .PosZ
- .Health
- .HealthMax
- .HP
- .EID
- .Power
- .PowerMax
- .PowerDeficit
- .PowerPct
- .PowerRegen
- .ComboPoints
- .ComboMax
- .ComboDeficit
- .Instance
- .Casting
- .Moving
- .PetActive
- .InGroup
- .CombatTime
- .CombatLeftTime
- .SwingLast
- .SwingNext
- .Resting

## Functions
- :GCDRemain()
- :GCD()
- :CDs()
- :CritPct()
- :TTM()
- :GetEnemy(Yards, Facing)
- :AutoTarget(Yards, Facing)
- :AutoTargetQuest(Yards, Facing)
- :AutoTargetAny(Yards, Facing)
- :GetEnemies(Yards)
- :GetAttackable(Yards)
- :GetEnemiesRect(Length, Width, TTD)
- :GetEnemiesCone(Length, Angle, TTD)
- :GetFriends(Yards, HP)
- :GetFriendsCone(Length, Angle, HP)
- :IsTanking()
- :HasMovementFlag(Flag)

## Tables
- Buffs
- Debuffs
- Equipment
- Items
- LastCast
- Spells
- Talents

# Buff/Debuff
## Constants
- .Ranks[]
- .SpellID
- .SpellName
- .BaseDuration

## Functions
- :Exist(Unit, OnlyPlayer)
- :Remain(Unit, OnlyPlayer)
- :Duration(Unit, OnlyPlayer)
- :Elapsed(Unit, OnlyPlayer)
- :Refresh(Unit, OnlyPlayer)
- :Stacks(Unit, OnlyPlayer)
- :Rank(Unit, OnlyPlayer)
- :Count(Table)
- :Lowest(Table)
- :HighestKnown()
- :Query(Unit, OnlyPlayer)

# Spell
## Constants
- .Ranks[]
- .SpellID
- .SpellName
- .BaseCD
- .BaseGCD
- .MinRange
- .MaxRange
- .CastType
- .IsHarmful
- .IsHelpful

## Functions
- :Cost(Rank)
- :CD(Rank)
- :IsReady(Rank)
- :Charges()
- :ChargesFrac()
- :RechargeTime()
- :FullRechargeTime()
- :CastTime(Rank)
- :LastCast(Index)
- :Cast(Unit, Rank)
- :CastPool(Unit, Extra, Rank)
- :CastGround(X, Y, Z, Rank)
- :Known(Rank)
- :Usable(Rank)
- :HighestRank()

# Item
## Constants
- .ItemID
- .ItemName
- .SpellName
- .SpellID

## Functions
- :Equipped()
- :CD(Rank)
- :IsReady(Rank)
- :Use(Unit)