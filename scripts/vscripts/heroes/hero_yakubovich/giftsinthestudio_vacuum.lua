function Vacuum( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local vacuum_modifier = keys.vacuum_modifier
	local remaining_duration = duration - (GameRules:GetGameTime() - target.vacuum_start_time)
	local target_teams = ability:GetAbilityTargetTeam() 
	local target_types = ability:GetAbilityTargetType() 
	local target_flags = ability:GetAbilityTargetFlags() 

	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

	for _,unit in ipairs(units) do
		local unit_location = unit:GetAbsOrigin()
		local vector_distance = target_location - unit_location
		local distance = (vector_distance):Length2D()
		local direction = (vector_distance):Normalized()

		if unit.vacuum_caster ~= target then
			unit.vacuum_caster = target
			unit.vacuum_caster.pull_speed = distance * 1/duration * 1/30
		end

		ability:ApplyDataDrivenModifier(caster, unit, vacuum_modifier, {duration = remaining_duration})
		unit:SetAbsOrigin(unit_location + direction * unit.vacuum_caster.pull_speed)

	end
end

function VacuumStart( keys )
	local target = keys.target

	target.vacuum_start_time = GameRules:GetGameTime()
end

function VacuumDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local Talent = caster:FindAbilityByName("special_bonus_unique_storm_spirit_2")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 250
	end
	
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end