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
	if #Split < 3 then
		SendMessage(Player, "Usage: " .. Split[1] .. " <player> <command [...]>")
		return true
	end

	-- Get the command and arguments.
	local newSplit = table.concat(Split, " ", 3)

	local FoundPlayerCallback = function(a_Player)
		local pluginManager = cRoot:Get():GetPluginManager()
		if (pluginManager:ExecuteCommand(a_Player, newSplit)) then
			SendMessageSuccess(Player, "Executed that command as the player " .. Split[2] .. ".")
		else
			SendMessageFailure(Player, "Could not execute that command, are permissions set?")
		end
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer(Split[2], FoundPlayerCallback) then
		SendMessageFailure(Player, "Could not find that player (" .. Split[2] .. "), are they online?")
		return true
	end
	
	return true
end

function HandleConsoleSudo(Split, Player)
	if #Split < 3 then
		return true, "Usage: " .. Split[1] .. " <player> <command [...]>"
	end

	-- Get the command and arguments.
	local newSplit = table.concat(Split, " ", 3)

	local FoundPlayerCallback = function(a_Player)
		local pluginManager = cRoot:Get():GetPluginManager()
		if (pluginManager:ExecuteCommand(a_Player, newSplit)) then
			return true, "Executed that command as the player " .. Split[2] .. "."
		else
			return true, "Could not execute that command, are permissions set?"
		end
	end

	if not cRoot:Get():FindAndDoWithPlayer(Split[2], FoundPlayerCallback) then
		return true, "Could not find that player, are they online?"
	end
end

function HandleExecuteCommand(Split, Player)
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
			Player:SendMessageSuccess("Executed a cmdblock in your direction.")
		else
			Player:SendMessageFailure("Could not find a cmdblock in your direction.")
		end
	elseif Split[2] ~= nil and Split[3] ~= nil and Split[4] ~= nil then
		if tonumber(Split[2]) == nil or tonumber(Split[3]) == nil or tonumber(Split[4]) == nil then
			Player:SendMessageFailure("Could not use a non-numeric coordinate.")
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
				Player:SendMessageSuccess("Executed a cmdblock at X: " ..Split[2].. ", Y: " ..Split[3].. ", Z: " ..Split[4].. ".")
			else
				Player:SendMessageFailure("Could not find a cmdblock in your direction.")
			end
			return true
		end
	else
		Player:SendMessage(cChatColor.LightGray .. "Usage: " ..Split[1].. " [<x> <y> <z>]")
	end
	return true
end

function HandleConsoleExecute(Split, Player)
	if Split[2] ~= nil and Split[3] ~= nil and Split[4] ~= nil and Split[5] ~= nil then
		if tonumber(Split[2]) == nil or tonumber(Split[3]) == nil or tonumber(Split[4]) == nil then
			return true, "Could not use a non-numeric coordinate."
		end
		if cRoot:Get():GetWorld(Split[5]) == nil then
			return true, "Could not find that world, did you use Caps?"
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
			return true, "Could not find a cmdblock at that location."
		end
	else
		return true, "Usage: " .. Split[1] .. " <x> <y> <z> <world>"
	end
end
