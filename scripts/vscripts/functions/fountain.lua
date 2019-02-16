function effect(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local player = target:GetPlayerID()
	
	if IsUnlockedInPass(player, "reward3") then
		ability:ApplyDataDrivenModifier( target, target, "modifier_fountain_aura_donate_effect", { Duration = 1 })
	end
end

function off( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	CustomGameEventManager:Send_ServerToAllClients("fountain_true", {} )
	Timers:CreateTimer(3, function()
		CustomGameEventManager:Send_ServerToAllClients("fountain_false", {} )
	end)
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_fountain_aura_afk", {})
	EmitGlobalSound("Tutorial.Notice.Speech")
end

function damage( keys )

	local caster = keys.caster
	local units = FindUnitsInRadius( caster:GetTeam(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	
	if nCOUNTDOWNTIMER then
		if nCOUNTDOWNTIMER >= 1200 then
			caster:RemoveModifierByName("modifier_degen_aura")
		end
	end

	for _,target in pairs (units) do
		target:EmitSound("Ability.LagunaBlade")
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );
		ApplyDamage({attacker = target, victim = target, ability = ability, damage = 100000, damage_type = DAMAGE_TYPE_PURE})
	end
end