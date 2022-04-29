local meta = FindMetaTable("Player")

function meta:CanUseSpecial()
	if self:Team() ~= TEAM_BOSS then return end
	return PVB.BossList[PVB.TRANSMITTER:GetBossInt()]:CanUseSpecial(self)
end
