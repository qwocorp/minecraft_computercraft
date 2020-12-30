--restack

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

restack()


-- turtle.select(sourceslot)
-- turtle.getItemSpace(16)
