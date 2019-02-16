function HellFireBlast ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local Talent = caster:FindAbilityByName("special_bonus_unique_wraith_king_3")
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	if Talent:GetLevel() == 1 then
		damage = damage + 175
	end

	if target:IsMagicImmune() == false then
		ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		ability:ApplyDataDrivenModifier( caster, target, "modifier_hellfire_blast_stun", { Duration = duration })
		ability:ApplyDataDrivenModifier( caster, target, "modifier_hellfire_blast_slow", { Duration = duration })
	end
end