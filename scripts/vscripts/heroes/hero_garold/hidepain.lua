function HidePainStack (keys)
	local caster = keys.caster	
	local ability = keys.ability
	
	if not ability.currentStacks then
	    ability.currentStacks = 1
	end
	
	if ability.currentStacks >= 5 then return end
	if caster:IsIllusion() then return end
	
	if caster:HasModifier("modifier_Garold_HidePain_stats") then
		ability.currentStacks = ability.currentStacks+1
		caster:SetModifierStackCount("modifier_Garold_HidePain_stats", ability, ability.currentStacks)
	else
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_Garold_HidePain_stats", {})
		ability.currentStacks = 1
		caster:SetModifierStackCount("modifier_Garold_HidePain_stats", ability, ability.currentStacks)
	end
end

function HidePainStackRemove(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	ability.currentStacks = ability.currentStacks - 1
	caster:SetModifierStackCount("modifier_Garold_HidePain_stats", ability, ability.currentStacks)
	
	if ability.currentStacks <= 0 then
		caster:RemoveModifierByName("modifier_Garold_HidePain_stats")
	end
end

function HidePainDeath(keys)
	local ability = keys.ability
	ability.currentStacks = 0
	keys.caster:RemoveModifierByName("modifier_Garold_HidePain_stats")
end

