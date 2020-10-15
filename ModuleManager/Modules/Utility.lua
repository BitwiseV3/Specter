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

return Utility