-- protection.lua
-- Implements spawn protection.

local function IsInSpawn(X, Y, Z, WorldName)
	local ProtectRadius = WorldsSpawnProtect[WorldName]

	if ProtectRadius > 0 then
		local World = cRoot:Get():GetWorld(WorldName)
		local SpawnArea = cBoundingBox(Vector3d(World:GetSpawnX() - ProtectRadius, -1000, World:GetSpawnZ() - ProtectRadius), Vector3d(World:GetSpawnX() + ProtectRadius, 1000, World:GetSpawnZ() + ProtectRadius))
		local PlayerLocation = Vector3d(X, Y, Z)

		if SpawnArea:IsInside(PlayerLocation) then
			return true
		end
	end
end

local function CheckBlockModification(Player, BlockX, BlockY, BlockZ)
	-- If they don't have the edits.build permission, don't let them build and send this failure message.
	if not Player:HasPermission("basics.build") then
		SendMessageFailure(Player, cChatColor.LightGray .. "Couldn't build because you're not permitted.")
		return true
	end

	-- If they don't have the edits.spawnprotect.bypass permission and they're in spawn, do the same thing.
	if not Player:HasPermission("basics.spawnprotect.bypass") and IsInSpawn(BlockX, BlockY, BlockZ, Player:GetWorld():GetName()) then
		SendMessageFailure(Player, cChatColor.LightGray .. "Couldn't build this close to spawn.")
		return true
	end
end

function OnBlockSpread(World, BlockX, BlockY, BlockZ, Source)
	if Source == ssFireSpread and IsInSpawn(BlockX, BlockY, BlockZ, World:GetName()) then
		return true
	end

end

function OnExploding(World, ExplosionSize, CanCauseFire, X, Y, Z, Source, SourceData)
	if IsInSpawn(X, Y, Z, World:GetName()) then
		return true
	end
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, Status, OldBlockType, OldBlockMeta)
	return CheckBlockModification(Player, BlockX, BlockY, BlockZ)
end

function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
	return CheckBlockModification(Player, BlockX, BlockY, BlockZ)
end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	if not Player:HasPermission("basics.spawnprotect.bypass") and IsInSpawn(BlockX, BlockY, BlockZ, Player:GetWorld():GetName()) then
		local Block = Player:GetWorld():GetBlock(Vector3i(BlockX, BlockY, BlockZ))
		if Block == E_BLOCK_GRASS or Block == E_BLOCK_DIRT then
			if Player:GetEquippedItem():IsEmpty() then
				return false
			end
		end

		if Player:GetEquippedItem().m_ItemType ~= E_ITEM_FLINT_AND_STEEL and
				Player:GetEquippedItem().m_ItemType ~= E_ITEM_FIRE_CHARGE then
			return false
		end

		-- Send the failure message.
		SendMessageFailure(Player, cChatColor.LightGray .. "Couldn't build this close to spawn.")
		return true
	end
end

function OnExploding(World, ExplosionSize, CanCauseFire, X, Y, Z, Source, SourceData)
	g_SpawnRadius = -1
	if g_SpawnRadius < 0 then
		return true
	end
	local SpawnX = World:GetSpawnX()
	local SpawnY = World:GetSpawnY()
	local SpawnZ = World:GetSpawnZ()
	local SpawnVector = Vector3d(SpawnX, SpawnY, SpawnZ)
	local ExplosionCoords = Vector3d(X, Y, Z)
	local Distance = (SpawnVector - ExplosionCoords):Length() + ExplosionSize
	if Distance < g_SpawnRadius then
		return true
	end
	return false
end
