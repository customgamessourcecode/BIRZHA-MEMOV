function HealSound( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = "modifier_Miku_HealSound"
	local heal = ability:GetLevelSpecialValueFor("heal", (ability:GetLevel() - 1))
	local heal_percent = ability:GetLevelSpecialValueFor("heal_percent", (ability:GetLevel() - 1)) / 100
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_grimstroke_1")
	
	if Talent2:GetLevel() == 1 then
		heal_percent = heal_percent + 0.1
	end
	
	local fullheal = heal + caster:GetMaxHealth() * heal_percent
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_enchantress_1")
	
	if Talent:GetLevel() == 1 then
		cooldown = cooldown - 3
	end

	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
			ability:StartCooldown(cooldown)
			caster:EmitSound("MikuUhh")
				
			local emp_explosion_effect = ParticleManager:CreateParticle("particles/miku/miku_healsound.vpcf",  PATTACH_ABSORIGIN, caster)
			
			local targets = FindUnitsInRadius(caster:GetTeamNumber(),
				caster:GetAbsOrigin(),
				nil,
				500,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_ANY_ORDER,
				false)

			for _,unit in pairs(targets) do
				unit:Heal(fullheal, caster)
			end		
		end
	end
end