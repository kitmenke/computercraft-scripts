-- ore
-- Author: @kitmenke
--
-- Used in SkyFactory to process ores. Probably not really useful for anything else.
-- 

local tArgs = {...}
local bDebug = false
local selectedSlot=1
local version = "1.1"
local oreCount = 0
local inventory = ""

-------------------------------------------------------------------------------
-- ARGUMENTS
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- FUNCTIONS
-------------------------------------------------------------------------------

function setSelectedSlot(slot)
	if turtle.select(slot) then
		selectedSlot = slot
	end
end

function craftOres()
	if oreCount > 0 then
		local piles = oreCount / 4
		print("Dividing into piles of " .. piles)
		-- spread the ores out
		turtle.transferTo(2,piles)
		turtle.transferTo(5,piles)
		turtle.transferTo(6,piles)
		turtle.craft()
	else
		print("No items to craft!")
	end
end

function getOres()
	local leftover = 0
	local previousItemCount = 0
	oreCount = 0
	for i = 1,16 do
		if inventory == "down" then
			turtle.suckDown(4)
		elseif inventory == "up" then
			turtle.suckUp(4)
		else
			turtle.suck(4)
		end
		
		if previousItemCount == turtle.getItemCount() then
			break
		end
		leftover = turtle.getItemCount() % 4
		if leftover ~= 0 then
			if inventory == "down" then
				turtle.dropDown(leftover)
			elseif inventory == "up" then
				turtle.dropUp(leftover)
			else
				turtle.drop(leftover)
			end
			break
		end
		oreCount = oreCount + 4
		previousItemCount = oreCount
	end
end

-------------------------------------------------------------------------------
-- MAIN PROGRAM START
-------------------------------------------------------------------------------

print("ore version " .. version .. " starting...")
setSelectedSlot(1)

-- down
print("Checking inventory below")
inventory = "down"
getOres()
craftOres()
turtle.drop()

-- up
print("Checking inventory above")
inventory = "up"
getOres()
craftOres()
turtle.drop()

print("Done!")