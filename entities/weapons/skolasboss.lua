SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "Destiny Weapons"
SWEP.Author							= "Delta, Heavily Modified by Liverneck"
SWEP.Contact						= "https://steamcommunity.com/id/DeltaDesigns/"
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Shrapnel Launcher"
SWEP.Type							= ""
SWEP.DrawAmmo						= false
SWEP.data 							= {}
SWEP.data.ironsights				= 0
SWEP.Secondary.IronFOV				= 70
SWEP.Slot							= 2
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true
SWEP.BossOnly = true
SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= true
SWEP.OnlyBurstFire					= false
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.Ammo					= "RPG_Round" //or "d2_heavy"

SWEP.Primary.ClipSize				= 4
SWEP.Primary.DefaultClip			= 50
SWEP.Primary.RPM					= 40
SWEP.Secondary.IronSightsEnabled = false
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= 80
SWEP.Primary.Delay				    = 0
SWEP.Primary.Sound 					= Sound ("TFA_LOW_FIRE.1")
SWEP.Primary.ReloadSound 			= Sound ("TFA_LOW_RELOAD.1")

SWEP.Primary.ProjectileDelay = 0 --Entity to shoot
SWEP.Primary.Projectile = "skolas_projectile" --Entity to shoot
SWEP.Primary.ProjectileVelocity = 1500  --Entity to shoot's velocity
SWEP.Primary.ProjectileModel = nil --Entity to shoot's model

SWEP.Primary.PenetrationMultiplier 	= 1
SWEP.MaxPenetrationCounter = 1 --The maximum number of ricochets.  To prevent stack overflows.
SWEP.Primary.Damage					= 20
SWEP.Primary.HullSize 				= 10
SWEP.DamageType 					= DMG_BULLET


SWEP.DoMuzzleFlash 					= false

SWEP.IronRecoilMultiplier			= 0.9
SWEP.CrouchRecoilMultiplier			= 0.85
SWEP.JumpRecoilMultiplier			= 2
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.2
SWEP.CrouchAccuracyMultiplier		= 0.8
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 10
SWEP.WalkAccuracyMultiplier			= 1.8
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.25
SWEP.SprintFOVOffset 				= 2

SWEP.ViewModel						= "models/weapons/c_lord_of_wolves.mdl"
SWEP.ViewModelFOV					= 54
SWEP.ViewModelFlip					= false
SWEP.UseHands 						= true
SWEP.HoldType 						= "crossbow"
SWEP.ReloadHoldTypeOverride 		= "crossbow"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(1.2, -9, .2)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 1
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
--SWEP.TracerName 					= "tracer_thorn"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0
SWEP.ImpactEffect 					= "impact"



SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Vector(0, 0, 0)

SWEP.IronSightTime 					= 0.4
SWEP.Primary.KickUp					= 0.5
SWEP.Primary.KickDown				= 0.5
SWEP.Primary.KickHorizontal			= 0.09
SWEP.Primary.StaticRecoilFactor 	= 0.45
SWEP.Primary.Spread					= 0.05
SWEP.Primary.IronAccuracy 			= 0.01
SWEP.Primary.SpreadMultiplierMax 	= 1.3
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 0.45
SWEP.IronSightsMoveSpeed 			= 0.45
SWEP.AllowSprintAttack = false --Shoot while sprinting?

SWEP.IronSightsPos = Vector(-8.336, -8, 0.07)
SWEP.IronSightsAng = Vector(-3.518, -5.7, -.1)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(3.819, -7.639, -5.026)
SWEP.InspectAng = Vector(21.106, 24.622, 7.034)

SWEP.Attachments = {
	[1] = { offset = { 0, 0 }, atts = { "low_release_the_wolves", "low_extended_mag" }, order = 1 },
	[2] = { offset = { 0, 0 }, atts = { "low_splice_of_life" }, order = 2 }
}
SWEP.WElements = {
	["world"] = { type = "Model", model = "models/weapons/c_lord_of_wolves.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-12.988, 6.752, -7.301), angle = Angle(-8.183, 2, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }}


SWEP.ThirdPersonReloadDisable		= false



SWEP.AutomaticFrameAdvance = true -- Must be set on client

DEFINE_BASECLASS( SWEP.Base )

function SWEP:Think(...)
	VModel = self.Owner:GetViewModel( )
	reload = VModel:SelectWeightedSequence( ACT_VM_RELOAD )

	if CLIENT then

		local pOwnerEA = self:GetOwner():EyeAngles()
		local lightorigin = self.Owner:GetShootPos() + pOwnerEA:Forward() * 39 + pOwnerEA:Up() * 1
		if !self:GetIronSights( issighting ) then
			lightorigin = self.Owner:GetShootPos() + pOwnerEA:Forward() * 39 + pOwnerEA:Up() * 1
		end

		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.pos = lightorigin
			dlight.r = 255
			dlight.g = 50
			dlight.b = 0
			dlight.brightness = 5
			dlight.Decay = 2048
			dlight.Size = 30
			dlight.Style = 6				
			dlight.DieTime = CurTime() + 1
			dlight.noworld = false
			dlight.nomodel = false
		end
	end

	local owner = self:GetOwner()

	if owner:KeyPressed(IN_ATTACK2) and owner:IsOnGround() and (self:GetLeapCool() < CurTime()) then
		local ang = owner:EyeAngles()
		ang.pitch = math.min(-45, ang.pitch)

		owner:SetGroundEntity(NULL)
		owner:SetVelocity(550 * ang:Forward())
		owner:SetAnimation(PLAYER_JUMP)

		self:SetLeapCool(CurTime() + 7.5)
	end

	return BaseClass.Think(self, ...)
end

function SWEP:ShootBullet()
	local num = 1
	local rec, aimcone

	for i = 1, num do
	if SERVER then
		timer.Simple( 0, function()
			if ( not IsValid(self) ) or ( not IsValid(self:GetOwner()) ) then return end
			aimcone = 0
			
				local ent = ents.Create(self.Primary.Projectile)
				local dir
				local ang = self.Owner:EyeAngles()

				local attachmentID=self:LookupAttachment("Muzzle")
				local muzzle = self:GetAttachment( attachmentID )
	  		
				dir = ang:Forward()
				ent:SetPos(self.Owner:GetShootPos() + ang:Forward()*20 + ang:Right()*13 + ang:Up()*-10)

				ent.Owner = self.Owner
				
				ent.damage = self.Primary.Damage
				ent.mydamage = self.Primary.Damage
				local trail = util.SpriteTrail(ent, 0, Color(255,179,128,200), true, 13, 2, .5, 1/(15+1)*0.5, "trails/smoke.vmt")

				ent:Spawn()
				ent:SetVelocity(dir * self.Primary.ProjectileVelocity)
				local phys = ent:GetPhysicsObject()

				if IsValid(phys) then
					phys:SetVelocity(dir * self.Primary.ProjectileVelocity)
					phys:EnableGravity( true )
					phys:EnableDrag(false)
				end

				ent:SetOwner(self.Owner)

				self.IdleAnimation = CurTime() + self:SequenceDuration()
			
		end)
	end
	end
end

function SWEP:DrawHUD()

	local str = math.max(math.Round(self:GetLeapCool() - CurTime(),1),0)

	local textcolor = Color(255,255,255)

	if str > 0 then
		textcolor = Color(255,0,0)
		str = "Leap: " .. str .. "s"
	else
		str = "Leap Ready"
	end

	surface.SetFont("PVBHUDHealth")

	local textSize = surface.GetTextSize(str)

	surface.SetTextColor(textcolor)
	surface.SetTextPos((ScrW()/2) - (textSize/2), ScrH()-60)
	surface.DrawText(str)
end

function SWEP:SetLeapCool(time)
	self:SetDTFloat(8, time)
end

function SWEP:GetLeapCool()
	return self:GetDTFloat(8)
end