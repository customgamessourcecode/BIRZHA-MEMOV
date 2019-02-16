function ShakeTheGround(keys)
	local caster = keys.caster
	local ability = keys.ability
	local fissure_range = ability:GetLevelSpecialValueFor("fissure_range", (ability:GetLevel() -1))
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() -1))
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1))
	local multi = ability:GetLevelSpecialValueFor("str_multi", (ability:GetLevel() -1))
	local direction = caster:GetForwardVector()
	local startPos = caster:GetAbsOrigin() + direction * 96
	local endPos = caster:GetAbsOrigin() + direction * fissure_range
	
	
	local particle = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_fissure_egset.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, startPos)
	ParticleManager:SetParticleControl(particle, 1, endPos)
	ParticleManager:SetParticleControl(particle, 2, Vector(1, 0, 0 ))
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_tusk")
	
	if Talent:GetLevel() == 1 then
		stun_duration = stun_duration + 2
	end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_tusk_2")
	
	if Talent:GetLevel() == 1 then
		multi = multi + 4
	end

	
	local units = FindUnitsInLine(caster:GetTeam(), startPos, endPos, nil, 225, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
	
	for j,unit in ipairs(units) do
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_stunned", {duration=stun_duration})

		ApplyDamage({
			victim = unit,
			attacker = caster,
			damage = damage + caster:GetStrength() * multi,
			damage_type = DAMAGE_TYPE_PHYSICAL
		})
	end
end