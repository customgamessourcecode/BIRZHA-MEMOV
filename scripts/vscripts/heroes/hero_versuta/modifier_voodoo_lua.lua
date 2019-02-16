modifier_voodoo_lua = class({})

function modifier_voodoo_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_SCALE
	}

	return funcs
end

function modifier_voodoo_lua:GetModifierModelChange()
	return "models/items/courier/shibe_dog_cat/shibe_dog_cat.vmdl"
end

function modifier_voodoo_lua:GetModifierMoveSpeedOverride()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_voodoo_lua:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true,
	[MODIFIER_STATE_BLOCK_DISABLED] = true,
	[MODIFIER_STATE_SILENCED] = true
	}

	return state
end

function modifier_voodoo_lua:IsHidden() 
	return false
end