function TwinBrother( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	local origin = caster:GetAbsOrigin() + RandomVector(100)
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage", ability:GetLevel() - 1 )
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_troll_warlord_3")
	
	if Talent:GetLevel() == 1 then
		outgoingDamage = outgoingDamage + 25
	end

	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeam())
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetControllableByPlayer(player, true)
	illusion:SetOwner(caster)
	
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
end