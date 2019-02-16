function SwapModel( keys )
	local caster = keys.caster
	local model = keys.model
	local ability = keys.ability
	local ability_level = ability:GetLevel()

	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end

	caster:SetOriginalModel(model)
end

function SwapModelEnd( keys )
	local caster = keys.caster

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
end

function GangstaAlexey(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = 15
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_legion_commander")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 15
	end
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_JesusAVGN_GangstaAlexey", {duration = duration })
end