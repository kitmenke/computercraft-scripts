-- placeblocks.lua
-- Author: @kitmenke
--
-- Places all blocks in the turtle's inventory directly below itself until
-- the turtle's inventory is completely empty.
-- 
-- Used in the Sky Factory 2 mod pack along with an Autonomous Activator
-- to hammer the blocks which are placed by the turtle.
--
----------------------------
-- SETUP
----------------------------
--
-- Place the file in your computercraft programs directory:
-- ..\ATLauncher\Instances\SkyFactory\saves\YourSaveGame\computer\0\placeblocks.lua
--
-- Note: 
-- YourSaveGame is the name of your save game
-- "0" is the ID of your Turtle
----------------------------
-- VARIABLES
----------------------------
local tArgs = {...}
local selectedSlot=1
local version = "0.0.4"

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

function isItemsLeft()
  for i = 1,16 do
    if turtle.getItemCount(i) > 0 then
      return true
    end
  end
  return false
end

function placeAllBlocks()
  print("working on slot " .. selectedSlot)
  while turtle.getItemCount() > 0 do
    -- if we couldn't place a block down
    -- maybe block was already there
    -- sleep until we can
    while turtle.placeDown() == false do
      sleep(1)
    end
  end
end

-------------------------------------------------------------------------------
-- MAIN PROGRAM START
-------------------------------------------------------------------------------
print("placeblocks version " .. version .. " starting...")

local allEmpty = false
-- turtle has 16 slots to loop over
while isItemsLeft() do
  for i = 1,16 do
    setSelectedSlot(i)
    placeAllBlocks()
  end
end