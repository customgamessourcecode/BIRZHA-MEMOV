mina_explosive_wave = class({})

function mina_explosive_wave:GetAbilityTextureName()
	return "Mina/ExplosiveWave"
end

function mina_explosive_wave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local radius = self:GetSpecialValueFor("aoe_radius")
		local cast_delay = self:GetSpecialValueFor("cast_delay")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local damage = self:GetSpecialValueFor("damage")
		local secondary_delay = self:GetSpecialValueFor("secondary_delay")
		local array_count = self:GetSpecialValueFor("array_count")
		local array_rings_count = self:GetSpecialValueFor("array_rings_count")
		local rings_radius = self:GetSpecialValueFor("rings_radius")
		local rings_delay = self:GetSpecialValueFor("rings_delay")
		local rings_distance = self:GetSpecialValueFor("rings_distance")
		local Talent = caster:FindAbilityByName("special_bonus_unique_techies")

		-- Distances
		local direction = (target_loc - caster_loc):Normalized()
		
		if Talent:GetLevel() == 1 then
			damage = damage + 140
		end

		-- Emit cast-sound
		caster:EmitSound("Hero_Techies.LandMine.Priming")

		-- Response 20%
		if (math.random(1,5) < 2) and (caster:GetName() == "npc_dota_hero_techies") then
			caster:EmitSound("Hero_Techies.LandMine.Detonate"..math.random(1,6))
		end

		-- Only create the main array blast
		self:CreateStrike( target_loc, 0, cast_delay, radius, damage, stun_duration )

		for i=0, array_count-1, 1 do
			local distance = i
			local count = i
			local next_distance = i+1
			local array_strike = i+1

			distance = radius * (distance + rings_distance)
			next_distance = radius * (next_distance + rings_distance)

			local delay = math.abs(distance / (radius * 2)) * cast_delay
			-- local position = target_loc + distance * direction

			-- Create 6 LSA rings around the explosion
			local rings_direction = direction
			for j=1, array_rings_count, 1 do
				rings_direction = RotateVector2D(rings_direction,((360/array_rings_count)),true)
				-- new_rings_direction = RotateVector2D(rings_direction,30,true) -- Determines the Hexagon angle
				local ring_distance = rings_radius * (array_strike + 1)
				local ring_delay = math.abs((radius * (i + cast_delay + rings_distance)) / (rings_radius * 2)) * cast_delay
				local ring_position = target_loc + ring_distance * rings_direction
				self:CreateStrike( ring_position, (cast_delay + ring_delay), (cast_delay + rings_delay), rings_radius, damage, stun_duration )
			end
		end
	end
end

function RotateVector2D(v,angle,bIsDegree)
    if bIsDegree then angle = math.rad(angle) end
    local xp = v.x * math.cos(angle) - v.y * math.sin(angle)
    local yp = v.x * math.sin(angle) + v.y * math.cos(angle)
    return Vector(xp,yp,v.z):Normalized()
end

function mina_explosive_wave:CreateStrike( position, delay, cast_delay, radius, damage, stun_duration )
	local caster = self:GetCaster()

	Timers:CreateTimer(delay, function()
		local cast_pfx = ParticleManager:CreateParticleForTeam("particles/heroes/hero_mina/explosionwave_start.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeam())
		ParticleManager:SetParticleControl(cast_pfx, 0, position)
		ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius * 2, 0, 0))
		ParticleManager:ReleaseParticleIndex(cast_pfx)
	end)

	Timers:CreateTimer((delay+cast_delay), function()
		-- Emit particle + sound
		local blast_pfx = ParticleManager:CreateParticle("particles/heroes/hero_mina/explosionwave.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(blast_pfx, 0, position)
		ParticleManager:SetParticleControl(blast_pfx, 1, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(blast_pfx)
		EmitSoundOnLocationWithCaster( position, "Hero_Techies.LandMine.Detonate", caster )

		-- Destroys trees
		GridNav:DestroyTreesAroundPoint(position, radius, false)

		-- Deal damage and stun
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in ipairs(enemies) do
			self:OnHit(enemy, damage, stun_duration)
		end
	end)
end

function mina_explosive_wave:OnHit( target, damage, stun_duration )
	local caster = self:GetCaster()
	ApplyDamage({attacker = caster, victim = target, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
end

function mina_explosive_wave:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius")
end

function mina_explosive_wave:IsHiddenWhenStolen()
	return false
end