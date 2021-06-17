-- bans.lua
-- Implements banning commands and handles the banlist.

-- Database handle for the banlist.
local BanlistDB

-- Adds the specified address to the banlist with the reason.
local function AddIPToBanlist(a_IP, a_Reason, a_BannedBy)
	-- Check parameters...
	assert(type(a_IP) == "string")
	assert(type(a_BannedBy) == "string")
	a_Reason = a_Reason or "banned"

	-- Insert into the database...
	return BanlistDB:ExecuteStatement(
		"INSERT INTO BannedIPs (IP, Reason, Timestamp, BannedBy) VALUES (?, ?, ?, ?)",
		{ a_IP, a_Reason, os.time(), a_BannedBy, }
	)
end

-- Adds the specified player to the banlist with the reason.
-- Resolves the player's unique identifier through cache if necessary.
function AddPlayerToBanlist(a_PlayerName, a_Reason, a_BannedBy)
	-- Check parameters...
	assert(type(a_PlayerName) == "string")
	assert(type(a_BannedBy) == "string")
	a_Reason = a_Reason or "banned"

  -- Resolves the player name to OfflineUUID.
  -- If the server is in online mode, resolves to OnlineUUID.
	local UUID = ""
	if (cRoot:Get():GetServer():ShouldAuthenticate()) then
		UUID = cMojangAPI:GetUUIDFromPlayerName(a_PlayerName, true)
    -- If the unique identifier can't be resolved, leave it as an empty string.
	end
	local OfflineUUID = cClientHandle:GenerateOfflineUUID(a_PlayerName)

	-- Insert into the database...
	return BanlistDB:ExecuteStatement(
		"INSERT INTO BannedNames (Name, UUID, OfflineUUID, Reason, Timestamp, BannedBy) VALUES (?, ?, ?, ?, ?, ?)",
		{
			a_PlayerName, UUID, OfflineUUID,
			a_Reason, os.time(), a_BannedBy,
		}
	)
end

-- Checks if the specified address is actually banned.
-- If so, return true along with the reason.  If not, return false.
local function IsIPBanned(a_IP)
	-- Check parameters...
	assert(type(a_IP) == "string")
	assert(a_IP ~= "")

	-- Query the database...
	local Reason
	assert(BanlistDB:ExecuteStatement(
		"SELECT Reason FROM BannedIPs WHERE IP = ?",
		{ a_IP },
		function (a_Row)
			Reason = a_Row["Reason"]
		end
	))

	-- Process the results...
	if (Reason == nil) then
		-- If they're not banned...
		return false
	else
		-- If they're banned with a reason...
		return true, Reason
	end
end

-- Checks if the specified player is actually banned.
-- If so, return true along with the reason.  If not, return false.
-- Uses the player's unique identifier and username as a primary and secondary check.
local function IsPlayerBanned(a_PlayerUUID, a_PlayerName)
	-- Check parameters...
	assert(type(a_PlayerUUID) == "string")
	assert(type(a_PlayerName) == "string")
	local UUID = a_PlayerUUID
	if (UUID == "") then
    -- If there's no unique identifier, use a dummy impossible value.
		UUID = "DummyImpossibleValue"
	end

	-- Query the database...
	local OfflineUUID = cClientHandle:GenerateOfflineUUID(a_PlayerName)
	local Reason
	assert(BanlistDB:ExecuteStatement(
		[[
			SELECT Reason FROM BannedNames WHERE
				(UUID = ?) OR
				(OfflineUUID = ?) OR
				((UUID = '') AND (Name = ?))
		]],
		{ UUID, OfflineUUID, a_PlayerName },
		function (a_Row)
			Reason = a_Row["Reason"]
		end
	))

	-- Process the results...
	if (Reason == nil) then
		-- Not banned
		return false
	else
		-- If they're banned with a reason...
		return true, Reason
	end
end

-- Returns an array table of everyone who's banned.
local function ListBannedPlayers()
	local res = {}
	BanlistDB:ExecuteStatement(
		"SELECT Name FROM BannedNames", {},
		function (a_Columns)
			table.insert(res, a_Columns["Name"])
		end
	)
	return res
end

-- Returns an array table of addresses that are banned.
local function ListBannedIPs()
	local res = {}
	BanlistDB:ExecuteStatement(
		"SELECT IP FROM BannedIPs", {},
		function (a_Columns)
			table.insert(res, a_Columns["IP"])
		end
	)
	return res
end

-- Removes a specific address from the banlist.
-- If the address isn't actually banned, don't do anything.
local function RemoveIPFromBanlist(a_IP)
	-- Check parameters...
	assert(type(a_IP) == "string")

	-- Remove from the database...
	assert(BanlistDB:ExecuteStatement(
		"DELETE FROM BannedIPs WHERE IP = ?",
		{ a_IP }
	))
end

-- Removes a specific player from the banlist.
-- If the player isn't actually banned, don't do anything.
local function RemovePlayerFromBanlist(a_PlayerName)
	-- Check parameters...
	assert(type(a_PlayerName) == "string")

	-- Remove from the database...
	assert(BanlistDB:ExecuteStatement(
		"DELETE FROM BannedNames WHERE Name = ?",
		{ a_PlayerName }
	))
end

-- Resolves the unique identifiers for players whose aren't in the database.
-- Could happen if a player is banned who's never connected to the server, thus not having been cached in the lookup.
local function ResolveUUIDs()
	-- If the server isn't online...
	if not(cRoot:Get():GetServer():ShouldAuthenticate()) then
		return
	end

	-- Collect player names without their unique identifiers.
	local NamesToResolve = {}
	BanlistDB:ExecuteStatement(
		"SELECT Name From BannedNames WHERE UUID = ''", {},
		function (a_Columns)
			table.insert(NamesToResolve, a_Columns["PlayerName"])
		end
	)
	if (#NamesToResolve == 0) then
		return;
	end

	-- Resolve their names...
	LOGINFO("Resolving player identifiers in the banlist from Mojang servers.")
	local ResolvedNames = cMojangAPI:GetUUIDsFromPlayerNames(NamesToResolve)
	LOGINFO("Completed resolving player identifiers.")

	-- Update the database...
	for name, uuid in pairs(ResolvedNames) do
		BanlistDB:ExecuteStatement(
			"UPDATE BannedNames SET UUID = ? WHERE PlayerName = ?",
			{ uuid, name }
		)
	end
end

function HandleBanCommand(a_Split, a_Player)
	-- Check parameters...
	if (a_Split[2] == nil) then
		SendMessage(a_Player, cChatColor.LightGray .. "Usage: " .. a_Split[1] .. " <player> [reason]")
		return true
	end

  -- Use a reason if one's supplied.  Otherwise, use the default reason.
	if (a_Split[3] ~= nil) then
		local Reason = table.concat(a_Split, " ", 3)
	else
		local Reason = "It doesn't look like any reason was supplied."
	end

	-- Add that player to the banlist.
	AddPlayerToBanlist(a_Split[2], Reason, a_Player:GetName());

  -- Attempt to kick the person who's being banned.
  -- Send the appropriate message to the person who's banned that player.
	if (KickPlayer(a_Split[2], Reason)) then
		cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Kicked the player " .. a_Split[2] .. " at request of staff.")
		LOGINFO("Kicked the player " .. a_Split[2] .. " at request of " .. a_Player:GetName() .. ".")
	else
		cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Banned the player " .. a_Split[2] .. " at request of staff.")
		LOGINFO("Banned the player " .. a_Split[2] .. " at request of " .. a_Player:GetName() .. ".")
	end

	return true

end

function HandlePardonCommand(a_Split, a_Player)
	-- Check parameters...
	if ((a_Split[2] == nil) or (a_Split[3] ~= nil)) then
		SendMessage(a_Player, cChatColor.LightGray .. "Usage: " .. a_Split[1] .. " <player>")
		return true
	end

	-- Remove that player from the banlist.
	RemovePlayerFromBanlist(a_Split[2])

	-- If it was successful...
	cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Pardoned the player " .. a_Split[2] .. " at request of staff.")
	LOGINFO("Pardoned the player " .. a_Split[2] .. " at request of " .. a_Player:GetName() .. ".")
	return true
end

function HandleConsoleBan(a_Split)
	-- Check parameters...
	if (a_Split[2] == nil) then
		return true, "Usage: " .. a_Split[1] .. " <player> [reason]"
	end
	local PlayerName = a_Split[2]

	-- If there's a reason, compose it.
	local Reason = cChatColor.LightGray .. "It doesn't look like any reason was supplied."
	if (a_Split[3] ~= nil) then
		Reason = table.concat(a_Split, " ", 3)
	end

	-- Add that player to the banlist.
	AddPlayerToBanlist(PlayerName, Reason, "<console>")

	-- If they're on the server, kick them.
	if not(KickPlayer(PlayerName, Reason)) then
		LOGINFO("Could not find the player " .. PlayerName .. ", but banned them anyway.")
	else
		LOGINFO("Kicked and banned the player " .. PlayerName .. ".")
	end

	return true
end

function HandleConsoleBanIP(a_Split)
	-- Check parameters...
	if (a_Split[2] == nil) then
		return true, "Usage: " .. a_Split[1] .. " <address> [reason]"
	end
	local BanIP = a_Split[2]

	-- If there's a reason, compose it.
	local Reason = cChatColor.LightGray .. "It doesn't look like any reason was supplied."
	if (a_Split[3] ~= nil) then
		Reason = table.concat(a_Split, " ", 3)
	end

	-- Add that address to the banlist.
	AddIPToBanlist(BanIP, Reason, "<console>")

	-- If they're on the server, kick them.
	cRoot:Get():ForEachPlayer(
		function (a_Player)
			local Client = a_Player:GetClientHandle()
			if (Client and Client:GetIPString() == BanIP) then
				Client:Kick(cChatColor.Gray .. "\\-(o)-(o)-/" .. cChatColor.LightGray .. "\n\n" .. "Couldn't connect because your address is banned." .. cChatColor.Gray .. "\n\n" .. cChatColor.LightGray .. "\"" .. Reason .. "\"")
			end
		end
	)

	-- Log to console that an address was banned.
	LOGINFO("Banned the address of " .. BanIP .. ".")
	return true
end

function HandleConsolePardon(a_Split)
	-- Check parameters...
	if ((a_Split[2] == nil) or (a_Split[3] ~= nil)) then
		return true, "Usage: " .. a_Split[1] .. " <player>"
	end

	-- Remove that player from the banlist.
	RemovePlayerFromBanlist(a_Split[2])

	-- Log to console that a player was unbanned.
	LOGINFO("Pardoned the player " .. a_Split[2] .. ".")
	return true
end

function HandleConsolePardonIP(a_Split)
	-- Check parameters...
	if ((a_Split[2] == nil) or (a_Split[3] ~= nil)) then
		return true, "Usage: " .. a_Split[1] .. " <address>"
	end

	-- Remove that address from the banlist.
	RemoveIPFromBanlist(a_Split[2])

	-- Log to console that an address was unbanned.
	LOGINFO("Pardoned the address of " .. a_Split[2] .. ".")
	return true
end

-- Opens the database and checks that all tables have the needed structure.
local function InitializeDB()
	-- Open it...
	local ErrMsg
	BanlistDB, ErrMsg = NewSQLiteDB("banlist.sqlite")
	if not(BanlistDB) then
		LOGWARNING("Couldn't access the banlist. SQLite: " .. (ErrMsg or "<no details>"))
		error(ErrMsg)
	end

	-- Define the needed structure.
	local NameListColumns =
	{
		"Name",
		"UUID",
		"OfflineUUID",
		"Reason",
		"Timestamp",
		"BannedBy",
	}
	local IPListColumns =
	{
		"IP",
		"Reason",
		"Timestamp",
		"BannedBy",
	}

	-- Check that it's right.
	if (
		not(BanlistDB:CreateDBTable("BannedNames", NameListColumns)) or
		not(BanlistDB:CreateDBTable("BannedIPs",   IPListColumns))
	) then
		LOGWARNING("Couldn't access the banlist.")
		error("Couldn't access the banlist.")
	end
end

-- HOOK_PLAYER_JOINED callback hook.
-- If the player's banned by their unique identifier or username, kick them.
-- If the player's unique identifier isn't already present, set it.
local function OnPlayerJoined(a_Player)
	local UUID = a_Player:GetUUID()
	local Name = a_Player:GetName()

	-- If empty, update the database.
	assert(BanlistDB:ExecuteStatement(
		"UPDATE BannedNames SET UUID = ? WHERE ((UUID = '') AND (Name = ?))",
		{ UUID, Name }
	))

	-- Kick the player if they're banned.
	local IsBanned, Reason = IsPlayerBanned(UUID, Name)
	if (IsBanned) then
		a_Player:GetClientHandle():Kick(cChatColor.Gray .. "\\-(o)-(o)-/" .. cChatColor.LightGray .. "\n\n" .. "Couldn't connect because you are banned." .. cChatColor.Gray .. "\n\n" .. cChatColor.LightGray .. "\"" .. Reason .. "\"")
		return true
	end
end

-- HOOK_LOGIN callbook hook.
-- If the player's address is banned, kick them.
local function OnLogin(a_Client)
	local IsBanned, Reason = IsIPBanned(a_Client:GetIPString())
	if (IsBanned) then
		a_Client:Kick(cChatColor.Gray .. "\\-(o)-(o)-/" .. cChatColor.LightGray .. "\n\n" .. "Couldn't connect because your address is banned." .. cChatColor.Gray .. "\n\n" .. cChatColor.LightGray .. "\"" .. Reason .. "\"")
		return true
	end
end

-- Initialize the banlist upon the plugin's startup.
-- Open the banlist's database and refresh any player names stored within.
function InitializeBanlist()
	-- Initialize the database...
	InitializeDB()
	ResolveUUIDs()

	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined)
	cPluginManager:AddHook(cPluginManager.HOOK_LOGIN, OnLogin)
end
