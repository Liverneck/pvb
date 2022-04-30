AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Damage = 40
ENT.Prime = 0
ENT.Delay = 0.3
ENT.HideDelay = 0.0
function ENT:Initialize()
	self:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")
	self:SetColor(Color(255, 153, 0))
	self:PhysicsInitSphere(3)
	self:SetModelScale(0.2, 0)
	self:SetMaterial("models/shadertest/shader2")

	//self:SetNoDraw(true)
		--self:PhysicsInitSphere((self:OBBMaxs() - self:OBBMins()):Length() / 4, "metal")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity( true )
		phys:EnableDrag(false)
	end

	self.killtime = CurTime() + self.Delay
	self:DrawShadow(true)
	self.StartTime = CurTime()
	self.HasIdle = true
	timer.Simple(0.1, function()
		if IsValid(self) then
			self:SetOwner()
		end
	end)
end

function ENT:Think()
	
	self:NextThink(CurTime())

	timer.Simple(7, function() if IsValid(self) then self:Explode() end end)
	if self.PhysicsData then
		self:Explode()
	end
	return true
end

local effectdata, shake

function ENT:Explode()

	if not IsValid(self.Owner) then
		SafeRemoveEntity(self)

		return
	end

	effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetScale(2)
	effectdata:SetMagnitude(2)
	util.Effect("Explosion", effectdata)
	util.BlastDamage(self.Owner, self.Owner, self:GetPos(), 128, 40 )
	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

function ENT:OnRemove()
	if self.HasIdle then
		self.HasIdle = false
	end
end