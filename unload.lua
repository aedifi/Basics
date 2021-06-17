-- unload.lua
-- Implements the /unload and /chunks commands.

function HandleConsoleUnload(Split)
	local UnloadChunks = function(World)
		World:QueueUnloadUnusedChunks()
	end

    cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Unloaded all vacant chunks at request of console.")
    cRoot:Get():SaveAllChunks()
	cRoot:Get():ForEachWorld(UnloadChunks)
	return true, "Unloaded all vacant chunks."
end

function HandleUnloadCommand(Split, Player)
	local UnloadChunks = function(World)
		World:QueueUnloadUnusedChunks()
	end

    cRoot:Get():BroadcastChat(cChatColor.LightGray .. cChatColor.Italic .. "Unloaded all vacant chunks at request of staff.")
	cRoot:Get():SaveAllChunks()
	cRoot:Get():ForEachWorld(UnloadChunks)
	return true
end

function HandleConsoleChunks(Split)
    local Out = "Chunks: " .. cRoot:Get():GetTotalChunkCount() .. " (loaded)"
    return true, Out
end

function HandleChunksCommand(Split, Player)
    return true, SendMessage(Player, cChatColor.LightGray .. "Chunks: " .. cRoot:Get():GetTotalChunkCount() .. " (loaded)")
end
