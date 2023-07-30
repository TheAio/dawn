--system management stuff
--must always be run with sudo no matter what, obvs
--stuff like system configs etc will be moved to here

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
        printError("WARNING! THIS WILL CLEAR /ETC/CONFIG/")
        write("proceed? [y/n]:")
        local yn = read()
        if yn == "y" then
            shell.run("rm /etc/config/*")
        elseif yn == "n" then
            error("Cancelling.",0)
        else
            error("Invalid input.",0)
        end
    end
else
    error("Must be run with sudo.",0)
end