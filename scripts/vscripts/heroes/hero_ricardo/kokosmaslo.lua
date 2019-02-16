function KokosMaslo( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/ricardo/ricardo_maslo_kokosa.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, point )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150, 150, 150 ) )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	caster:EmitSound("Hero_Phoenix.FireSpirits.Target")
	
	
		local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		point,
		nil,
		500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_NONE,
		FIND_ANY_ORDER,
		false)
		
	for _,unit in pairs(targets) do
		if unit:HasModifier("modifier_Ricardo_KokosMaslo_debuff") then
			local modif = unit:FindModifierByName("modifier_Ricardo_KokosMaslo_debuff")
			ability:ApplyDataDrivenModifier( caster, unit, "modifier_Ricardo_KokosMaslo_debuff", { duration = 10 })
			unit:SetModifierStackCount("modifier_Ricardo_KokosMaslo_debuff", ability, modif:GetStackCount() + 1)
		else
			ability:ApplyDataDrivenModifier( caster, unit, "modifier_Ricardo_KokosMaslo_debuff", { duration = 10 })
			unit:SetModifierStackCount("modifier_Ricardo_KokosMaslo_debuff", ability, 1)
		end
	end
end

function KokosMasloDamage(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.unit
	local base_damage = ability:GetLevelSpecialValueFor("bonus_damage", ability:GetLevel() - 1)
	local modif = target:FindModifierByName("modifier_Ricardo_KokosMaslo_debuff")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_enigma_2")
	
	if Talent:GetLevel() == 1 then
		base_damage = base_damage + 20
		print("talent")
	end
	
	local damage = modif:GetStackCount() * base_damage
		
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})	
end