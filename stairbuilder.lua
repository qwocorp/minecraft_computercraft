

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
            else 
                print("something has gone wrong, there should not be a block in front of me")
            end
        elseif Str == "up" then
            --first there is nothing above us, YES we get to move
            while  turtle.inspectUp() == true do
                turtle.digUp()
            end
            if turtle.inspectUp() == false then
                turtle.up()
            else
                print("something has gone wrong, there should not be a block above me")
            end
        elseif Str == "down"  then
            while turtle.inspectDown() == true do
                turtle.digDown()
            end
            if turtle.inspectDown() == false then
                turtle.down()
            else
                print("something has gone wrong, there should not be a block below me")
        end

        else 
            errorFunction("I got a move command I do not undestand")
        end
    moves = moves - 1
    end
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

function turnRight()
    turtle.turnRight()
    move("forward,1")
    turtle.turnRight()
end

function turnLeft()
    turtle.turnLeft()
    move("forward,1")
    turtle.turnLeft()
end


function placeBlock(Str)
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

    if turtle.inspectDown() == false then
        hebIkBlokjes()
        turtle.placeDown()
    else
        print("ik hoef geen blokje te plaatsen\n")
    end
    print("ik doe eenstapje vooruit")
    voorzichtig_forward()


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