function FuckingHamgurger ( keys )
	local caster = keys.caster
	local Talent = caster:FindAbilityByName("special_bonus_unique_lycan_2")
	
	if Talent:GetLevel() == 1 then
		local Pudge = CreateUnitByName("npc_pudge_3", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Pudge:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Pudge:SetOwner(caster)
		local Pudge2 = CreateUnitByName("npc_pudge_3", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Pudge2:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Pudge2:SetOwner(caster)
		
		Timers:CreateTimer(60, function()
		Pudge:Destroy()
		Pudge2:Destroy()
		end)	
	end
end