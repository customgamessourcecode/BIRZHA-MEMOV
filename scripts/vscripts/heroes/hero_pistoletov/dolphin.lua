function Leap( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1	

	caster:Stop()
	ProjectileManager:ProjectileDodge(caster)

	ability.leap_direction = caster:GetForwardVector()
	ability.leap_distance = 500
	ability.leap_speed = 1600 * 1/30
	ability.leap_traveled = 0
	ability.leap_z = 0
end

function LeapHorizonal( keys )
	local caster = keys.target
	local ability = keys.ability

	if ability.leap_traveled < ability.leap_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction * ability.leap_speed)
		ability.leap_traveled = ability.leap_traveled + ability.leap_speed
	else
		caster:InterruptMotionControllers(true)
		caster:RemoveModifierByName("Modifier_pistoletov_count_dolphin_active")
	end
end

function LeapVertical( keys )
	local caster = keys.target
	local ability = keys.ability

	if ability.leap_traveled < ability.leap_distance/2 then
		ability.leap_z = ability.leap_z + ability.leap_speed/2
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
	else
		ability.leap_z = ability.leap_z - ability.leap_speed/2
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
	end
end

function Charge( keys )
	if keys.ability:GetLevel() ~= 1 then return end
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "Modifier_pistoletov_count_dolphin"
	local maximum_charges = ability:GetLevelSpecialValueFor( "count", ( ability:GetLevel() - 1 ) )
	local charge_replenish_time = 15
	
	caster:SetModifierStackCount( modifierName, caster, 0 )
	caster.shrapnel_charges = maximum_charges
	caster.start_charge = false
	caster.shrapnel_cooldown = 0.0
	
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( modifierName, caster, maximum_charges )
	
	Timers:CreateTimer( function()
			if caster.start_charge and caster.shrapnel_charges < maximum_charges then
				local next_charge = caster.shrapnel_charges + 1
				caster:RemoveModifierByName( modifierName )
				if next_charge ~= maximum_charges then
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
					shrapnel_start_cooldown( caster, charge_replenish_time )
				else
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
					caster.start_charge = false
				end
				caster:SetModifierStackCount( modifierName, caster, next_charge )
				
				caster.shrapnel_charges = next_charge
			end
			
			if caster.shrapnel_charges ~= maximum_charges then
				caster.start_charge = true
				return charge_replenish_time
			else
				return 0.5
			end
		end
	)
end

function Start( keys )
	if keys.caster.shrapnel_charges > 0 then
		local caster = keys.caster
		local ability = keys.ability
		local modifierName = "Modifier_pistoletov_count_dolphin"
		local maximum_charges = ability:GetLevelSpecialValueFor( "count", ( ability:GetLevel() - 1 ) )
		local charge_replenish_time = 15
		
		local next_charge = caster.shrapnel_charges - 1
		if caster.shrapnel_charges == maximum_charges then
			caster:RemoveModifierByName( modifierName )
			ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
			shrapnel_start_cooldown( caster, charge_replenish_time )
		end
		caster:SetModifierStackCount( modifierName, caster, next_charge )
		caster.shrapnel_charges = next_charge
		
		-- Check if stack is 0, display ability cooldown
		if caster.shrapnel_charges == 0 then
			-- Start Cooldown from caster.shrapnel_cooldown
			ability:StartCooldown( caster.shrapnel_cooldown )
		else
			ability:EndCooldown()
		end
	end
end

function shrapnel_start_cooldown( caster, charge_replenish_time )
	caster.shrapnel_cooldown = charge_replenish_time
	Timers:CreateTimer( function()
			local current_cooldown = caster.shrapnel_cooldown - 0.1
			if current_cooldown > 0.1 then
				caster.shrapnel_cooldown = current_cooldown
				return 0.1
			else
				return nil
			end
		end
	)
end

function damage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor( "damage", ( ability:GetLevel() - 1 ) )
	local duration = ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) )
	local radius = 250
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_ursa")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 1
	end
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_ursa_3")
	
	if Talent2:GetLevel() == 1 then
		radius = 350
	end
	
	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		unit:AddNewModifier( unit, self, "modifier_stunned", { duration = duration } )
	end
end