function BoxingPunchSeries( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_kilchko_boxingPunchSeries_buff"
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local max_stack = ability:GetLevelSpecialValueFor( "max_attacks", ability:GetLevel() - 1 )
	
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, { } )
	caster:SetModifierStackCount( modifierName, ability, max_stack )
end

function boxingPunchSeries_stack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_kilchko_boxingPunchSeries_buff"
	local current_stack = caster:GetModifierStackCount( modifierName, ability )
	
	if current_stack > 1 then
		caster:SetModifierStackCount( modifierName, ability, current_stack - 1 )
	else
		caster:RemoveModifierByName( modifierName )
	end
end

function BoxingPunchSeriesDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_spirit_breaker_2")
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	
	if Talent:GetLevel() == 1 then
		damage = damage + 100
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
end