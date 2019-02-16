function Damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_homunculus_Spit_debuff", {duration = 6})
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function SecondDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local Talent = caster:FindAbilityByName("special_bonus_unique_venomancer")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 100
	end
	
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end