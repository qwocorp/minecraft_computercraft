function rotate()
    turtle.turnRight()
    turtle.turnRight()
end

function pullSet()
    for n=1,12 do
        turtle.select(n)
        turtle.suck(64)
    end
end

function dumpSet(int)
    for n=1+int,6+int do
        turtle.select(n)
        turtle.drop(64)
    end
end

print("The turtle must FACE the source chest")
sleep(2)

while true == true do
    print("pulling 12 slots from source chest")
    pullSet()
    print("returning 6 sets to source chest")
    dumpSet(0)
    print("turn to face target chest")
    rotate()
    print("drop 6 sets to target chest")
    dumpSet(6)
    print("turn to face source chest")
    rotate()
    print("waiting 600 seconds")
    sleep(600)
end


