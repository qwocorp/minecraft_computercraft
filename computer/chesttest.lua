
print("please choose")
print("left / right")
local location = io.read()

local chestread = peripheral.wrap(location)
print(chestread.listMethods())-- see all the methods and find the one you need.
print(chestread.theMethod())

