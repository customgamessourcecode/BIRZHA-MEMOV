modifier_JohnCena_Grabbed_buff = class({})

--------------------------------------------------------------------------------

function modifier_JohnCena_Grabbed_buff:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_JohnCena_Grabbed_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_JohnCena_Grabbed_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
		
function modifier_JohnCena_Grabbed_buff:OnDestroy()
	local ability2 = self:GetCaster():FindAbilityByName("JohnCena_ThrowTheEnemy")
	ability2:SetLevel(0)
end

--------------------------------------------------------------------------------

function modifier_JohnCena_Grabbed_buff:GetActivityTranslationModifiers( params )
	return "tree"
end

--------------------------------------------------------------------------------

function modifier_JohnCena_Grabbed_buff:GetModifierTurnRate_Percentage( params )
	return -90
end

--------------------------------------------------------------------------------

function modifier_JohnCena_Grabbed_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return -80
end