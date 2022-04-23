local LocalPlayer = LocalPlayer

surface.CreateFont("PVBHUDHealth", {
	font = "Roboto-Regular",
	size = 25,
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

net.Receive("PVB.RoundStarted", function(len)
	BossHPMem = PVB.TRANSMITTER:GetBossMaxHealth()
	PlyHealthMem = LocalPlayer():Health()
end)

local BossHPMem = 0
local Plus = maxx / 2 + maxx / 6
local Minus = maxx / 2 - maxx / 6
local ScrOver6 = maxx / 6

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
	local str = "Special: " .. tostring(math.Round(GetBossHealth() / PVB.TRANSMITTER:GetBossMaxHealth() * 100), 1) .. "%"
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

hook.Add("HUDPaint", "PVB.CustomHUD", function()
	if PVB.TRANSMITTER:GetRoundActive() then
		DrawBossHealth()
		DrawBossRage()
	end
	if LocalPlayer():Alive() and LocalPlayer():Team() != TEAM_SPECTATOR then
		DrawPlayerHealth()
		DrawWeaponName()
	end
end)

local DontDraw = {
	CHudHealth = true,
	CHudAmmo = true,
	CHudDeathNotice = true
}

function GM:HUDShouldDraw( name )
	return !DontDraw[name]
end

function GM:DrawDeathNotice(x,y)
	return false
end
