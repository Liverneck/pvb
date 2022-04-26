include("cl_fonts.lua")
include("cl_hud.lua")

include("shared.lua")

local function FixWeapons()
	weapons.GetStored("tfa_gun_base").DrawHUD = nil
end

function GM:Initialize()
	FixWeapons()
	FixWeaponsShared()
end

local highlightedPlayers = {}
local NextTick = 0
function GM:Think()
	local time = CurTime()

	if NextTick <= time then
		NextTick = time + 0.1

		local players = team.GetPlayers(TEAM_PLAYERS)
		local tab = {}

		for _, ply in ipairs(players) do
			if ply:Alive() then
				tab[#tab + 1] = ply
			end	
		end

		if #tab == 1 then
			table.Add(tab, team.GetPlayers(TEAM_BOSS))
			highlightedPlayers = tab
		else
			highlightedPlayers = {}
		end		
	end
end

function GM:PreDrawHalos()
	halo.Add(highlightedPlayers, Color(0, 255, 0), 2, 2, 1, true, true)
end

function GM:CalcView(ply, origin, angles, fov, znear, zfar)
	if ply.KnockedDown and ply.KnockedDown:IsValid() then
		local rpos, rang = self:GetRagdollEyes(ply)
		if rpos then
			origin = rpos
			angles = rang
		end
	end

	return self.BaseClass.CalcView(self, ply, origin, angles, fov, znear, zfar)
end

local fadetime = CreateClientConVar("adn_fadetime", "0.75", true, false, "")

ArcticDamageNumbers = {}

function GM:OnEntityCreated(ent)
	if IsValid(ent) and ent:IsPlayer() then
		ent.DamageTaken = 0
	end
end

net.Receive("PVB.RoundStarted", function(len)
	BossHPMem = PVB.TRANSMITTER:GetBossMaxHealth()
	PlyHealthMem = LocalPlayer():Health()

	for _, ply in ipairs(player.GetAll()) do
		ply.DealtDamage = 0
		ply.DamageTaken = 0
	end
end)

net.Receive("SendDamages", function(len, ply)
	local pos = net.ReadVector()
	local dmg = net.ReadFloat()

	if fadetime:GetFloat() <= 0 then return end

	dmg = math.Round(dmg, 1)

	table.insert(ArcticDamageNumbers, {
		pos = pos,
		life = 1,
		num = dmg,
		vec = VectorRand()
	})
end)

net.Receive("SendBossDamages", function(len, ply)
	local dmg = net.ReadInt(16)
	local ent = net.ReadEntity()

	if dmg < 0 then
		ent.DamageTaken = 0
		return
	end

	if ent == PVB.TRANSMITTER:GetBossPlayer() then
		ent.DamageTaken = ent.DamageTaken + math.Round(dmg)
	end
end)
