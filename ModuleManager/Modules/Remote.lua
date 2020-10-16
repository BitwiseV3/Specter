local Remote = {}
local PackagedRemotes = {}

--[[
	RemoteObject: RemoteEvent/RemoteFunction
	NameAs: String name of the package
	...: Arguments being sent to the remote.
--]]
function Remote:Package(RemoteObject, NameAs, ...)
	if typeof(RemoteObject) == "Instance" and (RemoteObject:IsA("RemoteEvent") or RemoteObject:IsA("RemoteFunction")) then
		if type(NameAs) == "string" then
			PackagedRemotes[NameAs] = {Remote = RemoteObject, Args = {...}}
		else
			warn("Remote:Package(RemoteObject, NameAs, ...) failed it didn't get a string for the package name it got '"..tostring(NameAs).."'")
		end
	else
		warn("Remote:Package(RemoteObject, NameAs, ...) failed it didn't get a RemoteEvent/RemoteFunction it got '"..tostring(RemoteObject).."'")
	end
end

--[[
	PackageName: Name of the package assigned from Remote:Package(RemoteObject, NameAs, ...)
--]]
function Remote:FirePackage(PackageName)
	if PackagedRemotes[PackageName] then
		local Package = PackagedRemotes[PackageName]
		print(PackageName, Package.Remote, Package.Args)
		if Package.Remote:IsA("RemoteEvent") then
			Package.Remote:FireServer(unpack(Package.Args))
		elseif Package.Remote:IsA("RemoteFunction") then
			return Package.Remote:InvokeServer(unpack(Package.Args))
		end
	else
		warn("Remote:FirePackage(PackageName) has failed, the package with the name '"..tostring(PackageName).."' doesn't exist.")
	end
end

return Remote