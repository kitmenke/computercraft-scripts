-- buildrect <length> <width>
--
-- Builds a rectangle of the given length and width
-- 
----------------------------
-- USAGE
----------------------------
-- Fuel goes in the first slot (very top left in the Turtle's inventory)
-- First position the turtle directly ABOVE where the first block will go, facing OUTWARD
-- o o o
-- o o o
-- o o o
-- o o [] --> turtle faces this direction (outwards)
-- buildrect 3 4

local tArgs = {...}
local bDebug = false
local selectedSlot=1
local abort = false
local length = 0
local width = 0
local version = "1.0"

-------------------------------------------------------------------------------
-- ARGUMENTS
-------------------------------------------------------------------------------
if (#tArgs == 2) then
	length = tonumber(tArgs[1])
	width = tonumber(tArgs[2])
else
	print("Usage: buildrect <length> <width>")
	return
end

-------------------------------------------------------------------------------
-- FUNCTIONS
-------------------------------------------------------------------------------

function setSelectedSlot(slot)
	if turtle.select(slot) then
		selectedSlot = slot
	end
end

function getSelectedSlot()
	return selectedSlot
end

-- If fuel level is less than 10, refuel
function fuel()
	if turtle.getFuelLevel() < 10 then
		local slot = getSelectedSlot()
		setSelectedSlot(1)
		if turtle.refuel(1) then
			print("Refueled!")
		else
			print("Refuelling failed.")
			abort = true
		end
		setSelectedSlot(slot)
	end
end

function placeSlab()
	-- is there a block in front of us?
	if turtle.detect() then
		abort = true
	else
		-- try to place a block
		if not turtle.place() then
			local slot = getSelectedSlot()
			-- try to find another suitable slot
			for i=slot,16,1 do
				setSelectedSlot(i)
				if turtle.place() then
					break
				end
				if i == 16 then
					abort = true
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
-- MAIN PROGRAM START
-------------------------------------------------------------------------------

print("buildrect version " .. version .. " starting...")
-- fuel should be placed in slot 1
-- everything else in slots 2-16
setSelectedSlot(2)
-- turtle should be started above an empty space, the first block to place
turtle.down()
turtle.back()
placeSlab()

for w = 1, width, 1 do
	print("Width: " .. w .. " of " .. width)
	-- don't need to place start and end blocks
	for l = 1, length - 2, 1 do
		turtle.back()
		placeSlab()
		fuel()
		if abort == true then
			break
		end
	end
	if abort == true then
		break
	end
	-- place start and end blocks
	if (w%2) == 0 then
		turtle.turnLeft()
		turtle.back()
		placeSlab()
		turtle.turnLeft()
		if w ~= width then
			turtle.back()
			placeSlab()
		end
	else
		turtle.turnRight()
		turtle.back()
		placeSlab()
		turtle.turnRight()
		if w ~= width then
			turtle.back()
			placeSlab()
		end
	end
end

turtle.up()
print("Done!")