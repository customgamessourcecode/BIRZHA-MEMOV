function Punch( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local victim_angle = target:GetAnglesAsVector()
	local victim_forward_vector = target:GetForwardVector()
	local victim_angle_rad = victim_angle.y*math.pi/180
	local victim_position = target:GetAbsOrigin()
	local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)
	
	if target:TriggerSpellAbsorb(ability) then return end

	caster:SetAbsOrigin(attacker_new)
	FindClearSpaceForUnit(caster, attacker_new, true)
	caster:SetForwardVector(victim_forward_vector)

	order = 
	{
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = target:entindex(),
		AbilityIndex = ability,
		Queue = true
	}

	ExecuteOrderFromTable(order)
end

function PunchDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_vengeful_spirit_1")
	
	if Talent:GetLevel() == 1 then
		target:AddNewModifier( caster, self, "modifier_stunned", { duration = 2 } )
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
end