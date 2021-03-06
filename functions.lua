-- functions.lua
-- Functions called upon plugin initialization.

-- Returns the unique identifier of a player.
function GetPlayerUUID(PlayerName)
	-- Always check for unique identifier because of Bungee.
	return cMojangAPI:GetUUIDFromPlayerName(PlayerName)
end

-- Returns the world object of the specified world name.
-- If a name isn't provided, the function returns the world of the specified player.
-- If a player isn't specified (e.g. console), the function returns the default world.
function GetWorld(WorldName, Player)
	if not WorldName then
		return Player and Player:GetWorld() or cRoot:Get():GetDefaultWorld()
	end
	return cRoot:Get():GetWorld(WorldName)
end

-- Kicks a player by name and returns bool whether found.
function KickPlayer(PlayerName, Reason)
	if not Reason then
		Reason = "Kicked you from the server."
	end

	local KickPlayer = function(Player)
		Player:GetClientHandle():Kick(Reason)
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer(PlayerName, KickPlayer) then
		-- Couldn't find that player.
		return false
	end
	return true -- They've been kicked.
end

-- A better method to find players.
function SafeDoWithPlayer(PlayerName, Function)
	local DoWithPlayer = function(World)
		World:DoWithPlayer(PlayerName, Function)
	end
	
	local QueueTask = function(World)
		World:QueueTask(DoWithPlayer)
	end

	cRoot:Get():ForEachWorld(QueueTask);
end

-- If the target is a player, the SendMessage function takes care of sending the message to the player.
-- If the target is a command block or the console, the message is simply returned to the calling function.
function SendMessage(Player, Message)
	if Player then
		Player:SendMessageInfo(Message)
		return nil
	end
	return Message
end

function SendMessageSuccess(Player, Message)
	if Player then
		Player:SendMessageSuccess(Message)
		return nil
	end
	return Message
end

function SendMessageFailure(Player, Message)
	if Player then
		Player:SendMessageFailure(Message)
		return nil
	end
	return Message
end

-- Teleports a_SrcPlayer to a player named a_DstPlayerName.
-- If a_TellDst is true, will send a notice to the destination player.
function TeleportToPlayer(a_SrcPlayer, a_DstPlayerName, a_TellDst)
	local teleport = function(a_DstPlayerName)
		if a_DstPlayerName == a_SrcPlayer then
			-- Asked to teleport to self?
			SendMessage(cChatColor.LightGray .. "Can't teleport to yourself.")
		else
			-- If destination player is not in the same world, move to the correct world
			if a_SrcPlayer:GetWorld() ~= a_DstPlayerName:GetWorld() then
				a_SrcPlayer:MoveToWorld(a_DstPlayerName:GetWorld(), true, Vector3d( a_DstPlayerName:GetPosX() + 0.5, a_DstPlayerName:GetPosY(), a_DstPlayerName:GetPosZ() + 0.5 ))
			else
				a_SrcPlayer:TeleportToEntity(a_DstPlayerName)
			end
			SendMessage(a_SrcPlayer, cChatColor.LightGray .. "Teleported you to " .. a_DstPlayerName:GetName() .. ".")
			if (a_TellDst) then
				SendMessage(a_DstPlayerName, cChatColor.LightGray .. a_SrcPlayer:GetName().." teleported to you.")
			end
		end
	end

	if not cRoot:Get():FindAndDoWithPlayer(a_DstPlayerName, teleport) then
		SendMessage(a_SrcPlayer, cChatColor.LightGray .. "Couldn't find that player.")
	end

end

function getSpawnProtectRadius(WorldName)
	return WorldsSpawnProtect[WorldName]
end

function GetWorldDifficulty(a_World)
	local Difficulty = WorldsWorldDifficulty[a_World:GetName()]
	if (Difficulty == nil) then
		Difficulty = 1
	end
	return Clamp(Difficulty, 0, 3)
end

function SetWorldDifficulty(a_World, a_Difficulty)
	local Difficulty = Clamp(a_Difficulty, 0, 3)
	WorldsWorldDifficulty[a_World:GetName()] = Difficulty

	-- Update world.ini file.
	local WorldIni = cIniFile()
	WorldIni:ReadFile(a_World:GetIniFileName())
	WorldIni:SetValueI("Difficulty", "WorldDifficulty", Difficulty)
	WorldIni:WriteFile(a_World:GetIniFileName())
end

function LoadWorldSettings(a_World)
	local WorldIni = cIniFile()
	WorldIni:ReadFile(a_World:GetIniFileName())
	WorldsSpawnProtect[a_World:GetName()]    = WorldIni:GetValueSetI("SpawnProtect", "ProtectRadius", 10)
	WorldsWorldLimit[a_World:GetName()]      = WorldIni:GetValueSetI("WorldLimit",   "LimitRadius",   0)
	WorldsWorldDifficulty[a_World:GetName()] = WorldIni:GetValueSetI("Difficulty", "WorldDifficulty", 1)
	WorldIni:WriteFile(a_World:GetIniFileName())
end

--- Returns the cWorld object represented by the given WorldName,
--  if no world of the given name is found, returns nil and informs the player, if given, otherwise logs to console.
--  If no WorldName was given, returns the default world if called without a player,
--  or the current world that the player is in if called with a player.
--
--  @param WorldName String contains the name of the world to find.
--  @param Player cPlayer object represents the player calling the command.
--
--  @return cWorld object represents the requested world, or nil if not found.
--
--  Called from: time.lua, weather.lua...
function GetWorld( WorldName, Player )

	if not WorldName then
		return Player and Player:GetWorld() or cRoot:Get():GetDefaultWorld()
	else
		local World = cRoot:Get():GetWorld(WorldName)
		if not World then
			if Player then
				SendMessageFailure(Player, "Could not find that world (" .. WorldName .. "), did you use Caps?")
			end
		end
		return World
	end
end

function GetAdminRank()
	local AdminRank
	local Ranks = cRankManager:GetAllRanks()
	for _, Rank in ipairs(Ranks) do
		local Permissions = cRankManager:GetRankPermissions(Rank)
		for _, Permission in ipairs(Permissions) do
			if Permission == "*" then
				return Rank
			end
		end
	end
end
