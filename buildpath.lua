local bDebug = false
local selectedSlot=1
local abort = false

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
	local result = true
	if turtle.getFuelLevel() < 10 then
		local slot = getSelectedSlot()
		setSelectedSlot(1)
		if not turtle.refuel(1) then
			print("Refuelling failed.")
			result = false
		end
		setSelectedSlot(slot)
	end
	return result
end

function placeSlab()
	
end

-------------------------------------------------------------------------------
-- MAIN PROGRAM START
-------------------------------------------------------------------------------
-- Arguments
local tArgs = {...}
if #tArgs ~= 1 or tonumber(tArgs[1]) == nil or math.floor(tonumber(tArgs[1])) ~= tonumber(tArgs[1]) or tonumber(tArgs[1]) < 1 then
	print("Usage: buildPath <length>")
	return
end

local length = tonumber(tArgs[1])

local blocksPlaced = 0
setSelectedSlot(2)
turtle.back()
turtle.down()
while (blocksPlaced < length) and (abort == false) do

	-- is there a block in front of us?
	if turtle.detect() then
		abort = true
	else
		-- try to place a block
		if turtle.place() then
			blocksPlaced = blocksPlaced + 1
		else
			local slot = getSelectedSlot()
			-- try to find another suitable slot
			for i=slot,16,1 do
				setSelectedSlot(i)
				if turtle.place() then
					blocksPlaced = blocksPlaced + 1
					break
				end
				if i == 16 then
					abort = true
				end
			end
		end
	end
	
	if abort == false then
		-- move on to the next
		turtle.back()
		fuel()
	end
end

turtle.up()
turtle.forward()