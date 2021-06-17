-- nearby.lua
-- Implements the /nearby command.

function HandleNearbyCommand(Split, Player)
	local PlayerTable = {}
	Player:GetWorld():ForEachPlayer(
		function(OtherPlayer)
			local Distance = math.floor((Player:GetPosition() - OtherPlayer:GetPosition()):Length())
			if tonumber(Split[2]) then
				DistanceLimit = tonumber(Split[2])
			else
				DistanceLimit = 200
			end
			if Distance <= DistanceLimit then
				if OtherPlayer:GetName() ~= Player:GetName() then
					table.insert(PlayerTable,
						{
							Name = OtherPlayer:GetName(),
							Distance = Distance,
						}
					)
				end
			end
		end
	)

	table.sort(PlayerTable,
		function (Player1, Player2)
			return Player1.Distance < Player2.Distance
		end
	)

	local String = {}
	for k, v in ipairs(PlayerTable) do
		table.insert(String, v.Name)
		table.insert(String, " " .. cChatColor.LightGray .. "(")
		table.insert(String, v.Distance)
		table.insert(String, "m), ")
	end

	local String = table.concat(String, "")
	Player:SendMessage(cChatColor.LightGray .. "Nearby (" .. #PlayerTable .. "): " .. cChatColor.LightGray .. String:sub(1, String:len() - 2))
	return true
end
