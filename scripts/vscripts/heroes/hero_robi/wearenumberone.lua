function WeAreNumberOneCast(keys)

	local caster = keys.caster
	local target = keys.target
	local unit = caster:GetUnitName()
	local ability = keys.ability
	local origin = target:GetAbsOrigin() + RandomVector(100)
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local attackDelay = ability:GetLevelSpecialValueFor( "attack_delay", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage", ability:GetLevel() - 1 )
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_riki_4")
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_riki_3")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 2
	end
	
	if Talent2:GetLevel() == 1 then
		outgoingDamage = 100
	end

	local illusion = CreateUnitByName(unit, origin, true, caster, nil, caster:GetTeam())
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetOwner(caster)

	illusion:SetForwardVector(target:GetAbsOrigin() - illusion:GetAbsOrigin())

	local casterLevel = caster:GetLevel()
	for i=1,casterLevel-1 do
		illusion:HeroLevelUp(false)
	end

	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = caster:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			illusionAbility:SetLevel(abilityLevel)
		end
	end

	for itemSlot=0,5 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end

	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	illusion:MakeIllusion()
	ability:ApplyDataDrivenModifier(caster, illusion, "modifier_robi_WeAreNumberOne_buff", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, illusion, "modifier_robi_WeAreNumberOne_illusion_debuff", {duration = attackDelay})
	illusion:MoveToNPC(target)

	Timers:CreateTimer({
		endTime = attackDelay,
		callback = function()
			illusion:SetForceAttackTarget(target)
		end
	})

	caster.haunting = true

	Timers:CreateTimer({
		endTime = duration,
		callback = function()
			caster.haunting = false
		end
	})
end

function LevelUpWeAreNumberOne (keys)

	local caster = keys.caster
	local ability_reality = caster:FindAbilityByName("Robi_WeAreNumberOneTeleport")
	if ability_reality ~= nil then
		ability_reality:SetLevel(1)
	end

	caster.haunting = false

end

function WeAreNumberOneTeleport (keys)

	local caster = keys.caster
	local ability = keys.ability
	local unit = caster:GetUnitName()
	local vPoint = ability:GetCursorPosition()

	if caster.haunting then
		local target = Entities:FindByNameNearest(unit, vPoint, 0)

		if target:IsIllusion() then
			local caster_forward_vector = caster:GetForwardVector()
			local target_forward_vector = target:GetForwardVector()
			
			caster:SetForwardVector(target_forward_vector)
			target:SetForwardVector(caster_forward_vector)

			
			local caster_current_position = caster:GetAbsOrigin()
			local target_current_position = target:GetAbsOrigin()

			target:SetAbsOrigin(caster_current_position)	
			caster:SetAbsOrigin(target_current_position)

			FindClearSpaceForUnit( caster, target_current_position, true )

			EmitSoundOn("Hero_Spectre.Reality", caster)
		end
	end
end