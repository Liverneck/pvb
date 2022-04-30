local BOSS = {}

BOSS.PrintName = "Darth Vader" -- Boss name

BOSS.Weapons = {
	"vaderboss"
}

BOSS.Model = "models/player/darth_vader.mdl"
BOSS.Music = {
	"bossmusic/vaderboss_music.wav"
}

BOSS.Health = 1500
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
	end
end

PVB.RegisterBossClass(BOSS)
