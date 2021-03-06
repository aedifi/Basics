-- regen.lua
-- Implements commands for chunk regeneration.

function HandleRegenCommand(a_Split, a_Player)
	-- Check parameters...
	local numParams = #a_Split
	if (numParams == 2) or (numParams > 3) then
		SendMessage(a_Player, cChatColor.LightGray .. "Usage: " .. a_Split[1] .. " <x> <z>" )
		return true
    end
    
	-- Grab the coordinates of a chunk.
	local chunkX = tonumber(a_Split[2])
	if (chunkX == nil) then
		SendMessageFailure(a_Player, "Could not use a non-numeric coordinate (" .. chunkX .. ")")
		return true
	end
	local chunkZ = tonumber(a_Split[3])
	if (chunkZ == nil) then
		SendMessageFailure(a_Player, "Could not use a non-numeric coordinate (" .. chunkZ .. ").")
		return true
	end
    
	-- Regenerate that chunk.
	SendMessageSuccess(a_Player, "Regenerated the chunk at X: " .. chunkX .. ", Y: " .. chunkZ .. ".")
	a_Player:GetWorld():RegenerateChunk(chunkX, chunkZ)
	return true
end

function HandleConsoleRegen(a_Split)
	-- Check parameters...
	local numParams = #a_Split
	if ((numParams ~= 3) and (numParams ~= 4)) then
		return true, "Usage: " .. a_Split[1] .. " <x> <z> [world]"
	end
	
	-- Grab the coordinates of a chunk.
	local chunkX = tonumber(a_Split[2])
	if (chunkX == nil) then
		return true, "Could not use a non-numeric coordinate."
	end
	local chunkZ = tonumber(a_Split[3])
	if (chunkZ == nil) then
		return true, "Could not use a non-numeric coordinate."
	end
	
	-- Get the correct world.
	local world
	if (a_Split[4] == nil) then
		world = cRoot:Get():GetDefaultWorld()
	else
		world = cRoot:Get():GetWorld(a_Split[4])
		if (world == nil) then
			return true, "Could not find that world, did you use Caps?"
		end
	end
	
	-- Regenerate that chunk.
	world:RegenerateChunk(chunkX, chunkZ)
	return true, "Regenerated the chunk at X: " .. chunkX .. ", Y: " .. chunkZ .. " in world " .. world:GetName() .. "."
end
