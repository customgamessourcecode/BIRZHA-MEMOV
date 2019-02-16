function RageModifier( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local modifier = "modifier_yuno_rage"
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_phantom_assassin_2")
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_phantom_assassin")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 5
	end
	
	if Talent2:GetLevel() == 1 then
		modifier = "modifier_yuno_rage_talent"
	end

	ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = duration })
end