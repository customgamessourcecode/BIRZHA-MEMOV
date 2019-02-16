function LaughingRush(keys)
    local caster = keys.caster
    local ability = keys.ability
    local point = keys.target_points[1]
    local vDirection = caster:GetForwardVector() - caster:GetOrigin()
    vDirection = vDirection:Normalized()
    local particle = "particles/navat/laughingrush_effect.vpcf"
    local range = 800
    ability.tornado = 
    {
        Ability = ability,
        EffectName = particle,
        vSpawnOrigin = caster:GetOrigin(),
        fDistance = range,
        fStartRadius = 200,
        fEndRadius = 200,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
        vVelocity = vDirection * 1000,
        bVisibleToEnemies = true,
        bProvidesVision = true,
        iVisionRadius = 250,
        iVisionTeamNumber = caster:GetTeamNumber(),
    }
    i = -30
    for var=1,13, 1 do
        ProjectileManager:CreateLinearProjectile(ability.tornado)
        ability.tornado.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), caster:GetForwardVector()) * 1000
        i = i + 30
    end
end

function Damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = 75
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_zeus_2")
	
	if Talent:GetLevel() == 1 then
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
end