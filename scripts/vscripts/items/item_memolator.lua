function memolator3(keys)
	local caster = keys.caster
	local random_int = RandomInt(1, 100)
	local is_ranged_attacker = caster:IsRangedAttacker()
	local ability = keys.ability
	local target = keys.target

	if caster:IsIllusion() then return end
		if ability:GetCooldownTimeRemaining() == 0 then
		if (is_ranged_attacker and random_int <= keys.BashChanceRanged) or (not is_ranged_attacker and random_int <= keys.BashChanceMelee) then
			keys.target:EmitSound("DOTA_Item.SkullBasher")
			target:AddNewModifier( caster, ability, "modifier_stunned", {duration = 1.5})
			ApplyDamage({victim = target, attacker = caster, damage = 100, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
	end
end