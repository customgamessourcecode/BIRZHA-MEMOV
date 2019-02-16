function GrenadeLauncher(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multi = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local radius = 300
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local target_location = target:GetAbsOrigin()
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)
	for i,unit in ipairs(units) do
		ApplyDamage({ victim = unit, attacker = caster, damage = caster:GetAttackDamage() / 100 * multi, damage_type = DAMAGE_TYPE_MAGICAL })
	end	
end