-- commands.lua
-- Implements the /commands command.

-- How many commands should go in one page?
local g_CommandsPerPage = 8

-- Lists the first page of commands beginning with the specified string.
-- If a_Beginning isn't specified, display all permissible commands.
local function handleCommandsPage(a_Player, a_PageNumber, a_Beginning)
	-- Check parameters...
	assert(type(a_PageNumber) == "number")
	assert(tolua.type(a_Player) == "cPlayer")
	a_Beginning = a_Beginning or ""
	assert(type(a_Beginning) == "string")
	
	-- Collect and tabulate commands...
	local output = {}
	local beginLen = a_Beginning:len()
	cPluginManager:Get():ForEachCommand(
		function(a_CBCommand, a_CBPermission, a_CBCommandsString)
			if not (a_Player:HasPermission(a_CBPermission)) then
				-- Don't display non-permissible commands.
				return false
			end
			if (a_CBCommandsString == "") then
				-- Do not display commands without the proper string.
				return false
			end
			-- Does the command contain the wanted string?
			if (a_CBCommand:sub(1, beginLen) == a_Beginning) then
				table.insert(output, a_CBCommand .. "" .. a_CBCommandsString)
			end
		end
	)

	-- Check the number of pages.
	local numCommands = #output
	if (numCommands == 0) then
		a_Player:SendMessageFailure("Could not find any permissible commands.")
		return true
	end
	local firstLine = (a_PageNumber - 1) * g_CommandsPerPage + 1
	local lastLine = firstLine + g_CommandsPerPage
	local maxPages = math.ceil(numCommands / g_CommandsPerPage)
	if (firstLine > numCommands) then
		a_Player:SendMessageFailure("Could not find that page; only pages 1-" .. maxPages .. " exist.")
		return true
	end

	-- Only show what's been requested.
	table.sort(output)
	a_Player:SendMessage(cChatColor.LightGray .. "Commands (" .. a_PageNumber .. "-" .. maxPages .. "):")
	for idx, txt in ipairs(output) do
		if ((idx >= firstLine) and (idx < lastLine)) then
			a_Player:SendMessage(cChatColor.LightGray .. txt)
		end
	end
	return true
end

-- Show the appropriate commands based on the specified parameters.
-- Call the proper worker function.
function HandleCommandsCommand(a_Split, a_Player)
	-- Handles the /commands [page] [string] command.
	-- If there's no valid first parameter, display the first page of commands.
	local numSplit = #a_Split
	if (numSplit == 1) then
		return handleCommandsPage(a_Player, 1)
	end
	
	-- If there's a valid first parameter, display that page.
	local pageRequested = tonumber(a_Split[2])
	local filterStart = 3
	if (pageRequested == nil) then
		filterStart = 2
		pageRequested = 1
	end
	local beginningWanted
	if (numSplit >= filterStart) then
		beginningWanted = "/" .. table.concat(a_Split, " ", filterStart)
	end
	return handleCommandsPage(a_Player, pageRequested, beginningWanted)
end
