-- distance.lua
-- Implements the /distance command.

function HandleDistanceCommand(a_Split, a_Player)
    -- Check parameters...
	if (#a_Split ~= 2) then
		SendMessage(a_Player, cChatColor.LightGray .. "Usage: /distance <".. cClientHandle.MIN_VIEW_DISTANCE .." - ".. cClientHandle.MAX_VIEW_DISTANCE ..">")
		return true
	end

	-- Make sure it's a numeric parameter...
	local viewDistance = tonumber(a_Split[2])
	if not(viewDistance) then
		SendMessageFailure(a_Player, "Could not use a non-numeric value (" .. a_Split[2] .. ").")
		return true
	end

	-- Make sure it's not too high...
	if (viewDistance > cClientHandle.MAX_VIEW_DISTANCE) then
		a_Player:SendMessageFailure("Could not set a distance greater than " .. cClientHandle.MAX_VIEW_DISTANCE .. " (MAX_VIEW_DISTANCE).")
		return true
	end

	a_Player:GetClientHandle():SetViewDistance(viewDistance)
	SendMessageSuccess(a_Player, "Set your render distance to " .. a_Player:GetClientHandle():GetViewDistance() .. ".")
	return true
end
