function TalentSniper ( keys )
	local caster = keys.caster
	local Talent = caster:FindAbilityByName("special_bonus_unique_sven_3")
	
	if Talent:GetLevel() == 1 then
		if caster:IsIllusion() then return end
		local Sniper = CreateUnitByName("npc_dota_uk_sniper_3", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Sniper:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Sniper:SetOwner(caster)
		
		local Sniper2 = CreateUnitByName("npc_dota_uk_sniper_3", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Sniper2:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Sniper2:SetOwner(caster)
		
		local Sniper3 = CreateUnitByName("npc_dota_uk_sniper_3", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Sniper3:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Sniper3:SetOwner(caster)
		
		local Sniper4 = CreateUnitByName("npc_dota_uk_sniper_3", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Sniper4:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Sniper4:SetOwner(caster)
		
		local Sniper5 = CreateUnitByName("npc_dota_uk_sniper_3", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Sniper5:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Sniper5:SetOwner(caster)
		
		local Sniper6 = CreateUnitByName("npc_dota_uk_sniper_3", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Sniper6:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Sniper6:SetOwner(caster)
		
		Timers:CreateTimer(40, function()
		Sniper:Destroy()
		Sniper2:Destroy()
		Sniper3:Destroy()
		Sniper4:Destroy()
		Sniper5:Destroy()
		Sniper6:Destroy()
		end)
	end
end