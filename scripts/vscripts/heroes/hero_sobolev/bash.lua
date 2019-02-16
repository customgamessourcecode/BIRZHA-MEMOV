function bash(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end
	
	ability.currentStacks = ability.currentStacks+1
	
	if ability.currentStacks >= 5 then
		ability.currentStacks = 0
		ability:ApplyDataDrivenModifier( caster, target, "modifier_sobolev_Bash", { duration = 0.5} )
	end
end