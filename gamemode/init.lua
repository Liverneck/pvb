AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("team_spectator.lua")
AddCSLuaFile("team_players.lua")
AddCSLuaFile("team_boss.lua")
AddCSLuaFile("team_init.lua")

AddCSLuaFile("bosses/init.lua")
AddCSLuaFile("music/manifest.lua")
AddCSLuaFile("sh_config.lua")
AddCSLuaFile("rounds/manifest.lua")
AddCSLuaFile("hud/manifest.lua")
AddCSLuaFile("vgui/manifest.lua")
AddCSLuaFile("loadout/manifest.lua")
AddCSLuaFile("tutorial/sh_tutorial.lua")

include("content.lua")

include("shared.lua")

function GM:PlayerShouldTakeDamage(ply, attacker)
	if attacker:IsWeapon() then
		if ply:Team() == attacker:GetOwner():Team() then
			return false
		end
	end

	return true
end

function GM:CanPlayerSuicide(ply)
	if ply:IsSuperAdmin() or ply:IsAdmin() then
		return true
	end
end

local JUMPING = {}
function GM:StartMove( ply, move )
	-- Only apply the jump boost in FinishMove if the player has jumped during this frame
	-- Using a global variable is safe here because nothing else happens between SetupMove and FinishMove
	if bit.band( move:GetButtons(), IN_JUMP ) ~= 0 and bit.band( move:GetOldButtons(), IN_JUMP ) == 0 and ply:OnGround() then
		JUMPING[ply:SteamID()] = true
	end
end

function GM:FinishMove( ply, move )
	-- If the player has jumped this frame
	if JUMPING[ply:SteamID()] then
		-- Get their orientation
		local forward = move:GetAngles()
		forward.p = 0
		forward = forward:Forward()
		
		-- Compute the speed boost
		
		-- HL2 normally provides a much weaker jump boost when sprinting
		-- For some reason this never applied to GMod, so we won't perform
		-- this check here to preserve the "authentic" feeling
		local speedBoostPerc = ( ( not ply:Crouching() ) and 0.5 ) or 0.1
		
		local speedAddition = math.abs( move:GetForwardSpeed() * speedBoostPerc )
		local maxSpeed = move:GetMaxSpeed() * ( 1 + speedBoostPerc )
		local newSpeed = speedAddition + move:GetVelocity():Length2D()
		
		-- Clamp it to make sure they can't bunnyhop to ludicrous speed
		if newSpeed > maxSpeed then
			speedAddition = speedAddition - (newSpeed - maxSpeed)
		end
		
		/*-- Reverse it if the player is running backwards
		if move:GetVelocity():Dot(forward) < 0 then
			speedAddition = -speedAddition
		end*/
		
		-- Apply the speed boost
		move:SetVelocity(forward * speedAddition + move:GetVelocity())
	end
	
	JUMPING[ply:SteamID()] = nil
end
