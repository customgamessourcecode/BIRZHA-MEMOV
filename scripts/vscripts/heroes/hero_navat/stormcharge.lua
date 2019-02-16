function StormCharge(keys)
	local caster = keys.caster
	local ability = keys.ability

	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end

	if caster:HasModifier("modifier_StormCharge_active") then return end
	
	ability.currentStacks = ability.currentStacks+1
	
	if ability.currentStacks >= 3 then
		ability.currentStacks = 0
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_StormCharge_active", {} )
	end
end