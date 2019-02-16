function PocikPenek(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local speed = 6
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local radius = 600
	local dur = 2.0
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, 0, 0, false)
	for i,unit in ipairs(units) do
		local unit_location = unit:GetAbsOrigin()
		local vector_distance = target_location - unit_location
		local distance = (vector_distance):Length2D()
		local direction = (vector_distance):Normalized()
		if distance >= 50 then
			unit:SetAbsOrigin(unit_location + direction * speed)
		else
			unit:SetAbsOrigin(unit_location)
		end
	end
end

function CheckUnitTeam(keys)
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	local caster_team = caster:GetTeamNumber()
	local damage_type = ability:GetAbilityDamageType()
	local heal = target:GetMaxHealth() / 10
	local damage_pct = 10
	local target_health_percentage = target:GetMaxHealth() / 100
	local damage_percentage = target_health_percentage * damage_pct
	local base_damage = 150
	local total_damage = damage_percentage + base_damage
	
	
	if target:GetTeamNumber() ~= caster_team then
		ApplyDamage({ victim = target, attacker = caster, damage = total_damage, damage_type = damage_type })
	else
		target:Heal(heal, caster)
	end
end