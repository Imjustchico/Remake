local loaded = {}
local NumberData = 1
local ExperimentNumber = game.ReplicatedStorage.GameSettings.ExperimentNumber.Value
local RealmInfo = game.ReplicatedStorage.Realm
local DaoInfo = game.ReplicatedStorage.DaoPath

local UserKillAchievement = {}

local function NewValue(Type, Name, Value, To)
	local CreateValue = Instance.new(Type, To)
	CreateValue.Name = Name
	CreateValue.Value = Value
	return CreateValue
end

local StatsMultiplier = {
	["Common"] = 1,
	["Uncommon"] = 2,
	["Rare"] = 4,
	["Unique"] = 8,
	["Legendary"] = 12,
	["Mythical"] = 20
}

function onPlayerEntered(NewPlayer)
	repeat
		wait()
	until NewPlayer:FindFirstChild("UserSlot")

	local IsChanged = false

	NewPlayer:FindFirstChild("UserSlot")["Slot"..NumberData].Changed:Once(function()
		IsChanged = true
	end)

	repeat
		wait()
	until NewPlayer:FindFirstChild("UserSlot")["Slot"..NumberData].Value == true

	-- DataStores for Main, Murim, and Magic data
	local DS_Main = game:GetService("DataStoreService"):GetDataStore("PlayerMainDataNew1".. NumberData + ExperimentNumber)
	local DS_Murim = game:GetService("DataStoreService"):GetDataStore("PlayerMurimDataNew1".. NumberData + ExperimentNumber)
	local DS_Magic = game:GetService("DataStoreService"):GetDataStore("PlayerMagicDataNew1".. NumberData + ExperimentNumber)
	local DS_Dragon = game:GetService("DataStoreService"):GetDataStore("PlayerDragonDataNew1".. NumberData + ExperimentNumber)

	repeat wait() until game.ReplicatedStorage.PlayerAchievement:FindFirstChild(NewPlayer.Name..NumberData)

	local UserAchievement = game.ReplicatedStorage.PlayerAchievement:FindFirstChild(NewPlayer.Name..NumberData)

	for _, Achievement in pairs(UserAchievement:GetChildren()) do
		if Achievement.AchievementInfo.Value ~= nil and Achievement.AchievementInfo.Value.Type.Value == "Kill" then
			table.insert(UserKillAchievement, Achievement)
		end
	end

	local UserData = Instance.new("Folder")
	UserData.Name = "UserData"..NumberData

	-- Main Data
	local Talent = NewValue("IntValue", "Talent", 1, UserData)
	local Adaptive = NewValue("IntValue", "Adaptive", 1, UserData)
	local Social = NewValue("IntValue", "Social", 1, UserData)
	local Control = NewValue("IntValue", "Control", 1, UserData)
	local Endurance = NewValue("IntValue", "Endurance", 1, UserData)

	local SkillsDown = NewValue("BoolValue", "SkillsDown", false, UserData)
	local WeatherState = NewValue("BoolValue", "WeatherState", true, UserData)
	local allowMusic = NewValue("BoolValue", "allowMusic", true, UserData)

	-- Temporary Data
	local System = NewValue("StringValue", "System", "Murim", UserData)
	local Aura = NewValue("StringValue", "Aura", "", UserData)
	local World = NewValue("StringValue", "World", "Murim World", UserData)

	-- Stamina
	local Energy = NewValue("IntValue", "Energy", 100, UserData)
	local MaxEnergy = NewValue("IntValue", "MaxEnergy", 100, UserData)

	local Attempt = 10
	local S, V

	repeat
		wait(0.05)
		S, V = pcall(DS_Main.GetAsync, DS_Main, NewPlayer.UserId) -- Fixed userId to UserId
		Attempt -= 1
	until S or Attempt <= 0

	if not S then
		NewPlayer:Kick("DataStore failed to load (Failed To Load Data)")
		return
	end

	local DataStore = V or {}
	print(NewPlayer.Name.. " Status Loaded", DataStore)
	loaded[tostring(NewPlayer).."Main_Data"] = true

	-- Collect all main data values
	local Table = {Talent, Adaptive, Control, Endurance, Social, World, System, SkillsDown, Aura, WeatherState, allowMusic}

	if DataStore then
		for i, v in pairs(DataStore) do
			Table[i].Value = v
		end
	else
		return 0
	end

	UserData.Parent = NewPlayer

	if IsChanged then
		repeat wait() until NewPlayer:FindFirstChild("SystemChanged")
	end

	-- User temporary data
	local UserTempData = Instance.new("Folder")
	UserTempData.Name = "UserTempData"..NumberData

	local Money = NewValue("NumberValue", "Money", 0, UserTempData)
	local Lifespan = NewValue("NumberValue", "Lifespan", math.random(3, 21), UserTempData)
	local SuccessRate = NewValue("IntValue", "SuccessRate", 0, UserTempData)

	local Title = NewValue("StringValue", "Title", "", UserTempData)
	local Trait = NewValue("StringValue", "Trait", "", UserTempData)

	local Head = NewValue("ObjectValue", "Head", nil, UserTempData)
	local Chest = NewValue("ObjectValue", "Chest", nil, UserTempData)
	local Pants = NewValue("ObjectValue", "Pants", nil, UserTempData)
	local Boots = NewValue("ObjectValue", "Boots", nil, UserTempData)
	local LeftArm = NewValue("ObjectValue", "LeftArm", nil, UserTempData)
	local RightArm = NewValue("ObjectValue", "RightArm", nil, UserTempData)

	local Animation = NewValue("StringValue", "Animation", "BareHand", UserTempData)

	-- Check for Murim or Magic system and load data accordingly
	if System.Value == "Murim" then
		local Life_Essence = NewValue("NumberValue", "Life Essence", 10, UserTempData)
		local Strength = NewValue("NumberValue", "Strength", 5, UserTempData)
		local Soul_Power = NewValue("NumberValue", "Soul Power", 5, UserTempData)
		local Qi_Power = NewValue("NumberValue", "Qi Power", 5, UserTempData)
		local Agility = NewValue("NumberValue", "Agility", 5, UserTempData)
		local Dao_Path = NewValue("StringValue", "Dao Path", "Mortal Path", UserTempData)
		local Race = NewValue("StringValue", "Race", "Human", UserTempData)

		local Qi = NewValue("IntValue", "Qi", 0, UserTempData)
		local MaxQi = NewValue("IntValue", "MaxQi", 100, UserTempData)

		local Realm = NewValue("StringValue", "Realm", "Mortal", UserTempData)

		local Attempt = 5
		local S, V

		repeat
			wait(0.05)
			S, V = pcall(DS_Murim.GetAsync, DS_Murim, NewPlayer.UserId)
			Attempt -= 1
		until S or Attempt <= 0

		if not S then
			NewPlayer:Kick("DS_Murim failed to load (Failed To Load Data)")
			return
		end

		local DataStore = V or {}
		print(NewPlayer.Name.. " Status Murim Loaded", DataStore)
		loaded[tostring(NewPlayer).."Murim_Data"] = true

		local Table = {Money, Animation, Qi, MaxQi, Realm, Race, Title, Dao_Path, Lifespan, Trait}

		if DataStore then
			for i, v in pairs(DataStore) do
				Table[i].Value = v
			end
		else
			return 0
		end

		if Dao_Path.Value == "Spear Parth" then
			Dao_Path.Value = "Spear Path"
		end
	elseif System.Value == "Magic" then
		local Magic_Endurance = NewValue("NumberValue", "Magic Endurance", 10, UserTempData)
		local Magic_Melee = NewValue("NumberValue", "Magic Melee", 5, UserTempData)
		local Magic_Power = NewValue("NumberValue", "Magic Power", 5, UserTempData)
		local Mental_Power = NewValue("NumberValue", "Mental Power", 5, UserTempData)
		local Magic_Agility = NewValue("NumberValue", "Magic Agility", 5, UserTempData)
		local Class = NewValue("StringValue", "Class", "Classless", UserTempData)
		local Race = NewValue("StringValue", "Race", "Human", UserTempData)

		local Exp = NewValue("IntValue", "Exp", 0, UserTempData)
		local MaxExp = NewValue("IntValue", "MaxExp", 100, UserTempData)

		local Level = NewValue("IntValue", "Level", 1, UserTempData)

		local Attempt = 5
		local S, V

		repeat
			wait(0.05)
			S, V = pcall(DS_Magic.GetAsync, DS_Magic, NewPlayer.UserId)
			Attempt -= 1
		until S or Attempt <= 0

		if not S then
			NewPlayer:Kick("DS_Magic failed to load (Failed To Load Data)")
			return
		end

		local DataStore = V or {}
		print(NewPlayer.Name.. " Status Magic Loaded", DataStore)
		loaded[tostring(NewPlayer).."Magic_Data"] = true

		local Table = {Money, Animation, Exp, MaxExp, Level, Race, Title, Class, Lifespan, Trait}

		if DataStore then
			for i, v in pairs(DataStore) do
				Table[i].Value = v
			end
		else
			return 0
		end
	elseif System.Value == "Dragon" then
	local Dragon_Endurance = NewValue("NumberValue", "Dragon Endurance", 10, UserTempData)
	local Dragon_Melee = NewValue("NumberValue", "Dragon Melee", 5, UserTempData)
	local Dragon_Power = NewValue("NumberValue", "Dragon Power", 5, UserTempData)
	local Mental_Power = NewValue("NumberValue", "Mental Power", 5, UserTempData)
	local Dragon_Agility = NewValue("NumberValue", "Dragon Agility", 5, UserTempData)
	local Class = NewValue("StringValue", "Class", "Classless", UserTempData)
	local Race = NewValue("StringValue", "Race", "Human", UserTempData)

	local Exp = NewValue("IntValue", "Exp", 0, UserTempData)
	local MaxExp = NewValue("IntValue", "MaxExp", 100, UserTempData)

	local Level = NewValue("IntValue", "Level", 1, UserTempData)

	local Attempt = 5
	local S, V

	repeat
		wait(0.05)
		S, V = pcall(DS_Dragon.GetAsync, DS_Dragon, NewPlayer.UserId)
		Attempt -= 1
	until S or Attempt <= 0

	if not S then
		NewPlayer:Kick("DS_Dragon failed to load (Failed To Load Data)")
		return
	end

	local DataStore = V or {}
	print(NewPlayer.Name.. " Status Dragon Loaded", DataStore)
	loaded[tostring(NewPlayer).."Dragon_Data"] = true

	local Table = {Money, Animation, Exp, MaxExp, Level, Race, Title, Class, Lifespan, Trait}

	if DataStore then
		for i, v in pairs(DataStore) do
			Table[i].Value = v
		end
	else
		return 0
	end
end

	UserTempData.Parent = NewPlayer
end

function onPlayerLeave(PlrLeft)
	repeat wait() until PlrLeft:FindFirstChild("UserSlot")

	local UserSlot = PlrLeft:FindFirstChild("UserSlot")
	local DS_Main = game:GetService("DataStoreService"):GetDataStore("PlayerMainDataNew1".. NumberData + ExperimentNumber)
	local DS_Murim = game:GetService("DataStoreService"):GetDataStore("PlayerMurimDataNew1".. NumberData + ExperimentNumber)
	local DS_Magic = game:GetService("DataStoreService"):GetDataStore("PlayerMagicDataNew1".. NumberData + ExperimentNumber)
	local DS_Dragon = game:GetService("DataStoreService"):GetDataStore("PlayerDragonDataNew1".. NumberData + ExperimentNumber)

	-- Save Main Data
	if loaded[tostring(PlrLeft).."Main_Data"] == nil then return end
	local Data = PlrLeft:WaitForChild("UserData"..NumberData)
	local MainTable = {
		Data.Talent.Value, Data.Adaptive.Value, Data.Control.Value, Data.Endurance.Value,
		Data.Social.Value, Data.World.Value, Data.System.Value, Data.SkillsDown.Value,
		Data.Aura.Value, Data.WeatherState.Value, Data.allowMusic.Value
	}

	local Attempt = 5
	repeat
		wait(0.05)
		local success, err = pcall(DS_Main.SetAsync, DS_Main, PlrLeft.UserId, MainTable)
		print(PlrLeft.Name.. " Status Saved: ", MainTable)
		Attempt -= 1
	until success or Attempt <= 0

	loaded[tostring(PlrLeft).."Main_Data"] = nil

	local system = Data.System.Value

	if system == "Murim" then
		if loaded[tostring(PlrLeft).."Murim_Data"] == nil then return end
		local TempData = PlrLeft:WaitForChild("UserTempData"..NumberData)
		local MurimTable = {
			TempData.Money.Value, TempData.Animation.Value, TempData.Qi.Value, TempData.MaxQi.Value, TempData.Realm.Value,
			TempData.Race.Value, TempData.Title.Value, TempData["Dao Path"].Value, TempData.Lifespan.Value, TempData.Trait.Value
		}

		local Attempt = 5
		repeat
			wait(0.05)
			local success, err = pcall(DS_Murim.SetAsync, DS_Murim, PlrLeft.UserId, MurimTable)
			print(PlrLeft.Name.. " Murim Saved: ", MurimTable)
			Attempt -= 1
		until success or Attempt <= 0

		loaded[tostring(PlrLeft).."Murim_Data"] = nil

	elseif system == "Magic" then
		if loaded[tostring(PlrLeft).."Magic_Data"] == nil then return end
		local TempData = PlrLeft:WaitForChild("UserTempData"..NumberData)
		local MagicTable = {
			TempData.Money.Value, TempData.Animation.Value, TempData.Exp.Value, TempData.MaxExp.Value, TempData.Level.Value,
			TempData.Race.Value, TempData.Title.Value, TempData.Class.Value, TempData.Lifespan.Value, TempData.Trait.Value
		}

		local Attempt = 5
		repeat
			wait(0.05)
			local success, err = pcall(DS_Magic.SetAsync, DS_Magic, PlrLeft.UserId, MagicTable)
			print(PlrLeft.Name.. " Magic Saved: ", MagicTable)
			Attempt -= 1
		until success or Attempt <= 0

		loaded[tostring(PlrLeft).."Magic_Data"] = nil

	elseif system == "Dragon" then
		if loaded[tostring(PlrLeft).."Dragon_Data"] == nil then return end
		local TempData = PlrLeft:WaitForChild("UserTempData"..NumberData)
		local DragonTable = {
			TempData.Money.Value, TempData.Animation.Value, TempData.Exp.Value, TempData.MaxExp.Value, TempData.Level.Value,
			TempData.Race.Value, TempData.Title.Value, TempData.Class.Value, TempData.Lifespan.Value, TempData.Trait.Value
		}

		local Attempt = 5
		repeat
			wait(0.05)
			local success, err = pcall(DS_Dragon.SetAsync, DS_Dragon, PlrLeft.UserId, DragonTable)
			print(PlrLeft.Name.. " Dragon Saved: ", DragonTable)
			Attempt -= 1
		until success or Attempt <= 0

		loaded[tostring(PlrLeft).."Dragon_Data"] = nil
	end
end

local function ServerShutdown()
	while next(loaded) ~= nil do
		task.wait()
	end
end

game:BindToClose(ServerShutdown)
game.Players.PlayerAdded:Connect(onPlayerEntered)
game.Players.PlayerRemoving:Connect(onPlayerLeave)
