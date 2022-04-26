
GM.Version = "0.2"
GM.Name = "Players VS BOSS"
GM.Author = "By Ancient Entity & Friends"
GM.TeamBased = true
GM.MinPlayers = 2

PVB = {}

DeriveGamemode("base")
DEFINE_BASECLASS("gamemode_base")

include("sh_util.lua")
include("team_spectator.lua")
include("team_players.lua")
include("team_boss.lua")
include("team_init.lua")
include("bosses/init.lua")
include("music/manifest.lua")
include("rounds/manifest.lua")
include("vgui/manifest.lua")
include("loadout/manifest.lua")
include("tutorial/sh_tutorial.lua")

GM.ShowTeam = nil

function GM:GetRagdollEyes(ply)
	local Ragdoll = ply:GetRagdollEntity()
	if not Ragdoll or not Ragdoll:IsValid() then return end

	local att = Ragdoll:GetAttachment(Ragdoll:LookupAttachment("eyes"))
	if att then
		att.Pos = att.Pos + att.Ang:Forward() * -2
		att.Ang = att.Ang

		return att.Pos, att.Ang
	end
end

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
