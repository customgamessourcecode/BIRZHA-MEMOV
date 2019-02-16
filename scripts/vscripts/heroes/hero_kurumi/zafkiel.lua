function ZafkielModifier( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local modifier = "modifier_kurumi_zafkiel_aura"
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_queen_of_pain_2")
	
	if Talent:GetLevel() == 1 then
		modifier = "modifier_kurumi_zafkiel_aura_talent"
	end
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_queen_of_pain")
	
	if Talent2:GetLevel() == 1 then
		duration = duration + 1
	end

	ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = duration })
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_kurumi_zafkiel_caster", { Duration = duration })
end