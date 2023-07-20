--dawn installer

local handle

handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/fs"))
local rfs = textutils.unserialise(handle.readAll())
handle.close()
handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/files"))
local files = textutils.unserialiseJSON(handle.readAll())
handle.close()

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
local password = read()
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

print("Please note that as of now, this installer works with 'idev' branch only.")
write("MAKE: basefs...")
for k,v in pairs(rfs) do
    fs.makeDir(v)
    sleep(0.001)
end
print("done")
write("MAKE: core...")
for k,v in pairs(files) do
    shell.run("fg wget https://raw.githubusercontent.com/XDuskAshes/dawn/idev"..v,v)
end
print("done")