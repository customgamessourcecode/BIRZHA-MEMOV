LinkLuaModifier("modifier_ClubNoBroads","heroes/hero_bukin/ClubNoBroads.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ClubNoBroads_death","heroes/hero_bukin/ClubNoBroads.lua",LUA_MODIFIER_MOTION_NONE)

Bukin_ClubNoBroads = class({})

function Bukin_ClubNoBroads:OnUpgrade()
    if self.isScepterUpgraded == nil then
      self.isScepterUpgraded = false
    end
    local caster = self:GetCaster()
    local PID = caster:GetPlayerOwnerID()
    local mainMeepo = PlayerResource:GetSelectedHeroEntity(PID)
    local list = mainMeepo.meepoList or {}
    if caster~=mainMeepo then
        return nil
    end
    if not mainMeepo.meepoList then
        table.insert(list, mainMeepo)
        mainMeepo.meepoList=list
        mainMeepo:AddNewModifier(mainMeepo,self,"modifier_ClubNoBroads",{})
    end
    local newMeepo = CreateUnitByName(caster:GetUnitName(),mainMeepo:GetAbsOrigin(),true,mainMeepo,mainMeepo:GetPlayerOwner(),mainMeepo:GetTeamNumber())
    newMeepo:SetControllableByPlayer(PID,false)
    newMeepo:SetOwner(caster:GetOwner())
    newMeepo:AddNewModifier(mainMeepo,self,"modifier_phased",{["duration"]=0.1})
    local ability = newMeepo:FindAbilityByName(self:GetAbilityName())
    newMeepo:AddNewModifier(mainMeepo,self,"modifier_ClubNoBroads",{})
    list=mainMeepo.meepoList
    table.insert(list, newMeepo)
    mainMeepo.meepoList=list
end

function Bukin_ClubNoBroads:OnInventoryContentsChanged()
  for i=0,5,1 do
    local item = self:GetCaster():GetItemInSlot(i)
    if item and (string.find(item:GetAbilityName(), "item_ultimate_scepter")) then
        item:SetDroppable(false)
        item:SetSellable(false)
        item:SetCanBeUsedOutOfInventory(false)
        if not self.isScepterUpgraded then
          self.isScepterUpgraded=true
          self:OnUpgrade()
        end
        break
    end
  end
end

modifier_ClubNoBroads = class({})
function modifier_ClubNoBroads:IsHidden()
	return true
end

function modifier_ClubNoBroads:IsDebuff()
	return false
end

function modifier_ClubNoBroads:IsPurgable()
	return false
end

function modifier_ClubNoBroads:IsPermanent()
  return true
end

function modifier_ClubNoBroads:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ClubNoBroads:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ORDER,MODIFIER_EVENT_ON_RESPAWN,MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_ClubNoBroads:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end

function modifier_ClubNoBroads:OnIntervalThink()
    local meepo = self:GetParent()
    local mainMeepo = self:GetCaster()
    local ability = self:GetAbility()
    if mainMeepo~=meepo then
        local boots = {
          "item_travel_boots2",
          "item_travel_boots",
          "item_guardian_greaves",
          "item_power_treads",
          "item_arcane_boots",
          "item_phase_boots",
          "item_tranquil_boots",
          "item_boots",
          "item_boots_of_invisibility",
          "item_imba_phase_boots_2",
          "item_blink_boots",
          "item_force_boots",
          "item_pt_mem"
        }

        local item = ""
        for _, name in pairs(boots) do
            if item=="" then
                for j=0,5,1 do
                    local it = mainMeepo.GetItemInSlot(mainMeepo,j)
                    if it and (string.find(it.GetAbilityName(it), name)) then
                        item=it.GetAbilityName(it)
                    end
                end
            else
                break
            end
        end
        if item~="" then
            if meepo["item"] then
                if meepo["item"]~=item then
                    UTIL_Remove(meepo["itemHandle"])
                    local itemHandle = meepo.AddItemByName(meepo,item)
                    itemHandle.SetDroppable(itemHandle,false)
                    itemHandle.SetSellable(itemHandle,false)
                    itemHandle.SetCanBeUsedOutOfInventory(itemHandle,false)
                    meepo["itemHandle"]=itemHandle
                    meepo["item"]=item
                end
            else
                meepo["itemHandle"]=meepo.AddItemByName(meepo,item)
                meepo["item"]=item
            end
        end
        for j=0,5,1 do
            local itemToCheck = meepo.GetItemInSlot(meepo,j)
            if itemToCheck then
                local name = itemToCheck.GetAbilityName(itemToCheck)
                if name~=item then
                    UTIL_Remove(itemToCheck)
                end
            end
        end
        meepo.SetBaseStrength(meepo,mainMeepo.GetStrength(mainMeepo))
        meepo.SetBaseAgility(meepo,mainMeepo.GetAgility(mainMeepo))
        meepo.SetBaseIntellect(meepo,mainMeepo.GetIntellect(mainMeepo))
        meepo.CalculateStatBonus(meepo)
        while meepo.GetLevel(meepo)<mainMeepo.GetLevel(mainMeepo) do
            meepo.AddExperience(meepo,10,1,false,false)
        end
    else
        LevelAbilitiesForAllMeepos(meepo)
    end
end

function modifier_ClubNoBroads:OnTakeDamage(keys)
  local mainMeepo = self:GetCaster()
  local parent = self:GetParent()
  if keys.unit==parent then
    if parent:GetHealth() <= 0 then
      if parent~=mainMeepo then
        local oldLocation = mainMeepo:GetAbsOrigin()
        mainMeepo:SetAbsOrigin(parent:GetAbsOrigin())
        mainMeepo:Kill(keys.inflictor,keys.attacker)
        mainMeepo:SetAbsOrigin(oldLocation)
        parent:SetHealth(parent:GetMaxHealth())
        Timers:CreateTimer(0.1, function()
          parent:AddNewModifier(mainMeepo,self:GetAbility(),"modifier_ClubNoBroads_death",{})
        end)
      end
      for _, meepo in pairs(GetAllMeepos(mainMeepo)) do
        if meepo~=mainMeepo then
          meepo:AddNewModifier(mainMeepo,self:GetAbility(),"modifier_ClubNoBroads_death",{})
        end
      end
    end
  end
end

function modifier_ClubNoBroads:OnRespawn(keys)
    local parent = self:GetParent()
    local mainMeepo = self:GetCaster()
    for _, meepo in pairs(GetAllMeepos(mainMeepo)) do
      if meepo~=mainMeepo then
        meepo:RemoveModifierByName("modifier_ClubNoBroads_death")
        meepo:RemoveNoDraw()
        FindClearSpaceForUnit(meepo,mainMeepo:GetAbsOrigin(),true)
        meepo:AddNewModifier(meepo,self:GetAbility(),"modifier_phased",{["duration"]=0.1})
      end
    end
end

modifier_ClubNoBroads_death = class({})

function modifier_ClubNoBroads_death:IsPermanent()
    return true
end

function modifier_ClubNoBroads_death:IsHidden()
    return true
end

function modifier_ClubNoBroads_death:IsPurgable()
  return false
end

function modifier_ClubNoBroads_death:IsDebuff()
	return false
end

function modifier_ClubNoBroads_death:OnCreated()
  if IsServer() then
    self:GetParent():StartGesture(ACT_DOTA_DIE)
    self:StartIntervalThink(1.5)
  end
end

function modifier_ClubNoBroads_death:OnIntervalThink()
  local parent = self:GetParent()
  parent:RemoveGesture(ACT_DOTA_DIE)
  parent:AddNoDraw()
  if parent:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
      parent:SetAbsOrigin(Vector(-10000,-10000,0))
  else
      parent:SetAbsOrigin(Vector(10000,10000,0))
  end
  parent:SetHealth(parent:GetMaxHealth())
  parent:SetMana(parent:GetMaxMana())
  self:StartIntervalThink(-1)
end

function modifier_ClubNoBroads_death.CheckState(self)
    return {[MODIFIER_STATE_STUNNED]=true,[MODIFIER_STATE_UNSELECTABLE]=true,[MODIFIER_STATE_INVULNERABLE]=true,[MODIFIER_STATE_OUT_OF_GAME]=true,[MODIFIER_STATE_NO_HEALTH_BAR]=true,[MODIFIER_STATE_NOT_ON_MINIMAP]=true}
end

function LevelAbilitiesForAllMeepos(caster)
  local PID = caster:GetPlayerOwnerID()
  local mainMeepo = PlayerResource:GetSelectedHeroEntity(PID)
  if caster==mainMeepo then
    for a=0,caster:GetAbilityCount()-1,1 do
      local ability = caster:GetAbilityByIndex(a)
      if ability then
        for _, meepo in pairs(GetAllMeepos(mainMeepo)) do
          local cloneAbility = meepo:FindAbilityByName(ability:GetAbilityName())
          if ability:GetLevel() > cloneAbility:GetLevel() then
            cloneAbility:SetLevel(ability:GetLevel())
            meepo:SetAbilityPoints(meepo:GetAbilityPoints()-1)
          end
          if ability:GetLevel() < cloneAbility:GetLevel() then
            ability:SetLevel(cloneAbility:GetLevel())
            mainMeepo:SetAbilityPoints(mainMeepo:GetAbilityPoints()-1)
          end
        end
      end
    end
  end
end

function GetAllMeepos(caster)
  if caster.meepoList then
    return caster.meepoList
  else
    return {caster}
  end
end

function MeepoExperience(filterTable)
  local PID = filterTable.player_id_const
  local reason = filterTable.reason_const
  local experience = filterTable.experience
  local hero = PlayerResource:GetSelectedHeroEntity(PID)
  if (hero and hero:HasAbility("Bukin_ClubNoBroads")) and (reason~=DOTA_ModifyXP_Unspecified) then
    filterTable.experience=0
    hero:AddExperience(experience,DOTA_ModifyXP_Unspecified,true,false)
  end
  return filterTable
end

function MeepoOrderFilter(filterTable)
  local entindex_ability = filterTable.entindex_ability
  local sequence_number_const = filterTable.sequence_number_const
  local queue = filterTable.sequence_number_const
  local units = filterTable.units
  local entindex_target = filterTable.entindex_target
  local position = Vector(filterTable.position_y,filterTable.position_y,filterTable.position_z)
  local order_type = filterTable.order_type
  local issuer_player_id_const = filterTable.issuer_player_id_const
  local ability = EntIndexToHScript(entindex_ability)
  local target = EntIndexToHScript(entindex_target)
  for _, entindex_unit in pairs(units) do
    local unit = EntIndexToHScript(entindex_unit)
    if unit:HasModifier("modifier_ClubNoBroads") and (unit~=PlayerResource:GetSelectedHeroEntity(unit:GetPlayerOwnerID())) then
      if order_type==DOTA_UNIT_ORDER_PICKUP_ITEM then
        return false
      end
    end
    if ((target and target.HasModifier) and target:HasModifier("modifier_ClubNoBroads")) and (target~=PlayerResource:GetSelectedHeroEntity(target:GetPlayerOwnerID())) then
      if order_type==DOTA_UNIT_ORDER_GIVE_ITEM then
        return false
      end
    end
  end
  return true
end

if IsServer() then
    GameRules.GetGameModeEntity(GameRules).SetExecuteOrderFilter(GameRules.GetGameModeEntity(GameRules),function(f,filterTable)
        if MeepoOrderFilter then
            if not MeepoOrderFilter(filterTable) then
                return false
            end
        end
        return true
    end ,GameRules.GetGameModeEntity(GameRules))
    GameRules.GetGameModeEntity(GameRules).SetModifyExperienceFilter(GameRules.GetGameModeEntity(GameRules),function(f,filterTable)
        if MeepoExperience then
            filterTable=MeepoExperience(filterTable)
        end
        return true
    end ,GameRules.GetGameModeEntity(GameRules))
end