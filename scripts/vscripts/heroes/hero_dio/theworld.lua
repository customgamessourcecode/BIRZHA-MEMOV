function TheWorldSpawn( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = caster:GetAbsOrigin() + RandomVector(100)

	local unit_name = event.unit_name
	unit_name = unit_name..level

	if caster.bear and IsValidEntity(caster.bear) and caster.bear:IsAlive() then
		FindClearSpaceForUnit(caster.bear, origin, true)
		caster.bear:SetHealth(caster.bear:GetMaxHealth())
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.bear)	
	else
		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:SetControllableByPlayer(player, true)
		
		if ability ~= nil then
			ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_dio_TheWorld", nil)
		end

		LearnBearAbilities( caster.bear, 1 )
	end
end

function TheWorldLevel( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local unit_name = "npc_dio_theworld"..level

	if caster.bear and caster.bear:IsAlive() then 
		local origin = caster.bear:GetAbsOrigin()
		caster.bear:RemoveSelf()

		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:SetControllableByPlayer(player, true)
		ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_dio_TheWorld", nil)

		LearnBearAbilities( caster.bear, 1 )
	end
end

function LearnBearAbilities( unit, level )

	for i=0,15 do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			ability:SetLevel(level)
			print("Set Level "..level.." on "..ability:GetAbilityName())
		end
	end

end

function TheWorldDeath( event )
	local caster = event.caster
	local killer = event.attacker
	local ability = event.ability

	local damage = 99999999
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_faceless_void_2")
	
	if Talent:GetLevel() == 1 then
		damage = 0
	end

	ApplyDamage({ victim = caster, attacker = killer, damage = damage, damage_type = DAMAGE_TYPE_PURE })
end

function TheWorldRadius( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local casterLocation = caster:GetAbsOrigin()
	local radius = 900
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_skywrath_2")
	
	if Talent:GetLevel() == 1 and not target:HasModifier("modifier_dio_TheWorld_talent") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_dio_TheWorld_talent", nil)
		print("dalsa")
	end
	

	if caster.bear:HasModifier("modifier_dio_TheWorld_radius_check") then
		caster.bear:RemoveModifierByName("modifier_dio_TheWorld_silence")
		if target:GetUnitName() == "npc_dio_theworld1" then
			target:RemoveModifierByName("modifier_dio_TheWorld_silence")
		end
		if target:GetUnitName() == "npc_dio_theworld2" then
			target:RemoveModifierByName("modifier_dio_TheWorld_silence")
		end
		if target:GetUnitName() == "npc_dio_theworld3" then
			target:RemoveModifierByName("modifier_dio_TheWorld_silence")
		end
	else
		ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_dio_TheWorld_silence", nil)
		if target:GetUnitName() == "npc_dio_theworld1" then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_dio_TheWorld_silence", nil)
		end
		if target:GetUnitName() == "npc_dio_theworld2" then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_dio_TheWorld_silence", nil)
		end
		if target:GetUnitName() == "npc_dio_theworld3" then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_dio_TheWorld_silence", nil)
		end
	end
end