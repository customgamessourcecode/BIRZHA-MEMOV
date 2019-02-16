function Screamer(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:IsRealHero() then
		local Player = PlayerResource:GetPlayer(target:GetPlayerID())
		EmitSoundOnClient("ScpScreamer", Player)
		CustomGameEventManager:Send_ServerToPlayer(Player, "ScpScreamerTrue", {} )
		ability:ApplyDataDrivenModifier(caster, target, "modifier_scp_screamer", {Duration = event.Dur})
	end
end

function ScreamerDestroy(keys)
	local target = keys.target
	local Player = PlayerResource:GetPlayer(target:GetPlayerID())
	CustomGameEventManager:Send_ServerToPlayer(Player, "ScpScreamerFalse", {} )
end