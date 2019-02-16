modifier_admin = class({})

--------------------------------------------------------------------------------

function modifier_admin:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_admin:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_admin:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_admin:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_admin:AllowIllusionDuplicate()
	return true
end

function modifier_admin:OnCreated()
	if IsServer() then
		local sEffect = "particles/premium/premium_effect.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_admin:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
--------------------------------------------------------------------------------

function modifier_admin:OnDestroy(params)
	if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, true)
		end
	end
	return 0	
end

function modifier_admin:GetTexture()
  return "admin"
end

--------------------------------------------------------------------------------