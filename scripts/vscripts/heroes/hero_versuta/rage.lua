function rage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_versuta_rage_buff"
	local duration = ability:GetLevelSpecialValueFor( "duration_tooltip", ability:GetLevel() - 1 )
	local max_stack = ability:GetLevelSpecialValueFor( "max_attacks", ability:GetLevel() - 1 )
	local Talent = caster:FindAbilityByName("special_bonus_unique_lycan_4")
	
	if Talent:GetLevel() == 1 then
		max_stack = max_stack + 2
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, { } )
	caster:SetModifierStackCount( modifierName, ability, max_stack )
end

--[[
	Author: kritth
	Date: 7.1.2015.
	Main: Decrease stack upon attack
]]
function rage_stack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_versuta_rage_buff"
	local current_stack = caster:GetModifierStackCount( modifierName, ability )
	
	if current_stack > 1 then
		caster:SetModifierStackCount( modifierName, ability, current_stack - 1 )
	else
		caster:RemoveModifierByName( modifierName )
	end
end