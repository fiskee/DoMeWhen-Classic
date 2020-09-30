function LoadMiniBotAPI()
	ObjectTypes = {
		Object = wmbapi.GetObjectTypeFlagsTable().Object,
		Item = wmbapi.GetObjectTypeFlagsTable().Item,
		Container = wmbapi.GetObjectTypeFlagsTable().Container,
		AzeriteEmpoweredItem = wmbapi.GetObjectTypeFlagsTable().AzeriteEmpoweredItem,
		AzeriteItem = wmbapi.GetObjectTypeFlagsTable().AzeriteItem,
		Unit = wmbapi.GetObjectTypeFlagsTable().Unit,
		Player = wmbapi.GetObjectTypeFlagsTable().Player,
		ActivePlayer = wmbapi.GetObjectTypeFlagsTable().ActivePlayer,
		GameObject = wmbapi.GetObjectTypeFlagsTable().GameObject,
		DynamicObject = wmbapi.GetObjectTypeFlagsTable().DynamicObject,
		Corpse = wmbapi.GetObjectTypeFlagsTable().Corpse,
		AreaTrigger = wmbapi.GetObjectTypeFlagsTable().AreaTrigger,
		SceneObject = wmbapi.GetObjectTypeFlagsTable().SceneObject,
		ConversationData = wmbapi.GetObjectTypeFlagsTable().Conversation
	}
	MovementFlags = {
		Forward = wmbapi.GetUnitMovementFlagsTable().Forward,
		Backward = wmbapi.GetUnitMovementFlagsTable().Backward,
		StrafeLeft = wmbapi.GetUnitMovementFlagsTable().StrafeLeft,
		StrafeRight = wmbapi.GetUnitMovementFlagsTable().StrafeRight,
		TurnLeft = wmbapi.GetUnitMovementFlagsTable().TurnLeft,
		TurnRight = wmbapi.GetUnitMovementFlagsTable().TurnRight,
		PitchUp = wmbapi.GetUnitMovementFlagsTable().PitchUp,
		PitchDown = wmbapi.GetUnitMovementFlagsTable().PitchDown,
		Walking = wmbapi.GetUnitMovementFlagsTable().Walking,
		Immobilized = wmbapi.GetUnitMovementFlagsTable().Immobilized,
		Falling = wmbapi.GetUnitMovementFlagsTable().Falling,
		FallingFar = wmbapi.GetUnitMovementFlagsTable().FallingFar,
		Swimming = wmbapi.GetUnitMovementFlagsTable().Swimming,
		Ascending = wmbapi.GetUnitMovementFlagsTable().Ascending,
		Descending = wmbapi.GetUnitMovementFlagsTable().Descending,
		CanFly = wmbapi.GetUnitMovementFlagsTable().CanFly,
		Flying = wmbapi.GetUnitMovementFlagsTable().Flying,
	}
	Types = {
		Bool = wmbapi.GetValueTypesTable().Bool,
		Char = wmbapi.GetValueTypesTable().Char,
		Byte = wmbapi.GetValueTypesTable().Byte,
		Short = wmbapi.GetValueTypesTable().Short,
		UShort = wmbapi.GetValueTypesTable().UShort,
		Int = wmbapi.GetValueTypesTable().Int,
		UInt = wmbapi.GetValueTypesTable().UInt,
		Long = wmbapi.GetValueTypesTable().Long,
		ULong = wmbapi.GetValueTypesTable().ULong,
		Float = wmbapi.GetValueTypesTable().Float,
		Double = wmbapi.GetValueTypesTable().Double,
		String = wmbapi.GetValueTypesTable().String,
		GUID = wmbapi.GetValueTypesTable().GUID,
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
	StopFalling = wmbapi.StopFalling
	ObjectTypeFlags = wmbapi.ObjectTypeFlags
	GetObjectWithPointer = wmbapi.GetObject
	ObjectExists = wmbapi.ObjectExists
	ObjectIsVisible = UnitIsVisible
	ObjectPosition = wmbapi.ObjectPosition
	ObjectFacing = wmbapi.ObjectFacing
	ObjectName = UnitName
	ObjectID = wmbapi.ObjectId
	ObjectIsUnit = function(obj) return obj and ObjectIsType(obj,ObjectTypes.Unit) end
	ObjectIsPlayer = function(obj) return obj and ObjectIsType(obj,ObjectTypes.Player) end
	ObjectIsGameObject = function(obj) return obj and ObjectIsType(obj,ObjectTypes.GameObject) end
	ObjectIsAreaTrigger = function(obj) return obj and ObjectIsType(obj,ObjectTypes.AreaTrigger) end
	GetDistanceBetweenPositions = wmbapi.GetDistanceBetweenPositions
	GetDistanceBetweenObjects = wmbapi.GetDistanceBetweenObjects
	GetPositionBetweenObjects = wmbapi.GetPositionBetweenObjects
	GetPositionFromPosition = wmbapi.GetPositionFromPosition
	GetAnglesBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2) return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2), math.atan((Z1 - Z2) / math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))) % math.pi end
	GetPositionBetweenPositions = wmbapi.GetPositionBetweenPositions
	ObjectIsFacing = wmbapi.ObjectIsFacing
	ObjectInteract = InteractUnit
	GetObjectCount = wmbapi.GetObjectCount
	GetObjectWithIndex = wmbapi.GetObjectWithIndex
	GetObjectWithGUID = wmbapi.GetObjectWithGUID
	UnitBoundingRadius = wmbapi.UnitBoundingRadius
	UnitCombatReach = wmbapi.UnitCombatReach
	UnitTarget = wmbapi.UnitTarget
	UnitCastID = function(unit) return select(7,GetSpellInfo(UnitCastingInfo(unit))), select(7,GetSpellInfo(UnitChannelInfo(unit))), wmbapi.UnitCastingTarget(unit), wmbapi.UnitCastingTarget(unit) end
	TraceLine = wmbapi.TraceLine
	GetCameraPosition = wmbapi.GetCameraPosition
	CancelPendingSpell = wmbapi.CancelPendingSpell
	ClickPosition = wmbapi.ClickPosition
	IsAoEPending = wmbapi.IsAoEPending
	GetTargetingSpell = function() return end
	WorldToScreen = function(...) return select(2,wmbapi.WorldToScreen(...)) end
	ScreenToWorld = wmbapi.ScreenToWorld
	GetDirectoryFiles = wmbapi.GetDirectoryFiles
	ReadFile = wmbapi.ReadFile
	WriteFile = wmbapi.WriteFile
	CreateDirectory = wmbapi.CreateDirectory
	GetSubdirectories = wmbapi.GetDirectoryFolders
	GetWoWDirectory = wmbapi.GetWoWDirectory
	GetHackDirectory = wmbapi.GetAppDirectory
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
	SendHTTPRequest = wmbapi.SendHttpRequest
	GetKeyState = wmbapi.GetKeyState
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
	IsMeshLoaded = wmbapi.IsMapLoaded
	CalculatePath = wmbapi.FindPath
	SetMaximumClimbAngle = wmbapi.SetClimbAngle
	GetMapId = wmbapi.GetCurrentMapInfo
	ObjectGUID = UnitGUID
	ObjectEntryID = UnitGUID
	ObjectIsType = wmbapi.ObjectIsType
	GetAnglesBetweenObjects = wmbapi.GetAnglesBetweenObjects
	FaceDirection = function(a) if wmbapi.GetObject(a) then wmbapi.FaceDirection(GetAnglesBetweenObjects(a,"player")*2,true) else wmbapi.FaceDirection(a,true) end end
	ObjectIsBehind = wmbapi.ObjectIsBehind
	ObjectDescriptor = wmbapi.ObjectDescriptor
	ObjectTypeFlags = wmbapi.ObjectTypeFlags
	ObjectField = wmbapi.ObjectField
	GetActivePlayer = function() return "player" end
	UnitIsFacing = function(unit1,unit2,degree) return ObjectIsFacing(unit1,unit2,math.rad(degree)/2) end
	UnitIsFalling = function(unit) return unit and UnitMovementFlags(unit) == wmbapi.GetUnitMovementFlagsTable().Falling end
	UnitMovementFlags = wmbapi.UnitMovementFlags
	UnitBoundingRadius = wmbapi.UnitBoundingRadius
	UnitCombatReach = wmbapi.UnitCombatReach
	UnitFlags = wmbapi.UnitFlags
	PlayerFlags = function() wmbapi.UnitFlags("player") end
	ObjectCreator = wmbapi.UnitCreator
	UnitCanBeLooted = wmbapi.UnitIsLootable
	UnitCanBeSkinned = wmbapi.UnitIsSkinnable
	UnitPitch = wmbapi.UnitPitch
	GetGroundZ = function(StartX, StartY, Flags) return TraceLine(StartX, StartY, 10000, StartX, StartY, -10000, Flags or 0x10) end
	GetCorpsePosition = wmbapi.GetCorpsePosition
	MoveTo = wmbapi.MoveTo
	ObjectDynamicFlags = wmbapi.ObjectDynamicFlags
	GetUnitTransport = wmbapi.UnitTransport
	GetUnitMovement = wmbapi.UnitMovementField
	WebsocketClose = wmbapi.CloseWebsocket
	WebsocketSend = wmbapi.SendWebsocketData
	ObjectPointer = wmbapi.GetObject
	UnitCreatureTypeID = wmbapi.UnitCreatureTypeId
	AesEncrypt = wmbapi.AesEncrypt
	AesDecrypt = wmbapi.AesDecrypt
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
		return wmbapi.GetObjectDescriptorsTable()[Offsets[string.lower(offset)]]
	end
	InitializeNavigation = function() end
	IsHackEnabled = function() end
end
