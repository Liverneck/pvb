TEAM_BOSS 		= 2
TEAM_PLAYERS 	= 1
GM.CreateTeams = function()
	team.SetUp(TEAM_BOSS, "Boss", Color(255,0,0,255))
	team.SetUp(TEAM_PLAYERS, "Players", Color(0,255,255,255))

	team.SetSpawnPoint(TEAM_PLAYERS, { "info_player_counterterrorist", "info_player_blue" })
	team.SetSpawnPoint(TEAM_BOSS, { "info_player_terrorist", "info_player_red" })
	team.SetSpawnPoint(TEAM_SPECTATOR, "worldspawn")
end

local count
function GM:AliveBosses()
	count = 0
	for _,v in pairs(team.GetPlayers(TEAM_BOSS)) do
		if v:Alive() then
			count = count + 1
		end
	end
	return count
end

function GM:AlivePlayers()
	count = 0
	for _,v in pairs(team.GetPlayers(TEAM_PLAYERS)) do
		if v:Alive() then
			count = count + 1
		end
	end
	return count
end

function GM:PlayerDeathThink( pl )
	return
end

--non
function GM:PlayerJoinTeam() return false end
function GM:PlayerRequestTeam() return false end
