--[[
	Load the module on and wait for LoadModule for action.
--]]
local ModuleLocation = "https://raw.githubusercontent.com/BitwiseV3/Specter/main/ModuleManager/Modules/" -- ModuleName.lua
local Preloaded = {}

function GetModuleHttp(Link)
	local Success, Module = pcall(game.HttpGet, game, Link)
	if Success then
		return loadstring(Module)()
	else
		warn("GetModuleHttp(Link) failed to find module for this link: "..tostring(Link))
	end
end

--[[
	ModuleName: The name of the Module.
	NameAs: Make the index/name of the module different from the ModuleName to access.
--]]
getgenv().PreloadModule = function(ModuleName, NameAs)
	Preloaded[NameAs or ModuleName] = GetModuleHttp(ModuleLocation..ModuleName..".lua")
end

--[[
	ModuleName: The name of the Module.
	NameAs: Make the index/name of the module different from the ModuleName to access.
--]]
getgenv().LoadModule = function(ModuleName, NameAs)
	if not getgenv()[NameAs or ModuleName] then
		if not Preloaded[NameAs or ModuleName] then
			getgenv()[NameAs or ModuleName] = GetModuleHttp(ModuleLocation..ModuleName..".lua")
		else
			getgenv()[NameAs or ModuleName] = Preloaded[NameAs or ModuleName]
		end
	else
		warn("LoadModule(ModuleName, NameAs)", NameAs or ModuleName, "was already loaded.")
	end
end