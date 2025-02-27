util.AddNetworkString("SendDamages")
util.AddNetworkString("SendBossDamages")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("obj_player_extend.lua")

AddCSLuaFile("sh_util.lua")
AddCSLuaFile("team_spectator.lua")
AddCSLuaFile("team_players.lua")
AddCSLuaFile("team_boss.lua")
AddCSLuaFile("team_init.lua")

AddCSLuaFile("bosses/init.lua")
AddCSLuaFile("music/manifest.lua")
AddCSLuaFile("rounds/manifest.lua")
AddCSLuaFile("vgui/manifest.lua")
AddCSLuaFile("loadout/manifest.lua")
AddCSLuaFile("tutorial/sh_tutorial.lua")

include("content.lua")

include("obj_player_extend_sv.lua")

include("shared.lua")

local player_GetAll = player.GetAll
local ipairs = ipairs
local math_Round = math.Round
local math_abs = math.abs

local function FixWeapons()
	
end

function GM:Initialize()
	FixWeapons()
	FixWeaponsShared()
end

function GM:PostPlayerDeath(ply)
	if ply:Team() == TEAM_BOSS then
		timer.Simple(1, function()
			for _, pl in ipairs(player_GetAll()) do
				pl:Extinguish()
			end
		end)
	end
end

local NextTick = 0
function GM:Think()
	local time = CurTime()

	if NextTick <= time then
		NextTick = time + 1

		for _, ply in ipairs(team.GetPlayers(TEAM_PLAYERS)) do
			if ply:IsValid() and ply:Alive() and ply:Health() < ply:GetMaxHealth() and ply.LastDamageTime + 15 < CurTime() then
				ply:SetHealth(ply:Health() + 1)
			end
		end
	end
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if ply:Team() == TEAM_BOSS and not wep.BossOnly then
		return false
	end

	return true
end

function GM:PlayerInitialSpawn( pl, transiton )
	pl:SetTeam( TEAM_UNASSIGNED )
end

function GM:PlayerSpawn( ply, transiton )
	if self.TeamBased and (ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED) then
		self:PlayerSpawnAsSpectator(ply)
		return
	end

	-- Stop observer mode
	ply:UnSpectate()

	ply:SetupHands()

	player_manager.OnPlayerSpawn( ply, transiton )
	player_manager.RunClass( ply, "Spawn" )

	-- If we are in transition, do not touch player's weapons
	if not transiton then
		-- Call item loadout function
		hook.Call("PlayerLoadout", GAMEMODE, ply)
	end

	-- Set player model
	hook.Call("PlayerSetModel", GAMEMODE, ply)

	ply.DealtDamage = 0
	ply.DamageTaken = 0
end

function GM:EntityTakeDamage(ent, dmg)
	ent.LastDamageTime = CurTime()
	
	local ply = dmg:GetAttacker()

	if not ply:IsPlayer() then return end
	if not ent:IsPlayer() then return end
	local entTeam = ent:Team()
	if entTeam == ply:Team() then return end
	if ent:Health() == 0 then return end
	
	local pos = dmg:GetDamagePosition()
	local num = dmg:GetDamage()
	
	if entTeam == TEAM_BOSS then
		ent:SetVelocity(dmg:GetDamageForce() * 0.01)
		ply.DealtDamage = ply.DealtDamage + num
		ent.DamageTaken = ent.DamageTaken + num
		
		net.Start("SendBossDamages")
		net.WriteInt(num, 16)
		net.WriteEntity(ent)
		net.Broadcast()
	end
	
	num = math_Round(num, 1)
	if num <= 0 then return end
	
	if not pos then
		pos = ent:GetPos()
	end

	net.Start("SendDamages", true)
	net.WriteVector(pos)
	net.WriteFloat(num)
	net.Send(ply)
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if attacker:IsWeapon() then
		if ply:Team() == attacker:GetOwner():Team() then
			return false
		end
	elseif attacker:IsPlayer() and attacker:Team() == ply:Team() then
		return false
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
		
		local speedAddition = math_abs( move:GetForwardSpeed() * speedBoostPerc )
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
