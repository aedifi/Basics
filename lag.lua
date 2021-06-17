-- lag.lua
-- Implements the /lag command and calculates an average ticks per second.

TpsCache = {}
GlobalTps = {}

function HandleConsoleLag(Split)
	LOG("Tick(s)/s: " .. GetAverageNum(GlobalTps))
	return true
end

function HandleLagCommand(Split, Player)
	Player:SendMessage(cChatColor.LightGray .. "Ticks (in T/S): " .. GetAverageNum(GlobalTps))
	return true
end

function GetAverageNum(Table)
	local Sum = 0
	for i,Num in ipairs(Table) do
		Sum = Sum + Num
	end
	return math.floor(Sum / #Table * 100) / 100
end

function OnWorldTick(World, TimeDelta)
	local WorldTps = TpsCache[World:GetName()]
	if (WorldTps == nil) then
		WorldTps = {}
		TpsCache[World:GetName()] = WorldTps
	end

	if (#WorldTps >= 10) then
		table.remove(WorldTps, 1)
	end

	table.insert(WorldTps, 1000 / TimeDelta)
end

function OnTick(TimeDelta)
	if (#GlobalTps >= 10) then
		table.remove(GlobalTps, 1)
	end

	table.insert(GlobalTps, 1000 / TimeDelta)
end
