LinkLuaModifier("modifier_voodoo_lua", "heroes/hero_versuta/modifier_voodoo_lua.lua", LUA_MODIFIER_MOTION_NONE)

function voodoo_start( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target

	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	
	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
			if target:IsIllusion() then
				target:ForceKill(true)
			else
				target:AddNewModifier(caster, ability, "modifier_voodoo_lua", {duration = duration})
				target:EmitSound("Hero_Lion.Hex.Target")
			end
		end
	end
end

function voodoo_start_Cooldown( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = "modifier_versuta_dog"
	local Talent = caster:FindAbilityByName("special_bonus_unique_lycan_3")
	
	if Talent:GetLevel() == 1 then
		cooldown = cooldown - 7
	end
	
	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
			ability:StartCooldown(cooldown)	
			caster:EmitSound("versutadog")
		end
	end
end