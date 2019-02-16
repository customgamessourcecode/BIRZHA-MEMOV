function ArmyModifier (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local projectile_model = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf"
	
	caster:SetRangedProjectileName(projectile_model)
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_kadet_army", { Duration = duration })
end

function ArmyAttack (keys)
	local caster = keys.caster
	local projectile_model = "particles/units/heroes/hero_lone_druid/lone_druid_base_attack.vpcf"
	
	caster:SetRangedProjectileName(projectile_model)
end

function ArmyAttackLanded (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration_target", (ability:GetLevel() - 1))
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	caster:SetRangedProjectileName(projectile_model)
	
	ability:ApplyDataDrivenModifier( caster, target, "modifier_kadet_army_debuff", { Duration = duration })
end