function MakeAFeeder( keys )
	local caster = keys.caster
	local ability = keys.ability
	local Talent = caster:FindAbilityByName("special_bonus_unique_terrorblade_2")
	local duration = 6
	
	if Talent:GetLevel() == 1 then
		duration = duration + 6
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_red21_MakeAFeeder", { Duration = duration })
end