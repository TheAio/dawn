--make a file at the defined destination

local pass

local args = {...}

if fs.exists(args[1]) then
    if fs.isDir(args[1]) then
        error(args[1].." is dir",0)
    else
        error(args[1].." exists",0)
    end
end

--paths that need sudo. (literally anything but the user's home directory and /tmp/ lmfao)
local needSudo = {
    "/bin/",
    "/boot/",
    "/boot/dbios/",
    "/boot/dbios/core/",
    "/dev/",
    "/etc/",
    "/etc/config/",
    "/etc/dash/",
    "/etc/dash/help/",
    "/etc/dawn/",
    "/etc/logs/",
    "/etc/usr/",
    "/home/",
    "/lib/",
    "/mnt/",
    "/sbin/",
    "/stat/",
    "/stat/pkg/",
    "/sys/",
    "/usr/",
    "/usr/bin/",
    "/usr/lib/",
    "/usr/local/",
    "/usr/sbin/",
    "/usr/share/",
    "/var/"
}

--Open the .login file, created by /bin/login.lua
--Ideally, we would want programs to be wrappable with 'sudo', but I can't figure that out yet :p
--For the time being, open it and then open /etc/passwd until we find the right one.
--Then, password prompt. If that fails, then kick to terminal prompt
--Until I can detect the dir it's in, you'll always need sudo perms.
if fs.exists("/etc/usr/.login") then
    local handle = fs.open("/etc/usr/.login","r")
    local user = handle.readLine()
    handle.close()

    local handle2 = fs.open("/etc/sudoers","r")
    repeat
        local a = handle2.readLine()
        if a == nil then
            error("User does not have sudo permissions.",0)
        end
    until a == user
    handle2.close()

    local handle3 = fs.open("/etc/passwd","r")
    repeat
        local a = handle3.readLine()
        if a == nil then
            os.reboot()
        end
        --Ideally, we want no unused data, which is useless ram usage.
        --However, I don't want to break the matching.
        local usr, id, home, cshell = "", "foo", "bar", "gab"
        usr, pass, id, home, cshell = string.match(a, "([^:]+):([^:]+):([^:]+):([^:]+):([^:]+)")
        if user == nil then
            error("No user found.",0)
        end
    until user == usr
    write("Password: ")
    local input = read("#")
    if input == pass then
        fs.copy("/etc/file",args[1])
    else
        error("Password doesn't match.",0)
    end
else
    error("/etc/usr/.login doesn't exist: cannot discern user.")
end