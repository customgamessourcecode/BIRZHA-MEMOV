function Spider(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_legion_commander_2")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 200
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end