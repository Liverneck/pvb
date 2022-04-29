local LocalPlayer = LocalPlayer

surface.CreateFont("PVBHUDHealth", {
	font = "Roboto-Regular",
	size = 25,
	weight = 600,
	shadow = true
})

surface.CreateFont("PVBHUDTime", {
	font = "Roboto-Regular",
	size = 60,
	weight = 600,
	shadow = true
})

local maxx = ScrW()
local maxy = ScrH()

///////////////
//BOSS HEALTH//
///////////////
local function GetBossHealth()
	local num = 0
	for k,v in pairs(team.GetPlayers(TEAM_BOSS)) do
		num = num + v:Health()
	end
	return num
end

local BossHPMem = 0
local Plus = maxx / 2 + maxx / 6
local Minus = maxx / 2 - maxx / 6
local ScrOver6 = maxx / 6

function util.ToMinutesSeconds(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	return string.format("%02d:%02d", minutes, math.floor(seconds))
end

-- More appropriate for count downs. Timer will display 00:01 if less than a second remains and never display 00:00.
function util.ToMinutesSecondsCD(seconds)
	seconds = math.ceil(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	return string.format("%02d:%02d", minutes, seconds)
end

function util.ToMinutesSecondsMilliseconds(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	local milliseconds = math.floor(seconds % 1 * 100)

	return string.format("%02d:%02d.%02d", minutes, math.floor(seconds), milliseconds)
end

local function DrawDamageNumbers()
	local nextadm = {}

	for _, i in pairs(ArcticDamageNumbers) do

		cam.Start3D()

		local spos = i.pos:ToScreen()
		local x = spos.x
		local y = spos.y

		cam.End3D()

		cam.Start2D()

		surface.SetFont("ArcticDamageNum_Shadow")

		local width = surface.GetTextSize(tostring(i.num))

		surface.SetTextColor(0, 0, 0, 255 * i.life)
		surface.SetTextPos(x - (width / 2), y)
		surface.DrawText(tostring(i.num))

		surface.SetFont("ArcticDamageNum")

		surface.SetTextColor(255, 255 - i.num, 255 - i.num, 255 * i.life)
		surface.SetTextPos(x - (width / 2), y)
		surface.DrawText(tostring(i.num))

		i.pos = i.pos + Vector(0, 0, RealFrameTime() * 32)

		i.pos = i.pos + (i.vec * RealFrameTime() * 8)

		i.life = i.life - RealFrameTime() * (1 / GetConVar("adn_fadetime"):GetFloat())

		if i.life > 0 then
			table.insert(nextadm, i)
		end

		cam.End2D()
	end

	ArcticDamageNumbers = nextadm
end

local function DrawBossHealth()
	BossHPMem = Lerp(FrameTime() * 9, BossHPMem, GetBossHealth())
	surface.SetDrawColor(100,100,100)
	draw.NoTexture()
	surface.DrawPoly{
		{ x = Minus - 10, y = 0 },
		{ x = Plus + 10, y = 0 },
		{ x = Plus - 45, y = 55 },
		{ x = Minus + 45, y = 55 }
	}
		
	if math.Round(GetBossHealth() / PVB.TRANSMITTER:GetBossMaxHealth() * 100) > 75 then
		surface.SetDrawColor(55,92,255)
	elseif math.Round(GetBossHealth() / PVB.TRANSMITTER:GetBossMaxHealth() * 100) > 25 then
		surface.SetDrawColor(252,255,55)
	elseif math.Round(GetBossHealth() / PVB.TRANSMITTER:GetBossMaxHealth() * 100) <= 25 then
		surface.SetDrawColor(255,55,55)
	end

	render.SetScissorRect(0, 6, Minus + (Plus - Minus) * (BossHPMem / PVB.TRANSMITTER:GetBossMaxHealth()), 50, true)
	surface.DrawPoly{
		{ x = Minus, y = 0 },
		{ x = Plus, y = 0 },
		{ x = Plus - 50, y = 50 },
		{ x = Minus + 50, y = 50 }
	}
	render.SetScissorRect(0,0,0,0,false)
	surface.SetFont("PVBHUDHealth")
	local str = "Boss Health: " .. tostring(GetBossHealth() .. "/" .. tostring(PVB.TRANSMITTER:GetBossMaxHealth()) .. ", " .. tostring(math.Round(GetBossHealth() / PVB.TRANSMITTER:GetBossMaxHealth() * 100), 1) .. "%")
	local sizew, sizeh = surface.GetTextSize(str)
	surface.SetTextColor(Color(225,225,225,255))
	surface.SetTextPos(maxx / 2 - sizew / 2, sizeh - 10)
	surface.DrawText(str)
end

///////////////
//BOSS RAGE////
///////////////
local function DrawBossRage()
	surface.SetFont("PVBHUDHealth")
	local str = "Special: " .. tostring(math.Round(PVB.BossList[PVB.TRANSMITTER:GetBossInt()]:SpecialProgress(PVB.TRANSMITTER:GetBossPlayer()) * 100), 1) .. "%"
	local sizew, sizeh = surface.GetTextSize(str)
	surface.SetTextColor(Color(255,255,255))
	surface.SetTextPos(maxx / 2 - sizew / 2, sizeh + 30)
	surface.DrawText(str)
end


///////////////////
//END BOSS HEALTH//
///////////////////

///////////////////////
//LOCAL PLAYER HEALTH//
///////////////////////

local ScrOver6 = maxx / 5
local PlyHealthMem = 100
local function DrawPlayerHealth()
	PlyHealthMem = Lerp(FrameTime() * 12, PlyHealthMem, LocalPlayer():Health())
	surface.SetDrawColor(100,100,100)
	draw.NoTexture()
	surface.DrawPoly{
		{ x = 5, y = maxy - 50 },
		{ x = ScrOver6 + 15, y = maxy - 50 },
		{ x = ScrOver6 + 60, y = maxy },
		{ x = 5, y = maxy }
	}
	
	if math.Round(LocalPlayer():Health() / LocalPlayer():GetMaxHealth() * 100) > 75 then
		surface.SetDrawColor(55,255,55)
	elseif math.Round(LocalPlayer():Health() / LocalPlayer():GetMaxHealth() * 100) > 25 then
		surface.SetDrawColor(252,255,55)
	elseif math.Round(LocalPlayer():Health() / LocalPlayer():GetMaxHealth() * 100) <= 25 then
		surface.SetDrawColor(255,55,55)
	end
	render.SetScissorRect(0,0,0,0,false)
	render.SetScissorRect(5, maxy - 45, 5 + (ScrOver6 + 45 - 5) * (PlyHealthMem / LocalPlayer():GetMaxHealth()), maxy - 5, true)
	surface.DrawPoly{
		{ x = 10, y = maxy - 45 },
		{ x = ScrOver6 + 5, y = maxy - 45 },
		{ x = ScrOver6 + 45, y = maxy - 5 },
		{ x = 10, y = maxy-5 }
	}
	render.SetScissorRect(0,0,0,0,false)
	surface.SetFont("PVBHUDHealth")
	local str = tostring(LocalPlayer():Health() .. "/" .. tostring(LocalPlayer():GetMaxHealth()) .. ", " .. tostring(math.Round(LocalPlayer():Health() / LocalPlayer():GetMaxHealth() * 100), 1) .. "%")
	local _, sizeh = surface.GetTextSize(str)
	surface.SetTextColor(Color(225,225,225,255))
	surface.SetTextPos(20, maxy - sizeh - 11)
	surface.DrawText(str)
end


/////////////////////
//END PLAYER HEALTH//
/////////////////////



/////////////////////
/////Round Timer/////
/////////////////////
local time = 180
local roundtime = util.ToMinutesSecondsCD(time)
local function DrawRoundTimer()
	surface.SetDrawColor(85,85,85,231)
	surface.DrawOutlinedRect(10, 10, 150, 75, 2)
	surface.SetDrawColor(0,0,0,65)
	surface.DrawRect(10, 10, 150, 75)
	surface.SetTextColor(Color(225,225,225,255))
	surface.SetTextPos(20, 15, 150)
	surface.SetFont("PVBHUDTime")
	surface.DrawText(roundtime)
end



/////////////////////
//Queue Player Hud///
/////////////////////
local function DrawQueueHud()
	surface.SetDrawColor(61,61,61, 180)
	surface.DrawRect(10, 100, 250, 450)
	local str = "Boss Queue"
	surface.SetTextColor(Color(255,255,255))
	surface.SetTextPos(70, 115)
	surface.DrawText(str)

	local DisplayTab = player.GetAll()
	local Tablo = 155
	local count = 0
	table.sort(DisplayTab, function(a, b) return a:GetNWInt("QueuePoints", 0) > b:GetNWInt("QueuePoints", 0) end)
	for _, pl in ipairs(DisplayTab) do
		if count >= 13 then break end
		local strply = nil
		if #pl:Name() > 12 then
			strply = string.sub(pl:Name(), 1, 12) .. "... - " .. tostring(pl:GetNWInt("QueuePoints", 0))
		else
			strply = pl:Name() .. " - " .. tostring(pl:GetNWInt("QueuePoints", 0))
		end
		surface.SetTextPos(15, Tablo)
		Tablo = Tablo + 30
		surface.SetTextColor(Color(255,255,255))
		surface.DrawText(strply)
		count = count + 1
	end
end
///////////////////
//PLAYER WEAPON////
///////////////////

local function DrawWeaponName()
	surface.SetFont("PVBHUDHealth")
	local str = "Weapon: " .. tostring(LocalPlayer():GetActiveWeapon().PrintName)
	surface.SetTextColor(Color(255,255,255))
	surface.SetTextPos(10, maxy-80)
	surface.DrawText(str)
end

function GM:HUDPaint()
	if PVB.TRANSMITTER:GetRoundActive() then
		DrawDamageNumbers()
		DrawBossHealth()
		DrawBossRage()
		DrawQueueHud()
		DrawRoundTimer()
	end
	if LocalPlayer():Alive() and LocalPlayer():Team() ~= TEAM_SPECTATOR then
		DrawPlayerHealth()
		DrawWeaponName()
	end
end

local DontDraw = {
	CHudHealth = true,
	CHudAmmo = true,
	CHudDeathNotice = true,
	CHudDamageIndicator = true,
}

function GM:HUDShouldDraw(name)
	return not DontDraw[name]
end

function GM:DrawDeathNotice(x, y)
	return false
end
