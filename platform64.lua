function voorzichtig_forward()
    if turtle.inspect() == false then
        turtle.forward()
    else
        write("** Help ik ben geblokeerd **\n\n Ik stop alles nu\n")
        error()
    end
end

function achtdoor()
    write("ik plaats 8 blokjes\n")
    for num=1,8 do
        if turtle.inspectDown() == false then
            write("ik plaats een blokje\n")
            turtle.placeDown()
        else
            write("ik hoef geen blokje te plaatsen\n")
        end
        write("ik doe eenstapje vooruit")
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

if turtle.getItemCount(turtle.getSelectedSlot()) < 64 then
    write("er zitten niet 64 blokjes in slot 1")
    error()
end

if turtle.getFuelLevel() > 64  then
    for num=1,4 do
        achtdoor()
        rechtsaf()
        achtdoor()
        linksaf()
    end
else
    write("niet genoeg brandstof")
end
