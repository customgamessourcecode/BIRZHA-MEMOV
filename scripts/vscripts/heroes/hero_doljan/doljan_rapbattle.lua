function StealDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local buff = "modifier_steal_damage_buff"
	local debuff = "modifier_steal_damage_debuff"
	local dur = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local stack_value = ability:GetLevelSpecialValueFor("damage_steal", ability:GetLevel() - 1)
	local aghamim_stack_value = stack_value * 3
	
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()
	local distance = (target_location - caster_location):Length2D()
	local break_distance = ability:GetLevelSpecialValueFor("break_distance", (ability:GetLevel() - 1))

	if distance >= break_distance then
		target:RemoveModifierByName("modifier_Doljan_RapBattle_debuff")
		return
	end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_timbersaw_2")
	
	if Talent:GetLevel() == 1 then
		if target:HasModifier( debuff ) and caster:HasModifier( buff ) then
			local current_stack = target:GetModifierStackCount( debuff, ability )
			ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			caster:SetModifierStackCount( buff, ability, current_stack + aghamim_stack_value )
			target:SetModifierStackCount( debuff, ability, current_stack + aghamim_stack_value )
		end
		if target:HasModifier( debuff ) and caster:HasModifier( buff ) == false then
			ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			caster:SetModifierStackCount( buff, ability, aghamim_stack_value )
			target:SetModifierStackCount( debuff, ability, current_stack + aghamim_stack_value )
		end
		if target:HasModifier( debuff ) == false and caster:HasModifier( buff ) then
			ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			caster:SetModifierStackCount( buff, ability, current_stack + aghamim_stack_value )
			target:SetModifierStackCount( debuff, ability, aghamim_stack_value )
		end
		if target:HasModifier( debuff ) == false and caster:HasModifier( buff ) == false then
			ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			caster:SetModifierStackCount( buff, ability, aghamim_stack_value )
			target:SetModifierStackCount( debuff, ability, aghamim_stack_value )
		end
	else
		if target:HasModifier( debuff ) and caster:HasModifier( buff ) then
			local current_stack = target:GetModifierStackCount( debuff, ability )
			ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			caster:SetModifierStackCount( buff, ability, current_stack + stack_value )
			target:SetModifierStackCount( debuff, ability, current_stack + stack_value )
		end
		if target:HasModifier( debuff ) and caster:HasModifier( buff ) == false then
			ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			caster:SetModifierStackCount( buff, ability, stack_value )
			target:SetModifierStackCount( debuff, ability, current_stack + stack_value )
		end
		if target:HasModifier( debuff ) == false and caster:HasModifier( buff ) then
			ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			caster:SetModifierStackCount( buff, ability, current_stack + stack_value )
			target:SetModifierStackCount( debuff, ability, stack_value )
		end
		if target:HasModifier( debuff ) == false and caster:HasModifier( buff ) == false then
			ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			caster:SetModifierStackCount( buff, ability, stack_value )
			target:SetModifierStackCount( debuff, ability, stack_value )
		end
	end
end

function stop_sound( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end

function DealDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage_type = ability:GetAbilityDamageType()
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local multi = ability:GetLevelSpecialValueFor("int_multi", (ability:GetLevel() -1))
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local target_location = target:GetAbsOrigin()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()
	local distance = (target_location - caster_location):Length2D()
	local break_distance = ability:GetLevelSpecialValueFor("break_distance", (ability:GetLevel() - 1))

	if distance >= break_distance then
		target:RemoveModifierByName("modifier_Doljan_RapBattle_debuff")
		return
	end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_timbersaw_3")
	
	if Talent:GetLevel() == 1 then
		multi = multi + 3
	end
	
	ApplyDamage({ victim = target, attacker = caster, damage = caster:GetIntellect() * multi, damage_type = damage_type })
end