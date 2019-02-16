function MusicBarrier( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target_point = keys.target_points[1]

	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))

	local dummy_modifier = keys.dummy_aura
	local dummy = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeam())
	dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, dummy, dummy_modifier, {duration = duration})
	Timers:CreateTimer(duration, function() dummy:RemoveSelf() end)
end

function MusicBarrierAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local aura_modifier = keys.aura_modifier
	local ignore_void = ability:GetLevelSpecialValueFor("ignore_void", ability_level)
	local duration = 0.1

	ability:ApplyDataDrivenModifier(caster, target, aura_modifier, {duration = duration}) 
end