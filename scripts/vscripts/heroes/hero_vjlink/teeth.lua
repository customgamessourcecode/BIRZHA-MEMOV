function feast_attack( keys )
    local attacker = keys.attacker
    local target = keys.target
    local ability = keys.ability
	
	if target:IsAncient() == false then
		ability.hp_leech_percent = ability:GetLevelSpecialValueFor("hp_leech_percent", ability:GetLevel() - 1)
		
		local Talent = attacker:FindAbilityByName("special_bonus_unique_lifestealer_2")
		
		if Talent:GetLevel() == 1 then
			ability.hp_leech_percent = ability.hp_leech_percent + 30
		end
		
		local feast_modifier = keys.feast_modifier 

		local damage = target:GetHealth() * (ability.hp_leech_percent / 100)

		ability:ApplyDataDrivenModifier(attacker, attacker, feast_modifier, {})
		attacker:SetModifierStackCount(feast_modifier, ability, damage)
	end
end

function feast_heal( keys )
  local attacker = keys.attacker
  local target = keys.target
  local ability = keys.ability
  
	if target:IsAncient() == false then
		ability.hp_leech_percent = ability:GetLevelSpecialValueFor("hp_leech_percent", ability:GetLevel() - 1)
		
		local Talent = attacker:FindAbilityByName("special_bonus_unique_lifestealer_2")
		
		if Talent:GetLevel() == 1 then
			ability.hp_leech_percent = ability.hp_leech_percent + 30
		end
		
		local damage = target:GetHealth() * (ability.hp_leech_percent / 100)

		attacker:Heal(damage, ability)
	end
end