function Fade( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	local origin = caster:GetAbsOrigin()
	local duration = 5
	local outgoingDamage = 100
	local incomingDamage = 100

	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetControllableByPlayer(player, true)
	
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
	illusion:AddNewModifier(caster, ability, "modifier_phased", { duration = 2 })
	illusion:MakeIllusion()
end