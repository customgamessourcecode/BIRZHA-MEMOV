function bigrussianboss_ultimate_start(keys)
	local caster = keys.caster
	local caster_origin = caster:GetAbsOrigin()
	local target = keys.target
	local target_origin = target:GetAbsOrigin()
	local ability = keys.ability
	local modifier_duel = "modifier_brb_test"
	
	if target:HasItemInInventory("item_sphere") or target:IsIllusion() == false then
		caster:EmitSound("legend")
		caster.legion_commander_duel_datadriven_particle = ParticleManager:CreateParticle("particles/duel/legion_duel_ring_arcana.vpcf", PATTACH_ABSORIGIN, caster)
		local center_point = target_origin + ((caster_origin - target_origin) / 1)
		ParticleManager:SetParticleControl(caster.legion_commander_duel_datadriven_particle, 0, center_point)  --The center position.
		ParticleManager:SetParticleControl(caster.legion_commander_duel_datadriven_particle, 7, center_point)  --The flag's position (also centered).
		local order_target = 
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}
		local order_caster =
		{
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex()
		}
		target:Stop()
		ExecuteOrderFromTable(order_target)
		ExecuteOrderFromTable(order_caster)
		caster:SetForceAttackTarget(target)
		target:SetForceAttackTarget(caster)
		ability:ApplyDataDrivenModifier(caster, caster, modifier_duel, {Duration = keys.Duration})
		ability:ApplyDataDrivenModifier(caster, target, modifier_duel, {Duration = keys.Duration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_brb_test_attack_target", {Duration = keys.Duration})
	else
		print(LinkBlock)
	end
end

function modifier_test_on_death(keys)
	local caster = keys.caster
	local caster_team = caster:GetTeam()
	local unit = keys.unit
	local ability = keys.ability
	local modifier_duel = "modifier_brb_test"
	local modifier_duel_damage = "modifier_test_damage"
	ability.bonusDamage = keys.RewardDamage
	
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_invoker_3")
	
	if Talent:GetLevel() == 1 then
		ability.bonusDamage = ability.bonusDamage + 30
	end
	
	
	if unit == caster then  --If Legion Commander was killed.
		local herolist = HeroList:GetAllHeroes()
		for i, individual_hero in ipairs(herolist) do  --Iterate through the enemy heroes, award any with a Duel modifier the reward damage, and then remove that modifier.
			if individual_hero:GetTeam() ~= caster_team and individual_hero:HasModifier(modifier_duel) then
				if individual_hero:HasModifier(modifier_duel) then
					if not individual_hero:HasModifier(modifier_duel_damage) then
						ability:ApplyDataDrivenModifier(caster, individual_hero, modifier_duel_damage, {})
					end
					local duel_stacks = individual_hero:GetModifierStackCount(modifier_duel_damage, ability) + ability.bonusDamage
					individual_hero:SetModifierStackCount(modifier_duel_damage, ability, duel_stacks)
					individual_hero:RemoveModifierByName(modifier_duel)
					individual_hero:RemoveModifierByName("modifier_brb_test_attack_target")
					
					individual_hero:EmitSound("Hero_LegionCommander.Duel.Victory")
					local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_ABSORIGIN_FOLLOW, individual_hero)
				end
			end
		end
	else  --If Legion Commander's opponent was killed.
		if not caster:HasModifier(modifier_duel_damage) then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_duel_damage, {})
		end
		local duel_stacks = caster:GetModifierStackCount(modifier_duel_damage, ability) + ability.bonusDamage
		caster:SetModifierStackCount(modifier_duel_damage, ability, duel_stacks)
		caster:RemoveModifierByName(modifier_duel)
		
		caster:EmitSound("Hero_LegionCommander.Duel.Victory")
		local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	end
end

function modifier_test_on_destroy(keys)
	local caster = keys.caster
	local target = keys.target
	
	caster:StopSound("legend")
	
	if caster.legion_commander_duel_datadriven_particle ~= nil then
		ParticleManager:DestroyParticle(caster.legion_commander_duel_datadriven_particle, false)
	end

	target:SetForceAttackTarget(nil)
	caster:SetForceAttackTarget(nil)
	caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
end

function modifier_test_on_attack_passive( keys )
	local caster = keys.caster
	local target = keys.target

	target:SetForceAttackTarget(nil)

	if caster:IsAlive() then
		local order = 
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		ExecuteOrderFromTable(order)
	else
		target:Stop()
	end

	target:SetForceAttackTarget(caster)
end

function GladSorryEnd( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end