
GM.Version = "0.2"
GM.Name = "Players VS BOSS"
GM.Author = "By Ancient Entity & Friends"
GM.TeamBased = true
GM.MinPlayers = 2

PVB = {}

DeriveGamemode("base")
DEFINE_BASECLASS("gamemode_base")

GM.ShowTeam = nil

include("sh_util.lua")
include("team_spectator.lua")
include("team_players.lua")
include("team_boss.lua")
include("team_init.lua")
include("bosses/init.lua")
include("music/manifest.lua")
include("rounds/manifest.lua")
include("hud/manifest.lua")
include("vgui/manifest.lua")
include("loadout/manifest.lua")
include("tutorial/sh_tutorial.lua")

function FixWeaponsShared()
	for _, wep in ipairs(weapons.GetList()) do
		local wepTab = weapons.GetStored(wep.ClassName)

		if wepTab.Primary then
			wepTab.Primary.KickUp = 0
			wepTab.Primary.KickDown = 0
			wepTab.Primary.KickHorizontal = 0
			wepTab.Primary.StaticRecoilFactor = 0
		end
	end

	local magnumdrill = weapons.GetStored("tfa_cso_magnumdrill")
	magnumdrill.PrimaryAttack = function(wepSelf)
		wepSelf:SecondaryAttack()
	end
end
