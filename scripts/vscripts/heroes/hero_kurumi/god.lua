function GodModifier( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local modifier = "modifier_kurumi_god"

	ability:ApplyDataDrivenModifier( caster, caster, modifier, { Duration = duration })
end