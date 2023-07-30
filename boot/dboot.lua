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

local fromROM = {
    "[ /bin/cd.lua ]" == "/rom/programs/cd.lua",
    "[ /bin/ls.lua ]" == "/rom/programs/list.lua",
    "[ /bin/edit.lua ]" == "/rom/programs/edit.lua"
}

if fs.exists("/etc/config/simpleboot") then --simple looking boot anim ( [ ########## ] )
    term.setCursorPos(11,8)
    print("Dawn is booting, please wait.")
    term.setCursorPos(18,10)
    write("[ ---------- ]")
    term.setCursorPos(20,10)
    for i,v in pairs(bfs) do
        if fs.exists(v) ~= true then
            fs.makeDir(v)
        end
        sleep(0.01)
    end

    textutils.slowWrite("#####")

    for i,v in pairs(bfiles) do
        if fs.exists(v) ~= true then
            handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/"..v))
            local toWrite = {}
            repeat
                local a = handle.readLine()
                table.insert(toWrite,a)
            until a == nil
            handle.close()
            handle = fs.open(v,"w")
            for _,v in pairs(toWrite) do
                handle.writeLine(v)
            end
            handle.close()
        end
        sleep(0.01)
    end

    textutils.slowWrite("#####")

    term.setCursorPos(6,8)
    sleep(0.1)
    print("Dawn has finished booting. Going to login.")
    sleep(1)
    term.clear()
    term.setCursorPos(1,1)
    shell.run("/bin/login.lua")
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
            shell.run("wget","https://raw.githubusercontent.com/XDuskAshes/dawn/idev/"..v,v)
        else
            k.scrMSG(1,v.." exists")
        end
        sleep(0.01)
    end

    if fs.exists("/tmp/ccpcBug") then
        fs.delete("/tmp/ccpcBug")
        k.scrMSG(3,"dbios can be entered as a username")
    end
    shell.run("/bin/login.lua")
end