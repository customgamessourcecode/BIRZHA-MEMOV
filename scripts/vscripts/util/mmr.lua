BirzhaMmr = class({}) or BirzhaMmr

function BirzhaMmr:IsMmrMap()
if IsInToolsMode() then
return true
end
if not GameRules:IsCheatMode() then
return true
end
return nil
end

function BirzhaMmr:GetMmrData()
RequestData("http://bmemov.ru/api/mmr.json", function(data) self:AddPlayersMmr(data) end)
end

function ClearjsonData(data)
local data = {
data = {
players = {
{mmr = "3420", steamid = "106096878"},
{mmr = "100", steamid = "307325307"},
{mmr = "2320", steamid = "216210038"},
{mmr = "1", steamid = "164854966"},
{mmr = "10", steamid = "264646604"}
}
}
}
SendData("http://bmemov.ru/api/mmr.php", data, nil)
end

function BirzhaMmr:AddPlayersMmr(data)
local playersdata = data.data.players
if playersdata == nil then return end
 print("Mmr Founded")
for playerid = 0, PlayerResource:GetPlayerCount() - 1 do
local steamid = PlayerResource:GetSteamAccountID(playerid)

   for count = 1, #playersdata do
    if steamid == tonumber(playersdata[count].steamid) then
     local mmr = tonumber(playersdata[count].mmr)
     CustomNetTables:SetTableValue("birzha_mmr", tostring(playerid), {mmr = mmr, json_count = count})

    end

   end
end
print(" stranger mmr",CustomNetTables:GetTableValue("birzha_mmr", "0" ).mmr)
Timers:CreateTimer(3, function()
	self:TopMMR(data)
	CustomGameEventManager:Send_ServerToAllClients( "birzha_tophud_show_mmr", {players_count = PlayerResource:GetPlayerCount() } )
end)
end

function BirzhaMmr:EndGame(data)
print("geroi")
if PlayerResource:GetPlayerCount() < 9 then return end
print("geroimnogo")
for playerid = 0, PlayerResource:GetPlayerCount() - 1 do
 local table = CustomNetTables:GetTableValue("birzha_mmr", tostring(playerid))
 if table ~= nil then
 print("opa mmr")
 data.data.players[table.json_count].mmr = tostring(self:GetPlusMMr(playerid, table.mmr))
 elseif table == nil and PlayerResource:GetConnectionState(playerid) ~= 1 then
 local new_count = #data.data.players + 1
 data.data.players[new_count] = {}
 data.data.players[new_count].mmr = tostring(GetNewMmr(playerid))
 data.data.players[new_count].steamid = tostring(PlayerResource:GetSteamAccountID(playerid))
 end

end

SendData("http://bmemov.ru/api/mmr.php", data, nil)
end

function BirzhaMmr:TopMMR(data)
local playerdata = data.data.players
local topmmr = {}
local bpxp =  CustomNetTables:GetTableValue("birzha_mmr", "bp_xp")

	for i = 1, 10 do
		local max = tonumber(playerdata[1].mmr)
		local max_count = 1
		local max_steamid = playerdata[1].steamid
		local max_xpbp = bpxp[max_steamid]
		print("Playerdata count:", #playerdata)
		for j = 2, #playerdata do
		if tonumber(playerdata[j].mmr) > max then
		max = tonumber(playerdata[j].mmr)
		max_count = j
		max_steamid = playerdata[j].steamid
		max_xpbp = bpxp[max_steamid]
		end
		end
		local info = { mmr = max, steamid = max_steamid,}
		info.bp = max_xpbp
		table.insert(topmmr, info)
		table.remove(playerdata, max_count)
	end
	print("TopMMr:")
	PrintTable(topmmr)
	CustomNetTables:SetTableValue("birzha_mmr", "topmmr", topmmr)
end

function BirzhaMmr:GetPlusMMr(id, mmrf)
local mmr = 0 
local win_team = CustomNetTables:GetTableValue("birzha_mmr", "game_winner").t
local lose_team = CustomNetTables:GetTableValue("birzha_mmr", "game_lose").l
print("Wint Team: ", win_team)
print("Lose Team: ", lose_team)
print("Player team: ", PlayerResource:GetTeam(id) )
	if PlayerResource:GetTeam(id) == win_team then
    mmr = 25
	elseif PlayerResource:GetTeam(id) == lose_team then
	mmr = -25
	end
	if IsUnlockedInPass(id, "reward100") then
	mmr = mmr * 2
    end	
	if mmr + mmrf < 0 then return 0 end
	print("newmmr", mmr + mmrf)
	return mmr + mmrf
end

function GetNewMmr(id)
local mmr = 0
local win_team = CustomNetTables:GetTableValue("birzha_mmr", "game_winner").t
	if PlayerResource:GetTeam(id) == win_team then
	mmr = 25
	end
   if IsUnlockedInPass(id, "reward100") then
	return mmr * 2
   end	
   return mmr
end