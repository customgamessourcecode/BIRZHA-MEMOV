--[[
Cheat lobby commands
 -defaultplayer     	-- RemoveEffects.
 -lakadmatatag     	-- LAKAAAAD MATATAG NORMALIN NORMALIN.
]]

Commands = Commands or class({})

function Commands:is_cheats( player, arg )
	if GameRules:IsCheatMode() then print ( 'cheats is enabled' ) else print ( 'cheats is disabled' ) end
end 

function Commands:defaultplayer(player, arg)
	local hero = player:GetAssignedHero() 

	hero:RemoveModifierByName("modifier_admin")
	hero:RemoveModifierByName("modifier_vip")
	hero:RemoveModifierByName("modifier_gob")
	hero:RemoveModifierByName("modifier_sponsor")
	print ( 'modifier is deleted' )
end

function Commands:lakadmatatag(player, arg)
	EmitGlobalSound("soundboard.ta_daaaa")
end  