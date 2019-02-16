function President( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local caster = keys.caster	
	local target = keys.target
	local duration = ability:GetSpecialValueFor("duration")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_alchemist_4")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 10
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_naval_president", { Duration = duration })
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_naval_president_effect2", { Duration = duration })
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_naval_president_effect", { Duration = duration })
end