if ChatListener == nil then
	print ( '[ChatListener] created ChatListener' )
	ChatListener = {}
	ChatListener.__index = ChatListener
end

require("commands/commands")
require("commands/cheats")

function ChatListener:OnPlayerChat(keys)
	local player_id = keys.playerid
	local player = PlayerResource:GetPlayer(keys.playerid)
	local text = keys.text

	local args = {}

	for i in string.gmatch(text, "%S+") do -- split string
		table.insert(args, i)
		print ( 'cheats1' )
	end

	local command = args[1]
	table.remove(args, 1)
	print ( 'cheats3' )

	local fixed_command = command.sub(command, 2)

	if Commands[fixed_command] then
		Commands[fixed_command](Commands, player, args)
		print ( 'cheats2' )
	end 
end