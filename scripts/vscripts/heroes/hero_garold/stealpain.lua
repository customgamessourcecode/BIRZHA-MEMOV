function StealPainStack (keys)
	local caster = keys.caster	
	local ability = keys.ability
	local damageTaken = keys.DamageTaken
	
	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end
	
	local maxstack = ability:GetLevelSpecialValueFor("damagestack", ability:GetLevel() - 1)
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_dark_seer_3")
	
	if Talent2:GetLevel() == 1 then
		maxstack = maxstack + 2000
	end
	
	if ability.currentStacks <= maxstack then
		ability.currentStacks = ability.currentStacks+damageTaken
		caster:SetModifierStackCount("modifier_Garold_StealPain_stack", ability, ability.currentStacks)
	end
end

function StealPainRefresh(keys)
	local caster = keys.caster	
	local ability = keys.ability
	
	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end
	
	local maxstack = ability:GetLevelSpecialValueFor("damagestack", ability:GetLevel() - 1)
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_dark_seer_3")
	
	if Talent2:GetLevel() == 1 then
		maxstack = maxstack + 2000
	end
	
	if ability.currentStacks > maxstack then
		ability.currentStacks = maxstack
	end

	caster:SetModifierStackCount("modifier_Garold_StealPain_stack", ability, ability.currentStacks)
end

function StealPainDamage(keys)
		local ability = keys.ability
		local enddamage = ability.currentStacks / 100
		local caster = keys.caster
		local damagepersentage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
		
		local Talent = caster:FindAbilityByName("special_bonus_unique_dark_seer_2")
	
		if Talent:GetLevel() == 1 then
			damagepersentage = damagepersentage + 5
		end

		local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		400,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)
		
	if ability.currentStacks >= 0 then
		for _,unit in pairs(targets) do
			ApplyDamage({victim = unit, attacker = caster, damage = enddamage * damagepersentage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
			ability.currentStacks = 0
			caster:SetModifierStackCount("modifier_Garold_StealPain_stack", ability, 0)
			
			local void_pfx = ParticleManager:CreateParticle("particles/garold/garold_stealpain.vpcf", PATTACH_POINT_FOLLOW, unit)
			ParticleManager:SetParticleControlEnt(void_pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true)
			ParticleManager:SetParticleControl(void_pfx, 1, Vector(400,0,0))
			ParticleManager:ReleaseParticleIndex(void_pfx)
			EmitGlobalSound( "Hero_Antimage.ManaVoid" )
		end
	end
end

function StealPainDeath(keys)
		local ability = keys.ability
		local caster = keys.caster
		
		ability.currentStacks = 0
		caster:SetModifierStackCount("modifier_Garold_StealPain_stack", ability, 0)
end

