function NewSong(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_tusk_5")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 5
	end
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_face_newsong", {duration = duration })
end

function Damage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		700,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
end