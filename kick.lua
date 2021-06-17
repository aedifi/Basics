-- kick.lua
-- Implements the /kick command.

function HandleKickCommand(Split, Player)
	if(#Split < 2) then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <player> [reason]")
		return true
	end

	local Reason = cChatColor.Gray .. "(╯°□°)╯︵ ┻━┻" .. cChatColor.LightGray .. "\n\n" .. "Kicked you from the server."
	if (#Split > 2) then
		Reason = cChatColor.Gray .. "(╯°□°)╯︵ ┻━┻" .. cChatColor.LightGray .. "\n\n" .. "Kicked you from the server." .. cChatColor.Gray .. "\n\n" .. cChatColor.LightGray .. "\"" .. table.concat(Split, " ", 3) .. "\""
	end
	local IsPlayerKicked = false
	local Kick = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[2]) then
			IsPlayerKicked = true
			KickPlayer(Split[2], Reason)
		end
	end

	cRoot:Get():FindAndDoWithPlayer(Split[2], Kick)
    if (IsPlayerKicked) then
        cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Kicked the player " .. Split[2] .. " at request of staff.")
		return true
	end
	if (IsPlayerKicked == false) then
		SendMessage(Player, cChatColor.LightGray .. "Couldn't find that player.")       
		return true
	end
end
