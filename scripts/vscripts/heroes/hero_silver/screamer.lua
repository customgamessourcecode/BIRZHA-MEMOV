function Damage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_ogre_magi")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 100
	end

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		400,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
end