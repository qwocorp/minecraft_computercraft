-- vars below
--the totalmoves is to limit te maximum steps of the turtles, so they don't fly away
local totalmoves = 10000
local hardFloor = 2
local hardCeiling = 125
local badblocks = {"minecraft:stone","rustic:slate","chisel:limestone2","minecraft:sand","minecraft:gravel","minecraft:cobblestone","chisel:marble2","chisel:basalt2","minecraft:dirt","minecraft:stained_hardened_clay"}

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
        lavaCheck(Str)
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
            while turtle.inspect() == true do
                turtle.dig()
            end
            if turtle.inspect() == false then
                turtle.forward()
            -- elseif here to prevent hitting things we don't want like chests, but need to write that code, this turtle will kill all atm
            else 
                print("something has gone wrong, there should not be a block in front of me")
                --turtle.dig()
                --turtle.forward()
            end
        elseif Str == "up" then
            --first there is nothing above us, YES we get to move
            while  turtle.inspectUp() == true do
                turtle.digUp()
            end
            if turtle.inspectUp() == false then
                turtle.up()
            -- elseif here to prevent hitting things we don't want like chests, but need to write that code, this turtle will kill all atm
            else
                print("something has gone wrong, there should not be a block above me")
                --turtle.digUp()
                --turtle.up()
            end
        elseif Str == "down"  then
            while turtle.inspectDown() == true do
                turtle.digDown()
            end
            if turtle.inspectDown() == false then
                turtle.down()
        -- elseif here to prevent hitting things we don't want like chests, but need to write that code, this turtle will kill all atm
            else
                print("something has gone wrong, there should not be a block below me")
                --turtle.digDown()
                --turtle.down()
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

function userInput(Str,modulo)
    print(Str)
    local nummer = io.read()
    nummer = tonumber(nummer)
    if nummer == nil then
        errorFunction("niet een geldig getal ingevoerd")
    elseif nummer % modulo ~= 0 then
        errorFunction("getal is niet deelbaar door", modulo)
    else
    return nummer
    end
end

function lavaCheck(Str)
    if Str == "down" then
        if turtle.inspectDown() == true then
            local success, blockBelow=turtle.inspectDown()
            print("onder me zit", blockBelow.name)
            if blockBelow.name == "minecraft:flowing_lava" then
                move("up",5)
                errorFunction("Lava detected, going up 5 and stopping")
            elseif blockBelow.name == "minecraft:bedrock" then
                errorFunction("We are above bedrock, we should stop digging down")
            end
        end
    elseif Str == "forward" then
        if turtle.inspect() == true then
            local success, blockInfront=turtle.inspect()
            print("voor me zit", blockInfront.name)
            if blockInfront.name == "minecraft:flowing_lava" then
                move("up",5)
                errorFunction("Lava detected, going up 5 and stopping")
            end
        end
    elseif Str == "up" then
        -- do nothing just going up hoping for no lava
    end
end

function restack()
    local start = 1
    local slots = 16
    local blockName = "nil"
    for slot=1,16 do
        if turtle.getItemCount(slot) ~= 0 then
            blockName = turtle.getItemDetail(slot).name
            for transferSlots = slot+1,16 do
                if turtle.getItemCount(transferSlots) ~= 0 then
                    if turtle.getItemDetail(transferSlots).name == blockName then
                        turtle.select(transferSlots)
                        turtle.transferTo(slot) --if this does not work, it will ignore the error (I hope)
                    end
                end
            end
        end
    end
end

function cleanup()
    print("inventory cleanup cycle")
    for cleanIter=1,16 do
        turtle.select(cleanIter)
        if turtle.getItemSpace(cleanIter) ~= 64 then
            local founditem = turtle.getItemDetail(cleanIter).name
            for i,v in ipairs(badblocks) do
                if v == founditem then
                    turtle.dropUp()
                end
            end
        end
    end
end


print("=======================================")
print("MiningBot Alpha")
print("=======================================")
print("This bot will dig down in a square")
print("---------------------------------------")

local turn = 0

local limit = userInput("Please indicate size (must be even)",2)
local depth = userInput("How many layers",1)

local limitMin1 = limit - 1
for iter = 1,depth do
    print("starting layer", iter)
    for num=1,limit do
        print("track",num)
        move("forward",limitMin1)
        if num == limit then
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

    -- doing some inventory manaagement
    restack()
    cleanup()


end