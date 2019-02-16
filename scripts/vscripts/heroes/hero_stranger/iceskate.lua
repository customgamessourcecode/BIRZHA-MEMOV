function IceSkate (keys)

	local target = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(ability_level)
	
	if target:HasModifier("modifier_Stranger_SnowStorm") == false then
	
		ability:StartCooldown(cooldown)		

		target:Stop()

		ability.forced_direction = target:GetForwardVector()
		ability.forced_distance = ability:GetLevelSpecialValueFor("push_length", ability_level)
		ability.forced_speed = ability:GetLevelSpecialValueFor("push_speed", ability_level) * 1/30
		ability.forced_traveled = 0
	end
end

function ForceHorizontal( keys )

	local target = keys.caster
	local ability = keys.ability
	
	if target:HasModifier("modifier_Stranger_SnowStorm") == false then

		if ability.forced_traveled < ability.forced_distance then
			target:SetAbsOrigin(target:GetAbsOrigin() + ability.forced_direction * ability.forced_speed)
			ability.forced_traveled = ability.forced_traveled + (ability.forced_direction * ability.forced_speed):Length2D()
		else
			target:InterruptMotionControllers(true)
		end
	end
end

function DealDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage_type = ability:GetAbilityDamageType()
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_meepo")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 100
	end
	
	if caster:HasModifier("modifier_Stranger_SnowStorm") == false then
		ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = damage_type })
	end
end