-- goto.lua
-- Implements the /goto command and coordinate teleportation.

function HandleGotoCommand(a_Split, a_Player)
	if #a_Split == 2 then
        -- Teleport to player specified in a_Split[2].
        TeleportToPlayer(a_Player, a_Split[2])
		return true
	elseif #a_Split == 4 then
		-- Teleport to coordinates specified in a_Split[2, 3, 4].
		-- Relative coordinates.
		local Function
		local X = tonumber(a_Split[2])
		Function = loadstring(a_Split[2]:gsub("~", "return " .. a_Player:GetPosX() .. "+0"))
		if Function then
			-- Execute the function in a save environment, and get the second return value.
			-- The first return value is a boolean.
			X = select(2, pcall(setfenv(Function, {})))
		end
		local Y = tonumber(a_Split[3])
		Function = loadstring(a_Split[3]:gsub("~", "return " .. a_Player:GetPosY() .. "+0"))
		if Function then
			-- Execute the function in a save environment, and get the second return value.
			-- The first return value is a boolean.
			Y = select(2, pcall(setfenv(Function, {})))
		end
		local Z = tonumber(a_Split[4])
		Function = loadstring(a_Split[4]:gsub("~", "return " .. a_Player:GetPosZ() .. "+0"))
		if Function then
			-- Execute the function in a save environment, and get the second return value.
			-- The first return value is a boolean.
			Z = select(2, pcall(setfenv(Function, {})))
		end
		-- Check the given coordinates for errors.
		if (type(X) ~= 'number') then
			SendMessage(a_Player, cChatColor.LightGray .. "Couldn't take you to a non-numeric coordinate.")
			return true
		end
		if (type(Y) ~= 'number') then
			SendMessage(a_Player, cChatColor.LightGray .. "Couldn't take you to a non-numeric coordinate.")
			return true
		end
		if (type(Z) ~= 'number') then
			SendMessage(a_Player, cChatColor.LightGray .. "Couldn't take you to a non-numeric coordinate.")
			return true
		end
		a_Player:TeleportToCoords( X, Y, Z )
		SendMessage(a_Player, cChatColor.LightGray .. "Took you to X: " .. X .. ", Y: " .. Y .. ", Z: " .. Z .. ".")
		return true
	else
		SendMessage(a_Player, cChatColor.LightGray .. "Usage: " .. a_Split[1] .. " <player> (or) " .. a_Split[1] .. " <x> <y> <z>")
		return true
	end
end
