--system management stuff
--must always be run with sudo no matter what, obvs
--stuff like system configs etc will be moved to here

local function e(s)
    return s == nil or s == ""
end

local lio = require "/lib/libio"
local args = {...}

if args[1] == "-h" then
    print("sysmgr - system management (must be run with sudo)")
    print("sysmgr --cleanup | cleanup all temp/dump files")
    print("sysmgr --default-sh | set the default shell")
    print("sysmgr --clear-config | clear /etc/config/")
end

if fs.exists("/tmp/sudo") then
    if args[1] == "--cleanup" then
        shell.run("rm /tmp/*")
        shell.run("rm /etc/dump/*")
        shell.run("rm /var/dump/*")
    elseif args[1] == "--default-sh" then
    if fs.exists("/etc/dawn/sh-default") then
        fs.delete("/etc/dawn/sh-default")
    end
        local handle = fs.open("/etc/dawn/sh-default","w")
        handle.write(args[2])
        handle.close()
    elseif args[1] == "--clear-config" then
        term.setTextColor(colors.red)
        write("WARNING: Clears /etc/config. Continue? ")
        sleep(1)
        term.setTextColor(colors.white)
        local a = lio.ynae.npref()
        if a == true then
            shell.run("rm /etc/config/*")
        elseif a == false then
            error("Bailing!",0)
        end
    end
else
    error("Must be run with sudo.",0)
end
