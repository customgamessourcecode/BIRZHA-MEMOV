function SharpnessAxe(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_phantom_assassin_3")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 100
	end

	if caster:IsIllusion() == false then
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	end
end