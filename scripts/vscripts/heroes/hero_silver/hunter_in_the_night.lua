--[[Author: Pizzalol
	Date: 11.01.2015.
	Checks if it is night time to see if it should apply the night modifier
	If it is day then it removes it if the caster has the night modifier]]
function HunterInTheNight( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local Talent = caster:FindAbilityByName("special_bonus_unique_ogre_magi_2")
	
	if Talent:GetLevel() == 1 then
		if not GameRules:IsDaytime() then
			ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		else
			if caster:HasModifier(modifier) then caster:RemoveModifierByName(modifier) end
		end
	end
end

function HunterInTheNightAttackRange( keys )
	local caster = keys.caster
	local ability = keys.ability
	local projectile_model = keys.projectile_model
	
    caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	caster:SetRangedProjectileName(projectile_model)
end

function HideWearables( event )
	local hero = event.caster
	local ability = event.ability

	hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
	local hero = event.caster

	for i,v in pairs(hero.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
	end
end

function ModelSwapEnd( keys )
local caster = keys.caster
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end