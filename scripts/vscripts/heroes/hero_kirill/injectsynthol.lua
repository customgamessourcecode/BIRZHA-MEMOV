function InjectSynthol(keys)
	local caster = keys.caster
	local ability = keys.ability
	local persentage = ability:GetLevelSpecialValueFor("reg", (ability:GetLevel() -1))
	
	local health = caster:GetMaxHealth() / 100 * persentage
	local mana = caster:GetMaxMana() / 100 * persentage
	local Talent = caster:FindAbilityByName("special_bonus_unique_morphling_1")
	
	if Talent:GetLevel() == 1 then 
		if caster:GetMana() < mana then 
			caster:ModifyHealth(caster:GetHealth() - health, ability, false, 0)
		end 
		caster:ReduceMana( mana )
	else
		caster:ModifyHealth(caster:GetHealth() - health, ability, false, 0)
	end
end