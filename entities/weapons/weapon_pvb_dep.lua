AddCSLuaFile()
SWEP.Author						= ""
SWEP.Base						= "weapon_pvb_base"
SWEP.PrintName					= "Desert Phoenix"
SWEP.Instructions				= "lol"

SWEP.ViewModel					= "models/weapons/tfa_cso2/c_dep.mdl"
SWEP.WorldModel					= "models/weapons/tfa_cso2/w_dep.mdl"
SWEP.ViewModelFlip				= true
SWEP.UseHands					= true
SWEP.SetHoldType				= "revolver"

SWEP.Weight						= 8
SWEP.AutoSwitchTo				= true
SWEP.AutoSwitchFrom				= false

SWEP.Slot						= 1
SWEP.SlotPos					= 0

SWEP.DrawAmmo					= false
SWEP.DrawCrosshair				= true

SWEP.Spawnable					= false
SWEP.AdminSpawnable				= true

SWEP.ShouldDropOnDie = false

SWEP.Primary.ClipSize			= 7
SWEP.Primary.DefaultClip		= 48
SWEP.Primary.Ammo				= "357"
SWEP.Primary.Automatic			= false
SWEP.Primary.Recoil				= 2.5
SWEP.Primary.Damage				= 250
SWEP.Primary.NumShots			= 1
SWEP.Primary.Spread				= 0.02
SWEP.Primary.Cone				= 0.02
SWEP.Primary.Delay				= 0.3

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Automatic		= false
SWEP.ImpactDecal 				= "FadingScorch"

local ShootSound = Sound("tfa_cso2_dep.1")

function SWEP:Initialize()
	self:SetHoldType(self.SetHoldType)
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
	
	self.Owner:ViewPunch(Angle(-self.Primary.Recoil,0,0))
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
	timer.Simple(0.01, function()
		if not IsValid(self) then return end
		if not self:VMIV() then return end
		self:CleanParticles()
		ParticleEffectAttach( "ss_dep_fire_f", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 5 )
		ParticleEffectAttach( "ss_dep_fire_f", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 6 )
	end)
	return true
end

function SWEP:ChooseIdleAnim( ... )
	if self:Clip1() <= 1 then return end
	return BaseClass.ChooseIdleAnim(self,...)
end







