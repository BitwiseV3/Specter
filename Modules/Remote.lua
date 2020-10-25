local Remote = {}
local Packed = {}

function Remote:Package(Remote, PackageName, ...)
	Packed[PackageName] = {
		Remote = Remote,
		Args = {...}
	}
end

function Remote:RunPackage(PackageName)
	local Package = Packed[PackageName]
	local Remote = Package.Remote
	if Remote and Remote:IsA("RemoteEvent") then
		Remote:FireServer(unpack(Package.Args))
	elseif Remote and Remote:IsA("RemoteFunction") then
		return Remote:InvokeServer(unpack(Package.Args))
	end
end

return Remote