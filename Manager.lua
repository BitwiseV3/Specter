local Directory = {Url = {}}

Directory.Url.Version = "https://raw.githubusercontent.com/BitwiseV3/Specter/main/Version.json"
Directory.Url.Modules = "https://raw.githubusercontent.com/BitwiseV3/Specter/main/Modules/"

Directory.Folder = "Specter"

-- Main code, don't touch unless you don't know what you're doing.
local Interface = {}

local function GetModuleFromGithub(ModuleName)
	local Success, File = pcall(function()
		return game:HttpGet(Directory.Url.Modules..ModuleName)
	end)
	return Success and File or nil
end

local function GetModuleFromWorkspace(ModuleName)
	local Success, File = pcall(function()
		return readfile(Directory.Folder.."/"..ModuleName)
	end)
	return Success and File or nil
end

function Interface:Load(ModuleName)

end

function Interface:Get(ModuleName)

end

-- Checks modules in Workspace/Specter folder is up to date with Github.
local function UpdateNeeded(CurrentVersion, LatestVersion)
	local ToSub = CurrentVersion:find("\n")
	if ToSub and type(ToSub) == "number" then
		if CurrentVersion:sub(1, ToSub - 1) ~= LatestVersion then
			return true
		end
	end
	return false
end

pcall(function()
	createdirectory(Directory.Folder)
end)

local VersionFile = game:GetService("HttpService"):JSONDecode(game:HttpGet(Directory.Url.Version))

for ModuleName, Version in pairs(VersionFile) do
	local WorkspaceFile = GetModuleFromWorkspace(ModuleName)
	if WorkspaceFile then
		if UpdateNeeded(WorkspaceFile, Version) then
			writefile(Directory.Folder.."/"..ModuleName..".lua", "--"..Version.."\n"..GetModuleFromGithub(ModuleName))
		end
	else
		writefile(Directory.Folder.."/"..ModuleName..".lua", "--"..Version.."\n"..GetModuleFromGithub(ModuleName))
	end
end

getgenv().Specter = Interface