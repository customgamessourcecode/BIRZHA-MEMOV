function DaDaYa(keys)
	local caster = keys.caster	
	local ability = keys.ability
	
	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end
	
	local bonus_strength = ability:GetLevelSpecialValueFor("bonus_strength", ability:GetLevel() - 1)
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_mirana_3")
	
	if Talent:GetLevel() == 1 then
		bonus_strength = bonus_strength + 4
	end

	ability.currentStacks = ability.currentStacks+bonus_strength

	caster:ModifyStrength(bonus_strength)
	caster:CalculateStatBonus()

	caster:SetModifierStackCount("modifier_dadaya_stacks", ability, ability.currentStacks)
end 


function DaDaYaRefresh(keys)
	local caster = keys.caster	
	local ability = keys.ability
	
	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end

	caster:SetModifierStackCount("modifier_dadaya_stacks", ability, ability.currentStacks)
end 