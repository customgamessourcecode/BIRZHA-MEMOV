function StrikeJump( keys )
	-- Check if spell has already casted
	if keys.caster.ball_lightning_is_running ~= nil and keys.caster.ball_lightning_is_running == true then
		keys.ability:RefundManaCost()
		return
	end

	-- Variables from keys
	local caster = keys.caster
	local casterLoc = caster:GetAbsOrigin()
	local target = keys.target_points[ 1 ] 
	local ability = keys.ability
	-- Variables inheritted from ability
	local speed = ability:GetLevelSpecialValueFor( "rem_move_speed", ability:GetLevel() - 1 )
	local destroy_radius = ability:GetLevelSpecialValueFor( "rem_destroy_radius", ability:GetLevel() - 1 )
	local vision_radius = ability:GetLevelSpecialValueFor( "rem_vision_radius", ability:GetLevel() - 1 )
	
	-- Variables based on modifiers and precaches
	local particle_dummy = "particles/status_fx/status_effect_base.vpcf"
	local loop_sound_name = "Hero_StormSpirit.BallLightning.Loop"
	local modifierName = "modifier_rem_buff"
	local modifierDestroyTreesName = "modifier_ball_lightning_destroy_trees_datadriven"
	
	-- Necessary pre-calculated variable
	local currentPos = casterLoc
	local intervals_per_second = speed / destroy_radius		-- This will calculate how many times in one second unit should move based on destroy tree radius
	local forwardVec = ( target - casterLoc ):Normalized()
	
	-- Set global value for damage mechanism
	caster.ball_lightning_start_pos = casterLoc
	caster.ball_lightning_is_running = true
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	-- Adjust vision
	caster:SetDayTimeVisionRange( vision_radius )
	caster:SetNightTimeVisionRange( vision_radius )
	
	-- Start
	local distance = 0.0
		Timers:CreateTimer( function()
				-- Spending mana
				distance = distance + speed / intervals_per_second
				currentPos = currentPos + forwardVec * ( speed / intervals_per_second )
				-- caster:SetAbsOrigin( currentPos ) -- This doesn't work because unit will not stick to the ground but rather travel in linear
				FindClearSpaceForUnit( caster, currentPos, false )
				print("length = ",( target - currentPos ):Length2D())
                print("speed = ",speed / intervals_per_second)
				-- Check if unit is close to the destination point
				if ( target - currentPos ):Length2D() <= speed / intervals_per_second then
					-- Exit condition
                    
					caster:RemoveModifierByName("modifier_rem_buff")
					caster.ball_lightning_is_running = false
					return nil
				else
                
					return 1 / intervals_per_second
				end
			end
		)
	-- else
	-- 	ability:RefundManaCost()
end

function StrikeJumpHit(keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local echo_slam_damage_range = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() -1))
	local echo_slam_echo_search_range = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() -1))
	local echo_slam_echo_range = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() -1))
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() -1))
    local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() -1))
    local bashpoint = caster:GetAbsOrigin() + caster:GetForwardVector() * 450
	local Talent = caster:FindAbilityByName("special_bonus_unique_vengeful_spirit_6")
	
	if Talent:GetLevel() == 1 then
		stun_duration = stun_duration + 1
	end
			
	-- Renders the echoslam start particle around the caster
	local particle2 = ParticleManager:CreateParticle(keys.particle2, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, Vector(bashpoint.x,bashpoint.y,bashpoint.z))
	ParticleManager:SetParticleControl(particle2, 1, Vector(echo_slam_damage_range,echo_slam_damage_range,bashpoint.z))
	ParticleManager:SetParticleControl(particle2, 2, Vector(bashpoint.x,bashpoint.y,bashpoint.z))
--[[
    local particle3 = ParticleManager:CreateParticle(keys.particle1, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle1, 1, Vector(echo_slam_damage_range,echo_slam_damage_range,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle1, 2, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
			
	-- Renders the echoslam start particle around the caster
	local particle4 = ParticleManager:CreateParticle(keys.particle2, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle2, 1, Vector(echo_slam_damage_range,echo_slam_damage_range,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle2, 2, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	]]
	-- Units to take the initial echo slam damage, and to send echo projectiles from
	local initial_units = FindUnitsInRadius(caster:GetTeamNumber(), bashpoint, nil, echo_slam_damage_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	-- ability:ApplyDataDrivenModifier(caster, initial_units, modifier, {duration = duration})
	

	
	-- Loops through the targets
	for i,initial_unit in ipairs(initial_units) do
		-- Applies the initial damage to the target
		ApplyDamage({victim = initial_unit, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = ability:GetAbilityDamageType()})
		initial_unit:AddNewModifier(caster, ability, "modifier_stunned", {Duration = stun_duration})

	end
	
	
end

function Echorem(keys)
	local caster = keys.caster
	local ability = keys.ability
	local echo_slam_echo_range = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() -1))
    local bashpoint = caster:GetAbsOrigin()
			
	-- Renders the echoslam start particle around the caster
	local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, Vector(bashpoint.x,bashpoint.y,bashpoint.z))
	ParticleManager:SetParticleControl(particle, 1, Vector(echo_slam_damage_range,echo_slam_damage_range,bashpoint.z))
	ParticleManager:SetParticleControl(particle, 2, Vector(bashpoint.x,bashpoint.y,bashpoint.z))
	
	
end

