function Vebasos(params)
	local ability = params.ability
	local vision_cone = 85
	local caster_location = params.caster:GetAbsOrigin()
	local target_location = params.target:GetAbsOrigin()
	local p_damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	
	if params.caster:HasTalent("special_bonus_unique_abaddon_3") then
		p_damage = p_damage + 75
	end
	
	local damage = params.attacker:GetAttackDamage() / 100 * p_damage

	local direction = (caster_location - target_location):Normalized()
	local forward_vector = params.target:GetForwardVector()
	local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)

	if angle <= vision_cone/2 then
		if params.attacker:IsIllusion() then
			return nil
		end
		
		if params.target:IsMagicImmune() then
			return nil
		end
		
		ApplyDamage({victim = params.target, attacker = params.attacker, damage = damage, damage_type = ability:GetAbilityDamageType()})
		params.attacker:EmitSound("edwardebasos")
	end	

	if params.caster:HasTalent("special_bonus_unique_bloodseeker_4") then
		local chance = RandomInt(1, 100)
		if chance <= 8 then
			local damage_crit = ability:GetLevelSpecialValueFor("damage_crit", ability:GetLevel() - 1)
			local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
			if params.caster:HasTalent("special_bonus_unique_abaddon_3") then
				damage_crit = damage_crit + 75
			end
			local damagetalent = params.attacker:GetAttackDamage() / 100 * damage_crit
			params.target:AddNewModifier( params.attacker, ability, "modifier_stunned", {duration = duration})
			ApplyDamage({victim = params.target, attacker = params.attacker, damage = damage, damage_type = ability:GetAbilityDamageType()})
			params.attacker:EmitSound("Hero_EarthSpirit.GeomagneticGrip.Stun")	
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_CUSTOMORIGIN, params.attacker );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, params.target, PATTACH_ABSORIGIN_FOLLOW, nil, params.target:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, params.target, PATTACH_POINT_FOLLOW, "attach_attack2", params.attacker:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, params.attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", params.attacker:GetOrigin(), true );
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			local nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_hand.vpcf", PATTACH_CUSTOMORIGIN, params.attacker );
			ParticleManager:SetParticleControlEnt( nFXIndexB, 1, params.attacker, PATTACH_POINT_FOLLOW, "attach_attack2", params.attacker:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndexB, 2, params.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", params.attacker:GetOrigin(), true );
			ParticleManager:ReleaseParticleIndex( nFXIndexB )
			local knockbackProperties =
			{
				duration = 0.5,
				knockback_duration = 0.5,
				knockback_distance = 300,
				knockback_height = 300
			}
			params.target:AddNewModifier( params.target, nil, "modifier_knockback", knockbackProperties )
		end
	end		
end

function VebasosUse(params)
	local ability = params.ability
	local vision_cone = 85
	local caster_location = params.caster:GetAbsOrigin()
	local target_location = params.target:GetAbsOrigin()
	local damage_crit = ability:GetLevelSpecialValueFor("damage_crit", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	
	if params.caster:HasTalent("special_bonus_unique_abaddon_3") then
		damage_crit = damage_crit + 75
	end
	
	local damage = params.attacker:GetAttackDamage() / 100 * damage_crit
	params.target:AddNewModifier( params.attacker, ability, "modifier_stunned", {duration = duration})
	ApplyDamage({victim = params.target, attacker = params.attacker, damage = damage, damage_type = ability:GetAbilityDamageType()})
	params.attacker:EmitSound("Hero_EarthSpirit.GeomagneticGrip.Stun")	
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_CUSTOMORIGIN, params.attacker );
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, params.target, PATTACH_ABSORIGIN_FOLLOW, nil, params.target:GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, params.target, PATTACH_POINT_FOLLOW, "attach_attack2", params.attacker:GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, params.attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", params.attacker:GetOrigin(), true );
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	local nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_hand.vpcf", PATTACH_CUSTOMORIGIN, params.attacker );
	ParticleManager:SetParticleControlEnt( nFXIndexB, 1, params.attacker, PATTACH_POINT_FOLLOW, "attach_attack2", params.attacker:GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( nFXIndexB, 2, params.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", params.attacker:GetOrigin(), true );
	ParticleManager:ReleaseParticleIndex( nFXIndexB )
end