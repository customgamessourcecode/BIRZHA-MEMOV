function StoneSoulsDeath( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local current_stack = caster:GetModifierStackCount( modifier, ability )
	local SoulsSteal = 2
	local SoulsTalent = caster:FindAbilityByName("special_bonus_unique_elder_titan")
	
	if SoulsTalent:GetLevel() == 1 then
		SoulsSteal = 1
	end
	
	if current_stack > 1 then
		caster:SetModifierStackCount( modifier, ability, current_stack / SoulsSteal )
	end
end

function StoneSoulsStack( keys )
	local caster = keys.caster
	local target = keys.target
	local modifier = keys.modifier
	local ability = keys.ability
	local max_souls = ability:GetLevelSpecialValueFor( "max_souls", ability:GetLevel() - 1 )
	local souls_gained = 1
	local current_stack = caster:GetModifierStackCount( modifier, ability )
	
	if target:IsIllusion() then
		target:ForceKill(true)
	else
	
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()

	local distance = (target_location - caster_location):Length2D()
	local direction = (target_location - caster_location):Normalized()

	if distance >= 750 then
		ability:OnChannelFinish(false)
		caster:Stop()
		target:RemoveModifierByName( "modifier_thanos_stone_souls_active" )
		return
	end
	
	if caster:HasModifier("modifier_windwalk") then
		ability:OnChannelFinish(false)
		caster:Stop()
		target:RemoveModifierByName( "modifier_thanos_stone_souls_active" )
		return
	end
	
	if caster:HasModifier("modifier_invisible") then
		ability:OnChannelFinish(false)
		caster:Stop()
		target:RemoveModifierByName( "modifier_thanos_stone_souls_active" )
		return
	end
	
	if caster:HasModifier("modifier_item_invisibility_edge_windwalk") then
		ability:OnChannelFinish(false)
		caster:Stop()
		target:RemoveModifierByName( "modifier_thanos_stone_souls_active" )
		return
	end
	
	if caster:HasModifier("modifier_silver_edge_debuff") then
		ability:OnChannelFinish(false)
		caster:Stop()
		target:RemoveModifierByName( "modifier_thanos_stone_souls_active" )
		return
	end

	caster:SetForwardVector(direction)
	
	if not current_stack then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		current_stack = 0
	end
	
	if not caster:HasModifier( "modifier_thanos_stone_souls" ) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	end
	
	if caster:HasModifier("modifier_thanos_stone_strength_1") then
		max_souls = max_souls + 10
	end
	
	if caster:HasModifier("modifier_thanos_stone_strength_2") then
		max_souls = max_souls + 20
	end
	
	if caster:HasModifier("modifier_thanos_stone_strength_3") then
		max_souls = max_souls + 30
	end

	if (current_stack + souls_gained) <= max_souls then
			caster:SetModifierStackCount( modifier, ability, current_stack + souls_gained )
		else
			caster:SetModifierStackCount( modifier, ability, max_souls )
		end
	end
end

function stop_sound( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end

function TimeStonesSave( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage_taken = keys.DamageTaken
	local backtrack_time = keys.BacktrackTime
	local remember_interval = keys.Interval
	local target = keys.target
	
	-- Temporary damage array and index
	if not ability.tempList then  ability.tempList = {} end
	if not ability.tempList[caster:GetUnitName()] then ability.tempList[caster:GetUnitName()] = {} end
	local casterTable = {}
	casterTable["health"] = caster:GetHealth()
	casterTable["mana"] = caster:GetMana()
	casterTable["position"] = caster:GetAbsOrigin()
	table.insert(ability.tempList[caster:GetUnitName()],casterTable)
  	enemies = FindUnitsInRadius(caster:GetTeam(),
                                    caster:GetAbsOrigin(),
                                    nil,
                                    9999,
                                    DOTA_UNIT_TARGET_TEAM_BOTH,
                                    DOTA_UNIT_TARGET_HERO,
                                    DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                                    FIND_ANY_ORDER,
                                    false)
  	for _,enemy in pairs(enemies) do
  		if not ability.tempList[enemy:GetName()] then ability.tempList[enemy:GetName()] = {} end
  		local enemyTable = {}
  		enemyTable["health"] = enemy:GetHealth()
  		enemyTable["mana"] = enemy:GetMana()
  		enemyTable["position"] = enemy:GetAbsOrigin()
  		table.insert(ability.tempList[enemy:GetName()],enemyTable)
  	end
	
	local maxindex = backtrack_time/remember_interval
	if #ability.tempList[caster:GetUnitName()] > maxindex then
		table.remove(ability.tempList[caster:GetUnitName()],1)
	end	
	
	for _,enemy in pairs(enemies) do
		if #ability.tempList[enemy:GetUnitName()] > maxindex then
			table.remove(ability.tempList[enemy:GetName()],1)
		end
	end	
end

function TimeStonesActive( keys )
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster
	local health = ability.tempList[target:GetUnitName()][1]["health"]
	local mana = ability.tempList[target:GetUnitName()][1]["mana"]
	local position = ability.tempList[target:GetUnitName()][1]["position"]

	target:Interrupt()
	
	-- Adds damage to caster's current health
	particle_ground = ParticleManager:CreateParticle("particles/thanos/stone_time_effect.vpcf", PATTACH_ABSORIGIN  , target)
    ParticleManager:SetParticleControl(particle_ground, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_ground, 1, position) --radius
    ParticleManager:SetParticleControl(particle_ground, 2, position) --ammount of particle
	
	target:SetHealth(health)
	target:SetMana(mana)
	target:Purge(false,true,false,true,false)
	ProjectileManager:ProjectileDodge(target)
	FindClearSpaceForUnit(target, position, true)
end

function StoneSpace( keys )
	ProjectileManager:ProjectileDodge(keys.caster)
	
	local origin_point = keys.caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local difference_vector = target_point - origin_point
	local ability = keys.ability
	
	if difference_vector:Length2D() > keys.MaxBlinkRange then
		target_point = origin_point + (target_point - origin_point):Normalized() * 960
	end
	
	keys.caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(keys.caster, target_point, false)
	
	ability:ApplyDataDrivenModifier( keys.caster, keys.caster, "modifier_thanos_stone_space", { Duration = 3 })
	ability:ApplyDataDrivenModifier( keys.caster, keys.caster, "modifier_thanos_stone_space_animation", { Duration = 0.35 })
end

function StoneSpaceDamage( keys )

	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage_type = ability:GetAbilityDamageType()
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local target_location = target:GetAbsOrigin()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_types, target_flags, 0, false)
	
	if caster:HasModifier("modifier_thanos_stone_strength_1") then
		damage = damage + 500
	end
	
	if caster:HasModifier("modifier_thanos_stone_strength_2") then
		damage = damage + 750
	end
	
	if caster:HasModifier("modifier_thanos_stone_strength_3") then
		damage = damage + 1000
	end
	
	for i,unit in ipairs(units) do
		ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = damage_type })
		
		local knockbackProperties =
		{
			center_x = 0,
			center_y = 0,
			center_z = 0,
			duration = 0.5,
			knockback_duration = 0.5,
			knockback_distance = 350,
			knockback_height = 250
		}
		unit:AddNewModifier( unit, nil, "modifier_knockback", knockbackProperties )
		unit:AddNewModifier( unit, ability, "modifier_stunned", {duration = 1})
	end
end

-- Pancer только не души плз :D

function StoneMind(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	
	if caster:HasModifier("modifier_thanos_stone_strength_1") then
		duration = duration + 2
	end
	
	if caster:HasModifier("modifier_thanos_stone_strength_2") then
		duration = duration + 4
	end
	
	if caster:HasModifier("modifier_thanos_stone_strength_3") then
		duration = duration + 6
	end
	
	ability:ApplyDataDrivenModifier( caster, target, "modifier_thanos_stone_mind", { Duration = duration })
end

function StoneMindControl(keys)
	local caster = keys.caster
	local casterID = caster:GetPlayerID()
	local target = keys.target
	local targetID = target:GetPlayerID()
	caster.oldHullRadius = caster:GetHullRadius()
	target.oldTeam = target:GetTeamNumber()
	target:SetControllableByPlayer(casterID, true)
	target:SetTeam(caster:GetTeamNumber())
	PlayerResource:SetCameraTarget(casterID, target)
	PlayerResource:SetCameraTarget(casterID, nil)
	for i = 0, 8 do
		target.item = target:GetItemInSlot(i) 
		if target.item then
			if target.item:IsSellable() then
				target.item:SetSellable(false)
			end
			if target.item:IsDroppable() then
				target.item:SetDroppable(false)
			end
		end
	end
end

function StoneMindRemove(keys)
	local caster = keys.caster
	local casterID = caster:GetPlayerID()
	local target = keys.target
	local targetID = target:GetPlayerID()
	target:SetControllableByPlayer(targetID, true)
	target:SetTeam(target.oldTeam)
	for i = 0, 8 do
		target.item = target:GetItemInSlot(i) 
		if target.item then
			if not target.item:IsSellable() then
				target.item:SetSellable(true)
			end
			if not target.item:IsDroppable() then
				target.item:SetDroppable(true)
			end
		end
	end
end

function StoneStrengthRemoveTwo(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_thanos_stone_strength_check2", {})
	caster:RemoveModifierByName( "modifier_thanos_stone_strength_check" )
end

function StoneStrengthRemoveThree(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_thanos_stone_strength_3", {})
	caster:RemoveModifierByName( "modifier_thanos_stone_strength_check2" )
end