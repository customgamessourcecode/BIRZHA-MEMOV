ice_blast_target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
ice_blast_target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
ice_blast_target_flag = DOTA_UNIT_TARGET_FLAG_NONE

function ice_blast_launch( keys )
	local caster = keys.caster	
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local main_ability_name = keys.main_ability_name
	local sub_ability_name = keys.sub_ability_name

	local caster_location = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1)
	local target_point = keys.target_points[1]
	local direction = (target_point - caster_location):Normalized()
	caster.ice_blast_ability = ability
	local radius_min = 500
	local radius_grow = 50
	local radius_max = 600
	local speed = 1500 * 1/30
	local target_sight_radius = 500
	local tracer_modifier = keys.tracer_modifier
	local tracer_distance_traveled = 0
	local path_radius = 275
	local min_time = 2
	local projectile_speed = 999999
	local travel_vision = 500
	local travel_vision_duration = 3
	local area_vision = 650
	local area_vision_duration = 4
	local projectile_particle = keys.projectile_particle

	SwitchAbilities(caster, main_ability_name, sub_ability_name)
	ability.ice_blast_tracer = CreateUnitByName("npc_dummy_unit", caster_location, false, caster, caster, caster:GetTeam())
	pudge = 1
	ability:ApplyDataDrivenModifier(caster, ability.ice_blast_tracer, tracer_modifier, {})
	ability.ice_blast_tracer_traveling = true
	ability.ice_blast_tracer_start = GameRules:GetGameTime()
	ability.ice_blast_tracer_location = caster_location

	Timers:CreateTimer(function()
		if ability.ice_blast_tracer_traveling and 
		(ability.ice_blast_tracer_location.x < GetWorldMaxX() and ability.ice_blast_tracer_location.x > GetWorldMinX()) and
		(ability.ice_blast_tracer_location.y < GetWorldMaxY() and ability.ice_blast_tracer_location.y > GetWorldMinY()) then

			ability.ice_blast_tracer_location = ability.ice_blast_tracer_location + Vector(speed * direction.x, speed * direction.y, 0)
			ability.ice_blast_tracer_location = GetGroundPosition(ability.ice_blast_tracer_location, ability.ice_blast_tracer) + Vector(0,0,128)
			ability.ice_blast_tracer:SetAbsOrigin(ability.ice_blast_tracer_location)
			tracer_distance_traveled = tracer_distance_traveled + speed

			return 1/30

		elseif not ability.ice_blast_tracer_traveling then
			SwitchAbilities(caster, sub_ability_name, main_ability_name )

			if tracer_distance_traveled / projectile_speed > min_time then
				projectile_speed = tracer_distance_traveled / min_time
			end

			ability.ice_blast_radius = radius_min + (GameRules:GetGameTime() - ability.ice_blast_tracer_start) * radius_grow
			if ability.ice_blast_radius > radius_max then
				ability.ice_blast_radius = radius_max
			end

			caster_location = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1)
			local hail_location = caster_location
			local hail_traveled_distance = 0
			local hail_speed = projectile_speed * 1/30 -- This is the distance per frame
			local distance = (ability.ice_blast_tracer_location - caster_location):Length2D()
			local projectile_direction = (ability.ice_blast_tracer_location - caster_location):Normalized()

			ProjectileManager:CreateLinearProjectile( {
				Ability				= ability,
				EffectName			= projectile_particle,
				vSpawnOrigin		= caster_location,
				fDistance			= distance,
				fStartRadius		= path_radius,
				fEndRadius			= path_radius,
				Source				= caster,
				bHasFrontalCone		= true,
				bReplaceExisting	= false,
				iUnitTargetTeam		= ice_blast_target_team,
				iUnitTargetFlags	= ice_blast_target_flag,
				iUnitTargetType		= ice_blast_target_type,
				bDeleteOnHit		= false,
				vVelocity			= Vector(projectile_direction.x * projectile_speed, projectile_direction.y * projectile_speed, 0),
				bProvidesVision		= true,
				iVisionRadius		= travel_vision,
				iVisionTeamNumber	= caster:GetTeamNumber(),
			} )

			Timers:CreateTimer(function()
				if hail_traveled_distance < distance then
					hail_location = hail_location + Vector(projectile_direction.x * hail_speed, projectile_direction.y * hail_speed, 0)
					hail_traveled_distance = hail_traveled_distance + hail_speed

					AddFOWViewer(caster:GetTeamNumber(), hail_location, travel_vision, travel_vision_duration, false)
					return 1/30
				else
					-- End path area vision
					ability.ice_blast_tracer:RemoveSelf()
					AddFOWViewer(caster:GetTeamNumber(), hail_location, area_vision, area_vision_duration, false)
					return nil
				end
			end)

			return nil
		else
			SwitchAbilities(caster, sub_ability_name, main_ability_name )
			ability.ice_blast_tracer_traveling = false
			ability.ice_blast_tracer:RemoveSelf()
			return nil
		end
	end)
end

function ice_blast_release( keys )
	local caster = keys.caster

	caster.ice_blast_ability.ice_blast_tracer_traveling = false
end

function ice_blast_explode( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local modifier = keys.modifier
	local sound = keys.sound
	local explosion_particle = keys.explosion_particle
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	local damage_table = {}
	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = ability:GetAbilityDamage()

	EmitSoundOn(sound, ability.ice_blast_tracer)
	local particle = ParticleManager:CreateParticle(explosion_particle, PATTACH_ABSORIGIN_FOLLOW, ability.ice_blast_tracer)
	ParticleManager:SetParticleControl(particle, 0, ability.ice_blast_tracer_location)
	ParticleManager:SetParticleControl(particle, 3, ability.ice_blast_tracer_location)
	ParticleManager:ReleaseParticleIndex(particle)
	
	local particle2 = ParticleManager:CreateParticle("particles/v1lat/v1lat_aiaiai.vpcf", PATTACH_ABSORIGIN_FOLLOW, ability.ice_blast_tracer)
	ParticleManager:ReleaseParticleIndex(particle)
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_visage_2")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 2
	end
	

	local units_to_damage = FindUnitsInRadius(caster:GetTeam(), ability.ice_blast_tracer_location, nil, ability.ice_blast_radius, ice_blast_target_team, ice_blast_target_type, ice_blast_target_flag, FIND_CLOSEST, false)

	for _,v in pairs(units_to_damage) do
		if v:IsConsideredHero() then
			v:AddNewModifier( v, self, "modifier_stunned", { duration = duration } )
		end

		damage_table.victim = v
		ApplyDamage(damage_table)
	end
end

function SwitchAbilities( caster, main_ability_name, sub_ability_name )
	caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)
end