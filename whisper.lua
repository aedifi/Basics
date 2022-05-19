-- whisper.lua
-- Implements the /whisper and /reply commands.

function HandleWhisperCommand(Split, Player)
	if (Split[2] == nil) or (Split[3] == nil) then
		SendMessage(Player, cChatColor.LightGray .. "Usage: "..Split[1].." <player> <message>")
		return true
	end
	local FoundPlayer = false
	local SendMessage = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[2]) then
			local newSplit = table.concat(Split, " ", 3)
			-- Notify them that the message was sent successfully.
			SendMessageSuccess(Player, "Sent a message to " .. Split[2] .. ".")
			OtherPlayer:SendMessagePrivateMsg(newSplit, Player:GetName())
			lastsender[OtherPlayer:GetName()] = Player:GetName()
			FoundPlayer = true
		end
	end
	cRoot:Get():ForEachPlayer(SendMessage)
	-- If that player couldn't be found, display an error.
	if not FoundPlayer then
		-- Tell them.
		SendMessageFailure(Player, "Could not find that player, are they online?")
	end
	return true
end

function HandleReplyCommand(Split, Player)
    if Split[2] == nil then
        Player:SendMessage(cChatColor.LightGray .. "Usage: "..Split[1].." <message>")
    else
        local SendMessage = function(OtherPlayer)
            if (OtherPlayer:GetName() == lastsender[Player:GetName()]) then
                local newSplit = table.concat(Split, " ", 2)
                Player:SendMessageSuccess(cChatColor.LightGray .. "Sent a message to " .. lastsender[Player:GetName()] .. ".")
                OtherPlayer:SendMessagePrivateMsg(newSplit, Player:GetName())
                lastsender[OtherPlayer:GetName()] = Player:GetName()
                return true
            end
        end
	-- If there isn't anybody to which they may reply, display an error.
        if lastsender[Player:GetName()] == nil then
            Player:SendMessageFailure(cChatColor.LightGray .. "Could not find a previous sender.")
        else
	    -- If that player couldn't be found, display an error.
            if (not(cRoot:Get():FindAndDoWithPlayer(lastsender[Player:GetName()], SendMessage))) then
                Player:SendMessageFailure(cChatColor.LightGray .. "Could not find that player, are they online?")
            end
        end
    end
    return true
end
