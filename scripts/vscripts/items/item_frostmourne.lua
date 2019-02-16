function frostmourneskadi(keys)
	if keys.caster:IsRangedAttacker() then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_frostmourne_skadi_debuff", {duration = keys.ColdDurationRanged})
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_frostmourne_skadi_debuff", {duration = keys.ColdDurationMelee})
	end
end

function frostmournehex(keys)
	local target = keys.target
	local model = keys.model
	local ability = keys.ability
	local ability_level = ability:GetLevel()
	local player = keys.caster:GetPlayerID()
	if target.caster_model == nil then 
		target.caster_model = target:GetModelName()
	end	
	
	if IsUnlockedInPass(player, "reward55") then
		target:SetModel("models/items/courier/scuttling_scotty_penguin/scuttling_scotty_penguin.vmdl")
		target:SetOriginalModel("models/items/courier/scuttling_scotty_penguin/scuttling_scotty_penguin.vmdl")
	else
		target:SetModel("models/props_gameplay/pig_blue.vmdl")
		target:SetOriginalModel("models/props_gameplay/pig_blue.vmdl")
	end


	
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_frostmorn_debuff", {duration = 3.5})
end

function frostmournehexend(keys)
	local target = keys.target
	local model = keys.model
	local ability = keys.ability
	local ability_level = ability:GetLevel()
	
	target:SetModel(target.caster_model)
	target:SetOriginalModel(target.caster_model)
end