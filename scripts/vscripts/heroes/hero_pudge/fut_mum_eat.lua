fut_mum_eat = class({})
LinkLuaModifier( "modifier_fut_mum_eat_caster", "heroes/hero_pudge/fut_mum_eat.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fut_mum_eat_target", "heroes/hero_pudge/fut_mum_eat.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fut_mum_eat_caster_scepter", "heroes/hero_pudge/fut_mum_eat.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bee_attack_eat", "heroes/hero_pudge/fut_mum_eat.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stun", "heroes/hero_pudge/pudge_eat.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silence_item", "heroes/hero_pudge/pudge_eat_silence.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pudge_slow", "heroes/hero_pudge/modifier_pudge_slow.lua",LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function fut_mum_eat:OnSpellStart()
_G.beetable = {}
    local duration = self:GetSpecialValueFor( "duration" )
  if not self:GetCaster():HasModifier("modifier_noAttack") then
  end
	
	if self:GetCaster():HasScepter() then
		duration = self:GetSpecialValueFor( "duration_scepter" )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_fut_mum_eat_caster_scepter", { duration = duration } )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_silence_item", { duration = duration } )
		LinkLuaModifier( "modifier_movespeed_cap", "modifiers/modifier_movespeed_cap", LUA_MODIFIER_MOTION_NONE )
		self:GetCaster():AddNewModifier( self:GetCaster(), nil, "modifier_movespeed_cap", {duration = duration})
	end
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_fut_mum_eat_caster", { duration = duration } )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_silence_item", { duration = duration } )
	
    local rage_particle = ParticleManager:CreateParticle("particles/pudge/status_effect_template.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	self:EmitSound("pudgemeat")
    if self:GetCaster():GetPlayerOwnerID() == false then
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_stun", { duration = 1 } )
    end
end

function fut_mum_eat:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then	
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_bee_attack", nil )
	end
	return true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_fut_mum_eat_caster = class({})

function modifier_fut_mum_eat_caster:IsHidden()
    return false
end
function modifier_fut_mum_eat_caster:OnCreated()
    if IsServer() then
        self:GetAbility():SetActivated(false)
        self.eat_bool = true
        
        self.stack_particle = ParticleManager:CreateParticle(particleTime, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl( self.stack_particle, 0, self:GetParent():GetAbsOrigin())         
        self:AddParticle( self.stack_particle, false, false, -1, false, true )
        self.victims = 0
    end
end

function modifier_fut_mum_eat_caster:OnDestroy()
    if IsServer() then
        self.model_scale = self:GetAbility():GetSpecialValueFor( "model_scale" )
        self:GetAbility():SetActivated(true)
        self:GetCaster():SetModelScale(self.model_scale)
        self:GetCaster():SetRenderColor(255, 255, 255)
        self:GetCaster():EmitSound("mumend")
        local caster_pos = self:GetCaster():GetAbsOrigin()
        self.victims = nil
		self:GetCaster():RemoveModifierByName("modifier_pudge_slow")
        ParticleManager:DestroyParticle(self.stack_particle, true)
        Timers:CreateTimer(0.1,function()
        for k,v in pairs(_G.beetable) do    
            k:AddNewModifier(v.Caster,v.ability,"modifier_bee_attack",nil) 
            print(k:GetTeamNumber(),v.Caster:GetTeamNumber(),v.ability:GetName())
        end   
        end)
	end
end

function modifier_fut_mum_eat_caster:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }

    return state
end
function modifier_fut_mum_eat_caster:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
    return funcs
end
function modifier_fut_mum_eat_caster:OnAttackStart( params )
    if IsServer() then
        if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
            if self:GetParent():PassivesDisabled() then
                return 0
            end
			self:GetCaster():RemoveGesture(ACT_DOTA_ATTACK)
            local target = params.target
            local duration = self:GetRemainingTime()
            if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                if not target:IsRealHero() or params.target:HasModifier("modifier_fut_mum_eat_caster") then
                    return nil
                else
                  if self.eat_bool == true then
                      self:GetCaster():SetModelScale(self:GetCaster():GetModelScale() + 0.1)
                      ---END SOUND
                      if self.stack_particle then
                       ParticleManager:DestroyParticle(self.stack_particle, true)
                      end
                      target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_fut_mum_eat_target", { duration = duration } )
                      local caster = self:GetParent()
                      local particleTime = "particles/mum/pudge_stack.vpcf"    
                      self.stack_particle = ParticleManager:CreateParticle(particleTime, PATTACH_OVERHEAD_FOLLOW, self:GetParent())            
                      self.victims = self.victims + 1
					  self:GetCaster():SetModifierStackCount("modifier_fut_mum_eat_caster", self:GetAbility(), self.victims)
					  
					if self:GetCaster():HasModifier("modifier_pudge_slow") then
						local stack_count = self:GetCaster():GetModifierStackCount("modifier_pudge_slow", self:GetAbility())
						self:GetCaster():SetModifierStackCount("modifier_pudge_slow", self:GetAbility(), stack_count + 1)
					else
						if self:GetCaster():HasScepter() then
							self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_pudge_slow", {} )
							self:GetCaster():SetModifierStackCount("modifier_pudge_slow", self:GetAbility(), 3)
						else
							self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_pudge_slow", {} )
							self:GetCaster():SetModifierStackCount("modifier_pudge_slow", self:GetAbility(), 1)
						end
					end
					  
                      ParticleManager:SetParticleControl( self.stack_particle, 1, Vector(1, self.victims, 0))
                      self:AddParticle( self.stack_particle, false, false, -1, false, true )
                      if self.victims > 9 then
                         ParticleManager:SetParticleControl( self.stack_particle, 2, Vector(2, 1, 0))
                      else
                         ParticleManager:SetParticleControl( self.stack_particle, 2, Vector(1, 1, 0))
                      end
                      self:GetCaster():Stop()
                      self.eat_bool = false
                      Timers:CreateTimer(1, function() self.eat_bool = true return nil end)
                    else
                        return nil
                    end
                end
            end
        end
    end
    return 0
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_fut_mum_eat_target = class({})
--------------------------------------------------------------------------------

function modifier_fut_mum_eat_target:IsPurgable()
    return true
end

--------------------------------------------------------------------------------



function modifier_fut_mum_eat_target:OnCreated( kv )
    self.model_scale = self:GetParent():GetModelScale()
    self:StartIntervalThink(0.03)
    self.kill_chance = self:GetAbility():GetSpecialValueFor( "kill_chance" )
    if IsServer() then
        if self:GetParent():HasModifier("modifier_bee_attack") then
            local mod = self:GetParent():FindModifierByName("modifier_bee_attack")
            self.PrimaryCaster = mod:GetCaster()
            self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bee_attack_eat", nil )
            _G.beetable[self:GetParent()] = {}
            _G.beetable[self:GetParent()].HasModifier = true 
            _G.beetable[self:GetParent()].Caster = self.PrimaryCaster
            _G.beetable[self:GetParent()].ability = mod:GetAbility()
            mod:Destroy()
        end
    end
    self:StartIntervalThink(0.1)
    if IsServer() then
        self:GetParent():SetModelScale(0.05)  
        self.particle = ParticleManager:CreateParticleForPlayer("particles/pudge/pudgerage.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
        self:AddParticle( self.particle, false, false, -1, false, true )		
        self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
		 Timers:CreateTimer(self.duration,function()
            ParticleManager:DestroyParticle (self.particle, false)
            return nil
        end)
    end
end
function modifier_fut_mum_eat_target:OnIntervalThink()
    if IsServer() then
        local target = self:GetParent ()
        local target_pos = target:GetAbsOrigin ()
        local caster = self:GetAbility ():GetCaster ()
        target:SetAbsOrigin (self:GetCaster ():GetAbsOrigin ())
        if not caster:IsAlive() then
            target:RemoveModifierByName ("modifier_fut_mum_eat_target")
        end
    end
end

function modifier_fut_mum_eat_target:OnDestroy( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
    if IsServer() then
        if _G.beetable[self:GetParent()] and self:GetCaster():IsAlive() then
             local mod = self:GetCaster():FindModifierByName("modifier_bee_attack_eat")
             self.PrimaryCaster = mod:GetCaster()
             mod:Destroy()
             self:GetParent():AddNewModifier( self.PrimaryCaster, self:GetAbility(), "modifier_bee_attack", nil )
        end
    end
    if IsServer() then
    local point = self:GetCaster():GetAbsOrigin()
   FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin(), true)
        local chance = math.random(100)
		local npcName = self:GetParent():GetUnitName()
		
		if npcName == "npc_dota_hero_invoker" then
			self:GetParent():SetModelScale(0.740000)
		elseif npcName == "npc_dota_hero_zuus" then
			self:GetParent():SetModelScale(1.0)
		else
			self:GetParent():SetModelScale(self.model_scale)
		end
		
        local knockback = CreateUnitByName("npc_dota_knockback", point, false, nil, nil, self:GetCaster():GetTeamNumber())
        Timers:CreateTimer(0.1,function()
            knockback:ForceKill(false)
        end)
        if chance <= self.kill_chance then
            local caster = self:GetCaster()
            self:GetParent():Kill(self:GetAbility(), self:GetCaster())
        else
			local caster = self:GetCaster()
			ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(),ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE})
			if not self:GetParent():IsAlive() then
			end
		end
    end
end

--------------------------------------------------------------------------------

function modifier_fut_mum_eat_target:CheckState()
    local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_NIGHTMARED] = true,
        [MODIFIER_STATE_HEXED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }

    return state
end

modifier_fut_mum_eat_caster_scepter = class({})

function modifier_fut_mum_eat_caster_scepter:IsHidden()
    return true
end

function modifier_fut_mum_eat_caster_scepter:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }
    return funcs
end
function modifier_fut_mum_eat_caster_scepter:GetModifierMoveSpeedBonus_Constant()
  if IsServer() then
    if self:GetParent():HasModifier("modifier_noAttack") then
      return 100
    end
  end
    return 1000
end
function modifier_fut_mum_eat_caster_scepter:GetModifierMoveSpeed_Max()
  if IsServer() then
    if self:GetParent():HasModifier("modifier_noAttack") then
      return 100
    end
  end
    return 800
end
modifier_bee_attack_eat = class({})
--------------------------------------------------------------------------------

function modifier_bee_attack_eat:IsDebuff()
	return true
end

function modifier_bee_attack_eat:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bee_attack_eat:OnCreated()
	self.beehive_radius = 500
	self.beehive_slow = 0
	self.beehive_damage = 25
	self.beehive_tick = 0.1
	local abil = {}
	abil.caster = self:GetParent()
	if IsServer() then
    self:StartIntervalThink( self.beehive_tick )
    self.time = 0
		Timers:CreateTimer(function()
        if not abil.caster:HasModifier("modifier_fut_mum_eat_caster") then
            return nil
        end
            if self.time == 0 then
            self.time = 8
                if abil.caster then
                    EmitSoundOn( "", abil.caster )
                end    
                if not abil.caster:HasModifier("modifier_bee_attack_eat") then
                    return nil
                end
            end
            self.time = self.time - 1
			return 1
		end)
	end
end

--------------------------------------------------------------------------------

function modifier_bee_attack_eat:OnDestroy()
	if IsServer() then
		StopSoundOn( "", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function modifier_bee_attack_eat:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING
	}
    
	return funcs
end

function modifier_bee_attack_eat:GetDisableHealing()
	return 1
end

function modifier_bee_attack_eat:OnIntervalThink() 
	if IsServer() then
		local flDamagePerTick = self.beehive_tick * self.beehive_damage
		local damage = { 
			victim = self:GetCaster(), 
			attacker = self:GetCaster(), 
			damage = flDamagePerTick, 
			damage_type = DAMAGE_TYPE_MAGICAL, 
			ability = self:GetAbility() 
		} 
		ApplyDamage( damage )
	end 
end

function modifier_bee_attack_eat:GetTexture()
    return "item_box_bee_attack"
end

function modifier_bee_attack_eat:IsHidden()
	return false
end