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

SWEP.Base					= "melee_boss_base"
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Damage 		= 50
SWEP.MeleeRange             = 75
SWEP.MeleeForce             = 8

SWEP.Category			= "Lightsaber"
SWEP.PrintName			= "Lightsaber"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

AccessorFunc(SWEP, "m_NextTime", "NextReload", FORCE_NUMBER)

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

function SWEP:EmitHitSound()
    self:EmitSound(Sound("weapons/melee/saberhit/saber_hit-0" .. math.random(1,4) .. ".wav"))
end

function SWEP:EmitMissSound()
    self:EmitSound(Sound("weapons/melee/saberswing/saber_swing-0" .. math.random(1,1) .. ".wav"))
end

function SWEP:EmitDeploySound()
    self:EmitSound(Sound("weapons/melee/saberon/saber_on-0" .. math.random(1,1) .. ".wav"))
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
