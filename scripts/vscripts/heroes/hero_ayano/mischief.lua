function SwapModel( keys )
	local caster = keys.caster
	local model = keys.model
	local ability = keys.ability
	local ability_level = ability:GetLevel()

	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	
	local Chance = RandomInt(1,5)
	
	if Chance == 1 then
		caster:SetOriginalModel("models/props_tree/dire_tree003.vmdl")
	elseif Chance == 2 then
		caster:SetOriginalModel("models/props_gameplay/treasure_chest_gold.vmdl")
	elseif Chance == 3 then
		caster:SetOriginalModel("models/props_gameplay/rune_goldxp.vmdl")
	elseif Chance == 4 then
		caster:SetOriginalModel("models/props_structures/stair_step007.vmdl")	
	elseif Chance == 5 then
		caster:SetOriginalModel("models/courier/doom_demihero_courier/doom_demihero_courier.vmdl")
	end
end

function SwapModelEnd( keys )
	local caster = keys.caster

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
end