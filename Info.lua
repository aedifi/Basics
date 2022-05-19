-- info.lua
-- Implements the g_PluginInfo standard plugin description.

g_PluginInfo = 
{
	Name = "Basics",
	Version = "1",
	Date = "2022-05-19",
	SourceLocation = "https://github.com/aedifi/basics",
	Description = [[Basic commands and permissions.]],
	
	Commands =
	{
		["/assign"] = 
		{
			Alias = "/rank",
			Permission = "basics.admin.assign",
			Handler = HandleAssignCommand,
			HelpString = "Displays or assigns a player's rank.",
		},
		["/ban"] = 
		{
			Permission = "basics.mod.ban",
			Handler = HandleBanCommand,
			HelpString = "Bans a player.",
		},
		["/chunks"] = 
		{
			Permission = "basics.visitor.chunks",
			Handler = HandleChunksCommand,
			HelpString = "Lists any chunks in memory.",
		},
		["/clear"] = 
		{
			Alias = "/ci",
			Permission = "basics.architect.clear",
			Handler = HandleClearCommand,
			HelpString = "Clears a player's inventory.",
		},
		["/commands"] = 
		{
			Alias = {"/?", "/help"},
			Permission = "basics.visitor.commands",
			Handler = HandleCommandsCommand,
			HelpString = "Lists permissible commands.",
		},
		["/distance"] = 
		{
			Permission = "basics.visitor.distance",
			Handler = HandleDistanceCommand,
			HelpString = "Sets your render distance.",
		},
		["/execute"] = 
		{
			Permission = "basics.admin.execute",
			Handler = HandleExecuteCommand,
			HelpString = "Executes a command block with superuser privileges.",
		},
		["/get"] = 
		{
			Alias = {"/give", "/i"},
			Permission = "basics.architect.get",
			Handler = HandleGetCommand,
			HelpString = "Gets an item for you.",
		},
		["/goto"] = 
		{
			Alias = {"/teleport", "/tp"},
			Permission = "basics.architect.goto",
			Handler = HandleGotoCommand,
			HelpString = "Takes you to any player, coordinates, or random location.",
		},
		["/item"] = 
		{
			Alias = {"/itemdb"},
			Permission = "basics.architect.item",
			Handler = HandleItemCommand,
			HelpString = "Displays the information of an item you're holding.",
		},
		["/kick"] = 
		{
			Permission = "basics.mod.kick",
			Handler = HandleKickCommand,
			HelpString = "Kicks a player.",
		},
		["/lag"] = 
		{
			Permission = "basics.visitor.lag",
			Handler = HandleLagCommand,
			HelpString = "Calculates the average ticks per second.",
		},
		["/memory"] = 
		{
			Alias = "/mem",
			Permission = "basics.visitor.memory",
			Handler = HandleMemoryCommand,
			HelpString = "Calculates the amount of memory being used.",
		},
		["/mode"] =
		{	
			Alias = {"/gamemode", "/gm"},
			Permission= "basics.architect.mode",
			Handler = HandleChangeGMCommand,
			HelpString = "Changes a player's gamemode.",
		},
		["/motd"] = 
		{
			Permission = "basics.visitor.motd",
			Handler = HandleMOTDCommand,
			HelpString = "Displays the message of the day.",
		},
		["/near"] = 
		{
			Alias = "/nearby",
			Permission = "basics.visitor.nearby",
			Handler = HandleNearbyCommand,
			HelpString = "Lists players who are nearby.",
		},
		["/pardon"] = 
		{
			Alias = "/unban",
			Permission = "basics.mod.pardon",
			Handler = HandlePardonCommand,
			HelpString = "Pardons a player.",
		},
		["/players"] = 
		{
			Alias = {"/list", "/online"},
			Permission = "basics.visitor.players",
			Handler = HandlePlayersCommand,
			HelpString = "Lists players who are connected.",
		},
		["/plugins"] = 
		{
			Alias = "/pl",
			Permission = "basics.visitor.plugins",
			Handler = HandlePluginsCommand,
			HelpString = "Lists configured plugins.",
		},
		["/ranks"] =
		{
			Permission = "basics.visitor.ranks",
			Handler = HandleRanksCommand,
			HelpString = "Lists configured ranks.",
		},
		["/regen"] =
		{
			Alias = "/regenerate",
			Permission = "basics.mod.regen",
			Handler = HandleRegenCommand,
			HelpString = "Regenerates a specific chunk.",
		},
		["/time"] = 
		{
			Alias = "/t",
			Permission = "basics.architect.time",
			Handler = HandleTimeCommand,
			HelpString = "Changes the world's time.",
		},
		["/weather"] = 
		{
			Alias = "/w",
			Permission = "basics.architect.weather",
			Handler = HandleWeatherCommand,
			HelpString = "Changes the world's weather.",
		},
		["/whisper"] = 
		{
			Alias = {"/m", "/message", "/msg"},
			Permission = "basics.visitor.whisper",
			Handler = HandleWhisperCommand,
			HelpString = "Directly messages somebody.",
		},
		["/worlds"] =
		{
			Permission = "basics.visitor.worlds",
			Handler = HandleWorldsCommand,
			HelpString = "Lists configured worlds.",
		},
		["/reload"] = 
		{
			Permission = "basics.mod.reload",
			Handler = HandleReloadCommand,
			HelpString = "Reloads all plugins.",
		},
		["/reply"] = 
		{
			Alias = "/r",
			Permission = "basics.visitor.reply",
			Handler = HandleReplyCommand,
			HelpString = "Directly replies to somebody.",
		},
		["/seed"] = 
		{
			Permission = "basics.visitor.seed",
			Handler = HandleSeedCommand,
			HelpString = "Displays the world's seed.",
		},
		["/save"] = 
		{
			Permission = "basics.mod.save",
			Handler = HandleSaveCommand,
			HelpString = "Saves all worlds to disk.",
		},
		["/spawn"] = 
		{
			Permission = "basics.visitor.spawn",
			Handler = HandleSpawnCommand,
			HelpString = "Takes you to any world's spawn.",
		},
		["/spy"] = 
		{
			Permission = "basics.mod.spy",
			Handler = HandleSpyCommand,
			HelpString = "Spies on the commands of players.",
		},
		["/sudo"] = 
		{
			Permission = "basics.admin.sudo",
			Handler = HandleSudoCommand,
			HelpString = "Executes a command as another player.",
		},
		["/summon"] =
		{
			Alias = {"/mob", "/spawnmob"},
			Permission = "basics.architect.summon",
			Handler = HandleSummonCommand,
			HelpString = "Summons an entity.",
		},
		["/unload"] =
		{
			Permission = "basics.mod.unload",
			Handler = HandleUnloadCommand,
			HelpString = "Unloads chunks with no players in them.",
		},
	}, -- Commands

	ConsoleCommands =
	{
		["assign"] = 
		{
			Handler = HandleConsoleAssign,
			HelpString = "Displays or assigns a player's rank.",
		},
		["ban"] = 
		{
			Handler = HandleConsoleBan,
			HelpString = "Bans a player.",
		},
		["banaddr"] = 
		{
			Handler = HandleConsoleBanIP,
			HelpString = "Bans an address.",
		},
		["chunks"] = 
		{
			Handler = HandleConsoleChunks,
			HelpString = "Lists any chunks in memory.",
		},
		["execute"] = 
		{
			Handler = HandleConsoleExecute,
			HelpString = "Executes a command block with superuser privileges.",
		},
		["pardon"] = 
		{
			Handler = HandleConsolePardon,
			HelpString = "Pardons a player.",
		},
		["pardonaddr"] = 
		{
			Handler = HandleConsolePardonIP,
			HelpString = "Pardons an address.",
		},
		["lag"] = 
		{
			Handler = HandleConsoleLag,
			HelpString = "Calculates the average ticks per second.",
		},
		["memory"] = 
		{
			Handler = HandleConsoleMemory,
			HelpString = "Calculates the amount of memory being used.",
		},
		["mode"] = 
		{
			Handler = HandleConsoleGamemode,
			HelpString = "Changes a player's gamemode.",
		},
		["players"] = 
		{
			Handler = HandleConsolePlayers,
			HelpString = "Lists players who are connected.",
		},
		["plugins"] = 
		{
			Handler = HandleConsolePlugins,
			HelpString = "Lists configured plugins.",
		},
		["ranks"] = 
		{
			Handler = HandleConsoleRanks,
			HelpString = "Lists configured ranks.",
		},
		["regen"] = 
		{
			Handler = HandleConsoleRegen,
			HelpString = "Regenerates a specific chunk.",
		},
		["reloadpl"] = 
		{
			Handler = HandleConsoleReload,
			HelpString = "Reloads all plugins.",
		},
		["save"] = 
		{
			Handler = HandleConsoleSave,
			HelpString = "Saves all worlds to disk.",
		},
		["seed"] = 
		{
			Handler = HandleConsoleSeed,
			HelpString = "Displays the world's seed.",
		},
		["sudo"] = 
		{
			Handler = HandleConsoleSudo,
			HelpString = "Executes a command as a player.",
		},
		["time"] = 
		{
			Handler = HandleConsoleTime,
			HelpString = "Changes the world's time.",
		},
		["unloadch"] = 
		{
			Handler = HandleConsoleUnload,
			HelpString = "Unloads chunks with no players in them.",
		},
		["worlds"] = 
		{
			Handler = HandleConsoleWorlds,
			HelpString = "Lists configured worlds.",
		},
	}, -- ConsoleCommands
} -- g_PluginInfo
