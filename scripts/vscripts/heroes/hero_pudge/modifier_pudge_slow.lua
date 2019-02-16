modifier_pudge_slow = class({})

function modifier_pudge_slow:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_pudge_slow:IsHidden()
	return true
end

function modifier_pudge_slow:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end



function modifier_pudge_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return -15 * self:GetStackCount()
end