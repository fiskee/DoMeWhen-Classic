function LoadBanetoBotAPI()
	ObjectTypes = {
		Object = bntapi.GetObjectTypeFlagsTable().Object,
		Item = bntapi.GetObjectTypeFlagsTable().Item,
		Container = bntapi.GetObjectTypeFlagsTable().Container,
		AzeriteEmpoweredItem = bntapi.GetObjectTypeFlagsTable().AzeriteEmpoweredItem,
		AzeriteItem = bntapi.GetObjectTypeFlagsTable().AzeriteItem,
		Unit = bntapi.GetObjectTypeFlagsTable().Unit,
		Player = bntapi.GetObjectTypeFlagsTable().Player,
		ActivePlayer = bntapi.GetObjectTypeFlagsTable().ActivePlayer,
		GameObject = bntapi.GetObjectTypeFlagsTable().GameObject,
		DynamicObject = bntapi.GetObjectTypeFlagsTable().DynamicObject,
		Corpse = bntapi.GetObjectTypeFlagsTable().Corpse,
		AreaTrigger = bntapi.GetObjectTypeFlagsTable().AreaTrigger,
		SceneObject = bntapi.GetObjectTypeFlagsTable().SceneObject,
		ConversationData = bntapi.GetObjectTypeFlagsTable().Conversation
	}
	MovementFlags = {
		Forward = bntapi.GetUnitMovementFlagsTable().Forward,
		Backward = bntapi.GetUnitMovementFlagsTable().Backward,
		StrafeLeft = bntapi.GetUnitMovementFlagsTable().StrafeLeft,
		StrafeRight = bntapi.GetUnitMovementFlagsTable().StrafeRight,
		TurnLeft = bntapi.GetUnitMovementFlagsTable().TurnLeft,
		TurnRight = bntapi.GetUnitMovementFlagsTable().TurnRight,
		PitchUp = bntapi.GetUnitMovementFlagsTable().PitchUp,
		PitchDown = bntapi.GetUnitMovementFlagsTable().PitchDown,
		Walking = bntapi.GetUnitMovementFlagsTable().Walking,
		Immobilized = bntapi.GetUnitMovementFlagsTable().Immobilized,
		Falling = bntapi.GetUnitMovementFlagsTable().Falling,
		FallingFar = bntapi.GetUnitMovementFlagsTable().FallingFar,
		Swimming = bntapi.GetUnitMovementFlagsTable().Swimming,
		Ascending = bntapi.GetUnitMovementFlagsTable().Ascending,
		Descending = bntapi.GetUnitMovementFlagsTable().Descending,
		CanFly = bntapi.GetUnitMovementFlagsTable().CanFly,
		Flying = bntapi.GetUnitMovementFlagsTable().Flying,
	}
	Types = {
		Bool = bntapi.GetValueTypesTable().Bool,
		Char = bntapi.GetValueTypesTable().Char,
		Byte = bntapi.GetValueTypesTable().Byte,
		Short = bntapi.GetValueTypesTable().Short,
		UShort = bntapi.GetValueTypesTable().UShort,
		Int = bntapi.GetValueTypesTable().Int,
		UInt = bntapi.GetValueTypesTable().UInt,
		Long = bntapi.GetValueTypesTable().Long,
		ULong = bntapi.GetValueTypesTable().ULong,
		Float = bntapi.GetValueTypesTable().Float,
		Double = bntapi.GetValueTypesTable().Double,
		String = bntapi.GetValueTypesTable().String,
		GUID = bntapi.GetValueTypesTable().GUID,
	}
	HitFlags = {
		M2Collision = 0x1,
		M2Render = 0x2,
		WMOCollision = 0x10,
		WMORender = 0x20,
		Terrain = 0x100,
		WaterWalkableLiquid = 0x10000,
		Liquid = 0x20000,
		EntityCollision = 0x100000,
	}
	Offsets = {
		["cgunitdata__animtier"] = "CGUnitData__animTier",
		["cgunitdata__boundingradius"] = "CGUnitData__boundingRadius",
		["cgunitdata__combatreach"] = "CGUnitData__combatReach",
		["cgunitdata__flags"] = "CGUnitData__flags",
		["cgunitdata__target"] = "CGUnitData__target",
		["cgplayerdata__currentspecid"] = "CGPlayerData__currentSpecID",
		["cgunitdata__createdby"] = "CGUnitData__createdBy",
		["cgareatriggerdata__m_spelid"] = "CGAreaTriggerData__m_spellID",
		["cgobjectdata__m_guid"] = "CGObjectData__m_guid",
		["cggameobjectData__m_createdby"] = "CGGameObjectData__m_createdBy",
		["cgunitdata__flags3"] = "CGUnitData__flags3",
		["cgunitdata__flags2"] = "CGUnitData__flags2",
		["cgunitdata__mountdisplayid"] = "CGUnitData__mountDisplayID",
		["cgunitdata__summonedby"] = "CGUnitData__summonedBy",
		["cgunitdata__demoncreator"] = "CGUnitData__demonCreator",
		["cgobjectdata__m_scale"] = "CGObjectData__m_scale",
		["cgobjectdata__m_dynamicflags"] = "CGObjectData__m_dynamicFlags",
		["cgareatriggerdata__m_caster"] = "CGAreaTriggerData__m_caster",
		["cgunitdata__npcflags"]="CGUnitData__npcFlags"
	}
	StopFalling = bntapi.StopFalling
	ObjectTypeFlags = bntapi.ObjectTypeFlags
	GetObjectWithPointer = bntapi.GetObject
	ObjectExists = bntapi.ObjectExists
	ObjectIsVisible = UnitIsVisible
	ObjectPosition = bntapi.ObjectPosition
	ObjectFacing = bntapi.ObjectFacing
	ObjectName = UnitName
	ObjectID = bntapi.ObjectId
	ObjectIsUnit = function(obj) return obj and ObjectIsType(obj,ObjectTypes.Unit) end
	ObjectIsPlayer = function(obj) return obj and ObjectIsType(obj,ObjectTypes.Player) end
	ObjectIsGameObject = function(obj) return obj and ObjectIsType(obj,ObjectTypes.GameObject) end
	ObjectIsAreaTrigger = function(obj) return obj and ObjectIsType(obj,ObjectTypes.AreaTrigger) end
	GetDistanceBetweenPositions = bntapi.GetDistanceBetweenPositions
	GetDistanceBetweenObjects = bntapi.GetDistanceBetweenObjects
	GetPositionBetweenObjects = bntapi.GetPositionBetweenObjects
	GetPositionFromPosition = bntapi.GetPositionFromPosition
	GetAnglesBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2) return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2), math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi end
	GetPositionBetweenPositions = bntapi.GetPositionBetweenPositions
	ObjectIsFacing = bntapi.ObjectIsFacing
	ObjectInteract = InteractUnit
	GetObjectCount = bntapi.GetObjectCount
	GetObjectWithIndex = bntapi.GetObjectWithIndex
	GetObjectWithGUID = bntapi.GetObjectWithGUID
	UnitBoundingRadius = bntapi.UnitBoundingRadius
	UnitCombatReach = bntapi.UnitCombatReach
	UnitTarget = bntapi.UnitTarget
	UnitCastID = function(unit) return select(7,GetSpellInfo(UnitCastingInfo(unit))), select(7,GetSpellInfo(UnitChannelInfo(unit))), bntapi.UnitCastingTarget(unit), bntapi.UnitCastingTarget(unit) end
	TraceLine = bntapi.TraceLine
	GetCameraPosition = bntapi.GetCameraPosition
	CancelPendingSpell = bntapi.CancelPendingSpell
	ClickPosition = bntapi.ClickPosition
	IsAoEPending = bntapi.IsAoEPending
	GetTargetingSpell = function() return end
	WorldToScreen = function(...) return select(2,bntapi.WorldToScreen(...)) end
	ScreenToWorld = bntapi.ScreenToWorld
	GetDirectoryFiles = bntapi.GetDirectoryFiles
	ReadFile = bntapi.ReadFile
	WriteFile = bntapi.WriteFile
	CreateDirectory = bntapi.CreateDirectory
	GetSubdirectories = bntapi.GetDirectoryFolders
	GetWoWDirectory = bntapi.GetWoWDirectory
	GetHackDirectory = bntapi.GetAppDirectory
	AddEventCallback = function(Event, Callback)
		if not MiniBotFrames then
			MiniBotFrames = CreateFrame("Frame")
			MiniBotFrames:SetScript("OnEvent",MiniBotFrames_OnEvent)
		end
		MiniBotFrames:RegisterEvent(Event)
	end
	AddFrameCallback = function(frame)
		if not MiniBotFrames then
			MiniBotFrames = CreateFrame("Frame")
		end
		MiniBotFrames:SetScript("OnUpdate",frame)
	end
	SendHTTPRequest = bntapi.SendHttpRequest
	GetKeyState = bntapi.GetKeyState
	GetWoWWindow = function()
		return GetScreenWidth(), GetScreenHeight()
	end
	StopMoving = function()
		MoveAndSteerStop()
		MoveForwardStop()
		MoveBackwardStop()
		PitchDownStop()
		PitchUpStop()
		StrafeLeftStop()
		StrafeRightStop()
		TurnLeftStop()
		TurnOrActionStop()
		TurnRightStop()
		if IsMoving() then
			MoveForwardStart()
			MoveForwardStop()
		end
		if GetKeyState(0x02) then 
			TurnOrActionStart()
		elseif GetKeyState(0x01) then
			CameraOrSelectOrMoveStart()
		end
	end
	IsMeshLoaded = bntapi.IsMapLoaded
	CalculatePath = bntapi.FindPath
	SetMaximumClimbAngle = bntapi.SetClimbAngle
	GetMapId = bntapi.GetCurrentMapInfo
	ObjectGUID = UnitGUID
	ObjectEntryID = UnitGUID
	ObjectIsType = bntapi.ObjectIsType
	GetAnglesBetweenObjects = bntapi.GetAnglesBetweenObjects
	FaceDirection = function(a) if bntapi.GetObject(a) then bntapi.FaceDirection(GetAnglesBetweenObjects(a,"player")*2,true) else bntapi.FaceDirection(a,true) end end
	ObjectIsBehind = bntapi.ObjectIsBehind
	ObjectDescriptor = bntapi.ObjectDescriptor
	ObjectTypeFlags = bntapi.ObjectTypeFlags
	ObjectField = bntapi.ObjectField
	GetActivePlayer = function() return "player" end
	UnitIsFacing = function(unit1,unit2,degree) return ObjectIsFacing(unit1,unit2,math.rad(degree)/2) end
	UnitIsFalling = function(unit) return unit and UnitMovementFlags(unit) == bntapi.GetUnitMovementFlagsTable().Falling end
	UnitMovementFlags = bntapi.UnitMovementFlags
	UnitBoundingRadius = bntapi.UnitBoundingRadius
	UnitCombatReach = bntapi.UnitCombatReach
	UnitFlags = bntapi.UnitFlags
	PlayerFlags = function() bntapi.UnitFlags("player") end
	ObjectCreator = bntapi.UnitCreator
	UnitCanBeLooted = bntapi.UnitIsLootable
	UnitCanBeSkinned = bntapi.UnitIsSkinnable
	UnitPitch = bntapi.UnitPitch
	GetGroundZ = function(StartX, StartY, Flags) return TraceLine(StartX, StartY, 10000, StartX, StartY, -10000, Flags or 0x10) end
	GetCorpsePosition = bntapi.GetCorpsePosition
	MoveTo = bntapi.MoveTo
	ObjectDynamicFlags = bntapi.ObjectDynamicFlags
	GetUnitTransport = bntapi.UnitTransport
	GetUnitMovement = bntapi.UnitMovementField
	WebsocketClose = bntapi.CloseWebsocket
	WebsocketSend = bntapi.SendWebsocketData
	ObjectPointer = bntapi.GetObject
	UnitCreatureTypeID = bntapi.UnitCreatureTypeId
	AesEncrypt = bntapi.AesEncrypt
	AesDecrypt = bntapi.AesDecrypt
	ObjectRawType = function(obj)
		local result = 0
		local type_flags = ObjectTypeFlags(obj)
		if (band(type_flags, ObjectTypes.ActivePlayer) > 0) then
			result = 7
		elseif (band(type_flags, ObjectTypes.Player) > 0) then
			result = 6
		elseif (band(type_flags, ObjectTypes.Unit) > 0) then
			result = 5
		elseif (band(type_flags, ObjectTypes.GameObject) > 0) then
			result = 8
		elseif (band(type_flags, ObjectTypes.AreaTrigger) > 0) then
			result = 11
		elseif (band(type_flags, ObjectTypes.Item) > 0) then
			result = 1
		elseif (band(type_flags, ObjectTypes.Container) > 0) then
			result = 2
		elseif (band(type_flags, ObjectTypes.AzeriteEmpoweredItem) > 0) then
			result = 3
		elseif (band(type_flags, ObjectTypes.AzeriteItem) > 0) then
			result = 4
		elseif (band(type_flags, ObjectTypes.DynamicObject) > 0) then
			result = 9
		elseif (band(type_flags, ObjectTypes.Corpse) > 0) then
			result = 10
		elseif (band(type_flags, ObjectTypes.SceneObject) > 0) then
			result = 12
		elseif (band(type_flags, ObjectTypes.ConversationData) > 0) then
			result = 13
		end
		return result
	end
	GetOffset = function(offset)
		return bntapi.GetObjectDescriptorsTable()[Offsets[string.lower(offset)]]
	end
	InitializeNavigation = function() end
	IsHackEnabled = function() end
end
