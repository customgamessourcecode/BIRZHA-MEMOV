function CheckTalentSobolevSkill(keys)
	local caster = keys.caster
	local abilityStart = caster:FindAbilityByName("special_bonus_unique_slark_3")
	local abilitylevel = caster:FindAbilityByName("slark_shadow_dance")
	local abilitycd = caster:FindAbilityByName("puck_phase_shift")
	local main_ability_name = "puck_phase_shift"
	local sub_ability_name = "slark_shadow_dance"
	local lvl = abilitycd:GetLevel()
	local cd = abilitycd:GetCooldownTimeRemaining()
	
	if abilityStart:GetLevel() == 1 then
		caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )
		caster:RemoveModifierByName("modifier_check_talent_Sobolev_skill")
		caster:RemoveAbility("puck_phase_shift")
		abilitylevel:SetLevel(lvl)
		abilitylevel:StartCooldown(cd)
	end
end

function CheckTalentSlidanClassic(keys)
	local caster = keys.caster
	local abilityStart = caster:FindAbilityByName("special_bonus_unique_doom_1")
	local abilitylevel = caster:FindAbilityByName("Slidan_ReallyClassic_talent")
	local abilitycd = caster:FindAbilityByName("Slidan_ReallyClassic")
	local main_ability_name = "Slidan_ReallyClassic"
	local sub_ability_name = "Slidan_ReallyClassic_talent"
	local lvl = abilitycd:GetLevel()
	local cd = abilitycd:GetCooldownTimeRemaining()
	
	if abilityStart:GetLevel() == 1 then
		caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )
		caster:RemoveModifierByName("modifier_check_talent_slidan")
		caster:RemoveAbility("Slidan_ReallyClassic")
		abilitylevel:SetLevel(lvl)
		abilitylevel:StartCooldown(cd)
	end
end