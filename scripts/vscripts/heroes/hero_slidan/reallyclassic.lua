function ReallyClassic(keys)
	local forbidden_items = 
	{
		"item_hand_of_midas",
		"item_refresher",
		"item_aeon_disk",
		"item_frostmorn",
		"item_baldezh",
		"item_cosmobaldezh",
		"item_superbaldezh",
		"item_black_king_bar",
		"item_sphere",
		"item_roscom_midas",
		"item_arcane_boots",
		"item_guardian_greaves",
		"item_overheal_trank",
		"item_chill_aquila",
		"item_drum_of_speedrun",
		"item_aether_lupa"		
	}
			
	for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
		local current_ability = keys.caster:GetAbilityByIndex(i)
		if current_ability ~= nil then
			current_ability:EndCooldown()
		end
	end
	
	--Refresh all items the caster has.
	for i = 0, 5 do
		local current_item = keys.caster:GetItemInSlot(i)
		local should_refresh = true

	-- If this item is forbidden, do not refresh it
	for _,forbidden_item in pairs(forbidden_items) do
		if current_item and current_item:GetName() == forbidden_item then
			should_refresh = false
		end
	end

		-- Refresh
		if current_item and should_refresh then
			current_item:EndCooldown()
		end
	end
end