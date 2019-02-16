function MusicWave(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1))
	local jump_delay = 0.25
	local radius = 650
	
	target:AddNewModifier( caster, self, "modifier_silence", { duration = 0.5 } )
	
	target:RemoveModifierByName("modifier_miku_MusicWave")
	
	Timers:CreateTimer(jump_delay,
    function()
		local current
		for i=0,ability.instance do
			if ability.target[i] ~= nil then
				if ability.target[i] == target then
					current = i
				end
			end
		end
	
		if target.hit == nil then
			target.hit = {}
		end
		target.hit[current] = true
	
		ability.jump_count[current] = ability.jump_count[current] + 1
	
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
		local closest = radius
		local new_target
		for i,unit in ipairs(units) do
			local unit_location = unit:GetAbsOrigin()
			local vector_distance = target:GetAbsOrigin() - unit_location
			local distance = (vector_distance):Length2D()
			if distance < closest then
				if unit.hit == nil then
					new_target = unit
					closest = distance
				elseif unit.hit[current] == nil then
					new_target = unit
					closest = distance
				end
			end
		end
		if new_target ~= nil then
			local bolt = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, target)
			ParticleManager:SetParticleControl(bolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
			ParticleManager:SetParticleControl(bolt,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
			ability.target[current] = new_target
			damage = damage
			
			local Talent = caster:FindAbilityByName("special_bonus_unique_enchantress_3")
			
			if Talent:GetLevel() == 1 then
				damage = damage + 100
			end
	
			ApplyDamage({victim = new_target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
			
			ability:ApplyDataDrivenModifier(caster, new_target, "modifier_miku_MusicWave", {})
		else
			ability.target[current] = nil
		end
	end)
end

function NewInstance(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1))
	
	if ability.instance == nil then
		ability.instance = 0
		ability.jump_count = {}
		ability.target = {}
	else
		ability.instance = ability.instance + 1
	end
	
	ability.jump_count[ability.instance] = 0
	ability.target[ability.instance] = target
	
	local bolt = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(bolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
    ParticleManager:SetParticleControl(bolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_enchantress_3")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 100
	end
	
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
end