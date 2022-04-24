AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	self:SetStartTime(CurTime())

	pPlayer.KnockedDown = self
	--pPlayer:Freeze(true)

	pPlayer:DrawWorldModel(false)
	pPlayer:DrawViewModel(false)

	local lifetime = self.DieTime - CurTime()
	self.DieTime = CurTime() + lifetime * (pPlayer.KnockdownRecoveryMul or 1)
	self:SetDTFloat(1, self.DieTime)

	if not bExists then
		pPlayer:CreateRagdoll()
	end
end

function ENT:OnRemove()
	self.StackedTime = 0
	
	local parent = self:GetParent()
	if parent:IsValid() then
		--parent:Freeze(false)
		parent.KnockedDown = nil

		if parent:Alive() then
			parent:DrawViewModel(true)
			parent:DrawWorldModel(true)

			local rag = parent:GetRagdollEntity()
			if rag and rag:IsValid() then
				rag:Remove()
			end
		end
	end
end
