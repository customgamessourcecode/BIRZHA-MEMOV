function ThrowDaggers(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1)
	local vDirection = caster:GetCursorPosition() - caster:GetOrigin()
	vDirection = vDirection:Normalized()
	local particle = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"
	local info = 
    {
        Ability = ability,
        EffectName = particle,
        vSpawnOrigin = caster:GetOrigin(),
        fDistance = range,
        fStartRadius = 400,
        fEndRadius = 400,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vVelocity = vDirection * 1200 + RandomInt(-175, 175),
        bVisibleToEnemies = true,
    }
	ProjectileManager:CreateLinearProjectile(info)
end

function DealDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	caster:PerformAttack(target, true, true, true, true, false, false, true)
end