modifier_gob = class({})

--------------------------------------------------------------------------------

function modifier_gob:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_gob:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_gob:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_gob:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_gob:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_gob:OnCreated()
	if IsServer() then
		local sEffect = "particles/gob/gob_effect.vpcf"
		self.particle = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_gob:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
--------------------------------------------------------------------------------

function modifier_gob:OnDestroy(params)
	if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, true)
		end
	end
	return 0	
end


function modifier_gob:GetTexture()
  return "gob"
end

--------------------------------------------------------------------------------