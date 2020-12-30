local totalmoves = 10000
local hardFloor = 2
local hardCeiling = 125
local badblocks = {"minecraft:stone","rustic:slate","chisel:limestone2","minecraft:sand","minecraft:gravel","minecraft:cobblestone","chisel:marble2","chisel:basalt2","minecraft:dirt","minecraft:stained_hardened_clay"}
local keep = {"minecraft:chest","minecraft:coal","minecraft:torch"}

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
            elseif blockBelow.name == "minecraft:lava" then
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

function dig(Str)
    if Str == "up" then
        while turtle.inspectUp() == true do
            turtle.digUp()
        end
    elseif Str == "forward" then
        while turtle.inspect() == true do
            turtle.dig()
        end
    elseif Str == "down" then
        while turtle.inspectDown() == true do
            turtle.digDown()
        end
    end
end

function tunnelSection(Wide,Heigth)
    if Heigth>3 then
        move("up",Heigth-3)
        dig("up")
        move("down",Heigth-3)
    else
        dig("up")
    end
    dig("down")

    for cycle = 1,Wide-1 do
    move("forward",1)
    if Heigth>3 then
        move("up",Heigth-3)
        dig("up")
        move("down",Heigth-3)
    end
    dig("up")
    dig("down")
    end
end

function findInventoryItem(Item)
    local slots = 16
    local found = 0
    for slot = 1,16 do
        if turtle.getItemCount(slot) ~= 0 then
            --nested if, nice
            if turtle.getItemDetail(slot).name == Item then
                --yes this slot has the stuff
                found = slot
            end
        end
    end
    return found
end

function placeItem(location,item)
    local slot = findInventoryItem(item)
    local result = false
    if slot ~= 0 then
        if location == "down" then
            if turtle.inspectDown() == false then
                --place item
                turtle.select(slot)
                result = turtle.placeDown()
            else
                print("cannot place ",item," as there is no free space below me")
            end
        elseif location == "up" then
            if turtle.inspectUp() == false then
                --place item
                turtle.select(slot)
                result = turtle.placeUp()
            else
                print("cannot place ",item," as there is no free space above me")
            end
        elseif location == "forward" then
            if turtle.inspect() == false then
                --place item
                turtle.select(slot)
                result = turtle.place()
            else
                print("cannot place ",item," as there is no free space infront me")
            end
        else
            print("invalid placement location")
        end
    else
        print("cannot place item, this is not in my inventory")
    end

    return result
end

function chestDump(location)
    local go = placeItem(location,"minecraft:chest")
        if go == true then
        for n=1,16 do
            if turtle.getItemSpace(n) ~= 64 then
                local founditem = turtle.getItemDetail(n).name
                local keepme = false
                for i,v in ipairs(keep) do
                    if v == founditem then
                        keepme = true
                    end
                end
                if keepme == false then
                    turtle.select(n)
                    print("dropping item", turtle.getItemDetail(n).name," in chest")
                    if location == "up" then
                        turtle.dropUp()
                    elseif location == "down" then
                        turtle.dropDown()
                    elseif location == "forward" then
                        turtle.drop()
                    end
                else
                    print("not dropping item ", turtle.getItemDetail(n).name," in chest")
                end
            end
        end
    end
end

function countEmpty()
    local totalEmpty = 0
    for n=1,16 do
        if turtle.getItemSpace(n) == 64 then
            totalEmpty = totalEmpty + 1
        end
    end
    print("Empty slots ",totalEmpty)
    return totalEmpty
end

function selectItem(Item)
    local foundslot = findInventoryItem(Item)
    if foundslot ~= 0 then
        turtle.select(foundslot)
    else
        errorFunction("Ran out of ",Item)
    end
end

function gravelRemoval(direction)
    local escape = 0
    sleep(1)
    while escape == 0 do
        print("gravel remove is running")
        print(escape)
        
        if direction == "up" then
            if turtle.detectUp() == true then
                dig("up")
            else
                escape = 1
                return 
            end
        elseif direction == "down" then
            if turtle.detectDown() == true then
                dig("down")
            else
                escape = 1
                return 
            end
        elseif direction == "forward" then
            if turtle.detect() == true then
                dig("forward")
            else
                escape = 1
                return 
            end
        end
    sleep(1)
    end
end



local turn = 0
local ending = userInput("how long is the path",1)

turtle.turnLeft()

for n=1,ending do
    if turn % 2 == 0 then
        rechtsaf()
    else
        linksaf()
    end
    for n=1,3 do
        
        placeItem("down","minecraft:cobblestone")
        move("up",1)
        dig("up")
        gravelRemoval("up")
        move("down",1)
        if n ~= 3 then
        move("forward",1)
        end
    end
    turn = turn + 1
    restack()
end

turtle.turnRight()
