function Goo(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)
	caster:EmitSound("Hero_Bristleback.ViscousGoo.Cast")
	
	for _,hero in pairs(heroes) do
		local goo = {
			Target = hero,
			Source = caster,
			Ability = ability,
			EffectName = "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_crimson_nasal_goo_proj.vpcf",
			iMoveSpeed = 1500,
			bDodgeable = false, 
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			bProvidesVision = false,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
	
		ProjectileManager:CreateTrackingProjectile(goo) 
	end 
end


function Goohit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	if target:TriggerSpellAbsorb(ability) then return end
	target:TriggerSpellReflect(ability)
	target:EmitSound("Hero_Bristleback.ViscousGoo.Target")
	ability:ApplyDataDrivenModifier( target, target, "modifier_slow", { Duration = 3 })
end