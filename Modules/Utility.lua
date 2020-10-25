local Utility = {}

-- ... = "Players", "RunService", etc,.
function Utility:GetServices(...)
	local Pack = {}
	local Args = {...}
	for i = 1, #Args do
		table.insert(Pack, game:GetService(Args[i]))
	end
	return unpack(Pack)
end

local Players, RunService = Utility:GetServices("Players", "RunService")

-- Object = The Object.
-- Index = the property name to access inside of Object.
function Utility:RepeatUntilObjectIndex(Object, Index)
	while RunService.Stepped:Wait() do
		local Success, Message = pcall(function()
			return Object[Index]
		end)
		if Success and Message then
			break
		end
	end
end

-- Location = CFrame/Vector3 value.
function Utility:TeleportTo(Location)
	Utility:RepeatUntilObjectIndex(Players, "LocalPlayer")
	Utility:RepeatUntilObjectIndex(Players.LocalPlayer, "Character")

	local HumanoidRootPart = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		if typeof(Location) == "CFrame" then
			HumanoidRootPart.CFrame = Location
		elseif typeof(Location) == "Vector3" then
			HumanoidRootPart.Position = Location
		end
	end
end

-- StringName = Full or partial name of a player.
function Utility:GetPlayerByName(StringName)
	if not type(StringName) == "string" or #StringName < 3 then
		return nil
	end
	for i,v in pairs(Players:GetPlayers()) do
		if v.Name:lower():sub(1, #StringName) == StringName:lower() then
			return v
		end
	end
end

-- Parent = Instance to look into.
-- Properties = table with index being property name and the value being the matching value.
-- {Name = "Ha", Anchored = true}, etc,.
function Utility:GetObjectByPropertyMatch(Parent, Properties)
	local function IsMatch(Object)
		local Checked, Matched = 0, 0
		for i,v in pairs(Properties) do
			Checked = Checked + 1
			local Success, Value = pcall(function()
				return Object[i]
			end)
			if Success and Value == v then
				Matched = Matched + 1
			end
		end
		return Checked == Matched
	end
	for i,v in pairs(Parent:GetDescendants()) do
		if IsMatch(v) then
			return v
		end
	end
end

return Utility