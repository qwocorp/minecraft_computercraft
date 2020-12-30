-- vars below
--the totalmoves is to limit te maximum steps of the turtles, so they don't fly away
local totalmoves = 2000
local hardFloor = 2
local hardCeiling = 125

function errorFunction(Str)
    print(Str)
    error()
end

function fuelcheck()
    if turtle.getFuelLevel() == 0 then
        local oldslot = turtle.getSelectedSlot()
        fuelOn16()
        turtle.select(16)
        if turtle.getItemCount(16) == 0 then
            print("Cannot refuel as there is no more fuel in slot 16")
            error()
        end
        print("inserting fuel")
        turtle.refuel(1)
        turtle.select(oldslot)
    end
end

function fuelOn16()
    local countOn16 = turtle.getItemSpace(16)
    if countOn16 == 64 then
        --it's empty
        local sourceslot = findCoalSlot()
            if sourceslot == 16 then
                errorFunction("no extra coal found")
            end
            turtle.select(sourceslot)
            turtle.transferTo(16)
    elseif countOn16 ~= 0 then
        if turtle.getItemDetail(16).name ~= "minecraft:coal" then
            --We found items on slot 16, but they are not coal. So we need to remove the stuff from slot 16 to fill it with coal
            print("slot 16 has other items than Coal, we need to dump this somewhere else in the inventory")
            local targetslot = findEmptySlot()
            if targetslot == 0 then
                errorFunction("cannot move non coal item as there is no space ending program")
            end

            --select slot 16 and transfer this to the empty slot
            turtle.select(16)
            turtle.transferTo(targetslot)

            --now we need to get the coal to 16
            local sourceslot = findCoalSlot()
            if sourceslot == 16 then
                errorFunction("no extra coal found")
            end
            turtle.select(sourceslot)
            turtle.transferTo(16)
        end
    end

end

function findEmptySlot()
    local slots = 0
    for slot = 1,16 do
        if turtle.getItemCount(slot) == 0 then
            slots = slot
        end
    end
    return slots
end

function findCoalSlot()
    local slots = 16
    for slot = 1,16 do
        local slotreversed = 17 - slot
        if turtle.getItemCount(slotreversed) ~= 0 then
            --nested if, nice
            if turtle.getItemDetail(slotreversed).name == "minecraft:coal" then
                --yes this slot is not empty and has coal... jeez
                slots = slotreversed
            end
        end
    end
    return slots
end

function move(Str,moves)
    while moves > 0 do
        fuelcheck()
        totalmoves = totalmoves - 1
        if moves % 10 == 0 then
            print("moves left")
            print(totalmoves)
        end
        if totalmoves == 0 then
                errorFunction("Ran out of moves")
        end
        if Str == "forward" then
        --first there is nothing in front, YES we get to move
            if turtle.inspect() == false then
                turtle.forward()
            -- elseif here to prevent hitting things we don't want like chests, but need to write that code, this turtle will kill all atm
            else 
                turtle.dig()
                turtle.forward()
            end
        elseif Str == "up" then
            --first there is nothing above us, YES we get to move
            if turtle.inspectUp() == false then
                turtle.up()
            -- elseif here to prevent hitting things we don't want like chests, but need to write that code, this turtle will kill all atm
            else
                turtle.digUp()
                turtle.up()
            end
        elseif Str == "down"  then
            --first there is nothing above us, YES we get to move
            if turtle.inspectDown() == false then
            turtle.down()
        -- elseif here to prevent hitting things we don't want like chests, but need to write that code, this turtle will kill all atm
            else
            turtle.digDown()
            turtle.down()
        end

        else 
            errorFunction("I got a move command I do not undestand")
        end
    moves = moves - 1
    end
end

function rechtsaf()
    turtle.turnRight()
    move("forward",1)
    turtle.turnRight()

end

function linksaf()
    turtle.turnLeft()
    move("forward",1)
    turtle.turnLeft()

end


print("--------------")
print("MiningBot Alpha, I suck")
print("--------------")

local turn = 0

--for num=1,3 do
--    for iter=1,16 do
--        move("forward", 16)
--        if turn % 2 == 0 then
--            rechtsaf()
--        else
--            linksaf()
--        end
--    end
--    turn = turn + 1
--end


for iter = 1,4 do
    print("starting layer", iter)
    for num=1,16 do
        print("track",num)
        move("forward",15)
        if num == 16 then
            turtle.turnLeft()
            turtle.turnLeft()
        elseif turn % 2 == 0 then
            rechtsaf()
        else
            linksaf()
        end
        turn = turn + 1
    end
    move("down",1)
    turn = turn + 1
end