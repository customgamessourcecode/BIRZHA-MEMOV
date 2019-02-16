function NamelessWorm(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local buff = "Modifier_Shiro_NamelessWorm_buff"
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_vengeful_spirit_2")
	
	if Talent:GetLevel() == 1 then
		buff = "Modifier_Shiro_NamelessWorm_buff_talent"
	end
	
	ability:ApplyDataDrivenModifier(caster, target, buff, {duration = duration })
end

function NamelessWormHeal(keys)
	local caster = keys.caster
	local target = keys.unit
	local attacker = keys.attacker
	local ability = keys.ability
	local health_bonus_pct = ability:GetLevelSpecialValueFor("health_bonus_pct", (ability:GetLevel() -1))/100
	
	if caster:IsAlive() then
		local target_health = target:GetMaxHealth()
		local heal = target_health * health_bonus_pct
		
		caster:Heal(heal, caster)
	else
		local caster_health = caster:GetMaxHealth()
		local heal = caster_health * health_bonus_pct
		
		attacker:Heal(heal, caster)
	end
end
