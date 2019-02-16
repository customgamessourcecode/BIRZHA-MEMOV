function ItsNotNormalEnd( keys )

	local sound_name = "Hero_ObsidianDestroyer.AstralImprisonment"
	local target = keys.target

	StopSoundEvent(sound_name, target)

	target:RemoveNoDraw()	
end

function ItsNotNormalStart( keys )
	local target = keys.target

	target:AddNoDraw()
end

function ItsNotNormal(keys)
	local caster = keys.caster
	local ability = keys.ability

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
	caster:GetAbsOrigin(),
	nil,
	600,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	FIND_ANY_ORDER,
	false)

	for _,unit in pairs(targets) do
		ability:ApplyDataDrivenModifier( caster, unit, "modifier_V1lat_ItsNotNormal", {} )
	end
end