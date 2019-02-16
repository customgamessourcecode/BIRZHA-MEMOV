function Papaz( keys )
	local target = keys.target
	local caster = keys.caster
	local model = keys.model
	local ability = keys.ability
	local ability_level = ability:GetLevel()
	local Talent = caster:FindAbilityByName("special_bonus_unique_night_stalker")
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_night_stalker_2")
	
	if Talent:GetLevel() == 1 then
		ability:ApplyDataDrivenModifier( caster, target, "modifier_papaz_warrior", {})
	end
	
	if Talent2:GetLevel() == 1 then
		ability:ApplyDataDrivenModifier( caster, target, "modifier_papaz_damage", {})
	end
end
