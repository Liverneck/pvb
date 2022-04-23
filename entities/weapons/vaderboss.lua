SWEP.Contact 		= ""
SWEP.Author			= ""
SWEP.Instructions	= ""

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFOV 		= 65
SWEP.ViewModel			= "models/weapons/v_datsaber.mdl"
SWEP.WorldModel			= "models/sgg/starwars/weapons/w_vader_saber.mdl"
SWEP.HoldType 			= "melee"
SWEP.ShowWorldModel     = false
SWEP.ShowViewModel     	= false

SWEP.VElements = {
	["longsword"] = { type = "Model", model = "models/sgg/starwars/weapons/w_vader_saber.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.557, 1.557, -6.753), angle = Angle(92.337, -64.287, 127.402), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["longsword"] = { type = "Model", model = "models/sgg/starwars/weapons/w_vader_saber.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, 0), angle = Angle(90, 80, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.BossOnly = true

SWEP.FiresUnderwater = true
SWEP.base					= "weapon_base"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= -1
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Damage 		= 25

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Lightsaber"
SWEP.PrintName			= "Lightsaber - Darth Vader"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	
end

function SWEP:PlayWeaponSound( snd )
	if ( CLIENT ) then return end
	self.Owner:EmitSound( snd )
end

function SWEP:Deploy()
    
    self.Weapon:EmitSound(Sound("weapons/melee/saberon/saber_on-0"..math.random(1,1)..".wav"))
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetWeaponHoldType(self.HoldType)

end
	
function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 75 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )
	
		if ( trace.Hit ) then
			self.Weapon:EmitSound(Sound("weapons/melee/saberhit/saber_hit-0"..math.random(1,4)..".wav"))
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 8
			bullet.Damage = self.Primary.Damage
			self.Owner:FireBullets( bullet )
			self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
				
		else
			self.Weapon:EmitSound(Sound("weapons/melee/saberswing/saber_swing-0"..math.random(1,1)..".wav"))
			self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
			self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			timer.Simple(0, function()
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			end)	
		end
		
	timer.Create( "Idle", self:SequenceDuration(), 1, function() 
	if ( !IsValid( self ) ) then 
		return 
	end 
			self:SendWeaponAnim( ACT_VM_IDLE ) 
	end )

end



function SWEP:SecondaryAttack()

end


