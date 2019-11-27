local DMW = DMW
local EHFrame = CreateFrame("Frame")
local class = select(2, UnitClass("player"))
local ContainersID = {7973, 20766}

EHFrame:RegisterEvent("ENCOUNTER_START")
EHFrame:RegisterEvent("ENCOUNTER_END")
EHFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
EHFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
EHFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
EHFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
EHFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
EHFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")
EHFrame:RegisterEvent("LOOT_OPENED")
EHFrame:RegisterEvent("LOOT_CLOSED")
EHFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
EHFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
if class == "ROGUE" or class == "DRUID" then
    EHFrame:RegisterEvent("UNIT_POWER_FREQUENT")
-- EHFrame:RegisterEvent("UNIT_POWER_UPDATE")
end
local function EventHandler(self, event, ...)
    if GetObjectWithGUID then
        if event == "ENCOUNTER_START" then
            DMW.Player.EID = select(1, ...)
        elseif event == "ENCOUNTER_END" then
            DMW.Player.EID = false
        elseif event == "PLAYER_TOTEM_UPDATE" then
            if DMW.Player.Class == "PALADIN" then
                if GetTotemInfo(1) then
                    DMW.Player.Consecration = {
                        PosX = DMW.Player.PosX,
                        PosY = DMW.Player.PosY,
                        PosZ = DMW.Player.PosZ
                    }
                else
                    DMW.Player.Consecration = false
                end
            elseif DMW.Player.Class == "SHAMAN" then
                local slot = ...;
                C_Timer.After(0.01, function()DMW.Player:UpdateTotems(slot) end)
            end
        elseif event == "ACTIONBAR_SLOT_CHANGED" then
            DMW.Helpers.Queue.GetBindings()
        elseif event == "PLAYER_REGEN_ENABLED" then
            DMW.Player.Combat = false
            DMW.Player.CombatLeft = DMW.Time
        elseif event == "PLAYER_REGEN_DISABLED" then
            DMW.Player.Combat = DMW.Time
            DMW.Player.CombatLeft = false
        elseif event == "PLAYER_EQUIPMENT_CHANGED" then
            DMW.Player:UpdateEquipment()
        elseif event == "CHARACTER_POINTS_CHANGED" then
            DMW.Player:GetTalents()
        elseif event == "LOOT_OPENED" then
            DMW.Player.Looting = true
        elseif event == "LOOT_CLOSED" then
            DMW.Player.Looting = false
            DMW.Player.freeSlots = 0
            for bag=0,4,1 do
                DMW.Player.freeSlots = DMW.Player.freeSlots + GetContainerNumFreeSlots(bag)
            end
            for bag=0,4,1 do
                for slot=1,36,1 do
                    local name=GetContainerItemLink(bag,slot)
                    if (name and string.find(name, "19 Pound Catfish"))
                        or (name and string.find(name, "Raw Longjaw Mud Snapper"))
                        or (name and string.find(name, "Raw Bristle Whisker Catfish"))
                        or (name and string.find(name, "Raw Brilliant Smallfish"))
                        or (name and string.find(name, "Raw Spotted Yellowtail"))
                        or (name and string.find(name, "Zesty Clam Meat"))
                        or (name and string.find(name, "Raw Glossy Mightfish"))
                        or (name and string.find(name, "Raw Rockscale Cod"))
                        or (name and string.find(name, "Morning Glory Dew"))
                        or (name and string.find(name, "Lifeless Stone"))
                        or (name and string.find(name, "Large Bear Bone"))
                        or (name and string.find(name, "Thick Fury Mane"))
                        or (name and string.find(name, "Brittle Dragon Bone"))
                        or (name and string.find(name, "Red Wolf Meat"))
                        or (name and string.find(name, "Tender Wolf Meat"))
                        or (name and string.find(name, "Ripped Wing Webbing"))
                        or (name and string.find(name, "Savage Bear Claw"))
                        or (name and string.find(name, "Broken Weapon"))
                        or (name and string.find(name, "Tender Crocolisk Meat"))
                        or (name and string.find(name, "Lifeless Skull"))
                        or (name and string.find(name, "Pointy Crocolisk Tooth"))
                        or (name and string.find(name, "Slimy Ichor"))
                        or (name and string.find(name, "Earthroot"))
                        or (name and string.find(name, "Briarthorn"))
                        or (name and string.find(name, "Liferoot"))
                        or (name and string.find(name, "Silverleaf"))
                        or (name and string.find(name, "Thick Scaly Tail"))
                        or (name and string.find(name, "Empty Dew Gland"))
                        or (name and string.find(name, "Punctured Dew Gland"))
                        or (name and string.find(name, "Khadgar's Whisker"))
                        or (name and string.find(name, "Gorilla Fang"))
                        or (name and string.find(name, "Patch of Fine Fur"))
                        or (name and string.find(name, "White Spider Meat"))
                        or (name and string.find(name, "Dripping Spider Mandible"))
                        or (name and string.find(name, "Raw Spinefin Halibut"))
                        or (name and string.find(name, "Intricate Bauble"))
                        or (name and string.find(name, "Essence of Agony"))
                        or (name and string.find(name, "Deathweed"))
                        or (name and string.find(name, "Essence of Pain"))
                        or (name and string.find(name, "Heavy Junkbox"))
                    then
                        if DMW.Player.freeSlots < 8 then
                            PickupContainerItem(bag,slot)
                            DeleteCursorItem()
                            break
                        end
                    end
                    local itemID = GetContainerItemID(bag, slot)
                    
                    if DMW.Player.freeSlots > 2 then 
                        for k,v in ipairs(ContainersID) do
                            if itemID == v then
                                UseContainerItem(bag,slot)
                            end
                        end
                    end
                end
            end
        elseif event == "GET_ITEM_INFO_RECEIVED" then
            local ItemID = select(1, ...)
            if DMW.Tables.ItemInfo[ItemID] then
                DMW.Tables.ItemInfo[ItemID]:Refresh()
                DMW.Tables.ItemInfo[ItemID] = nil
            end
        elseif event == "UNIT_INVENTORY_CHANGED" then
            local unit = select(1, ...)
            if unit == "player" then
                DMW.Helpers.Swing.OnInventoryChange()
            end
        elseif event == "UNIT_POWER_FREQUENT" then
            local a, b = ...
            if class == "ROGUE" or (class == "DRUID" and GetShapeshiftForm() == 3) then
                local Power = UnitPower("player") or 0
                if DMW.Player and DMW.Player.Power and a == "player" and b == "ENERGY" and DMW.Player.Power < Power then
                    DMW.Player.TickTime = DMW.Time
                -- EHFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
                end
            end
        end
    end
end
EHFrame:SetScript("OnEvent", EventHandler)
