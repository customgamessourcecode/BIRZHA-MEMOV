function Beer( keys )
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local caster = keys.caster
	local Talent = caster:FindAbilityByName("special_bonus_unique_brewmaster_3")
	
	if Talent:GetLevel() == 1 then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_invisible", { Duration = duration })
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_beer_active", { Duration = duration })
end