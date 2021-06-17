-- plugins.lua
-- Implements the /plugins command.

function HandleConsolePlugins(a_Split, a_Player)
	-- Parse the parameters for plugin statuses to display.
	local IncludePluginStatus = {}
	-- Map of status, or the "true" for plugins to show.
	local idx = 2
	while (a_Split[idx]) do
		local param = a_Split[idx]
		idx = idx + 1
		if (param == "all") then
			IncludePluginStatus[cPluginManager.psLoaded]   = true
			IncludePluginStatus[cPluginManager.psUnloaded] = true
			IncludePluginStatus[cPluginManager.psError]    = true
			IncludePluginStatus[cPluginManager.psNotFound] = true
			IncludePluginStatus[cPluginManager.psDisabled] = true
		elseif (param == "loaded") then
			IncludePluginStatus[cPluginManager.psLoaded] = true
		elseif (param == "unloaded") then
			IncludePluginStatus[cPluginManager.psUnloaded] = true
		elseif ((param == "errored") or (param == "error") or (param == "errorred")) then
			IncludePluginStatus[cPluginManager.psError] = true
		elseif (param == "notfound") then
			IncludePluginStatus[cPluginManager.psNotFound] = true
		elseif (param == "disabled") then
			IncludePluginStatus[cPluginManager.psDisabled] = true
		end
	end
	if not(a_Split[2]) then
		-- Show only psLoaded plugins...
		IncludePluginStatus[cPluginManager.psLoaded] = true
	end
	
	-- Enumerate the plugins.
	local PluginTable = {}
	cPluginManager:Get():ForEachPlugin(
		function (a_CBPlugin)
			table.insert(PluginTable,
				{
					Name = a_CBPlugin:GetName(),
					Folder = a_CBPlugin:GetFolderName(),
					Status = a_CBPlugin:GetStatus(),
					LoadError = a_CBPlugin:GetLoadError()
				}
			)
		end
	)
	table.sort(PluginTable,
		function (a_Plugin1, a_Plugin2)
			return (string.lower(a_Plugin1.Folder) < string.lower(a_Plugin2.Folder))
		end
	)
	
	-- Prepare a translation table for the status.
	local StatusName =
	{
		[cPluginManager.psLoaded]   = "Loaded  ",
		[cPluginManager.psUnloaded] = "Unloaded",
		[cPluginManager.psError]    = "Error   ",
		[cPluginManager.psNotFound] = "NotFound",
		[cPluginManager.psDisabled] = "Disabled",
	}
	
	-- Generate the name and ratio.
	local Out = {}
	local HasAnyListed = false
	table.insert(Out, "Plugins (")
	table.insert(Out, cPluginManager:Get():GetNumLoadedPlugins())
	table.insert(Out, "/")
	table.insert(Out, #PluginTable)
	table.insert(Out, "):")
	
	-- Generate the list of plugins.
	local OutPlugins = {}
	local HasAnyListed = false
	for _, plg in ipairs(PluginTable) do
		if (IncludePluginStatus[plg.Status]) then
			table.insert(OutPlugins, plg.Folder)
			if (plg.Name ~= plg.Folder) then
				table.insert(OutPlugins, " (API name ")
				table.insert(OutPlugins, plg.Name)
				table.insert(OutPlugins, ")")
			end
			-- if (plg.Status == cPluginManager.psError) then
			-- 	table.insert(Out, " ERROR: ")
			-- 	table.insert(Out, plg.LoadError or "<unknown>")
			-- end
			HasAnyListed = true
		end
	end
	if not(HasAnyListed) then
		table.insert(OutPlugins, "n/a")
	end
	
	-- Send output to player.
	LOG(table.concat(Out) .. " " .. table.concat(OutPlugins, ", "))
	return true
end

function HandlePluginsCommand(a_Split, a_Player)
	-- Parse the parameters for plugin statuses to display.
	local IncludePluginStatus = {}
	-- Map of status, or the "true" for plugins to show.
	local idx = 2
	while (a_Split[idx]) do
		local param = a_Split[idx]
		idx = idx + 1
		if (param == "all") then
			IncludePluginStatus[cPluginManager.psLoaded]   = true
			IncludePluginStatus[cPluginManager.psUnloaded] = true
			IncludePluginStatus[cPluginManager.psError]    = true
			IncludePluginStatus[cPluginManager.psNotFound] = true
			IncludePluginStatus[cPluginManager.psDisabled] = true
		elseif (param == "loaded") then
			IncludePluginStatus[cPluginManager.psLoaded] = true
		elseif (param == "unloaded") then
			IncludePluginStatus[cPluginManager.psUnloaded] = true
		elseif ((param == "errored") or (param == "error") or (param == "errorred")) then
			IncludePluginStatus[cPluginManager.psError] = true
		elseif (param == "notfound") then
			IncludePluginStatus[cPluginManager.psNotFound] = true
		elseif (param == "disabled") then
			IncludePluginStatus[cPluginManager.psDisabled] = true
		end
	end
	if not(a_Split[2]) then
		-- Show only psLoaded plugins...
		IncludePluginStatus[cPluginManager.psLoaded] = true
	end
	
	-- Enumerate the plugins.
	local PluginTable = {}
	cPluginManager:Get():ForEachPlugin(
		function (a_CBPlugin)
			table.insert(PluginTable,
				{
					Name = a_CBPlugin:GetName(),
					Folder = a_CBPlugin:GetFolderName(),
					Status = a_CBPlugin:GetStatus(),
					LoadError = a_CBPlugin:GetLoadError()
				}
			)
		end
	)
	table.sort(PluginTable,
		function (a_Plugin1, a_Plugin2)
			return (string.lower(a_Plugin1.Folder) < string.lower(a_Plugin2.Folder))
		end
	)
	
	-- Prepare a translation table for the status.
	local StatusName =
	{
		[cPluginManager.psLoaded]   = "Loaded  ",
		[cPluginManager.psUnloaded] = "Unloaded",
		[cPluginManager.psError]    = "Error   ",
		[cPluginManager.psNotFound] = "NotFound",
		[cPluginManager.psDisabled] = "Disabled",
	}
	
	-- Generate the name and ratio.
	local Out = {}
	local HasAnyListed = false
	table.insert(Out, "Plugins (")
	table.insert(Out, cPluginManager:Get():GetNumLoadedPlugins())
	table.insert(Out, "/")
	table.insert(Out, #PluginTable)
	table.insert(Out, "):")
	
	-- Generate the list of plugins.
	local OutPlugins = {}
	local HasAnyListed = false
	for _, plg in ipairs(PluginTable) do
		if (IncludePluginStatus[plg.Status]) then
			table.insert(OutPlugins, plg.Folder)
			if (plg.Name ~= plg.Folder) then
				table.insert(OutPlugins, " (API name ")
				table.insert(OutPlugins, plg.Name)
				table.insert(OutPlugins, ")")
			end
			-- if (plg.Status == cPluginManager.psError) then
			-- 	table.insert(Out, " ERROR: ")
			-- 	table.insert(Out, plg.LoadError or "<unknown>")
			-- end
			HasAnyListed = true
		end
	end
	if not(HasAnyListed) then
		table.insert(OutPlugins, "n/a")
	end
	
	-- Send output to player.
	SendMessage(a_Player, cChatColor.LightGray .. table.concat(Out) .. " " .. table.concat(OutPlugins, ", "))
	return true
end
