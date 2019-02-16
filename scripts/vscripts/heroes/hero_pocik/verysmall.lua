function VerySmall(event)
	local caster = event.caster
	local target = event.target
	local ability  = event.ability
	local AbilityDamageType = ability:GetAbilityDamageType()
	local gold_to_damage_ratio = ability:GetLevelSpecialValueFor("gold_to_damage_ratio", ability:GetLevel() - 1 )
	
	if target:TriggerSpellAbsorb(ability) then return end

	local Talent = caster:FindAbilityByName("special_bonus_unique_monkey_king_6")
	
	if Talent:GetLevel() == 1 then
		gold_to_damage_ratio = gold_to_damage_ratio + 20
	end
	
	local gold_damage = math.floor(target:GetGold() * gold_to_damage_ratio * 0.01)

	ApplyDamage({ victim = target, attacker = caster, damage = gold_damage, damage_type = AbilityDamageType, ability = ability}) 
	event.target:EmitSound("pocikxyli")
	event.target:EmitSound("DOTA_Item.Hand_Of_Midas")

    PopupNumbers(event.target, "damage", Vector(255, 0, 0), 2.0, gold_damage, PATTACH_OVERHEAD_FOLLOW, nil, POPUP_SYMBOL_POST_LIGHTNING)
end