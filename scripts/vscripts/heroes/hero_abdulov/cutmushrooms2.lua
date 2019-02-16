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
	local chance = RandomInt(1, 100)

	local kill_threshold = ability:GetLevelSpecialValueFor("kill_threshold", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local chanceuse = ability:GetLevelSpecialValueFor("chance", ability_level)
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_axe_3")
	if Talent:GetLevel() == 1 then
		chanceuse = chanceuse + 7	
	end
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_invoker_2")
	if Talent2:GetLevel() == 1 then
		kill_threshold = kill_threshold + 10	
	end
	
	print("abdul", kill_threshold)
	
	if not caster:IsIllusion() then
		if chance <= chanceuse then					
			caster:EmitSound(sound_fail)
			ApplyDamage({victim = target, attacker = caster, damage = target:GetMaxHealth() / 100 * damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
			caster:EmitSound("Hero_Axe.Culling_Blade_Success")
			ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade.vpcf", PATTACH_ABSORIGIN, target)
			caster:StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_4, 1 )
		end
		
		if target:GetHealth() <= target:GetMaxHealth() / 100 * kill_threshold then
			if target:GetUnitName() == "npc_dota_bristlekek" or target:GetUnitName() == "npc_dota_LolBlade" then
			return 
			end
			target:Purge(true, true, false, false, true)
			caster:EmitSound("Hero_Axe.Culling_Blade_Success")
			ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade.vpcf", PATTACH_ABSORIGIN, target)
			caster:StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_4, 1 )

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
			damage_table.damage = 999999
			ApplyDamage(damage_table)
		end
	end
end