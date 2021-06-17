-- players.lua
-- Implements the /players command.

function HandleConsolePlayers(Split, Player)
	local PlayerTable = {}

	-- Collect and tabulate online players.
	local ForEachPlayer = function(a_Player)
		table.insert(PlayerTable, a_Player:GetName())
	end
	cRoot:Get():ForEachPlayer(ForEachPlayer)
	table.sort(PlayerTable)

	-- Format this table.
	LOG("Players (" .. #PlayerTable .. "): " .. table.concat(PlayerTable, ", "))
	return true
end

function HandlePlayersCommand(Split, Player)
	local PlayerTable = {}

	-- Collect and tabulate online players.
	local ForEachPlayer = function(a_Player)
		table.insert(PlayerTable, a_Player:GetName())
	end
	cRoot:Get():ForEachPlayer(ForEachPlayer)
	table.sort(PlayerTable)

	-- Format this table in a message.
	Player:SendMessage(cChatColor.LightGray .. "Players (" .. #PlayerTable .. "): " .. table.concat(PlayerTable, ", "))
	return true
end
