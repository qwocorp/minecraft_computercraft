local breakout = 1
while turtle.inspectDown() == false do
    turtle.down()
    breakout = breakout + 1
    if breakout > 100 then
        print("we stoppen hier, al 100 keer bewogen")
        error()
    end
end
