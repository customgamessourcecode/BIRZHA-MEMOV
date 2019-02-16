function BindingModifier( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	local Talent = caster:FindAbilityByName("special_bonus_unique_earth_spirit_2")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 2
	end

	ability:ApplyDataDrivenModifier( caster, target, "modifier_gachi_binding", { Duration = duration })
end