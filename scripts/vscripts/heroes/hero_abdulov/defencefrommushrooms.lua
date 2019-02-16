function DefenceFromMushrooms( keys )
    local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local Talent = caster:FindAbilityByName("special_bonus_unique_axe")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 2
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_rage_ability", { Duration = duration })
    caster:Purge(false, true, false, true, false)
end