function CreepyAppearanceDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_centaur_4")
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	
	if Talent:GetLevel() == 1 then
		damage = damage + 50
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end