function Eminem(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = ability:GetSpecialValueFor("damage")
	local typedamage = DAMAGE_TYPE_MAGICAL
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_visage_1")
	
	if Talent2:GetLevel() == 1 then
		typedamage = DAMAGE_TYPE_PURE
	end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_visage_3")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 60
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = typedamage, ability = ability})
end