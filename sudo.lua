-- sudo.lua
-- Implements the /sudo command.

function GetPlayerLookPos(Player)
	local World = Player:GetWorld()
	local Start = Player:GetEyePosition()
	local End = Start + Player:GetLookVector() * 150
	local HitCoords = nil
	local Callbacks =
	{
		OnNextBlock = function(BlockPos, BlockType)
			if BlockType ~= E_BLOCK_AIR then
				HitCoords = BlockPos
				return true
			end
		end
	}
	cLineBlockTracer:Trace(World, Callbacks, Start, End)
	return HitCoords
end

function HandleSudoCommand(Split, Player)
	if Split[2] == nil then
		local LookPos = GetPlayerLookPos(Player)
		local LookingAtCommandBlock = Player:GetWorld():DoWithBlockEntityAt(
			LookPos.x, LookPos.y, LookPos.z,
			function (CommandBlock)
				local ExecuteCommandBlock = tolua.cast(CommandBlock, "cCommandBlockEntity")
				ExecuteCommandBlock:Activate()
			end
		)
		if LookingAtCommandBlock then
			Player:SendMessage(cChatColor.LightGray .. "Executed a cmdblock in your direction.")
		else
			Player:SendMessage(cChatColor.LightGray .. "Couldn't find a cmdblock in your direction.")
		end
	elseif Split[2] ~= nil and Split[3] ~= nil and Split[4] ~= nil then
		if tonumber(Split[2]) == nil or tonumber(Split[3]) == nil or tonumber(Split[4]) == nil then
			Player:SendMessage(cChatColor.LightGray .. "Couldn't execute a cmdblock at a non-numeric coordinate.")
			return true
		else
			local IsCommandBlock = Player:GetWorld():DoWithBlockEntityAt(
				Split[2], Split[3], Split[4],
				function (CommandBlock)
					local ExecuteCommandBlock = tolua.cast(CommandBlock, "cCommandBlockEntity")
					ExecuteCommandBlock:Activate()
				end
			)
			if IsCommandBlock then
				Player:SendMessage(cChatColor.LightGray .. "Executed a cmdblock at X: " ..Split[2].. ", Y: " ..Split[3].. ", Z: " ..Split[4].. ".")
			else
				Player:SendMessage(cChatColor.LightGray .. "Couldn't find a cmdblock at that location.")
			end
			return true
		end
	else
		Player:SendMessage(cChatColor.LightGray .. "Usage: " ..Split[1].. " [<x> <y> <z>]")
	end
	return true
end

function HandleConsoleSudo(Split, Player)
	if Split[2] ~= nil and Split[3] ~= nil and Split[4] ~= nil and Split[5] ~= nil then
		if tonumber(Split[2]) == nil or tonumber(Split[3]) == nil or tonumber(Split[4]) == nil then
			return true, "Couldn't execute a cmdblock at a non-numeric coordinate."
		end
		if cRoot:Get():GetWorld(Split[5]) == nil then
			return true, "Couldn't find that world."
		end
		local IsCommandBlock = cRoot:Get():GetWorld(Split[5]):DoWithBlockEntityAt(
			Split[2], Split[3], Split[4],
			function (CommandBlock)
				local ExecuteCommandBlock = tolua.cast(CommandBlock, "cCommandBlockEntity")
				ExecuteCommandBlock:Activate()
			end
		)
		if IsCommandBlock == true then
			return true, "Executed a cmdblock in that world at X: " .. Split[2] .. ", Y: " .. Split[3] .. ", Z: " .. Split[4] .. "."
		else
			return true, "Couldn't find a cmdblock in that world at that location."
		end
	else
		return true, "Usage: " .. Split[1] .. " <x> <y> <z> <world>"
	end
end