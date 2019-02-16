function Scp_DamageAura( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local target_max_hp = target:GetMaxHealth() / 100
	local aura_damage = ability:GetLevelSpecialValueFor("aura_damage", (ability:GetLevel() - 1))
	local aura_damage_interval = ability:GetLevelSpecialValueFor("aura_damage_interval", (ability:GetLevel() - 1))
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_sand_king")
	
	if Talent:GetLevel() == 1 then
		aura_damage = aura_damage - 2
	end

	if not target:IsAncient() then
		local damage_table = {}

		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.damage_type = DAMAGE_TYPE_PURE
		damage_table.ability = ability
		damage_table.damage = target_max_hp * -aura_damage * aura_damage_interval
		damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS

		ApplyDamage(damage_table)
	end
end