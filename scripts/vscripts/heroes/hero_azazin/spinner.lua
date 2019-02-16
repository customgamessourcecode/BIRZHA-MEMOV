function Damage(event)
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetSpecialValueFor("damage") * ability:GetSpecialValueFor("spinner_damage_tick")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_oracle_2")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 6
	end

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		ability:GetSpecialValueFor("spinner_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	end
end

function BladeFuryStop( event )
	local caster = event.caster
	
	caster:StopSound("azazin")
end

function AzazinModifier (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local Talent = caster:FindAbilityByName("special_bonus_unique_oracle")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 5
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_spinner", { Duration = duration })
end