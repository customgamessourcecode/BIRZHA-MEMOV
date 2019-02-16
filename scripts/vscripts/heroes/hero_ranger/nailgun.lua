function NailGun(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage_type = DAMAGE_TYPE_PHYSICAL
	
	local multi = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	
	local Talent2 = caster:FindAbilityByName("special_bonus_unique_sniper_2")
	local Talent = caster:FindAbilityByName("special_bonus_unique_sniper_1")
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	if Talent:GetLevel() == 1 then
		multi = multi + 40
	end
	
	if Talent2:GetLevel() == 1 then
		damage_type = DAMAGE_TYPE_PURE
	end
	
	if not target:IsMagicImmune() then
		ApplyDamage({ victim = target, attacker = caster, damage = caster:GetAttackDamage() / 100 * multi, damage_type = damage_type })
	end
end