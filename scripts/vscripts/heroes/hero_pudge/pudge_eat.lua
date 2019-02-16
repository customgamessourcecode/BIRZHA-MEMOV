modifier_stun = class({})

function modifier_stun:CheckState() 
  local state =
      {
   [MODIFIER_STATE_STUNNED] = true
      }
  return state
end

function modifier_stun:IsHidden()
	return true
end