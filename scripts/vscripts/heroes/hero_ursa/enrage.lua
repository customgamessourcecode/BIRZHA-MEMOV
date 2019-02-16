function Purge(keys)
	local caster = keys.caster
	local ability = keys.ability
	local model_scale = ability:GetLevelSpecialValueFor( "model_scale", ability:GetLevel() - 1 )
	
	-- Strong Dispel
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
	
	-- Gives Ursa a red tint
	caster:SetRenderColor(255, 0, 0)
	
	-- Scales Ursa's model by 120%
	caster:SetModelScale(model_scale)
end

function ChangeAppearance(keys)
	local caster = keys.caster
	
	caster:SetRenderColor(255, 255, 255)
	caster:SetModelScale(1.5)
end