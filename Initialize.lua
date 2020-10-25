local Initialize = {}
Initialize.Loaded = {}
Initialize.InWorkspace = {}

local ModuleDirectory = "https://raw.githubusercontent.com/BitwiseV3/Specter/main/Modules/"

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

getgenv().Specter = Initialize