function Damage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local damagecaster = 9999999999
	local attacker = keys.attacker
	local damagecaster2 = caster:GetHealth() / 100 * 90
	local new_health = caster:GetHealth() - damagecaster2
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_venomancer_3")
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_venomancer_2")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 600
	end
	
	if Talent2:GetLevel() == 1 then
		caster:ModifyHealth(new_health, ability, false, 0)
	else
		ApplyDamage({victim = caster, attacker = caster, damage = damagecaster, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	end

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		900,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end	
end