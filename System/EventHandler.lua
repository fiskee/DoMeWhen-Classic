local DMW = DMW
local EHFrame = CreateFrame("Frame")
local class = select(2, UnitClass("player"))

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
EHFrame:RegisterEvent("SKILL_LINES_CHANGED")
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
        elseif event == "SKILL_LINES_CHANGED" and DMW.Player.UpdateProfessions then
            DMW.Player:UpdateProfessions()
        end
    end
end
EHFrame:SetScript("OnEvent", EventHandler)
