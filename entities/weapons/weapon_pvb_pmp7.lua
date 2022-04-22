AddCSLuaFile()
SWEP.Author						= ""
SWEP.Base						= "weapon_pvb_base"
SWEP.PrintName					= "MP7 Phoenix"
SWEP.Instructions				= "lol"

SWEP.ViewModel			= "models/weapons/tfa_cso2/c_mp7_ss_phoenix.mdl"
SWEP.WorldModel			= "models/weapons/tfa_cso2/w_mp7_ss_phoenix.mdl"
SWEP.ViewModelFlip				= true
SWEP.UseHands					= true
SWEP.SetHoldType				= "smg"

SWEP.Weight						= 8
SWEP.AutoSwitchTo				= true
SWEP.AutoSwitchFrom				= false

SWEP.Slot						= 2
SWEP.SlotPos					= 0

SWEP.DrawAmmo					= false
SWEP.DrawCrosshair				= true

SWEP.Spawnable					= false
SWEP.AdminSpawnable				= true

SWEP.ShouldDropOnDie = false

SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip		= 60
SWEP.Primary.Ammo				= "357"
SWEP.Primary.Automatic			= true
SWEP.Primary.Recoil				= 0.5
SWEP.Primary.Damage				= 125
SWEP.Primary.NumShots			= 1
SWEP.Primary.Spread				= 0.02
SWEP.Primary.Cone				= 0.02
SWEP.Primary.Delay				= 0.11

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Automatic		= false
SWEP.ImpactDecal 				= "FadingScorch"
SWEP.EjectionSmokeEnabled 		= true

local ShootSound = Sound("tfa_cso2_mp7phoenix.1")


function SWEP:Initialize()
	
end

function SWEP:PrimaryAttack()
	if(not self:CanPrimaryAttack()) then
		return
	end
	
	local ply = self:GetOwner()
	
	ply:LagCompensation(true)
	
	local Bullet = {}
		Bullet.Num		=	self.Primary.NumShots
		Bullet.Src		=	ply:GetShootPos()
		Bullet.Dir		=	ply:GetAimVector()
		Bullet.Spread	=	Vector(self.Primary.Spread,self.Primary.Spread,0)
		Bullet.Tracer	=	1
		Bullet.TracerName = "tfa_tracer_incendiary"
		Bullet.Damage	=	self.Primary.Damage
		Bullet.AmmoType =	self.Primary.Ammo
	
	self:FireBullets(Bullet)
	self:ShootEffects()
	self:EmitSound( ShootSound )
	//self:BaseClass.ShootEffects()
	
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	
	ply:LagCompensation(false)
end

function SWEP:CanSecondaryAttack()
	return false
end

DEFINE_BASECLASS( SWEP.Base )

function SWEP:Deploy( ... )
	BaseClass.Deploy( self, ... )
	if not self:VMIV() then return true end
	timer.Simple(0, function()
		if IsValid(self) and self:VMIV() then
			self:CleanParticles()
			ParticleEffectAttach( "ss_dep_fire_f", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 3 )
			ParticleEffectAttach( "ss_dep_fire_f", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 4 )
		end
	end)
	return true
end









