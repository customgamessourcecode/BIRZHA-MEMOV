function SnowStorm_order_explosion( keys )
	Timers:CreateTimer( 0.1, function()
		keys.ability:ApplyDataDrivenModifier( keys.caster, keys.caster, "modifier_Stranger_SnowStorm_northwest_thinker", {} )
		return nil
		end )
		
	Timers:CreateTimer( 0.2, function()
		keys.ability:ApplyDataDrivenModifier( keys.caster, keys.caster, "modifier_Stranger_SnowStorm_northeast_thinker", {} )
		return nil
		end )
	
	Timers:CreateTimer( 0.3, function()
		keys.ability:ApplyDataDrivenModifier( keys.caster, keys.caster, "modifier_Stranger_SnowStorm_southeast_thinker", {} )
		return nil
		end )
	
	Timers:CreateTimer( 0.4, function()
		keys.ability:ApplyDataDrivenModifier( keys.caster, keys.caster, "modifier_Stranger_SnowStorm_southwest_thinker", {} )
		return nil
		end )
end

function SnowStorm_explode( keys )
	local ability = keys.ability
	local caster = keys.caster
	local casterLocation = keys.caster:GetAbsOrigin()
	local abilityDamage = ability:GetLevelSpecialValueFor( "damage", ( ability:GetLevel() - 1 ) )
	local minDistance = ability:GetLevelSpecialValueFor( "explosion_min_dist", ( ability:GetLevel() - 1 ) )
	local maxDistance = ability:GetLevelSpecialValueFor( "explosion_max_dist", ( ability:GetLevel() - 1 ) )
	local radius = ability:GetLevelSpecialValueFor( "explosion_radius", ( ability:GetLevel() - 1 ) )
	local directionConstraint = keys.section
	local modifierName = "modifier_Stranger_SnowStorm_debuff"
	local refModifierName = "modifier_fStranger_SnowStorm_ref_point"
	local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf"
	local soundEventName = "hero_Crystal.freezingField.explosion"
	local targetTeam = ability:GetAbilityTargetTeam() 
	local targetType = ability:GetAbilityTargetType() 
	local targetFlag = ability:GetAbilityTargetFlags()
	local damageType = ability:GetAbilityDamageType()
	
	local castDistance = RandomInt( minDistance, maxDistance )
	local angle = RandomInt( 0, 90 )
	local dy = castDistance * math.sin( angle )
	local dx = castDistance * math.cos( angle )
	local attackPoint = Vector( 0, 0, 0 )
	
	if directionConstraint == 0 then			-- NW
		attackPoint = Vector( casterLocation.x - dx, casterLocation.y + dy, casterLocation.z )
	elseif directionConstraint == 1 then		-- NE
		attackPoint = Vector( casterLocation.x + dx, casterLocation.y + dy, casterLocation.z )
	elseif directionConstraint == 2 then		-- SE
		attackPoint = Vector( casterLocation.x + dx, casterLocation.y - dy, casterLocation.z )
	else										-- SW
		attackPoint = Vector( casterLocation.x - dx, casterLocation.y - dy, casterLocation.z )
	end
	
	local units = FindUnitsInRadius( caster:GetTeamNumber(), attackPoint, caster, radius,
			targetTeam, targetType, targetFlag, 0, false )
	for k, v in pairs( units ) do
		local damageTable =
		{
			victim = v,
			attacker = caster,
			damage = abilityDamage,
			damage_type = damageType
		}
		ApplyDamage( damageTable )
	end
	
	local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( fxIndex, 0, attackPoint )
	
	local dummy = CreateUnitByName( "npc_dummy_unit", attackPoint, false, caster, caster, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, dummy, refModifierName, {} )
	StartSoundEvent( soundEventName, dummy )
	Timers:CreateTimer( 0.1, function()
		dummy:ForceKill( true )
		return nil
	end )
end

function Talent( keys )

	local Talent = keys.caster:FindAbilityByName("special_bonus_unique_meepo_2")
	
	if Talent:GetLevel() == 1 then
		keys.ability:ApplyDataDrivenModifier( keys.caster, keys.target, "modifier_Stranger_SnowStorm_skeletons", { duration = 2 } )
	end
end