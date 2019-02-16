function golosovanie( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")

	ability:ApplyDataDrivenModifier( caster, caster, "modifier_Ricardo_Golosovanie", { duration = duration })
	caster:EmitSound("ricardoultimate")
end

function golosovanieDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local anim = RandomInt(1, 2)
	local effect = RandomInt(1, 2)
	local rotate = RandomInt(40, 120)
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")
	local flag = DOTA_UNIT_TARGET_FLAG_NONE
	local damagetype = DAMAGE_TYPE_MAGICAL
	local angles = caster:GetAngles()
	caster:SetAngles(angles.x, angles.y+rotate, angles.z)
	
	ability_kokos = caster:FindAbilityByName("Ricardo_KokosMaslo")
	if ability_kokos ~= nil then
		ability.damagekokos = ability_kokos:GetSpecialValueFor("bonus_damage")
	end
	
	if anim == 1 then
		caster:StartGesture( ACT_DOTA_CAST_ABILITY_4 )
	elseif anim == 2 then
		caster:StartGesture( ACT_DOTA_CAST_ABILITY_3 )
	end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_bane_1")
	
	if Talent:GetLevel() == 1 then
		flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		damagetype = DAMAGE_TYPE_PURE
		print("talent let's go")
	end
	
	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		flag,
		FIND_ANY_ORDER,
		false)
		
	print(flag, damagetype)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = damagetype, ability = ability})
		if #targets > 0 then
			ability:ApplyDataDrivenModifier( caster, unit, "modifier_Ricardo_Golosovanie_slow", { duration = 0.5 })
		end
		
		if unit:HasModifier("modifier_Ricardo_KokosMaslo_debuff") then
			local modif = unit:FindModifierByName("modifier_Ricardo_KokosMaslo_debuff")
			local Talentkokos = caster:FindAbilityByName("special_bonus_unique_enigma_2")
			if Talentkokos:GetLevel() == 1 then
				ability.damagekokos = ability.damagekokos + 20
			end
			local fulldamagekokos = modif:GetStackCount() * ability.damagekokos
			ApplyDamage({victim = unit, attacker = caster, damage = fulldamagekokos, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
		
		if effect == 1 then
			local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_red_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
			ParticleManager:SetParticleControl (nFXIndex, 0, Vector (0, 0, 0))
			ParticleManager:SetParticleControl (nFXIndex, 1, Vector (250, 250, 250))
			unit:EmitSound("Hero_FacelessVoid.TimeDilation.Cast.ti7_layer")
		elseif effect == 2 then
			local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
			ParticleManager:SetParticleControl (nFXIndex, 0, Vector (0, 0, 0))
			ParticleManager:SetParticleControl (nFXIndex, 1, Vector (250, 250, 250))
			unit:EmitSound("Hero_FacelessVoid.TimeDilation.Cast.ti7_layer")
		end
	end
	
	if caster:HasModifier("modifier_Ricardo_Golosovanie_magic") then
		caster:SetModifierStackCount("modifier_Ricardo_Golosovanie_magic", ability, #targets * 1)
	else
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_Ricardo_Golosovanie_magic", {})
	end
end