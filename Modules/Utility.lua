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

function Utility:RepeatUntil(Object, Index)
	repeat RunService.Stepped:Wait()
	until Object[Index]
end

-- Location = CFrame/Vector3
function Utility:TeleportTo(Location)
	Utility:RepeatUntil(Players, "LocalPlayer")
	Utility:RepeatUntil(Players.LocalPlayer, "Character")

	local HumanoidRootPart = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart then
		if typeof(Location) == "CFrame" then
			HumanoidRootPart.CFrame = Location
		elseif typeof(Location) == "Vector3" then
			HumanoidRootPart.Position = Location
		end
	end
end

return Utility