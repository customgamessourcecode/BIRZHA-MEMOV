LinkLuaModifier( "modifier_admin", "modifiers/modifier_admin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vip", "modifiers/modifier_vip", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sponsor", "modifiers/modifier_sponsor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gob", "modifiers/modifier_gob", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_never_arcana", "modifiers/modifier_never_arcana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rewards", "modifiers/modifier_rewards", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disconnect_debuff", "modifiers/modifier_disconnect_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_BirzhaMemov_startgame", "modifiers/modifier_BirzhaMemov_startgame", LUA_MODIFIER_MOTION_NONE )

_G.nNEUTRAL_TEAM = 4

if COverthrowGameMode == nil then
	_G.COverthrowGameMode = class({})
end

require( "events" )
require('timers')
require( "items" )
require( "utility_functions" )
require('functions/reklama')
require("functions/function")

---------
-- BirzhaPASS
---------
require('memespass/init')
require('util/requests')
require('util/math')
require('util/players')

--------
-- MMR
-------
require("util/mmr")
require("commands/chat")
require("util/disconnect")

--------
-- Pick
-------
require('util/custompick')
require('util/tophud')


function Precache( context )
		PrecacheItemByNameSync( "item_bag_of_gold", context )
		PrecacheResource( "particle", "particles/items2_fx/veil_of_discord.vpcf", context )	
		PrecacheItemByNameSync( "item_treasure_chest", context )
		PrecacheModel( "item_treasure_chest", context )
		PrecacheUnitByNameSync( "npc_dota_creature_basic_zombie", context )
        PrecacheModel( "npc_dota_creature_basic_zombie", context )
        PrecacheUnitByNameSync( "npc_dota_creature_berserk_zombie", context )
        PrecacheModel( "npc_dota_creature_berserk_zombie", context )
        PrecacheUnitByNameSync( "npc_dota_treasure_courier", context )
        PrecacheModel( "npc_dota_treasure_courier", context )
       	PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf", context )
       	PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
       	PrecacheResource( "particle", "particles/last_hit/last_hit.vpcf", context )
       	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf", context )
       	PrecacheResource( "particle", "particles/addons_gameplay/player_deferred_light.vpcf", context )
       	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
       	PrecacheResource( "particle", "particles/treasure_courier_death.vpcf", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_dragon_knight", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_venomancer", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_axe", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_life_stealer", context )
       	PrecacheResource( "particle", "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", context )			
		PrecacheResource( "soundfile", "soundevents/game_sounds_birzha.vsndevts", context )
		PrecacheResource("particle_folder", "particles/econ/items/invoker/invoker_apex", context)
	    PrecacheResource("particle_folder", "particles/hw_fx", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_creeps.vsndevts", context )
	    PrecacheResource("particle", "particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_dire_lvl2.vpcf", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context )
		PrecacheResource( "model", "models/heroes/storm_spirit/storm_spirit.vmdl", context )
		PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_ghost_ship_model.vpcf", context )
		PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_ghost_ship.vpcf", context )
		PrecacheResource( "particle", "particles/memolator3/memolator.vpcf", context )
		PrecacheResource( "particle", "particles/generic_gameplay/generic_silenced.vpcf", context )
		PrecacheResource( "particle", "particles/memolator2/desolator_projectile.vpcf", context )
		PrecacheResource( "particle", "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_base_attack.vpcf", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_dragon_knight", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_venomancer", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_axe", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_life_stealer", context )
        PrecacheResource( "particle", "particles/kli4ko/tinker_laser.vpcf", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/soundevents_conquest.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_Winter_Wyvern.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_viper.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_terrorblade.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shadow_demon.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skeleton_king.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_wraith_king.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spectre.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer_diretide_2012.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_roshan_halloween.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer_dlc_rick_and_morty.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context)
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context)
		PrecacheResource( "soundfile",	"soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context)
		PrecacheResource( "soundfile",	"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context)
		PrecacheResource( "soundfile",	"soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context)
		PrecacheResource( "soundfile",	"soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context)
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts", context)
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_willow.vsndevts", context)
end

function Activate()
	COverthrowGameMode:InitGameMode()
	ListenToGameEvent("player_chat", Dynamic_Wrap(ChatListener, 'OnPlayerChat'), ChatListener)
	CustomGameEventManager:RegisterListener( "birzha_emitsound", Dynamic_Wrap(COverthrowGameMode, "BirzhaSoundEmit"))
	CustomGameEventManager:RegisterListener( "birzha_spray", Dynamic_Wrap(COverthrowGameMode, "BirzhaSpray"))
end

function COverthrowGameMode:BirzhaSoundEmit(event) 
	if not PlayerResource:GetSelectedHeroEntity(event.PlayerID):HasModifier("modifier_bp_sounds") then
		if PlayerResource:GetSelectedHeroEntity(event.PlayerID):IsAlive() then
			EmitGlobalSound(event.sound)
			PlayerResource:GetSelectedHeroEntity(event.PlayerID):AddNewModifier(nil, nil, "modifier_bp_sounds", {duration = 10})
		end
	end
end

function COverthrowGameMode:BirzhaSpray(event) 
	if not PlayerResource:GetSelectedHeroEntity(event.PlayerID):HasModifier("modifier_bp_sprays") then
		if PlayerResource:GetSelectedHeroEntity(event.PlayerID):IsAlive() then
			local spray = ParticleManager:CreateParticle(event.spray, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl( spray, 0, PlayerResource:GetSelectedHeroEntity(event.PlayerID):GetOrigin() )
			ParticleManager:ReleaseParticleIndex( spray )
			PlayerResource:GetSelectedHeroEntity(event.PlayerID):AddNewModifier(nil, nil, "modifier_bp_sprays", {duration = 10})
			PlayerResource:GetSelectedHeroEntity(event.PlayerID):EmitSound("Spraywheel.Paint")
		end
	end
end

LinkLuaModifier( "modifier_bp_sounds", "addon_game_mode", LUA_MODIFIER_MOTION_NONE )

modifier_bp_sounds = class({})

function modifier_bp_sounds:IsHidden()
return true
end

LinkLuaModifier( "modifier_bp_sprays", "addon_game_mode", LUA_MODIFIER_MOTION_NONE )

modifier_bp_sprays = class({})

function modifier_bp_sprays:IsHidden()
return true
end

function COverthrowGameMode:InitGameMode()

	XP_PER_LEVEL_TABLE = {
    0, -- 1
    200, -- 2
    600, -- 3
    1080, -- 4
    1680, -- 5
    2300, -- 6	 
    3940, -- 7	 
    4600, -- 8
    5280, -- 9
    6080, -- 10
	6900,  --- 11
	7740,  --- 12
	8640,  --- 13
	9865,  --- 14
	11115, --- 15
	12390, --- 16
	13690, --- 17
	15015, --- 18
	16415, --- 19
	17905, --- 20
	19405, --- 21
	21155, --- 22
	23155, --- 23
	25405, --- 24
	27905, --- 25
	30655, --- 26
	33655, --- 27
	36905, --- 28
	40405, --- 29
	44405, --- 30
	48655, --- 31
	52155, --- 32
	56905, --- 33
	58905, --- 34
	62905, --- 35
  }
  
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( 35 )
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)

	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple

	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

	self.m_GatheredShuffledTeams = {}
	self.numSpawnCamps = 5
	self.specialItem = ""
	self.spawnTime = 120
	self.nNextSpawnItemNumber = 1
	self.hasWarnedSpawn = false
	self.allSpawned = false
	self.leadingTeam = -1
	self.runnerupTeam = -1
	self.leadingTeamScore = 0
	self.runnerupTeamScore = 0
	self.isGameTied = true
	self.countdownEnabled = false
	self.itemSpawnIndex = 1
	self.itemSpawnLocation = Entities:FindByName( nil, "greevil" )
	self.tier1ItemBucket = {}
	self.tier2ItemBucket = {}
	self.tier3ItemBucket = {}
	self.tier4ItemBucket = {}

	self.TEAM_KILLS_TO_WIN = 25
	self.CLOSE_TO_VICTORY_THRESHOLD = 5

	self:GatherAndRegisterValidTeams()

	GameRules:GetGameModeEntity().COverthrowGameMode = self

	if GetMapName() == "birzhamemov_5v5v5" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 5 )
		self.m_GoldRadiusMin = 300
		self.m_GoldRadiusMax = 1400
		self.m_GoldDropPercent = 8
	else
		self.m_GoldRadiusMin = 250
		self.m_GoldRadiusMax = 550
		self.m_GoldDropPercent = 4
	end
	
	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetCustomVictoryMessageDuration( 20 )
	GameRules:SetPreGameTime( 0 )
	GameRules:SetStrategyTime( 0 )
	GameRules:SetShowcaseTime( 0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE , true ) --Double Damage
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_HASTE, true ) --Haste
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ILLUSION, true ) --Illusion
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_INVISIBILITY, true ) --Invis
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_REGENERATION, false ) --Regen
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ARCANE, true ) --Arcane
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_BOUNTY, false ) --Bounty
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( 0 )
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( 0 )
	GameRules:GetGameModeEntity():SetFountainConstantManaRegen( 0 )
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( COverthrowGameMode, "BountyRunePickupFilter" ), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( COverthrowGameMode, "ExecuteOrderFilter" ), self )


	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( COverthrowGameMode, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( COverthrowGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( COverthrowGameMode, 'OnTeamKillCredit' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( COverthrowGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( COverthrowGameMode, "OnItemPickUp"), self )
	ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( COverthrowGameMode, "OnNpcGoalReached" ), self )
	

	Convars:RegisterCommand( "overthrow_force_item_drop", function(...) self:ForceSpawnItem() end, "Force an item drop.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_force_gold_drop", function(...) self:ForceSpawnGold() end, "Force gold drop.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_set_timer", function(...) return SetTimer( ... ) end, "Set the timer.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_force_end_game", function(...) return self:EndGame( DOTA_TEAM_GOODGUYS ) end, "Force the game to end.", FCVAR_CHEAT )
	Convars:SetInt( "dota_server_side_animation_heroesonly", 0 )

	GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")
	COverthrowGameMode:SetUpFountains()
	BirzhaCheck:Init()
	CustomPick:Init()
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 
end

function COverthrowGameMode:SetUpFountains()
	LinkLuaModifier( "modifier_fountain_aura_lua", "modifiers/modifier_fountain_aura_lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_fountain_aura_effect_lua", "modifiers/modifier_fountain_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

	local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
	for _,fountainEnt in pairs( fountainEntities ) do
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {} )
	end
end

function COverthrowGameMode:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 }
	end
	return color
end

function COverthrowGameMode:EndGame( victoryTeam, LastTeam )
	RequestData("http://bmemov.ru/api/compendium.json", function(data) 
	ChangeData(data)
	end)
	if BirzhaMmr:IsMmrMap() then
		CustomNetTables:SetTableValue("birzha_mmr", "game_winner", {t = victoryTeam} )
		CustomNetTables:SetTableValue("birzha_mmr", "game_lose", {l = LastTeam} )
		RequestData("http://bmemov.ru/api/mmr.json", function(data) BirzhaMmr:EndGame(data) end)
		print("Mmr был отправлен")
	end
end

function COverthrowGameMode:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end

function COverthrowGameMode:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )

		-- Scaleform UI Scoreboard
		local score = 
		{
			team_id = t.teamID,
			team_score = t.teamScore
		}
		FireGameEvent( "score_board", score )
	end
	-- Leader effects (moved from OnTeamKillCredit)
	local leader = sortedTeams[1].teamID
	--print("Leader = " .. leader)
	self.leadingTeam = leader
	self.runnerupTeam = sortedTeams[2].teamID
	self.leadingTeamScore = sortedTeams[1].teamScore
	self.runnerupTeamScore = sortedTeams[2].teamScore
	if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
		self.isGameTied = true
	else
		self.isGameTied = false
	end
	local allHeroes = HeroList:GetAllHeroes()
	for _,entity in pairs( allHeroes) do
		if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
			if entity:IsAlive() == true then
				-- Attaching a particle to the leading team heroes
				local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
       			if existingParticle == -1 then
       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
				end
			else
				local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
				if particleLeader ~= -1 then
					ParticleManager:DestroyParticle( particleLeader, true )
					entity:DeleteAttribute( "particleID" )
				end
			end
		else
			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
			if particleLeader ~= -1 then
				ParticleManager:DestroyParticle( particleLeader, true )
				entity:DeleteAttribute( "particleID" )
			end
		end
	end
end

function COverthrowGameMode:OnThink()

	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:UpdatePlayerColor( nPlayerID )
	end
	
	self:UpdateScoreboard()
	
	if GameRules:IsGamePaused() == true then
        return 1
    end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		
		if pickbirzhaend == nil then 
			CustomPick:OnThink()
			print("dodik")
			return 1
		end
		
		CountdownTimer()
		
		if FountainTimer > 0 then
			CountdownFountainTimer()
		end
		
		if not GameRules:IsCheatMode() then
			Timers:CreateTimer(3, function()
				BirzhaCheck:AutoWin()
			end)
		end
		
		for _,hero in pairs(HeroList:GetAllHeroes()) do
			for i = 0,5 do
				local item = hero:GetItemInSlot(i)
				if item then
					if item:IsMuted() then
						hero:DropItemAtPositionImmediate(item, hero:GetAbsOrigin())
					end
				end
			end
		end
		
		local Heroes = HeroList:GetAllHeroes()
		for _,Hero in pairs ( Heroes ) do
			if Hero:HasOwnerAbandoned() and not Hero:HasModifier("modifier_disconnect_debuff") then
				Hero:AddNewModifier(Hero, nil, "modifier_disconnect_debuff", nil)
				CustomGameEventManager:Send_ServerToAllClients("birzha_top_hood_disconnect", {PlayerID = Hero:GetPlayerID()})
			end
		end
		
		if GetMapName() == "birzhamemov_solo" then
			COverthrowGameMode:ThinkGoldDrop()
			COverthrowGameMode:ThinkSpecialItemDrop()
		end
		
		if GetMapName() == "birzhamemov_duo" then
			COverthrowGameMode:ThinkGoldDrop()
			COverthrowGameMode:ThinkSpecialItemDrop()
		end

		if GetMapName() == "birzhamemov_trio" then
			COverthrowGameMode:ThinkGoldDrop()
			COverthrowGameMode:ThinkSpecialItemDrop()
		end
		
		if GetMapName() == "birzhamemov_5v5v5" then
			COverthrowGameMode:ThinkGoldDrop()
			COverthrowGameMode:ThinkSpecialItemDrop()
		end
		
		if GetMapName() == "birzhamemov_5v5" then
			COverthrowGameMode:ThinkGoldDrop()
			COverthrowGameMode:ThinkSpecialItemDrop()
		end
	end

	return 1
end

function COverthrowGameMode:GatherAndRegisterValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end

function COverthrowGameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)
		if npc:IsRealHero() then
			CustomGameEventManager:Send_ServerToAllClients("birzha_top_hood_respawn", {PlayerID = npc:GetPlayerID()})
		end
	   	if npc:IsHero() and npc.bFirstSpawned == nil then
			if npc:GetUnitName() == "npc_dota_hero_wisp" then
				 npc:FindAbilityByName("game_start"):SetLevel(1)
				return
			end
	   		npc.bFirstSpawned = true
			local playerID = npc:GetPlayerID()
	    	local steamID = PlayerResource:GetSteamAccountID(playerID)
			COverthrowGameMode:OnHeroInGame(npc)
			
			
			if not npc:IsIllusion() then
				npc:AddItemByName("item_courier")
				
				if IsUnlockedInPass(playerID, "reward7") then
					npc:AddNewModifier( npc, nil, "modifier_rewards", {duration = -1})
				end
				
				--Premium
				
				local premium = 
				{
					106096878, -- stranger
					290640546, -- IIIpam
					254502295, -- Dim4ik
					130168657, -- Kw1te
					136356113, -- Kaliostro
					170590037, -- IceDonro immortal dark seer
					307325307, -- Rem
					216210038,
					202171131 -- https://vk.com/id138367286
				}
				
				for _,premium_modifier in pairs(premium) do
					if steamID == premium_modifier then
						npc:AddNewModifier( npc, nil, "modifier_admin", {duration = -1})
						
						local chancePet = RandomInt(1,5)
						local Pet = CreateUnitByName("unit_premium_pet"..chancePet, npc:GetAbsOrigin() + RandomVector(RandomFloat(0,100)), true, npc, nil, npc:GetTeamNumber())
						Pet:SetOwner(npc)
					end
				end
				
				--Special Pet for Donaters Sion_Atlasia	
				if steamID == 141034428 then
					local Pet = CreateUnitByName("unit_premium_pet5", npc:GetAbsOrigin() + RandomVector(RandomFloat(0,100)), true, npc, nil, npc:GetTeamNumber())
					Pet:SetOwner(npc)
				end
				
				if steamID == 98022540 then
					local Pet = CreateUnitByName("unit_premium_pet6", npc:GetAbsOrigin() + RandomVector(RandomFloat(0,100)), true, npc, nil, npc:GetTeamNumber())
					Pet:SetOwner(npc)
				end
				
				--Guys Of Balance
				if steamID == 141034428 or steamID == 248344741 or steamID == 264646604 or steamID == 265405372 or steamID == 164854966 then
					npc:AddNewModifier( npc, nil, "modifier_gob", {duration = -1})
				end
				
				--Vip
				
				local vip = 
				{
					150395621,
					254474472,
					282375424,
					119742951
				}
				
				for _,vip_modifier in pairs(vip) do
					if steamID == vip_modifier then
						npc:AddNewModifier( npc, nil, "modifier_vip", {duration = -1})
					end
				end
				
				--Arcana for Nevermore
				
					if IsUnlockedInPass(playerID, "reward15") then
						if npc:GetUnitName() == "npc_dota_hero_nevermore" then
							npc:AddNewModifier( npc, nil, "modifier_never_arcana", {duration = -1})
						end
					end
				
				--Sponsor
				
				if steamID == 196803465 or steamID == 58977934 then
					npc:AddNewModifier( npc, nil, "modifier_sponsor", {duration = -1})				
				end
			end
		end
	local Abilitylevels = 
	{
		"Ayano_Mischief",
		"pudge_flesh_heap",
		"lycan_howl",
		"Knuckles_Cluck",
		"Ranger_Jump",
		"game_start",
		"edward_bil_prank",
		"Rikardo_Fire",
	}
	
	for _,Abilitylevels in pairs(Abilitylevels) do
	   	local FastAbility = npc:FindAbilityByName(Abilitylevels)
		
	   	if npc:IsRealHero() then
	      	if FastAbility then
	        	FastAbility:SetLevel(1)
	      	end
	    end
	end
end

function COverthrowGameMode:OnHeroInGame(hero)
	local playerID = hero:GetPlayerID()
	local npcName = hero:GetUnitName()
		if IsUnlockedInPass(playerID, "reward15") then
			if hero:GetUnitName() == "npc_dota_hero_nevermore" then
				local DefaultSkills = {"never_stupid","never_spit","never_speed","generic_hidden","generic_hidden","Never_ultimate"}
				local ArcanaSkills = {"never_stupid_arcana","never_spit_arcana","never_speed_arcana","generic_hidden","generic_hidden","Never_ultimate_arcana"}
				for default=1,6 do
					hero:RemoveAbility(DefaultSkills[default])
				end
				for arcana=1,6 do
					hero:AddAbility(ArcanaSkills[arcana])
				end
			end
			if npcName == "npc_dota_hero_nevermore" then
				if hero ~= nil and hero:IsHero() then
					local children = hero:GetChildren();
					for k,child in pairs(children) do
						if child:GetClassname() == "dota_item_wearable" and child:GetModelName() ~= "models/heroes/shadow_fiend/shadow_fiend_head.vmdl" then
							child:RemoveSelf();
						end
					end
				end
				hero:SetOriginalModel("models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl")
				local NevermoreWings = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/shadow_fiend/arcana_wings.vmdl"})
				NevermoreWings:FollowEntity(hero, true)
				local NevermorePauldrons = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/nevermore/ferrum_chiroptera_shoulder/ferrum_chiroptera_shoulder.vmdl"})
				NevermorePauldrons:FollowEntity(hero, true)
				local NevermoreHead = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/shadow_fiend/head_arcana.vmdl"})
				NevermoreHead:FollowEntity(hero, true)
				local NevermoreArms = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/shadow_fiend/arms_deso/arms_deso.vmdl"})
				NevermoreArms:FollowEntity(hero, true)
				local NevermoreRocks = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/shadow_fiend/fx_rocks.vmdl"})
				NevermoreRocks:FollowEntity(hero, true)
			end
		end
	
	--Immortal Model for versuta
	if IsUnlockedInPass(playerID, "reward30") then
		if hero:GetUnitName() == "npc_dota_hero_lycan" then
			if hero ~= nil and hero:IsHero() then
				local children = hero:GetChildren();
				for k,child in pairs(children) do
					if child:GetClassname() == "dota_item_wearable" then
						child:RemoveSelf();
					end
				end
			end
			hero:SetOriginalModel("models/creeps/knoll_1/werewolf_boss.vmdl")
			hero:SetModelScale(1.4)
		end
	end
	
	if IsUnlockedInPass(playerID, "reward45") then
		if hero:GetUnitName() == "npc_dota_hero_ogre_magi" then
			if hero ~= nil and hero:IsHero() then
				local children = hero:GetChildren();
				for k,child in pairs(children) do
					if child:GetClassname() == "dota_item_wearable" then
						child:RemoveSelf();
					end
				end
			end
			hero:SetOriginalModel("models/creeps/ogre_1/boss_ogre.vmdl")
			hero:SetModelScale(1.3)
		end
	end
	
	if npcName == "npc_dota_hero_invoker" then
		if hero ~= nil and hero:IsHero() then
			local children = hero:GetChildren();
			for k,child in pairs(children) do
				if child:GetClassname() == "dota_item_wearable" and child:GetModelName() ~= "models/heroes/invoker/invoker_head.vmdl"then
						child:RemoveSelf();
				end
			end
		end
		
		local InvokerBelt = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/dark_artistry/dark_artistry_belt_model.vmdl"})
		InvokerBelt:FollowEntity(hero, true)
		local InvokerBracer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/dark_artistry/dark_artistry_bracer_model.vmdl"})
		InvokerBracer:FollowEntity(hero, true)
		local InvokerCape = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/dark_artistry/dark_artistry_cape_model.vmdl"})
		InvokerCape:FollowEntity(hero, true)
		local InvokerShoulder = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/dark_artistry/dark_artistry_shoulder_model.vmdl"})
		InvokerShoulder:FollowEntity(hero, true)
	end
	if npcName == "npc_dota_hero_beastmaster" then
		local KamaShoulder = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/beastmaster/chimeras_anger_shoulder/chimeras_anger_shoulder.vmdl"})
		KamaShoulder:FollowEntity(hero, true)
		local KamaHead = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/beastmaster/red_talon_head/red_talon_head.vmdl"})
		KamaHead:FollowEntity(hero, true)
	end
	if npcName == "npc_dota_hero_antimage" then
		local AmHead = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/antimage/god_eater_head/god_eater_head.vmdl"})
		AmHead:FollowEntity(hero, true)
	end
	if npcName == "npc_dota_hero_earthshaker" then
		local GladTotem = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/earthshaker/eges_totem/eges_totem.vmdl"})
		GladTotem:FollowEntity(hero, true)
		local GladHead = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/earthshaker/shatterhorn_head/shatterhorn_head.vmdl"})
		GladHead:FollowEntity(hero, true)
	end
	if npcName == "npc_dota_hero_bounty_hunter" then
		local BountyArmor = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/bounty_hunter/gold_ripperbounty_hunter_armor/gold_ripperbounty_hunter_armor.vmdl"})
		BountyArmor:FollowEntity(hero, true)
		local BountyHead = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/bounty_hunter/hunternoname_head/hunternoname_head.vmdl"})
		BountyHead:FollowEntity(hero, true)
		local BountyGold = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/bounty_hunter/ti6_hunters_hoard/mesh/ti6_hunters_hoard_model.vmdl"})
		BountyGold:FollowEntity(hero, true)
		local BountyOffhand = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/bounty_hunter/twinblades_offhand/twinblades_offhand.vmdl"})
		BountyOffhand:FollowEntity(hero, true)
	end
	if npcName == "npc_dota_hero_pudge" then
		local PudgeHook = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/pudge/pudge_skeleton_hook.vmdl"})
		PudgeHook:FollowEntity(hero, true)
		local PudgeHand = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/pudge/immortal_arm/immortal_arm.vmdl"})
		PudgeHand:FollowEntity(hero, true)
		local PudgeOffHand = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/pudge/war_path_off_hand/war_path_off_hand.vmdl"})
		PudgeOffHand:FollowEntity(hero, true)
		local PudgeArcana = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/pudge/arcana/pudge_arcana_back.vmdl"})
		PudgeArcana:FollowEntity(hero, true)
		local PudgeHead = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/pudge/doomsday_ripper_head/doomsday_ripper_head.vmdl"})
		PudgeHead:FollowEntity(hero, true)
	end
	if npcName == "npc_dota_hero_abaddon" then
		local WeaponMeepo = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/ti8_meepo_pitmouse_fraternity_weapon/ti8_meepo_pitmouse_fraternity_weapon.vmdl"})
		WeaponMeepo:FollowEntity(hero, true)
	end
end
	
function COverthrowGameMode:ExecuteOrderFilter( filterTable )
	--[[
	for k, v in pairs( filterTable ) do
		print("EO: " .. k .. " " .. tostring(v) )
	end
	]]

	local orderType = filterTable["order_type"]
	if ( orderType ~= DOTA_UNIT_ORDER_PICKUP_ITEM or filterTable["issuer_player_id_const"] == -1 ) then
		return true
	else
		local item = EntIndexToHScript( filterTable["entindex_target"] )
		if item == nil then
			return true
		end
		local pickedItem = item:GetContainedItem()
		--print(pickedItem:GetAbilityName())
		if pickedItem == nil then
			return true
		end
		if pickedItem:GetAbilityName() == "item_treasure_chest" then
			local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
			local hero = player:GetAssignedHero()
			if hero:GetNumItemsInInventory() < 9 then
				--print("inventory has space")
				return true
			else
				--print("Moving to target instead")
				local position = item:GetAbsOrigin()
				filterTable["position_x"] = position.x
				filterTable["position_y"] = position.y
				filterTable["position_z"] = position.z
				filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION
				return true
			end
		end
	end
	return true
end
