function VzhuhLaunch( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target_type = ability:GetAbilityTargetType()
	local target_team = ability:GetAbilityTargetTeam()
	local target_flags = ability:GetAbilityTargetFlags()
	local attack_target = caster:GetAttackTarget()
	local radius = ability:GetLevelSpecialValueFor("range", ability_level)
	local max_targets = 10
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local split_shot_projectile = keys.split_shot_projectile
	local cooldown = ability:GetCooldown(ability_level)
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_windranger_3")
	
	if Talent:GetLevel() == 1 then
		cooldown = cooldown - 3
	end

	local split_shot_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, target_team, target_type, target_flags, FIND_CLOSEST, false)
	
	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then

			for _,v in pairs(split_shot_targets) do
					local projectile_info = 
					{
						EffectName = split_shot_projectile,
						Ability = ability,
						vSpawnOrigin = caster_location,
						Target = v,
						Source = caster,
						bHasFrontalCone = false,
						iMoveSpeed = projectile_speed,
						bReplaceExisting = false,
						bProvidesVision = false
					}
					ProjectileManager:CreateTrackingProjectile(projectile_info)
					max_targets = max_targets - 1
					
					ability:StartCooldown(cooldown)
				if max_targets == 0 then break end
			end
		end
	end
end

function VzhuhDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage2 = ability:GetSpecialValueFor("damage_bonus")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_windranger")
	
	if Talent:GetLevel() == 1 then
		damage2 = damage2 + 80
	end

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = DAMAGE_TYPE_PURE
	damage_table.damage = caster:GetAttackDamage()

	ApplyDamage(damage_table)
	ApplyDamage({victim = target, attacker = caster, damage = damage2, damage_type = DAMAGE_TYPE_PURE, ability = ability})
end