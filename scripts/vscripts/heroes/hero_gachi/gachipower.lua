function GachiPowerModifier( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_luna_4")
	local Talent = caster:FindAbilityByName("special_bonus_unique_earth_spirit_3")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 10
	end
	
	if Talent2:GetLevel() == 1 then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_GachiPower_talent", { Duration = duration })
	else
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_GachiPower", { Duration = duration })
	end
end