function LifeDrainParticle( event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local targetTeam = target:GetTeamNumber()
	local casterTeam = caster:GetTeamNumber()

	if target == caster then 
		ability:OnChannelFinish(false)
		caster:Stop()
		ability:EndCooldown()
		ability:RefundManaCost()
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", event.caster:GetPlayerOwner())
		return
	end
	
	if targetTeam == casterTeam then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_item_stone_mask_active_target", {})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_item_stone_mask_target_buff", {})
	else
		if caster:GetHealth() < (caster:GetMaxHealth() / 100 * 40) or target:GetHealth() < (target:GetMaxHealth() / 100 * 40) then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_item_stone_mask_active_target", {})
		else
			ability:OnChannelFinish(false)
			caster:Stop()
			ability:EndCooldown()
			ability:RefundManaCost()
			EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", event.caster:GetPlayerOwner())
			return
		end
	end
	
	local particleName = "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf"
	caster.LifeDrainParticle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.LifeDrainParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function LifeDrainHealthTransfer( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local health_drain = 200
	local tick_rate = 0.25
	local HP_drain = health_drain * tick_rate
	local targetTeam = target:GetTeamNumber()
	local casterTeam = caster:GetTeamNumber()


	if target:IsIllusion() then
		target:ForceKill(true)
		ability:OnChannelFinish(false)
		caster:Stop()
		return
	else
		local caster_location = caster:GetAbsOrigin()
		local target_location = target:GetAbsOrigin()
		local distance = (target_location - caster_location):Length2D()
		local break_distance = 1000
		local direction = (target_location - caster_location):Normalized()

		if distance >= break_distance then
			ability:OnChannelFinish(false)
			caster:Stop()
			return
		end
		caster:SetForwardVector(direction)
	end
	
	if target:IsInvulnerable() or target:IsMagicImmune() then
		ability:OnChannelFinish(false)
		caster:Stop()
		ParticleManager:DestroyParticle(caster.LifeDrainParticle,false)
		target:RemoveModifierByName("modifier_item_stone_mask_active_target")
		target:RemoveModifierByName("modifier_item_stone_mask_target_buff")
		return
	end

	if targetTeam == casterTeam then
		if target:GetHealthDeficit() > 0 then
			ApplyDamage({ victim = caster, attacker = caster, damage = HP_drain, damage_type = DAMAGE_TYPE_MAGICAL })
			target:Heal( HP_drain, caster)
			
			ParticleManager:SetParticleControl(caster.LifeDrainParticle, 10, Vector(0,0,0))
			ParticleManager:SetParticleControl(caster.LifeDrainParticle, 11, Vector(0,0,0))
		else
			ApplyDamage({ victim = caster, attacker = caster, damage = HP_drain, damage_type = DAMAGE_TYPE_MAGICAL })
			target:SetMana( target:GetMana() + HP_drain)

			ParticleManager:SetParticleControl(caster.LifeDrainParticle, 10, Vector(1,0,0))
			ParticleManager:SetParticleControl(caster.LifeDrainParticle, 11, Vector(1,0,0))
		end	
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_item_stone_mask_death_target", { duration = 1.5})
		ApplyDamage({ victim = target, attacker = caster, damage = HP_drain, damage_type = DAMAGE_TYPE_MAGICAL })
		caster:Heal( HP_drain, caster)

		ParticleManager:SetParticleControl(caster.LifeDrainParticle, 10, Vector(0,0,0))
		ParticleManager:SetParticleControl(caster.LifeDrainParticle, 11, Vector(0,0,0))
	end
end

function LifeDrainParticleEnd( event )
	local caster = event.caster
	ParticleManager:DestroyParticle(caster.LifeDrainParticle,false)
end

function LifeDrainDeath( event )
	local caster = event.caster
	local ability = event.ability
	
	local stone_mask_slot = nil
	for i=0, 5, 1 do
		local current_item = caster:GetItemInSlot(i)
		if current_item ~= nil then			
			if current_item:GetName() == "item_stone_mask" then
				stone_mask_slot = current_item
			end
		end
	end
	
	if stone_mask_slot ~= nil then
		stone_mask_slot:SetCurrentCharges(stone_mask_slot:GetCurrentCharges() + 1)
	end
		
	if not ability.currentStacks then
	    ability.currentStacks = 1 
	end
	
	ability.currentStacks = ability.currentStacks + 1
	
	caster:SetModifierStackCount("modifier_item_stone_mask_caster_buff", ability, ability.currentStacks)
end

function LifeDrainDeathCaster( event )
	local caster = event.caster
	local ability = event.ability
	
	if not ability.currentStacks then
	    ability.currentStacks = 1 
	end
	
	if ability.currentStacks <= 1 then return end
	
	local stone_mask_slot = nil
	for i=0, 5, 1 do
		local current_item = caster:GetItemInSlot(i)
		if current_item ~= nil then			
			if current_item:GetName() == "item_stone_mask" then
				stone_mask_slot = current_item
			end
		end
	end
	
	if stone_mask_slot ~= nil then
		stone_mask_slot:SetCurrentCharges(stone_mask_slot:GetCurrentCharges() / 2)
	end
	
	ability.currentStacks = ability.currentStacks / 2
	
	caster:SetModifierStackCount("modifier_item_stone_mask_caster_buff", ability, ability.currentStacks)
end