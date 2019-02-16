function Darkness( keys )
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local caster = keys.caster

	-- Time variables
	local time_flow = 0.0020833333
	local time_elapsed = 0
	local start_time_of_day = GameRules:GetTimeOfDay()
	local end_time_of_day = start_time_of_day + duration * time_flow
	
	if caster:HasModifier("modifier_silver_owl_buff") then return end

	if end_time_of_day >= 1 then end_time_of_day = end_time_of_day - 1 end

	GameRules:SetTimeOfDay(0)
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_silver_owl_buff", { Duration = duration })

	Timers:CreateTimer(1, function()
		if time_elapsed < duration then
			GameRules:SetTimeOfDay(0)
			time_elapsed = time_elapsed + 1
			return 1
		else
			GameRules:SetTimeOfDay(end_time_of_day)
			return nil
		end
	end)
end

function ReduceVision( keys )
	local target = keys.target
	local ability = keys.ability
	local blind_percentage = ability:GetLevelSpecialValueFor("blind_percentage", (ability:GetLevel() - 1)) / -100

	target.original_vision = target:GetBaseNightTimeVisionRange()

	target:SetNightTimeVisionRange(target.original_vision * (1 - blind_percentage))
end

function RevertVision( keys )
	local target = keys.target

	target:SetNightTimeVisionRange(target.original_vision)
end