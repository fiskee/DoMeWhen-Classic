local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer
local Spell = DMW.Classes.Spell
local Buff = DMW.Classes.Buff
local Debuff = DMW.Classes.Debuff

function LocalPlayer:GetSpells()
    self.Spells = {}
    self.Buffs = {}
    self.Debuffs = {}
    local CastType, Duration
    for k,v in pairs(DMW.Enums.Spells) do
        if k == "GLOBAL" or k == self.Class then
            for SpellType, SpellTable in pairs(v) do
                if SpellType == "Abilities" then
                    for SpellName, SpellInfo in pairs(SpellTable) do
                        CastType = SpellInfo.CastType or "Normal"
                        self.Spells[SpellName] = Spell(SpellInfo.Ranks, CastType)
                        self.Spells[SpellName].Key = SpellName
                    end
                elseif SpellType == "Buffs" then
                    for SpellName, SpellInfo in pairs(SpellTable) do
                        self.Buffs[SpellName] = Buff(SpellInfo.Ranks)
                    end
                elseif SpellType == "Debuffs" then
                    for SpellName, SpellInfo in pairs(SpellTable) do
                        Duration = SpellInfo.Duration or nil
                        self.Debuffs[SpellName] = Debuff(SpellInfo.Ranks, Duration)
                    end
                end
            end            
        end        
    end
end

function LocalPlayer:GetTalents()
    if self.Talents then
        table.wipe(self.Talents)
    else
        self.Talents = {}
    end
    local name, iconPath, tier, column, currentRank, maxRank, isExceptional, meetsPrereq
    for k,v in pairs(DMW.Enums.Spells[self.Class].Talents) do
        name, iconPath, tier, column, currentRank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(v[1], v[2])
        if name then
            self.Talents[k] = {Rank = currentRank, MaxRank = maxRank, Active = false}
            if currentRank > 0 then
                self.Talents[k].Active = true
            end
        end
    end
end

function LocalPlayer:UpdateEquipment()
    table.wipe(self.Equipment)
    self.Items.Trinket1 = nil
    self.Items.Trinket2 = nil
    local ItemID
    for i = 1, 19 do
        ItemID = GetInventoryItemID("player", i)
        if ItemID then
            self.Equipment[i] = ItemID
            if i == 13 then
                self.Items.Trinket1 = DMW.Classes.Item(ItemID)
            elseif i == 14 then
                self.Items.Trinket2 = DMW.Classes.Item(ItemID)
            end
        end
    end
end

function LocalPlayer:GetItems()
    local Item = DMW.Classes.Item
    for Name, ItemID in pairs(DMW.Enums.Items) do
        self.Items[Name] = Item(ItemID)
    end
end