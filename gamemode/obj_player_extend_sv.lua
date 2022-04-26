local meta = FindMetaTable("Player")

function meta:CanUseSpecial()
	if self:Team() ~= TEAM_BOSS then return end
	return PVB.BossList[PVB.TRANSMITTER:GetBossInt()]:CanUseSpecial(self)
end

function meta:RemoveAllStatus(bSilent, bInstant)
	if bInstant then
		for _, ent in ipairs( self:GetChildren() ) do
			if ent.IsStatus and not ent.NoRemoveOnDeath then
				ent:Remove()
			end
		end
	else
		for _, ent in ipairs( self:GetChildren() ) do
			if ent.IsStatus and not ent.NoRemoveOnDeath then
				ent.SilentRemove = bSilent
				ent:SetDie()
			end
		end
	end
end

function meta:RemoveAllStatusEx(sType, bSilent, bInstant)
	if bInstant then
		for _, ent in ipairs( self:GetChildren() ) do
			if ent.IsStatus and not ent.NoRemoveOnDeath and ent:GetClass() ~= "status_" .. sType then
				ent:Remove()
			end
		end
	else
		for _, ent in ipairs( self:GetChildren() ) do
			if ent.IsStatus and not ent.NoRemoveOnDeath and ent:GetClass() ~= "status_" .. sType then
				ent.SilentRemove = bSilent
				ent:SetDie()
			end
		end
	end
end

function meta:RemoveStatus(sType, bSilent, bInstant, sExclude)
	local removed
	
	for _, ent in ipairs( self:GetChildren() ) do
		if not (sExclude and ent:GetClass() == "status_" .. sExclude) then
			if ent:GetClass() == "status_" .. sType then
				if bInstant then
					ent:Remove()
				else
					ent.SilentRemove = bSilent
					ent:SetDie()
				end
				removed = true
			end
		end
	end

	return removed
end

function meta:GetStatus(sType)
	local ent = self["status_" .. sType]
	if ent and ent:IsValid() and ent:GetOwner() == self then return ent end
end

function meta:GiveStatus(sType, fDie, bStack)
	local cur = self:GetStatus(sType)
	if cur then
		if fDie then
			cur:SetDie(fDie,bStack)
		end
		cur:SetPlayer(self, true)
		return cur
	else
		local ent = ents.Create("status_" .. sType)
		if ent:IsValid() then
			ent:Spawn()
			if fDie then
				ent:SetDie(fDie,bStack)
			end
			ent:SetPlayer(self)
			return ent
		end
	end
end
