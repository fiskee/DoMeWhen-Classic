local DMW = DMW
local Item = DMW.Classes.Item
DMW.Tables.ItemInfo = {}

function Item:New(ItemID)
    self.ItemID = ItemID
    self.ItemName = GetItemInfo(ItemID)
    if not self.ItemName then
        DMW.Tables.ItemInfo[ItemID] = self
    end
    self.SpellName, self.SpellID = GetItemSpell(ItemID)
    self.Cache = {}
end

function Item:Refresh()
    self.ItemName = GetItemInfo(self.ItemID)
    self.SpellName, self.SpellID = GetItemSpell(self.ItemID)
end

function Item:Equipped()
    for _, ID in pairs(DMW.Player.Equipment) do
        if ID == self.ItemID then
            return true
        end
    end
    return false
end

function Item:CD()
    if DMW.Pulses == self.Cache.CDUpdate then
        return self.Cache.CD
    end
    self.Cache.CDUpdate = DMW.Pulses
    local Start, Duration, Enable = GetItemCooldown(self.ItemID)
    if Enable == 0 then
        return 99
    end
    local CD = Start + Duration - DMW.Time
    self.Cache.CD = CD > 0 and CD or 0
    return self.Cache.CD
end

function Item:IsReady()
    return self:Useable() and self:CD() == 0
end

function Item:Useable()
    return IsUsableItem(self.ItemName)
end

function Item:Use(Unit)
    Unit = Unit or DMW.Player
    if self.SpellID and self:IsReady() then
        UseItemByName(self.ItemName, Unit.Pointer)
        return true
    end
    return false
end

function Item:InBag()
    if self.ItemName then
        local TempName, TempID
        for Bag = 0, 4, 1 do
            for Slot = 1, GetContainerNumSlots(Bag), 1 do
                TempID = GetContainerItemID(Bag, Slot)
                if TempID then
                    TempName = GetItemInfo(TempID)
                    if TempName == self.ItemName then
                        return true
                    end
                end
            end
        end
    end
    return false
end