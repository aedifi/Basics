-- info.lua
-- Implements the g_PluginInfo standard plugin description.

g_PluginInfo = 
{
	Name = "Basics",
	Version = "1",
	Date = "2020-11-27",
	SourceLocation = "https://github.com/aedifi/basics",
	Description = [[Basic commands and permissions.]],
	
	Commands =
	{
		["/assign"] = 
		{
			Permission = "basics.assign",
			Handler = HandleAssignCommand,
			HelpString = "Displays or assigns a player's rank.",
		},
		["/ban"] = 
		{
			Permission = "basics.ban",
			Handler = HandleBanCommand,
			HelpString = "Bans a player.",
		},
		["/chunks"] = 
		{
			Permission = "basics.chunks",
			Handler = HandleChunksCommand,
			HelpString = "Lists any chunks in memory.",
		},
		["/clear"] = 
		{
			Permission = "basics.clear",
			Handler = HandleClearCommand,
			HelpString = "Clears a player's inventory.",
		},
		["/commands"] = 
		{
			Alias = "/help",
			Permission = "basics.commands",
			Handler = HandleCommandsCommand,
			HelpString = "Lists permissible commands.",
		},
		["/discretion"] = 
		{
			Permission = "basics.discretion",
			Handler = HandleDiscretionCommand,
			HelpString = "Changes if you're spying on players.",
		},
		["/distance"] = 
		{
			Permission = "basics.distance",
			Handler = HandleDistanceCommand,
			HelpString = "Sets your render distance.",
		},
		["/get"] = 
		{
			Permission = "basics.get",
			Handler = HandleGetCommand,
			HelpString = "Gets an item for you.",
		},
		["/goto"] = 
		{
			Permission = "basics.goto",
			Handler = HandleGotoCommand,
			HelpString = "Takes you to any player, coordinates, or random location.",
		},
		["/kick"] = 
		{
			Permission = "basics.kick",
			Handler = HandleKickCommand,
			HelpString = "Kicks a player.",
		},
		["/lag"] = 
		{
			Permission = "basics.lag",
			Handler = HandleLagCommand,
			HelpString = "Calculates the average ticks per second.",
		},
		["/memory"] = 
		{
			Permission = "basics.memory",
			Handler = HandleMemoryCommand,
			HelpString = "Calculates the amount of memory being used.",
		},
		["/mode"] =
		{	
			Permission= "basics.mode",
			Handler = HandleChangeGMCommand,
			HelpString = "Changes a player's gamemode.",
		},
		["/motd"] = 
		{
			Permission = "basics.motd",
			Handler = HandleMOTDCommand,
			HelpString = "Displays the message of the day.",
		},
		["/nearby"] = 
		{
			Permission = "basics.nearby",
			Handler = HandleNearbyCommand,
			HelpString = "Lists players who are nearby.",
		},
		["/pardon"] = 
		{
			Permission = "basics.pardon",
			Handler = HandlePardonCommand,
			HelpString = "Pardons a player.",
		},
		["/players"] = 
		{
			Permission = "basics.players",
			Handler = HandlePlayersCommand,
			HelpString = "Lists players who are connected.",
		},
		["/plugins"] = 
		{
			Permission = "basics.plugins",
			Handler = HandlePluginsCommand,
			HelpString = "Lists configured plugins.",
		},
		["/ranks"] =
		{
			Permission = "basics.ranks",
			Handler = HandleRanksCommand,
			HelpString = "Lists configured ranks.",
		},
		["/regen"] =
		{
			Permission = "basics.regen",
			Handler = HandleRegenCommand,
			HelpString = "Regenerates a specific chunk.",
		},
		["/time"] = 
		{
			Permission = "basics.time",
			Handler = HandleTimeCommand,
			HelpString = "Changes the world's time.",
		},
		["/weather"] = 
		{
			Permission = "basics.weather",
			Handler = HandleWeatherCommand,
			HelpString = "Changes the world's weather.",
		},
		["/whisper"] = 
		{
			Permission = "basics.whisper",
			Handler = HandleWhisperCommand,
			HelpString = "Directly messages somebody.",
		},
		["/worlds"] =
		{
			Permission = "basics.worlds",
			Handler = HandleWorldsCommand,
			HelpString = "Lists configured worlds.",
		},
		["/reload"] = 
		{
			Permission = "basics.reload",
			Handler = HandleReloadCommand,
			HelpString = "Reloads all plugins.",
		},
		["/reply"] = 
		{
			Permission = "basics.reply",
			Handler = HandleReplyCommand,
			HelpString = "Directly replies to somebody.",
		},
		["/seed"] = 
		{
			Permission = "basics.seed",
			Handler = HandleSeedCommand,
			HelpString = "Displays the world's seed.",
		},
		["/save"] = 
		{
			Permission = "basics.save",
			Handler = HandleSaveCommand,
			HelpString = "Saves all worlds to disk.",
		},
		["/spawn"] = 
		{
			Permission = "basics.spawn",
			Handler = HandleSpawnCommand,
			HelpString = "Takes you to any world's spawn.",
		},
		["/spy"] = 
		{
			Permission = "basics.spy",
			Handler = HandleSpyCommand,
			HelpString = "Spies on the commands of players.",
		},
		["/summon"] =
		{
			Permission = "basics.summon",
			Handler = HandleSummonCommand,
			HelpString = "Summons an entity.",
		},
		["/unload"] =
		{
			Permission = "basics.unload",
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
