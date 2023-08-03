--dawn default boot program
--by dusk

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

ke.scrMSG(3,"'dbios' as username enters dbios.")
shell.run("/bin/login.lua")