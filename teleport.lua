-- teleport.lua
-- Implements the /goto command and coordinate teleportation.

BackCoords = {}
BackWorld = {}

function HandleGotoCommand(a_Split, a_Player)
	if #a_Split == 2 and a_Split[2] == "rand" then
		local X = math.random(-5000, 5000);
		local Y = math.random(50,50);
		local Z = math.random(-5000, 5000);
		a_Player:TeleportToCoords( X, Y, Z )
		SendMessageSuccess(a_Player, "Took you to X: " .. X .. ", Y: " .. Y .. ", Z: " .. Z .. ".")
		return true
	elseif #a_Split == 2 then
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
			SendMessageFailure(a_Player, "Could not use a non-numeric coordinate (" .. a_Split[2] .. ").")
			return true
		end
		if (type(Y) ~= 'number') then
			SendMessageFailure(a_Player, "Could not use a non-numeric coordinate (" .. a_Split[3] .. ").")
			return true
		end
		if (type(Z) ~= 'number') then
			SendMessageFailure(a_Player, "Could not use a non-numeric coordinate (" .. a_Split[4] .. ").")
			return true
		end
		a_Player:TeleportToCoords( X, Y, Z )
		SendMessageSuccess(a_Player, "Took you to X: " .. X .. ", Y: " .. Y .. ", Z: " .. Z .. ".")
		return true
	else
		SendMessage(a_Player, cChatColor.LightGray .. "Usage: " .. a_Split[1] .. " <player> (or) " .. a_Split[1] .. " <x> <y> <z> (or) " .. a_Split[1] .. " rand")
		return true
	end
end

function HandleBackCommand(Split, Player)
	local BackCoords = BackCoords[Player:GetName()]
	if BackCoords == nil then
		Player:SendMessageFailure("Could not find any known last position.")
	else
		local CurWorld = Player:GetWorld()
		local OldWorld = BackWorld[Player:GetName()]
		if CurWorld ~= OldWorld then
			Player:MoveToWorld(OldWorld, true, Vector3d(BackCoords.x, BackCoords.y, BackCoords.z))
		else
			Player:TeleportToCoords(BackCoords.x, BackCoords.y, BackCoords.z)
		end
		Player:SendMessageSuccess("Took you back to your last known position.")
	end
	return true
end

function OnEntityChangingWorld(Entity, World)
	if Entity:IsPlayer() then
		BackWorld[Entity:GetName()] = Entity:GetWorld()
		BackCoords[Entity:GetName()] = Vector3d(Entity:GetPosX(), Entity:GetPosY(), Entity:GetPosZ())
	end
end

function OnEntityTeleport(Entity, OldPosition, NewPosition)
	if Entity:IsPlayer() then
		BackWorld[Entity:GetName()] = Entity:GetWorld()
		BackCoords[Entity:GetName()] = Vector3d(OldPosition)
	end
end

function OnKilled(Victim, TDI, DeathMessage)
	if Victim:IsPlayer() then
		BackWorld[Victim:GetName()] = Victim:GetWorld()
		BackCoords[Victim:GetName()] = Vector3d(Victim:GetPosX(), Victim:GetPosY(), Victim:GetPosZ())
	end
end
