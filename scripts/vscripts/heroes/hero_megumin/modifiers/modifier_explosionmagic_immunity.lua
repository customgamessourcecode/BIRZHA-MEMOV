
modifier_ExplosionMagic_immunity = class({})

-----------------------------------------------------------------------------------------

function modifier_ExplosionMagic_immunity:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_ExplosionMagic_immunity:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ExplosionMagic_immunity:CheckState()
return {[MODIFIER_STATE_MAGIC_IMMUNE] = true,}
end

-----------------------------------------------------------------------------------------

function modifier_ExplosionMagic_immunity:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

-----------------------------------------------------------------------------------------

