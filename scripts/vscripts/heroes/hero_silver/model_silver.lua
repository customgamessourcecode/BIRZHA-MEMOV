function SwapModelSilver( keys )
	local caster = keys.caster
	local model = keys.model
	local ability = keys.ability
	local ability_level = ability:GetLevel()

	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end	

	caster:SetOriginalModel(model)
end

function SwapModelSilverEnd( keys )
	local caster = keys.caster

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
end