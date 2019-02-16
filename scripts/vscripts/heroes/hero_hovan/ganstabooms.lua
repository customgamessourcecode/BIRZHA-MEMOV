function GanstaBoomsOne( keys )
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage_first", ability:GetLevel() - 1)
	local caster = keys.caster
	local target = keys.target
	local Talent = caster:FindAbilityByName("special_bonus_unique_shadow_demon_1")
	
	if Talent:GetLevel() == 1 then
		damage = damage +  500
	end
	
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
end

function GanstaBoomsTwo( keys )
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage_second", ability:GetLevel() - 1)
	local caster = keys.caster
	local target = keys.target
	local Talent = caster:FindAbilityByName("special_bonus_unique_shadow_demon_1")
	
	if Talent:GetLevel() == 1 then
		damage = damage +  500
	end
	
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
end