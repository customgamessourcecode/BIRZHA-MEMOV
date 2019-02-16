function Fart ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local Talent = caster:FindAbilityByName("special_bonus_unique_pudge_2")
		
	if Talent:GetLevel() == 1 then
		damage = damage + 50
	end

	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end