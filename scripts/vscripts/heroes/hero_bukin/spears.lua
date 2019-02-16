function DoHealthCost( event )
    local caster = event.caster
    local ability = event.ability
    local health_cost = ability:GetLevelSpecialValueFor( "health_cost" , ability:GetLevel() - 1  )
    local health = caster:GetHealth()
    local new_health = (health - health_cost)

    caster:ModifyHealth(new_health, ability, false, 0)
end

function IncreaseStackCount( event )
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local modifier_name = event.modifier_counter_name
    local dur = ability:GetDuration()

    local modifier = target:FindModifierByName(modifier_name)
    local count = target:GetModifierStackCount(modifier_name, caster)

	if not target:IsMagicImmune() then
		if not modifier then
			ability:ApplyDataDrivenModifier(caster, target, modifier_name, {duration=dur})
			target:SetModifierStackCount(modifier_name, caster, 1) 
		else
			target:SetModifierStackCount(modifier_name, caster, count+1)
			modifier:SetDuration(dur, true)
		end
	end
end

function DecreaseStackCount(event)
    local caster = event.caster
    local target = event.target
    local modifier_name = event.modifier_counter_name
    local modifier = target:FindModifierByName(modifier_name)
    local count = target:GetModifierStackCount(modifier_name, caster)

    if modifier then
	
        if count and count > 1 then
            target:SetModifierStackCount(modifier_name, caster, count-1)
        else
            target:RemoveModifierByName(modifier_name)
        end
    end
end

function Damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_huskar")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 25
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end