function DrinkSomePepper (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local Talent = caster:FindAbilityByName("special_bonus_unique_antimage_5")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 3
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_illidan_pepper", { Duration = duration })
end