-- main.lua
-- Implements the plugin's main entrypoint.

-- Configuration: should prefixes be used or not?
-- If set to true, messages are prefixed.  If false, messages are colored.
g_UsePrefixes = false

-- Global variables.
WorldsSpawnProtect = {}
WorldsWorldLimit = {}
WorldsWorldDifficulty = {}
lastsender = {}

-- Called on plugin start for initialization.
function Initialize(Plugin)
	Plugin:SetName("Basics")
	Plugin:SetVersion(tonumber(g_PluginInfo["Version"]))

	-- Register for all hooks needed.
	cPluginManager:AddHook(cPluginManager.HOOK_BLOCK_SPREAD, OnBlockSpread)
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT, OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_EXPLODING, OnExploding)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
	cPluginManager:AddHook(cPluginManager.HOOK_TICK, OnTick)
	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick)
	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand)

	-- Bind in-game commands...
	-- Load the InfoReg shared library...
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

	-- Bind all the commands...
	RegisterPluginInfoCommands()

	-- Bind all the console commands...
	RegisterPluginInfoConsoleCommands()

	-- Load SpawnProtection and WorldLimit settings...
	cRoot:Get():ForEachWorld(
		function (a_World)
			LoadWorldSettings(a_World)
		end
	)

	-- Initialize the whitelist.
	-- Whitelist functionality is disabled for this server.
	-- InitializeWhitelist()

	-- Initialize the item blacklist i.e. what can't be contained using in-game commands.
	-- Item blacklist functionality is disabled for this server.
	-- IntializeItemBlacklist( Plugin )

	LoadMOTD()

	-- WEBLOGINFO("Basics has been enabled.")
	-- LOG(Plugin:GetName() .. " has been enabled.")

	return true
end

function OnChat(Player, Message)
	LOGINFO(Player:GetName() .. ": " .. StripColorCodes(Message));
	return false
end

-- function OnDisable()
-- 	LOG("Basics has been disabled.")
-- end
