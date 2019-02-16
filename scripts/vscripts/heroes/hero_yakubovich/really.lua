function  Really(keys)
	local caster = keys.caster
	local target = keys.attacker
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
end
