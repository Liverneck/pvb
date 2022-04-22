
AddCSLuaFile()
SWEP.Author						= "Ancient Entity & Friends"
SWEP.Base						= "weapon_base"
SWEP.PrintName					= "PVB Weapon Base"
SWEP.Instructions				= [[Default PVB Weapon]]

SWEP.ViewModel				= "models/weapons/cstrike/c_rif_aug.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_aug.mdl"
SWEP.ViewModelFlip				= false
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

SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip		= 90
SWEP.Primary.Ammo				= "357"
SWEP.Primary.Automatic			= true
SWEP.Primary.Recoil				= 0.5
SWEP.Primary.Damage				= 135
SWEP.Primary.NumShots			= 1
SWEP.Primary.Spread				= 0.07
SWEP.Primary.Cone				= 0.07
SWEP.Primary.Delay				= 0.12

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Automatic		= false

local ShootSound = Sound("Weapon_Aug.Single")


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
		Bullet.Tracer	=	0
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


SWEP.Secondary.ScopeLevel = 0
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
	return false
end

function SWEP:VMIV()
	local owent = self:GetOwner()

	if not IsValid(self.OwnerViewModel) then
		if IsValid(owent) and owent.GetViewModel then
			self.OwnerViewModel = owent:GetViewModel()
		end

		return false
	else
		if not IsValid(owent) or not owent.GetViewModel then
			self.OwnerViewModel = nil

			return false
		end

		return self.OwnerViewModel
	end
end

function SWEP:CleanParticles()
	if not IsValid(self) then return end

	if self.StopParticles then
		self:StopParticles()
	end

	if self.StopParticleEmission then
		self:StopParticleEmission()
	end

	if not self:VMIV() then return end
	local vm = self.OwnerViewModel

	if IsValid(vm) then
		if vm.StopParticles then
			vm:StopParticles()
		end

		if vm.StopParticleEmission then
			vm:StopParticleEmission()
		end
	end
end

function SWEP:EjectionSmoke(ovrr)
	local retVal = hook.Run("TFA_EjectionSmoke",self)
	if retVal ~= nil then
		return retVal
	end
	if TFA.GetEJSmokeEnabled() and (self:GetStatL("EjectionSmokeEnabled") or ovrr) then
		local vm = self:IsFirstPerson() and self.OwnerViewModel or self

		if IsValid(vm) then
			local att = vm:LookupAttachment(self:GetStatL("ShellAttachment"))

			if not att or att <= 0 then
				att = 2
			end

			local oldatt = att
			att = self:GetStatL("ShellAttachmentRaw", att)
			local angpos = vm:GetAttachment(att)

			if not angpos then
				att = oldatt
				angpos = vm:GetAttachment(att)
			end

			if angpos then
				fx = EffectData()
				fx:SetEntity(self)
				fx:SetOrigin(angpos.Pos)
				fx:SetAttachment(att)
				fx:SetNormal(angpos.Ang:Forward())
				TFA.Effects.Create("tfa_shelleject_smoke", fx)
			end
		end
	end
end










