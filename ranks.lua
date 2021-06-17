-- ranks.lua
-- Implements the /ranks command and hierarchy functions.

function HandleConsoleRanks(Split)
    local Ranks = cRankManager:GetAllRanks()
    return true, "Ranks (" .. #Ranks .. "): " .. table.concat(Ranks, ", ")
end

function HandleRanksCommand(Split, Player)
    local Ranks = cRankManager:GetAllRanks()
    return true, SendMessage(Player, cChatColor.LightGray .. "Ranks (" .. #Ranks .. "): " .. table.concat(Ranks, cChatColor.LightGray .. ", "))
end

function HandleAssignCommand(Split, Player)
	local Response
	local PlayerName = Split[2]
	local NewRank = Split[3]

	if not PlayerName then
		Response = SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <player> [rank]")
	else
		-- Translate from username to unique identifier.
		local PlayerUUID = GetPlayerUUID(PlayerName)

		if not PlayerUUID or string.len(PlayerUUID) ~= 32 then
			Response = SendMessage(Player, cChatColor.LightGray .. "Couldn't find that player.")
		else
			-- If lacking parameters, view their rank.
			if not NewRank then
				-- Display the rank.
				local CurrentRank = cRankManager:GetPlayerRankName(PlayerUUID)

				if CurrentRank == "" then
					Response = SendMessage(Player, cChatColor.LightGray .. "Couldn't find any rank for that player.")
				else
					Response = SendMessage(Player, cChatColor.LightGray .. "Found the player " .. PlayerName .. "'s rank to be of " .. CurrentRank .. ".")
				end
			else
				-- Change the player's rank:
				if not cRankManager:RankExists(NewRank) then
					Response = SendMessage(Player, cChatColor.LightGray .. "Couldn't find that rank.")
				else
					cRankManager:SetPlayerRank(PlayerUUID, PlayerName, NewRank)
					cRoot:Get():ForEachPlayer(
                		function(a_CBPlayer)
	                		if (a_CBPlayer:GetName() == PlayerName) then
	            			a_CBPlayer:LoadRank()
	            		end
            		end
                	)

                    local CurrentRank = cRankManager:GetPlayerRankName(PlayerUUID)
                    Response = cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Updated the player " .. PlayerName .. "'s rank at request of staff.")
				end
			end
		end
	end
	return true, Response
end

function HandleConsoleAssign(Split)
	local Response
	local PlayerName = Split[2]
	local NewRank = Split[3]

	if not PlayerName then
		Response = "Usage: " .. Split[1] .. " <player> [rank]"
	else
		-- Translate from username to unique identifier.
		local PlayerUUID = GetPlayerUUID(PlayerName)

		if not PlayerUUID or string.len(PlayerUUID) ~= 32 then
			Response = "Couldn't find that player."
		else
			-- If lacking parameters, view their rank.
			if not NewRank then
				-- Display the rank.
				local CurrentRank = cRankManager:GetPlayerRankName(PlayerUUID)

				if CurrentRank == "" then
					Response = "Couldn't find any rank for that player."
				else
					Response = "Found the player " .. PlayerName .. "'s rank to be of " .. CurrentRank .. "."
				end
			else
				-- Change the player's rank:
				if not cRankManager:RankExists(NewRank) then
					Response = "Couldn't find that rank."
				else
					cRankManager:SetPlayerRank(PlayerUUID, PlayerName, NewRank)
					cRoot:Get():ForEachPlayer(
                		function(a_CBPlayer)
	                		if (a_CBPlayer:GetName() == PlayerName) then
	            			a_CBPlayer:LoadRank()
	            		end
            		end
                	)

                    local CurrentRank = cRankManager:GetPlayerRankName(PlayerUUID)
                    Response = LOGINFO("Assigned the player " .. PlayerName .. " to " .. CurrentRank .. ".")
                    Response = cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Updated the player " .. PlayerName .. "'s rank at request of console.")
				end
			end
		end
	end
	return true, Response
end
