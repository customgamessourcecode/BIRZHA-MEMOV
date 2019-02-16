function TalentSchoolboy ( keys )
	local caster = keys.caster
	local Talent = caster:FindAbilityByName("special_bonus_unique_alchemist_3")
	
	if Talent:GetLevel() == 1 then
		local Schoolboy = CreateUnitByName("npc_schoolboy_4", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Schoolboy:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Schoolboy:SetOwner(caster)
		local Schoolboy2 = CreateUnitByName("npc_schoolboy_4", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Schoolboy2:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Schoolboy2:SetOwner(caster)
		local Schoolboy3 = CreateUnitByName("npc_schoolboy_4", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Schoolboy3:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Schoolboy3:SetOwner(caster)
		local Schoolboy4 = CreateUnitByName("npc_schoolboy_4", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Schoolboy4:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Schoolboy4:SetOwner(caster)
		local Schoolboy5 = CreateUnitByName("npc_schoolboy_4", caster:GetAbsOrigin() + RandomVector(RandomFloat(100,250)), true, caster, nil, caster:GetTeamNumber())
		Schoolboy5:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
		Schoolboy5:SetOwner(caster)
		
		Timers:CreateTimer(15, function()
		Schoolboy:Destroy()
		Schoolboy2:Destroy()
		Schoolboy3:Destroy()
		Schoolboy4:Destroy()
		Schoolboy5:Destroy()
		end)
	end
end

function TalentSchoolboy2(event)
	local caster = event.caster
	local ability = event.ability
	local Talent = caster:FindAbilityByName("special_bonus_unique_alchemist_3")

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		100000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	if Talent:GetLevel() == 1 then
		for _,unit in pairs(targets) do
			if unit:GetUnitName() == "npc_schoolboy_1" or unit:GetUnitName() == "npc_schoolboy_2" or unit:GetUnitName() == "npc_schoolboy_3" or unit:GetUnitName() == "npc_schoolboy_4" then
				ability:ApplyDataDrivenModifier( caster, unit, "modifier_schoolboys_talent_stats", {})
			end
		end
	end
end