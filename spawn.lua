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
	    SendMessageSuccess(Player, "Took you to the spawnpoint.")
		SendPlayerToWorldSpawn(Player)
		return true
	elseif (NumParams ~= 2) then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " [world]")
		return true
	end
	local World = cRoot:Get():GetWorld(Split[2])
	if (Player:GetWorld():GetName() == Split[2]) then
		SendMessageSuccess(Player, "Took you to the spawnpoint.")
		SendPlayerToWorldSpawn(Player)
		return true
	elseif(World == nil) then
		SendMessageFailure(Player, "Could not find that world (" .. Split[2] .. "), did you use Caps?")
		return true
	elseif(Player:MoveToWorld(World, true, Vector3d(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())) == false) then
		SendMessageFailure(Player, "Could not take you to that world (" .. Split[2] .. "), oops!")
		return true
	end
	SendMessageSuccess(Player, "Took you to that world's spawnpoint (" .. Split[2] .. ").")
	return true
end

function HandleSetSpawnCommand(Split, Player)
	local World = Player:GetWorld()
  
	local PlayerX = Player:GetPosX()
	local PlayerY = Player:GetPosY()
	local PlayerZ = Player:GetPosZ()
  
	if (World:SetSpawn(PlayerX, PlayerY, PlayerZ)) then
		SendMessageSuccess(Player, "Moved the spawnpoint to X: " .. PlayerX .. ", Y: " .. PlayerY .. ", Z: " .. PlayerZ .. ".")
		return true
	else
		SendMessageFailure(Player, "Could not move the spawnpoint, are permissions set?")
		return false
	end
end
