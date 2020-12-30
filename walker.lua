
function getOrientation() --copied from http://www.computercraft.info/forums2/index.php?/topic/1704-get-the-direction-the-turtle-face/
    loc1 = vector.new(gps.locate(2, false))
    if not turtle.forward() then
        for j=1,6 do
                if not turtle.forward() then
                        turtle.dig()
             else break end
        end
    end
    loc2 = vector.new(gps.locate(2, false))
    print("location1", loc1)
    print("location2", loc2)
    heading = loc2 - loc1
    print("heading",heading)
    return ((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))

        --[[orientation will be:
    -x = 1
    -z = 2
    +x = 3
    +z = 4
    This matches exactly with orientation in game, except that Minecraft uses 0 for +z instead of 4.
    --]]

end
    
function getLocation()
    location = vector.new(gps.locate(2, false))
    return location
end

function numberToCompas(dir)
    -- postitive X = east = 3
    -- positive z = south = 4
    -- negative x = west = 1
    -- negative z = north = 2
    local compas = "NaN"
    if dir == 1 then
        compas = "west"
    elseif  dir == 2 then
        compas = "north"
    elseif dir == 3 then
        compas = "east"
    elseif dir == 4 then
        compas = "south"
    end
end

--get start location and position
local GPSlocation = getLocation()
local GPSdirection = getOrientation()
local windDirection = numberToCompas(GPSdirection)
local turtleLabel = os.getComputerLabel()

print("turtle",turtleLabel,"location is",GPSlocation,"and is facing",windDirection, "which is",GPSdirection)
