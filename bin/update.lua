--dawn updater

local spinner = {"|","/","-","\\"}
local stage = 0
local new = {}
local remove = {}
local update = {}

local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/update/new"))
local x,y = term.getCursorPos()
repeat
    local a = handle.readLine()
    if a == "nil" then
        break
    else
        term.setCursorPos(x,y)
        stage = (stage % 4) + 1
        write("write new data to table " .. spinner[stage].." ")
        table.insert(new,a)
    end
until a == nil

handle.close()

local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/update/remove"))
local x,y = term.getCursorPos()
repeat
    local a = handle.readLine()
    if a == "nil" then
        break
    else
        term.setCursorPos(x,y)
        stage = (stage % 4) + 1
        write("write remove data to table " .. spinner[stage].." ")
        table.insert(remove,a)
    end
until a == nil

handle.close()

local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/update/update"))
local x,y = term.getCursorPos()
repeat
    local a = handle.readLine()
    if a == "nil" then
        break
    else
        term.setCursorPos(x,y)
        stage = (stage % 4) + 1
        write("write remove data to table " .. spinner[stage].." ")
        table.insert(update,a)
    end
until a == nil

handle.close()

local x,y = term.getCursorPos()
if #new < 1 then
    print("There is nothing new.")
else
    write("\n")
    for k,v in pairs(new) do
        if fs.exists(v) then
            print("File",v,"exists")
        else
            local file = v
            local toWrite = {}
            local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev"..v))
                repeat
                    local a = handle.readLine()
                    table.insert(toWrite,a)
                until a == nil
            handle.close()
            local handle = fs.open(v,"w")
            local x,y = term.getCursorPos()
                for k,v in pairs(toWrite) do
                    handle.writeLine(v)
                    term.setCursorPos(x,y)
                    stage = (stage % 4) + 1
                    write("adding files... ("..file..") " .. spinner[stage].." ")
                    sleep(0.01)
                end
            handle.close()
            write("done. \n")
        end
    end
end

local x,y = term.getCursorPos()
if #remove < 1 then
    print("Nothing to remove.")
else
    write("\n")
    local x,y = term.getCursorPos()
    for k,v in pairs(remove) do
        term.setCursorPos(x,y)
        fs.delete(v)
        stage = (stage % 4) + 1
        write("deleting files... ("..v..") ".. spinner[stage].." ")
        sleep(0.01)
    end
end

local x,y = term.getCursorPos()
if #update < 1 then
    print("Nothing to update.")
else
    write("\n")
    for k,v in pairs(new) do
        if fs.exists(v) then
            fs.delete(v)
        end
            local file = v
            local toWrite = {}
            local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev"..v))
                repeat
                    local a = handle.readLine()
                    table.insert(toWrite,a)
                until a == nil
            handle.close()
            local handle = fs.open(v,"w")
            local x,y = term.getCursorPos()
                for k,v in pairs(toWrite) do
                    handle.writeLine(v)
                    term.setCursorPos(x,y)
                    stage = (stage % 4) + 1
                    write("updating files... ("..file..") " .. spinner[stage].." ")
                    sleep(0.01)
                end
            handle.close()
            write("done. \n")
        end
    end

