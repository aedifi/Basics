-- save-reload.lua
-- Implements the /save and /reload commands.
  
function HandleConsoleSave(Split)
	cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Saved all worlds to disk at request of console.")
	LOG("Saved all worlds to disk.")
	cRoot:Get():SaveAllChunks()
	return true
end

function HandleSaveCommand(Split, Player)
	cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Saved all worlds to disk at request of staff.")
	cRoot:Get():SaveAllChunks()
	return true
end

function HandleConsoleReload(Split)
	cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Reloaded all plugins at request of console.")
	LOG("Reloaded all plugins.")
	cRoot:Get():GetPluginManager():ReloadPlugins()
	return true
end

function HandleReloadCommand(Split, Player)
	cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Reloaded all plugins at request of staff.")
	cRoot:Get():GetPluginManager():ReloadPlugins()
	return true
end
