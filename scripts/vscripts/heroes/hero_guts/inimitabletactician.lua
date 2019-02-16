function InimitableTactician( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local manaBurn = ability:GetLevelSpecialValueFor("mana_per_hit", (ability:GetLevel() - 1))
	local manaDamage = ability:GetLevelSpecialValueFor("damage_per_burn", (ability:GetLevel() - 1))

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.victim = target
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.ability = ability
	
	if caster:IsIllusion() == false then
		if not target:IsMagicImmune() then
			if(target:GetMana() >= manaBurn) then
				damageTable.damage = manaBurn * manaDamage
				target:ReduceMana(manaBurn)
			else
				damageTable.damage = target:GetMana() * manaDamage
				target:ReduceMana(manaBurn)
			end

			ApplyDamage(damageTable)
		end
	end
end