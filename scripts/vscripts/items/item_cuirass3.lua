function cuirass3( keys )
	local caster = keys.caster
	local particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 2, Vector(caster:GetModelRadius() * 1.1,0,0))
end