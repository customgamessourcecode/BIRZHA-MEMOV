modifier_rewards = class({})

--------------------------------------------------------------------------------

function modifier_rewards:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_rewards:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rewards:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_rewards:RemoveOnDeath()
	return false
end

function modifier_rewards:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
--------------------------------------------------------------------------------

function modifier_rewards:OnDeath(params)
	local player = self:GetParent():GetPlayerID()
	local hAttacker = params.attacker
	local hVictim = params.unit
	if IsServer() then
		if self:GetParent():IsRealHero() then
			if not self:GetParent():IsIllusion() then
				if IsUnlockedInPass(player, "reward7") then
					if hVictim == self:GetParent() and self:GetParent():IsRealHero() then
						local sEffect = "particles/birzhapass/birzha_death_effect.vpcf"
						local nFXIndex = ParticleManager:CreateParticle(sEffect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
						ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
						ParticleManager:ReleaseParticleIndex( nFXIndex )
					end
				end
			end
		end
	end
	return 0	
end