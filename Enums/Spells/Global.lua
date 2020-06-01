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
            --Professions, multiple ID's shouldn't matter, just for tracking casts
            Mining = {Ranks = {2575}, CastType = "Profession"},
            HerbGathering = {Ranks = {2366}, CastType = "Profession"},
            Skinning = {Ranks = {8613}, CastType = "Profession"}
        },
        Buffs = {
            SoulstoneResurrection = {Ranks = {20707}},
            EssenceoOfSapphiron = {Ranks = {28779}}, -- The Restrained Essence of Sapphiron
            EphemeralPower = {Ranks = {23271}}, -- Talisman of Ephemeral Power
            UnstablePower = {Ranks = {24658}}, -- Zandalarian Hero Charm
            DraconicInfusedEmblem = {Ranks = {27675}}, -- Draconic Infused Emblem
            PowerInfusion = {Ranks = {10060}}
        },
        Debuffs = {
            LivingBomb = {Ranks = {20475}},
            BurningAdrenaline = {Ranks = {18173}},
            ShadowVulnerability = {Ranks = {15258}},
            Nightfall = {Ranks = {23605}}
            
        },
        Talents = {}
    }
}
