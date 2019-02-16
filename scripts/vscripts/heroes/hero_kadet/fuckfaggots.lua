function FuckFaggotsDamage (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local damage_type = DAMAGE_TYPE_MAGICAL
	local Talent = caster:FindAbilityByName("special_bonus_unique_chaos_knight_3")
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_chaos_knight")
	local duration = 1
	
	if target:TriggerSpellAbsorb(ability) then return end

	if Talent:GetLevel() == 1 then
		damage_type = DAMAGE_TYPE_PURE
	end
	
	if Talent2:GetLevel() == 1 then
		duration = 2
	end
	
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = damage_type })
	target:AddNewModifier( caster, self, "modifier_stunned", { duration = duration } )
end