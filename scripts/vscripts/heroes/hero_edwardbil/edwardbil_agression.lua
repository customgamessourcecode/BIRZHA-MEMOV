if EdwardBil_Agression == nil then 
	EdwardBil_Agression = class({}) 
end
LinkLuaModifier( "modifier_EdwardBil_Agression", "heroes/hero_edwardbil/EdwardBil_Agression.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_EdwardBil_Agression_debuff", "heroes/hero_edwardbil/EdwardBil_Agression.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_EdwardBil_Agression_debuff_talent", "heroes/hero_edwardbil/EdwardBil_Agression.lua", LUA_MODIFIER_MOTION_NONE )

function EdwardBil_Agression:OnSpellStart()
    if IsServer() then
		local duration = self:GetSpecialValueFor( "duration" )
		local debuff = "modifier_EdwardBil_Agression_debuff"
		
		if self:GetCaster():HasTalent("special_bonus_unique_abaddon") then
			duration = duration + 2
		end
		
		if self:GetCaster():HasTalent("special_bonus_unique_silencer_2") then
			self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_EdwardBil_Agression_debuff_talent", {duration = duration})
		end
		
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_EdwardBil_Agression", {duration = duration})
		self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_EdwardBil_Agression_debuff", {duration = duration + 1})
		self:GetCaster():EmitSound("edwardcrazy")		
    end
end

if modifier_EdwardBil_Agression == nil then 
	modifier_EdwardBil_Agression = class({}) 
end

function modifier_EdwardBil_Agression:IsHidden()
	return false
end

function modifier_EdwardBil_Agression:IsPurgable()
	return false
end

function modifier_EdwardBil_Agression:SearchTarget()
    if IsServer() then 
        local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(),self:GetParent(), 99999, self:GetAbility():GetAbilityTargetTeam(),self:GetAbility():GetAbilityTargetType(),self:GetAbility():GetAbilityTargetFlags(), FIND_CLOSEST, false )
		for k,unit in pairs(units) do
			if unit ~= self:GetParent() and unit:HasModifier("modifier_EdwardBil_Agression_debuff") then
				return unit
			end
		end
    end
    return nil
end

function modifier_EdwardBil_Agression:AttackTarget()
    if IsServer() then 
        local order =
		{
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			TargetIndex = self.target:entindex()
		}
        ExecuteOrderFromTable(order)
        
        self:GetParent():SetForceAttackTarget(self.target)
    end
end

function modifier_EdwardBil_Agression:OnCreated(params)
	if IsServer() then
		self:GetCaster():SetRenderColor(255, 0, 0)
        self:StartIntervalThink(0.05)
	end
end

function modifier_EdwardBil_Agression:OnDestroy()
	if IsServer() then
        self:GetParent():Interrupt()
		self:GetParent():SetForceAttackTarget(nil)
        self:GetParent():SetForceAttackTargetAlly(nil)
        self:GetParent():Stop()
		self:GetParent():SetRenderColor(255, 255, 255)
	end
end

function modifier_EdwardBil_Agression:OnIntervalThink()
    if IsServer() then 
		self.target = self:SearchTarget()
        if self.target == nil or self.target:IsAlive() == false or self.target:IsAttackImmune() or self.target:IsInvulnerable() then 
            self:Destroy()
		else
            self:AttackTarget()	
        end
    end
end

function modifier_EdwardBil_Agression:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_EdwardBil_Agression:GetModifierIncomingPhysicalDamage_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("phys_immunitet")
end

function modifier_EdwardBil_Agression:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_EdwardBil_Agression:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = false,
        [MODIFIER_STATE_FAKE_ALLY] = true
	}

	return state
end


if modifier_EdwardBil_Agression_debuff == nil then 
	modifier_EdwardBil_Agression_debuff = class({}) 
end 

function modifier_EdwardBil_Agression_debuff:IsHidden()
	return false
end

function modifier_EdwardBil_Agression_debuff:IsPurgable()
	return false
end

function modifier_EdwardBil_Agression_debuff:RemoveOnDeath()
	return true
end

function modifier_EdwardBil_Agression_debuff:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_EdwardBil_Agression_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("target_movespeed")
end

function modifier_EdwardBil_Agression_debuff:GetEffectName()
	return "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear_smoke.vpcf"
end

if modifier_EdwardBil_Agression_debuff_talent == nil then 
	modifier_EdwardBil_Agression_debuff_talent = class({}) 
end 

function modifier_EdwardBil_Agression_debuff_talent:IsHidden()
	return true
end

function modifier_EdwardBil_Agression_debuff_talent:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

