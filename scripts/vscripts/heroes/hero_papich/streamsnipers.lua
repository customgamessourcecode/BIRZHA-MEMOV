function StreamSnipers( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local buff_modifier = "modifier_streamsnipers_buff"


	if ability.stacks == nil then
		ability.stacks = 0
	end
	
	local previous_stacks
	if caster:HasModifier(buff_modifier) then
		previous_stacks = caster:GetModifierStackCount(buff_modifier, ability)
	else
		previous_stacks = 0
	end
	
	if target:IsAlive() then
		if caster:HasModifier(buff_modifier) == false then
			ability:ApplyDataDrivenModifier(caster, caster, buff_modifier, {})
		end
		
		caster:SetModifierStackCount(buff_modifier, ability, 1 + previous_stacks - ability.stacks)
		ability.stacks = new_stacks
	else
		caster:SetModifierStackCount(buff_modifier, ability, previous_stacks - ability.stacks)
		ability.stacks = 0
		
		if caster:GetModifierStackCount(buff_modifier, ability) == 0 then
			caster:RemoveModifierByName(buff_modifier)
		end
	end
end

function StreamSnipersRemove( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local buff_modifier = "modifier_streamsnipers_buff"


	if ability.stacks == nil then
		ability.stacks = 0
	end
	
	local previous_stacks
	if caster:HasModifier(buff_modifier) then
		previous_stacks = caster:GetModifierStackCount(buff_modifier, ability)
	else
		previous_stacks = 0
	end
	
	if caster:HasModifier(buff_modifier) then
			caster:SetModifierStackCount(buff_modifier, ability, previous_stacks - 1)
			ability.stacks = 0
			if caster:GetModifierStackCount(buff_modifier, ability) == 0 then
				caster:RemoveModifierByName(buff_modifier)
			end
	else
		caster:SetModifierStackCount(buff_modifier, ability, previous_stacks - 1)
		ability.stacks = new_stacks
	end
end