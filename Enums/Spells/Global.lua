local DMW = DMW

DMW.Enums.Spells = {
    GLOBAL = {
        Abilities = {
            Attack = {Ranks = {6603}, CastType = "Toggle"},
            Shoot = {Ranks = {5019}},
            --Racials
            BloodFury = {Ranks = {20572}},
            BerserkingTroll = {Ranks = {20554}},
            WillofTheForsaken = {Ranks = {7744}},
            WarStomp = {Ranks = {20549}},
            BloodFury = {Ranks = {20572}},
            --Professions, multiple ID's shouldn't matter, just for tracking casts
            Mining = {Ranks = {2575}, CastType = "Profession"},
            HerbGathering = {Ranks = {2366}, CastType = "Profession"},
            Skinning = {Ranks = {8613}, CastType = "Profession"}
        },
        Buffs = {
            SoulstoneResurrection = {Ranks = {20707}}
        },
        Debuffs = {
            LivingBomb = {Ranks = {20475}}
        },
        Talents = {}
    }
}
