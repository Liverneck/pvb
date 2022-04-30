local BOSS = {}

BOSS.PrintName = "Skolas, Kell of Kells" -- Boss name

BOSS.Weapons = {
	"skolasboss"
}

BOSS.Model = "models/konnie/asapgaming/destiny2/skolas.mdl"
BOSS.Music = {
	"bossmusic/skolassong.wav"
}

BOSS.Health = 2000
BOSS.HealthAdd = 1000
BOSS.SpecialHealthPerc = 0.9

-- Put music in BOSS.Music for it to play during fight. 'pvb_enablebossmusic' in console controls if its playing (client side)

function BOSS:Init()
	local tabs = player.GetAll()
	table.sort(tabs, function(a, b) return a:GetNWInt("QueuePoints", 0) > b:GetNWInt("QueuePoints", 0) end)
	local ply = tabs[1]
	ply:SetNWInt("QueuePoints", 0)
	ply:SetTeam(TEAM_BOSS)
	ply.BossPlayerModel = self.Model --Boss's Model

	ply:SetModelScale(1.5,.000001)
	ply:SetViewOffset(Vector(0, 0, 64)*1.5)
end

local requiredDamageFunc = function(ply)
	local enemies = #team.GetPlayers(TEAM_PLAYERS) -- Number of "players"
	return  enemies * BOSS.SpecialHealthPerc * BOSS.Health + BOSS.HealthAdd
end

function BOSS:CanUseSpecial(ply)
	if ply.DamageTaken >= requiredDamageFunc(ply) then
		return true
	end

	return false
end

function BOSS:SpecialProgress(ply)
	return math.min(ply.DamageTaken / requiredDamageFunc(ply), 1)
end

-- Include weapons/ammo/armor/etc in BOSS:Loadout
function BOSS:Loadout(ply)
	local enemies = #team.GetPlayers(TEAM_PLAYERS) -- Number of "players"
	local health = ((self.Health * enemies) ^ 1.0341) + self.HealthAdd -- Health multiplier so health scales depending on player count
	ply:SetHealth(health)
	
	for _, weapon in ipairs(self.Weapons) do
		ply:Give(weapon)

		ply:GiveAmmo(999999, "RPG_Round")
	end
end

PVB.RegisterBossClass(BOSS)
