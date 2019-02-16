function Fura(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_lina_1")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 200
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end
