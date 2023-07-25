--remove files, dirs, etc
--again, we would ideally want a sudo wrapper, but that won't be possible for time being
--idc, people can delete their entire system if they want. This is what I will now be calling a "nuke" program
--meaning that if used incorrectly, it can nuke the system :D

local args = {...}


--commiting a quite literal robbery from touch
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
    print("WARNING: You could potentially nuke your system with this.")
    write("Password: ")
    local input = read("#")
    if input == pass then
        fs.delete(args[1])
    else
        error("Password doesn't match.",0)
    end
else
    error("/etc/usr/.login doesn't exist: cannot discern user.")
end