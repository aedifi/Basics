-- spy.lua
-- Implements the /spy command and creates a list of staffmembers with the feature enabled.

CommandSpyList = {}

function HandleSpyCommand(Split, Player)
	if Split[2] == "commands" then
		-- Add that player's identifier to the list.
		CommandSpyList[Player:GetUUID()] = true
		Player:SendMessage(cChatColor.LightGray .. "Started spying on players' commands.")
	elseif Split[2] == "stop" then
		-- If they disable the feature, remove their identifier from the list.
		CommandSpyList[Player:GetUUID()] = nil
		Player:SendMessage(cChatColor.LightGray .. "Gave up your role as a spy (or did we?)")		
	else
		Player:SendMessage(cChatColor.LightGray .. "Usage: " .. Split[1] .. " <commands | stop>")
	end
	return true
end

function OnExecuteCommand(Player, CommandSplit, EntireCommand)
	local DisplayCommand = function(OtherPlayer)
		if CommandSpyList[OtherPlayer:GetUUID()] ~= nil then
			if Player then
				if CommandSpyList[Player:GetUUID()] ~= nil then
					-- OtherPlayer:SendMessage(cChatColor.Yellow .. Player:GetName() .. cChatColor.Yellow .. ": " .. EntireCommand)
                    return true
				else
					OtherPlayer:SendMessage(cChatColor.LightGray .. Player:GetName() .. ": " .. EntireCommand)
				end
			-- If the command was executed by the console or by a command block, then send a different message.
			else
				OtherPlayer:SendMessage(cChatColor.LightGray .. cChatColor.Italic .. "Console/cmdblock: " .. cChatColor.Plain .. cChatColor.LightGray .. EntireCommand)
			end
		end
	end
	cRoot:Get():ForEachPlayer(DisplayCommand)
end