-- farmrect <length> <width>
--
-- Farm a rectangle of the given length and width
-- 
----------------------------
-- USAGE
----------------------------
-- TODO: positioning
--   o o o  w
--   o o o  i
--   o o o  d
--   o o o  t
--  length  h
-- buildrect 3 4
--

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
	print("Usage: farmrect <length> <width>")
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

function getItemsFromChest()
  local slot = 2
  print("Getting items from chest")
  setSelectedSlot(slot)
  while turtle.suckDown() and slot <= 16 do
    slot = slot + 1
    setSelectedSlot(slot)
  end
end

function putItemsInChest()
  if not turtle.detectDown() then
    print("Can't put items in chest! There isn't anything here!")
    return
  end
  print("Putting items in chest")
  for slot = 2, 16, 1 do
    setSelectedSlot(slot)
    turtle.dropDown()
  end
end

function plant()
	-- try to place a block
	if not turtle.placeDown() then
		local slot = getSelectedSlot()
		-- try to find another suitable slot
		for i=slot,16,1 do
			setSelectedSlot(i)
			if turtle.placeDown() then
				break
			end
			if i == 16 then
				abort = true
			end
		end
	end
end

function farm()
	if turtle.digDown() then
		plant()
		turtle.forward()
		fuel()
	end
end

function goBack()
  print("Going back...")
  if (width%2) == 0 then
    for l = 1, length, 1 do
      turtle.back()
    end
    turtle.turnRight()
  else
    for l = 1, length, 1 do
      turtle.forward()
    end
    turtle.turnLeft()
  end

  for w = 1, width, 1 do
    turtle.forward()
  end
  
  turtle.turnLeft()
end

-------------------------------------------------------------------------------
-- MAIN PROGRAM START
-------------------------------------------------------------------------------

print("farmrect version " .. version .. " starting...")
-- fuel should be placed in slot 1
-- everything else in slots 2-16
setSelectedSlot(2)
-- turtle should be started above a chest facing the first square of farmland
-- get everything out of the chest
getItemsFromChest()
fuel()
turtle.forward()
for w = 1, width, 1 do
	print("Width: " .. w .. " of " .. width)
	for l = 1, length - 1, 1 do
		farm()
		if abort == true then
			break
		end
	end
	if abort == true then
		break
	end
	-- place start and end blocks
	if (w%2) == 0 then
		turtle.turnRight()
		farm()
		turtle.turnRight()
	else
		turtle.turnLeft()
		farm()
		turtle.turnLeft()
	end
end

goBack()
putItemsInChest()
print("Done!")