function Pizda( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("bonus_damage", ability_level)
	
	if caster:IsIllusion() then return end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_monkey_king_7")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 0.5
	end
	
	ability:ApplyDataDrivenModifier( caster, target, "modifier_pocik_bash", { Duration = duration })
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
end