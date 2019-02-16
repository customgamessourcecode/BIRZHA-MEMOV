function HardSkeleton(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local casterSTR = caster:GetStrength()
	local str_return = ability:GetLevelSpecialValueFor( "strength_pct" , ability:GetLevel() - 1  ) * 0.01
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_centaur_3")
	
	if Talent:GetLevel() == 1 then
		str_return = str_return + 0.15
	end
	
	local damage = ability:GetLevelSpecialValueFor( "return_damage" , ability:GetLevel() - 1  )
	local damageType = ability:GetAbilityDamageType()
	local return_damage = damage + ( casterSTR * str_return )

	if attacker:GetTeamNumber() ~= caster:GetTeamNumber() then
		ApplyDamage({ victim = attacker, attacker = caster, damage = return_damage, damage_type = damageType })
	end
end