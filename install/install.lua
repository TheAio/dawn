--dawn installer

local spinner = {"|","/","-","\\"}
local stage = 0

local handle

local rfs = {}
local files = {}

local fshandle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/fs"))
repeat
    local a = fshandle.readLine()
    table.insert(rfs,a)
until a == nil
fshandle.close()

local fihandle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/files"))
repeat
    local a = fihandle.readLine()
    table.insert(files,a)
until a == nil
fihandle.close()

local function e(s)
    return s == nil or s == ""
end

term.clear()
term.setCursorPos(1,1)
print("This installer will install the DAWN kernel on your system.")
print("")
print("The following is some quick setup for the main user account.")

print("Username:")
write("> ")
local user = read()
if user == "root" then
    printError("Username cannot be 'root'. Defaulting to piggle")
    user = "piggle"
elseif e(user) then
    printError("Username cannot be nil or ''. Defaulting to piggle")
    user = "piggle"
end

print("Password:")
write("> ")
local password = read("#")
if e(password) then
    password = "1234"
    printError("Password cannot be empty. (DEFAULT: 1234)")
end

print("Add a home folder? (y/n (y is default)):")
write("> ")
local home = read()
if home == "y" then
    home = true
elseif home == "n" then
    home = false
else
    home = true
end

print("Should user be sudo? (y/n (y is default)):")
write("> ")
local sudo = read()
if sudo == "y" then
    sudo = true
elseif sudo == "n" then
    sudo = false
else
    sudo = true
end

term.clear()
term.setCursorPos(1,1)
print("Please note that as of now, this installer works with 'idev' branch only.")
sleep(1)
write("make basefs...")
for k,v in pairs(rfs) do
    fs.makeDir(v)
    term.setCursorPos(1,3)
    stage = (stage % 4) + 1
    write("make basefs " .. spinner[stage].." ")
    sleep(0.01)
end
stage = 0
print("done")
write("get core...")
for k,v in pairs(files) do
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
            term.setCursorPos(1,4)
stage = (stage % 4) + 1
write("get core... " .. spinner[stage].." ")
end
print("done")
write("write user data of "..user.." to /etc/passwd...")
handle = fs.open("/etc/passwd","a")
handle.write(user..":"..password..":1:")
if home == true then
    fs.makeDir("/home/"..user)
    handle.write("/home/"..user..":")
else
    handle.write("nil:")
end
handle.write("/usr/bin/dash.lua\n")
handle.close()
print("done")
if sudo == true then
    write("write "..user.." to /etc/sudoers...")
    local handle = fs.open("/etc/sudoers","a")
    handle.writeLine(user)
    handle.close()
end
print("done")

write("copy ls, cd, and edit from '/rom/' to '/bin/'...")

fs.copy("/rom/programs/cd.lua","/bin/cd.lua")
fs.copy("/rom/programs/list.lua","/bin/ls.lua")
fs.copy("/rom/programs/edit.lua","/bin/edit.lua")
print("done")

print("Restarting in 3 seconds.")
sleep(3)
os.reboot()