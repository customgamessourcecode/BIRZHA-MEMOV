function CDOTA_BaseNPC:DioMudaMudaMuda()
	local victim_angle = self:GetAnglesAsVector()
	local victim_angle_rad = victim_angle.y * math.pi/180
	local victim_position = self:GetAbsOrigin()
	local new_position = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)
	return new_position
end

function CDOTA_BaseNPC:HasTalent(tal)
    if self:HasAbility(tal) then
        if self:FindAbilityByName(tal):GetLevel() > 0 then return true end
    end
return nil
end