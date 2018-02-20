local Mod = RegisterMod("Easter Eggs", 1.0)
local game = Game()

local ItemScript = {}
	local ItemId = {
		EASTEREGG = Isaac.GetItemIdByName("Easter Egg")
	}
	local HasItem = {
		EasterEgg = false
	}
	
	function UpdateItems(player) 
		HasItem.EasterEgg = player:HasCollectible(ItemId.EASTEREGG)
	end
	
	function ItemScript:onPlayerInit(player)
		UpdateItems(player)
	end
	
	function ItemScript:onPefUpdate(player)
		if game:GetFrameCount() == 1 then
			if player:HasCollectible(ItemId.EASTEREGG) and not HasItem.EasterEgg then
				UpdateItems(player)
			end
		end
		
		UpdateItems(player)
	end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, ItemScript.onPlayerInit)
Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ItemScript.onPefUpdate)

local TearVariantScript = {}
	local TearVariant = {
		EGGSHOT = Isaac.GetEntityVariantByName("Egg Shot")
	}
	
	function TearVariantScript:onPefUpdate(player)
		if HasItem.EasterEgg then
			for _, entity in pairs(Isaac.GetRoomEntities()) do
				local data = entity:GetData()
				if entity.Type == EntityType.ENTITY_TEAR then
					local tear = entity:ToTear()
					if entity.Variant ~= TearVariant.EGGSHOT and data.ChangedTear == nil then
						local dice = player:GetCollectibleRNG(ItemId.EASTEREGG)
						if dice:RandomFloat() < math.sqrt((player.Luck+1))/10 then
							data.ChangedTear = true
							tear:ChangeVariant(TearVariant.EGGSHOT)
						else
							data.ChangedTear = false
						end
					else
						if data.ChangedTear == true and (tear.Height >= -5 or tear:CollidesWithGrid()) and data.MadeCreep == nil then
							local dice = player:GetCollectibleRNG(ItemId.EASTEREGG)
							if dice:RandomFloat() < 0.1 then
								data.MadeCreep = true
								data.Shell1 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TOOTH_PARTICLE, 0, tear.Position, Vector(0,0), player):ToEffect()
								data.Shell1:SetColor(Color(1.0,1.0,1.0,0,0,0,0),0,0,false,false)
								data.Shell1:GetData().EggShot = true
								data.Shell2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TOOTH_PARTICLE, 0, tear.Position, Vector(0,0), player):ToEffect()
								data.Shell2:SetColor(Color(1.0,1.0,1.0,0,0,0,0),0,0,false,false)
								data.Shell2:GetData().EggShot = true
								data.Creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE, 0, tear.Position, Vector(0,0), player):ToEffect()
								data.Creep:SetColor(Color(1.0,1.0,1.0,0,0,0,0),0,0,false,false)
								data.Creep:GetData().EggShot = true
							else
								data.MadeCreep = true
								data.Shell1 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TOOTH_PARTICLE, 0, tear.Position, Vector(0,0), player):ToEffect()
								data.Shell1:SetColor(Color(1.0,1.0,1.0,0,0,0,0),0,0,false,false)
								data.Shell1:GetData().EggShot = true
								data.Shell2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TOOTH_PARTICLE, 0, tear.Position, Vector(0,0), player):ToEffect()
								data.Shell2:SetColor(Color(1.0,1.0,1.0,0,0,0,0),0,0,false,false)
								data.Shell2:GetData().EggShot = true
							end
						end
					end
				end
				if entity.Type == EntityType.ENTITY_EFFECT and data.EggShot ~= nil then
					entity:SetColor(Color(1.0,1.0,1.0,1.0,0,0,0),0,0,false,false)
				end
			end
		end
	end
	
	function TearVariantScript:onDamage(entity, amt, flag, source, countdown)
		local player = game:GetPlayer(0)
		if source.Type == EntityType.ENTITY_TEAR and source.Variant == TearVariant.EGGSHOT then
			local dice = player:GetCollectibleRNG(ItemId.EASTEREGG)
			if dice:RandomFloat() < math.sqrt((player.Luck+1))/10 then
				entity:AddConfusion(source, 60, true)
			end
			entity:TakeDamage(player.Damage, 0, EntityRef(player), 0)
		end
	end
Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, TearVariantScript.onPefUpdate)
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, TearVariantScript.onDamage)