AddCSLuaFile()
SWEP.Author						= ""
SWEP.Base						= "weapon_pvb_base"
SWEP.PrintName					= "AWM Gauss"
SWEP.Instructions				= "lol"

SWEP.ViewModel			= "models/weapons/tfa_cso2/c_awp_ss.mdl"
SWEP.WorldModel			= "models/weapons/tfa_cso2/w_awp_ss.mdl"
SWEP.ViewModelFlip				= true
SWEP.UseHands					= true
SWEP.SetHoldType				= "ar2"

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

SWEP.Primary.ClipSize			= 5
SWEP.Primary.DefaultClip		= 5
SWEP.Primary.Ammo				= "357"
SWEP.Primary.Automatic			= false
SWEP.Primary.Recoil				= 12
SWEP.Primary.Damage				= 1200
SWEP.Primary.NumShots			= 1
SWEP.Primary.Spread				= 0.00001
SWEP.Primary.Cone				= 0.00001
SWEP.Primary.Delay				= 1.4

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Automatic		= false

SWEP.Secondary.ScopeLevel = 0

SWEP.MuzzleFlashEffect 			= "tfa_muzzle_awp_ss"
SWEP.EjectionSmokeEnabled 		= true
SWEP.ImpactDecal 				= "Scorch"
SWEP.ImpactEffect 				= nil

local ShootSound = Sound("tfa_cso2_awmgauss.1")

DEFINE_BASECLASS( SWEP.Base )

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
		Bullet.TracerName = "tfa_tracer_awp_ss"
		Bullet.ImpactDecal = "Scorch"
		Bullet.ImpactEffect = nil
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


function SWEP:SecondaryAttack()
	if(self.Secondary.ScopeLevel == 0) then
 
		if(SERVER) then
			self.Owner:SetFOV( 25, 0 )
		end	
 
		self.Secondary.ScopeLevel = 1
 
	else if(self.Secondary.ScopeLevel == 1) then
 
		if(SERVER) then
			self.Owner:SetFOV( 0, 0 )
		end	
 
		self.Secondary.ScopeLevel = 0

	end
	end
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:Think2( ... )
	local t = self.ViewModelBoneMods["ValveBiped.Bip01_R_Hand"]
	if self:GetLastActivity() == ACT_VM_RELOAD and self.OwnerViewModel:GetCycle() < 0.9 then
		if not t.angle_b then
			t.angle_b = t.angle
		end
		t.angle = LerpAngle( FrameTime() * 10,t.angle,angle_zero)
	else
		if t.angle_b then
			t.angle = LerpAngle( FrameTime() * 10,t.angle,t.angle_b)
		end
	end
	return BaseClass.Think2( self, ... )
end





