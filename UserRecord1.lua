local loaded = {}
local NumberData = 1
local ExperimentNumber = game.ReplicatedStorage.GameSettings.ExperimentNumber.Value

local function NewValue(Type, Name, Value, To)
	local CreateValue = Instance.new(Type, To)
	CreateValue.Name = Name
	CreateValue.Value = Value
	return CreateValue
end

function onPlayerEntered(NewPlayer)
	repeat
		wait()
	until NewPlayer:FindFirstChild("UserSlot")

	local UserSlot = NewPlayer:FindFirstChild("UserSlot")

	repeat
		wait()
	until NewPlayer:FindFirstChild("UserSlot")["Slot"..NumberData].Value == true

	local DS_Record = game:GetService("DataStoreService"):GetDataStore("PlayerRecordNew1".. ExperimentNumber + NumberData)

	local UserRecord = Instance.new("Folder")
	UserRecord.Name = "UserRecord"..NumberData

	-- Creating stats for the player (added indentation for clarity)
	local Wild_Rabbit = NewValue("IntValue", "Wild Rabbit", 0, UserRecord)
	local Demon_Boar = NewValue("IntValue", "Demon Boar", 0, UserRecord)
	local Bandit = NewValue("IntValue", "Bandit", 0, UserRecord)
	local LaoHu = NewValue("IntValue", "Lao Hu", 0, UserRecord)
	local Expert_Bandit = NewValue("IntValue", "Expert Bandit", 0, UserRecord)
	local XiaoJin = NewValue("IntValue", "Xiao Jin", 0, UserRecord)
	local Elite_Bandit = NewValue("IntValue", "Elite Bandit", 0, UserRecord)
	local MingLian = NewValue("IntValue", "Ming Lian", 0, UserRecord)
	local Steel_Titan_Bandit = NewValue("IntValue", "Steel Titan Bandit", 0, UserRecord)
	local ChenLong = NewValue("IntValue", "Chen Long", 0, UserRecord)
	local Dragon_Bandit = NewValue("IntValue", "Dragon Bandit", 0, UserRecord)
	local Jinlong = NewValue("IntValue", "Jinlong", 0, UserRecord)
	local Training_Dummy = NewValue("IntValue", "Training Dummy", 0, UserRecord)
	local Harvested = NewValue("IntValue", "Harvested", 0, UserRecord)
	local NPCKills = NewValue("IntValue", "NPCKills", 0, UserRecord)
	local PlayerKills = NewValue("IntValue", "PlayerKills", 0, UserRecord)
	local BladeHit = NewValue("IntValue", "BladeHit", 0, UserRecord)
	local HandHit = NewValue("IntValue", "HandHit", 0, UserRecord)
	local HitBlocked = NewValue("IntValue", "HitBlocked", 0, UserRecord)
	local Ragdolled = NewValue("IntValue", "Ragdolled", 0, UserRecord)
	local Stunned = NewValue("IntValue", "Stunned", 0, UserRecord)
	local Hitted = NewValue("IntValue", "Hitted", 0, UserRecord)
	local Walked = NewValue("IntValue", "Walked", 0, UserRecord)
	local Jumped = NewValue("IntValue", "Jumped", 0, UserRecord)
	local SaberAttack = NewValue("IntValue", "SaberAttack", 0, UserRecord)
	local LongBowAttack = NewValue("IntValue", "LongBowAttack", 0, UserRecord)
	local SpearAttack = NewValue("IntValue", "SpearAttack", 0, UserRecord)
	local BareHandAttack = NewValue("IntValue", "BareHandAttack", 0, UserRecord)
	local TwoSaberAttack = NewValue("IntValue", "TwoSaberAttack", 0, UserRecord)
	local Goblin = NewValue("IntValue", "Goblin", 0, UserRecord)
	local Goblin_Champion = NewValue("IntValue", "Goblin Champion", 0, UserRecord)
	local Wolf = NewValue("IntValue", "Wolf", 0, UserRecord)
	local Werewolf = NewValue("IntValue", "Werewolf", 0, UserRecord)
	local Undead = NewValue("IntValue", "Undead", 0, UserRecord)
	local Necromancer = NewValue("IntValue", "Necromancer", 0, UserRecord)
	local Meditation = NewValue("IntValue", "Meditation", 0, UserRecord)
	local SwordFlying = NewValue("IntValue", "SwordFlying", 0, UserRecord)
	local CreatureRiding = NewValue("IntValue", "CreatureRiding", 0, UserRecord)
	local MonsterTame = NewValue("IntValue", "MonsterTame", 0, UserRecord)
	local MonsterSummoned = NewValue("IntValue", "MonsterSummoned", 0, UserRecord)
	local NPCTalked = NewValue("IntValue", "NPCTalked", 0, UserRecord)
	local QuestCompleted = NewValue("IntValue", "QuestCompleted", 0, UserRecord)
	local BlackSmithExp = NewValue("IntValue", "BlackSmithExp", 0, UserRecord)
	local RefineExp = NewValue("IntValue", "RefineExp", 0, UserRecord)
	local HammerAttack = NewValue("IntValue", "HammerAttack", 0, UserRecord)
	local MeleeStaff = NewValue("IntValue", "MeleeStaff", 0, UserRecord)

	-- Attempt to load data from DataStore
	local Attempt = 10
	local S, V

	repeat
		wait(0.05)
		S, V = pcall(DS_Record.GetAsync, DS_Record, NewPlayer.UserId) -- Changed `userId` to `UserId`
		Attempt -= 1
	until S or Attempt <= 0

	if not S then -- Changed `S == false` to `not S`
		NewPlayer:Kick("DataStore failed to load (Failed To Load Data)")
		return 
	end

	local DataStore = V or {}
	print(NewPlayer.Name.. " Record Loaded", DataStore)
	loaded[tostring(NewPlayer).."Record"] = true

	-- Collect all stat values into a table for easy loading
	local Table = {
		Wild_Rabbit, Demon_Boar, Bandit, LaoHu, Expert_Bandit, XiaoJin, Elite_Bandit, MingLian,
		Steel_Titan_Bandit, ChenLong, Dragon_Bandit, Jinlong, Training_Dummy, Harvested,
		NPCKills, PlayerKills, BladeHit, HandHit, HitBlocked, Ragdolled, Stunned, Walked,
		Hitted, SaberAttack, LongBowAttack, SpearAttack, BareHandAttack, TwoSaberAttack,
		Goblin, Goblin_Champion, Wolf, Werewolf, Undead, Necromancer, Meditation, SwordFlying,
		CreatureRiding, MonsterTame, MonsterSummoned, NPCTalked, QuestCompleted, BlackSmithExp,
		RefineExp, HammerAttack, MeleeStaff
	}

	-- Load the data into the respective values
	if DataStore then
		for i, v in pairs(DataStore) do
			if Table[i] then
				Table[i].Value = v -- Only load data if it exists in the table
			end
		end
	else
		return 0
	end

	UserRecord.Parent = NewPlayer
end

local function ServerShutdown()
	while next(loaded) ~= nil do
		task.wait()
	end
end

game:BindToClose(ServerShutdown)
game.Players.PlayerAdded:Connect(onPlayerEntered) -- Changed `:connect()` to `:Connect()`
