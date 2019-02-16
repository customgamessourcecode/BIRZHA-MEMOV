function Meteor(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = caster:GetCursorPosition() + 5

	local caster_loc = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1)
	local cast_direction = caster:GetForwardVector()
	local meteor_count = 1
	local distince = 1250
	
	caster:EmitSound("Hero_Invoker.ChaosMeteor.Impact")

	local arrow_projectile = {
		Ability				= ability,
		EffectName			= "particles/booom/megumin/meteor/megumin_meteor.vpcf",
		vSpawnOrigin		= caster:GetAbsOrigin(),
		fDistance			= distince,
		fStartRadius		= 115,
		fEndRadius			= 120,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting = false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit		= true,
		vVelocity			= (target - caster:GetAbsOrigin()):Normalized() * 1000,
		bProvidesVision		= true,
		iVisionRadius		= 200,
		iVisionTeamNumber	= caster:GetTeamNumber(),
	}
	
	ProjectileManager:CreateLinearProjectile(arrow_projectile)
end

function MeteorHit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local stun_time = ability:GetLevelSpecialValueFor("meteor_stun", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local Talent = caster:FindAbilityByName("special_bonus_unique_templar_assassin")

	target:EmitSound("Hero_WarlockGolem.Attack")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 400
	end
	
	local Talent3 = caster:FindAbilityByName("special_bonus_unique_invoker_7")
	
	if Talent3:GetLevel() == 1 then
		stun_time = stun_time + 0.5
	end
	
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_time})
	ability:ApplyDataDrivenModifier( caster, target, "megumin_meteor_fired_debuff", { Duration = 5 } )
end

function MeteorHitDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("think_damage", ability_level)
	
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_invoker_8")
	
	if Talent2:GetLevel() == 1 then
		damage = damage + 200
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end