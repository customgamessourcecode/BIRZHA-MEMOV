function Become (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local Talent = caster:FindAbilityByName("special_bonus_unique_pugna_2")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 10
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_klichko_BecomeMayor", { Duration = duration })
end