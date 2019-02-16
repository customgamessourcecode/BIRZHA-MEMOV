function RoseStrike( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local helix_modifier = keys.helix_modifier
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_spectre_2")
	
	if Talent:GetLevel() == 1 then
		cooldown = cooldown - 1
	end
	
	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
			if target == caster and not caster:HasModifier(helix_modifier) then
				ability:ApplyDataDrivenModifier(caster, caster, helix_modifier, {})
				ability:StartCooldown(cooldown)
			end
			if target == target and not caster:HasModifier(helix_modifier) then
				ability:ApplyDataDrivenModifier(caster, caster, helix_modifier, {})
				ability:StartCooldown(cooldown)
			end
		end
	end
end

function DealDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage_type = ability:GetAbilityDamageType()
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local radius = 300
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local target_location = target:GetAbsOrigin()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)
	
	for i,unit in ipairs(units) do
		ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = damage_type })
	end
end