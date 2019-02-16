function Shield( event )
	local target = event.target
	local max_damage_absorb = event.ability:GetLevelSpecialValueFor("damage_absorb", event.ability:GetLevel() - 1 )
	local shield_size = 75

	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	
		target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
		target.AphoticShieldRemaining = max_damage_absorb
		if target:IsIllusion() then return end
		Timers:CreateTimer(0.01, function() 
			target.ShieldParticle = ParticleManager:CreateParticle("particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(target.ShieldParticle, 1, Vector(shield_size,0,shield_size))
			ParticleManager:SetParticleControl(target.ShieldParticle, 2, Vector(shield_size,0,shield_size))
			ParticleManager:SetParticleControl(target.ShieldParticle, 4, Vector(shield_size,0,shield_size))
			ParticleManager:SetParticleControl(target.ShieldParticle, 5, Vector(shield_size,0,0))

			ParticleManager:SetParticleControlEnt(target.ShieldParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		end)
end

function ShieldAbsorb( event )
	local damage = event.DamageTaken
	local unit = event.unit
	local ability = event.ability
	local shield_remaining = unit.AphoticShieldRemaining
	print("Shield Remaining: "..shield_remaining)
	print("Damage Taken pre Absorb: "..damage)
	
	if unit:IsIllusion() then return end

	if not unit:HasModifier("modifier_borrowed_time") then
		if damage > shield_remaining then
			local newHealth = unit.OldHealth - damage + shield_remaining
			print("Old Health: "..unit.OldHealth.." - New Health: "..newHealth.." - Absorbed: "..shield_remaining)
			unit:SetHealth(newHealth)
		else
			local newHealth = unit.OldHealth			
			unit:SetHealth(newHealth)
			print("Old Health: "..unit.OldHealth.." - New Health: "..newHealth.." - Absorbed: "..damage)
		end

		unit.AphoticShieldRemaining = unit.AphoticShieldRemaining-damage
		if unit.AphoticShieldRemaining <= 0 then
			unit.AphoticShieldRemaining = nil
			unit:RemoveModifierByName("modifier_shiro_shield_buff")
			print("--Shield removed--")
		end

		if unit.AphoticShieldRemaining then
			print("Shield Remaining after Absorb: "..unit.AphoticShieldRemaining)
			print("---------------")
		end
	end
end

function EndShieldParticle( event )
	local target = event.target
	target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")
	ParticleManager:DestroyParticle(target.ShieldParticle,false)
end

function ShieldHealth( event )
	local target = event.target

	target.OldHealth = target:GetHealth()
end

function EvasionHealth( keys )
	local caster = keys.caster
	local ability = keys.ability

	ability.caster_hp_old = ability.caster_hp_old or caster:GetMaxHealth()
	ability.caster_hp = ability.caster_hp or caster:GetMaxHealth()
	ability.caster_hp_old = ability.caster_hp
	ability.caster_hp = caster:GetHealth()
end

function EvasionHeal( keys )
	local caster = keys.caster
	local ability = keys.ability

	caster:SetHealth(ability.caster_hp_old)
end