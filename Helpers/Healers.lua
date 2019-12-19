local DMW = DMW
local HealCommLib = LibStub("LibHealComm-4.0", true)

DMW.Tables.HealerStuff = {}
local HealerStuff = DMW.Tables.HealerStuff

local function avg(a, b) return (a + b) / 2 end

local spellData = {}

if select(2, UnitClass("player")) == "SHAMAN" then
    spellData["ChainHeal"] = {
        coeff = 2.5 / 3.5,
        levels = {40, 46, 54},
        averages = {
            {avg(320, 368), avg(322, 371), avg(325, 373), avg(327, 376), avg(330, 378), avg(332, 381)},
            {avg(405, 465), avg(407, 468), avg(410, 471), avg(413, 474), avg(416, 477), avg(419, 479)},
            {avg(551, 629), avg(554, 633), avg(557, 636), avg(560, 639), avg(564, 643), avg(567, 646)}
        }
    }
    spellData["HealingWave"] = {
        levels = {1, 6, 12, 18, 24, 32, 40, 48, 56, 60},
        averages = {
            {avg(34, 44), avg(34, 45), avg(35, 46), avg(36, 47)},
            {avg(64, 78), avg(65, 79), avg(66, 80), avg(67, 81), avg(68, 82), avg(69, 83)},
            {avg(129, 155), avg(130, 157), avg(132, 158), avg(133, 160), avg(135, 161), avg(136, 163)},
            {avg(268, 316), avg(270, 319), avg(272, 321), avg(274, 323), avg(277, 326), avg(279, 328)},
            {avg(376, 440), avg(378, 443), avg(381, 446), avg(384, 449), avg(386, 451), avg(389, 454)},
            {avg(536, 622), avg(539, 626), avg(542, 629), avg(545, 632), avg(549, 636), avg(552, 639)},
            {avg(740, 854), avg(743, 858), avg(747, 862), avg(751, 866), avg(755, 870), avg(759, 874)},
            {avg(1017, 1167), avg(1021, 1172), avg(1026, 1177), avg(1031, 1182), avg(1035, 1186), avg(1040, 1191)},
            {avg(1367, 1561), avg(1372, 1567), avg(1378, 1572), avg(1383, 1578), avg(1389, 1583)}, {avg(1620, 1850)}
        }
    }
    spellData["LesserHealingWave"] = {
        coeff = 1.5 / 3.5,
        levels = {20, 28, 36, 44, 52, 60},
        averages = {
            {avg(162, 186), avg(163, 188), avg(165, 190), avg(167, 192), avg(168, 193), avg(170, 195)},
            {avg(247, 281), avg(249, 284), avg(251, 286), avg(253, 288), avg(255, 290), avg(257, 29)},
            {avg(337, 381), avg(339, 384), avg(342, 386), avg(344, 389), avg(347, 391), avg(349, 394)},
            {avg(458, 514), avg(461, 517), avg(464, 520), avg(467, 523), avg(470, 526), avg(473, 529)},
            {avg(631, 705), avg(634, 709), avg(638, 713), avg(641, 716), avg(645, 720), avg(649, 723)}, {avg(832, 928)}
        }
    }
end

function HealerStuff.getBaseHealAmount(spellData, Spell, Rank)
    spellData = spellData[Spell]
    local average = spellData.averages[Rank]
    if type(average) == "number" then return average end
    local requiresLevel = spellData.levels[Rank]
    return average[min(DMW.Player.Level - requiresLevel + 1, #average)]
end

function HealerStuff.calculateGeneralAmount(level, amount, spellPower, spModifier, healModifier)
    local penalty = level > 20 and 1 or (1 - ((20 - level) * 0.0375))
    spellPower = spellPower * penalty
    return healModifier * (amount + (spellPower * spModifier))
end

function HealerStuff.predictHealAmount(Spell, Rank, Unit, links, returnTable)
    local Buff = DMW.Player.Buffs
    local Talent = DMW.Player.Talents
    -- Spell:HealCommFix(Rank)
    local amountHealed, amountOverhealed
    local healAmount = HealerStuff.getBaseHealAmount(spellData, Spell, Rank)
    local healModifier, spModifier = 1, 1
    local PurificationIncrease = 0.02 * Talent.Purification.Rank
    local spellPower = GetSpellBonusHealing()
    -- local returnTable = returnTable or {}
    local function finalHealFunc(Unit, healAmount, links)
        local modifier = HealCommLib:GetHealModifier(Unit.GUID) or 1
        local linksMod = (links ~= nil and 2 ^ (links - 1)) or 1
        local finalHeal = healAmount * modifier / linksMod
        local overhealAmount = Unit.HealthDeficit > finalHeal and 0 or (finalHeal - Unit.HealthDeficit)
        local finalFinalHeal = overhealAmount == 0 and finalHeal or Unit.HealthDeficit
        return finalFinalHeal, overhealAmount
    end
    healAmount = healAmount * (1 + PurificationIncrease)
    if Spell == "ChainHeal" then
        spellPower = spellPower * spellData[Spell].coeff
    elseif Spell == "HealingWave" then
        local hwStacks = Buff.HealingWay:Stacks(Unit)
        if hwStacks > 0 then healAmount = healAmount * ((hwStacks * 0.06) + 1) end
        local castTime = Rank > 3 and 3 or Rank == 3 and 2.5 or Rank == 2 and 2 or 1.5
        spellPower = spellPower * (castTime / 3.5)
    elseif Spell == "LesserHealingWave" then
        spellPower = spellPower * spellData[Spell].coeff
    end
    healAmount = HealerStuff.calculateGeneralAmount(spellData[Spell].levels[Rank], healAmount, spellPower, spModifier,
                                                    healModifier)
    local healAmountCeil = math.ceil(healAmount)
    amountHealed, amountOverhealed = finalHealFunc(Unit, healAmountCeil, links)
    -- if Setting("DownRanking") then
    --     if Rank > 0 then
    --         returnTable[Rank] = {amountHealed, amountOverhealed}
    --         Rank = Rank - 1
    --         CalcHeals.predictHealAmount(Spell, Rank, Unit, returnTable)
    --     end
    --         return returnTable
    -- else
    -- if amountOverhealed == 0 then
    -- print(Spell .. " R." .. Rank .. " will heal " .. Unit.Name .. " for " .. amountHealed .. " plus " .. amountOverhealed ..
    --   " overhealed ")
    -- end
    return amountHealed, amountOverhealed
    -- end
end

function HealerStuff.chainHealSim(Unit, Rank, returnTable)
    local totalHeal, totalOverheal, chainCount
    local usedPointers = {}
    -- local returnTable = returnTable or {}
    --------------------------------Initial Heal there--------------------------------
    local firstHeal, overhealAmount = HealerStuff.predictHealAmount("ChainHeal", Rank, Unit, chainCount)
    chainCount = 1
    totalHeal = firstHeal
    totalOverheal = overhealAmount
    usedPointers[Unit.Pointer] = true
    --------------------------------2nd Jump there--------------------------------
    local ChainUnits, ChainUnitsCount = Unit:GetFriends(10, 100, true)
    if ChainUnitsCount > 1 then
        local maxDeficit, chainTarget, chainHeal, chainOverheal
        for _, Friend in pairs(ChainUnits) do
            if not usedPointers[Friend.Pointer] then
                local modifier = HealCommLib:GetHealModifier(Friend.GUID) or 1
                local firstJumpHealCalc = firstHeal * modifier / 2
                local overhealAmount = Friend.HealthDeficit > firstJumpHealCalc and 0 or (firstJumpHealCalc - Friend.HealthDeficit)
                local healAmount = overhealAmount == 0 and firstJumpHealCalc or Friend.HealthDeficit
                if Friend.HealthDeficit > 0 and (maxDeficit == nil or maxDeficit < Friend.HealthDeficit) then
                    maxDeficit = Friend.HealthDeficit
                    chainTarget = Friend
                    chainHeal = healAmount
                    chainOverheal = overhealAmount
                end
            end
        end
        if chainTarget ~= nil then
            chainCount = chainCount + 1
            totalHeal = totalHeal + chainHeal
            totalOverheal = totalOverheal + chainOverheal
            usedPointers[chainTarget.Pointer] = true
            --------------------------------3rd Jump there--------------------------------
            local ChainUnits, ChainUnitsCount = chainTarget:GetFriends(10, 100, true)
            if ChainUnitsCount > 1 then
                local maxDeficit, chainTarget, chainHeal, chainOverheal
                for _, Friend in pairs(ChainUnits) do
                    if not usedPointers[Friend.Pointer] then
                        local modifier = HealCommLib:GetHealModifier(Friend.GUID) or 1
                        local secondJumpHealCalc = firstHeal * modifier / 4
                        local overhealAmount = Friend.HealthDeficit > secondJumpHealCalc and 0 or
                                                   (secondJumpHealCalc - Friend.HealthDeficit)
                        local healAmount = overhealAmount == 0 and secondJumpHealCalc or Friend.HealthDeficit
                        if Friend.HealthDeficit > 0 and (maxDeficit == nil or maxDeficit < Friend.HealthDeficit) then
                            maxDeficit = Friend.HealthDeficit
                            chainTarget = Friend
                            chainHeal = healAmount
                            chainOverheal = overhealAmount
                        end
                    end
                end
                if chainTarget ~= nil then
                    chainCount = chainCount + 1
                    totalHeal = totalHeal + chainHeal
                    totalOverheal = totalOverheal + chainOverheal
                end
            end
        end
    end
    -- if Setting("DownRanking") then
    --     if Rank > 0 then
    --         returnTable[Rank] = amountHealed, amountOverhealed, Unit, chainCount, firstHeal
    --         Rank = Rank - 1
    --         CalcHeals.chainHealSim(Unit, Rank, returnTable)
    --     else
    --         return returnTable
    --     end
    -- else
    return totalHeal, totalOverheal, chainCount
    -- end
end
