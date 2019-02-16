function sputum_debuff(params)
	local hero_base = params.target:FindModifierByName("modifier_sputum")
	local hero_stack = params.target:FindModifierByName("modifier_sputum_stack")

	if params.target:IsHero() and hero_base == nil then
		params.target.goo_particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, params.target)
		ParticleManager:SetParticleControl(params.target.goo_particle_index, 1, Vector(0, 1, 0))
		params.ability:ApplyDataDrivenModifier(params.caster, params.target, "modifier_sputum", nil)
		params.ability:ApplyDataDrivenModifier(params.caster, params.target, "modifier_sputum_stack", nil)
		params.target:FindModifierByName("modifier_sputum_stack"):IncrementStackCount()

	elseif params.target:IsHero() and hero_base ~= nil then
		if hero_stack:GetStackCount() < params.max_stacks then hero_stack:IncrementStackCount() end
		hero_base:SetDuration(params.debuff_duration, true)
		hero_stack:SetDuration(params.debuff_duration, true)
		ParticleManager:SetParticleControl(params.target.goo_particle_index, 1, Vector(0, hero_stack:GetStackCount(), 0))
	end
end

function destroy_particles(params)
	ParticleManager:DestroyParticle(params.target.goo_particle_index, true)
end