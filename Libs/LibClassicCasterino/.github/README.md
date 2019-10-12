# LibClassicCasterino

Emulates unit cast events from live

Usage example:
-----------------

    local isClassic = select(4,GetBuildInfo()) <= 19999
    local UnitCastingInfo = UnitCastingInfo
    local UnitChannelInfo = UnitChannelInfo

    if isClassic then
        UnitCastingInfo = CastingInfo
        UnitChannelInfo = ChannelInfo
    end

    local LibCC = isClassic and LibStub("LibClassicCasterino", true)

    if LibCC then
        local CastbarEventHandler = function(event, ...)
            local self = f
            return NugCast[event](self, event, ...)
        end
        LibCC.RegisterCallback(f,"UNIT_SPELLCAST_START", CastbarEventHandler)
        LibCC.RegisterCallback(f,"UNIT_SPELLCAST_DELAYED", CastbarEventHandler) -- only for player
        LibCC.RegisterCallback(f,"UNIT_SPELLCAST_STOP", CastbarEventHandler)
        LibCC.RegisterCallback(f,"UNIT_SPELLCAST_FAILED", CastbarEventHandler)
        LibCC.RegisterCallback(f,"UNIT_SPELLCAST_INTERRUPTED", CastbarEventHandler)
        LibCC.RegisterCallback(f,"UNIT_SPELLCAST_CHANNEL_START", CastbarEventHandler)
        LibCC.RegisterCallback(f,"UNIT_SPELLCAST_CHANNEL_UPDATE", CastbarEventHandler) -- only for player
        LibCC.RegisterCallback(f,"UNIT_SPELLCAST_CHANNEL_STOP", CastbarEventHandler)
        UnitCastingInfo = function(unit)
            return LibCC:UnitCastingInfo(unit)
        end
        UnitChannelInfo = function(unit)
            return LibCC:UnitChannelInfo(unit)
        end
    else
        f:RegisterEvent("UNIT_SPELLCAST_START")
        f:RegisterEvent("UNIT_SPELLCAST_DELAYED")
        f:RegisterEvent("UNIT_SPELLCAST_STOP")
        f:RegisterEvent("UNIT_SPELLCAST_FAILED")
        f:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
        f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
        f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
        f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    end



![Screenshot](https://i.imgur.com/horIUxu.jpg)