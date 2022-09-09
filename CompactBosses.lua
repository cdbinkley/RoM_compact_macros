--- --- ---
-- Title: CompactMacros
-- Version: 0.9
-- Description: Descriptions of boss tactics and some functions to combat them.
-- Author: illagong
--- --- ---


--[[
--create menu in xml
input1: instance (defind by name, abbr, or level)
input2: boss (defind by number, name, nickname, trash, puzzle)
button: calls CM_Explain(input1, input2)


what type of text yellow in the middle of the screen?
function ExplainBoss(level, [bossnum])
	how to handle multiple same lv instances
if no argument if given, display help about the command
level = instance level
bossnum - use decimals for halls
	if only one argument is given, print a list of those bosses that have information
	if bossnum == 0 then display info about trash
  
  
--]]



--just "55" should return some debug info
--[[
lua function inputs?

function g (a, b, ...) end
Then, we have the following mapping from arguments to parameters:
CALL            PARAMETERS
g(3)             a=3, b=nil, arg={n=0}
g(3, 4)          a=3, b=4, arg={n=0}
g(3, 4, 5, 8)    a=3, b=4, arg={5, 8; n=2}
--]]
--[[
create menu in xml

/run Explain(“” or input, [channel]) {
	output= “party” or channel --defaults to party chat
if  “” or input=”menu” then
	display popup menu (with instance/boss name/boss number/puzzle name/puzzle number (number as between bosses. ex. lasers = sardo 2.5)/etc)
  
function CM_Explain(...)
  




end
--]]

-- Hall of Survivors hos
--55a, #6
function ExplainColours()
  SendChatMessage("In each corner of the room will be a large crystal, with four different colours.", "party")
  SendChatMessage("Four players will receive a colour debuff, one matching each crystal.", "party")
  SendChatMessage("You can mouse over the debuff, or the crystal, to read the colour.", "party")
  SendChatMessage("Before the time runs out, each player needs to click their matching crystal.", "party")
  SendChatMessage("If we don't get it, run back to the center of the room to try again.", "party")
end


--65 Grafu Castle gch

--box stacking

--feast
--Lavanger(sp?) will initially be immune to attacks. An initial round of zombies will spawn, which are highly resistant to damage and hit very hard. The tables around the room will each contain up to two food items. Clicking on one of these items will give you a 30 second buff and a special action bar to use the food. You can only have one food buff at a time. Meat is the first item to be placed, and will attract the zombies to it. Wine is used second, to splash on the zombies once they are gathered around the meat. Finally, a candle is used to ignite the wine-drenched zombies and destroy them. Soup is not critical to destroying the zombies, but should be used whenever possible and to keep the tables clear. A second round of zombies spawns 30 seconds after the fight begins, and the same process must be used to destroy them. This process continues for a total of eight rounds, after which the boss will attack. The boss has a cast-bar skill called Poison Throw. Poison will appear at the location each player was standing when the skill began to cast. Either move or use a magic immune skill or item to avoid heavy damage.


--annelia



-- 67 Sardo Castle sc
--lasers
--This hall consists of a total of six lasers, and five walls with a gap in each wall. If you stand in a laser, it will continuously deal a percentage of your health, and renew a 15 second debuff that prevents you from casting spells or using items. Please swap gear and remove health buffs so that heals are more effective on you. The gaps in the walls are safe from the lasers, but are initially guarded by a totem that will fear you, usually back into the lasers. The totems can be destroyed by using six bottles of water, which are found in an empty form on the wine racks in the previous room, and filled from buckets of water.

--boulder hall


-- 70 Tomb of the Seven Heros tosh
--jenny	
--letin
--the rest of tosh

--most of AC

--some of KBN







-- 95 Bone Peak

--95, #3
--[[ old versions
function ExplainSlogar()
  SendChatMessage("Rusty Iron Blade: Short-range aoe, back up. If you are hit, the boss will ignore any aggro you have generated.", "party")
  SendChatMessage("Steel Porcine Blow: Hits all players between the boss and the person with the second highest aggro.", "party")
  SendChatMessage("Rage Mode: Interrupt if possible. Tank will kite with speed boosts otherwise.", "party")
  SendChatMessage("Defensive Formation: A 10-stack shiled that makes Slogar immune to all damage. DPS will click on the clubs around the room to gain an Alt-skill.", "party")
  SendChatMessage("This skill can be used as long as Slogar is close to you, so the tank will kite the boss aroound the room. You can not move while holding a club.", "party")
  SendChatMessage("The lava in the middle will deal damage if you pass through it. If Slogar passes through it, he will gain a buff that makes him drop lava.", "party")
  SendChatMessage("Dropped lava pools will fear you if you pass over them.", "party")
end

function ExplainSlogar()
  SendChatMessage("Rusty Iron Blade: Short-range aoe, back up. Boss will ignore your aggro if hit.\nSteel Porcine Blow: Hits all players between the boss and the person with the second highest aggro.", "party")
  SendChatMessage("Rage Mode: Interrupt if possible. Tank will kite with speed boosts otherwise.", "party")
  SendChatMessage("Defensive Formation: A 10-stack shield that makes Slogar immune to all damage. DPS will click on the clubs around the room to gain an Alt-skill.", "party")
  SendChatMessage("This skill can be used as long as Slogar is close to you, so the tank will kite the boss aroound the room. You can not move while holding a club.", "party")
  SendChatMessage("The central lava deals damage if you walk through it. If Slogar passes through it, he will gain a buff that makes him drop lava pools. These will fear you if you step on them.", "party")
end
--]]

function ExplainSlogar()
  SendChatMessage("Rusty Iron Blade: Short-range aoe, back up. Boss will ignore your aggro if hit.\nSteel Porcine Blow: Hits all players between the boss and the person with the second highest aggro.\nRage Mode: Interrupt if possible. Tank will kite with speed boosts otherwise.\nDefensive Formation: A 10-stack shield that makes Slogar immune to all damage. DPS will click on the clubs around the room to gain an Alt-skill.", "party")
  SendChatMessage("This skill can be used as long as Slogar is close to you, so the tank will kite the boss aroound the room. You can not move while holding a club.\nThe central lava deals damage if you walk through it. If Slogar passes through it, he will gain a buff that makes him drop lava pools. These will fear you if you step on them.", "party")
end


--95, #4
--[[
can I trigger the using of the skill when I get the buff/debuff?
  if unitbuffchanged(name of soul debuff) then
    person = findplayertosave()
    castAltSkill(1 on person)
  end
  
if (I dont have a buff) then 
	find the person who does, and make sure they’re using the macro
else (when I have buff to save)
	same the player
--]]
  
--/run if FindDebuff("Devour Soul") then SaveEnsouledPlayer() end

function FindDebuff(debuff)
  for i = 1,10 do 
    local a = UnitDebuff("player",i) 
    if a == debuff then 
      SendChatMessage("I have"..debuff, "party")
      return true
    end
  end 
  
  return false
end
--[[
Source code
1
/run AltSkill = false for i=1,10 do 
local a = UnitDebuff("player",i) 
if a == "Devour Soul" then 
AltSkill = true 
end 
end 
if AltSkill then 
  for i=1,12 do 
    for j=1,40 do 
    local DName = UnitDebuff("raid"..i,j) 
    if (DName == "Broken Soul" or DName == "Torn Soul") 
    and (UnitDebuffLeftTime("raid"..i,j) <= 4) then 
    TargetUnit("raid"..i) 
    UseExtraAction(1) 
    end 
    end 
  end 
end


broken is shorder cd
--]]

-- need to add time check on who to save first
function SaveEnsouledPlayer()
  local player = ""
  for i = 1,12 do 
    player = "raid"..i
    for j = 1,40 do 
      local debuffName = UnitDebuff(player,j) 
      if debuffName == "Broken Soul" or debuffName == "Torn Soul" then 
        TargetUnit(player)
        SendChatMessage("Targeting "..player.." with "..debuff..".")
        UseExtraAction(1)
      end 
    end 
  end 
end

function FindDebuffedPlayer(debuff)
  local player = ""
  for i = 1,12 do 
    player = "raid"..i
    for j = 1,40 do 
      local debuffName = UnitDebuff(player,j)
      if debuffName == debuff then
        TargetUnit(player)
        SendChatMessage("Targeting "..player.." with "..debuff..".")
        UseExtraAction(1)
      end 
    end 
  end 
end

--[[

/run 

AltSkill = false 

for i=1,10 do 
  local a = UnitDebuff("player",i) 
  if a == "Devour Soul" then 
    AltSkill = true 
  end 
end 
if AltSkill then 
  for i=1,12 do 
    for j=1,40 do 
      local Dname = UnitDebuff("raid"..i,j) 
      if Dname == "Broken Soul" or Dname == "Torn Soul" then 
        TargetUnit("raid"..i) 
        UseExtraAction(1) 
      end 
    end 
  end 
end

function FindDebuff(debuff)
  for i = 1,10 do 
    local a = UnitDebuff("player",i) 
    if a == debuff then 
      SendChatMessage("I have"..debuff, "party")
      return true
    end
  end 
  
  return false
end

function FindEnsouledPlayer()
  local player = ""
  for i = 1,12 do 
    player = "raid"..i
    for j = 1,40 do 
      local debuffName = UnitDebuff(player,j) 
      if debuffName == "Broken Soul" or debuffName == "Torn Soul" then 
        TargetUnit(player)
        SendChatMessage("Targeting "..player.." with "..debuff..".")
        UseExtraAction(1)
      end 
    end 
  end 
end

function FindDebuffedPlayer(debuff)
  local player = ""
  for i = 1,12 do 
    player = "raid"..i
    for j = 1,40 do 
      local debuffName = UnitDebuff(player,j)
      if debuffName == debuff then
        TargetUnit(player)
        SendChatMessage("Targeting "..player.." with "..debuff..".")
        UseExtraAction(1)
      end 
    end 
  end 
end

--original:
/run AltSkill = false for i=1,10 do local a = UnitDebuff("player",i) if a == "Devour Soul" then AltSkill = true end end if AltSkill then for i=1,12 do for j=1,40 do local Dname = UnitDebuff("raid"..i,j) if Dname == "Broken Soul" or Dname == "Torn Soul" then TargetUnit("raid"..i) UseExtraAction(1) end end end end

--logic:
/run 
AK=false 
for i=1,9 do 
	local a=UD("player",i) 
	if a=="Devour Soul" then 
		AK=true
	end
end 
if AK then 
	for i=1,12 do 
		for i=1,40 do 
			local DN=UD("raid"..i,j)
			if DN=="Broken Soul" or DN=="Torn Soul" then 
				TU("raid"..i)
				UEA(1) 
			end 
		end 
	end 
end

--compact:
/run AK=false for i=1,9 do local a=UD("player",i) if a=="Devour Soul" then AK=true end end if AK then for i=1,12 do for i=1,40 do local DN=UD("raid"..i,j) if DN=="Broken Soul" or DN=="Torn Soul" then TU("raid"..i) UEA(1) end end end end

--]]
  
-- 98 Vale of Rites

-- CD("skill") defined in DIYCE
function CM_HopeStun()
  if UnitCastingTime("target") == "Purple Flame Blaze" then
    if CD("Savage Whirlwind") then
      CastSpellByName("Savage Whirlwind")
    elseif CD("Blasting Cyclone") then
      CastSpellByName("Blasting Cyclone")
    elseif CD("Terror") then
      CastSpellByName("Terror")
    elseif CD("Shout") then
      CastSpellByName("Shout")
    end
  end

--[[  
  /run function GSC(slot1, slot2) local a,b = GetSkillCooldown(slot1,slot2) return b == 0 end  
  if UnitCastingTime("target") == "Purple Flame Blaze" then 
    if GSC(3,5) then 
      CastSpellByName("Silence") 
    elseif GSC(2,7) then 
      CastSpellByName("Shock Strike") 
    elseif GSC(2,1) then 
      CastSpellByName("Electrocution") 
    elseif GSC(4,15) then 
      CastSpellByName("Vacuum Wave") 
    elseif GSC(3,2) then 
      CastSpellByName("Lightning") 
    end 
  end 
--]]

end



  
  












