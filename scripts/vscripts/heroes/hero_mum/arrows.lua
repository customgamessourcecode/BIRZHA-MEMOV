function DeathArrows(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target_points[1]

	-- Parameters
	local caster_loc = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1)
	local cast_direction = (target - caster_loc):Normalized()
	local arrow_particle = "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf"
	local arrow_speed = ability:GetLevelSpecialValueFor("arrow_speed", ability_level)
	local arrow_width = ability:GetLevelSpecialValueFor("arrow_width", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("arrow_vision", ability_level)
	local arrow_amount = ability:GetLevelSpecialValueFor("arrow_amount", ability_level)

	-- Play sound
	caster:EmitSound("Hero_Mirana.ArrowCast")

	-- Arrow projectile setup
	local arrow_projectile = {
		Ability				= ability,
		EffectName			= arrow_particle,
		vSpawnOrigin		= caster_loc,
		fDistance			= 5000,
		fStartRadius		= arrow_width,
		fEndRadius			= arrow_width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
	--	iUnitTargetFlags	= ,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	--	fExpireTime			= ,
		bDeleteOnHit		= true,
		vVelocity			= cast_direction * arrow_speed,
		bProvidesVision		= true,
		iVisionRadius		= vision_radius,
		iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	-- Determine arrow directions
	local arrow_direction
	local first_angle = -6 * (arrow_amount - 1) / 2
	for i = 1, arrow_amount do
		arrow_direction = (RotatePosition(caster_loc, QAngle(0, first_angle + (i-1) * 6, 0), target) - caster_loc):Normalized()
		print(arrow_direction)
		arrow_projectile.vVelocity = Vector(arrow_direction.x, arrow_direction.y, 0) * arrow_speed
		ProjectileManager:CreateLinearProjectile(arrow_projectile)
	end
end

function DeathArrowsHit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local arrow_stun = ability:GetLevelSpecialValueFor("arrow_stun", ability_level)
	local Talent = caster:FindAbilityByName("special_bonus_unique_pudge_3")
		
	if Talent:GetLevel() == 1 then
		arrow_stun = arrow_stun + 1
	end


	target:EmitSound("Hero_Mirana.ArrowImpact")
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = arrow_stun})
end