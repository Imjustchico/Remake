local DS_Slot = game:GetService("DataStoreService"):GetDataStore("PlayerSlotDataNew1"..game.ReplicatedStorage.GameSettings.ExperimentNumber.Value)

local loaded = {}

local function NewValue(Type, Name, Value, To)
	local CreateValue = Instance.new(Type, To)
	CreateValue.Name = Name
	CreateValue.Value = Value
	return CreateValue
end

function onPlayerEntered(NewPlayer)
	local UserSlot = Instance.new("Folder")
	UserSlot.Name = "UserSlot"

	--Main Data
	local Slot1 = NewValue("BoolValue", "Slot1", false, UserSlot)
	local Slot2 = NewValue("BoolValue", "Slot2", false, UserSlot)
	local Slot3 = NewValue("BoolValue", "Slot3", false, UserSlot)
	local Slot4 = NewValue("BoolValue", "Slot4", false, UserSlot)

	local NumberSlot = NewValue("IntValue", "NumberSlot", 1, UserSlot)

	local Attempt = 50
	local S, V

	repeat
		wait(0.05)
		S, V = pcall(DS_Slot.GetAsync, DS_Slot, NewPlayer.UserId)
		Attempt -= 1
	until S or Attempt <= 0

	if not S then 
		NewPlayer:Kick("DataStore failed to load after multiple attempts. Please try again later.") 
		return 
	end

	local DataStore = V or {}
	print(NewPlayer.Name.. " Slots Loaded", DataStore)
	loaded[tostring(NewPlayer).."Main_Slot"] = true

	local Table = {Slot1, Slot2, Slot3, Slot4, NumberSlot}

	-- Validate the loaded data
	if type(DataStore) == "table" and #DataStore == #Table then
		for i, v in pairs(DataStore) do
			Table[i].Value = v
		end
	else
		warn("Invalid data format for player:", NewPlayer.Name)
	end

	UserSlot.Parent = NewPlayer
end

function onPlayerLeave(PlrLeft)
	if loaded[tostring(PlrLeft).."Main_Slot"] == nil then return end
	local Data = PlrLeft:WaitForChild("UserSlot")
	local Table = {Data.Slot1.Value, Data.Slot2.Value, Data.Slot3.Value, Data.Slot4.Value, Data.NumberSlot.Value}
	local Attempt = 50

	repeat
		wait(0.05)
		local S, V = pcall(DS_Slot.SetAsync, DS_Slot, PlrLeft.UserId, Table)
		print(PlrLeft.Name.. " Slots Saved: ", Table)
		Attempt -= 1
	until S or Attempt <= 0

	loaded[tostring(PlrLeft).."Main_Slot"] = nil
end

local function ServerShutdown()
	while next(loaded) ~= nil do
		task.wait()
	end
end

game:BindToClose(ServerShutdown)
game.Players.PlayerAdded:Connect(onPlayerEntered)
game.Players.PlayerRemoving:Connect(onPlayerLeave)