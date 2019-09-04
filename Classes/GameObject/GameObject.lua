local DMW = DMW
local GameObject = DMW.Classes.GameObject

function GameObject:New(Pointer)
    self.Pointer = Pointer
    self.Name = ObjectName(Pointer)
    self.ObjectID = ObjectID(Pointer)
end

function GameObject:Update(Pointer)
    self.NextUpdate = DMW.Time + (math.random(100, 400) / 1000)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Distance = self:GetDistance()
    self.Quest = self:IsQuest()
    self.Herb = self:IsHerb()
    self.Ore = self:IsOre()
    self.Trackable = self:IsTrackable()
end

function GameObject:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2))
end

function GameObject:IsQuest()
    if DMW.Settings.profile.Helpers.QuestieHelper and QuestieTooltips and QuestieTooltips.tooltipLookup["o_" .. self.Name] then
        for _, Tooltip in pairs(QuestieTooltips.tooltipLookup["o_" .. self.Name]) do
            Tooltip.Objective:Update()
            if not Tooltip.Objective.Completed then
                return true
            end
        end
    end
    return false
end

function GameObject:IsHerb() --TODO: Add check if we have high enough skill
    --ObjectDescriptor(self.Pointer, GetOffset("CGObjectData__DynamicFlags"), Types.Byte) > 0 if they don't disappear after looting
    if DMW.Settings.profile.Helpers.Herbs and DMW.Enums.Herbs[self.ObjectID] then
        return true
    end
    return false
end

function GameObject:IsOre() --TODO: Add check if we have high enough skill
    if DMW.Settings.profile.Helpers.Ore and DMW.Enums.Ore[self.ObjectID] then
        return true
    end
    return false
end

function GameObject:IsTrackable() --TODO: enums
    if DMW.Settings.profile.Helpers.Trackable and DMW.Enums.Trackable[self.ObjectID] then
        return true
    end
    if DMW.Settings.profile.Helpers.TrackObjects then
        for k in string.gmatch(DMW.Settings.profile.Helpers.TrackObjects, "([^,]+)") do
            if strmatch(string.lower(self.Name), string.lower(string.trim(k))) then
                return true
            end
        end
    end
    return false
end
