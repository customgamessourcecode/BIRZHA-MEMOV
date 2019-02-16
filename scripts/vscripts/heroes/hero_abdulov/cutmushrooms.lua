function CutMushrooms( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_fail = keys.sound_fail
	local sound_success = keys.sound_success
	local particle_kill = keys.particle_kill
	local modifier_sprint = keys.modifier_sprint

	local kill_threshold = ability:GetLevelSpecialValueFor("kill_threshold", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local speed_duration = ability:GetLevelSpecialValueFor("speed_duration", ability_level)
	local speed_aoe = ability:GetLevelSpecialValueFor("speed_aoe", ability_level)
	
	if caster:HasScepter() == true then
		kill_threshold = ability:GetSpecialValueFor("kill_threshold_scepter")
	end

	local exception_table = {}
	table.insert(exception_table, "modifier_dazzle_shallow_grave")

	if target:GetHealth() <= kill_threshold then
		target:Purge(true, true, false, false, true)

		local modifier_count = target:GetModifierCount()
		for i = 0, modifier_count do
			local modifier_name = target:GetModifierNameByIndex(i)
			local modifier_check = false

			for j = 0, #exception_table do
				if exception_table[j] == modifier_name then
					modifier_check = true
					break
				end
			end

			if modifier_check then
				target:RemoveModifierByName(modifier_name)
			end
		end
		
		local Talent = caster:FindAbilityByName("special_bonus_unique_axe_3")
		
		if Talent:GetLevel() == 1 then
			local targets = FindUnitsInRadius(caster:GetTeamNumber(),
				caster:GetAbsOrigin(),
				nil,
				1200,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_ANY_ORDER,
				false)

			for _,unit in pairs(targets) do
				ability:ApplyDataDrivenModifier( unit, unit, "modifier_CutMushrooms_buff", { Duration = 5 })
			end
		end

		local culling_kill_particle = ParticleManager:CreateParticle(particle_kill, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:ReleaseParticleIndex(culling_kill_particle)

		caster:EmitSound(sound_success)
		
		
		local damage_table = {}
		damage_table.victim = target
		damage_table.attacker = caster
		damage_table.ability = ability
		damage_table.damage_type = DAMAGE_TYPE_PURE
		damage_table.damage = kill_threshold
		ApplyDamage(damage_table)

		local units_to_buff = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, speed_aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, ability:GetAbilityTargetType() , 0, FIND_CLOSEST, false)
		for _,v in pairs(units_to_buff) do
			ability:ApplyDataDrivenModifier(caster, v, modifier_sprint, {duration = speed_duration})
		end

		if target:IsRealHero() then
			ability:EndCooldown()
		end			
	else
		caster:EmitSound(sound_fail)
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	end
end