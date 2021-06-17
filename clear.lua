-- clear.lua
-- Implements the /clear command.

function HandleClearCommand(Split, Player)

    if (Split[2] == nil) then
        Player:GetInventory():Clear()
        LOGINFO(Player:GetName() .. " cleared their inventory.")
        SendMessageSuccess(Player, cChatColor.LightGray .. "Cleared your own inventory.")
        return true
    end

    -- If they have the permission to clear other people's inventories, let them.
    if Player:HasPermission("basics.clear.others") then
        local InventoryCleared = false
        local ClearInventory = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                OtherPlayer:GetInventory():Clear()
                InventoryCleared = true
            end
        end

        cRoot:Get():FindAndDoWithPlayer(Split[2], ClearInventory)
        if (InventoryCleared) then
            LOGINFO(Player:GetName() .. " cleared the inventory of " .. Split[2] .. ".")
            SendMessageSuccess(Player, cChatColor.LightGray .. "Cleared the inventory of " .. Split[2] .. ".")
        else
            SendMessageFailure(Player, cChatColor.LightGray .. "Couldn't find that player.")
        end

        return true
    end

    return false

end