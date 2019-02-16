function Youtube( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local target = keys.target	
	local money = 300
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_alchemist_2")
	
	if Talent:GetLevel() == 1 then
		money = money + 300
	end
	
	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
			caster:ModifyGold( money, true, 0 )
			ability:StartCooldown(cooldown)	
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red_spotlight.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)	
		end
	end
end