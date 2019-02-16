LinkLuaModifier( "modifier_movespeed_cap_low", "modifiers/modifier_movespeed_cap_low.lua" ,LUA_MODIFIER_MOTION_NONE )

function RenderParticles(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = ability:GetCursorPosition()
	local radius = ability:GetLevelSpecialValueFor("radius1", ability:GetLevel() -1)
	
	EmitSoundOn(keys.sound, caster)
	
	ability.formation_particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(ability.formation_particle, 0, point)
	ParticleManager:SetParticleControl(ability.formation_particle, 1, Vector(radius, radius, 0))
	ParticleManager:SetParticleControl(ability.formation_particle, 2, point)
	
	ability.marker_particle = ParticleManager:CreateParticle(keys.particle2, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(ability.marker_particle, 0, point)
	ParticleManager:SetParticleControl(ability.marker_particle, 1, Vector(radius, radius, 0))
	ParticleManager:SetParticleControl(ability.marker_particle, 2, point)
end

function CheckPosition(keys)
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius1", ability:GetLevel() -1)
	local duration = ability:GetLevelSpecialValueFor("duration_scale", ability:GetLevel() -1)
	
	local distance = (target:GetAbsOrigin() - ability.center):Length2D()
	local distance_from_border = distance - radius
	
	local target_angle = target:GetAnglesAsVector().y
	
	local origin_difference =  ability.center - target:GetAbsOrigin()
	local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
	
	origin_difference_radian = origin_difference_radian * 180
	local angle_from_center = origin_difference_radian / math.pi
	angle_from_center = angle_from_center + 180.0
	
	if distance_from_border < 0 and math.abs(distance_from_border) <= 20 and (math.abs(target_angle - angle_from_center)<90 or math.abs(target_angle - angle_from_center)>270) then
		if target:HasModifier("modifier_movespeed_cap_low") == false then
			target:AddNewModifier(caster, nil, "modifier_movespeed_cap_low", {Duration = duration})
		end
		ability:ApplyDataDrivenModifier(caster, target, "modifier_kinetic_field_debuff",{})
	elseif distance_from_border > 0 and math.abs(distance_from_border) <= 30 and (math.abs(target_angle - angle_from_center)>90) then
		if target:HasModifier("modifier_movespeed_cap_low") == false then
			target:AddNewModifier(caster, nil, "modifier_movespeed_cap_low", {Duration = duration})
		end
		ability:ApplyDataDrivenModifier(caster, target, "modifier_kinetic_field_debuff",{})
	else
		if target:HasModifier("modifier_kinetic_field_debuff") then
			target:RemoveModifierByName("modifier_kinetic_field_debuff")
			target:RemoveModifierByName("modifier_movespeed_cap_low")
		end
	end
end

function RemoveModifiers(keys)
	local target = keys.target

	target:RemoveModifierByName("modifier_kinetic_field_debuff")
	target:RemoveModifierByName("modifier_movespeed_cap_low")
end

function GiveVision(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius1", ability:GetLevel() -1)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability:GetLevel() -1)
	local vision_duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
	ability.center = target:GetAbsOrigin()
	
	AddFOWViewer(caster:GetTeam(), ability.center, vision_radius, vision_duration, false)
	
	ParticleManager:DestroyParticle(ability.formation_particle, true)
	ParticleManager:DestroyParticle(ability.marker_particle, true)
	
	ability.field_particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(ability.field_particle, 0, ability.center)
	ParticleManager:SetParticleControl(ability.field_particle, 1, Vector(radius, radius, 0))
	ParticleManager:SetParticleControl(ability.field_particle, 2, ability.center)
end

function DestroyParticles(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	ParticleManager:DestroyParticle(ability.field_particle, true)
	StopSoundEvent(keys.sound, caster)
end