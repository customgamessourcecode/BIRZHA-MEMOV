function ZhopaDamage(keys)
	local ability = keys.ability
	local caster = keys.caster
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability:GetLevel() - 1)
	local base_damage_hero = ability:GetLevelSpecialValueFor("damage_unit", ability:GetLevel() - 1)
	
	ability_kokos = caster:FindAbilityByName("Ricardo_KokosMaslo")
	if ability_kokos ~= nil then
		ability.damagekokos = ability_kokos:GetSpecialValueFor("bonus_damage")
	end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_bane_2")
	
	if Talent:GetLevel() == 1 then
		base_damage_hero = base_damage_hero + 150
	end

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
	caster:GetAbsOrigin(),
	nil,
	800,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO,
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER,
	false)
	
	local damage = #targets * base_damage_hero + base_damage
		
	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})	
		local void_pfx = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_POINT_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(void_pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true)
		ParticleManager:SetParticleControl(void_pfx, 1, Vector(400,0,0))
		ParticleManager:ReleaseParticleIndex(void_pfx)
		EmitGlobalSound( "Hero_ObsidianDestroyer.SanityEclipse.Cast" )
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

