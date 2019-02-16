function DropBristlekek(keys)
	local spawnPointChest = keys.caster:GetAbsOrigin()
	
	local BossDrop = CreateItem( "item_bristback", nil, nil )
	
	local DropItem = CreateItemOnPositionForLaunch( spawnPointChest, BossDrop )
	local dropRadiusChest = RandomFloat( 100, 200 )
	
	local attacker = keys.attacker
	local team = attacker:GetTeam()
	local AllHeroes = HeroList:GetAllHeroes()
		for count, hero in ipairs(AllHeroes) do
			if hero:GetTeam() == team then
				hero:ModifyGold( 700, true, 0 )
			end
		end
		
	CustomGameEventManager:Send_ServerToAllClients("bristlekek_killed_true", {} )
		Timers:CreateTimer(3, function()
			CustomGameEventManager:Send_ServerToAllClients("bristlekek_killed_false", {} )
		end)
	
	EmitGlobalSound("conquest.stinger.capture_radiant")
	BossDrop:LaunchLootInitialHeight( false, 0, 300, 0.75, spawnPointChest + RandomVector( dropRadiusChest ) )
	
	Timers:CreateTimer(300, function()
		local RoshanSpawnPoint = Entities:FindByName( nil, "RoshanSpawn" ):GetAbsOrigin()
	
		local Boss = CreateUnitByName("npc_dota_bristlekek", RoshanSpawnPoint, false, nil, nil, DOTA_TEAM_NEUTRALS)
	end)
end

function DropLolBlade(keys)
	local spawnPointChest = keys.caster:GetAbsOrigin()
	
	local BossDrop2 = CreateItem( "item_crysdalus", nil, nil )
	
	local DropItem2 = CreateItemOnPositionForLaunch( spawnPointChest, BossDrop2 )
	local dropRadiusChest = RandomFloat( 100, 200 )
	
	local attacker = keys.attacker
	local team = attacker:GetTeam()
	local AllHeroes = HeroList:GetAllHeroes()
	for count, hero in ipairs(AllHeroes) do
		if hero:GetTeam() == team then
			hero:ModifyGold( 700, true, 0 )
		end
	end
	
	CustomGameEventManager:Send_ServerToAllClients("lolblade_killed_true", {} )
		Timers:CreateTimer(3, function()
			CustomGameEventManager:Send_ServerToAllClients("lolblade_killed_false", {} )
		end)
	
	EmitGlobalSound("conquest.stinger.capture_radiant")	
	BossDrop2:LaunchLootInitialHeight( false, 0, 300, 0.75, spawnPointChest + RandomVector( dropRadiusChest ) )
	
	Timers:CreateTimer(300, function()
		local RoshanSpawnPoint = Entities:FindByName( nil, "RoshanSpawn2" ):GetAbsOrigin()
	
		local Boss = CreateUnitByName("npc_dota_LolBlade", RoshanSpawnPoint, false, nil, nil, DOTA_TEAM_NEUTRALS)
	end)	
end


function LolBladeAbility( event )
	local caster = event.caster
	local ability = event.ability
	local duration = 3
	local outgoingDamage = 100
	
	
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)
	
	for _,hero in pairs(heroes) do
		if ability:GetCooldownTimeRemaining() == 0 then
			if hero == nil then return end
			local unit_name = hero:GetUnitName()
			local origin = hero:GetAbsOrigin() + RandomVector(100)
			local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
			ability:StartCooldown(20)

			local targetLevel = hero:GetLevel()
			for i=1,targetLevel-1 do
				illusion:HeroLevelUp(false)
			end

			illusion:SetAbilityPoints(0)
			for abilitySlot=0,15 do
				local ability = hero:GetAbilityByIndex(abilitySlot)
				if ability ~= nil then 
					local abilityLevel = ability:GetLevel()
					local abilityName = ability:GetAbilityName()
					local illusionAbility = illusion:FindAbilityByName(abilityName)
					illusionAbility:SetLevel(abilityLevel)
				end
			end

			for itemSlot=0,5 do
				local item = hero:GetItemInSlot(itemSlot)
				if item ~= nil then
					local itemName = item:GetName()
					local newItem = CreateItem(itemName, illusion, illusion)
					illusion:AddItem(newItem)
				end
			end

			illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = 0 })
			illusion:MakeIllusion()
			ability:ApplyDataDrivenModifier(caster, illusion, "modifier_reflection_invulnerability", nil)
			illusion:SetForceAttackTarget(hero)
			illusion:EmitSound("Hero_Terrorblade.Reflection")
		end
	end
end
