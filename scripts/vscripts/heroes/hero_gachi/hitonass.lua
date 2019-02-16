function HitOnAss( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = "modifier_gachi_HitOnAss"
	local Talent = caster:FindAbilityByName("special_bonus_unique_death_prophet")
	
	if Talent:GetLevel() == 1 then
		cooldown = cooldown - 2
	end

	ability:StartCooldown(cooldown)

	caster:RemoveModifierByName(modifierName) 

	Timers:CreateTimer(cooldown, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
		end)	
end