function GetInTheTank( keys )
	local caster = keys.caster
	local model = keys.model
	local ability = keys.ability
	local ability_level = ability:GetLevel()
	local projectile_model = keys.projectile_model

	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end	

	caster:SetOriginalModel(model)
	caster:SetModelScale(6)
	caster:SetRangedProjectileName(projectile_model)
end

function GetInTheTankEnd( keys )
	local caster = keys.caster
	local projectile_model_destroy = keys.projectile_model_destroy

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetModelScale(4)
	caster:SetRangedProjectileName(projectile_model_destroy)
end

function GetInTheTankModifier(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = 15
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_winter_wyvern_4")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 10
	end
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_Knuckles_GetInTheTank", {duration = duration })
end