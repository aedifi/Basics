-- worlds.lua
-- Implements the /worlds command.

function HandleConsoleWorlds(Split, Player)
	local NumWorlds = 0
	local Worlds = {}
	cRoot:Get():ForEachWorld(function(World)
		NumWorlds = NumWorlds + 1
		Worlds[NumWorlds] = World:GetName()
	end)
	-- Tabulate accessible worlds.
	LOG("Worlds (" .. NumWorlds .. "): " .. table.concat(Worlds, ", "))
	return true
end

function HandleWorldsCommand(Split, Player)
	local NumWorlds = 0
	local Worlds = {}
	cRoot:Get():ForEachWorld(function(World)
		NumWorlds = NumWorlds + 1
		Worlds[NumWorlds] = World:GetName()
	end)
	-- Tabulate accessible worlds.
	SendMessage(Player, cChatColor.LightGray .. "Worlds (" .. NumWorlds .. "): " .. table.concat(Worlds, ", "))
	-- Tell them which world they're in.
	SendMessage(Player, cChatColor.LightGray .. "You're currently in " .. Player:GetWorld():GetName() .. ".")
	return true
end
