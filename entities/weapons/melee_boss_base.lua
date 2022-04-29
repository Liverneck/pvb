SWEP.Base					= "weapon_base"

SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""
SWEP.BossOnly = true

SWEP.FiresUnderwater = true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 65
SWEP.ViewModel			= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
SWEP.HoldType 			= "melee2"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Damage 		= 50
SWEP.MeleeRange             = 75
SWEP.MeleeForce             = 8
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Base Melee"
SWEP.PrintName			= "Base Melee"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

AccessorFunc(SWEP, "m_NextTime", "NextReload", FORCE_NUMBER)

function SWEP:Initialize()
	self:SetNextReload(0)

	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PlayWeaponSound( snd )
	if ( CLIENT ) then return end
	self:GetOwner():EmitSound( snd )
end

function SWEP:Deploy()
    self:EmitDeploySound()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    self:BasicMeleeTrace()

    timer.Create("Idle", self:SequenceDuration(), 1, function()
    if not IsValid(self) then 
        return
    end
        self:SendWeaponAnim(ACT_VM_IDLE) 
    end)
end

function SWEP:SecondaryAttack()

end

function SWEP:BasicMeleeTrace()
    local owner = self:GetOwner()
	owner:LagCompensation(true)
	local tr = {}
	tr.start = owner:GetShootPos()
	tr.endpos = owner:GetShootPos() + (owner:GetAimVector() * self.MeleeRange)
	tr.filter = owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine(tr)
	owner:LagCompensation(false)
	
	if trace.Hit then
		self:EmitHitSound()
		self:SendWeaponAnim(ACT_VM_HITCENTER)
		bullet = {}
		bullet.Num    = 1
		bullet.Src    = owner:GetShootPos()
		bullet.Dir    = owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = self.MeleeForce
		bullet.Damage = self.Primary.Damage
		owner:FireBullets(bullet)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		owner:SetAnimation(PLAYER_ATTACK1)
	else
		self:EmitMissSound()
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		timer.Simple(0, function()
			if owner:IsValid() then
				owner:SetAnimation(PLAYER_ATTACK1)
			end
		end)	
	end
end

function SWEP:EmitHitSound()
    self:EmitSound(Sound("weapons/melee/saberhit/saber_hit-0" .. math.random(1,4) .. ".wav"))
end

function SWEP:EmitMissSound()
    self:EmitSound(Sound("weapons/melee/saberswing/saber_swing-0" .. math.random(1,1) .. ".wav"))
end

function SWEP:EmitDeploySound()
    self:EmitSound(Sound("weapons/melee/saberon/saber_on-0" .. math.random(1,1) .. ".wav"))
end