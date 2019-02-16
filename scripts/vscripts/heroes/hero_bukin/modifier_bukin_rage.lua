if modifier_Bukin_Rage == nil then
    modifier_Bukin_Rage = class({})
end

function modifier_Bukin_Rage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_Bukin_Rage:OnCreated()
	-- Variables
	self.berserkers_blood_attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus_per_stack" )
	self.berserkers_blood_movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.berserkers_blood_model_size = self:GetAbility():GetSpecialValueFor("model_size_per_stack")
	self.berserkers_blood_hurt_health_ceiling = self:GetAbility():GetSpecialValueFor("hurt_health_ceiling")
	self.berserkers_blood_hurt_health_floor = self:GetAbility():GetSpecialValueFor("hurt_health_floor")
	self.berserkers_blood_hurt_health_step = self:GetAbility():GetSpecialValueFor("hurt_health_step")


    if IsServer() then
        --print("Created")
        self:SetStackCount( 1 )
		self:GetParent():CalculateStatBonus()

		self:StartIntervalThink(0.1) 
    end
end

function modifier_Bukin_Rage:OnIntervalThink()
	if IsServer() then
	
		local caster = self:GetParent()
		local oldStackCount = self:GetStackCount()
		local health_perc = caster:GetHealthPercent()/100
		local newStackCount = 1

		local model_size = self.berserkers_blood_model_size
		local hurt_health_ceiling = self.berserkers_blood_hurt_health_ceiling
		local hurt_health_floor = self.berserkers_blood_hurt_health_floor
		local hurt_health_step = self.berserkers_blood_hurt_health_step


	    for current_health=hurt_health_ceiling, hurt_health_floor, -hurt_health_step do
	        if health_perc <= current_health then

	            newStackCount = newStackCount+1
	        else
	        	break
	        end
	    end
	   

    	local difference = newStackCount - oldStackCount

    	-- set stackcount
    	if difference ~= 0 then
    		caster:SetModelScale(caster:GetModelScale()+difference*model_size)
    		self:SetStackCount( newStackCount )
    		self:ForceRefresh()
    	end
		
	end
end

function modifier_Bukin_Rage:OnRefresh()
	self.berserkers_blood_attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus_per_stack" )
	self.berserkers_blood_movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	local StackCount = self:GetStackCount()
	local caster = self:GetParent()

    if IsServer() then
        self:GetParent():CalculateStatBonus()
    end
end

function modifier_Bukin_Rage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT 
	}

	return funcs
end

function modifier_Bukin_Rage:GetModifierAttackSpeedBonus_Constant ( params )
	return self:GetStackCount() * self.berserkers_blood_attack_speed
end

function modifier_Bukin_Rage:GetModifierMoveSpeedBonus_Constant ( params )
	return self:GetStackCount() * self.berserkers_blood_movespeed
end
