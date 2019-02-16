function OvertakingMushroomsPosition( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin() 
	local target_location = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local min_range = ability:GetLevelSpecialValueFor("min_range", ability_level) 
	local max_range = ability:GetLevelSpecialValueFor("max_range", ability_level)
	local distance = (target_location - caster_location):Length2D() 
	local direction = (target_location - caster_location):Normalized()
	local target_point = RandomFloat(min_range, max_range) * distance
	local target_point_vector = caster_location + direction * target_point

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster_location, true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
	ParticleManager:SetParticleControl(particle, 2, target_point_vector)
	ParticleManager:SetParticleControlOrientation(particle, 2, direction, Vector(0,1,0), Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(particle) 

	ability.reality_rift_location = target_point_vector
	ability.reality_rift_direction = direction
end

function OvertakingMushrooms( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local player = caster:GetPlayerOwnerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local bonus_duration = ability:GetLevelSpecialValueFor("bonus_duration", ability_level) 
	local illusion_search_radius = 1375 
	local bonus_modifier = keys.bonus_modifier
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	target:SetAbsOrigin(ability.reality_rift_location - ability.reality_rift_direction * 25)
	caster:SetAbsOrigin(ability.reality_rift_location + ability.reality_rift_direction * 25)

	target:SetForwardVector(ability.reality_rift_direction)
	caster:Stop() 
	caster:SetForwardVector(ability.reality_rift_direction * -1)

	target:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.03})
	caster:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.03})

	local order =
	{
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = target:entindex(),
		Queue = true
	}

	ExecuteOrderFromTable(order)

	local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_HERO
	local target_flags = DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, illusion_search_radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

	for _,unit in ipairs(units) do
		if unit:IsIllusion() and unit:GetPlayerOwnerID() == player then
		
			unit:SetAbsOrigin(ability.reality_rift_location + ability.reality_rift_direction * 25) 
			unit:Stop() 
			unit:SetForwardVector(ability.reality_rift_direction * -1)

			unit:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.03})
			ability:ApplyDataDrivenModifier(caster, unit, bonus_modifier, {duration = bonus_duration})

			local order =
			{
				UnitIndex = unit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = target:entindex(),
				Queue = true
			}

			ExecuteOrderFromTable(order)
		end
	end	
end