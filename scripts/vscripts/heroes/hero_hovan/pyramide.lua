function PyramideGold( keys )

	local money = 150
	local caster = keys.caster	
	local Talent = caster:FindAbilityByName("special_bonus_unique_brewmaster")
	
	if Talent:GetLevel() == 1 then
		money = money +  100
	end
	
	caster:ModifyGold( money, true, 0 )
end

function PyramideDamage( keys )
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local caster = keys.caster
	local target = keys.target
	
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end