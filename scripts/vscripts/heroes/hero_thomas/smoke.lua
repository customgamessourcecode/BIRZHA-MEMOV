function Smoke( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_gyrocopter_1")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 30
	end

	local damage_table = {}
	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = damage

	ApplyDamage(damage_table)
end