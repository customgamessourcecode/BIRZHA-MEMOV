function Love( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = 0
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_windranger_2")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 100
	end
	
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end