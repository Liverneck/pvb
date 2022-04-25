SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 65
SWEP.ViewModel			= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel			= "models/sgg/starwars/weapons/w_vader_saber.mdl"
SWEP.HoldType 			= "melee2"
SWEP.ShowWorldModel     = false
SWEP.ShowViewModel     	= false

if SERVER then
	resource.AddFile("models/sgg/starwars/weapons/w_vader_saber.mdl")
end

SWEP.VElements = {
	["longsword"] = { type = "Model", model = "models/sgg/starwars/weapons/w_vader_saber.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.557, 1.557, -6.753), angle = Angle(92.337, -64.287, 127.402), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["longsword"] = { type = "Model", model = "models/sgg/starwars/weapons/w_vader_saber.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, 0), angle = Angle(90, 80, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.BossOnly = true

SWEP.FiresUnderwater = true
SWEP.Base					= "weapon_base"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Damage 		= 50

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Lightsaber"
SWEP.PrintName			= "Lightsaber"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	
end

function SWEP:PlayWeaponSound( snd )
	if ( CLIENT ) then return end
	self:GetOwner():EmitSound( snd )
end

function SWEP:Deploy()
	self:EmitSound(Sound("weapons/melee/saberon/saber_on-0" .. math.random(1,1) .. ".wav"))
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)
end
	
function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	owner:LagCompensation(true)
	local tr = {}
	tr.start = owner:GetShootPos()
	tr.endpos = owner:GetShootPos() + (owner:GetAimVector() * 75)
	tr.filter = owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine(tr)
	owner:LagCompensation(false)
	
	if trace.Hit then
		self:EmitSound(Sound("weapons/melee/saberhit/saber_hit-0" .. math.random(1,4) .. ".wav"))
		self:SendWeaponAnim(ACT_VM_HITCENTER)
		bullet = {}
		bullet.Num    = 1
		bullet.Src    = owner:GetShootPos()
		bullet.Dir    = owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 8
		bullet.Damage = self.Primary.Damage
		owner:FireBullets(bullet)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		owner:SetAnimation(PLAYER_ATTACK1)
	else
		self:EmitSound(Sound("weapons/melee/saberswing/saber_swing-0" .. math.random(1,1) .. ".wav"))
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		timer.Simple(0, function()
			if owner:IsValid() then
				owner:SetAnimation(PLAYER_ATTACK1)
			end
		end)	
	end
		
	timer.Create("Idle", self:SequenceDuration(), 1, function()
	if not IsValid(self) then 
		return
	end
		self:SendWeaponAnim(ACT_VM_IDLE) 
	end)
end

function SWEP:Reload()

end

function SWEP:SecondaryAttack()

end
