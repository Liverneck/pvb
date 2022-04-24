AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self.DieTime = self.DieTime or 0
	self.StackedTime = self.StackedTime or 0

	self:OnInitialize()
end

function ENT:SetPlayer(pPlayer, bExists)
	if bExists then
		self:PlayerSet(pPlayer, bExists)
	else
		local bValid = pPlayer and pPlayer:IsValid()
		if bValid then
			self:SetPos(pPlayer:GetPos() + Vector(0,0,16))
		end
		pPlayer[self:GetClass()] = self
		self:SetOwner(pPlayer)
		self:SetParent(pPlayer)
		if bValid then
			self:PlayerSet(pPlayer)
		end
	end
end

function ENT:PlayerSet(pPlayer, bExists)
end

function ENT:Think()
	-- Any kind of active effect.

	if self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:KeyValue(key, value)
	if key == "dietime" then
		self:SetDie(tonumber(value))
		return true
	end
end

function ENT:PhysicsCollide(data, physobj)
end

function ENT:Touch(ent)
end

function ENT:OnRemove()
	self.StackedTime = 0
end

function ENT:SetDie(fTime,bStack)
	if self.StackedTime == 0 then self.StackedTime = fTime end
	
	if fTime == 0 or not fTime then
		self.DieTime = 0
	elseif fTime == -1 then
		self.DieTime = 999999999
	else
		if bStack then
			self.StackedTime = self.StackedTime + fTime
			
			if self.GetDuration and self:GetDuration() then
				self.DieTime = CurTime() + ( self.StackedTime - fTime )
				
				self:SetDuration( self.StackedTime - fTime )
			else
				self.DieTime = CurTime() + ( self.StackedTime - fTime )
			end
		else
			self.DieTime = CurTime() + fTime
			if self.GetDuration and self:GetDuration() then
				self:SetDuration( fTime )
			end
		end
	end
end