--dawn default boot program
--by dusk

local ver = fs.open("/stat/.dawninf", "r")
local v = ver.readLine()
ver.close()

local ke = require "/kernel"

local fromROM = {
    "/bin/cd.lua",
    "/bin/ls.lua",
    "/bin/edit.lua"
}

for k,v in pairs(fromROM) do
    if fs.exists(v) then
        ke.scrMSG(1,"exists: "..v)
    else
        if v == "/bin/cd.lua" then
            fs.copy("/rom/programs/cd.lua",v)
        elseif v == "/bin/ls.lua" then
            fs.copy("/rom/programs/list.lua",v)
        elseif v == "/bin/edit.lua" then
            fs.copy("/rom/programs/edit.lua",v)
        end
        ke.scrMSG(3,"had to copy from rom: "..v)
    end
end

sleep(1)
term.clear()
term.setCursorPos(22,6)
local image = paintutils.loadImage("/etc/dawn/logo.nfp")
paintutils.drawImage(image, term.getCursorPos())
term.setCursorPos(18,13)
print("Dawn OS "..v)
term.setCursorPos(5,18)
print("ENTER to boot to login, Z to boot to dbios.")
while true do
    local event = {os.pullEvent()}
    local eventD = event[1]

    if eventD == "key" then
        local k = event[2]
        if k == keys.enter then
          term.clear()
          term.setCursorPos(1,1)
          shell.run("/bin/login.lua")
          break
        elseif k == keys.z then
            term.clear()
            term.setCursorPos(1,1)
            shell.run("/boot/dbios/init.lua")
            break
        end
    end
end