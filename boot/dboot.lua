--dawn default boot program
--by dusk

local k = require "/kernel"

term.clear()
term.setCursorPos(1,1)

local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/fs"))
    local bfs = {}
    repeat
        local a = handle.readLine()
        table.insert(bfs,a)
    until a == nil
handle.close()

local handle2 = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/files"))
    local bfiles = {}
    repeat
        local a = handle2.readLine()
        table.insert(bfiles,a)
    until a == nil
handle2.close()


if fs.exists("/etc/config/simpleboot") then --simple looking boot anim ( [ ########## ] )
    
else --logging and such
    for i,v in pairs(bfs) do
        if fs.exists(v) ~= true then
            fs.makeDir(v)
            k.scrMSG(4,v.." doesn't exist. dir made.")
        else
            k.scrMSG(1,v.." exists")
        end
        sleep(0.01)
    end

    for i,v in pairs(bfiles) do
        if fs.exists(v) ~= true then
            k.scrMSG(4,v.." doesn't exist. download.")
            shell.run("wget",v,v)
        else
            k.scrMSG(1,v.." exists")
        end
        sleep(1)
    end
end