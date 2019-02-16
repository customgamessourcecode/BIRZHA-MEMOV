function StealDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local buff = "modifier_evrei_zhad_damage_buff"
	local debuff = "modifier_evrei_zhad_damage_debuff"
	local dur = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local stack_value = ability:GetLevelSpecialValueFor("damage_steal", ability:GetLevel() - 1)
	local talent_stack_value = stack_value * 3
	local Talent = caster:FindAbilityByName("special_bonus_unique_ember_spirit_4")
	local current_stack_buff = caster:GetModifierStackCount( buff, ability )
	local current_stack_debuff = target:GetModifierStackCount( debuff, ability )
	if not target:IsAncient() then
		if Talent:GetLevel() == 1 then
			if caster:HasModifier(buff) then
				caster:SetModifierStackCount( buff, ability, current_stack_buff + talent_stack_value )
				ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			else
				ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
				caster:SetModifierStackCount( buff, ability, talent_stack_value )
			end
			
			if target:HasModifier(debuff) then
				target:SetModifierStackCount( debuff, ability, current_stack_debuff + talent_stack_value )
				ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			else
				ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
				target:SetModifierStackCount( debuff, ability, talent_stack_value )
			end
		else
			if caster:HasModifier(buff) then
				caster:SetModifierStackCount( buff, ability, current_stack_buff + stack_value )
				ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
			else
				ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = dur })
				caster:SetModifierStackCount( buff, ability, stack_value )
			end
			
			if target:HasModifier(debuff) then
				target:SetModifierStackCount( debuff, ability, current_stack_debuff + stack_value )
				ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
			else
				ability:ApplyDataDrivenModifier( caster, target, debuff, { Duration = dur })
				target:SetModifierStackCount( debuff, ability, stack_value )
			end
		end
	end
end