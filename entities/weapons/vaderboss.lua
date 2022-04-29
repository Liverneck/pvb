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
	if not self:CanReload() then return end
	self:SetNextReload(CurTime() + 1)

	if not SERVER then return end

	local owner = self:GetOwner()

	local dist = 128
	local pos = owner:GetPos() + Vector(dist, dist, 0) * (owner:EyeAngles() + Angle(0, 90, 0)):Right()
	pos.z = pos.z + 32

	if owner:CanUseSpecial() then
		local plyNum = 0
		
		for _, ent in ipairs(ents.FindInSphere(pos, 128)) do
			if ent:IsPlayer() and ent:Alive() and ent ~= owner then
				plyNum = plyNum + 1
				ent:GiveStatus("knockdown", 5)
				timer.Simple(0.1, function()
					if ent:IsValid() then
						ent:SetVelocity(Vector(500, 500, 0) * owner:GetAimVector() + Vector(0, 0, 500))
					end
				end)
			end
		end
		
		if plyNum > 0 then
			owner.DamageTaken = 0

			net.Start("SendBossDamages")
			net.WriteInt(-1, 16)
			net.WriteEntity(owner)
			net.Broadcast()
		end
	end
end

function SWEP:CanReload()
	if self:GetNextReload() <= CurTime() then
		return true
	end

	return false
end

function SWEP:SecondaryAttack()

end

local matWhite = Material("models/debug/debugwhite")
hook.Add("PostDrawOpaqueRenderables", "DrawTheThingy", function()
	local ply = LocalPlayer()
	if ply:Team() ~= TEAM_BOSS or not ply:Alive() or not ply:CanUseSpecial() then return end

	local dist = 128
	local pos = ply:GetPos() + Vector(dist, dist, 0) * (ply:EyeAngles() + Angle(0, 90, 0)):Right()
	pos.z = pos.z + 32

	for _, ent in ipairs(ents.FindInSphere(pos, 128)) do
		if ent:IsPlayer() and ent:Alive() and ent ~= ply then

			render.SetBlend(1)
			render.ModelMaterialOverride(matWhite)
			render.SetColorModulation(1, 1, 0)
			render.SuppressEngineLighting(true)
			cam.IgnoreZ(true)

			ent:DrawModel()

			render.SetBlend(1)
			render.ModelMaterialOverride()
			render.SetColorModulation(1, 1, 1)
			render.SuppressEngineLighting(false)
			cam.IgnoreZ(false)
		end
	end
end)
