-- LubDraw by docbrown on fh-wow.com

local libdraw
local sin, cos, atan, atan2, sqrt, rad = math.sin, math.cos, math.atan, math.atan2, math.sqrt, math.rad
local tinsert, tremove = tinsert, tremove


local function WorldToScreen (wX, wY, wZ)
	local sX, sY = _G.WorldToScreen(wX, wY, wZ);
	local a = 1;
	local b = 1;
	if bntapi then
		a = 1365;
		b = 768;
	end
	if sX and sY then
		return sX*a, -(WorldFrame:GetTop() - sY*b)
	elseif sX then
		return sX*a, sY;
	elseif sY then
		return sX, sY*b;
	else
		return sX, sY;
	end
end

if LibStub then
	-- LibStub version control
	libdraw = LibStub:NewLibrary("libdraw-1.0", 3)
	if not libdraw then return end
else
	-- Pretty much LibStub
	libdraw = {
		version = 1.3
	}
	if _G['libdraw'] and _G['libdraw'].version and _G['libdraw'].version > libdraw.version then
		return
	else
		_G['libdraw'] = libdraw
	end
end

libdraw.line = libdraw.line or { r = 0, g = 1, b = 0, a = 1, w = 1 }
libdraw.level = "BACKGROUND"
libdraw.callbacks = { }

if not libdraw.canvas then
	libdraw.canvas = CreateFrame("Frame", WorldFrame)
	libdraw.canvas:SetAllPoints(WorldFrame)
	libdraw.lines = { }
	libdraw.lines_used = { }
	libdraw.textures = { }
	libdraw.textures_used = { }
	libdraw.fontstrings = { }
	libdraw.fontstrings_used = { }
end

function libdraw.SetColor(r, g, b, a)
	libdraw.line.r = r * 0.00390625
	libdraw.line.g = g * 0.00390625
	libdraw.line.b = b * 0.00390625
	if a then
		libdraw.line.a = a * 0.01
	else
		libdraw.line.a = 1
	end
end

function libdraw.SetColorRaw(r, g, b, a)
	libdraw.line.r = r
	libdraw.line.g = g
	libdraw.line.b = b
	libdraw.line.a = a
end

function libdraw.SetWidth(w)
	libdraw.line.w = w
end

function libdraw.Line(sx, sy, sz, ex, ey, ez)
	if not WorldToScreen then return end

	local sx, sy = WorldToScreen(sx, sy, sz)
	local ex, ey = WorldToScreen(ex, ey, ez)

	libdraw.Draw2DLine(sx, sy, ex, ey)
end

function libdraw.rotateX(cx, cy, cz, px, py, pz, r)
	if r == nil then return px, py, pz end
	local s = sin(r)
	local c = cos(r)
	-- center of rotation
	px, py, pz = px - cx,  py - cy, pz - cz
	local x = px + cx
	local y = ((py * c - pz * s) + cy)
	local z = ((py * s + pz * c) + cz)
	return x, y, z
end

function libdraw.rotateY(cx, cy, cz, px, py, pz, r)
	if r == nil then return px, py, pz end
	local s = sin(r)
	local c = cos(r)
	-- center of rotation
	px, py, pz = px - cx,  py - cy, pz - cz
	local x = ((pz * s + px * c) + cx)
	local y = py + cy
	local z = ((pz * c - px * s) + cz)
	return x, y, z
end

function libdraw.rotateZ(cx, cy, cz, px, py, pz, r)
	if r == nil then return px, py, pz end
	local s = sin(r)
	local c = cos(r)
	-- center of rotation
	px, py, pz = px - cx,  py - cy, pz - cz
	local x = ((px * c - py * s) + cx)
	local y = ((px * s + py * c) + cy)
	local z = pz + cz
	return x, y, z
end

function libdraw.Array(vectors, x, y, z, rotationX, rotationY, rotationZ)
	for _, vector in ipairs(vectors) do
		local sx, sy, sz = x+vector[1], y+vector[2], z+vector[3]
		local ex, ey, ez = x+vector[4], y+vector[5], z+vector[6]

		if rotationX then
			sx, sy, sz = libdraw.rotateX(x, y, z, sx, sy, sz, rotationX)
			ex, ey, ez = libdraw.rotateX(x, y, z, ex, ey, ez, rotationX)
		end
		if rotationY then
			sx, sy, sz = libdraw.rotateY(x, y, z, sx, sy, sz, rotationY)
			ex, ey, ez = libdraw.rotateY(x, y, z, ex, ey, ez, rotationY)
		end
		if rotationZ then
			sx, sy, sz = libdraw.rotateZ(x, y, z, sx, sy, sz, rotationZ)
			ex, ey, ez = libdraw.rotateZ(x, y, z, ex, ey, ez, rotationZ)
		end

		local sx, sy = WorldToScreen(sx, sy, sz)
		local ex, ey = WorldToScreen(ex, ey, ez)
		libdraw.Draw2DLine(sx, sy, ex, ey)
	end
end

function libdraw.Draw2DLine(sx, sy, ex, ey)

	if not WorldToScreen or not sx or not sy or not ex or not ey then return end

	local L = tremove(libdraw.lines) or false
	if L == false then
		L = CreateFrame("Frame", libdraw.canvas)
    L.line = L:CreateLine()
		L.line:SetDrawLayer(libdraw.level)
	end
	tinsert(libdraw.lines_used, L)

  L:ClearAllPoints()

  if sx > ex and sy > ey or  sx < ex and sy < ey  then
    L:SetPoint("TOPRIGHT", libdraw.canvas, "TOPLEFT", sx, sy)
    L:SetPoint("BOTTOMLEFT", libdraw.canvas, "TOPLEFT", ex, ey)
    L.line:SetStartPoint('TOPRIGHT')
    L.line:SetEndPoint('BOTTOMLEFT')
  elseif sx < ex and sy > ey then
    L:SetPoint("TOPLEFT", libdraw.canvas, "TOPLEFT", sx, sy)
    L:SetPoint("BOTTOMRIGHT", libdraw.canvas, "TOPLEFT", ex, ey)
    L.line:SetStartPoint('TOPLEFT')
    L.line:SetEndPoint('BOTTOMRIGHT')
  elseif sx > ex and sy < ey then
    L:SetPoint("TOPRIGHT", libdraw.canvas, "TOPLEFT", sx, sy)
    L:SetPoint("BOTTOMLEFT", libdraw.canvas, "TOPLEFT", ex, ey)
    L.line:SetStartPoint('TOPLEFT')
    L.line:SetEndPoint('BOTTOMRIGHT')
  else
    -- wat, I don't like this, not one bit
    L:SetPoint("TOPLEFT", libdraw.canvas, "TOPLEFT", sx, sy)
    L:SetPoint("BOTTOMLEFT", libdraw.canvas, "TOPLEFT", sx, ey)
    L.line:SetStartPoint('TOPLEFT')
    L.line:SetEndPoint('BOTTOMLEFT')
  end

  L.line:SetThickness(libdraw.line.w)
	L.line:SetColorTexture(libdraw.line.r, libdraw.line.g, libdraw.line.b, libdraw.line.a)

	L:Show()

end

local full_circle = rad(365)
local small_circle_step = rad(3)

function libdraw.Circle(x, y, z, size)
	local lx, ly, nx, ny, fx, fy = false, false, false, false, false, false
	for v=0, full_circle, small_circle_step do
		nx, ny = WorldToScreen( (x+cos(v)*size), (y+sin(v)*size), z )
		libdraw.Draw2DLine(lx, ly, nx, ny)
		lx, ly = nx, ny
	end
end

local flags = bit.bor(0x100)

function libdraw.GroundCircle(x, y, z, size)
	local lx, ly, nx, ny, fx, fy, fz = false, false, false, false, false, false, false
	for v=0, full_circle, small_circle_step do
		fx, fy, fz = TraceLine(  (x+cos(v)*size), (y+sin(v)*size), z+100, (x+cos(v)*size), (y+sin(v)*size), z-100, flags )
		if fx == nil then
			fx, fy, fz = (x+cos(v)*size), (y+sin(v)*size), z
		end
		nx, ny = WorldToScreen( (fx+cos(v)*size), (fy+sin(v)*size), fz )
		libdraw.Draw2DLine(lx, ly, nx, ny)
		lx, ly = nx, ny
	end
end

function libdraw.Arc(x, y, z, size, arc, rotation)
	local lx, ly, nx, ny, fx, fy = false, false, false, false, false, false
	local half_arc = arc * 0.5
	local ss = (arc/half_arc)
	local as, ae = -half_arc, half_arc
	for v = as, ae, ss do
		nx, ny = WorldToScreen( (x+cos(rotation+rad(v))*size), (y+sin(rotation+rad(v))*size), z )
		if lx and ly then
			libdraw.Draw2DLine(lx, ly, nx, ny)
		else
			fx, fy = nx, ny
		end
		lx, ly = nx, ny
	end
	local px, py = WorldToScreen(x, y, z)
	libdraw.Draw2DLine(px, py, lx, ly)
	libdraw.Draw2DLine(px, py, fx, fy)
end

function libdraw.Texture(config, x, y, z, alphaA)

	local texture, width, height = config.texture, config.width, config.height
	local left, right, top, bottom, scale =  config.left, config.right, config.top, config.bottom, config.scale
	local alpha = config.alpha or alphaA

	if not WorldToScreen or not texture or not width or not height or not x or not y or not z then return end
	if not left or not right or not top or not bottom then
		left = 0
		right = 1
		top = 0
		bottom = 1
	end
	if not scale then
		local cx, cy, cz = GetCameraPosition()
		scale = width / libdraw.Distance(x, y, z, cx, cy, cz)
	end

	local sx, sy = WorldToScreen(x, y, z)
	if not sx or not sy then return end
	local w = width * scale
	local h = height * scale
	sx = sx - w*0.5
	sy = sy + h*0.5
	local ex, ey = sx + w, sy - h

	local T = tremove(libdraw.textures) or false
	if T == false then
		T = libdraw.canvas:CreateTexture(nil, "BACKGROUND")
		T:SetDrawLayer(libdraw.level)
		T:SetTexture(libdraw.texture)
	end
	tinsert(libdraw.textures_used, T)
	T:ClearAllPoints()
	T:SetTexCoord(left, right, top, bottom)
	T:SetTexture(texture)
	T:SetWidth(width)
	T:SetHeight(height)
	T:SetPoint("TOPLEFT", libdraw.canvas, "TOPLEFT", sx, sy)
	T:SetPoint("BOTTOMRIGHT", libdraw.canvas, "TOPLEFT", ex, ey)
	T:SetVertexColor(1, 1, 1, 1)
	if alpha then T:SetAlpha(alpha) else T:SetAlpha(1) end
	T:Show()

end

function libdraw.Text(text, font, x, y, z)

	local sx, sy = WorldToScreen(x, y, z)

	if sx and sy then

		local F = tremove(libdraw.fontstrings) or libdraw.canvas:CreateFontString(nil, "BACKGROUND")

		F:SetFontObject(font)
		F:SetText(text)
		F:SetTextColor(libdraw.line.r, libdraw.line.g, libdraw.line.b, libdraw.line.a)

		if p then
			local width = F:GetStringWidth() - 4
			local offsetX = width*0.5
			local offsetY = F:GetStringHeight() + 3.5
			local pwidth = width*p*0.01
			FHAugment.drawLine(sx-offsetX, sy-offsetY, (sx+offsetX), sy-offsetY, 4, r, g, b, 0.25)
			FHAugment.drawLine(sx-offsetX, sy-offsetY, (sx+offsetX)-(width-pwidth), sy-offsetY, 4, r, g, b, 1)
		end

		F:SetPoint("TOPLEFT", UIParent, "TOPLEFT", sx-(F:GetStringWidth()*0.5), sy)
		F:Show()

		tinsert(libdraw.fontstrings_used, F)

	end

end

local rad90 = math.rad(-90)

function libdraw.Box(x, y, z, width, height, rotation, offset_x, offset_y)

	if not offset_x then offset_x = 0 end
	if not offset_y then offset_y = 0 end

	if rotation then rotation = rotation + rad90 end

	local half_width = width * 0.5
	local half_height = height * 0.5

	local p1x, p1y = libdraw.rotateZ(x, y, z, x - half_width + offset_x, y - half_width + offset_y, z, rotation)
	local p2x, p2y = libdraw.rotateZ(x, y, z, x + half_width + offset_x, y - half_width + offset_y, z, rotation)
	local p3x, p3y = libdraw.rotateZ(x, y, z, x - half_width + offset_x, y + half_width + offset_y, z, rotation)
	local p4x, p4y = libdraw.rotateZ(x, y, z, x - half_width + offset_x, y - half_width + offset_y, z, rotation)
	local p5x, p5y = libdraw.rotateZ(x, y, z, x + half_width + offset_x, y + half_width + offset_y, z, rotation)
	local p6x, p6y = libdraw.rotateZ(x, y, z, x + half_width + offset_x, y - half_width + offset_y, z, rotation)
	local p7x, p7y = libdraw.rotateZ(x, y, z, x - half_width + offset_x, y + half_width + offset_y, z, rotation)
	local p8x, p8y = libdraw.rotateZ(x, y, z, x + half_width + offset_x, y + half_width + offset_y, z, rotation)

	libdraw.Line(p1x, p1y, z, p2x, p2y, z)
	libdraw.Line(p3x, p3y, z, p4x, p4y, z)
	libdraw.Line(p5x, p5y, z, p6x, p6y, z)
	libdraw.Line(p7x, p7y, z, p8x, p8y, z)

end

local deg45 = math.rad(45)
local arrowX = {
	{ 0  , 0, 0, 1.5,  0,    0   },
	{ 1.5, 0, 0, 1.2,  0.2, -0.2 },
	{ 1.5, 0, 0, 1.2, -0.2,  0.2 }
}
local arrowY = {
	{ 0, 0  , 0,  0  , 1.5,  0   },
	{ 0, 1.5, 0,  0.2, 1.2, -0.2 },
	{ 0, 1.5, 0, -0.2, 1.2,  0.2 }
}
local arrowZ = {
	{ 0, 0, 0  ,  0,    0,   1.5 },
	{ 0, 0, 1.5,  0.2, -0.2, 1.2 },
	{ 0, 0, 1.5, -0.2,  0.2, 1.2 }
}

function libdraw.DrawHelper()
	local playerX, playerY, playerZ = ObjectPosition("player")
	local old_red, old_green, old_blue, old_alpha, old_width = libdraw.line.r, libdraw.line.g, libdraw.line.b, libdraw.line.a, libdraw.line.w

	-- X
	libdraw.SetColor(255, 0, 0, 100)
	libdraw.SetWidth(1)
	libdraw.Array(arrowX, playerX, playerY, playerZ, deg45, false, false)
	libdraw.Text('X', "GameFontNormal", playerX + 1.75, playerY, playerZ)
	-- Y
	libdraw.SetColor(0, 255, 0, 100)
	libdraw.SetWidth(1)
	libdraw.Array(arrowY, playerX, playerY, playerZ, false, -deg45, false)
	libdraw.Text('Y', "GameFontNormal", playerX, playerY + 1.75, playerZ)
	-- Z
	libdraw.SetColor(0, 0, 255, 100)
	libdraw.SetWidth(1)
	libdraw.Array(arrowZ, playerX, playerY, playerZ, false, false, false)
	libdraw.Text('Z', "GameFontNormal", playerX, playerY, playerZ + 1.75)

	libdraw.line.r, libdraw.line.g, libdraw.line.b, libdraw.line.a, libdraw.line.w = old_red, old_green, old_blue, old_alpha, old_width
end

function libdraw.Distance(ax, ay, az, bx, by, bz)
	return math.sqrt(((bx-ax)*(bx-ax)) + ((by-ay)*(by-ay)) + ((bz-az)*(bz-az)))
end

function libdraw.Camera()
	local fX, fY, fZ = ObjectPosition("player")
	local sX, sY, sZ = GetCameraPosition()
	return sX, sY, sZ, atan2(sY - fY, sX - fX), atan((sZ - fZ) / sqrt(((fX - sX) ^ 2) + ((fY - sY) ^ 2)))
end

function libdraw.Sync(callback)
	tinsert(libdraw.callbacks, callback)
end

function libdraw.clearCanvas()
	-- libdraw.stats = #libdraw.textures_used
	for i = #libdraw.textures_used, 1, -1 do
		libdraw.textures_used[i]:Hide()
		tinsert(libdraw.textures, tremove(libdraw.textures_used))
	end
	for i = #libdraw.fontstrings_used, 1, -1 do
		libdraw.fontstrings_used[i]:Hide()
		tinsert(libdraw.fontstrings, tremove(libdraw.fontstrings_used))
	end
  for i = #libdraw.lines_used, 1, -1 do
		libdraw.lines_used[i]:Hide()
		tinsert(libdraw.lines, tremove(libdraw.lines_used))
	end
end

local function OnUpdate()
	libdraw.clearCanvas()
	for _, callback in ipairs(libdraw.callbacks) do
		callback()
		if libdraw.helper then
			libdraw.DrawHelper()
		end
		libdraw.helper = false
	end
end

function libdraw.Enable(interval)
	local timer
	if not interval then
		timer = C_Timer.NewTicker(interval, OnUpdate)
	else
		timer = C_Timer.NewTicker(interval, OnUpdate)
	end
	return timer
end

--libdraw.canvas:SetScript("OnUpdate", OnUpdate)