function MixedIngridients (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local Talent = caster:FindAbilityByName("special_bonus_unique_pangolier_6")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 10
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_gitelman_MixedIngridients_buff", { Duration = duration })
end