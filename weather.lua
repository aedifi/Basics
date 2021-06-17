-- weather.lua
-- Implements weather-related standards and /weather.

-- Make proper values out of descriptors.
local WeatherNames =
{
	["sunny"] = wSunny,
	["rainy"] = wRain,
	["stormy"] = wStorm,
}

-- Strings displayed when changing to the specified conditions.
local WeatherChanges =
{
	[wSunny] = "Changed the weather to sunny.",
	[wRain]  = "Changed the weather to rainy.",
	[wStorm] = "Changed the weather to stormy.",
}

function HandleWeatherCommand(Split, Player)
	local Response

	-- Parse the command into components...
	local Weather = WeatherNames[Split[2]]
	local TPS = 20
	local TicksToChange = (tonumber(Split[3]) or 0) * TPS
	local WorldName = Split[4]

	if not tonumber(Split[3]) then
		WorldName = Split[3]
	end
	
	local World = GetWorld(WorldName, Player)  -- Function is in functions.lua.

	if not Weather then
		Response = SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <sunny | rainy | stormy> [ticks] [world]")
	elseif not World then
		Response = SendMessage(Player, cChatColor.LightGray .. "Couldn't find that world.")
	else
		World:SetWeather(Weather)

		if TicksToChange ~= 0 then
			World:SetTicksUntilWeatherChange(TicksToChange)
		end
		
		Response = SendMessage(Player, cChatColor.LightGray .. WeatherChanges[Weather])
	end
	return true, Response
end
