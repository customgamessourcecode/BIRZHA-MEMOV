--[[
Author: uBluewolfu
Special For Birzha Memov.	
© Copyright 2018. All Right Reserved. The BirzhaMemov Development Team. 
Custom Pick.
-]]
LinkLuaModifier( "modifier_start_game_hero_pick", "modifiers/modifier_start_game_hero_pick", LUA_MODIFIER_MOTION_NONE )
PICK_MODE_STATE = "Standart"
IS_PLAYER_SELECT = {} 
ENABLE_BAN = {}
IS_BANNED = {}
LOSE_GOLD = {}
IS_CM_STATE_USED = {}
PICK_BANNED_HEROES = {}
CM_PICKED_HEROES = {}
for i=2,3 do CM_PICKED_HEROES[i] = {} end
BIRZHA_PICK_STATE_VOTING = "BIRZHA_PICK_STATE_VOTING"
BIRZHA_PICK_STATE_BAN = "BIRZHA_PICK_STATE_BAN"
BIRZHA_PICK_STATE_SELECT = "BIRZHA_PICK_STATE_SELECT"
BIRZHA_PICK_STATE_PRE_END = "BIRZHA_PICK_STATE_PRE_END"
BIRZHA_PICK_STATE_END = "BIRZHA_PICK_STATE_END"
BIRZHA_PICK_STATE_START_CM = "BIRZHA_PICK_STATE_START_CM"
BIRZHA_PICK_STATE_CM_SELECT = "BIRZHA_PICK_STATE_CM_SELECT"
BIRZHA_PICK_STATE_CM_END = "BIRZHA_PICK_STATE_CM_END"
PICK_STATE_STATUS = {}
VOTING_STATUS = {}
--All PICK
PICK_STATE_STATUS[1] = BIRZHA_PICK_STATE_VOTING
PICK_STATE_STATUS[2] = BIRZHA_PICK_STATE_BAN
PICK_STATE_STATUS[3] = BIRZHA_PICK_STATE_SELECT
PICK_STATE_STATUS[4] = BIRZHA_PICK_STATE_PRE_END
PICK_STATE_STATUS[5] = BIRZHA_PICK_STATE_END

--Captains Mode
PICK_STATE_STATUS[6] = BIRZHA_PICK_STATE_START_CM
PICK_STATE_STATUS[7] = BIRZHA_PICK_STATE_CM_SELECT
PICK_STATE_STATUS[8] = BIRZHA_PICK_STATE_CM_END

TIME_OF_STATE = {}

TIME_OF_STATE[1] = 20
TIME_OF_STATE[2] = 20
TIME_OF_STATE[3] = 50
TIME_OF_STATE[4] = 20
TIME_OF_STATE[5] = 999
TIME_OF_STATE[6] = 9999
TIME_OF_STATE[7] = 60
TIME_OF_STATE[8] = 999

if IsInToolsMode() then
	TIME_OF_STATE[2] = 5
	TIME_OF_STATE[1] = 5
end
CustomPick = class({})
require('util/cm_state')
function CustomPick:Init()
self.TIMER_COUNT = 10
--birzha_pick_mode_voting
CustomGameEventManager:RegisterListener( "birzha_pick_select_hero", Dynamic_Wrap(self, "SelectHero"))
CustomGameEventManager:RegisterListener( "birzha_pick_mode_voting", Dynamic_Wrap(self, "ModeVote"))
CustomGameEventManager:RegisterListener( "birzha_pick_select_cm_hero", Dynamic_Wrap(self, "SelectCmHero"))
local enable_heroes = {}
local str_heroes = {}
local ag_heroes = {}
local int_heroes = {}
local anime = {}
CustomNetTables:SetTableValue("birzha_pick", "heroes_ability", {})
local heroes = LoadKeyValues("scripts/npc/activelist.txt")
for k,v in pairs(heroes) do
	if v == 1 then
	table.insert(enable_heroes, k)
	end
end
print("LOl Heroes;")
PrintTable(enable_heroes)
local h = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
local all = {}
	for c = 1, #enable_heroes do
		local inf = h[enable_heroes[c]]
		local ability = {}
		if inf then
			for ab = 1, 9 do
				if inf["Ability" ..ab] ~= nil and inf["Ability"..ab] ~= "" and inf["Ability"..ab] ~= "generic_hidden" then
				table.insert(ability, inf["Ability"..ab])
				end
			end
			print(enable_heroes[c]," ability:")
			PrintTable(ability)
			CustomNetTables:SetTableValue("birzha_pick", tostring(enable_heroes[c]), ability)
		end
	end
self.enables_heroes = enable_heroes
for _,hero in pairs(enable_heroes) do
	if h[hero].AttributePrimary == "DOTA_ATTRIBUTE_AGILITY" then
	table.insert(ag_heroes, hero)
	elseif h[hero].AttributePrimary == "DOTA_ATTRIBUTE_STRENGTH" then
	table.insert(str_heroes, hero)
	elseif h[hero].AttributePrimary == "DOTA_ATTRIBUTE_INTELLECT" then
	table.insert(int_heroes, hero)
	end
	
		if h[hero].IsAnime == 1 then
		table.insert(anime, hero)
		end
	end
print("Agility Heroes:")
PrintTable(ag_heroes)
print("Anime Heroes:")
PrintTable(anime)

CustomNetTables:SetTableValue("birzha_pick", "hero_list", {str = str_heroes, ag = ag_heroes, int = int_heroes, str_length = #str_heroes, ag_length = #ag_heroes, int_length = #int_heroes, anime = anime, animelg = #anime})
end

function CustomPick:OnThink()
--All Pick
if PICK_MODE_STATE == "Standart" then
CheckPlayerHeroes()
	if self:GetPickState() == BIRZHA_PICK_STATE_PRE_END then
	self:GiveLoseGold()
	end

self.TIMER_COUNT = self.TIMER_COUNT - 1
	if self.TIMER_COUNT <= 0 then
	self:ChangePickState(self.PICK_STATE_COUNT + 1)
	end

CustomGameEventManager:Send_ServerToAllClients( "birzha_pick_change_timer", {time = self.TIMER_COUNT} )
end
--Captaints Mode
	if PICK_MODE_STATE == "CM" then
	self.CM_TIMER_COUNT = self.CM_TIMER_COUNT - 1
		if self.CM_TIMER_COUNT <= 0 then
		CustomPick:OnCmStateEnd()
		self:SetCMstate(self.CM_STATE_COUNT + 1)
		end
		CustomGameEventManager:Send_ServerToAllClients( "birzha_pick_change_timer", {time = self.CM_TIMER_COUNT} )
	end
end

function CheckPlayerHeroes()
if PICK_MODE_STATE == 'CM' then return end
if CustomPick:GetPickState() == BIRZHA_PICK_STATE_END then return end
for p = 0, PlayerResource:GetPlayerCount() - 1 do
	if IS_PLAYER_SELECT[p] == nil then
	return 
	end
end
CustomPick:ChangePickState(5)
end

function CustomPick:StartPick() 
	for c = 0, 6 do
	GameRules:GetGameModeEntity():SetHUDVisible(c, false)
	end  

end

function CustomPick:ModeVote(ev)
	if VOTING_STATUS[ev.PlayerID] == nil then
		VOTING_STATUS[ev.PlayerID] = ev.mode
		CustomGameEventManager:Send_ServerToAllClients("change_flow_avatar_voting", {id = ev.PlayerID, mode = ev.mode})
	end
end

function CustomPick:GiveLoseGold()
	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		if IS_PLAYER_SELECT[i] == nil then
			LOSE_GOLD[i] = LOSE_GOLD[i] + 2
			CustomGameEventManager:Send_ServerToAllClients("birzha_top_hood_tick", {player = i})
		end
	end
end


function CustomPick:SelectHero(ev)
if CustomPick:GetPickState() == BIRZHA_PICK_STATE_CM_SELECT then
	return 
end
if PICK_MODE_STATE == "Standart" then
if CustomPick:GetPickState() == BIRZHA_PICK_STATE_BAN then
	if ENABLE_BAN[ev.PlayerID] == nil and IS_BANNED[ev.hero] == nil then
	IS_BANNED[ev.hero] = true
	table.insert(PICK_BANNED_HEROES, ev.hero)
	CustomNetTables:SetTableValue("birzha_pick", "banned_heroes", PICK_BANNED_HEROES)
	CustomGameEventManager:Send_ServerToAllClients("birzha_pick_ban_hero", {hero = ev.hero})
	ENABLE_BAN[ev.PlayerID] = true
	end
	return
end
if IsBannedHero(ev.hero) or IS_PLAYER_SELECT[ev.PlayerID] == true then return end
CustomGameEventManager:Send_ServerToAllClients("birzha_top_hood_change_portrait", {PID = ev.PlayerID, hero = ev.hero})
CustomPick:GiveHeroPlayer(ev.PlayerID, ev.hero, true)
end
--All Pick
if PICK_MODE_STATE == "CM" then
	if CustomPick.CM_STATE_CH == "BAN" then
		if not CustomPick:IsCpID(ev.PlayerID) or IS_CM_STATE_USED[CustomPick.CM_STATE_COUNT] == true then return end
		if IS_BANNED[ev.hero] == nil then
		 IS_BANNED[ev.hero] = true
		IS_CM_STATE_USED[CustomPick.CM_STATE_COUNT] = true
		 table.insert(PICK_BANNED_HEROES, ev.hero)
		 CustomGameEventManager:Send_ServerToAllClients("birzha_pick_ban_hero", {hero = ev.hero})
		 CustomGameEventManager:Send_ServerToAllClients("birzha_pick_cm_panel_image", {hero = ev.hero, state = CustomPick.CM_STATE_CH, container = CustomPick.CM_CONT})
		 CustomPick.CM_TIMER_COUNT = 1
		end
	end
	
	if CustomPick.CM_STATE_CH == "PICK" then
		if not CustomPick:IsCpID(ev.PlayerID) or IS_CM_STATE_USED[CustomPick.CM_STATE_COUNT] == true then return end
		 if IS_BANNED[ev.hero] == nil then
		 IS_BANNED[ev.hero] = true
		 CM_PICKED_HEROES[CustomPick.TEAM_STEP][ev.hero] = true 
		 IS_CM_STATE_USED[CustomPick.CM_STATE_COUNT] = true
		 CustomGameEventManager:Send_ServerToAllClients("birzha_pick_cm_panel_image", {hero = ev.hero, state = CustomPick.CM_STATE_CH, container = CustomPick.CM_CONT})
		 CustomGameEventManager:Send_ServerToTeam(CustomPick.TEAM_STEP, "birzha_pick_cm_button_setup", {container = CustomPick.CM_CONT, hero = ev.hero})
		 CustomPick.CM_TIMER_COUNT = 1
		 end
	end
end
end



function CustomPick:IsCpID(id)
local table = CustomNetTables:GetTableValue("birzha_cm", "captains")
	if table then
	PrintTable(table)
	local cp = table[tostring(self.TEAM_STEP)].id
	print("Cp test: ", cp)
	print("Local test: ", id)
	return tonumber(id) == cp
	end
end


function CustomPick:IsAvailable(id)
local team = TopHud:GetNETEmasCount()
local av_id = team[self.TEAM_STEP][self.PLAYER_SELECT]
return av_id == id
end

function CustomPick:GiveHeroPlayer(id,hero, iscm)
table.insert(PICK_BANNED_HEROES, hero)
if cm == false then
CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(id), "birzha_pick_hide_heroes_panel", {} )
end
IS_PLAYER_SELECT[id] = true
PlayerResource:ReplaceHeroWith(id, hero, 0, 0)
local new_hero = PlayerResource:GetPlayer(id):GetAssignedHero()
new_hero:AddNewModifier( new_hero, nil, "modifier_start_game_hero_pick", {})
end

function CustomPick:ChangePickState(state)
self.PICK_STATE_COUNT = state
self.PICK_STATE = PICK_STATE_STATUS[self.PICK_STATE_COUNT]
self:OnChangedPickState()
CustomGameEventManager:Send_ServerToAllClients("birzha_pick_state_change", {state = self.PICK_STATE})
end


function CustomPick:OnChangedPickState()
self.TIMER_COUNT = TIME_OF_STATE[self.PICK_STATE_COUNT]
if self:GetPickState() == BIRZHA_PICK_STATE_VOTING then
Timers:CreateTimer( 1,function()
TopHud:Init()
self:CreateVotePanels()
if not NidingCM() then self:ChangePickState(2) return end
CustomGameEventManager:Send_ServerToAllClients("birzha_pick_voting_for_game", {})
end
)
end

if self:GetPickState() == BIRZHA_PICK_STATE_BAN then
self:GetVoteWinner()
CustomGameEventManager:Send_ServerToAllClients("birzha_pick_voting_end", {})
end
if self:GetPickState() == BIRZHA_PICK_STATE_SELECT then
CustomGameEventManager:Send_ServerToAllClients("birzha_pick_ban_start", {value = true})
GetFiltBannedHero()
for i = 0, PlayerResource:GetPlayerCount() - 1 do 
LOSE_GOLD[i] = 0 
end
elseif self:GetPickState() == BIRZHA_PICK_STATE_END then
GameRules:SetPreGameTime(0)
CustomGameEventManager:Send_ServerToAllClients("birzha_pick_end_pick", {})
	CustomGameEventManager:Send_ServerToAllClients( "birzha_top_hood_change_for_game", {players_count = PlayerResource:GetPlayerCount() } )
	for c = 0, 6 do
	GameRules:GetGameModeEntity():SetHUDVisible(c, true)
	end  
	self:GiveRandomHeroes()
	RemovePickDebuff()
	self:GiveGoldForHeroes()
	pickbirzhaend = true
elseif self:GetPickState() == BIRZHA_PICK_STATE_CM_END then
	self:GiveCmHeroesNoPicked()
	self:ChangePickState(5)
end

end

function RemovePickDebuff()
    for id = 0, PlayerResource:GetPlayerCount() - 1 do
        local player = PlayerResource:GetPlayer(id)
        local hero = player:GetAssignedHero()
            if hero:GetUnitName() == "npc_dota_hero_wisp" then 
                Timers:CreateTimer(1, RemovePickDebuff)
                return nil
            end
    hero:RemoveModifierByName("modifier_start_game_hero_pick")   
	hero:AddNewModifier( hero, nil, "modifier_BirzhaMemov_startgame", {duration = 15})
    end
end

function CustomPick:CreateVotePanels()
local otstup = 0
for i = 0, PlayerResource:GetPlayerCount() - 1 do
CustomGameEventManager:Send_ServerToAllClients("birzha_pick_voting_createpanel", {id = i, ots = otstup})
otstup = otstup + 110
end
end

function CustomPick:GiveGoldForHeroes()
    for i = 0, PlayerResource:GetPlayerCount() - 1 do
    local id = PlayerResource:GetPlayer(i)
    local hero = id:GetAssignedHero()
    hero:ModifyGold(600 - ((LOSE_GOLD[i] or 0) + hero:GetGold()), true, 0)
    end

end

function CustomPick:GiveRandomHeroes() 

for i= 0, PlayerResource:GetPlayerCount() - 1 do
	if IS_PLAYER_SELECT[i] ~= true then
	local hero = self:RandomHeroForPlayer()
	self:GiveHeroPlayer(i, hero)
	CustomGameEventManager:Send_ServerToAllClients("birzha_top_hood_change_portrait", {PID = i, hero = hero})
	end
end

end

function CustomPick:GiveCmHeroesNoPicked()
    for i = 0, PlayerResource:GetPlayerCount() - 1 do
        if IS_PLAYER_SELECT[i] == nil then
        local hero = self:RandomCmHero(i)
        print(hero, " sosat shkila")
		self:GiveHeroPlayer(i, hero, true)
		CM_PICKED_HEROES[PlayerResource:GetTeam(i)][hero] = nil
		CustomGameEventManager:Send_ServerToAllClients("birzha_top_hood_change_portrait", {PID = i, hero = hero})
        end
    
    end

end

function CustomPick:RandomCmHero(id)
local count = 0
local team = PlayerResource:GetTeam(id)
local tb_lenght = #CM_PICKED_HEROES[team]
    if tb_lenght then
        local r = RandomInt(1, tb_lenght)
            for k,v in pairs (CM_PICKED_HEROES[team]) do
                count = count + 1    
                if count == r then
                return k
                end    
            end
    end
end

function CustomPick:RandomHeroForPlayer()
local r = RandomInt(1, #self.enables_heroes)
if IsBannedHero(self.enables_heroes[r]) then return self:RandomHeroForPlayer() end
return self.enables_heroes[r]
end


function CustomPick:GetPickState()
return self.PICK_STATE
end


function IsBannedHero(hn)
PrintTable(PICK_BANNED_HEROES)
	for b = 1, #PICK_BANNED_HEROES do
		if hn == PICK_BANNED_HEROES[b] then
			return true
		end
	end
return false
end

function GetFiltBannedHero()
local c = math.floor(#PICK_BANNED_HEROES / 2)
PrintTable(PICK_BANNED_HEROES)
for i = 1, c do
table.remove(PICK_BANNED_HEROES, math.random(1, #PICK_BANNED_HEROES))
end
print("C")
CustomGameEventManager:Send_ServerToAllClients("birzha_pick_hide_banned_panel", {})
CustomGameEventManager:Send_ServerToAllClients("birzha_pick_show_filt_banned_panel", {heroes = PICK_BANNED_HEROES, length = #PICK_BANNED_HEROES})
end


function CustomPick:GetVoteWinner()
if not NidingCM() then return end
local mode = {"cm", "standart"}
local cm_points = GetValueCount(VOTING_STATUS, "cm")
local standart_points = GetValueCount(VOTING_STATUS, "standart")
if standart_points > cm_points then
print("Pick Mode is All Pick")
	elseif cm_points > standart_points then
print("Pick Mode is CM")	
self:SetupCmMode()
	elseif cm_points == standart_points then
print("Vi kto takie idite nahui")
if RandomInt(1,2) == 1 then self:SetupCmMode() end
end

end


function CustomPick:SetupCmMode()
self:GetTopTeamMmr()
PICK_MODE_STATE = "CM"
CustomGameEventManager:Send_ServerToAllClients("birzha_pick_setup_cm", {})
self:ChangePickState(6)
self:SetCMstate(1)
end

function CustomPick:SetCMstate(state)
local inf = CM_STATE[state]
self.CM_STATE_COUNT = state
	if inf then
		if inf.state == "BAN" then
		self.CM_TIMER_COUNT = inf.time
		self.CM_STATE_CH = "BAN"
		self.TEAM_STEP = inf.team
		self.CM_CONT = inf.count
		end
		if inf.state == "PICK" then
		self.CM_TIMER_COUNT = inf.time
		self.CM_STATE_CH = "PICK"
		self.TEAM_STEP = inf.team
		self.PLAYER_SELECT = inf.player
		self.CM_CONT = inf.count
		end
		self:OnCmStateChange()
	else
		self:ChangePickState(7)
		PICK_MODE_STATE = "Standart"
	end

end


function CustomPick:GetTopTeamMmr()
local player_mmr_info = {}
for i = 0, PlayerResource:GetPlayerCount() - 1     do
table.insert(player_mmr_info, {id = i, mmr = GetPlayerMmr(i) or 0})
end
print("Not Sorted: ")
PrintTable(player_mmr_info)
print("Sorted: ")
local sorted = SortMmrTable(player_mmr_info)
PrintTable(sorted)
local captain = {}
    for i = 2,3 do     
        for _,t in pairs (sorted) do
            if PlayerResource:GetTeam(t.id) == i then
            print("[CustomPick] Player ", t.id, " now captain team ", i)
            captain[i] = {id = t.id, mmr = t.mmr}
            break
            end
            
        end
    end
    local cp_table = {}
    for i = 2,3 do
            if captain[i] then
                if captain[i].mmr == 0 then
                local team_t = TopHud:GetNETEmasCount()[i]
                captain[i].id = team_t[RandomInt(1, #team_t)]
                end    
            end    
        if not captain[i] then
        captain[i] = {}
        captain[i].id = 26
        captain[i].mmr = 0
        end
    end
    PrintTable(captain)
    CustomNetTables:SetTableValue("birzha_cm", "captains", captain)
    for i = 1, 2 do cp_table[i] = captain[i + 1].id end
    CustomGameEventManager:Send_ServerToAllClients("bizrha_tophud_show_captains", cp_table)
	print("captain is", cp_table)
end

function CustomPick:OnCmStateChange()
	CustomGameEventManager:Send_ServerToAllClients("birzha_pick_cm_team_border", {team = self.TEAM_STEP})
	if self.CM_STATE_CH == "BAN" then
	CustomGameEventManager:Send_ServerToAllClients("birzha_pick_cm_ban_start", {team = self.TEAM_STEP, container = self.CM_CONT})
	elseif self.CM_STATE_CH == "PICK" then
	CustomGameEventManager:Send_ServerToAllClients("birzha_pick_cm_select_start", {team = self.TEAM_STEP, container = self.CM_CONT})
	end	

end

function CustomPick:OnCmStateEnd()
	if self.CM_STATE_CH == "BAN" and IS_CM_STATE_USED[self.CM_STATE_COUNT] == nil then
	local hero = self:RandomHeroForPlayer()
	print("banned hero", hero)
	IS_BANNED[hero] = true
		 table.insert(PICK_BANNED_HEROES, hero)
		 CustomGameEventManager:Send_ServerToAllClients("birzha_pick_ban_hero", {hero = hero})
		 CustomGameEventManager:Send_ServerToAllClients("birzha_pick_cm_panel_image", {hero = hero, state = CustomPick.CM_STATE_CH, container = CustomPick.CM_CONT})	
	end
	if self.CM_STATE_CH == "PICK" and IS_CM_STATE_USED[self.CM_STATE_COUNT] == nil then
	IS_CM_STATE_USED[self.CM_STATE_COUNT] = true
	 local hero = self:RandomHeroForPlayer()
	 	 print("banned hero", hero)
	 IS_BANNED[hero] = true
	 	 table.insert(PICK_BANNED_HEROES, hero)
	CM_PICKED_HEROES[CustomPick.TEAM_STEP][hero] = true
		 CustomGameEventManager:Send_ServerToAllClients("birzha_pick_cm_panel_image", {hero = hero, state = CustomPick.CM_STATE_CH, container = CustomPick.CM_CONT})
		CustomGameEventManager:Send_ServerToTeam(CustomPick.TEAM_STEP, "birzha_pick_cm_button_setup", {container = CustomPick.CM_CONT, hero = hero})
		self.CM_TIMER_COUNT = 1
	
	end
end

function CustomPick:SelectCmHero(ev)
if CustomPick:GetPickState() ~= BIRZHA_PICK_STATE_CM_SELECT or IS_PLAYER_SELECT[ev.PlayerID] == true then return end
local team = PlayerResource:GetTeam(ev.PlayerID)
	if CM_PICKED_HEROES[team][ev.hero] then
	CM_PICKED_HEROES[team][ev.hero] = nil
	CustomGameEventManager:Send_ServerToAllClients("birzha_top_hood_change_portrait", {PID = ev.PlayerID, hero = ev.hero})
	CustomPick:GiveHeroPlayer(ev.PlayerID, ev.hero, true)
	end

end

function NidingCM()
if GetMapName() ~= "birzhamemov_5v5" or PlayerResource:GetPlayerCount() > 10 then
return nil
end
return true
end


function GetHeroPickedCM()
local team = TopHud:GetNETEmasCount()
return team[CustomPick.TEAM_STEP][CustomPick.PLAYER_SELECT]
end
