local Service = {}
Service.LoadedServices = {}

local function FormatService(ServiceName)
    return ""
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
    else
        
    end
end

function Service:Load(ServiceName)

end

function Service:Remove(ServiceName)

end

return Service