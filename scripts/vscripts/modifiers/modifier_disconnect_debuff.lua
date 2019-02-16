modifier_disconnect_debuff = class({})

function modifier_disconnect_debuff:IsHidden()
return true
end

function modifier_disconnect_debuff:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true,[MODIFIER_STATE_MUTED]= true,[MODIFIER_STATE_SILENCED]= true,[MODIFIER_STATE_NIGHTMARED] = true,[MODIFIER_STATE_NO_HEALTH_BAR] = true,[MODIFIER_STATE_OUT_OF_GAME] = true,[MODIFIER_STATE_MAGIC_IMMUNE] = true,[MODIFIER_STATE_INVULNERABLE] = true, }
end

function modifier_disconnect_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_disconnect_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

