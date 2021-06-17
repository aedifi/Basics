-- spawn.lua
-- Implements spawn teleportion and the /spawn [world] and /setspawn commands.

-- Teleports the specified player to the spawn of the world they're in.
local function SendPlayerToWorldSpawn(a_Player)
	-- Get the spawn's coordinates...
	local World = a_Player:GetWorld()
	local SpawnX = World:GetSpawnX()
	local SpawnY = World:GetSpawnY()
	local SpawnZ = World:GetSpawnZ()

	-- Teleport to spawn using ChunkStay.
	local PlayerUUID = a_Player:GetUUID()
	World:ChunkStay(
		{{SpawnX / 16, SpawnZ / 16}},
		nil,  -- OnChunkAvailable
		function()  -- OnAllChunksAvailable
			World:DoWithPlayerByUUID(PlayerUUID,
				function(a_CBPlayer)
					a_CBPlayer:TeleportToCoords(SpawnX, SpawnY, SpawnZ)
				end
			)
		end
	)
end

function HandleSpawnCommand(Split, Player)
	local NumParams = #Split
	if (NumParams == 1) then
	    SendMessage(Player, cChatColor.LightGray .. "Took you to this world's spawn.")
		SendPlayerToWorldSpawn(Player)
		return true
	elseif (NumParams ~= 2) then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " [world]")
		return true
	end
	local World = cRoot:Get():GetWorld(Split[2])
	if (Player:GetWorld():GetName() == Split[2]) then
		SendMessage(Player, cChatColor.LightGray .. "Took you to this world's spawn.")
		SendPlayerToWorldSpawn(Player)
		return true
	elseif(World == nil) then
		SendMessage(Player, cChatColor.LightGray .. "Couldn't find that world.")
		return true
	elseif(Player:MoveToWorld(World, true, Vector3d(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())) == false) then
		SendMessage(Player, cChatColor.LightGray .. "Couldn't take you to that world.")
		return true
	end
	SendMessage(Player, cChatColor.LightGray .. "Took you to that world's spawn.")
	return true
end

function HandleSetSpawnCommand(Split, Player)
	local World = Player:GetWorld()
  
	local PlayerX = Player:GetPosX()
	local PlayerY = Player:GetPosY()
	local PlayerZ = Player:GetPosZ()
  
	if (World:SetSpawn(PlayerX, PlayerY, PlayerZ)) then
		SendMessage(Player, cChatColor.LightGray .. "Changed the spawn position.")
		return true
	else
		SendMessage(Player, cChatColor.LightGray .. "Couldn't change the spawn position.")
		return false
	end
end
