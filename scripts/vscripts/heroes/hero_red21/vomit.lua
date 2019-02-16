function Vomit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local modifier = keys.modifier
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local movement_slow = ability:GetLevelSpecialValueFor("movement_slow", ability_level) * -1 

	local slow_per_second = movement_slow / duration
	local slow_rate = 1 / slow_per_second

	if target.venomous_gale_timer then
		Timers:RemoveTimer(target.venomous_gale_timer)
	end

	ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration})
	target:SetModifierStackCount(modifier, caster, movement_slow)

	target.venomous_gale_timer = Timers:CreateTimer(slow_rate, function()
		if IsValidEntity(target) and target:HasModifier(modifier) then
			local current_slow = target:GetModifierStackCount(modifier, caster)
			target:SetModifierStackCount(modifier, caster, current_slow - 1)

			return slow_rate
		else
			return nil
		end
	end)
end

function Damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("strike_damage")
	local Talent = caster:FindAbilityByName("special_bonus_unique_terrorblade")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 100
	end
	
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end