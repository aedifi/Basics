-- time.lua
-- Implements /time and time-related subcommands.

local PlayerTimeCommandUsage = "Usage: /time <day | night | value> [world]"
local ConsoleTimeCommandUsage = "Usage: time <day | night | value> [world]"

-- Translate our arbitrary labels to in-game values.
local SpecialTimesTable = {
	["day"] = 1000,
	["night"] = 1000 + 12000,
}

local TimeAnimationInProgress = false

-- Animates the transition between old and new time values.
local function SetTime(World, TimeToSet)
	local CurrentTime = World:GetTimeOfDay()
    local MaxTime = 24000
    
	-- Handle the cases where TimeToSet < 0 or > 24000.
	TimeToSet = TimeToSet % MaxTime
	local AnimationSpeed = 480
	if CurrentTime > TimeToSet then
		AnimationSpeed = -AnimationSpeed
    end
    
	local function DoAnimation()
		if not TimeAnimationInProgress then
			return
		end
		local TimeOfDay = World:GetTimeOfDay()
		local AnimatedTime = TimeOfDay + AnimationSpeed
		local Animate = (
			((AnimationSpeed > 0) and (AnimatedTime < TimeToSet))
			or ((AnimationSpeed < 0) and (AnimatedTime > TimeToSet))
		)
		if Animate then
			World:SetTimeOfDay(AnimatedTime)
			World:ScheduleTask(1, DoAnimation)
		else
			World:SetTimeOfDay(TimeToSet)
			TimeAnimationInProgress = false
		end
    end
    
	if TimeAnimationInProgress then
		TimeAnimationInProgress = false
		World:SetTimeOfDay(TimeToSet)
	else
		TimeAnimationInProgress = true
		World:ScheduleTask(1, DoAnimation)
    end
	return true
end

local function CommonSetTime(World, Time)
	-- Make sure the world is valid...
	if not World then
		return true
	end
	local TimeToSet = SpecialTimesTable[Time] or tonumber(Time)
	if not TimeToSet then
		return false
	else
		SetTime(World, TimeToSet)
		SendMessage(Player, cChatColor.LightGray .. "Changed the time to " .. TimeToSet .. ".")
	end
	return true
end

-- /time <day | night | value> [world]
function HandleTimeCommand(Split, Player)
	if not CommonSetTime(GetWorld(Split[3], Player), Split[2]) then
		SendMessage(Player, cChatColor.LightGray .. PlayerTimeCommandUsage)
	end
	return true
end

function HandleConsoleTime(a_Split)
	if not CommonSetTime(GetWorld(a_Split[3]), a_Split[2]) then
		LOG(ConsoleTimeCommandUsage)
	end
	return true
end
