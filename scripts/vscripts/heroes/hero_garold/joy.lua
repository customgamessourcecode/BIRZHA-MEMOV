function Joy(keys)
	local caster = keys.caster	
	local ability = keys.ability
	local damageTaken = keys.DamageTaken
	local attacker = keys.attacker
	
	if not ability.currentStacks2 then
	    ability.currentStacks2 = 0
	end
	
	if not ability.currentStacks then
	    ability.currentStacks = 0
	end
	
	local damageforstack = ability:GetLevelSpecialValueFor("damageforstack", ability:GetLevel() - 1)
	local maxstacks = ability:GetLevelSpecialValueFor("maxstacks", ability:GetLevel() - 1)
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_dark_seer_4")
	
	if Talent:GetLevel() == 1 then
		damageforstack = 1500
	end
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_dark_seer")
	
	if Talent2:GetLevel() == 1 then
		maxstacks = maxstacks + 8
	end
	
	if attacker:IsRealHero() then
		ability.currentStacks2 = ability.currentStacks2+damageTaken
		caster:SetModifierStackCount("modifier_Garold_StealPain_stack", ability, ability.currentStacks2)
	end
	if ability.currentStacks2 >= damageforstack then
		if ability.currentStacks >= maxstacks == false then
			if caster:HasModifier("modifier_joy_stats") == false then
				ability:ApplyDataDrivenModifier( caster, caster, "modifier_joy_stats", {})
				ability.currentStacks2 = ability.currentStacks2 - damageforstack
				caster:ModifyStrength(ability:GetSpecialValueFor("atribute"))
				caster:ModifyAgility(ability:GetSpecialValueFor("atribute"))
				caster:ModifyIntellect(ability:GetSpecialValueFor("atribute"))
				caster:CalculateStatBonus()
			else
				ability.currentStacks2 = ability.currentStacks2 - damageforstack
				caster:SetModifierStackCount("modifier_joy_stats", ability, ability.currentStacks + 1)
				ability.currentStacks = ability.currentStacks+1
				caster:ModifyStrength(ability:GetSpecialValueFor("atribute"))
				caster:ModifyAgility(ability:GetSpecialValueFor("atribute"))
				caster:ModifyIntellect(ability:GetSpecialValueFor("atribute"))
				caster:CalculateStatBonus()
			end
		end
	end
end

function JoyRefresh(keys)
	local caster = keys.caster	
	local ability = keys.ability
	
	if not ability.currentStacks then
	    ability.currentStacks = 1 
	end
	
	if caster:HasModifier("modifier_joy_stats") == false then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_joy_stats", {})
	else
		caster:SetModifierStackCount("modifier_joy_stats", ability, ability.currentStacks)
	end
end