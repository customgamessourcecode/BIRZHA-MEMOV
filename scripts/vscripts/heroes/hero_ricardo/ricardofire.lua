function ricardofire(event)
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetSpecialValueFor("damage")
	local Talent = caster:FindAbilityByName("special_bonus_unique_enigma")
	
	if Talent:GetLevel() == 1 then
				ability:ApplyDataDrivenModifier( caster, caster, "modifier_Rikardo_Fire_talent", {})
		caster:RemoveModifierByName("modifier_Rikardo_Fire")
		print("talent")
	end
	
	ability_kokos = caster:FindAbilityByName("Ricardo_KokosMaslo")
	if ability_kokos ~= nil then
		ability.damagekokos = ability_kokos:GetSpecialValueFor("bonus_damage")
	end

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_NONE,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		if unit:HasModifier("modifier_Ricardo_KokosMaslo_debuff") then
			local modif = unit:FindModifierByName("modifier_Ricardo_KokosMaslo_debuff")
			local Talentkokos = caster:FindAbilityByName("special_bonus_unique_enigma_2")
			if Talentkokos:GetLevel() == 1 then
				ability.damagekokos = ability.damagekokos + 20
			end
			local fulldamagekokos = modif:GetStackCount() * ability.damagekokos
			ApplyDamage({victim = unit, attacker = caster, damage = fulldamagekokos, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
	end
end