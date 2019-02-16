modifier_BirzhaMemov_startgame = class({})

--------------------------------------------------------------------------------

function modifier_BirzhaMemov_startgame:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_BirzhaMemov_startgame:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_BirzhaMemov_startgame:IsPurgeException()
	return true
end

--------------------------------------------------------------------------------

function modifier_BirzhaMemov_startgame:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_BirzhaMemov_startgame:AllowIllusionDuplicate()
	return false
end

function modifier_BirzhaMemov_startgame:OnCreated()
	if IsServer() then
		local player = self:GetParent():GetPlayerID()
		if IsUnlockedInPass(player, "reward11") then
			self.speedeffect = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		end
	end
	self:StartIntervalThink(0.1)
end

function modifier_BirzhaMemov_startgame:OnIntervalThink()
	local units = FindUnitsInRadius( self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	
	if #units > 0 then
		self:Destroy()
	end
end 

--------------------------------------------------------------------------------

function modifier_BirzhaMemov_startgame:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
	return funcs
end
--------------------------------------------------------------------------------

function modifier_BirzhaMemov_startgame:GetModifierMoveSpeed_Absolute( params )
	return 550	
end

function modifier_BirzhaMemov_startgame:OnDestroy(params)
	if IsServer() then
		if self.speedeffect then
			ParticleManager:DestroyParticle(self.speedeffect, true)
		end
	end
	return 0	
end

--------------------------------------------------------------------------------