function Talent(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_clinkz_1")
	
	if Talent:GetLevel() == 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_JesusAVGN_PunchSpider_talent_chance", {})
		caster:RemoveModifierByName("modifier_JesusAVGN_PunchSpider")
	end
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_clinkz_3")
	
	if Talent2:GetLevel() == 1 then	
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_JesusAVGN_PunchSpider_talent_spider", {})
		caster:RemoveModifierByName("modifier_JesusAVGN_PunchSpider")
	end
end