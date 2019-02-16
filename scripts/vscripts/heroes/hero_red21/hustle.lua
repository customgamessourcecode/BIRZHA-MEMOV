function Hustle( keys )
	local caster = keys.caster
	local ability = keys.ability
	local Talent = caster:FindAbilityByName("special_bonus_unique_terrorblade_3")
	local duration = 15
	
	if Talent:GetLevel() == 1 then
		duration = duration + 10
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_red21_HUSTLE", { Duration = duration })
end