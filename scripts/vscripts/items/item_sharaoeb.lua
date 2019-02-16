item_aether_lens_baseclass = {}

LinkLuaModifier("modifier_item_sharoeb", "items/item_sharoeb.lua", LUA_MODIFIER_MOTION_NONE)

function item_aether_lens_baseclass:GetIntrinsicModifierName()
	return "modifier_item_sharoeb"
end

item_sharoeb = class(item_aether_lens_baseclass)

modifier_item_sharoeb = class({
	GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
	IsHidden      = function() return true end,
	IsPurgable    = function() return false end,
})

function modifier_item_sharoeb:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_item_sharoeb:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("dmg")
end

function modifier_item_sharoeb:GetModifierCooldown_Percentage()
	return self:GetAbility():GetSpecialValueFor("dmg")
end

function modifier_item_sharoeb:GetModifierConstantHealthBonus()
	return self:GetAbility():GetSpecialValueFor("hp")
end

function modifier_item_sharoeb:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("mp")
end

function modifier_item_sharoeb:GetModifierIntellectBonus()
	return self:GetAbility():GetSpecialValueFor("int")
end

function modifier_item_sharoeb:GetModifierCastRangeBonus()
	return self:GetAbility():GetSpecialValueFor("cast_range_bonus")
end
