-- seed.lua
-- Implements the /seed command.

function HandleSeedCommand(Split, Player)
	if not(Split[2]) then
		Player:SendMessageInfo(cChatColor.LightGray .. "Seed: " .. Player:GetWorld():GetSeed())
	else
		local World = cRoot:Get():GetWorld(Split[2])
		local WorldName = Split[2]
		if not(World) then
			Player:SendMessageFailure("Could not find that world (" .. WorldName .. "), did you use Caps?")
		else
			Player:SendMessage(cChatColor.LightGray .. "Seed (" .. WorldName .. "): " .. World:GetSeed())
		end
	end
	return true
end

function HandleConsoleSeed(Split)
	if not(Split[2]) then
		return true, "Seed: " .. cRoot:Get():GetDefaultWorld():GetSeed()
	else
		local World = cRoot:Get():GetWorld(Split[2])
		local WorldName = Split[2]
		if not(World) then
			return true, "Could not find that world, did you use Caps?"
		else
			return true, "Seed (" .. WorldName .. "): " .. World:GetSeed()
		end
	end
end
