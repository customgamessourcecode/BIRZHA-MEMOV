function StatsRespawn(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end

	ability.currentStacks = ability.currentStacks+ability:GetSpecialValueFor("int")

	caster:ModifyIntellect(ability:GetSpecialValueFor("int"))
	caster:CalculateStatBonus()

	caster:SetModifierStackCount("modifier_Doljan_Intellect", ability, ability.currentStacks)
	
end
