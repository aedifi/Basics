-- time.lua
-- Implements /time and time-related subcommands.

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
		return false
	end
	local TimeToSet = SpecialTimesTable[Time] or tonumber(Time)
	if not TimeToSet then
		return false
	else
		SetTime(World, TimeToSet)	
	end
	return true
end

-- /time <day | night | value> [world]
function HandleTimeCommand(Split, Player)
	if not GetWorld(Split[3], Player) then
		return true
	elseif not CommonSetTime(GetWorld(Split[3], Player), Split[2]) then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <day | night | value> [world]")
	elseif Split[3] == nil then
        SendMessageSuccess(Player, "Set the time to " .. Split[2] .. ".")
    else
        SendMessageSuccess(Player, "Set that world's time to " .. Split[2] .. " (" .. Split[3] .. ").")
    end
	return true
end

function HandleConsoleTime(a_Split)
	if not GetWorld(Split[3], Player) then
		return true, "Could not find that world, did you use Caps?"
	elseif not CommonSetTime(GetWorld(a_Split[3]), a_Split[2]) then
--		LOG(ConsoleTimeCommandUsage)
		return true, "Usage: " .. a_Split[1] .. " <day | night | value> [world]"
	elseif Split[3] == nil then
		return true, "Set the spawn world's time to " .. a_Split[2] .. "."
	else
		return true, "Set that world's time to " .. a_Split[2] .. " (" .. a_Split[3] .. ")."
	end
end
