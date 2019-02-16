function WretchedEggAwakeness( keys )
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_vengeful_spirit_3")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 5
	end

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		9999999,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ability:ApplyDataDrivenModifier( caster, unit, "modifier_WretchedEggAwakeness_debuff", { Duration = duration })
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_WretchedEggAwakeness_buff", { Duration = duration })
end