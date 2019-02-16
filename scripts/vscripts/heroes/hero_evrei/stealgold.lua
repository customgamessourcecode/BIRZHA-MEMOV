function Stealgold( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local target = keys.target	
	local modifierName = "modifier_evrei_gold"
	local target_location = target:GetAbsOrigin()
	local money = ability:GetLevelSpecialValueFor("money_amount", ability:GetLevel() - 1)
	local money_team = ability:GetLevelSpecialValueFor("money_amount_team", ability:GetLevel() - 1)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, 9999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false)
	local Talent = caster:FindAbilityByName("special_bonus_unique_ember_spirit_2")
	
	if Talent:GetLevel() == 1 then
		money = money + 1000
	end
	
	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
	
			for i,unit in ipairs(units) do
				unit:ModifyGold( money_team, true, 0 )
			end
			
			caster:ModifyGold( money, true, 0 )
			caster:EmitSound("DOTA_Item.Hand_Of_Midas")
			ability:StartCooldown(cooldown)
			
			local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)	
			ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
		end	
	end
end