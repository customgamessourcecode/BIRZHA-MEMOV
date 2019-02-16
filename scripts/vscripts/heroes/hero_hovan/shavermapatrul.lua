function ShavermaPatrulDamage( keys )
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local caster = keys.caster
	local Talent = caster:FindAbilityByName("special_bonus_unique_brewmaster_4")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 5
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_hovan_damage", { Duration = duration })
end

function ShavermaPatrulAttackSpeed( keys )
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local caster = keys.caster
	local Talent = caster:FindAbilityByName("special_bonus_unique_brewmaster_4")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 5
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_hovan_speed", { Duration = duration })
end