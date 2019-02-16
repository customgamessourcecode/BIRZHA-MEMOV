function PythonActive( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local charge_speed = ability:GetLevelSpecialValueFor("charge_speed", (ability:GetLevel() - 1)) * 1/30

    ability.modifiername = keys.ModifierName
    ability.modifiername_debuff = keys.ModifierName_Debuff

    ability.target = target
    ability.velocity = charge_speed
    ability.life_break_z = 0
    ability.initial_distance = (GetGroundPosition(target:GetAbsOrigin(), target)-GetGroundPosition(caster:GetAbsOrigin(), caster)):Length2D()
    ability.traveled = 0
end


function DoDamage(caster, target, ability)
    local caster_health = caster:GetHealth()
    local target_health = target:GetHealth()
    local health_damage = ability:GetLevelSpecialValueFor("health_damage", (ability:GetLevel() - 1))
	local Talent = caster:FindAbilityByName("special_bonus_unique_lifestealer_3")
		
	if Talent:GetLevel() == 1 then
		health_damage = health_damage + 0.20
	end

    local dmg_to_target = target_health * health_damage

    local dmg_table_target = {
                                victim = target,
                                attacker = caster,
                                damage = dmg_to_target,
                                damage_type = DAMAGE_TYPE_MAGICAL
                            }
    ApplyDamage(dmg_table_target)
end

function AutoAttack(caster, target)
        order = 
        {
            UnitIndex = caster:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = target:GetEntityIndex(),
            Queue = true
        }

        ExecuteOrderFromTable(order)
end

function OnMotionDone(caster, target, ability)
    local modifiername = ability.modifiername
    local modifiername_debuff = ability.modifiername_debuff

    if caster:FindModifierByName(modifiername) then
        caster:RemoveModifierByName(modifiername)
    end

    EmitSoundOn("Hero_Huskar.Life_Break.Impact", target)

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)


    ability:ApplyDataDrivenModifier(caster, target, modifiername_debuff, {})

    DoDamage(caster, target, ability)

    AutoAttack(caster, target)
end

function JumpHorizonal( keys )
    local caster = keys.target
    local ability = keys.ability
    local target = ability.target

    local target_loc = GetGroundPosition(target:GetAbsOrigin(), target)
    local caster_loc = GetGroundPosition(caster:GetAbsOrigin(), caster)
    local direction = (target_loc - caster_loc):Normalized()

    local max_distance = ability:GetLevelSpecialValueFor("max_distance", ability:GetLevel()-1)


    if (target_loc - caster_loc):Length2D() >= max_distance then
    	caster:InterruptMotionControllers(true)
    end

    if (target_loc - caster_loc):Length2D() > 100 then
        caster:SetAbsOrigin(caster:GetAbsOrigin() + direction * ability.velocity)
        ability.traveled = ability.traveled + ability.velocity
    else
        caster:InterruptMotionControllers(true)

        caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))

		OnMotionDone(caster, target, ability)
    end
end

function JumpVertical( keys )
    local caster = keys.target
    local ability = keys.ability
    local target = ability.target
    local caster_loc = caster:GetAbsOrigin()
    local caster_loc_ground = GetGroundPosition(caster_loc, caster)

    if caster_loc.z < caster_loc_ground.z then
    	caster:SetAbsOrigin(caster_loc_ground)
    end

    if ability.traveled < ability.initial_distance/2 then
        ability.life_break_z = ability.life_break_z + ability.velocity/2
        caster:SetAbsOrigin(caster_loc_ground + Vector(0,0,ability.life_break_z))
    elseif caster_loc.z > caster_loc_ground.z then
        ability.life_break_z = ability.life_break_z - ability.velocity/2
        caster:SetAbsOrigin(caster_loc_ground + Vector(0,0,ability.life_break_z))
    end

end