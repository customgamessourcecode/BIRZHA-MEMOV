TopHud  = class({})

function TopHud:Init()
local ots = 0
local team_t = self:GetNETEmasCount()
print("Length: ", #team_t)
	for team = 2, 14 do
		if team_t[team] ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("birzha_top_hood_create_panels", {team = team, players = team_t[team], pl_count = #team_t[team], team_color = COverthrowGameMode.m_TeamColors[team], ots = ots})
		ots = ots + (#team_t[team] * 86) + 50
		end
	end
end


function TopHud:GetNETEmasCount()
local teams_info = {}
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
		local team = PlayerResource:GetTeam(i)
		if teams_info[team] == nil then teams_info[team] = {} end
 		table.insert(teams_info[team], i)
		end
		print("Team Info:")
		PrintTable(teams_info)		
		return teams_info
end