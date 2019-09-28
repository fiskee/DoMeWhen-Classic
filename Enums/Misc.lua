DMW.Enums.MeleeSpell = {
    WARRIOR = 5308,
    ROGUE = 1752
}

DMW.Enums.CreatureType = {
    [1] = "Beast",
    [2] = "Dragonkin",
    [3] = "Demon",
    [4] = "Elemental",
    [5] = "Giant",
    [6] = "Undead",
    [7] = "Humanoid",
    [8] = "Critter",
    [9] = "Mechanical",
    [10] = "Not specified",
    [11] = "Totem"
}

DMW.Enums.ClassColor = {
    DRUID = {r = 255, g = 125, b = 10},
    HUNTER = {r = 171, g = 212, b = 115},
    MAGE = {r = 64, g = 199, b = 235},
    PALADIN = {r = 245, g = 140, b = 186},
    PRIEST = {r = 255, g = 255, b = 255},
    ROGUE = {r = 255, g = 245, b = 105},
    SHAMAN = {r = 0, g = 112, b = 222},
    WARLOCK = {r = 135, g = 135, b = 237},
    WARRIOR = {r = 199, g = 156, b = 110}
}

DMW.Enums.UnitFlags = {
    --From trinity
    NotClientControlled = 0x1,
    PlayerCannotAttack = 0x2,
    RemoveClientControl = 0x4,
    PlayerControlled = 0x8,
    Preparation = 0x20,
    NoAttack = 0x80,
    NotAttackbleByPlayerControlled = 0x100,
    OnlyAttackableByPlayerControlled = 0x200,
    Looting = 0x400,
    PetIsAttackingTarget = 0x800,
    PVP = 0x1000,
    Silenced = 0x2000,
    CannotSwim = 0x4000,
    OnlySwim = 0x8000,
    NoAttack2 = 0x10000,
    Pacified = 0x20000,
    Stunned = 0x40000,
    AffectingCombat = 0x80000,
    OnTaxi = 0x100000,
    MainHandDisarmed = 0x200000,
    Confused = 0x400000,
    Feared = 0x800000,
    PossessedByPlayer = 0x1000000,
    NotSelectable = 0x2000000,
    Skinnable = 0x4000000,
    Mount = 0x8000000,
    PreventKneelingWhenLooting = 0x10000000,
    PreventEmotes = 0x20000000,
    Sheath = 0x40000000
}

DMW.Enums.NpcFlags = {
    Innkeeper = 0x00010000,
    Repair = 0x0000001000,
    PoisonVendor = 0x0000000400,
    FlightMaster = 0x0000002000,
    ReagentVendor = 0x0000000800,
    Trainer = 0x0000000010,
    ClassTrainer = 0x0000000020,
    ProfessionTrainer = 0x0000000040,
    AmmoVendor = 0x0000000100,
    FoodVendor = 0x0000000200,
    BlackMarket = 0x0080000000,
    TradeskillNpc = 0x4000000000,
    Vendor = 0x0000000080
}

DMW.Enums.MovementFlags = {
    None = 0x00000000,
    Forward = 0x00000001,
    Backward = 0x00000002,
    StrafeLeft = 0x00000004,
    StrafeRight = 0x00000008,
    Left = 0x00000010,
    Right = 0x00000020,
    PitchUp = 0x00000040,
    PitchDown = 0x00000080,
    Walking = 0x00000100,
    DisableGravity = 0x00000200,
    Root = 0x00000400,
    Falling = 0x00000800,
    FallingFar = 0x00001000,
    PendingStop = 0x00002000,
    PendingStrafeStop = 0x00004000,
    PendingForward = 0x00008000,
    PendingBackward = 0x00010000,
    PendingStrafeLeft = 0x00020000,
    PendingStrafeRight = 0x00040000,
    PendingRoot = 0x00080000,
    Swimming = 0x00100000,
    Ascending = 0x00200000,
    Descending = 0x00400000,
    CanFly = 0x00800000,
    Flying = 0x01000000,
    SplineElevation = 0x02000000,
    WaterWalking = 0x04000000,
    FallingSlow = 0x08000000,
    Hover = 0x10000000,
    DisableCollision = 0x20000000,
}
DMW.Enums.MovementFlags.Moving = bit.bor(DMW.Enums.MovementFlags.Forward, DMW.Enums.MovementFlags.Backward, DMW.Enums.MovementFlags.StrafeLeft, DMW.Enums.MovementFlags.StrafeRight, DMW.Enums.MovementFlags.Falling, DMW.Enums.MovementFlags.Ascending, DMW.Enums.MovementFlags.Descending)
