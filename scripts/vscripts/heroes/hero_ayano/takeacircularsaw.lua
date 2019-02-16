function TakeACircularSawOn (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local buff = "modifier_ayano_TakeACircularSaw"
	local Talent = caster:FindAbilityByName("special_bonus_unique_legion_commander_3")
	
	if Talent:GetLevel() == 1 then
		buff = "modifier_ayano_TakeACircularSaw_talent"
		caster:RemoveModifierByName("modifier_ayano_TakeACircularSaw")
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, buff, {})
end

function TakeACircularSawOff (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local buff = "modifier_ayano_TakeACircularSaw"
	local Talent = caster:FindAbilityByName("special_bonus_unique_legion_commander_3")
	
	if Talent:GetLevel() == 1 then
		buff = "modifier_ayano_TakeACircularSaw_talent"
	end
	
	caster:RemoveModifierByName(buff)
	caster:RemoveModifierByName("modifier_ayano_TakeACircularSaw")
end