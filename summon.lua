-- summon.lua
-- Implements the /summon command and declares mob aliases.

local Minecarts =
{
	["minecart"] = E_ITEM_MINECART,
	["chest_minecart"] = E_ITEM_CHEST_MINECART,
	["furnace_minecart"] = E_ITEM_FURNACE_MINECART,
	["hopper_minecart"] = E_ITEM_MINECART_WITH_HOPPER,
	["tnt_minecart"] = E_ITEM_MINECART_WITH_TNT,

	-- For 1.10 and below.
	["MinecartChest"] = E_ITEM_CHEST_MINECART,
	["MinecartFurnace"] = E_ITEM_FURNACE_MINECART,
	["MinecartHopper"] = E_ITEM_MINECART_WITH_HOPPER,
	["MinecartRideable"] = E_ITEM_MINECART,
	["MinecartTNT"] = E_ITEM_MINECART_WITH_TNT
}

local Mobs =
{
	["bat"] = mtBat,
	["blaze"] = mtBlaze,
	["cave_spider"] = mtCaveSpider,
	["chicken"] = mtChicken,
	["cow"] = mtCow,
	["creeper"] = mtCreeper,
	["ender_dragon"] = mtEnderDragon,
	["enderman"] = mtEnderman,
	["ghast"] = mtGhast,
	["giant"] = mtGiant,
	["guardian"] = mtGuardian,
	["horse"] = mtHorse,
	["iron_golem"] = mtIronGolem,
	["magma_cube"] = mtMagmaCube,
	["mooshroom"] = mtMooshroom,
	["ocelot"] = mtOcelot,
	["pig"] = mtPig,
	["rabbit"] = mtRabbit,
	["sheep"] = mtSheep,
	["silverfish"] = mtSilverfish,
	["skeleton"] = mtSkeleton,
	["slime"] = mtSlime,
	["snowman"] = mtSnowGolem,
	["spider"] = mtSpider,
	["squid"] = mtSquid,
	["villager"] = mtVillager,
	["witch"] = mtWitch,
	["wither"] = mtWither,
	["wolf"] = mtWolf,
	["zombie"] = mtZombie,
	["zombie_pigman"] = mtZombiePigman,

	-- For 1.10 and below.
	["Bat"] = mtBat,
	["Blaze"] = mtBlaze,
	["CaveSpider"] = mtCaveSpider,
	["Chicken"] = mtChicken,
	["Cow"] = mtCow,
	["Creeper"] = mtCreeper,
	["EnderDragon"] = mtEnderDragon,
	["Enderman"] = mtEnderman,
	["Ghast"] = mtGhast,
	["Giant"] = mtGiant,
	["Guardian"] = mtGuardian,
	["Horse"] = mtHorse,
	["LavaSlime"] = mtMagmaCube,
	["MushroomCow"] = mtMooshroom,
	["Ozelot"] = mtOcelot,
	["Pig"] = mtPig,
	["Rabbit"] = mtRabbit,
	["Sheep"] = mtSheep,
	["Silverfish"] = mtSilverfish,
	["Skeleton"] = mtSkeleton,
	["Slime"] = mtSlime,
	["SnowMan"] = mtSnowGolem,
	["Spider"] = mtSpider,
	["Squid"] = mtSquid,
	["Villager"] = mtVillager,
	["VillagerGolem"] = mtIronGolem,
	["Witch"] = mtWitch,
	["Wither"] = mtWither,
	["Wolf"] = mtWolf,
	["Zombie"] = mtZombie,
	["PigZombie"] = mtZombiePigman
}

local Projectiles =
{
	["arrow"] = cProjectileEntity.pkArrow,
	["egg"] = cProjectileEntity.pkEgg,
	["ender_pearl"] = cProjectileEntity.pkEnderPearl,
	["fireworks_rocket"] = cProjectileEntity.pkFirework,
	["fireball"] = cProjectileEntity.pkGhastFireball,
	["potion"] = cProjectileEntity.pkSplashPotion,
	["small_fireball"] = cProjectileEntity.pkFireCharge,
	["snowball"] = cProjectileEntity.pkSnowball,
	["wither_skull"] = cProjectileEntity.pkWitherSkull,
	["xp_bottle"] = cProjectileEntity.pkExpBottle,

	-- For 1.10 and below.
	["Arrow"] = cProjectileEntity.pkArrow,
	["Fireball"] = cProjectileEntity.pkGhastFireball,
	["FireworksRocketEntity"] = cProjectileEntity.pkFirework,
	["SmallFireball"] = cProjectileEntity.pkFireCharge,
	["Snowball"] = cProjectileEntity.pkSnowball,
	["ThrownEgg"] = cProjectileEntity.pkEgg,
	["ThrownEnderpearl"] = cProjectileEntity.pkEnderPearl,
	["ThrownExpBottle"] = cProjectileEntity.pkExpBottle,
	["ThrownPotion"] = cProjectileEntity.pkSplashPotion,
	["WitherSkull"] = cProjectileEntity.pkWitherSkull
}

-- function HandleEntitiesCommand(a_Split, a_Player)
-- 	a_Player:SendMessage(cChatColor.LightGray .. "Entities (36): arrow, bat, blaze, cave_spider, chest_minecart, chicken, cow, creeper, ender_dragon, enderman, furnace_minecart, ghast, giant, guardian, hopper_minecart, horse, iron_golem, magma_cube, mooshroom, ocelot, pig, rabbit, sheep, silverfish, skeleton, slime, snowman, spider, squid, tnt_minecart, villager, witch, wither, wolf, zombie, zombie_pigman")
-- 	return true
-- end

local function RelativeCommandCoord(a_Split, a_Relative)
	if string.sub(a_Split, 1, 1) == "~" then
		local rel = tonumber(string.sub(a_Split, 2, -1))
		if rel then
			return a_Relative + rel
		end
		return a_Relative
	end
	return tonumber(a_Split)
end

local function SpawnEntity(EntityName, World, X, Y, Z)
	if EntityName == "boat" or EntityName == "Boat" then
		local Material = cBoat.bmOak

		World:SpawnBoat(Vector3d(X, Y, Z), Material)
	elseif EntityName == "falling_block" or EntityName == "FallingSand" then
		local BlockType = E_BLOCK_SAND
		local BlockMeta = 0

		World:SpawnFallingBlock(Vector3i(X, Y, Z), BlockType, BlockMeta)
	elseif EntityName == "lightning_bolt" or EntityName == "LightningBolt" then
		World:CastThunderbolt(Vector3i(X, Y, Z))
	elseif Minecarts[EntityName] then
		World:SpawnMinecart(Vector3d(X, Y, Z), Minecarts[EntityName])
	elseif Mobs[EntityName] then
		World:SpawnMob(X, Y, Z, Mobs[EntityName])
	elseif Projectiles[EntityName] then
		World:CreateProjectile(Vector3d(X, Y, Z), Projectiles[EntityName], Player, Player:GetEquippedItem(), Player:GetLookVector() * 20)
	elseif EntityName == "tnt" or EntityName == "PrimedTnt" then
		World:SpawnPrimedTNT(Vector3d(X, Y, Z))
	elseif EntityName == "xp_orb" or EntityName == "XPOrb" then
		local Reward = 1

		World:SpawnExperienceOrb(Vector3d(X, Y, Z), Reward)
	elseif EntityName == "ender_crystal" or EntityName == "EnderCrystal" then
		World:SpawnEnderCrystal(Vector3d(X, Y, Z), false)
	else
		return false
	end
	return true
end

function HandleSummonCommand(Split, Player)
	if not Split[2] then
		Player:SendMessage(cChatColor.LightGray .. "Usage: " .. Split[1] .. " <entity> [x] [y] [z]")
	else
		local X = Player:GetPosX()
		local Y = Player:GetPosY()
		local Z = Player:GetPosZ()
		local World = Player:GetWorld()

		if Split[3] then
			X = RelativeCommandCoord(Split[3], X)
		end

		if Split[4] then
			Y = RelativeCommandCoord(Split[4], Y)
		end

		if Split[5] then
			Z = RelativeCommandCoord(Split[5], Z)
		end

		if not X then
			Player:SendMessageFailure("Could not use a non-numeric coordinate (" .. Split[3] .. ").")
			return true
		end

		if not Y then
			Player:SendMessageFailure("Could not use a non-numeric coordinate (" .. Split[4] .. ").")
			return true
		end

		if not Z then
			Player:SendMessageFailure("Could not use a non-numeric coordinate (" .. Split[5] .. ").")
			return true
		end

		if SpawnEntity(Split[2], World, X, Y, Z) then
			Player:SendMessageSuccess("Summoned an entity at X: " .. math.floor(X) .. ", Y: " .. math.floor(Y) .. ", Z: " .. math.floor(Z) .. ".")
		else
			Player:SendMessageFailure("Could not find that entity (" .. Split[2] .. ").")
		end
	end
	return true
end
