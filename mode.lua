-- mode.lua
-- Handles the gamemode-switching /mode command.

-- Translate gamemodes into strings.
local GameModeNameTable =
{
-- 	[gmSurvival]  = "survival",
	[gmCreative]  = "creative",
--	[gmAdventure] = "adventure",
	[gmSpectator] = "spectator",
}

-- Translate strings to their gamemodes.
-- Survival and adventure mode have been disabled on the server.
local GameModeTable =
{
--	["0"]         = gmSurvival,
--	["survival"]  = gmSurvival,
--	["s"]         = gmSurvival,
	["1"]         = gmCreative,
	["creative"]  = gmCreative,
	["c"]         = gmCreative,
--	["2"]         = gmAdventure,
--	["adventure"] = gmAdventure,
--	["a"]         = gmAdventure,
	["3"]         = gmSpectator,
	["spectator"] = gmSpectator,
	["sp"]        = gmSpectator,
}

local MessageFailure = "Couldn't find that player."

-- Changes a given player's gamemode / mode.
-- 
--  @param GameMode is the gamemode to change to.
--  @param PlayerName is the player name of the player to change the gamemode of.
--  
--  @return true if player was found and gamemode successfully changed, false otherwise.
local function ChangeGameMode(GameMode, PlayerName)

	local GMChanged = false
	local lcPlayerName = string.lower(PlayerName)

    -- Look for online players that match the given PlayerName.
    -- Change their gamemode.
	cRoot:Get():FindAndDoWithPlayer(PlayerName, 
		function(PlayerMatch)
			if string.lower(PlayerMatch:GetName()) == lcPlayerName then
				PlayerMatch:SetGameMode(GameMode)
				SendMessageSuccess(PlayerMatch, "Set your gamemode to " .. GameModeNameTable[GameMode] .. ".")
				GMChanged = true
			end
			return true
		end
	)

	return GMChanged

end

--- Handles the in-game command.
function HandleChangeGMCommand(Split, Player)

	-- Check parameters...
	local GameMode = GameModeTable[Split[2]]

	if not GameMode then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <creative | spectator> [player]")
		return true
	end

	local PlayerToChange = Split[3] or Player:GetName()

	-- Report success or failure.
	if ChangeGameMode( GameMode, PlayerToChange ) then

		local Message = PlayerToChange .. "'s gamemode was set to " .. GameModeNameTable[GameMode]
		local MessageTail = " by " .. Player:GetName()

        if PlayerToChange ~= Player:GetName() then
			SendMessageSuccess(cChatColor.LightGray .. Player, Message .. ".")
		end

		LOGINFO(Message .. MessageTail .. ".")

	else
		SendMessageFailure(Player, cChatColor.LightGray .. MessageFailure)
	end

	return true
end

-- Handles the console command.
function HandleConsoleGamemode(a_Split)

	-- Check parameters...
	local GameMode = GameModeTable[a_Split[2]]
	local PlayerToChange = a_Split[3]
	
	if not PlayerToChange or not GameMode then
		return true, "Usage: " .. a_Split[1] .. " <creative | spectator> <player>"
	end

	-- Report success or failure.
	if ChangeGameMode(GameMode, PlayerToChange) then

		local Message = PlayerToChange .. "'s gamemode was set to " .. GameModeNameTable[GameMode]
		local MessageTail = " by " .. "the console"

		LOG(Message .. MessageTail .. ".")

	else
		LOG(MessageFailure)
	end
	
	return true
end
