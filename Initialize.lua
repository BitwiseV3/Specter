local Initialize = {}
Initialize.Loaded = {}
Initialize.InWorkspace = {}

local ModuleDirectory = "https://raw.githubusercontent.com/BitwiseV3/Specter/main/Modules/"

pcall(function()
    createdirectory("Specter")
end)

function FormatModuleUrl(ModuleName)
    return ModuleDirectory..tostring(ModuleName)..".lua"
end

function GetFile(Url)
    local Success, Content = pcall(function()
        return game:HttpGet(Url)
    end)
    if Success and Content then
        return Content
    else
        warn("Failed to get the content for '"..tostring(Url).."'")
    end
end

function Initialize:Get(ModuleName)
    if Initialize.Loaded[ModuleName] then
        return Initialize.Loaded[ModuleName]
    elseif Initialize.InWorkspace[ModuleName] then
        local Success, Module = pcall(function()
            return loadstring(readfile("Specter/"..ModuleName..".lua"))()
        end)
        if Success and Module then
            Initialize.Loaded[ModuleName] = Module
            return Module
        end
    else
        return Initialize:Load(ModuleName)
    end 
end

function Initialize:Load(ModuleName)
    if not Initialize.Loaded[ModuleName] then
        local Content = GetFile(FormatModuleUrl(ModuleName))
        if Content then
            local Success, Module = pcall(function()
                return loadstring(Content)()
            end)
            if Module then
                Initialize.Loaded[ModuleName] = Module
                return Module
            elseif Success and not Module then
                warn("Module was required but nothing was returned on loadstring for '"..tostring(ModuleName).."'")
            elseif not Success and not Module then
                warn("Failed to load and returned nothing for '"..tostring(ModuleName).."', this is a big problem. Contact me immediately.")
            end
        else
            warn("Failed to load, '"..tostring(ModuleName).."' not found.")
        end
    else
        warn("Module '"..tostring(ModuleName).."' already loaded.")
    end
end

local VersionJSON = "https://raw.githubusercontent.com/BitwiseV3/Specter/main/Version.json"
local VersionFile = GetFile(VersionJSON)
local VersionTable = game:GetService("HttpService"):JSONDecode(VersionFile)

for ModuleName, Version in pairs(VersionTable) do
    local Success, Content = pcall(function()
        return readfile("Specter/"..ModuleName..".lua")
    end)
    if not Success then
        writefile("Specter/"..ModuleName..".lua", "--"..Version.."\n"..GetFile(FormatModuleUrl(ModuleName)))
    else
        local VSub = Content:find("\n")
        if VSub and type(VSub) == "number" then
            local CVersion = Content:sub(1, VSub - 1)
            if CVersion ~= "--"..Version then
                print("OUT OF DATE UPDATING")
                writefile("Specter/"..ModuleName..".lua", "--"..Version.."\n"..GetFile(FormatModuleUrl(ModuleName)))
            end
        end
        Initialize.InWorkspace[ModuleName] = true
    end
end

getgenv().Specter = Initialize