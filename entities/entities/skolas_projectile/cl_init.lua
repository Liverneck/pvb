include("shared.lua")

local matGlow = Material("sprites/glow04_noz")
local matSplay = Material("particles/smokey")
function ENT:Draw()
	local c = Color(255, 153, 0)
	self:SetColor(c)
	render.SetBlend(0.7)
	self:DrawModel()
	render.SetBlend(1)

	local pos = self:GetPos()
	local add = math.sin((CurTime() + 5) * 3) * 2

	render.SetMaterial(matSplay)
	render.DrawSprite(pos, 12 - add, 18 + add, c)
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 32 , 32, c)

	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.pos = pos
		dlight.r = 255
		dlight.g = 50
		dlight.b = 0
		dlight.brightness = 5
		dlight.Decay = 2048
		dlight.Size = 192
		dlight.Style = 6				
		dlight.DieTime = CurTime() + 1
		dlight.noworld = false
		dlight.nomodel = false
	end
end