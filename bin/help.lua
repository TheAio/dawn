--[[
    Help program
    Pull from /etc/dash/help/
    By Dusk
]]

local kernel = require "/kernel"

local args = {...}
if #args < 1 then
    local t = {}
    local handle = fs.open("/etc/dash/commlist","r")
    repeat
        local a = handle.readLine()
        table.insert(t,a)
    until a == nil
    for i,v in ipairs(t) do
        textutils.pagedPrint(v)
    end
    error()
end

if args[1] == "-l" then
    local i = fs.list("/bin/")
        for k,v in pairs(i) do
            print(v)
        end
end