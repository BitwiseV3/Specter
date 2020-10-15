local Utility = {}

--[[
	...: Any amount of string names of services.
--]]
function Utility:GetServices(...)
	local Services = {}
	local ServiceList = {...}
	for i = 1, #ServiceList do
		if type(ServiceList[i]) == "string" then
			table.insert(Services, game:GetService(ServiceList[i]))
		end
	end
	return unpack(Services)
end

local Players, RunService = Utility:GetServices("Players", "RunService")

--[[
	MaxDistance(Optional): How far you want this to reach.
	MinDistance(Optional): How close they have to be but not too close.
--]]
function Utility:GetNearestPlayer(MaxDistance, MinDistance)
	local LocalPlayer = Players.LocalPlayer
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local LocalRootPart = Character:WaitForChild("HumanoidRootPart")

	MaxDistance = MaxDistance or math.huge
	MinDistance = MinDistance or 0

	local Closest, ClosestPlayer = math.huge, nil
	local PlayerList = Players:GetPlayers()

	for i = 1, #PlayerList do
		local Player = PlayerList[i]
		if Player ~= LocalPlayer then
			if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
				local OtherRootPart = Player.Character.HumanoidRootPart
				local Distance = (LocalRootPart.Position - OtherRootPart.Position).Magnitude
				if Distance <= MaxDistance and Distance >= MinDistance and Distance <= Closest then
					Closest = Distance
					ClosestPlayer = Player
				end
			end
		end
	end

	return ClosestPlayer, Closest
end

--[[
	StringName: The name of the player, partial or full with the minimum of 3 characters.
--]]
function Utility:GetPlayerByName(StringName)
	if type(StringName) == "string" then
		if #StringName >= 3 then
			local PlayerList = Players:GetPlayers()
			for i = 1, #PlayerList do
				local Player = PlayerList[i]
				if Player.Name:sub(1, #StringName):lower() == StringName then
					return Player
				end
			end
		else
			warn("Utility:GetPlayerByName(StringName) failed, the name is less than 3 characters.")
		end
	else
		warn("Utility:GetPlayerByName(StringName) failed, it didn't receive a string it got '"..tostring(StringName).."'")
	end
end

--[[
	Path: String that is a path. Example: "Workspace.Part", "ReplicatedStorage.Remotes.RemoteName"
--]]
function Utility:WaitForPath(Path)
	local Found = game
	local Service = false
	for Step in string.gmatch(Path, "[^.^]+") do
		if not Service then
			Service = true
			Found = game:GetService(Step)
		elseif Found:FindFirstChild(Step) then
			Found = Found[Step]
		else
			local FoundIt = false
			while RunService.Stepped:Wait() and not FoundIt do
				if Found:FindFirstChild(Step) then
					Found = Found[Step]
					FoundIt = true
				end
			end
		end
	end
	return Found
end

--[[
	Goto: A Vector3 or CFrame value.
--]]
function Utility:TeleportTo(Goto)
	local LocalPlayer = Players.LocalPlayer
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local RootPart = Character:WaitForChild("HumanoidRootPart")
	local Humanoid = Character:WaitForChild("Humanoid")

	if Humanoid then
		repeat RunService.Stepped:Wait()
			Humanoid.Jump = true
		until Humanoid:GetState() ~= Enum.HumanoidStateType.Seated
	end

	if RootPart then
		if typeof(Goto) == "Vector3" then
			RootPart.Position = Goto
		elseif typeof(Goto) == "CFrame" then
			RootPart.CFrame = Goto
		else
			warn("Utility:TeleportTo(Goto) didn't get a proper value. It got '"..tostring(Goto).."'")
		end
	end
end

return Utility