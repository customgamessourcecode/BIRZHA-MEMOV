function SpotTheTarget( keys )
	local caster = keys.caster
	local target = keys.target
	local targetLocation = target:GetAbsOrigin() 
	local ability = keys.ability

	target:RemoveModifierByName("modifier_track_aura_datadriven") 
end

function DeathGold( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local money = ability:GetSpecialValueFor("money")

	local Talent = caster:FindAbilityByName("special_bonus_unique_invoker_4")
	
	if Talent:GetLevel() == 1 then
		money = money + 250
	end
	
	caster:ModifyGold( money, true, 0 )
end