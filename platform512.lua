function voorzichtig_forward()
    if turtle.inspect() == false then
        fuelcheck()
        turtle.forward()
    else
        print("** Help ik ben geblokeerd **\n\n Ik stop alles nu\n")
        error()
    end
end

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

function rechtdoor(Int)
    for num=1,Int do
        if turtle.inspectDown() == false then
            print("ik plaats een blokje\n")
            hebIkBlokjes()
            turtle.placeDown()
        else
            print("ik hoef geen blokje te plaatsen\n")
        end
        print("ik doe eenstapje vooruit")
        voorzichtig_forward()
    end

end

function rechtsaf()
    write("ik draai rechtsom\n")
    turtle.turnRight()
    voorzichtig_forward()
    turtle.turnRight()
    voorzichtig_forward()
end

function linksaf()
    write("ik draai linksom\n")
    turtle.turnLeft()
    voorzichtig_forward()
    turtle.turnLeft()
    voorzichtig_forward()
end

function inventarisCheck()
    local totalitems = 0
    for slotcheck=1,8 do
        totalitems = turtle.getItemCount(slotcheck) + totalitems
    end
    print("totale hoeveelheid items in slot 1 t/m 8")
    print(totalitems)
    return totalitems
end

function leesNummer(Str)
    print(Str)
    local nummer = io.read()
    nummer = tonumber(nummer)
    if nummer == nil then
        print("niet een geldig getal ingevoerd")
        error()
    else
    return nummer
    end
end

function stopEven()
    print("wil je doorgaan type: j")
    local antwoord = io.read()
    if antwoord ~= "j" then
        print("we stoppen op jouw verzoek")
        error()
    end
end

function hebIkBlokjes()
    local var = false
    local breakout = 0 
    while var == false do
            if turtle.getItemCount(turtle.getSelectedSlot()) == 0 then
                turtle.select(1+turtle.getSelectedSlot())
            else
            var = true
            end
        breakout = breakout + 1
        if breakout > 8 then
            print("er is iets misgegaan, heb ik wel genoeg blokjes?")
            error()
        end
        if turtle.getSelectedSlot() > 8 then
            print("we zijn buiten slot 1 t/m 8 gegaan, dat mag niet")
            error()
        end
    end
end

function startTurn()
    print("Moet de eerste bocht naar rechts of naar links (R/L)?")
    local input = io.read()
    local turnRelay = 0
    if input == "R" then
        turnRelay = 0
    elseif input == "L" then
        turnRelay = 1
    else
        print("ongeldige input, je had R of L moeten typen (let op hoofdletter)")
        error()
    end
    return turnRelay
end

--haal op hoeveel blokjes we hebben in de eerste 8 slots van de turtle
local supply = inventarisCheck()

--vraag gebruiker hoe groot zijn oppervalk moet zijn x keer y
print("de turtle wil graag weten hoe lang en breed je oppervlak moet zijn")
local lengte = leesNummer("hoe lang")
local breedte = leesNummer("hoe breed")

local oppervlak = lengte*breedte

if supply < oppervlak then
    print("je gegeven oppervlak is groter dan het aantal blokjes in slot 1 t/m 8")
    print("oppervlak", oppervlak)
    print("blokjes", supply)
    error()
else
    print("oppervlak", oppervlak)
    print("blokjes", supply)
end

--stopEven()

local kostenDraaien = breedte*2
local kostenVooruitgaan = lengte*breedte
local totaleKosten = kostenVooruitgaan + kostenDraaien

if turtle.getFuelLevel() < totaleKosten then
    print("je gegeven oppervlak is groter dan de hoeveelheid brandstof in de turtle ")
    print("oppervlak", oppervlak)
    print("brandstof", turtle.getFuelLevel())
else
    print("oppervlak", oppervlak)
    print("brandstof", turtle.getFuelLevel())
end
--stopEven()
local turn = startTurn()

--starten op slot 1
turtle.select(1)

for rows=1,breedte do
    rechtdoor(lengte)
    if turn % 2 == 0 then
        rechtsaf()
    else
        linksaf()
    end
    turn = turn + 1
end
