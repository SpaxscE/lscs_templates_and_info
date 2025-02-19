if true then return end

ALL ADDITIONAL LSCS SCRIPTS SHOULD GO INTO lua/lscs/content TO MAKE SURE THEY ARE LOADED AFTER THE BASESCRIPT IS LOADED. CONTENT IS ALWAYS SHARED


--[[---------------------
	GENERAL STUFF
--]]---------------------


LSCS:RegisterDeflectableTracer( "tracer_" ) -- MUST BE CALLED SHARED.
					    -- register all bullets with the tracername "tracer_" to be able to be deflected.
					    -- Internaly it just calls string.match() on this name so you dont have to register hundreds of tracers with different colors
					    -- Most likely not all tracers will visually deflect. Really depends on how they are coded.
					    -- All non registered tracers are still blockable but not deflectable.

data = LSCS:ClassToItem( entity_class ) -- gets the item-data of given class such as item_crystal_amethyst. Works Shared.

-- alternative you can call this directly if you already know what you are looking for:
data = LSCS:GetHilt( name_id )
data = LSCS:GetBlade( name_id )
data = LSCS:GetStance( name_id )
data = LSCS:GetForce( name_id )


LSCS:OpenMenu() -- opens the menu, only works clientside. Menu can be opened using console command "lscs_openmenu" aswell
LSCS:RefreshMenu() -- refreshes the menu if open. Only works clientside. Needs to be called everytime something is removed, added or equipped/unequipped


--[[---------------------
	CLIENT
--]]---------------------

-- very similar to gmods HUDShouldDraw, however instead of strings it takes "enums"

local hide = {
	[LSCS_HUD_POINTS_FORCE] = true, -- disable force hud on bottom right
	[LSCS_HUD_POINTS_BLOCK] = true, -- disable block points (red bars)
	[LSCS_HUD_POINTS_ADVANTAGE] = true, -- disable advantage (yellow bars)
	[LSCS_HUD_STANCE] = true,	-- disable stance information
}

hook.Add( "LSCS:HUDShouldDraw", "ANY_HOOK_NAME_YOU_WANT", function( name )
	if hide[ name ] then
		return false
	end
end )




--[[---------------------
	SERVER
--]]---------------------

-- called when a player attempts to pick up an item
hook.Add( "LSCS:PlayerInventory", "any_name_you_want", function( ply, classname, index )

 	--this example will allow admins only to pick up katarn saber hilt
	if not ply:IsAdmin() and item == "item_saberhilt_katarn" then
		return true -- returning true will prevent picking up
	end

end )

-- called after the player has picked up an item
hook.Add( "LSCS:PostPlayerInventory", "any_name_you_want", function( ply, classname, index )
end )

-- this is called when the player is fully loaded and ready
hook.Add( "LSCS:OnPlayerFullySpawned", "ANY_HOOK_NAME_YOU_WANT", function( ply )
	print("hello")
end )

-- when a player drops an item from the inventory it calls this hook. 
hook.Add( "LSCS:OnPlayerDroppedItem", "ANY_HOOK_NAME_YOU_WANT", function( ply, item_entity, inventory_id, classname )

	item_entity:Remove() -- lets just remove it in this example

end )

-- when a player finished crafting a lightsaber this hook is called. This is also called everytime a player spawns with a lightsaber as it just auto-crafts it after it has been crafted once.
hook.Add( "LSCS:OnPlayerCraftedSaber", "ANY_HOOK_NAME_YOU_WANT", function( ply, weapon_entity )

end )

-- called whenever a player equips an item
hook.Add( "LSCS:OnPlayerEquippedItem", "ANY_HOOK_NAME_YOU_WANT", function( ply, item, is_right_hand, inventory_id )
end)

-- called whenever a player unequips an item
hook.Add( "LSCS:OnPlayerUnEquippedItem", "ANY_HOOK_NAME_YOU_WANT", function( ply, item, inventory_id )
end)

-- same as GM:EntityFireBullets, except by using this hook it wont conflict with LSCS. Get's called AFTER LSCS code is run
hook.Add( "LSCS:EntityFireBullets", "ANY_HOOK_NAME_YOU_WANT", function( entity, bullet )
end)

-- called when a player tries to start using a force power
hook.Add( "LSCS:OnPlayerForceUse", "ANY_HOOK_NAME_YOU_WANT", function( ply, id, item )

	-- disallow saber throw useage example
	if id == "throw" then
		return false
	end
end)

ply:lscsAddInventory( class_or_entity, equip_to_hand ) -- add a entity to the players inventory. Can be given a classname instead of a entity aswell. Only supports sents.
							equip_to_hand = 
					 				true -- equip to right hand
									false -- equip to left hand
					 				nil -- don't equip



ply:lscsEquipItem( index, equip_to_hand ) -- equip a item from inventory. Index is just the numerical id of the item in the inventory table
							equip_to_hand = 
					 				true -- equip to right hand
									false -- equip to left hand
					 				nil -- don't equip


ply:lscsSyncInventory() -- send a full sync to the client. Should never be needed.

ply:lscsWipeInventory( wipe_unequipped ) -- clears the entire inventory. If wipe_unequipped = true will only clear unequipped items from inventory

ply:lscsRemoveItem( id ) -- just remove given numerical index id from inventory. This will also unequip automatically. Will only send a remove request to server when called on client

stuff_valid = ply:lscsIsValid() -- the items they have equipped, could they in theory successfully craft a working lightsaber? This can be used to prevent crafting broken lightsabers

bool_force_allowed = ply:lscsGetForceAllowed() -- returns whenever or not the player is allowed to use force powers, available on client aswell

ply:lscsSetForceAllowed( bool_allow ) -- allow/disallow force usage for this player. This will also hide the force selector hud

ply:lscsGetForce() -- returns players current force points, available on client aswell

ply:lscsSetForce( num ) -- set players force points

ply:lscsGetMaxForce() -- returns players MAX amount of force points, available on client aswell

ply:lscsSetMaxForce( num ) -- set players MAX force points

ply:lscsTakeForce( Amount ) -- take this 'Amount' of force and automatically adds a delay before regenerating can happen

ply:lscsSetForceRegenAmount( num ) -- set amount of force regeneration per 0.1 seconds

ply:lscsGetForceRegenAmount() -- returns how much force per 0.1 seconds regenerates for given player

ply:lscsSendComboDataTo( other_ply ) -- this is used internally to send the combo data to other players. You should never need this.

ply:lscsForceWalk( seconds ) -- will force the player to walk for given amount of seconds

ply:lscsSetShouldBleed( bool_should_bleed ) -- enable disable bleeding. Probably does nothing as the saber will constantly call it.

ply:lscsClearBlood() -- does exactly what it says. Workaround for a gmod bug where ply:RemoveAllDecals() doesnt do anything when called on SERVER



--[[---------------------
	SHARED
--]]---------------------

ply:lscsCraftSaber() -- craft's a lightsaber out of the equipped items. When called on client will only send a crafting request.
			--This only works if the player has permission to spawn SWEP's. If they don't have permission you need to call ply:Give("weapon_lscs") first

ply:lscsDropItem( id ) -- drop given id from inventory as physical object on the floor. This will also unequip automatically. Will only send a drop request to server when called on client

item = ply:lscsGetInventoryItem( id ) -- convenience function. Does the same as LSCS:ClassToItem( ply:lscsGetInventory()[ id ] )
					-- returns the item behind given id in the inventory. NOTE: On client this is only synced to LocalPlayer()

inventory = ply:lscsGetInventory() -- returns the inventory of given player. NOTE: On client this is only synced to LocalPlayer()

equipped = ply:lscsGetEquipped() -- returns the equipped list of given player. NOTE: On client this os only synced to LocalPlayer()

keydown = ply:lscsKeyDown( IN_KEY ) -- similar to ply:KeyDown() except properly synced. Useful if you write your own combo inside a combo

forcepowers = ply:lscsGetForceAbilities() -- returns a table of equipped force powers. NOTE: On client this is only synced to LocalPlayer()

combodata = ply:lscsGetCombo( num ) -- returns given num-id combo if the player has it equipped. Will fall back to default stance if invalid num-id

hilt_right, hilt_left = ply:lscsGetHilt() -- gets the EQUIPPED HILT in the menu, NOT THE CRAFTED ONE FROM THE SABER THAT YOU ARE HOLDING IN YOUR HANDS

blade_right, blade_left = ply:lscsGetBlade() -- gets the EQUIPPED CRYSTAL in the menu, NOT THE CRAFTED ONE FROM THE SABER THAT YOU ARE HOLDING IN YOUR HANDS

ply:lscsBuildPlayerInfo() -- build player data and network it to all clients. NOTE: This will only build for LocalPlayer() if called on client. Another NOTE: This should never have to be called

ply:lscsClearEquipped( type, is_right_hand ) -- unequip all items of given type. type can be "hilt" "crystal" "force" or "stance". 
						-- if is_right_hand = true/false  will only unequip  right/left hand

ply:lscsClearTimedMove() -- clears the restricted movement

ply:lscsSetTimedMove( ID, time_start, time_duration, vector_movement ) -- see combo template for how-to-use

ply:lscsSuppressFalldamage( time_seconds ) -- suppresses falldamage for given amount of seconds. Does nothing on client

is_suppressed = ply:lscsIsFalldamageSuppressed() -- returns if falldamage is disabled

shoot_pos = ply:lscsGetShootPos() -- returns "eyes" attachment pos or ply:GetShootPos() if no attachment is found

view_pos = ply:lscsGetViewOrigin() -- returns the view camera position. EyeAngles in LSCS is just vanilla ply:EyeAngles()
