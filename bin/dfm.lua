--Dusk File Manager

local function e(s)
    return s == nil or s == ""
end

while true do
    term.clear()
    term.setCursorPos(1,1)
    local dir
        if shell.dir() == "" then
            dir = "/"
        else
            dir = "/"..shell.dir().."/"
        end
    print("+ ["..dir.."]")
    local content = fs.list(dir)
    for k,v in pairs(content) do
        if fs.isDir(dir..v) then
            textutils.pagedPrint("| "..v.."/")
        else
            textutils.pagedPrint("| "..v)
        end
    end
    print("+ ["..dir.."]")
    write("Go to/open: ")
    local a = read(nil, nil, function(str)
        return fs.complete(str, dir, {
            include_files = true,
            include_dirs = true,
            include_hidden = false,
        })
    end)
    if e(a) then
        sleep(0.3)
    end
    if fs.exists(dir..a) then
        if fs.isDir(dir..a) then
            shell.run("cd",a)
        else
            shell.run("edit",a)
        end
    end
end
