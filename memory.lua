-- memory.lua
-- Implements the /memory command and converts memory usage to megabytes.

function HandleConsoleMemory(Split)
	LOG("Memory (in MB): " .. math.floor(cRoot:GetPhysicalRAMUsage() / 1024 + 0.5) .. " + " .. math.floor(cRoot:GetVirtualRAMUsage() / 1024 + 0.5) .. " = " .. math.floor(cRoot:GetPhysicalRAMUsage() / 1024 + cRoot:GetVirtualRAMUsage() / 1024 + 0.5) .. " (used) / 500 MB (total)")
	return true
end

function HandleMemoryCommand(Split, Player)
    Player:SendMessage(cChatColor.LightGray .. "Memory (in MB): " .. math.floor(cRoot:GetPhysicalRAMUsage() / 1024 + 0.5) .. " (physical) + " .. math.floor(cRoot:GetVirtualRAMUsage() / 1024 + 0.5) .. " (virtual) / 500 MB (total)")
	return true
end
