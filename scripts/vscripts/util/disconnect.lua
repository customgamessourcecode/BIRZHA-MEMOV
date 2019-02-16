BirzhaCheck = class({})


function BirzhaCheck:Init()
DISCONNECT_STATUS = {}
	for p = 0,  PlayerResource:GetPlayerCount() - 1 do
	end
end


function BirzhaCheck:AutoWin()
	local winteam = nil
	for team = 2, 14 do
	local player_count = self:GetCNPlayersInTeam(team)
		if player_count > 0 then
		if winteam == nil then
			winteam = team
		else
			print("daite ban")
			return nil
		end
		
		end
	end
print("Win Team: ",winteam )

COverthrowGameMode:EndGame( winteam )
GameRules:SetGameWinner(winteam)	
end


function BirzhaCheck:GetCNPlayersInTeam(t)
local count = 0
	for id = 0, PlayerResource:GetPlayerCount() - 1 do
if PlayerResource:GetTeam(id) == t and not PlayerResource:GetSelectedHeroEntity(id):HasModifier("modifier_disconnect_debuff") then
	count = count + 1
	end
	end
return count
end