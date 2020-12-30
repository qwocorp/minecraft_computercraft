local keep = {"minecraft:chest","minecraft:coal"}

function chestDump(location)
    local go = placeItem("down","minecraft:chest")
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
                    turtle.dropDown()
                else
                    print("not dropping item ", turtle.getItemDetail(n).name," in chest")
                end
            end
        end
    end
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


chestDump("down")