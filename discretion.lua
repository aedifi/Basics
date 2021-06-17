-- discretion.lua
-- Implements the /discretion command and spy execution.

WatchingList = {}

function HandleDiscretionCommand(Split, Player)
	if Split[2] == "watching" then
		-- If somebody is watching, add their unique identifier to that list.
		WatchingList[Player:GetUUID()] = true
		Player:SendMessage(cChatColor.LightGray .. "Set your discretion to watching.")
	elseif Split[2] == "ignoring" then
		-- If they switch to ignoring, remove their unique identifier.
		WatchingList[Player:GetUUID()] = nil
		Player:SendMessage(cChatColor.LightGray .. "Set your discretion to ignoring.")		
	else
		Player:SendMessage(cChatColor.LightGray .. "Usage: " .. Split[1] .. " <watching | ignoring>")
	end
	return true
end

function OnExecuteCommand(Player, CommandSplit, EntireCommand)
	local DisplayCommand = function(OtherPlayer)
		if WatchingList[OtherPlayer:GetUUID()] ~= nil then
			if Player then
				if WatchingList[Player:GetUUID()] == nil then
					OtherPlayer:SendMessage(cChatColor.LightGray .. Player:GetName() .. " executed this command: " .. EntireCommand)
                end
			-- If a player didn't execute the command...
			else
				OtherPlayer:SendMessage(cChatColor.LightGray .. "An instance executed this command: " .. EntireCommand)
			end
		end
	end
	cRoot:Get():ForEachPlayer(DisplayCommand)
end