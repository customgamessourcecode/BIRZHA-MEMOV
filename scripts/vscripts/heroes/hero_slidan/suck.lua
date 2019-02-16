function suck( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	
	local damage = ability:GetSpecialValueFor("sosat_mp2")

	local Talent = caster:FindAbilityByName("special_bonus_unique_doom_3")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 100
	end

	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	caster:Heal( damage, caster)
end