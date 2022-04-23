
GM.Version = "0.2"
GM.Name = "Players VS BOSS"
GM.Author = "By Ancient Entity & Friends"
GM.Config = {}
PVB = {}

DeriveGamemode("base")
DEFINE_BASECLASS("gamemode_base")

include("team_spectator.lua")
include("team_players.lua")
include("team_boss.lua")
include("team_init.lua")
include("bosses/init.lua")
include("music/manifest.lua")
include("sh_config.lua")
include("rounds/manifest.lua")
include("hud/manifest.lua")
include("vgui/manifest.lua")
include("loadout/manifest.lua")
include("tutorial/sh_tutorial.lua")
