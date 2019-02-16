function Car( keys )
	local caster = keys.caster
	local ability = keys.ability
	local Talent = caster:FindAbilityByName("special_bonus_unique_storm_spirit_3")
	local duration = ability:GetSpecialValueFor("duration")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 5
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_yakubovich_car", { Duration = duration })
end

LinkLuaModifier( "modifier_movespeed_cap", "modifiers/modifier_movespeed_cap.lua", LUA_MODIFIER_MOTION_NONE )

function SwapModelCar( keys )
	local caster = keys.caster
	local model = keys.model
	local ability = keys.ability
	local ability_level = ability:GetLevel()
	local duration = ability:GetSpecialValueFor("duration")

	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	
	caster:SetModelScale(2.5)

	caster:SetOriginalModel(model)
	if caster:HasModifier("modifier_movespeed_cap") == false then
		caster:AddNewModifier(caster, nil, "modifier_movespeed_cap", {duration = duration})
	end
end

function SwapModelCarEnd( keys )
	local caster = keys.caster

	caster:SetModelScale(1)
	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
end