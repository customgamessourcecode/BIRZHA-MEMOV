function DealDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage_type = ability:GetAbilityDamageType()
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local target_location = target:GetAbsOrigin()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)
	local Talent = caster:FindAbilityByName("special_bonus_unique_techies_4")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 500
	end
	
	for i,unit in ipairs(units) do
		ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = damage_type })
	end
end

function DealDamageTwo(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage_type = ability:GetAbilityDamageType()
	local damage = ability:GetLevelSpecialValueFor("damage2", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local target_location = target:GetAbsOrigin()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)
	local Talent = caster:FindAbilityByName("special_bonus_unique_techies_4")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 500
	end
	
	for i,unit in ipairs(units) do
		ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = damage_type })
	end
end

function DealDamageThree(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage_type = ability:GetAbilityDamageType()
	local damage = ability:GetLevelSpecialValueFor("damage3", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local target_location = target:GetAbsOrigin()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)
	local Talent = caster:FindAbilityByName("special_bonus_unique_techies_4")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 500
	end
	
	for i,unit in ipairs(units) do
		ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = damage_type })
	end
end

function StopCaster(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:Stop()
	caster:Purge(false, true, false, true, false)
	ProjectileManager:ProjectileDodge(caster)
end