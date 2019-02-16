function TricksMaster(keys)
	local caster = keys.caster	
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	
	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end
	
	local bonus_intellect = 1
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_rubick_3")
	
	if Talent:GetLevel() == 1 then
		bonus_intellect = bonus_intellect + 1
	end
	
	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
			ability:StartCooldown(cooldown)
			ability.currentStacks = ability.currentStacks+bonus_intellect
			caster:ModifyIntellect(bonus_intellect)
			caster:CalculateStatBonus()
			caster:SetModifierStackCount("modifier_ns_TricksMaster_stack", ability, ability.currentStacks)
		end
	end
end 