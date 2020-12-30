local badblocks = {"minecraft:stone","rustic:slate","chisel:limestone2","minecraft:sand","minecraft:gravel","minecraft:cobblestone","chisel:marble2","chisel:basalt2","minecraft:dirt","minecraft:stained_hardened_clay"}

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

cleanup()