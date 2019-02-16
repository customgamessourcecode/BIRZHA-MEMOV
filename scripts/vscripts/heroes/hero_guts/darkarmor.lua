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

function DarkArmor(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = 15
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_sven_2")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 5
	end
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_invoker_9")
	
	if Talent2:GetLevel() == 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_guts_DarkArmor_talent", {duration = duration })
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_guts_DarkArmor", {duration = duration })
	end
end