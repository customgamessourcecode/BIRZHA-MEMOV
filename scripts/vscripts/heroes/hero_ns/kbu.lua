function KBU( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1 )
	local level = ability:GetLevel()
	local unit_name_earth = event.unit_name_earth
	unit_name_earth = unit_name_earth..level
	local unit_name_storm = event.unit_name_storm
	unit_name_storm = unit_name_storm..level
	local unit_name_fire = event.unit_name_fire
	unit_name_fire = unit_name_fire..level
	local forwardV = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    local distance = 100
	local ang_right = QAngle(0, -90, 0)
    local ang_left = QAngle(0, 90, 0)
	local earth_position = origin + forwardV * distance
	local storm_position = RotatePosition(origin, ang_left, earth_position)
	local fire_position = RotatePosition(origin, ang_right, earth_position)

	caster.Earth = CreateUnitByName(unit_name_earth, earth_position, true, caster, caster, caster:GetTeamNumber())
	caster.Storm = CreateUnitByName(unit_name_storm, storm_position, true, caster, caster, caster:GetTeamNumber())
	caster.Fire = CreateUnitByName(unit_name_fire, fire_position, true, caster, caster, caster:GetTeamNumber())

	caster.Earth:SetControllableByPlayer(player, true)
	caster.Storm:SetControllableByPlayer(player, true)
	caster.Fire:SetControllableByPlayer(player, true)

	caster.Earth:SetForwardVector(forwardV)
	caster.Storm:SetForwardVector(forwardV)
	caster.Fire:SetForwardVector(forwardV)

	ability:ApplyDataDrivenModifier(caster, caster.Earth, "modifier_split_unit", {})
	ability:ApplyDataDrivenModifier(caster, caster.Storm, "modifier_split_unit", {})
	ability:ApplyDataDrivenModifier(caster, caster.Fire, "modifier_split_unit", {})

	caster.Earth:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	caster.Storm:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	caster.Fire:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

	caster.ActiveSplit = caster.Earth

	local underground_position = Vector(origin.x, origin.y, origin.z - 322)
	caster:SetAbsOrigin(underground_position)
end

function KBUDied( event )
	local caster = event.caster
	local attacker = event.attacker
	local unit = event.unit

	if IsValidEntity(caster.Earth) and caster.Earth:IsAlive() then
		caster.ActiveSplit = caster.Earth
	elseif IsValidEntity(caster.Storm) and caster.Storm:IsAlive() then
		caster.ActiveSplit = caster.Storm
	elseif IsValidEntity(caster.Fire) and caster.Fire:IsAlive() then
		caster.ActiveSplit = caster.Fire
	else
		if attacker == unit then
			print("Primal Split End Succesfully")
		elseif attacker ~= unit then
			-- Kill the caster with credit to the attacker.
			caster:Kill(nil, attacker)
			caster.ActiveSplit = nil
		end
	end

	if caster.ActiveSplit then
		print(caster.ActiveSplit:GetUnitName() .. " is active now")
	else
		print("All Split Units were killed!")
	end
end

function KBUAuraMove( event )
	local caster = event.caster
	local active_split_position = caster.ActiveSplit:GetAbsOrigin()
	local underground_position = Vector(active_split_position.x, active_split_position.y, active_split_position.z - 322)
	caster:SetAbsOrigin(underground_position)
end

function KBU2End( event )
	local caster = event.caster
	local facing_direction = caster.ActiveSplit:GetForwardVector()
	if caster.ActiveSplit then
		local position = caster.ActiveSplit:GetAbsOrigin()
		FindClearSpaceForUnit(caster, position, true)
		caster:SetForwardVector(facing_direction)
	end

end

function LearnAllAbilities( unit, level )

	for i=0,15 do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			ability:SetLevel(level)
			print("Set Level "..level.." on "..ability:GetAbilityName())
		end
	end
end

function LearnAllAbilitiesExcluding( unit, level, excludedAbilityName)
	for i=0,15 do
		local ability = unit:GetAbilityByIndex(i)
		if ability and ability:GetAbilityName() ~= excludedAbilityName then
			ability:SetLevel(level)
			print("Set Level "..level.." on "..ability:GetAbilityName())
		end
	end
end