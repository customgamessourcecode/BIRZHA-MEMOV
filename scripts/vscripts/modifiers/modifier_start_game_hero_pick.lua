modifier_start_game_hero_pick = class({})

function modifier_start_game_hero_pick:IsHidden()
return true
end

function modifier_start_game_hero_pick:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true,[MODIFIER_STATE_MUTED]= true,[MODIFIER_STATE_SILENCED]= true,[MODIFIER_STATE_NIGHTMARED] = true,[MODIFIER_STATE_NO_HEALTH_BAR] = true,[MODIFIER_STATE_OUT_OF_GAME] = true,[MODIFIER_STATE_MAGIC_IMMUNE] = true,[MODIFIER_STATE_INVULNERABLE] = true, }
end
