function Damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = 50
	local Talent = caster:FindAbilityByName("special_bonus_unique_zeus_3")
	
	if Talent:GetLevel() == 1 then
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
end