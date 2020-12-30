print("Name: "..os.getComputerLabel())
print("ID: "..os.getComputerID())
print("Fuel: "..turtle.getFuelLevel())

print("---------------")
print("running startup script")
sleep(2)

pastebinid = "bxnC72zz"
payload = "chestcleanup"
backup = payload .. ".bak"

print("Fetching " .. payload .. " program from pastebin")
if (fs.exists(backup)) then
  fs.delete(backup)
end
if (fs.exists(payload)) then
    fs.move(payload, backup)
end
local ok = shell.run("pastebin", "get " .. pastebinid .. " " .. payload)
print("pastebin results: ",ok)
print("Executing " .. payload .. " program")
if (not fs.exists(payload)) then
  print("Error: '" .. payload .. "' does not exist. Using old version.")
  fs.copy(backup, payload)
end
shell.run(payload)