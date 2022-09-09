--- --- ---
-- Title: CompactMacros
-- Version: 0.9
-- Description: My interface modifications, some fun or even practical chat utility, and assorted thoughts of mine put to code.
-- Author: illagong
--- --- ---

--[[ some stuff inspired by or blatantly copied from:

pbInfo by p.b. (a.k.a. novayuna)
released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
	
ComeOnIn by PetraAreon
released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/

Advanced AuctionHouse by McBen, Noguai
License: GNU General Public License version 3 (GPLv3)
--]]

-- ThisFrame : SetAnchor("ThisFrame anchor point", "anchor point on OtherFrame", "OtherFrame name", x change, y change)

--- --- --- BEGIN INTRO SECTION

local CompactMacros = {} --addon namespace, place all functions inside
_G.CompactMacros = CompactMacros --expose namespace to global scope
local CMframe = _G.CompactMacrosFrame --made in the XML
local chatty = true --debug

--for casting time on cast bar
local TimeStart = 0
local TimeNeed = 0

              
---[[ register many event at once. idea from aah
local FrameEvents = {
  "CHAT_MSG_GUILD",
  "CHAT_MSG_PARTY",
  "CHAT_MSG_WHISPER",
  
  "FOCUS_CHANGED",
  
  --"ACTIONBAR_UPDATE_COOLDOWN"
  --"COMBATMETER_HEAL",
  --[[
  --for redone pet bar
  "PET_ACTIONBAR_SHOW",
	"PET_ACTIONBAR_HIDE",
	"PET_ACTIONBAR_UPDATE",
  
  --for threat meter
  "COMBATMETER_DAMAGE",
  
  "TARGET_HATE_LIST_UPDATED",
  

  --]]
  }
for _, event in pairs(FrameEvents) do
  --can unregister events from other frames
  --for example, aah does:
  --AuctionFrame:UnregisterEvent(event)
  --AAH_AuctionFrame:RegisterEvent(event)
  CMframe:RegisterEvent(event)
end
---[[
local bgEvents = {
  "CLOSE_BATTLEGROUND_CAMP_SCORE_FRAME",
  "CLOSE_BATTLEGROUND_PLAYER_SCORE_FRAME",
  "CLOSE_BATTLEGROUND_ROOM_LIST_FRAME",
  "CLOSE_ENTER_BATTLEGROUND_QUERY_DIALOG",
  "ON_BATTLEGROUND_CLOSE",
  "OPEN_BATTLEGROUND_CAMP_SCORE_FRAME",
  "OPEN_BATTLEGROUND_PLAYER_SCORE_FRAME",
  "OPEN_BATTLEGROUND_ROOM_LIST_FRAME",
  "OPEN_ENTER_BATTLEGROUND_QUERY_DIALOG",
  "UPDATE_BATTLEGROUND_CAMP_SCORE",
  "UPDATE_BATTLEGROUND_PLAYER_SCORE",
  "UPDATE_BATTLEGROUND_ROOM_LIST_FRAME",
  "UPDATE_BATTLEGROUND_TOWER_IVAR",
}
for _, event in pairs(bgEvents) do
  CMframe:RegisterEvent(event)
end
--]]
CMframe:RegisterEvent("VARIABLES_LOADED")

function CompactMacros.EventHappened(event)
  --this gets annoying/spamming very quickly
  --DEFAULT_CHAT_FRAME:AddMessage("The registered event that was just processed was: "..event)
  
  if (event == "VARIABLES_LOADED") then
    --things to run on log-in:
    if (chatty == true) then
      DEFAULT_CHAT_FRAME:AddMessage("CompactMacros loaded.")
      
      --DEFAULT_CHAT_FRAME:AddMessage("global?: "..isthisglobal)
    end
    PlayerBuffFrameResize()
    HideButtons()
    
    --timer
    --this is anchored just right of the minigame score box, on top of the chat box
    TimeKeeperFrame:ClearAllAnchors()
    TimeKeeperFrame:SetAnchor("TOPLEFT", "TOPLEFT", "ChatFrame1", 153, -85)
    
    --ping/fps/zoneID
    --this is anchored left of the main action bar
    FramerateText:Show()
    FramerateText:ClearAllAnchors()
    FramerateText:SetAnchor("BOTTOMRIGHT", "BOTTOMLEFT", "MainActionBarFrame", 300, 0)
    
    -- +/- minimap zoom view
    MinimapFramePlusButton:ClearAllAnchors()
    MinimapFramePlusButton:SetAnchor("CENTER", "CENTER", MinimapFramePlayerPosition, 45, -5)
    MinimapFrameMinusButton:ClearAllAnchors()
    MinimapFrameMinusButton:SetAnchor("CENTER", "CENTER", MinimapFramePlayerPosition, -45, -5)
    
    --casting bar
    CastingBarFrame:ClearAllAnchors()
    CastingBarFrame:SetAnchor("BOTTOMLEFT", "TOPLEFT", "MainActionBarFrame", 10, -90)
    
    --casting bar of Focus1
    CM_FocusCastingBar:ClearAllAnchors()
    CM_FocusCastingBar:SetAnchor("TOPLEFT", "BOTTOMLEFT", "FocusFrame", 0, 8)
    
  --[[
  elseif (event == "COMBATMETER_HEAL") then
    if (UnitName("player") == "Toxinsembrace") and (UnitIsDeadOrGhost("target") == false) then
      CastSpellByName("Earth Arrow")
    end

  elseif (event == "COMBATMETER_DAMAGE") or (event == "COMBATMETER_HEAL") then
  
    elseif (event in bgEvents) then
    DEFAULT_CHAT_FRAME:AddMessage("event")
  --]]

  --[[
  elseif (event == "ACTIONBAR_UPDATE_COOLDOWN") then
    local a = arg1
    local b = arg2
    local c = arg3
    local d = arg4
    local e = arg5
    local f = arg6
    
    if a == nil then a = "foo" end
    if b == nil then b = "foo" end
    if c == nil then c = "foo" end
    if d == nil then d = "foo" end
    if e == nil then e = "foo" end
    if f == nil then f = "foo" end
    
    Msg(""..a.." "..b.." "..c.." "..d.." "..e.." "..f)
  --]]
  elseif (event == "CHAT_MSG_WHISPER") then
    local message = arg1
    local name = arg4
    local blockedPatterns = {
      --"blockthis",
      --"thistoo",
      }
    
    -- remove links and colors from string before parsing
    -- copied from ComeOnIn
    message = string.gsub(arg1,"|H[^|]*|h","");
    message = string.gsub(arg1,"|h","");
    message = string.gsub(arg1,"|c........","");
    message = string.gsub(arg1,"|r","");
    
    if ( type(message) ~= "string" or message == nil or type(name) ~= "string" or name == nil ) then
      DEFAULT_CHAT_FRAME:AddMessage("You got a whisper, but something went screwy. (error)")
    else
      --pattern matching works, need a way to hide pop-up...
      for _, pattern in pairs(blockedPatterns) do
        if ( string.find(message, pattern) ) then
          DEFAULT_CHAT_FRAME:AddMessage("Pattern matched, "..name.." has been added to your blacklist.")
          AddFriend("BadFriend", name) --adds to ignore list
        end
      end
      
      --[[
      for n=1,4 do
        messageText = _G["StaticPopup"..n.."Text"]:GetText()
        DEFAULT_CHAT_FRAME:AddMessage("messageText: "..messageText)
        
        for _, pattern in pairs(blockedPatterns) do
          if ( string.find(messageText, pattern) ) then
            DEFAULT_CHAT_FRAME:AddMessage("Pattern matched, is this a message you want to block?")
            blockPerson = true
            _G["StaticPopup"..n]:Hide();
          end
        end
      end
      --]]
    end
  --[[
  elseif (event == "UNIT_BUFF_CHANGED") then
         
         if (SMPAInSiege()) then
         if (event == "UNIT_BUFF_CHANGED" and arg1 =="player") then
            if (SMPAFindBuffName("Fearless", "player") and FEARLESS_ON == false) then
               FEARLESS_ON = true;
               SMPAFearlessTimer(180);
            elseif (HERALD_OBTAINED == false and SMPAFindBuffName("Herald", "player")) then
               SMPAGuildOut(SMPA_MSG.HERALD_OBTAINED);
            end
  --]]
            
  elseif (event == "FOCUS_CHANGED") then
    CM_FocusCastingBar:Hide()
  end
end


--[[


work on music check

--make arrays of length 6?
boolean haveMusic = false
int musicID = 0

--this will only save the first music found, if I have more than onetg
CheckMusic()
if haveItemInBag(luteID3) then
		haveMusic = true
		musicID - luteID3
	“” luteID7
	“” luteID30
	“” tambID3
	“” tambID7
	“” tambID30
else --not strictly needed
	SCM(“No Music”)
	boolean haveMusic = false
int musicID = 0
end
end

PlayMusic()
	if haveMusic then
	useItemByID(musicID)
	else
		SCM(No Music)
	end
end


function PlayMusic()
  --GetItemInBagByName("") could also be used
  local luteCountP   = GetBagItemCount(204534)
  local luteCount3   = GetBagItemCount(204544) --crafted
  local luteCount3IS = GetBagItemCount(204462) --item shop
  local luteCount7   = GetBagItemCount(204570)
  local luteCount30  = GetBagItemCount(206419)
  
  local tambCountP   = GetBagItemCount(204535)
  local tambCount3   = GetBagItemCount(204545) --crafted
  local tambCount3IS = GetBagItemCount(204463) --item shop
  local tambCount7   = GetBagItemCount(204571)
  local tambCount30  = GetBagItemCount(206420)
      
  local haveLute = (luteCountP + luteCount3 + luteCount3IS + luteCount7 + luteCount30) >= 1
  local haveTamb = (tambCountP + tambCount3 + tambCount3IS + tambCount7 + tambCount30) >= 1
  DEFAULT_CHAT_FRAME:AddMessage("lutes: "..haveLute.." and tambs: "..haveTamb)
  
  if (luteCountP > 0) then
    UseItemByName("Magic Lute (Prototype)")
  elseif(luteCount3 + luteCount3IS > 0) then
    UseItemByName("Magic Lute (3 days)")
  elseif (luteCount7 > 0) then
    UseItemByName("Magic Lute (7 days)")
  elseif (luteCount30 > 0) then
    UseItemByName("Magic Lute (30 days)")
  else
    DEFAULT_CHAT_FRAME:AddMessage("no lute")
  end
  
  if (tambCountP > 0) then
    UseItemByName("Magic Tambourine (Prototype)")
  elseif(tambCount3 + tambCount3IS > 0) then
    UseItemByName("Magic Tambourine (3 days)")
  elseif (tambCount7 > 0) then
    UseItemByName("Magic Tambourine (7 days)")
  elseif (tambCount30 > 0) then
    UseItemByName("Magic Tambourine (30 days)")
  else
    DEFAULT_CHAT_FRAME:AddMessage("no tamb")
  end
  
end
    --]]
   --[[ 
--make arrays of length 6?
boolean haveMusic = false
int musicID = 0

--this will only save the first music found, if I have more than onetg
GetMusic()
if haveItemInBag(luteID3) then
		haveMusic = true
		musicID - luteID3
	“” luteID7
	“” luteID30
	“” tambID3
	“” tambID7
	“” tambID30
else --not strictly needed
	SCM(“No Music”)
	boolean haveMusic = false
int musicID = 0
end
end

PlayMusic()
	if haveMusic then
	useItemByID(musicID)
	else
		SCM(No Music)
	end
end
--]]




function LowestHP()
  local isaraid = UnitInRaid("player")
  
  if (not isaraid) then
    SendChatMessage("Please convert to a raid.", "PARTY")
    return
  end
  
  local raidsize = GetNumRaidMembers()
  --local partysize = GetNumPartyMembers()
  
  local partyHP = {} --partyHP["name"] = health (as a percent)
  
  local i = 0
  local raidindex = ""
  local name = ""
  local online = false
  
  local totalhealth = 0
  local averagehealth = 1 -- average %hp of living players
  local minhealth = 1 --min %hp of living players
  local minhealthplayer = ""
  local playerhealth = 0
  
  local output = ""
  
  for i=1,12 do
    raidindex = "raid"..i
    name, online = GetRaidMember(i)
    
    if name then
      if online then --offline players generate a lot of nil values
        playerhealth = UnitHealth(raidindex) / UnitMaxHealth(raidindex)
        
        if playerhealth > 0 then --if unit is dead, skip them in the min and average calculations
          totalhealth = totalhealth + playerhealth
          
          if (playerhealth < minhealth) then
            minhealthplayer = raidindex
            minhealth = playerhealth
          end
        else --reduces the raid size by 1 if the player is dead
          raidsize = raidsize - 1
        end
        
        partyHP[raidindex] = playerhealth
        
        output = output.."\n"..raidindex..": "..name.." "..playerhealth
      else --offline dont count towards average
        raidsize = raidsize - 1
      end
    end
  end
  
  averagehealth = totalhealth / raidsize
  
  output = output.."\nlowest: "..minhealthplayer.."\naverage: "..averagehealth
  
  --SendChatMessage(output, "PARTY")
  
  return minhealthplayer, averagehealth
end


--[[
function RandomPerson(group, useOnline) --(group, online)
  local raidSize = GetNumRaidMembers()
  local partySize = GetNumPartyMembers()
  local namesAll = {}
  local namesOnline = {}
  local choice = 0
  local j = 0
  
  --DEFAULT_CHAT_FRAME:AddMessage("lets see who we get...")
  
  --select a random person from raid
  if(group == "raid") then
    
    if (raidSize == 0) then
      DEFAULT_CHAT_FRAME:AddMessage("You are not in a raid.")
      return
    end
    
    j = 1
    for i=1,36 do
      local name, online = GetRaidMember(i)
      namesAll[i] = name

      if (online) then
        namesOnline[j] = name
        j = j+1
      end
    end
    
    if (useOnline) then
      choice = math.random(1, j-1)
      SendChatMessage(namesOnline[choice]..", I choose you!","party")
    else
      choice = math.random(1, raidSize)
      SendChatMessage(namesAll[choice]..", I choose you!","party")
    end
    
    return
  end
  
  --select a random person from party
  if(partySize == 0) then
    DEFAULT_CHAT_FRAME:AddMessage("You are not in a party.")
    return
  end
  
  --a party is up to 5 people other than you, indexed 1 to 5
  namesAll[1] = UnitName("player")
  namesOnline[1] = UnitName("player")
  j = 2
  for i=2,6 do
    local name, online = GetPartyMember(i-1)
    namesAll[i] = name
    
    if (online) then
      namesOnline[j] = name
      j = j+1
    end
  end
  
  if (useOnline) then
    choice = math.random(1, j-1)
    SendChatMessage(namesOnline[choice]..", I choose you!","party")
  else
    choice = math.random(1, partySize)
    SendChatMessage(namesAll[choice]..", I choose you!","party")
  end
  
end



optional benefits: have a main tank designated 

mainTank = myNameByDefault
GetMainTank()
	return name and if person is in party or not
SetMainTank()
	when set, print if person is in party or not

optional: set main attacker

AutoHeal()
check if in raid or party
	for all members do
		store current hp / max hp
		store name
	end

	if (all > 90%) then
		target mainTank target
		debuff
	if tank under 80%
target tank
recover/blossom
elseif (num players under 80% hp >= 3 and CD(mef) = 0)
		target tank or lowest?
mef
	else
		target lowest
		recover
	end
end


function RaidHeal(mainTank, priorityTarget, other options?, ...)
  
  local tank = mainTank or 7
  local priority = priorityTarget or mainTank
  
  
  
  
end


--]]





--[[

function aoeCast(class)

if class == scout
	skill = Starshatter storm
elseif class == druid 
	skill == sandstorm
etc

castByName(skill)


--]]





--- --- --- BEGIN ALIAS SECTION

function CSBN(skill)
  CastSpellByName(skill)
end

function SCM(text, channel)
  SendChatMessage(text, channel)
end

function GSC(page, number)
  local a, b = GetSkillCooldown(page, number)
  return a, b
end

function STR(titleID)
  SetTitleRequest(titleID)
end

function UEI(gearslot)
  UseEquipmentItem(gearslot)
end

function ClearISS()
  SkillSuitFrame_DelAll_OnClick()
end

function GetISS(x, y)
  local a,b,c = GetSuitSkill_List(x, y)
  return a, b, c
end

function PlaceISS(x, y)
  SkillPlateReceiveDrag(x, y)
end

function UD(name, i)
  UnitDebuff(name,i)
end

function TU(uid)
  TargetUnit(uid)
end

function UEA(x)
  UseExtraAction(x)
end

function UCT(x)
  a, b = UnitClassToken(x)
  return a, b
end


--[[
function Shift()
  return IsShiftKeyDown()
end

function Ctrl()
  return IsCtrlKeyDown()
end

function Alt()
  return IsAltKeyDown()
end
--]]



function EquipISS()
--DIYCEmainClass, DIYCEsubClass = UnitClassToken("player")

--[[
function ClearISS()
  SkillSuitFrame_DelAll_OnClick()
end

function GetISS(x, y)
  local a,b,c = GetSuitSkill_List(x, y)
  return a, b, c
end

function PlaceISS(x, y)
  SkillPlateReceiveDrag(x, y)
end
--]]

end



--[[ original:
/cast Charged Chop
/run SWT,SW=GetActionCooldown(3);if(SW==0) then CastSpellByName("Savage Whirlwind") end
/run TAT, TA= GetActionCooldown(7); B = 0;V=false;W=false;H=false;R=UnitRace("target");M=UnitMana("player");for i=1,40 do local name, icon, count, ID =UnitDebuff("target", i);if ID == 501502 then V= true elseif name== "Weakened" then W= true elseif ID == 500081 then B = B+1 end end;if(R =="Humanoid" or R== "Beast") then H = true end;if(B>1 and TA<0.35) then CastSpellByName("Tactical Attack") end; if(V) then CastSpellByName("Open Flank") elseif(H and (V or W) and M>25) then CastSpellByName("Slash") elseif(B>0 and TA<0.3) then CastSpellByName("Tactical Attack") elseif(W) then CastSpellByName("Slash") else CastSpellByName("Probing Attack") end
Savage Whirlwind on key 3
Tactical Attack on key 7
--]]

--/cast Charged Chop before macro
function SoppyLogic()

  --Savage Whirlwind on key 3
  SWT, SW = GetActionCooldown(3)
  
  if (SW==0) then 
    CastSpellByName("Savage Whirlwind") 
  end
  
  --Tactical Attack on key 7
  TAT, TA = GetActionCooldown(7)
  
  B = 0 --slash bleed count
  V = false
  W = false
  H = false
  R = UnitRace("target")
  M = UnitMana("player") --rage
  
  for i=1,40 do
    local name, icon, count, ID = UnitDebuff("target", i)
    
    if ID == 501502 then --vulnerable from probing
      V = true 
    elseif name == "Weakened" then 
      W = true 
    elseif ID == 500081 then --slash bleed count
      B = B + 1 
    end 
  end
  
  if (R == "Humanoid" or R == "Beast") then
    H = true 
  end
  
  if (B>1 and TA<0.35) then 
    CastSpellByName("Tactical Attack")
  end
  
  if (V) then 
    CastSpellByName("Open Flank") 
  elseif (H and (V or W) and M>25) then 
    CastSpellByName("Slash") 
  elseif (B>0 and TA<0.3) then 
    CastSpellByName("Tactical Attack") 
  elseif (W) then 
    CastSpellByName("Slash") 
  else
    CastSpellByName("Probing Attack") 
  end
  
end

function BetterAttack()
  OnClick_QuestListButton(3, 1)
  CompleteQuest()
  OnClick_QuestListButton(1, 1)
  AcceptQuest()
  CSBN("Attack")
end

function Warlock_Dark_Damage()

  total_dark_damage = 71.3 -- ill will

  for i=1,100,1 do 
  
    local name, icon, count, ID = UnitBuff("player", i)
    
    if ID == 624354 then -- Dark Soul Essence
      total_dark_damage = total_dark_damage + 50
    end
    
    if ID == 624362 then -- Steps in the Abyss, generated by Abyss Footsteps
      total_dark_damage = total_dark_damage + (4*count)
    end
    
  end
  
  return total_dark_damage

end

function Warlock_Fire_Damage()

  total_fire_damage = 0 -- Fire Tali

  for i=1,100,1 do 
  
    local name, icon, count, ID = UnitBuff("player", i)
    
    if ID == 621397 then -- Blazing Barrier
      total_fire_damage = total_fire_damage + 40
    end
    
  end
  
  return total_fire_damage

end




--[[

function CM_wd_s_dps()

	local Skill = {}
	local Skill2 = {}
	local i = 0
  
	local combat = GetPlayerCombatState()
	local enemy = UnitCanAttack("player","target")
	local EnergyBar1 = UnitMana("player")
	local EnergyBar2 = UnitSkill("player")
	local pctEB1 = PctM("player")
	local pctEB2 = PctS("player")
	local tbuffs = BuffList("target")
	local pbuffs = BuffList("player")
	local tDead = UnitIsDeadOrGhost("target")
	local a1,a2,a3,a4,a5,ASon = GetActionInfo(20)  -- assumes Autoshot is in slot 20
	local ammo = (GetEquipSlotInfo(10) ~= nil)
	local phealth = PctH("player")
	local thealth = PctH("target")
	local LockedOn = UnitExists("target")
	local boss = UnitSex("target") > 2
	
	--Determine Class-Combo
	mainClass, subClass = UnitClassToken( "player" )

	--Silence Logic
	local tSpell,tTime,tElapsed = UnitCastingTime("target")
	local silenceThis = tSpell and silenceList[tSpell] and ((tTime - tElapsed) > 0.1)
	
  
  
  
  	--Begin Player Skill Sequences
    --Priest = AUGUR, Druid = DRUID, Mage = MAGE, Knight = KNIGHT, Scout = RANGER, 
    --Rogue = THIEF, Warden = WARDEN, Warrior = WARRIOR, Warlock = HARPSYN, Champion = PSYRON

    
      -- warden/scout wd/s
      if mainClass == "WARDEN" and subClass == "RANGER" then
        local petExists = UnitExists("pet")
        local ASEclipse = GetActionUsable(20)
        
        if (mode == "buff") then
          Skill = { 
            { name = "Savage Power",				    use = (EnergyBar1 >= 240) },
            { name = "Power of the Oak",				use = (EnergyBar1 >= 330) },
            { name = "Explosion of Power",		  use = (EnergyBar1 >= 300) and (petExists) }, 
            { name = "Morale Boost",				    use = (EnergyBar2 >=  35) and (not pbuffs["Morale Boost"])},
          }
        elseif (mode == "aoe") then
          Skill = {
            { name = "Frantic Briar",			      use = (EnergyBar1 >= 1078) },
          }
        else
          Skill = {
            { name = "Briar Shield",				  use = (not combat) and (EnergyBar1 >= 462) and ((not pbuffs["Briar Shield"]) or (pbuffs["Briar Shield"].time <= 45)) },
            { name = "Protection of Nature",	use = (not combat) and (EnergyBar1 >= 330) and ((not pbuffs["Protection of Nature"]) or (pbuffs["Protection of Nature"].time <= 45)) },  
          }
        end

        if enemy then
          if (mode == "range") then
            Skill2 = {
              { name = "Anti-Magic Arrow",		    use = (EnergyBar2 >= 30) and (SeigeWar) },
              { name = "Vampire Arrows",			    use = (EnergyBar2 >= 20) },
              { name = "Shot",				            use = true },
              { name = "Anti-Magic Arrow",		    use = (EnergyBar2 >= 80) },
            }
          elseif (mode == "ignorelos") then --any others?
            Skill2 = {
              { name = "Anti-Magic Arrow",		    use = (EnergyBar2 >=   30) },
              { name = "Movement Restriction",    use = (EnergyBar1 >=  270) },
              { name = "Cross Chop",              use = (EnergyBar1 >=  770) },
              { name = "Frantic Briar",			      use = (EnergyBar1 >= 1078) },
            }
          elseif (mode == "aoe") then -- AoE + multi-target
            Skill2 = {
              --{ name = "Power of the Wood Spirit",  use = (EnergyBar1 >= 225) },
              { name = "Cross Chop",                use = (EnergyBar1 >= 770) },
              { name = "Untamable",                 use = (EnergyBar2 >=  40) },
              { name = "Action: 20",                use = (ASEclipse) }, 
              --{ name = "Joint Blow",                use = (EnergyBar2 >=  30) },
              { name = "Shot",				              use = true },
            }
          elseif (mode == "noaoe") then --only single target chops
            Skill2 = {
              { name = "Throat Attack",				  use = (silenceThis) and (EnergyBar2 >= 15) },
              { name = "Savage Power",				  use = (EnergyBar1 >= 240) and boss },
              { name = "Power of the Oak",			use = (EnergyBar1 >= 330) and boss },
              { name = "Explosion of Power",		use = (EnergyBar1 >= 300) and boss and (petExists) }, 
              { name = "Morale Boost",				  use = (EnergyBar2 >=  35) and boss and (not pbuffs["Morale Boost"]) },
              { name = "Untamable",             use = (EnergyBar2 >=  40) },
              { name = "Action: 20",            use = (ASEclipse) }, 
              { name = "Vampire Arrows",			  use = (EnergyBar2 >=  20) },
              { name = "Shot",				          use = true },
            }
          elseif (mode == "hoe") then --buffs and sustained mana usage
            Skill2 = {
              { name = "Throat Attack",				  use = (silenceThis) and (EnergyBar2 >= 15) },
              { name = "Savage Power",				  use = (EnergyBar1 >= 240) },
              { name = "Power of the Oak",			use = (EnergyBar1 >= 330) },
              { name = "Explosion of Power",		use = (EnergyBar1 >= 300) and (petExists) }, 
              { name = "Morale Boost",				  use = (EnergyBar2 >=  35) and (not pbuffs["Morale Boost"]) },
              { name = "Untamable",             use = (EnergyBar2 >=  40) },
              { name = "Action: 20",            use = (ASEclipse) }, 
              { name = "Vampire Arrows",			  use = (EnergyBar2 >=  20) },
              { name = "Shot",				          use = true },
            }
          elseif (mode == "hundredrange") then --only spells with 100+ range. used in beth, bela, ...
            Skill2 = {
              { name = "Throat Attack",				  use = (silenceThis) and (EnergyBar2 >= 15) },
              { name = "Savage Power",				  use = (EnergyBar1 >= 240) and boss },
              { name = "Power of the Oak",			use = (EnergyBar1 >= 330) and boss },
              { name = "Explosion of Power",		use = (EnergyBar1 >= 300) and boss and (petExists) }, 
              { name = "Morale Boost",				  use = (EnergyBar2 >=  35) and boss and (not pbuffs["Morale Boost"]) },
              { name = "Vampire Arrows",			  use = (EnergyBar2 >=  20) },
              { name = "Cross Chop",            use = (pctEB1     >= 0.35) },
              { name = "Shot",				          use = true },
              { name = "Joint Blow",            use = (EnergyBar2 >=  35) },
            }
          elseif (mode == "aggro") then
            Skill2 = {
              { name = "Throat Attack",				  use = (silenceThis) },
              --{ name = "Charged Chop",				  use = (EnergyBar1 >=  300) },
              { name = "Briar Shield",				  use = (EnergyBar1 >= 462) and ((not pbuffs["Briar Shield"]) or (pbuffs["Briar Shield"].time <= 15)) },
              { name = "Protection of Nature",	use = (EnergyBar1 >= 330) and ((not pbuffs["Protection of Nature"]) or (pbuffs["Protection of Nature"].time <= 15)) },      
              { name = "Frantic Briar",			    use = (pctEB1     >= 0.50) and boss },
              { name = "Cross Chop",            use = (pctEB1     >= 0.35) },
              { name = "Savage Power",				  use = (EnergyBar1 >=  350) and boss },
              { name = "Power of the Oak",			use = (EnergyBar1 >=  330) and boss },
              { name = "Explosion of Power",		use = (EnergyBar1 >=  300) and boss and (petExists) }, 
              --{ name = "Morale Boost",				  use = (EnergyBar2 >=   35) and boss and (not pbuffs["Morale Boost"]) },
              { name = "Untamable",             use = (EnergyBar2 >=   40) },
              { name = "Action: 20",            use = (ASEclipse) }, 
              --{ name = "Vampire Arrows",			  use = (EnergyBar2 >=   20) },
              { name = "Shot",				          use = true },
            }
          elseif (mode == "nobuff") then
            Skill2 = {
              { name = "Throat Attack",				  use = (silenceThis) },
              --{ name = "Charged Chop",				  use = (EnergyBar1 >=  300) },
              { name = "Untamable",             use = (EnergyBar2 >=   40) },
              { name = "Frantic Briar",			    use = (pctEB1     >= 0.30) and boss },
              { name = "Action: 20",            use = (ASEclipse) }, 
              { name = "Cross Chop",            use = (pctEB1     >= 0.35) },
              --{ name = "Vampire Arrows",			  use = (EnergyBar2 >=   20) },
              { name = "Shot",				          use = true },
            }
          else --dps
            Skill2 = {
              { name = "Throat Attack",				  use = (silenceThis) },
              { name = "Frantic Briar",			    use = (EnergyBar1 >= 1078) and tbuffs["Authoritative Deterrence"] and tbuffs["Silence"] },
              { name = "Cross Chop",		        use = (EnergyBar1 >=  770) and tbuffs["Authoritative Deterrence"] and tbuffs["Silence"] },
              --{ name = "Charged Chop",				  use = (EnergyBar1 >=  300) },
              --{ name = "Midnight Ritual",       use = boss and (not tbuffs["Midnight Ritual"]) },
              { name = "Savage Power",				  use = (EnergyBar1 >=  240) and boss },
              { name = "Power of the Oak",			use = (EnergyBar1 >=  330) and boss },
              { name = "Explosion of Power",		use = (EnergyBar1 >=  300) and boss and (petExists) }, 
              { name = "Morale Boost",				  use = (EnergyBar2 >=   35) and boss and (not pbuffs["Morale Boost"]) },
              { name = "Untamable",             use = (EnergyBar2 >=   40) },
              --{ name = "Tactical Smash",        use = boss and (not tbuffs["Tactical Smash"] ) },
              { name = "Action: 20",            use = (ASEclipse) }, 
              { name = "Cross Chop",            use = (pctEB1     >= 0.35) },
              --{ name = "Vampire Arrows",			  use = (EnergyBar2 >=   20) },
              { name = "Shot",				          use = true },
            }
          end
        end



end
--]]




--- --- ---  BEGIN ALT SWAPPING HELP

-- because MoveRaidMember() crashes client if used when not in a raid
-- chat spots moved
-- chat if no assist
function CM_SwapIfInRaid(x, y)
  if UnitInRaid("player") then
    MoveRaidMember(x, y)
  else
    Msg("Swap failed, you're not in a raid.")
  end
end

--function CM_GetPosition()
  --local inRaid = UnitInRaid("player")
  --UnitName("player")
  
  
  --for 
  
  --for id = 1, 12 do 
    --name, online, hasAssist = GetRaidMember(id)
  
--end

function CM_UnitSwap(class)
  if UnitInRaid("player") then
    if IsRaidAssistant() or IsRaidLeader() then
    
      for id = 1, 12 do
        local mainClass, subClass = UnitClassToken("raid"..id)
        if mainClass then
          SCM("raid"..id.." "..mainClass.." "..subClass)
          
          --[[
          if (id > 6) then --party 2
            if (mainClass == "KNIGHT") and (subClass == "AUGUR") and (class == "kp") then 
              MoveRaidMember(id, 6)
              SCM("K/P swapped in.")
            elseif (mainClass == "WARDEN") and (subClass == "RANGER") and (class == "wds") then
              MoveRaidMember(id, 6)
              SCM("Wd/S swapped in.")
            elseif (mainClass == "PSYRON") and (subClass == "AUGUR") and (class == "cp") then
              MoveRaidMember(id, 6)
              SCM("C/P swapped in.")
            elseif (mainClass == "HARPSYN") or (mainClass == "MAGE") and (class == "wlm") then
              MoveRaidMember(id, 6)
              SCM("Wl/M swapped in.")
            else
              SCM("Swap failed, class not found in group two: "..class..". Supported options: kp, wds, cp, wlm.", "party")
            end --class match
          end -- party 2
          --]]
          
        end --toon exists
      end -- for
    else
      SCM("Swap failed, I do not have assist.", "party")
    end -- assist
  else
    Msg("Swap failed, you're not in a raid.")
  end --in raid
end

--local swap_pos_tank = 7
local swap_pos_healer = 8
local swap_pos_custom = 9
local swap_pos_knight_priest = 10
local swap_pos_warden_scout = 11
local swap_pos_champion_priest = 12

function CM_RaidSwap()
  if UnitInRaid("player") then
    local mainClass, subClass = UnitClassToken("player")
    local myname = UnitName("player")
    
    --Priest = AUGUR, Knight = KNIGHT, Scout = RANGER, Warden = WARDEN, Champion = PSYRON, Druid = DRUID,
    --Mage = MAGE, Rogue = THIEF, Warrior = WARRIOR, Warlock = HARPSYN, 
  
    local name = ""
    local canSwap = false
    
    for id = 1, 12 do
      name = GetRaidMember(id) -- name, online state, assistant state = GetRaidMember(id)
      canSwap = IsRaidAssistant() or IsRaidLeader()
      
      if (myname == name) then
        if (not canSwap) then
          SCM("Swap failed, I do not have assist.", "party")
        else
          if (id > 6) then --party 2
            if (mainClass == "KNIGHT") and (subClass == "AUGUR") then 
              swap_pos_knight_priest = id
              MoveRaidMember(id, 6)
            elseif (mainClass == "WARDEN") and (subClass == "RANGER") then
              swap_pos_warden_scout = id
              MoveRaidMember(id, 6)
            elseif (mainClass == "PSYRON") and (subClass == "AUGUR") then
              swap_pos_champion_priest = id
              MoveRaidMember(id, 6)
            elseif (mainClass == "AUGUR") or (mainClass == "DRUID") then
              swap_pos_healer = id
              MoveRaidMember(id, 6)
            else
              swap_pos_custom = id
              MoveRaidMember(id, 6)
            end
          else -- id <= 6, party 1
            if (mainClass == "KNIGHT") and (subClass == "AUGUR") then 
              if (swap_pos_knight_priest > 6) then 
                MoveRaidMember(6, swap_pos_knight_priest)
              end
            elseif (mainClass == "WARDEN") and (subClass == "RANGER") then
              if (swap_pos_warden_scout > 6) then 
                MoveRaidMember(6, swap_pos_warden_scout)
              end
            elseif (mainClass == "PSYRON") and (subClass == "AUGUR") then
              if (swap_pos_champion_priest > 6) then 
                MoveRaidMember(6, swap_pos_champion_priest)
              end
            elseif (mainClass == "AUGUR") or (mainClass == "DRUID") then
              if (swap_pos_healer > 6) then 
                MoveRaidMember(6, swap_pos_healer)
              end
            else
              if (swap_pos_custom > 6) then 
                MoveRaidMember(6, swap_pos_custom)
              end
            end
          end -- party 1/2
        end -- assist
      end -- name
    end -- for
  else 
    Msg("Swap failed, you're not in a raid.")
  end -- in raid
end

--/run CM_ChatCast("spell")
function CM_ChatCast(spell)

  local position = 0
  local raidAddition = ""
  local inRaid = UnitInRaid("player")

  if inRaid then
    position = UnitRaidIndex("player")
    raidAddition = " from raid position "..position
  end

  CastSpellByName(spell)
  SendChatMessage(spell.." cast"..raidAddition, "party")
end

--doesnt check raid members 13-36
--API:GetNumRaidMembers
function CM_AssistCheck()

  local name = ""
  local online = false
  local hasAssist = false
  
  local allOnline = true
  local allHaveAssist = true

  for id = 1, 12 do 
    name, online, hasAssist = GetRaidMember(id)
    
    --if raid slot is empty, name is nil
    if name then
      local leader = UnitIsRaidLeader("raid"..id) --tostring(id))
      
      if not online then
        allOnline = false
        SCM(name.." is offline.", "party")
      else
        if (not hasAssist) and (not leader) then
          allHaveAssist = false
          SCM(name.." needs assist.", "party")
        end
      end
      
    end
  end
  
  if allOnline and allHaveAssist then
    return true
  else
    return false
  end
end



--[[
local silenceList = {
  ["Annihilation"] = true,
  ["King Bug Shock"] = true,
  ["Mana Rift"] = true,
  ["Dream of Gold"] = true,
  ["Flame"] = true,
  ["Flame Spell"] = true,
  ["Wave Bomb"] = true,
  ["Silence"] = true,
  ["Recover"] = true,
  ["Restore Life"] = true,
  ["Heal"] = true,
  ["Curing Shot"] = true,
  ["Leaves of Fire"] = true,
  ["Urgent Heal"] = true,
  ["Heavy Shelling"] = true,
  ["Dark Healing"] = true,
  ["Boiling Ink"] = true, --grotto octopus
  ["Concentrated Decay"] = true, --coe 4th
  }	
  
local housePercentList = {
  [""] = true, 
  [""] = true, 
  }
  
local houseFixedList = {
  
  }
  
local weddingPercentList = {

  }
  
local weddingOtherList = {

  }

local foodDefenseList = {

  }

local foodOffenseList = {

  }

  
function CM_CheckBuffs()

  UnitBuff("player", i = 1 to 100)

  local houseP = 
  local silenceThis = tSpell and silenceList[tSpell] and ((tTime - tElapsed) > 0.1)
  

check for food/pots/buffs
	lists for possible buffs: house%, house#, wedding1, wedding2, attack, def, hero


end


Master list M
some number of component list (say 4: A, B, C, D)
no single list contains duplicates
the sum of the component lists contains no duplicates

(insert evaluation to determine if M contains exactly one item from each component list)

if M contains exactly one item from each component list then
	return true
else
	return false
end
Hash


brute force: iterate of all of M for each item in each component list

breaking: as per brute force, but stop once a match is found

sorting: sort M. combine components into list Z, sort Z
pointers for each list pM, pZ
counter = 0
if pM.value < pZ.value
	increment pM
elseif pM.value > pZ.value
	increment pZ
else (aka pM.value = pZ.value)
	counter++
	increment pM
	increment pZ
end
stop if you try to increment a pointer beyond its list
return true if counter = 4 (or whatever the number of component lists is)

needs only one pass over each of the two lists


---

get current buff list
sort current buff list

(create 7 buff type lists)
(combine to master buff list)
(combine or directly create master) buff check list
sort buff check list
compare current list to check list
elements shared count should equal 7 (2 house, 2 wedding, atk, def, hero)
return (countShard == 7)


Have buff check for classes in party
Ex. if party has a k/p, then check everyone for holy protection
If party has a wl, everyone will have sublimations




--]]


--[[
--/run CM_AmIReady()

function CM_AmIReady()

--1/4
check gear durability
	have an exception list
  local durabilityExceptionList
 
--2/4
onlineAndAssist = CM_AssistCheck()

--3/4
check cooldown for 3s/5s/music/pots

--4/4
buffCheck = CM_CheckBuffs()

  if 4 above are true) then
    SCM(“ready”)
  else
    SCM(not ready for the following reason: …)
  end
end

--]]



function tif()
--[[
name, id, taste, icon, classify1, classify2, rating, brief, infrequent GetTitleInfoByIndex = (index)

Index: The title number in the securities that you own. If you have 12, the index is 1 to 12. (0 to 11 ??)
Name: Title name
taste: If you have the title (true)
icon: The path to the icon
classify1: Title number in the category where it is located
classify2: The number the category in which the title is
Note: The message displayed for the title in the Title window (complete the followign quests...)
brief: Short version of the note title.
Rare: Rarity title.

general
  current
  custom
quest
  special
  Howling Mountains
  Silverspring
  Sascilia Steppes
  Aslan Valley
  Ystra Highlands
  Dragonfang Ridge
  Dust Devil Canyon
  Ravenfell
  Aotulia Volcano
  Weeping Coast
  Savage Lands
  Elven Island
  Thunderhoof Hills
  Southern Janost Forest
  Northern Janost Forest
  Limo Desert
  Land of Malevolence
  Coast of Opportunity
  Xaviera
  Redhill Mountains
  Tergothen Bay
  Ancient Kingdom of Rorazan
  Chrysalia
  Merdhin Tundra
  Syrbal Pass
  Sarlo
  Wailing Fjord
  Jungle of Hortek
  Salioca Basin
  Kashalyn
  Yrvandis Hollows
  Splitwater
challenge
  hunting
  instance
system
  planting
  guildcrafting
  relationship
event
  event instance
  festival event
other
  normal

--]]

  --for i = 0, GetTitleCount()-1 do --470 atm
  --650 in game atm?
  
  DEFAULT_CHAT_FRAME:AddMessage(""..GetTitleCount())
  
  for i = 1, 100 do --, GetTitleCount()-1 do
  
  
    local Name, TitleID, Have, Icon, Classify1, Classify2, Note, Brief, Rare = GetTitleInfoByIndex(i)
    
    if (Name) then
      DEFAULT_CHAT_FRAME:AddMessage(""..i.." "..Name.." "..TitleID.." "..Classify1.." "..Classify2.." "..Brief.." "..Rare)
    end
    --[[
    if (Have) then
      DEFAULT_CHAT_FRAME:AddMessage(""..i.." "..Name)
    end
    --]]
  end
  



end

--- --- --- BEGIN CHAT SECTION

--[[

s:lower()

Make uppercase characters lower case.

> = string.lower("Hello, Lua user!")
hello, lua user!


--(incomplete) error checking for channel input
function validChannel(channelName, nameOrNumber)
  chan = string.lower(channelName)
  
  if (chan == "yell") or (chan == "world") then
    return true, "yell", "0"
  elseif (chan == "raid") or (chan == "party") then
    return true, "party", "0"
  elseif (chan == "say") or (chan == "zone") or (chan == "guild") then
    return true, chan, "0"
  elseif (chan == "whisper") then
    return true, chan, nameOrNumber
  elseif (chan == "channel") then
    return true, chan, nameOrNumber
  else
    DEFAULT_CHAT_FRAME:AddMessage("The channel you tried to speak to was unavailable. (error)"
    return false, "say", "0"
  end
end
--]]

--[[
-- pick the name of a random person in party/raid
-- group
-- "raid" : select a random person from raid
-- anything else : select a random person from party (default)
-- useOnline
-- true : select only from players that are online
-- false : select from all players in party/raid (default)
--]]
function RandomPerson(group, useOnline) --(group, online)
  local raidSize = GetNumRaidMembers()
  local partySize = GetNumPartyMembers()
  local namesAll = {}
  local namesOnline = {}
  local choice = 0
  local j = 0
  
  --DEFAULT_CHAT_FRAME:AddMessage("lets see who we get...")
  
  --select a random person from raid
  if(group == "raid") then
    
    if (raidSize == 0) then
      DEFAULT_CHAT_FRAME:AddMessage("You are not in a raid.")
      return
    end
    
    j = 1
    for i=1,36 do
      local name, online = GetRaidMember(i)
      namesAll[i] = name

      if (online) then
        namesOnline[j] = name
        j = j+1
      end
    end
    
    if (useOnline) then
      choice = math.random(1, j-1)
      SendChatMessage(namesOnline[choice]..", I choose you!","party")
    else
      choice = math.random(1, raidSize)
      SendChatMessage(namesAll[choice]..", I choose you!","party")
    end
    
    return
  end
  
  --select a random person from party
  if(partySize == 0) then
    DEFAULT_CHAT_FRAME:AddMessage("You are not in a party.")
    return
  end
  
  --a party is up to 5 people other than you, indexed 1 to 5
  namesAll[1] = UnitName("player")
  namesOnline[1] = UnitName("player")
  j = 2
  for i=2,6 do
    local name, online = GetPartyMember(i-1)
    namesAll[i] = name
    
    if (online) then
      namesOnline[j] = name
      j = j+1
    end
  end
  
  if (useOnline) then
    choice = math.random(1, j-1)
    SendChatMessage(namesOnline[choice]..", I choose you!","party")
  else
    choice = math.random(1, partySize)
    SendChatMessage(namesAll[choice]..", I choose you!","party")
  end
  
end

--also it take in-game input from me/other? (in any/specified chat)
local quotesToSay = {
  "Let justice be done, though the heavens fall. - Aldnoah Zero", 
  "Well, yeah, you don't need to be sober to DPS. - Rustyx",
  "Dammit Chiron! - illagong",
  "Bring me another glass...Brain, Brain Eraser! I am THE MAN! - Drunkard",
  "How about ice shruiken? - Sean \n Irish shuriken? Aren't those just frozen shamrocks? - Peter",
  "Hairmature - a person who's a hair's width better than an amateur. - Kittan, Gurren Lagann",
  "Zamorak is chaos ... He is freedom to do what you need to do. Zamorak is the strength to act. - Tenebra, Legacy of Blood",
  "Hop, hop, hopptiy hop, and then you fall in molten lava. - Runescape, wilderness agility course",
  "I'm pretty sure the way God treats his non-followers is outlawed by the Geneva convention and by most of human civilization. - Bighaben, MTGS",
  "I can't facepalm any harder without breaking a bone. - Luminum Can, MTGS",
  "If a binary search tree falls in the forest, does it cause a stack overflow?",
  "Give me ambiguity or give me something else.",
  "Error, no keyboard - press F1 to continue.",
  "When there's a will, I want to be in it.",
  "Never forget: 2 + 2 = 5 for extremely large values of 2.",
  "A journey of a thousand sites begins with a single click.",
  "What boots up must come down.",
  }
local numQuotes = table.getn(quotesToSay)  

function RandomQuote(channel, num)
  local temp = math.random(1, numQuotes)
  local number = num or 0
  SendChatMessage(quotesToSay[temp], channel, 0, number)
end

local battleCry = {
  "We should begin. Let strength decide the outcome.",
  "Did you forget enchanted throw?",
  --"%T season!",
  "It's time to take chances, make mistakes, and get messy!",
  "Too much time in the toaster, not enough cream cheese!",
  "Then, everything changed when the Corruption Nation attacked."
  }
local numCries = table.getn(battleCry)
  
function RandomBattleCry(channel)
  local temp = math.random(1, numCries)
  SendChatMessage(battleCry[temp], channel)
end

--- --- --- BEGIN UTILITY SECTION

--[[
local AttackTimeStart = 0
local AttackTimeNeed = 0
local TimeToAttack = false

function threeseconds()
  AttackTimeStart = GetTime()
  
  while (IsShiftKeyDown()) do
    if TimeToAttack = true then
      DEFAULT_CHAT_FRAME:AddMessage("Time to attack, since it's been 3 seconds.")
      AttackTimeStart = GetTime()
      TimeToAttack = false
    end
    
  end

  <OnEvent>
    if ( event == "CASTING_START" ) then
      CastingBarText:Hide();
      CM_CastingBarText:SetText(arg1);
      CompactMacros.TimeStart = GetTime();
      CompactMacros.TimeNeed = arg2;
      this:Show();
    elseif ( event == "CASTING_STOP" and this:IsVisible() ) then
      this:Hide();
    elseif ( event == "CASTING_FAILED" and this:IsVisible() ) then
      this:Hide();
    elseif ( event == "CASTING_DELAYED" and this:IsVisible() ) then
      CompactMacros.TimeNeed = CompactMacros.TimeNeed + arg1;
    end;
  </OnEvent>
  
  <OnUpdate>
    local ElapsedTime = CompactMacros.TimeNeed - (GetTime() - CompactMacros.TimeStart);
    if (0 > ElapsedTime) then
      ElapsedTime = 0;
    end;
    CM_CastingBarTime:SetText(string.format("%.1f",ElapsedTime).." sec");
  </OnUpdate>
            
  
end
--]]

--[[ add a timer to this
function CCLOOP()
  while (IsShiftKeyDown()) do
    CastSpellByName("Charged Chop")
  end
end
--]]

--[[

/script if(IsPetSummoned(x) == false) then SummonPet(x) else ReturnPet(x) end

/script for i=1,180 do a,b,name,count = GetBagItemInfo(i) if (name== "x") then PickupBagItem(GetBagItemInfo(i)); break; end end;
/script ClickPetFeedItem();
/script for r=1,99 do FeedPet(y); end;

x = name of item you want to feed
y = slot number of pet you want to feed



/run Msg(GetPetItemAbility(1, "HUNGER"))
--huger of pet in slot 1

/run Msg(GetCountInBagByName(TEXT("Sys204925_name")))
--nutritious cheese


/run Msg(GetPetItemAbility(1, "LOYAL"))
--loyalty of pet in slot 1

if GetCountInBagByName(TEXT("Sys204510_name")) > 0 then
--desert of happiness

]]

function CM_PetStatus(slot)
  DEFAULT_CHAT_FRAME:AddMessage("Loyalty: "..tostring(GetPetItemAbility(slot, "LOYAL")).." and Hunger: "..tostring(GetPetItemAbility(slot, "HUNGER")))
end

--[[
function CM_PetSummon(slot)
  local hunger  = GetPetItemAbility(slot, "HUNGER")
  local loyalty = GetPetItemAbility(slot, "LOYAL")
  
  local cheese  = GetCountInBagByName(TEXT("Sys204925_name"))
  local desert  = GetCountInBagByName(TEXT("Sys204510_name"))
  
  
  
  local cheeseSlot = 
  
  for i=1,180 do 
		a,b,name,count = GetBagItemInfo(i) 
		if (name == TEXT("Sys204925_name")) then 
			PickupBagItem(GetBagItemInfo(i))
			break
		end 
	end
	ClickPetFeedItem()
  
  TEXT("Sys204925_name")
  
  
  local desertSlot = 
  for i=1,180 do 
		a,b,name,count = GetBagItemInfo(i) 
		if (name == TEXT("Sys204510_name")) then 
			PickupBagItem(GetBagItemInfo(i)) 
			break
		end 
	end
  
	ClickPetFeedItem()
  TEXT("Sys204510_name")
  
  
  
  local cheeseNeeded = math.floor( (100 - hunger)/10 )
  local desertNeeded = (100 - loyalty)
 
  if loyalty < 100 then
    if 
  
  
  
  
  --ClearPetFeedItem()


end


--]]


--[[

function REP.func.takeItem(id)
	for i=1,180 do 
		a,b,name,count = GetBagItemInfo(i) 
		if (name== TEXT("Sys"..id.."_name")) then 
			PickupBagItem(GetBagItemInfo(i)); 
			break;
		end 
	end;
	ClickPetFeedItem();
end

]]


function HaveAShield()
  local doI = false
  local thisisastring = GetEquipSlotInfo(17)
  
  if not(thisisastring == nil) then --have
    DEFAULT_CHAT_FRAME:AddMessage(GetEquipSlotInfo(17))
    doI = true
  else --dont have
    DEFAULT_CHAT_FRAME:AddMessage("no shield")
    doI = false
  end

end

--SMPA_PublicEventFrame:Show();
--[[
--Counts down till fearless comes off cooldown.
function SMPAFearlessTimer(passedTime)
   if (SMPAInSiege() == true and ALLOW == true) then
      local newTime = passedTime - 1;
      if (passedTime == 180) then
         SMPAColorAttentionPlease("SMPA:  Fearless was used.", 0.1, 0.94, 0.94)
         SMPA_FrameFearlessNumber:SetColor(0.9, 0.1, 0.1);
         SMPA_FullFrameFearlessNumber:SetColor(0.9, 0.1, 0.1);
      elseif (passedTime == 60) then
         SMPAColorAttentionPlease("SMPA:  Fearless up in 1 minute.", 0.1, 0.94, 0.94)
         FEARLESS_ON = false;
         SMPA_FrameFearlessNumber:SetColor(0.7, 0.3, 0.1);
         SMPA_FullFrameFearlessNumber:SetColor(0.7, 0.3, 0.1);
      elseif (passedTime == 30) then
         SMPAColorAttentionPlease("SMPA:  Fearless up in 30 seconds.", 0.1, 0.94, 0.94)
         SMPA_FrameFearlessNumber:SetColor(0.5, 0.5, 0.1);
         SMPA_FullFrameFearlessNumber:SetColor(0.5, 0.5, 0.1);
      elseif (passedTime == 15) then
         SMPAColorAttentionPlease("SMPA:  Fearless up in 15 seconds.", 0.1, 0.94, 0.94)
         SMPA_FrameFearlessNumber:SetColor(0.3, 0.7, 0.1);
         SMPA_FullFrameFearlessNumber:SetColor(0.3, 0.7, 0.1);
      elseif (passedTime == 1) then
         SMPAColorAttentionPlease("SMPA:  Fearless is up!", 0.1, 0.94, 0.94)
         SMPA_FrameFearlessNumber:SetColor(0.1, 0.9, 0.1);
         SMPA_FullFrameFearlessNumber:SetColor(0.1, 0.9, 0.1);
      end
      
      if (passedTime == 0) then
         --We must be done counting down now.
         SMPA_FrameFearlessNumber:SetText("Ready");
         SMPA_FullFrameFearlessNumber:SetText("Ready");
         if (SMPAVars.sound == true) then
            PlaySoundByPath("Interface\\Addons\\smpa\\Sound\\Fearless.wav");
         end
      else
         local convertedTime = SMPAConvertToMinutes(newTime);
         SMPA_FrameFearlessNumber:SetText(convertedTime);
         SMPA_FullFrameFearlessNumber:SetText(convertedTime);
         WaitTimer.Wait(1, SMPAFearlessTimer, tmrFearlessCooldown, newTime);
      end
   end
end
--]]

--[[
function pbInfo.TargetFrame.Scripts.OnLoad()
	if (pbInfoSettings["HEALTHBARCOLORFADE"] == false or pbInfoSettings["ENABLE"] == false) then
		TargetHealthBar:SetBarColor(1.0, 0.0, 0.0)
	end
  
	if ((pbInfoSettings["HEALTHBARCOLORFADE"] == false and pbInfoSettings["MODIFYHEALTHBAR"] == false) or pbInfoSettings["ENABLE"] == false) then
		pbInfoTargetFrameTimer:Hide()
	else
		pbInfoTargetFrameTimer:Show()
	end
  
end
--]]

---[[


-- name, hp pairs
--[[
local MobTable = {}
local oldChangeHP = 0
local newChangeHP = 0

function MonsterHealthOnUpdate()

  local name = UnitName("target")
  
	if ( UnitExists("target") and (UnitLevel("target") > 0) and (not UnitIsPlayer("target")) ) then 
  --and (UnitSex("target") >= 2)
  --and (UnitHealth > 0)
    
    if ( (UnitHealth("target") == 100 ) ) then
      MobTable[name] = UnitChangeHealth("target")
    elseif (not (MobTable[name] == nil) ) then
      
      newChangeHP = UnitChangeHealth("target")
      
      if ( oldChangeHP ~= newChangeHP ) then --otherwise it takes off the same amount of hp every frame update
        MobTable[name] = MobTable[name] + newChangeHP
      end
      
      oldChangeHP = newChangeHP
      
    else
      MobTable[name] = 0
    end
    
    local tempHP = ""..MobTable[name]
    local healthRatio = UnitHealth("target")
    
    if (MobTable[name] > 0) then 
      while true do --number formatting
        tempHP, k = string.gsub(tempHP, "^(-?%d+)(%d%d%d)", '%1' .. "," .. '%2');
        if (k == 0) then
          break
        end
      end
      tempHP = tempHP .. " (" .. healthRatio .. "%)"
    else
      tempHP = "".. healthRatio .. "%"
    end
    
    TargetHealthBarValueText:SetText(tempHP)
  end
end
--]]

--[[ --scrap from pbInfo
    if ( type(healthMax) == "number" and healthMax > 0 ) then
			local text = CM_AddThousandsSeparator(math.ceil((healthRatio * healthMax) / 100)) .. "/" .. CM_AddThousandsSeparator(healthMax)

		end
    
		--local mL, sL = UnitLevel("target")
		--local mC, sC = UnitClass("target")
		local healthMax = UnitChangeHealth("target")
    
    
		if (type(CompactMacros.MobDB.Mobs[name]) ~= "table") then
			CompactMacros.MobDB.Mobs[name] = {}
		end
    
		if (type(CompactMacros.MobDB.Mobs[name][mL]) ~= "table") then
			CompactMacros.MobDB.Mobs[name][mL] = {}
		end
    
		if (type(CompactMacros.MobDB.Mobs[name][mL][mC]) ~= "table") then
			CompactMacros.MobDB.Mobs[name][mL][mC] = {}
		end
   
    
		if (UnitHealth("target") == 100 and (MobTable[name] or 0) < healthMax) then
			CompactMacros.MobDB.Mobs[name][mL]["healthpoints"] = healthMax -- backward compatibility for other addons
			CompactMacros.MobDB.Mobs[name][mL][mC]["healthpoints"] = healthMax
		end
    
		local healthMax = CompactMacros.MobDB.Mobs[UnitName("target")][UnitLevel("target")][UnitClass("target")]["healthpoints"] or 0
    
		
    
		if ( type(healthMax) == "number" and healthMax > 0 ) then
			local text = CM_AddThousandsSeparator(math.ceil((healthRatio * healthMax) / 100)) .. "/" .. CM_AddThousandsSeparator(healthMax)
      text = text .. " (" .. healthRatio .. "%)"
			TargetHealthBarValueText:SetText(text)
		end
	else
		TargetHealthBar:SetBarColor(1.0, 0.0, 0.0)
	end
end
 --]]


 
function CM_PetActionButton_OnLoad(this)
	this:RegisterEvent("UPDATE_BINDINGS")
	this:RegisterEvent("PET_ACTIONBAR_UPDATE_COOLDOWN")

	this:RegisterForClicks("LeftButton", "RightButton")
end

function CM_PetActionButton_OnEvent(this, event)
	if ( event == "UPDATE_BINDINGS" ) then
		CM_PetActionButton_UpdateHotkeys(this)
	elseif ( event == "PET_ACTIONBAR_UPDATE_COOLDOWN" ) then
		CM_PetActionButton_UpdateCooldown(this)
	end
end

function CM_PetActionButton_UpdateHotkeys(this)
	local hotkey = getglobal(this:GetName().."Hotkey")
	local key = GetBindingKey("PETACTIONBARBUTTON"..this:GetID())
	if ( key ) then
		hotkey:SetText(key)
	else
		hotkey:SetText("")
	end
end

--[[
function CM_PetActionBarFrame_OnLoad(this)

	this:RegisterEvent("PET_ACTIONBAR_SHOW")
	this:RegisterEvent("PET_ACTIONBAR_HIDE")
	this:RegisterEvent("PET_ACTIONBAR_UPDATE")

	if ( UnitExists("pet") ) then
		ShowUIPanel(this)
    PetActionBarFrame:Hide()
	end
end
--]]

function CM_PetActionBarFrame_OnShow(this)
	CM_PetActionBarFrame_Update()
end

function CM_PetActionBarFrame_OnEvent(this, event)
	if ( event == "PET_ACTIONBAR_SHOW" ) then
		ShowUIPanel(this)
    PetActionBarFrame:Hide()
	elseif ( event == "PET_ACTIONBAR_HIDE" ) then
		HideUIPanel(this)
	elseif ( event == "PET_ACTIONBAR_UPDATE" ) then
		if ( CM_PetActionBarFrame:IsVisible() ) then
			CM_PetActionBarFrame_Update()
		end
	end
end

function CM_PetActionBarFrame_Update()
	local button, icon, auto
	for i = 1, 6 do
		icon, auto = GetPetActionInfo(i);
		button = getglobal("CM_PetActionBarButton"..i)

		if ( auto ) then
			getglobal(button:GetName().."Continued"):Show()
		else
			getglobal(button:GetName().."Continued"):Hide()
		end

		getglobal(button:GetName().."Icon"):SetTexture(icon)
		CM_PetActionButton_UpdateHotkeys(button)
		CM_PetActionButton_UpdateCooldown(button)
	end
end

function CM_PetActionButton_UpdateCooldown(this)	
	local duration, remaining = GetPetActionCooldown(this:GetID())
	CooldownFrame_SetTime(getglobal(this:GetName().."Cooldown"), duration, remaining)
end

function CM_FocusCastingBar_OnEvent(this, event)
	if ( event == "UNIT_CASTINGTIME" ) then
		if ( arg1 == "focus1" ) then
			local name, maxValue, currValue = UnitCastingTime("focus1")
      if ( CM_FocusCastingBar:IsVisible() == false ) then
        CM_FocusCastingBar:Show()
      end
			if ( name and maxValue > 0 ) then
				CM_FocusCastingBarName:SetText(name)
				this.fadeOut = 1
				this.maxValue = maxValue
				this:SetBarColor(0.0, 1.0, 0.0)
				this:SetMinValue(0)
				this:SetMaxValue(maxValue)
				this:SetValue(currValue)
				this:SetAlpha(1)
				this:Show()
			else
				this.maxValue = nil
			end
		end
	end
end

function CM_FocusCastingBar_OnUpdate(this, elapsedTime)
	if ( this.maxValue ) then
		local currTime = this:GetValue() + elapsedTime
		if ( currTime > this.maxValue ) then
			currTime = this.maxValue
		end
		this:SetValue(currTime)

    ---[[
		local sparkPosition = currTime / this.maxValue * 228
		if ( sparkPosition < 0 ) then
			sparkPosition = 0
		end
    CM_FocusCastingBarSpark:ClearAllAnchors()
    CM_FocusCastingBarSpark:SetAnchor("CENTER", "LEFT", CM_FocusCastingBarSpark, sparkPosition, 0)
		--TargetCastingBarSpark:ClearAllAnchors()
		--TargetCastingBarSpark:SetAnchor("CENTER", "LEFT", TargetCastingBarSpark, sparkPosition, 0)
    -- ThisFrame : SetAnchor("ThisFrame anchor point", "anchor point on OtherFramee", "OtherFramee name", x change, y change)
    --]]
	elseif ( this.fadeOut ) then
		local alpha = this:GetAlpha() - elapsedTime
		if ( alpha > 0 ) then
			this:SetAlpha(alpha)
		else
    	CM_FocusCastingBar.maxValue = nil
      CM_FocusCastingBar.fadeOut = nil
      CM_FocusCastingBar:Hide()
			--CloseTargetCastingBar()
		end
	end
end

--[[
function TargetCastingBar_OnEvent(this, event)
	if ( event == "UNIT_CASTINGTIME" ) then
		if ( arg1 == "target" ) then
			local name, maxValue, currValue = UnitCastingTime("target");
			if ( name and maxValue > 0 ) then
				TargetCastingBarText:SetText(name);
				this.fadeOut = 1;
				this.maxValue = maxValue;
				this:SetBarColor(0.0, 1.0, 0.0);
				this:SetMinValue(0);
				this:SetMaxValue(maxValue);
				this:SetValue(currValue);
				this:SetAlpha(1);
				this:Show();
			else
				this.maxValue = nil;
			end
		end
	end
end
--]]
 
 

--[[
MoveMouseTo(d, e)
PressMouseButton(1)
MoveMouseTo(f, g)
ReleaseMouseButton(1)

            MoveMouseTo(x1,y1)
            Sleep(100)
            PressMouseButton(1)
            Sleep(100)
            MoveMouseTo(x2,y2)
            Sleep(100)
            ReleaseMouseButton(1)
            Sleep(delay)    
            
            Syntax
Description: Returns the cursor's position on the screen
input.GetCursorPos()
Returns: number, number

Additional Notes
Coordinates are relative to the top-left corner of the window
See Also
input.SetMousePos
gui.MousePos (identical)
gui.SetMousePos
            setCursorPos({x=400,y=450})
            --]]
            
--[[ --not working
--CastASpellAtAPlace("spell name", x, y)
function MoveMouseForAOE()

  --get works, set doesnt
  local x, y = GetCursorPos(); 
  DEFAULT_CHAT_FRAME:AddMessage("x: "..x.." and y: "..y)
  --you would want to look at movemouseto and movemousetovariable pages. 
  local temp = SetCursorPos(1000, 500)
  x, y = GetCursorPos(); 
  DEFAULT_CHAT_FRAME:AddMessage("x: "..x.." and y: "..y)
  --local CurPos = getCursorPos()
  --DEFAULT_CHAT_FRAME:AddMessage("x, y: "..CurPos)
  -- setCursorPos({x=400,y=450})
  
  --get screen size and divide by 2 for center?
  --get center directly?
  --mouse.coords({x=100, y=100})
  --MoveMouseTo(100, 100)
  --SetCursorPos(100, 100)
  --CastSpellByName("Thunderstorm")
end
--]]

function DeterminePhirius()

  local health = UnitHealth("player") / UnitMaxHealth("player")
  
  -- mana = first combat resource
  -- skill = second combat resource
  local skill1 = UnitMana("player") / UnitMaxMana("player") 
  local skill2 = UnitSkill("player") / UnitMaxSkill("player") 
  -- skill2 = -1.#IND "indeterminate" if you do not have a second resource
  -- set to 100% for calculations
  if ( not (skill2 == skill2) ) then
    skill2 = 1
  end
  
  local skill1Type = UnitManaType("player")
  local skill2Type = UnitSkillType("player") --unused variable
  --[[ types:
  1 = mana (or none, if both classes use the same resource, or with no secondary class)
  2 = rage
  3 = focus
  4 = energy
  --]]
  
  local mana = 1
  if (skill1Type == 1) then
    mana = skill1
  else -- either skill2Type == 1 or there is no Type == 1
    mana = skill2
  end
  
  --[[
  --potion priority
  if health < 0.5 then
    if mana < 0.5 then
      swE > hpE > swD > hpD > swC > hpC > swB > hpB > swA > hpA
    else
      hpE > swE > hpD > swD > hpC > swC > hpB > swB > hpA > swA
    end
  elseif health < 0.6 then
    if mana < 0.6 then
      swD > hpD > swE > hpE > swC > hpC > swB > hpB > swA > hpA
    else
      hpD > swD > hpE > swE > hpC > swC > hpB > swB > hpA > swA
    end
  elseif health < 0.7 then
    if mana < 0.7 then
      swC > hpC > swD > hpD > swE > hpE > swB > hpB > swA > hpA
    else
      hpC > swC > hpD > swD > hpE > swE > hpB > swB > hpA > swA
    end
  elseif health < 0.8 then
    if mana < 0.8 then
      swB > hpB > swC > hpC > swD > hpD > swE > hpE > swA > hpA
    else
      hpB > swB > hpC > swC > hpD > swD > hpE > swE > hpA > swA
    end
  else
    if mana < 0.9 then
      swA > hpA > swB > hpB > swC > hpC > swD > hpD > swE > hpE
    else
      hpA > swA > hpB > swB > hpC > swC > hpD > swD > hpE > swE
    end
  end
  --]]
    
    
    
    
    
    --[[
  --potion construction
  local potion = "Phirius "
  
  if (health <= 0.4) and (sw60 > 0) or (hp60 > 0) then
    if(
  
  
  if (health <= 0.4) then
    if (mana <= 0.4) then
      if (sw60 > 0) then
        potion = potion.."Special Water - Type E"
      else
        potion = potion.."Potion - Type E"
      end
    end
  elseif (health <= 0.5) then  
    if (mana <= 0.5) then
      if (sw60 > 0) then
        potion = potion.."Special Water - Type D"
      else
        potion = potion.."Potion - Type D"
      end
    end
  elseif (health <= 0.6) then  
    if (mana <= 0.6) then
      if (sw60 > 0) then
        potion = potion.."Special Water - Type C"
      else
        potion = potion.."Potion - Type C"
      end
    end
  elseif (health <= 0.7) then  
    if (mana <= 0.7) then
      if (sw60 > 0) then
        potion = potion.."Special Water - Type B"
      else
        potion = potion.."Potion - Type B"
      end
    end
  elseif (health <= 0.8) then  
    if (mana <= 0.8) then
      if (sw60 > 0) then
        potion = potion.."Special Water - Type A"
      else
        potion = potion.."Potion - Type A"
      end
    end
  end
    
  letter
  if sw60 > 0 then "E" elseif sw50 > 0 then "D" ...
  
  if (health <= 0.4) and (mana <= 0.4) then
    "Special Water - Type "..sw60
  elseif (health <= 0.5) and (mana <= 0.5) then
    
  elseif (health <= 0.6) and (mana <= 0.6) then
  elseif (health <= 0.7) and (mana <= 0.7) then
  elseif (health <= 0.8) and (mana <= 0.8) then
  elseif (health <= 0.5) and (mana <= 0.5) then
    UseItemByName("Phirius Special Water - Type E")
    --elseif ... a ton of options
  end
  
  UseItemByName(potion)
  --]]
end

--[[
function UsePhirius(priority, one, two, three, four, five)
  local firstPart = "Phirius "
  local secondPart = potion or special water
  local thirdPart = A, B, C, D, or E

  --special water (both)
  local swA = GetBagItemCount(203489)
  local swB = GetBagItemCount(203490)
  local swC = GetBagItemCount(203491)
  local swD = GetBagItemCount(203492)
  local swE = GetBagItemCount(203493)
  local sw = {"a" = swA, "b" = swB, "c" = swC, "d" = swD, "e" = swE}
  
  --potion (health)
  local hpA = GetBagItemCount(203494)
  local hpB = GetBagItemCount(203495)
  local hpC = GetBagItemCount(203496)
  local hpD = GetBagItemCount(203497)
  local hpE = GetBagItemCount(203498)
  local hp = {"a" = hpA, "b" = hpB, "c" = hpC, "d" = cpD, "e" = hpE}
  
  for i = 1,10 do
  
  
  end
  
  
 elixir (mana)
  --since they share a cd, there is no reason to use a top up health in a serious fight
  local mpA = GetBagItemCount(203499)
  local mpB = GetBagItemCount(203500)
  local mpC = GetBagItemCount(203501)
  local mpD = GetBagItemCount(203502)
  local mpE = GetBagItemCount(203503)
  


end
--]]


function CM_TileSkill(skill)
  --[[
  singe sw title swap - casts the skill based on current title, switches to STH
Multi purpose sw title swap function
Pass an argument none/ft/sa/etc
Auto selects title ID and name of skill to cast

  530427 - escape artist
  530723 - lucky holder
  530724 - storytelling troupe helper
  530725 - nautilus shell leader
  530752 - story ceremony writer

  530459 - Mad Rush+30 --there are two versions?
  530467 - Fire Training
  530520 - Soldiers, Charge!
  530538 - Soldiers, Attack!
  530574 - Midnight Ritual
  530556 - Enchanted Stone Protection
  530584 - Tactical Smash+19
  530592 - Ironblood Will
  --]]



end





-- stored locally, cleared on log out/crash
local playersOnFile = {}

-- record the target's info. for an npc is will record their max health in percent
-- only name matters. if used on the same target again, the old info is overwritten
--should I trigger this on a damage event in SW?
function RecordPlayer()
  local name = UnitName("target")
  local mL, sL = UnitLevel("target")
  local hp = UnitMaxHealth("target")
  local mC, sC = UnitClass("target")
  local info = " is a "..mL.." "..mC.." / "..sL.." "..sC.." and has "..hp.." max health."
  DEFAULT_CHAT_FRAME:AddMessage("Added: "..name..info)
  playersOnFile[name] = info
end

-- print the table to chat/chat frame later one for reference (mainly during sw)
-- if channel is nil, then print to chatframe by default?
function ListPlayers(channel)
  DEFAULT_CHAT_FRAME:AddMessage("--- Players in list:")
  if(channel == "chatframe") then 
    for name,info in pairs(playersOnFile) do
      DEFAULT_CHAT_FRAME:AddMessage(name..info)
    end
  else 
    for name,info in pairs(playersOnFile) do
      SendChatMessage(name..info, channel)
    end
  end
  SendChatMessage("--- End list.", channel)
end

--removes all player info stored in the player list
function ClearPlayers()
  playersOnFile = {}
  DEFAULT_CHAT_FRAME:AddMessage("Player list cleared.")
end

--hides minimap and portrait buttons I dont want to see
function HideButtons()
  MinimapFrameTopupButton:Hide() --"top up" (buy) diamonds
  MinimapFrameRestoreUIButton:Hide() -- restores to default UI settings
  MinimapFrameStoreButton:Hide() -- item shop
  MinimapFrameQuestTrackButton:Hide() -- the area that lists your current quests
  MinimapBeautyStudioButton:Hide() -- style shop
  MinimapFrameBulletinButton:Hide() -- announcements
  MinimapNpcTrackButton:Hide() -- world search
  MinimapFrameOptionButton:Hide() -- additional world map / minimap settings
  --MinimapFrameBugGartherButton:Hide() -- UI errors, hidden by default
  PlayerFrameWorldBattleGroundButton:Hide() -- world battleground
  --PlayerFrame(name of pet/card compendium?):Hide() -- monster compendium

  --things I want to have showing
  --[[
  MinimapFramePlayerPosition:Hide() -- your current coordinates
  MinimapFramePlusButton:Hide() -- zoom in
  MinimapFrameMinusButton:Hide() -- zoom out 
  MinimapFrameBattleGroundButton:Hide() -- battlefield/arena queues
  PlayerFramePetButton:Hide() -- pet
  PlayerFramePartyBoardButton:Hide() -- party recruitment board
  --]]
end

--shows the minimap buttons I have hidden by default
function ShowButtons()
  MinimapFrameTopupButton:Show() --"top up" (buy) diamonds
  MinimapFrameRestoreUIButton:Show() -- restores to default UI settings
  MinimapFrameStoreButton:Show() -- item shop
  MinimapFrameQuestTrackButton:Show() -- the area that lists your current quests
  MinimapBeautyStudioButton:Show() -- style shop
  MinimapFrameBulletinButton:Show() -- announcements
  MinimapNpcTrackButton:Show() -- world search
  MinimapFrameOptionButton:Show() -- additional world map / minimap settings
  MinimapFrameBugGartherButton:Show() -- UI errors, hidden by default
  PlayerFrameWorldBattleGroundButton:Show() -- world battleground
end

function PlayerBuffFrameResize()
	local maxBuffSize = 40 -- MissingBuffs addon brings support up to 40 (from 30)
  local maxDebuffSize = 30 --game default is 30
  local buffLineItems = 20 --number of buffs to display in one row
	local itemButton = getglobal("PlayerBuffButton1")
  
  --ThisFrame : SetAnchor("ThisFrame anchor point", "anchor point on OtherFramee", "OtherFramee name", x change, y change)
  
  PlayerBuffButton1:ClearAllAnchors()
  PlayerBuffButton1:SetAnchor("BOTTOMLEFT", "TOPLEFT", "MainActionBarFrame", 0, -95)
  
	for i = 2, maxBuffSize do
		itemButton = getglobal("PlayerBuffButton"..i)
		itemButton:ClearAllAnchors()

		if ( i <= buffLineItems ) then
			itemButton:SetAnchor("TOPLEFT", "TOPRIGHT", "PlayerBuffButton"..(i-1), 4, 0)
		else
			itemButton:SetAnchor("BOTTOMLEFT", "TOPLEFT", "PlayerBuffButton"..(i - buffLineItems), 0, -13)
		end
	end

  PlayerDebuffButton1:ClearAllAnchors()
  PlayerDebuffButton1:SetAnchor("BOTTOMLEFT", "TOPLEFT", "PlayerBuffButton21", 0, -12)
  
	for i = 2, maxDebuffSize do
		itemButton = getglobal("PlayerDebuffButton"..i)
		itemButton:ClearAllAnchors()

		if ( i <= buffLineItems ) then
			itemButton:SetAnchor("TOPLEFT", "TOPRIGHT", "PlayerDebuffButton"..(i-1), 4, 0)
		else
			itemButton:SetAnchor("BOTTOMLEFT", "TOPLEFT", "PlayerDebuffButton"..(i - buffLineItems), 0, -13)
		end
	end
	
end
