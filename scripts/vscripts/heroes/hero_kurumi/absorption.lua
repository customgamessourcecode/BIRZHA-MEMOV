function Absorption(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_slark_4")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 250
	end
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_invoker_6")
	
	if Talent2:GetLevel() == 1 then
		caster:Heal(damage, caster)
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
end