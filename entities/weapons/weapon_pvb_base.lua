
AddCSLuaFile()
SWEP.Base						= "tfa_gun_base"
SWEP.PrintName					= "PVB Weapon Base"
SWEP.Instructions				= ""
SWEP.DrawCrosshair              = true
SWEP.DrawAmmo                   = true -- Should draw the default HL2 ammo counter

















--SHIT AND STUFF--

function SWEP:DrawHUDAmmo() return end
if CLIENT then
    function SWEP:Initialize()
        self.BaseClass.Initialize(self)
        GetConVar("cl_tfa_hud_enabled"):SetBool(false)
    end
end

local function Dryfire(self, self2)

	if self2.GetHasPlayedEmptyClick(self) then return end

	self2.SetHasPlayedEmptyClick(self, true)

	if SERVER and self:GetStatL("Primary.SoundHint_DryFire") then
		sound.EmitHint(SOUND_COMBAT, self:GetPos(), 500, 0.2, self:GetOwner())
	end

	if self:GetOwner():IsNPC() or self:KeyPressed(IN_ATTACK) then
		local enabled, tanim, ttype = self:ChooseDryFireAnim()

		if enabled then
			self:SetNextPrimaryFire(l_CT() + self:GetStatL("Primary.DryFireDelay", self:GetActivityLength(tanim, true, ttype)))
			return
		end
	end

	if IsFirstTimePredicted() then
		self:EmitSound(self:GetStatL("Primary.Sound_DryFire"))
	end
end

function SWEP:CanPrimaryAttack()
	local self2 = self:GetTable()

	local v = hook.Run("TFA_PreCanPrimaryAttack", self)

	if v ~= nil then
		return v
	end

	stat = self:GetStatus()

	if not TFA.Enum.ReadyStatus[stat] and stat ~= TFA.Enum.STATUS_SHOOTING then
		if self:GetStatL("LoopedReload") and TFA.Enum.ReloadStatus[stat] then
			self:SetReloadLoopCancel(true)
		end

		return false
	end

	if self:IsSafety() then
		if IsFirstTimePredicted() then
			self:EmitSound(self:GetStatL("Primary.Sound_DrySafety"))

			if SERVER and self:GetStatL("Primary.SoundHint_DryFire") then
				sound.EmitHint(SOUND_COMBAT, self:GetPos(), 200, 0.2, self:GetOwner())
			end
		end

		if l_CT() < self:GetLastSafetyShoot() + 0.2 then
			self:CycleSafety()
			-- self:SetNextPrimaryFire(l_CT() + 0.1)
		end

		self:SetLastSafetyShoot(l_CT() + 0.2)

		return
	end

	if self:GetSprintProgress() >= 0.1 and not self:GetStatL("AllowSprintAttack", false) then
		return false
	end

	if self:GetStatL("Primary.ClipSize") <= 0 and self:Ammo1() < self:GetStatL("Primary.AmmoConsumption") then
		Dryfire(self, self2)
		return false
	end

	if self:GetPrimaryClipSize(true) > 0 and self:Clip1() < self:GetStatL("Primary.AmmoConsumption") then
		self:Reload()
		return false
	end

	if self2.GetStatL(self, "Primary.FiresUnderwater") == false and self:GetOwner():WaterLevel() >= 3 then
		self:SetNextPrimaryFire(l_CT() + 0.5)
		self:EmitSound(self:GetStatL("Primary.Sound_Blocked"))
		return false
	end

	self2.SetHasPlayedEmptyClick(self, false)

	if l_CT() < self:GetNextPrimaryFire() then return false end

	local v2 = hook.Run("TFA_CanPrimaryAttack", self)

	if v2 ~= nil then
		return v2
	end

	if self:CheckJammed() then
		if IsFirstTimePredicted() then
			self:EmitSound(self:GetStatL("Primary.Sound_Jammed"))
		end

		local typev, tanim = self:ChooseAnimation("shoot1_empty")

		if typev ~= TFA.Enum.ANIMATION_SEQ then
			self:SendViewModelAnim(tanim)
		else
			self:SendViewModelSeq(tanim)
		end

		self:SetNextPrimaryFire(l_CT() + 1)

		return false
	end

	return true
end







