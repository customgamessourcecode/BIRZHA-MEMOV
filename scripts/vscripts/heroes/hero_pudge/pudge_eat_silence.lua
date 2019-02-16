modifier_silence_item = class({})

function modifier_silence_item:CheckState() 
  local state =
      {
   [MODIFIER_STATE_MUTED] = true
      }
  return state
end

function modifier_silence_item:IsHidden()
	return true
end