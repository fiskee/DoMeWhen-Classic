local DMW = DMW
DMW.Helpers.Queue = {}
local Queue = DMW.Helpers.Queue
DMW.Tables.Bindings = {}
local QueueFrame

function Queue.GetBindings()
    table.wipe(DMW.Tables.Bindings)
    local Type, ID, Key1, Key2, BindingID
    for k, frame in pairs(ActionBarButtonEventsFrame.frames) do
        local BindingID = frame:GetAttribute('bindingid') or frame:GetID()
        if frame.buttonType then
            Key1, Key2 = GetBindingKey(frame.buttonType .. BindingID)
        else
            Key1, Key2 = GetBindingKey("ACTIONBUTTON" .. BindingID)
        end
        Type, ID = GetActionInfo(frame.action)
        if Key1 then
            DMW.Tables.Bindings[Key1] = {["Type"] = Type, ["ID"] = ID}
        end
        if Key2 then
            DMW.Tables.Bindings[Key2] = {["Type"] = Type, ["ID"] = ID}
        end
    end
end

local function SpellSuccess(self, event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" and (Queue.Spell or Queue.Item) then
        local SourceUnit = select(1, ...)
        local SpellID = select(3, ...)
        if SourceUnit == "player" then
            if Queue.Spell and Queue.Spell.SpellID == SpellID then
                --print("Queue Casted: " .. Queue.Spell.SpellName)
                Queue.Spell = false
                Queue.Target = false
            elseif Queue.Item and Queue.Item.SpellID == SpellID then
                Queue.Item = false
                Queue.Target = false
            end
        end
    end
end

local function CheckPress(self, Key)
    if DMW.Player.Combat then
        local KeyPress = ""
        if IsLeftShiftKeyDown() then
            KeyPress = "SHIFT-"
        elseif IsLeftAltKeyDown() then
            KeyPress = "ALT-"
        elseif IsLeftControlKeyDown() then
            KeyPress = "CTRL-"
        end
        KeyPress = KeyPress .. Key
        if DMW.Tables.Bindings[KeyPress] then
            local Type, ID = DMW.Tables.Bindings[KeyPress].Type, DMW.Tables.Bindings[KeyPress].ID
            if Type == "spell" then
                local Spell = DMW.Helpers.Rotation.GetSpellByID(ID)
                if Spell and Spell:CD() < DMW.Settings.profile.Queue.Wait then
                    local QueueSetting = DMW.Settings.profile.Queue[Spell.SpellName]
                    if QueueSetting == 2 then
                        Queue.Spell = Spell
                        Queue.Time = DMW.Time
                        Queue.Type = 2
                        if DMW.Player.Target then
                            Queue.Target = DMW.Player.Target
                        else
                            Queue.Target = DMW.Player
                        end
                    elseif QueueSetting == 3 and DMW.Player.Mouseover then
                        Queue.Spell = Spell
                        Queue.Time = DMW.Time
                        Queue.Target = DMW.Player.Mouseover
                        Queue.Type = 3
                    elseif QueueSetting == 4 then
                        Queue.Spell = Spell
                        Queue.Time = DMW.Time
                        local x, y = GetMousePosition()
                        Queue.PosX, Queue.PosY, Queue.PosZ = ScreenToWorld(x, y)
                        Queue.Type = 4
                    elseif QueueSetting == 5 then
                        Queue.Spell = Spell
                        Queue.Time = DMW.Time
                        Queue.Type = 5
                    end
                end
            elseif Type == "item" and DMW.Settings.profile.Queue.Items then
                Queue.Item = DMW.Classes.Item(ID)
                Queue.Time = DMW.Time
                if DMW.Player.Target then
                    Queue.Target = DMW.Player.Target
                else
                    Queue.Target = DMW.Player
                end
            end
        end
    end
end

function Queue.Run()
    if not QueueFrame then
        QueueFrame = CreateFrame("Frame")
        QueueFrame:SetPropagateKeyboardInput(true)
        QueueFrame:SetScript("OnKeyDown", CheckPress)
        QueueFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        QueueFrame:SetScript("OnEvent", SpellSuccess)
    end
    if GetKeyState(0x05) then
        CheckPress(nil, "BUTTON4")
    elseif GetKeyState(0x06) then
        CheckPress(nil, "BUTTON5")
    end
    if Queue.Spell and (DMW.Time - Queue.Time) > 2 then
        Queue.Spell = false
        Queue.Target = false
        Queue.Item = false
    end
    if Queue.Spell and DMW.Player.Combat and not DMW.Player.Casting then
        if Queue.Type == 2 then
            if Queue.Target and IsSpellInRange(Queue.Spell.SpellName, Queue.Target.Pointer) ~= nil then
                if Queue.Spell:Cast(Queue.Target) then
                    return true
                end
            else
                if Queue.Spell:Cast(DMW.Player) then
                    return true
                end
            end
        elseif Queue.Type == 3 then
            if Queue.Spell:Cast(Queue.Target) then
                return true
            end
        elseif Queue.Type == 4 then
            if Queue.Spell:CastGround(Queue.PosX, Queue.PosY, Queue.PosZ) then
                return true
            end
        elseif Queue.Type == 5 then
            if Queue.Spell:IsReady() then
                CastSpellByName(Queue.Spell.SpellName)
                return true
            end
        end
    elseif Queue.Item and DMW.Player.Combat then
        Queue.Item:Use(Queue.Target)
    end
end
