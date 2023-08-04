--[[
    Minimal Terminal
    By Dusk
]]

local function e(s)
    return s == nil or s == ""
end

local libconfig = require "/lib/libconfig"

local configDefaults = {
    ":"
}

local handle = fs.open("/etc/usr/.login","r")
local user = handle.readLine()
handle.close()

local conf
local dir
if user == "root" then
    if fs.exists("/root/.config/minterm.cfg") then
        libconfig.makeConfig("/root/.config/minterm.cfg",configDefaults)
        conf = libconfig.readConfig("/root/.config/minterm.cfg")
    else
        conf = libconfig.readConfig("/root/.config/minterm.cfg")
    end
elseif fs.exists("/home/"..user.."/.config/minterm.cfg") ~= true then
    libconfig.makeConfig("/home/"..user.."/.config/minterm.cfg",configDefaults)
    conf = libconfig.readConfig("/home/"..user.."/.config/minterm.cfg")
    dir = "/home/"..user.."/"
else
    conf = libconfig.readConfig("/home/"..user.."/.config/minterm.cfg")
    dir = "/home/"..user.."/"
end
table.remove(conf,0)

while true do
        if shell.dir() == "" then
            dir = "/"
        else
            dir = "/"..shell.dir().."/"
        end
    write(conf[2])
    local a = read(nil, nil, function(str)
        return fs.complete(str, dir, {
            include_files = true,
            include_dirs = true,
            include_hidden = true,
        })
    end)
    if e(a) then
        write("")
    else
        shell.run("/bin/"..a)
    end
end