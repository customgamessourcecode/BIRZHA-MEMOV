function Brutality (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local buff = "modifier_illidan_Brutality_bash"
	local Talent = caster:FindAbilityByName("special_bonus_unique_antimage")
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_antimage_2")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 10
	end
	
	if Talent2:GetLevel() == 1 then
		buff = "modifier_illidan_Brutality_bash_talent"
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_illidan_Brutality_buff", { Duration = duration })
	ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = duration })
end