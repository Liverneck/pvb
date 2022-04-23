local BOSS = {}
BOSS.Num = 1 //Boss ID number. 1,2,3,etc if making a new boss make sure it increments in order!
BOSS.PName = "Darth Vader" //Boss name
BOSS.Weapon = "vaderboss"
BOSS.Music = {
	vaderboss_music
}
//Put music in BOSS.Music for it to play during fight. 'pvb_enablebossmusic' in console controls if its playing (client side)


function BOSS:Init()
	local tabs = player.GetAll()
	table.sort(tabs, function(a, b) return a:GetNWInt("QueuePoints", 0) > b:GetNWInt("QueuePoints", 0) end)
	local ply = tabs[1]
	ply:SetNWInt("QueuePoints", 0)
	ply:SetTeam(TEAM_BOSS)
	ply.BossPlayerModel = "models/player/darth_vader.mdl" //Bosses Model
end

//Include weapons/ammo/armor/etc in BOSS:Loadout
function BOSS:Loadout(ply)
	ply:SetHealth(#team.GetPlayers(TEAM_PLAYERS) * 4800) //Health multiplier so health scales depending on player count
	ply:Give(BOSS.Weapon)
end
PVB.RegisterBossClass(BOSS)
