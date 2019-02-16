modifier_sponsor = class({})

--------------------------------------------------------------------------------

function modifier_sponsor:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_sponsor:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sponsor:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_sponsor:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_sponsor:AllowIllusionDuplicate()
	return true
end

function modifier_sponsor:OnCreated()
	if IsServer() then
		local sEffect = "particles/sponsor/sponsor_effect.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		local SponsorEffect = "particles/sponsor/templar_assassin_refraction.vpcf"
		self.particle2 = ParticleManager:CreateParticle(SponsorEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.particle2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle2, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle2, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	end
end

--------------------------------------------------------------------------------

function modifier_sponsor:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
--------------------------------------------------------------------------------

function modifier_sponsor:OnDestroy(params)
	if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, true)
			ParticleManager:DestroyParticle(self.particle2, true)
		end
	end
	return 0	
end

function modifier_sponsor:GetTexture()
  return "sponsor"
end

--------------------------------------------------------------------------------