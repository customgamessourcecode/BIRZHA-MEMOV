function FastAttacks( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	if caster.fervor_target then
		if caster.fervor_target == target then
			if caster:HasModifier(modifier) then
				local stack_count = caster:GetModifierStackCount(modifier, ability)

				if stack_count < max_stacks then
					caster:SetModifierStackCount(modifier, ability, stack_count + 1)
				end
			else
				ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
				caster:SetModifierStackCount(modifier, ability, 1)
			end
		else
			caster:RemoveModifierByName(modifier)
			caster.fervor_target = target
		end
	else
		caster.fervor_target = target
	end
end