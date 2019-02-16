modifier_vip = class({})

--------------------------------------------------------------------------------

function modifier_vip:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_vip:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_vip:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_vip:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_vip:AllowIllusionDuplicate()
	return true
end

function modifier_vip:OnCreated()
	if IsServer() then
		local sEffect = "particles/vip/vip_effect.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		local VipGold = "particles/vip_gold.vpcf"
		self.particle2 = ParticleManager:CreateParticle(VipGold, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_vip:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
--------------------------------------------------------------------------------

function modifier_vip:OnDestroy(params)
	if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, true)
			ParticleManager:DestroyParticle(self.particle2, true)
		end
	end
	return 0	
end

function modifier_vip:GetTexture()
  return "vip"
end

--------------------------------------------------------------------------------