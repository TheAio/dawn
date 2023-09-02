--[[
    DASH Terminal
    Custom for dawn os
    By Dusk
]]

local user = ""

local kernel = require("/kernel")

local label = os.getComputerID() or os.getComputerLabel()

if fs.exists("/etc/usr/.login") ~= true then
    shell.run("/usr/bin/dash-login.lua")
end

local handle = fs.open("/etc/usr/.login","r")
user = handle.readLine()
handle.close()

local handle2 = fs.open("/stat/.dawninf","r")
local kernelVer = handle2.readLine()
handle2.close()

local function isempty(s) --i robbed this from https://stackoverflow.com/questions/19664666/check-if-a-string-isnt-nil-or-empty-in-lua
    return s == nil or s == ''
end

local function t()
    local termSize, termS = term.getSize()
    local tCurs,yCurs = term.getCursorPos()
    if yCurs == 1 then
        yCurs = yCurs + 2
    end
    term.clearLine(1,1)
    term.setCursorPos(1,1)
    write("DASH 1.0 | ["..termSize..":"..termS.."] | ")
    write(string.rep(" ",termSize))
    write(string.rep("=", termSize))
    term.setCursorPos(tCurs,yCurs)
end

local function fetchConfig()
    useFileBasedInputs = false
    fileBasedInputPath = "/tmp/dash-input.temp"
    runFolderAtStart = false
    startFolderPath = ""
    if fs.exists("/etc/dash.conf") then
        confHandle = fs.open("/etc/dash.conf","r")
        confFile={}
        while true do
            local i = confHandle.readLine()
            if i == nil then
                break
            else
                confFile[#confFile+1] = i
            end
        end
        confHandle.close()
        for i=1,#confFile do
            local line = confFile[i]
            if line=="useFileBasedInputs:" then
                if confFile[i+1] == "true" then
                    useFileBasedInputs = true
                else
                    useFileBasedInputs = false
                end
            elseif line == "fileBasedInputPath:" then
                fileBasedInputPath = confFile[i+1]
            elseif line=="runFolderAtStart:" then
                if confFile[i+1] == "true" then
                    runFolderAtStart = true
                else
                    runFolderAtStart = false
                end
            elseif line == "startFolderPath:" then
                startFolderPath = confFile[i+1]
            end
        end
    end
end

fetchConfig()

t()

if runFolderAtStart then
    if fs.exists(startFolderPath) and fs.isDir(startFolderPath) then
        local folderList = fs.list(startFolderPath)
        for i=1, #folderList do
            if not fs.isDir(startFolderPath.."/"..folderList[i]) then
                if term.isColor() then
                    shell.run("bg",startFolderPath.."/"..folderList[i])
                else
                    shell.run(startFolderPath.."/"..folderList[i])
                end
            end
        end
    end
end

while true do
    if fs.exists("/etc/config/colorterm") then
        shell.run("/etc/config/colorterm","r")
    end
    write(user.."-$")
    term.setTextColor(colors.white)
    if useFileBasedInputs then
        if fs.exists(fileBasedInputPath) then
            inputFileHandle = fs.open(fileBasedInputPath,"r")
            input=inputFileHandle.readAll()
            inputFileHandle.close()
            fs.delete(fileBasedInputPath)
        else
            printError("Error: input file path not found '"..fileBasedInputPath.."'")
            input = read()
        end
    else
        input = read()
    end
    if isempty(input) then
        write("")
    elseif input == "reboot" then
        shell.run("/sbin/r.lua")
    else
        shell.run("/bin/"..input)
    end
    if fs.exists("/home/"..user.."/") then
        local handle = fs.open("/home/"..user.."/.dashhistory","a")
        handle.writeLine(input)
        handle.close()
    end
    t()
end
