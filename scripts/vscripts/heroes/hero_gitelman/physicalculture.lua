function PhysicalCulture(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local hero_stun_duration = ability:GetLevelSpecialValueFor("hero_stun_duration", ability:GetLevel() - 1)
	local pull_offset = ability:GetLevelSpecialValueFor("pull_offset", ability:GetLevel() - 1)
	
	local caster_angle = caster:GetForwardVector()
	local caster_origin = caster:GetAbsOrigin()
	local offset_vector = caster_angle * pull_offset
	local new_location = caster_origin + offset_vector
	
	target:SetAbsOrigin(new_location)
	FindClearSpaceForUnit(target, new_location, true)
	local damage = ability:GetSpecialValueFor("damage")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_pangolier_5")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 400
	end
	
	if target:IsHero() == true then
		target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = hero_stun_duration})
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
end