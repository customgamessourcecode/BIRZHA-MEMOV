LinkLuaModifier ("modifier_dio_mudamudamuda", "heroes/hero_dio/Dio_MudaMudaMuda", LUA_MODIFIER_MOTION_NONE)

if Dio_MudaMudaMuda == nil then
	Dio_MudaMudaMuda = class({})
end

function Dio_MudaMudaMuda:GetAbilityTextureName() 
	return "Dio/MudaMudaMuda"
end 

function Dio_MudaMudaMuda:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

function Dio_MudaMudaMuda:GetChannelTime()
	return self.BaseClass.GetChannelTime(self)
end

function Dio_MudaMudaMuda:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end
	return true
end

function Dio_MudaMudaMuda:OnSpellStart() 
	local caster = self:GetCaster() 
	local ability = self 
	local target = self:GetCursorTarget()
	local dur = self:GetChannelTime()
	caster:SetAbsOrigin(target:DioMudaMudaMuda())
	FindClearSpaceForUnit(caster, target:DioMudaMudaMuda(), true)
	caster:SetForwardVector(target:GetForwardVector())
	if self.hVictim == nil then
		return
	end
	self.hVictim:AddNewModifier( caster, self, "modifier_dio_mudamudamuda", { duration = self:GetChannelTime() } )
	self.hVictim:Interrupt()
	EmitSoundOn("mudamuda",self:GetCaster())
end

function Dio_MudaMudaMuda:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_dio_mudamudamuda" )
	end
end

modifier_dio_mudamudamuda = class({})

function modifier_dio_mudamudamuda:IsDebuff()
	return true
end

function modifier_dio_mudamudamuda:IsHidden()
	return true
end

function modifier_dio_mudamudamuda:IsStunDebuff()
	return true
end

function modifier_dio_mudamudamuda:OnCreated( kv )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "interval_attack" )

	if IsServer() then
		self.damage_atk = 0
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
end

function modifier_dio_mudamudamuda:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
		StopSoundOn("mudamuda",self:GetCaster())
	end
end

function modifier_dio_mudamudamuda:OnIntervalThink()
	if IsServer() then
		self:GetCaster():StartGesture(ACT_DOTA_ATTACK)
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetAttackDamage(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility()
		}
		ApplyDamage( damage )
	end
end

function modifier_dio_mudamudamuda:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end