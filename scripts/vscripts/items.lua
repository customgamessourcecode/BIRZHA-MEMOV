function COverthrowGameMode:ThinkGoldDrop()
	local r = RandomInt( 1, 100 )
	if r > ( 100 - self.m_GoldDropPercent ) then
		self:SpawnGold()
	end
end

function COverthrowGameMode:SpawnGold()
	local overBoss = Entities:FindByName( nil, "@overboss" )
	local throwCoin = nil
	local throwCoin2 = nil
	if overBoss then
		throwCoin = overBoss:FindAbilityByName( 'dota_ability_throw_coin' )
		throwCoin2 = overBoss:FindAbilityByName( 'dota_ability_throw_coin_long' )
	end

	-- sometimes play the long anim
	if throwCoin2 and RandomInt( 1, 100 ) > 80 then
		overBoss:CastAbilityNoTarget( throwCoin2, -1 )
	elseif throwCoin then
		overBoss:CastAbilityNoTarget( throwCoin, -1 )
	else
		self:SpawnGoldEntity( Vector( 0, 0, 0 ) )
	end
end

function COverthrowGameMode:SpawnGoldEntity( spawnPoint )
	EmitGlobalSound("Item.PickUpGemWorld")
	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local dropRadius = RandomFloat( self.m_GoldRadiusMin, self.m_GoldRadiusMax )
	newItem:LaunchLootInitialHeight( false, 0, 500, 0.75, spawnPoint + RandomVector( dropRadius ) )
	newItem:SetContextThink( "KillLoot", function() return self:KillLoot( newItem, drop ) end, 20 )
end


--Removes Bags of Gold after they expire
function COverthrowGameMode:KillLoot( item, drop )

	if drop:IsNull() then
		return
	end

	if GameRules:IsGamePaused() == true then
        return 1
    end
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	EmitGlobalSound("Item.PickUpWorld")

	UTIL_Remove( item )
	UTIL_Remove( drop )
end

function COverthrowGameMode:SpecialItemAdd( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	local hero = owner:GetClassname()
	local ownerTeam = owner:GetTeamNumber()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )
	local n = TableCount( sortedTeams )
	local leader = sortedTeams[1].teamID
	local lastPlace = sortedTeams[n].teamID

	local tableindex = 0
	local tier1 = 
	{
		"item_branches",
		"item_gauntlets",
		"item_slippers",
		"item_mantle",
		"item_circlet",
		"item_belt_of_strength",
		"item_boots_of_elves",
		"item_robe",
		"item_ogre_axe",
		"item_blade_of_alacrity",
		"item_staff_of_wizardry",
		"item_crown",
		"item_ring_of_protection",
		"item_stout_shield",
		"item_quelling_blade",
		"item_blight_stone",
		"item_orb_of_venom",
		"item_blades_of_attack",
		"item_chainmail",
		"item_quarterstaff",
		"item_helm_of_iron_will",
		"item_broadsword",
		"item_claymore",
		"item_javelin",
		"item_ring_of_tarrasque",
		"item_wind_lace",
		"item_sobi_mask",
		"item_ring_of_regen",
		"item_boots",
		"item_gloves",
		"item_cloak",
		"item_ring_of_health",
		"item_void_stone",
		"item_gem",
		"item_lifesteal",
		"item_ghost",
		"item_shadow_amulet",
		"item_recipe_null_talisman",
		"item_wraith_band",
		"item_bracer",
		"item_soul_ring",
		"item_power_treads",
		"item_ring_of_basilius",
		"item_headdress",
		"item_buckler",
		"item_urn_of_shadows",
		"item_tranquil_boots",
		"item_medallion_of_courage",
		"item_arcane_boots",
		"item_energy_booster",
		"item_soul_booster",
		"item_vitality_booster",
		"item_platemail",
		"item_talisman_of_evasion",
		"item_baldezh"
	}
	local tier2 = 
	{
		"item_blink",
		"item_vape",
		"item_mithril_hammer",
		"item_phase_boots",
		"item_oblivion_staff",
		"item_pers",
		"item_hand_of_midas",
		"item_travel_boots",
		"item_helm_of_the_dominator",
		"item_mask_of_madness",
		"item_ancient_janggo",
		"item_mekansm",
		"item_vladmir",
		"item_spirit_vessel",
		"item_holy_locket",
		"item_glimmer_cape",
		"item_force_staff",
		"item_invis_sword",
		"item_basher",
		"item_hood_of_defiance",
		"item_vanguard",
		"item_blade_mail",
		"item_dragon_lance",
		"item_echo_sabre",
		"item_maelstrom",
		"item_hyperstone",
		"item_ultimate_orb",
		"item_demon_edge",
		"item_mystic_staff",
		"item_reaver",
		"item_boots_of_invisibility",
		"item_imba_phase_boots_2",
		"item_force_boots",
		"item_pt_mem",
		"item_mem_sange",
		"item_mem_yasha",
		"item_nimbus_lapteva",
		"item_burger_larin",
		"item_burger_oblomoff",
		"item_burger_sobolev",
		"item_overheal_trank",
		"item_chill_aquila",
		"item_veil_of_discord",
		"item_necronomicon",
		"item_aether_lens",
		"item_dagon",
		"item_cyclone",
		"item_solar_crest",
		"item_rod_of_atos",
		"item_kaya",
		"item_mem_cheburek",
		"item_lesser_crit",
		"item_armlet"
	}
	local tier3 = 
	{
		"item_moon_shard",
		"item_pipe",
		"item_orchid",
		"item_ultimate_scepter",
		"item_nullifier",
		"item_ethereal_blade",
		"item_bfury",
		"item_monkey_king_bar",
		"item_mithril_hammer",
		"item_soul_booster",
		"item_crimson_guard",
		"item_black_king_bar",
		"item_lotus_orb",
		"item_shivas_guard",
		"item_bloodstone",
		"item_manta",
		"item_hurricane_pike",
		"item_aeon_disk",
		"item_diffusal_blade",
		"item_heavens_halberd",
		"item_eagle",
		"item_relic",
		"item_blink_boots",
		"item_spinner",
		"item_memolator",
		"item_roscom_midas",
		"item_aether_lupa"
	}
	local tier4 = 
	{
		"item_guardian_greaves",
		"item_refresher",
		"item_sheepstick",
		"item_octarine_core",
		"item_butterfly",
		"item_silver_edge",
		"item_radiance",
		"item_greater_crit",
		"item_rapier",
		"item_abyssal_blade",
		"item_bloodthorn",
		"item_sharoeb",
		"item_heart",
		"item_assault",
		"item_skadi",
		"item_mjollnir",
		"item_satanic",
		"item_mega_spinner",
		"item_mem_chebureksword",
		"item_frostmorn",
		"item_cuirass_3",
		"item_ultimate_mem",
		"item_tar2",
		"item_butter2",
		"item_cuirass_2",
		"item_uebator",
		"item_dagon_5"
		
	}

	local t1 = PickRandomShuffle( tier1, self.tier1ItemBucket )
	local t2 = PickRandomShuffle( tier2, self.tier2ItemBucket )
	local t3 = PickRandomShuffle( tier3, self.tier3ItemBucket )
	local t4 = PickRandomShuffle( tier4, self.tier4ItemBucket )

	local spawnedItem = ""
	
	if GetMapName() == "birzhamemov_5v5" then
		if GetTeamHeroKills( leader ) < self.TEAM_KILLS_TO_WIN / 2 then
			if ( self.leadingTeamScore - self.runnerupTeamScore >= 10 ) then
				if ownerTeam == leader then
					spawnedItem = t1
				else
					spawnedItem = t3
				end
			elseif ( self.leadingTeamScore - self.runnerupTeamScore < 10 ) then
				spawnedItem = t2
			end
		elseif GetTeamHeroKills( leader ) >= self.TEAM_KILLS_TO_WIN / 2 then
			if ( self.leadingTeamScore - self.runnerupTeamScore >= 10 ) then
				if ownerTeam == leader then
					spawnedItem = t2
				else
					spawnedItem = t4
				end
			elseif ( self.leadingTeamScore - self.runnerupTeamScore < 10 ) then
				spawnedItem = t3
			end
		end
	else
		if GetTeamHeroKills( leader ) < self.TEAM_KILLS_TO_WIN / 2 then
			if ( self.leadingTeamScore - self.runnerupTeamScore >= 10 ) then
				if ownerTeam == leader then
					spawnedItem = t1
				elseif ownerTeam == lastPlace then
					spawnedItem = t3
				else
					spawnedItem = t2
				end
			elseif ( self.leadingTeamScore - self.runnerupTeamScore < 10 ) then
				spawnedItem = t2
			end
		elseif GetTeamHeroKills( leader ) >= self.TEAM_KILLS_TO_WIN / 2 then
			if ( self.leadingTeamScore - self.runnerupTeamScore >= 10 ) then
				if ownerTeam == leader then
					spawnedItem = t2
				elseif ownerTeam == lastPlace then
					spawnedItem = t4
				else
					spawnedItem = t3
				end
			elseif ( self.leadingTeamScore - self.runnerupTeamScore < 10 ) then
				spawnedItem = t3
			end
		end
	end

	-- add the item to the inventory and broadcast
	owner:AddItemByName( spawnedItem )
	EmitGlobalSound("powerup_04")
	local overthrow_item_drop =
	{
		hero_id = hero,
		dropped_item = spawnedItem
	}
	CustomGameEventManager:Send_ServerToAllClients( "overthrow_item_drop", overthrow_item_drop )
end

function COverthrowGameMode:ThinkSpecialItemDrop()
	-- Stop spawning items after 15
	if self.nNextSpawnItemNumber >= 15 then
		return
	end
	-- Don't spawn if the game is about to end
	if nCOUNTDOWNTIMER < 20 then
		return
	end
	local t = nCOUNTDOWNTIMER
	local tSpawn = ( self.spawnTime * self.nNextSpawnItemNumber )
	local tWarn = tSpawn - 15
	
	if not self.hasWarnedSpawn and t >= tWarn then
		-- warn the item is about to spawn
		self:WarnItem()
		self.hasWarnedSpawn = true
	elseif t >= tSpawn then
		-- spawn the item
		self:SpawnItem()
		self.nNextSpawnItemNumber = self.nNextSpawnItemNumber + 1
		self.hasWarnedSpawn = false
	end
end

function COverthrowGameMode:PlanNextSpawn()
	local missingSpawnPoint =
	{
		origin = "0 0 384",
		targetname = "item_spawn_missing"
	}

	local r = RandomInt( 1, 8 )
	if GetMapName() == "birzhamemov_5v5v5" then
		print("map is birzhamemov_5v5v5")
		r = RandomInt( 1, 6 )
	elseif GetMapName() == "temple_quartet" then
		print("map is temple_quartet")
		r = RandomInt( 1, 4 )
	end
	local path_track = "item_spawn_" .. r
	local spawnPoint = Vector( 0, 0, 700 )
	local spawnLocation = Entities:FindByName( nil, path_track )

	if spawnLocation == nil then
		spawnLocation = SpawnEntityFromTableSynchronous( "path_track", missingSpawnPoint )
		spawnLocation:SetAbsOrigin(spawnPoint)
	end
	
	self.itemSpawnLocation = spawnLocation
	self.itemSpawnIndex = r
end

function COverthrowGameMode:WarnItem()
	-- find the spawn point
	self:PlanNextSpawn()

	local spawnLocation = self.itemSpawnLocation:GetAbsOrigin();

	-- notify everyone
	CustomGameEventManager:Send_ServerToAllClients( "item_will_spawn", { spawn_location = spawnLocation } )
	EmitGlobalSound( "powerup_03" )
	
	-- fire the destination particles
	DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "Start", "0", 0, self, self )

	-- Give vision to the spawn area (unit is on goodguys, but shared vision)
	local visionRevealer = CreateUnitByName( "npc_vision_revealer", spawnLocation, false, nil, nil, DOTA_TEAM_GOODGUYS )
	visionRevealer:SetContextThink( "KillVisionRevealer", function() return visionRevealer:RemoveSelf() end, 35 )
	local trueSight = ParticleManager:CreateParticle( "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", PATTACH_ABSORIGIN, visionRevealer )
	ParticleManager:SetParticleControlEnt( trueSight, PATTACH_ABSORIGIN, visionRevealer, PATTACH_ABSORIGIN, "attach_origin", visionRevealer:GetAbsOrigin(), true )
	visionRevealer:SetContextThink( "KillVisionParticle", function() return trueSight:RemoveSelf() end, 35 )
end

function COverthrowGameMode:SpawnItem()
	-- notify everyone
	CustomGameEventManager:Send_ServerToAllClients( "item_has_spawned", {} )
	EmitGlobalSound( "powerup_05" )
	-- spawn the item
	local startLocation = Vector( 0, 0, 700 )
	treasureCourier = CreateUnitByName( "npc_dota_treasure_courier" , startLocation, true, nil, nil, DOTA_TEAM_NEUTRALS )
	treasureAbility = treasureCourier:FindAbilityByName( "dota_ability_treasure_courier" )
	treasureAbility:SetLevel( 1 )
    --print ("Spawning Treasure")
    targetSpawnLocation = self.itemSpawnLocation
    treasureCourier:SetInitialGoalEntity(targetSpawnLocation)
    local particleTreasure = ParticleManager:CreateParticle( "particles/items_fx/black_king_bar_avatar.vpcf", PATTACH_ABSORIGIN, treasureCourier )
	ParticleManager:SetParticleControlEnt( particleTreasure, PATTACH_ABSORIGIN, treasureCourier, PATTACH_ABSORIGIN, "attach_origin", treasureCourier:GetAbsOrigin(), true )
	treasureCourier:Attribute_SetIntValue( "particleID", particleTreasure )
end

function COverthrowGameMode:ForceSpawnItem()
	self:WarnItem()
	self:SpawnItem()
end

function COverthrowGameMode:KnockBackFromTreasure( center, radius )

	local targetType = bit.bor( DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_HERO )
	local knockBackUnits = FindUnitsInRadius( DOTA_TEAM_NOTEAM, center, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, targetType, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )

	for _,unit in pairs(knockBackUnits) do
		unit:AddNewModifier( unit, nil, "modifier_stunned", { duration = 1 })
	end
end


function COverthrowGameMode:TreasureDrop( treasureCourier )
	--Create the death effect for the courier
	local spawnPoint = treasureCourier:GetInitialGoalEntity():GetAbsOrigin()
	spawnPoint.z = 400
	local fxPoint = treasureCourier:GetInitialGoalEntity():GetAbsOrigin()
	fxPoint.z = 400
	local particle = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, fxPoint )
	local deathEffects = ParticleManager:CreateParticle( "particles/treasure_courier_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( deathEffects, 0, fxPoint )
	ParticleManager:SetParticleControlOrientation( deathEffects, 0, treasureCourier:GetForwardVector(), treasureCourier:GetRightVector(), treasureCourier:GetUpVector() )
	EmitGlobalSound( "lockjaw_Courier.Impact" )
	EmitGlobalSound( "lockjaw_Courier.gold_big" )

	--Spawn the treasure chest at the selected item spawn location
	local newItem = CreateItem( "item_treasure_chest", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	drop:SetForwardVector( treasureCourier:GetRightVector() ) -- oriented differently
	newItem:LaunchLootInitialHeight( false, 0, 50, 0.25, spawnPoint )

	--Stop the particle effect
	DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "stopplayendcap", "0", 0, self, self )

	--Knock people back from the treasure
	self:KnockBackFromTreasure( spawnPoint, 375 )
	
	--Destroy the courier
	UTIL_Remove( treasureCourier )
end

function COverthrowGameMode:ForceSpawnGold()
	self:SpawnGold()
end

