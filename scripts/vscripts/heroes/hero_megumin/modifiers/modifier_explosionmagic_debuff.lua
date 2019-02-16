
modifier_ExplosionMagic_debuff = class({})

-----------------------------------------------------------------------------------------

function modifier_ExplosionMagic_debuff:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ExplosionMagic_debuff:IsPurgable()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_ExplosionMagic_debuff:CheckState()
return {[MODIFIER_STATE_DISARMED] = true,}
end

-----------------------------------------------------------------------------------------

