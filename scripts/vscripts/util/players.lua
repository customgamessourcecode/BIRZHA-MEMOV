--
function LoadPlayersDataFromServer() RequestData("http://bmemov.ru/api/compendium.json", function(data) DataLoaded(data) end) end
--
function DataLoaded(data)
local playersdata = data.data.players 
if playersdata == nil then print("[Birzha Request] Этой таблиицы нету в json, так что нету инфы, нету компеда roflanebalo") AddEmptyData() end
AddSteamIdInfo(data)
  for playerid = 0, PlayerResource:GetPlayerCount() - 1 do
  
     local steamid = PlayerResource:GetSteamAccountID(playerid)
  
      for count = 1, #playersdata do
	     if steamid == tonumber(playersdata[count].steamid) then
	     print("[BirzhaPass] Игрок с id" ..playerid.. "имеет пропуск")
		 if is_donater == nil then
			is_donater = true
         end
	     local birzhapass_xp = tonumber(playersdata[count].xp)
	     local birzhapass_lvl = GetLvlByXP(birzhapass_xp)
	     local json_table_count = count
	     CustomNetTables:SetTableValue("birzhainfo", tostring(playerid), {
	     -- Опыт в Пропуска
	      xp = birzhapass_xp,
	     -- Уровень в Пропуска
	     lvl = birzhapass_lvl,
	     -- Требуется для отправки опыта в конце
	     json_table_count = json_table_count,
		 --Проверка на наличия Пропуска
		 has_bp = true,
	     --Просто СтимИд
	     steamid = steamid,
	  })
	  end
	  end
  
  
  end
--Это понадабится для игроков у которых нет пропуска (бомжи), чтобы проверка была легче  
Timers:CreateTimer(3, function()
AddEmptyData()
CustomGameEventManager:Send_ServerToAllClients( "birzha_tophud_show_level", {players_count = PlayerResource:GetPlayerCount() } )
end)
end

function AddEmptyData()
    for playerid = 0, PlayerResource:GetPlayerCount() - 1 do
     if CustomNetTables:GetTableValue("birzhainfo", tostring(playerid)) == nil then
	 CustomNetTables:SetTableValue("birzhainfo", tostring(playerid), {
	      xp = 0,
	     lvl = 0,
	     json_table_count = nil,
		 has_bp = false,
	     steamid = PlayerResource:GetSteamAccountID(playerid),
	  })
	 end
    end
end

function AddSteamIdInfo(data)
    local pd = data.data.players
    local d = {}
        for i = 1, #pd do
        d[pd[i].steamid] = pd[i].xp
        end
    CustomNetTables:SetTableValue("birzha_mmr", "bp_xp", d)
end





function ChangeData(data)
local playersdata = data.data.players
if playersdata == nil then print("[Birzha Request] Этой таблиицы нету в json, так что нету и отравки roflanpominki") return end
if is_donater == nil then print("no player") return end
for playerid = 0, PlayerResource:GetPlayerCount() - 1 do

      local table = CustomNetTables:GetTableValue("birzhainfo", tostring(playerid))
      
      if table ~= nil and table.json_table_count ~= nil then
		data.data.players[table.json_table_count].xp = tostring(tonumber(data.data.players[table.json_table_count].xp) + RandomInt(100, 200))
      else
      print("Земля тебе пухом дебил ебаный нищеброд лох чмо сиськастый цветочный")
      end

     
     
end     
SendData("http://bmemov.ru/api/compendium.php", data, nil)  
end