local RunService = game:GetService("RunService")
local NumberData = 1
local ExperimentNumber = game.ReplicatedStorage.GameSettings.ExperimentNumber.Value

local function updateCurrency(Money)
	local Bronze, Silver, Gold = 0, 0, 0

	Gold = math.floor(Money / 1000000)
	Money = Money % 1000000

	Silver = math.floor(Money / 1000)
	Money = Money % 1000

	Bronze = Money

	return Bronze, Silver, Gold
end

local loaded = {}

function onPlayerEntered(newPlayer)
	repeat
		wait()
	until newPlayer:FindFirstChild("UserSlot")

	local UserSlot = newPlayer:FindFirstChild("UserSlot")

	local DS_Achievement = game:GetService("DataStoreService"):GetDataStore("PlayerAchievementNew1".. ExperimentNumber+NumberData)

	local NewAchievementList = Instance.new("Folder")
	NewAchievementList.Name = newPlayer.Name.. NumberData

	repeat
		wait()
	until newPlayer:FindFirstChild("UserRecord"..NumberData)

	local UserRecord = newPlayer:FindFirstChild("UserRecord"..NumberData)

	repeat
		wait()
	until newPlayer.Character ~= nil

	local Char = newPlayer.Character

	local Attempt = 5
	local S, V

	repeat
		wait(0.05)
		S, V = pcall(DS_Achievement.GetAsync, DS_Achievement, newPlayer.UserId)
		Attempt -= 1
	until S or Attempt <= 0

	if not S then
		newPlayer:Kick("DataStore failed to load Achievement")
		return 
	end

	local DataStore = V or {}
	print(newPlayer.Name.. " Achievement Loaded", DataStore)
	loaded[newPlayer] = true

	for i, v in pairs(DataStore) do
		if game.ReplicatedStorage.AchievementInfo:FindFirstChild(v["Name"]) then
			local Info = game.ReplicatedStorage.AchievementInfo:FindFirstChild(v["Name"])

			local NewFolder = game.ReplicatedStorage.Folders.AchievementFolder:Clone()
			NewFolder.Name = v["Name"]
			NewFolder.Rarity.Value = v["Rarity"]
			NewFolder.AchievementInfo.Value = Info
			NewFolder.Parent = NewAchievementList
		end
	end

	NewAchievementList.Parent = game.ReplicatedStorage.PlayerAchievement
end

local function ServerShutdown()
	while next(loaded) ~= nil do
		task.wait()
	end
end

game:BindToClose(ServerShutdown)
game.Players.PlayerAdded:Connect(onPlayerEntered)
