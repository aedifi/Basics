-- clear.lua
-- Implements the /clear command.

function HandleClearCommand(Split, Player)
    if (Split[2] == nil) then
        Player:GetInventory():Clear()
        LOGINFO(Player:GetName() .. " cleared their inventory.")
        SendMessageSuccess(Player, "Cleared your inventory.")
        return true
    end

    -- If they have the permission to clear other people's inventories, let them.
    if Player:HasPermission("basics.mod.clear") then
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
            SendMessageSuccess(Player, "Cleared the inventory of " .. Split[2] .. ".")
        else
            SendMessageFailure(Player, "Could not find that player, are they online?")
        end

        return true
    end

    return false
end

function HandleItemCommand(Split,Player)
	local Item = cItem()
	if Split[2] == nil then
		local ItemString = ItemToString(Player:GetEquippedItem())
		local Item = Player:GetEquippedItem()
		Player:SendMessage(cChatColor.LightGray .. "The item(s) in your hand are " .. Item.m_ItemCount .. " " .. ItemString .. " with an ID of " .. Item.m_ItemType .. ".")
	elseif StringToItem(Split[2], Item) then
		Player:SendMessage(cChatColor.LightGray .. "The item in your hand is " .. ItemToString(Item) .. " with an ID of " .. Item.m_ItemType .. ".")
	else
		Player:SendMessageFailure("Could not find an item in your hand, is it too new?")
	end
	return true
end
