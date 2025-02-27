DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.DisplayName			= "Player"
PLAYER.WalkSpeed 			= 300
PLAYER.RunSpeed				= 300
PLAYER.CrouchedWalkSpeed 	= 0.4
PLAYER.DuckSpeed			= 0.3
PLAYER.UnDuckSpeed			= 0.3
PLAYER.JumpPower			= 200
PLAYER.CanUseFlashlight     = true
PLAYER.MaxHealth			= 100
PLAYER.StartHealth			= 100
PLAYER.StartArmor			= 0
PLAYER.DropWeaponOnDie		= true
PLAYER.AvoidPlayers			= false

player_manager.RegisterClass( "class_player", PLAYER, "player_default" )

