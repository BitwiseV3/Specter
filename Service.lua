local Service = {}
Service.LoadedServices = {}

local function FormatServiceUrl(ServiceName)
    return "https://raw.githubusercontent.com/BitwiseV3/Specter/main/Services/"..tostring(ServiceName)
end

local function HttpGet(Link)
    local Success, Content = pcall(function()
        return game:HttpGet(Link)
    end)
    if not Success then
        warn("Failure to retrieve '"..tostring(Link).."'")
    else
        return Content
    end
end

function Service:Get(ServiceName)
    if ServiceName and Service.LoadedServices[ServiceName] then
        return Service.LoadedServices[ServiceName]
    elseif ServiceName then
        return Service:Load(ServiceName)
    end
end

function Service:Load(ServiceName)
    if not Service.LoadedServices[ServiceName] then
        local Content = HttpGet(FormatServiceUrl(ServiceName))
        if Content then
            local Module = loadstring(Content)()
            Service.LoadedServices[ServiceName] = Module
            return Module
        else
            warn("Loading module failed, '"..tostring(ServiceName).."' wasn't found in the Services folder.")
        end
    else
        warn("Loading module denied, '"..tostring(ServiceName).."' was already loaded.")
    end
end

return Service