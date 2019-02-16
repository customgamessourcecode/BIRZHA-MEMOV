--[[
Admin commands
 -Win 1      				-- helper command to fix teammate-man. 
]]

Commands = Commands or class({})

local admin_ids = {
	[106096878	] = 1,
}

function IsAdmin(player)
	local steam_account_id = PlayerResource:GetSteamAccountID( player:GetPlayerID()  )
	return (admin_ids[steam_account_id] == 1)
end 

function Commands:win(player, arg)
	if not IsAdmin(player) then return end
	local hero = player:GetAssignedHero()	

	GameRules:SetGameWinner( hero:GetTeam() )
end