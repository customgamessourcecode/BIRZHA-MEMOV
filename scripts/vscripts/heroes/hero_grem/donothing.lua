function Purge(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_centaur_2")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 5
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_grem_donothing", { duration = duration })
	caster:SetRenderColor(255, 0, 0)
	caster:SetModelScale(2)
end

function DoNothing(keys)
	local caster = keys.caster
	
	caster:SetRenderColor(255, 255, 255)
	caster:SetModelScale(1.5)
end