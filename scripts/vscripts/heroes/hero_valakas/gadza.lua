function GadzaModifier( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	ability:ApplyDataDrivenModifier( caster, caster, "modifier_valakas_gadza", { Duration = 5 })
end

function GadzaDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local flag = DOTA_UNIT_TARGET_FLAG_NONE
	local damage_type = DAMAGE_TYPE_MAGICAL
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_earthshaker")
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_earthshaker_2")
	local Talent3 = caster:FindAbilityByName("special_bonus_unique_earthshaker_3")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 25
	end
	
	if Talent3:GetLevel() == 1 then
		flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		damage_type = DAMAGE_TYPE_PURE
	end

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		600,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		flag,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = damage_type, ability = ability})
		if Talent2:GetLevel() == 1 then
			unit:AddNewModifier( caster, self, "modifier_stunned", { duration = 0.5 } )
		end
	end
end