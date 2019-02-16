function InSolo( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local target = keys.target
	
	if caster:IsIllusion() == false then
		if target:IsAncient() == false then
			if ability:GetCooldownTimeRemaining() == 0 then
				ApplyDamage({victim = target, attacker = caster, damage = 10000000, damage_type = DAMAGE_TYPE_PURE })
				ability:StartCooldown(cooldown)
			end
		end
	end	
end
