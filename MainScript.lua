script.Parent.Title.Position = UDim2.new(0.5, 0, 0.2, 0)
script.Parent.VersionLabel.Position = UDim2.new(0.05, 0, 0.95, 0)
script.Parent.Reminder.Position = UDim2.new(0.35, 0, 0.6, 0)
script.Parent.CharacterSelection.Characters.Position = UDim2.new(-0.2, 0, 0.25, 0)
script.Parent.CharacterSelection.PlayDesk.Main.Position = UDim2.new(-1, 0, 0, 0)
game.Lighting.Blur.Size = 15

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local RemoteFolder = ReplicatedStorage:WaitForChild("Remotes")
local KeysEvent = RemoteFolder:WaitForChild("Keys")
local TeleportRequestEvent = RemoteFolder:WaitForChild("TeleportRequest")

local Plr = Players.LocalPlayer
local db = false
local CharacterSelection = script.Parent:WaitForChild("CharacterSelection")
local Slots = CharacterSelection.Characters

local i = 1

local LoadingEvent = RunService.Heartbeat:Connect(function()
	if db == false then
		db = true

		delay(0.25, function()
			db = false
		end)

		if i == 1 then
			script.Parent.Reminder.Text = "Loading Data's."
		elseif i == 2 then
			script.Parent.Reminder.Text = "Loading Data's.."
		elseif i >= 3 then
			script.Parent.Reminder.Text = "Loading Data's..."
			i = 0
		end

		i += 1
	end
end)

Plr:WaitForChild("UserSlot")

local UserSlot = Plr:WaitForChild("UserSlot")

if UserSlot.Slot1.Value == true then
	repeat wait() until Plr:FindFirstChild("UserData1") and game.ReplicatedStorage.PlayerAchievement:FindFirstChild(Plr.Name .. "1") and Plr:FindFirstChild("UserRecord1")
end
if UserSlot.Slot2.Value == true then
	repeat wait() until Plr:FindFirstChild("UserData2") and game.ReplicatedStorage.PlayerAchievement:FindFirstChild(Plr.Name .. "2") and Plr:FindFirstChild("UserRecord2")
end
if UserSlot.Slot3.Value == true then
	repeat wait() until Plr:FindFirstChild("UserData3") and game.ReplicatedStorage.PlayerAchievement:FindFirstChild(Plr.Name .. "3") and Plr:FindFirstChild("UserRecord3")
end
if UserSlot.Slot4.Value == true then
	repeat wait() until Plr:FindFirstChild("UserData4") and game.ReplicatedStorage.PlayerAchievement:FindFirstChild(Plr.Name .. "4") and Plr:FindFirstChild("UserRecord4")
end

if LoadingEvent then
	LoadingEvent:Disconnect()
	LoadingEvent = nil
end

script.Parent.Reminder.Text = "Press any Key to continue"

local GamePass = {
	["Additional Slot"] = 1078410490,
	["+Additional Slot"] = 1077854068
}


local SystemPathReference = {
	["Magic"] = "Class",
	["Murim"] = "Dao Path",
	["Dragon"] = "Class"
}

local SystemWorldReference = {
	["Magic"] = "Magic World",
	["Murim"] = "Murim World",
	["Dragon"] = "Dragon World"
}

local function Shake(Camera, Strength, Length)
	local OriginalPos = Camera.Position

	for i = 1, Length do
		delay(0.05 * i, function()
			local Goal = {}
			Goal.Position = OriginalPos + Vector3.new(math.random(-100 * Strength, 100 * Strength) / 100, math.random(-100 * Strength, 100 * Strength) / 100, math.random(-100 * Strength, 100 * Strength) / 100)
			local Info = TweenInfo.new(0.05)
			local Tween = TweenService:Create(Camera, Info, Goal)
			Tween:Play()
		end)
	end
	delay(0.05 * Length, function()
		local Goal = {}
		Goal.Position = OriginalPos
		local Info = TweenInfo.new(0.05)
		local Tween = TweenService:Create(Camera, Info, Goal)
		Tween:Play()
	end)
end

local function SpinPortal()
	for _, Wave in pairs(workspace.Portal:GetChildren()) do
		if Wave.Name == "Wave" then
			RunService.Heartbeat:Connect(function()
				Wave.Orientation = Wave.Orientation + Vector3.new(0, 0, -1)
			end)
		end
	end
end

local function TeleportEffect(UserData)
	if UserSlot.Slot1.Value == false then
		return
	end

	script.Parent.CharacterSelection.Characters:TweenPosition(UDim2.new(-0.2, 0, 0.25, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.5)
	script.Parent.CharacterSelection.PlayDesk.Main:TweenPosition(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)

	local Goal = {}
	Goal.Transparency = 0
	local Info = TweenInfo.new(1)
	local Tween = TweenService:Create(script.Parent:WaitForChild("BlankFrame"), Info, Goal)
	Tween:Play()

	if not UserData then
		UserData = Plr:FindFirstChild("UserData" .. UserSlot.NumberSlot.Value)
	end

	if not UserData then
		return
	end

	local CreatePlanet = game.ReplicatedStorage.Planets:FindFirstChild(UserData.World.Value)

	if not CreatePlanet then
		return
	end

	CreatePlanet = CreatePlanet:Clone()
	CreatePlanet.Parent = workspace.PlanetPosition

	-- CFrame Lerp (Interpolate over time)
	local startCFrame = CreatePlanet.Center.CFrame
	local endCFrame = workspace.PlanetPosition.CFrame
	local duration = 1 -- Time to transition

	local startTime = tick()
	while tick() - startTime < duration do
		local alpha = (tick() - startTime) / duration
		CreatePlanet.Center.CFrame = startCFrame:Lerp(endCFrame, alpha)
		wait()
	end
	CreatePlanet.Center.CFrame = endCFrame -- Ensuring final position is set after the lerp

	delay(0.7, function()
		for _, Sound in pairs(game.Workspace.Sound:GetDescendants()) do
			if Sound:IsA("Sound") then
				Sound:Stop()
			end
		end

		for _, Graphics in pairs(game.Lighting:GetChildren()) do
			Graphics:Destroy()
		end

		for _, Graphics in pairs(game.ReplicatedStorage.Graphics["Starting World"]:GetChildren()) do
			local Clone = Graphics:Clone()
			Clone.Parent = game.Lighting
		end

		for _, BasePart in pairs(game.Workspace.Room1:GetDescendants()) do
			if BasePart:IsA("BasePart") then
				BasePart.Transparency = 1
			elseif BasePart:IsA("Beam") then
				BasePart.Enabled = false
			end
		end
	end)
end


local RatingColor = {
	["Common"] = Color3.fromRGB(255, 255, 255),
	["Uncommon"] = Color3.fromRGB(0, 255, 0),
	["Rare"] = Color3.fromRGB(0, 85, 255),
	["Unique"] = Color3.fromRGB(255, 170, 0),
	["Legendary"] = Color3.fromRGB(255, 0, 0),
	["Mythical"] = Color3.fromRGB(170, 85, 255)
}

local RARITY_CHANCES = {
	["Common"]    = 55,
	["Uncommon"]  = 25,
	["Rare"]      = 12,
	["Unique"]    = 6,
	["Legendary"] = 1.8,
	["Mythical"]  = 0.2,
}

-- Utility: roll a rarity based on RARITY_CHANCES (ignores rarities with no available traits)
local function rollRarity(availableCounts)
	-- Build a filtered list of {rarity, weight} where at least 1 trait of that rarity is available
	local entries, total = {}, 0
	for rarity, weight in pairs(RARITY_CHANCES) do
		if (availableCounts[rarity] or 0) > 0 and weight > 0 then
			table.insert(entries, {rarity = rarity, w = weight})
			total += weight
		end
	end
	if total <= 0 then return nil end

	-- Weighted pick
	local r, acc = math.random() * total, 0
	for _, e in ipairs(entries) do
		acc += e.w
		if r <= acc then
			return e.rarity
		end
	end
	return entries[#entries].rarity
end

-- Utility: build a table of traits grouped by rarity, excluding any already chosen
local function groupTraitsByRarity(traitFolder, excludeSet)
	local groups, counts = {}, {}
	for _, t in ipairs(traitFolder:GetChildren()) do
		if t:IsA("Folder") or t:IsA("Model") or t:IsA("Configuration") or t:IsA("Folder") then
			-- skip non-trait containers just in case
		end
		if t and t:FindFirstChild("Rarity") and t:FindFirstChild("Description") then
			if not excludeSet[t.Name] then
				local r = t.Rarity.Value
				groups[r] = groups[r] or {}
				table.insert(groups[r], t)
				counts[r] = (counts[r] or 0) + 1
			end
		end
	end
	return groups, counts
end

-- Utility: pick 1 trait uniformly within a chosen rarity
local function pickTraitInRarity(groups, rarity)
	local list = groups[rarity]
	if not list or #list == 0 then return nil end
	return list[math.random(1, #list)]
end

local function StartSelectionTrait(UserData, UserTempData)
	local gui = Plr.PlayerGui.ScreenGui.CharacterCreation.TraitSelection
	gui.Visible = true
	gui.Continue.Visible = false

	local chosenCount, totalToChoose = 0, 3
	local chosenTraits = {}
	local excludeSet = {}

	for i = 1, totalToChoose do
		local uiObj = workspace["Trait" .. i].UI
		local PPos = uiObj.Position
		uiObj.Position += Vector3.new(0, 200, 0)

		delay(2, function()
			script.Portal:Stop()
			script.Portal:Play()

			TweenService:Create(uiObj, TweenInfo.new(1), { Position = PPos }):Play()

			local beam = workspace["Trait" .. i].Effect.Beam
			beam.Enabled = true
			beam.Width0, beam.Width1 = 0, 0
			TweenService:Create(beam, TweenInfo.new(0.5), { Width0 = 90, Width1 = 90 }):Play()
			delay(1, function()
				TweenService:Create(beam, TweenInfo.new(0.2), { Width0 = 0, Width1 = 0 }):Play()
				delay(0.3, function() beam.Enabled = false end)
			end)
		end)

		-- === RARITY ROLL ===
		local traitFolder = game.ReplicatedStorage:WaitForChild("TraitInfo")
		local byRarity, counts = groupTraitsByRarity(traitFolder, excludeSet)

		local rolledRarity = rollRarity(counts)
		if not rolledRarity or not byRarity[rolledRarity] or #byRarity[rolledRarity] == 0 then
			for _, r in ipairs({ "Mythical", "Legendary", "Unique", "Rare", "Uncommon", "Common" }) do
				if byRarity[r] and #byRarity[r] > 0 then
					rolledRarity = r
					break
				end
			end
		end

		local TraitTarget = pickTraitInRarity(byRarity, rolledRarity)
		if not TraitTarget then continue end
		excludeSet[TraitTarget.Name] = true

		local rarity = TraitTarget.Rarity.Value
		local Color = RatingColor[rarity] or Color3.fromRGB(255,255,255)
		local R, G, B = math.round(Color.R * 255), math.round(Color.G * 255), math.round(Color.B * 255)

		-- === Apply visual design ===
		uiObj.UI.MainStatus.TitleLabel.Text = string.format('<font color="rgb(%d,%d,%d)">%s</font> - %s', R, G, B, rarity, TraitTarget.Name)
		uiObj.UI.MainStatus.DescriptionLabel.Text = TraitTarget.Description.Value
		uiObj.UI.MainStatus.BackgroundColor3 = Color3.fromRGB(R, G, B)

		-- Border stroke that matches rarity
		local stroke = uiObj.UI.MainStatus:FindFirstChild("UIStroke") or Instance.new("UIStroke")
		stroke.Thickness = 2
		stroke.Color = Color3.fromRGB(R, G, B)
		stroke.Parent = uiObj.UI.MainStatus

		local originalSize = uiObj.Size
		local ClickDetector = Instance.new("ClickDetector")
		ClickDetector.MaxActivationDistance = 999
		ClickDetector.Parent = uiObj

		-- Hover FX
		ClickDetector.MouseHoverEnter:Connect(function()
			uiObj.Size *= 1.1
			script.Boop:Stop()
			script.Boop:Play()
		end)
		ClickDetector.MouseHoverLeave:Connect(function()
			uiObj.Size = originalSize
		end)

		-- Selection click
		ClickDetector.MouseClick:Connect(function()
			if ClickDetector.Parent == nil then return end
			script.Accept:Stop()
			script.Accept:Play()

			TweenService:Create(uiObj, TweenInfo.new(0.5), { Orientation = uiObj.Orientation + Vector3.new(0, 180, 0) }):Play()
			ClickDetector:Destroy()

			if not table.find(chosenTraits, TraitTarget.Name) then
				table.insert(chosenTraits, TraitTarget.Name)
				if UserTempData.Trait.Value == "" then
					UserTempData.Trait.Value = TraitTarget.Name
				else
					UserTempData.Trait.Value ..= ", " .. TraitTarget.Name
				end
				chosenCount += 1
			end

			-- === Lock styling (darker rarity color) ===
			local selColor = Color3.new(Color.R * 0.6, Color.G * 0.6, Color.B * 0.6)
			uiObj.UI.MainStatus.BackgroundColor3 = selColor
			if stroke then stroke.Color = selColor end

			uiObj.UI.MainStatus.TitleLabel.Text = "<b>" .. uiObj.UI.MainStatus.TitleLabel.Text .. "</b>"
			uiObj.UI.MainStatus.DescriptionLabel.Text = "<i>" .. uiObj.UI.MainStatus.DescriptionLabel.Text .. "</i>"

			-- After 3 picks, allow continue
			if chosenCount >= totalToChoose then
				task.wait(1)
				gui.Continue.Visible = true
				script.Accept:Play()

				gui.Continue.MouseButton1Click:Once(function()
					gui.Visible = false
					TeleportEffect(UserData)

                                    if UserData then
                                            local slotNumber = UserSlot.NumberSlot.Value
                                            if slotNumber > 0 then
                                                    TeleportRequestEvent:FireServer(slotNumber)
                                            else
                                                    warn("Invalid slot number for teleport request.")
                                            end
                                    end
				end)
			end
		end)
	end
end

local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local function SelectTrait(UserData, UserTempData)
	local ui = script.Parent
	local blankFrame = ui:WaitForChild("BlankFrame")
	local cameraView = Workspace:WaitForChild("CameraView")
	local traitSelection = Workspace:WaitForChild("TraitSelection")

	-- Reuse TweenInfo and goals instead of recreating them every time
	local fadeIn = TweenService:Create(blankFrame, TweenInfo.new(1), { Transparency = 0 })
	local fadeOut = TweenService:Create(blankFrame, TweenInfo.new(1), { Transparency = 1 })

	-- Fade to black
	fadeIn:Play()
	fadeIn.Completed:Wait()

	-- Camera transition (use pcall in case of nil references)
	task.spawn(function()
		if cameraView and traitSelection then
			cameraView.CFrame = traitSelection.CFrame
		end
	end)

	-- Fade back in
	fadeOut:Play()
	fadeOut.Completed:Wait()

	-- Start trait selection
	StartSelectionTrait(UserData, UserTempData)
end

local TweenService = game:GetService("TweenService")

local function SetPath(UserData, Path)
	local userTempData = Plr:FindFirstChild("UserTempData" .. UserSlot.NumberSlot.Value)
	if not userTempData then
		warn("[SetPath] UserTempData not found for player:", Plr.Name)
		return
	end

	local charCreationUI = script.Parent:FindFirstChild("CharacterCreation")
	if not charCreationUI or not charCreationUI:FindFirstChild("PathSelection") then
		warn("[SetPath] CharacterCreation or PathSelection UI missing.")
		return
	end

	local pathSelection = charCreationUI.PathSelection
	local systemKey = SystemPathReference[UserData.System.Value]
	if not systemKey then
		warn("[SetPath] Invalid system value:", UserData.System.Value)
		return
	end

	local systemValue = userTempData:FindFirstChild(systemKey)
	if not systemValue then
		warn("[SetPath] System path value not found in UserTempData:", systemKey)
		return
	end

	systemValue.Value = Path

	-- Smooth fade-out transition
	local fadeOutTween = TweenService:Create(pathSelection, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 1
	})

	fadeOutTween:Play()
	fadeOutTween.Completed:Wait()

	pathSelection.Visible = false
	pathSelection.Transparency = 0 -- reset for next time

	task.wait(0.5)
	SelectTrait(UserData, userTempData)
end

local function SetSystem(SlotNumber, System)
	script.Parent.CharacterCreation.SystemSelection.Visible = false
	repeat
		wait()
	until Plr:FindFirstChild("UserData" .. UserSlot.NumberSlot.Value)
	local UserData = Plr:FindFirstChild("UserData" .. UserSlot.NumberSlot.Value)
	if UserData then
		UserData.System.Value = System
		UserData.World.Value = SystemWorldReference[System]

		local Folder = Instance.new("Folder")
		Folder.Name = "SystemChanged"
		Folder.Parent = Plr

		delay(0.1, function()
			if Folder then
				Folder:Destroy()
			end
		end)
	end

	local betaRig = workspace:FindFirstChild("BetaRig") or workspace:WaitForChild("BetaRig", 5)
	if not betaRig then
		warn("BetaRig is missing; skipping system animation setup.")
		return
	end

	local humanoid = betaRig:FindFirstChild("Humanoid")
	local humanoid = workspace:FindFirstChild("BetaRig"):FindFirstChild("Humanoid")
	local animation = script:FindFirstChild("Animation")
	if humanoid and animation then
		humanoid:LoadAnimation(animation):Play()
	else
		warn("Humanoid or Animation is missing.")
	end

	delay(0.3, function()
		local CreateEffect = game.ReplicatedStorage.BlastEffect:Clone()
		local rightArm = betaRig:FindFirstChild("Right Arm")
		if rightArm then
			CreateEffect.CFrame = rightArm.CFrame
		else
			warn("BetaRig Right Arm is missing; skipping BlastEffect placement.")
		end
		CreateEffect.CFrame = workspace.BetaRig["Right Arm"].CFrame
		CreateEffect.Parent = workspace.IgnoreList

		delay(0.15, function()
			local Sound = script.Blast:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			delay(0.2 + Sound.TimeLength, function()
				if Sound then
					Sound:Destroy()
				end
			end)

			for _, Par in pairs(CreateEffect:GetDescendants()) do
				if Par:IsA("ParticleEmitter") then
					Par.Enabled = false
				end
			end
		end)

		delay(1, function()
			local Sound = script.Hit:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			delay(0.2 + Sound.TimeLength, function()
				if Sound then
					Sound:Destroy()
				end
			end)

			if CreateEffect then
				CreateEffect:Destroy()
			end
			local CreateEffect = game.ReplicatedStorage["Explosive" .. System .. "Effect"]:Clone()
			CreateEffect.CFrame = workspace.Effect.Rig2:WaitForChild("HumanoidRootPart").CFrame
			CreateEffect.Parent = workspace.IgnoreList

			delay(0.15, function()
				for _, Par in pairs(CreateEffect:GetDescendants()) do
					if Par:IsA("ParticleEmitter") then
						Par.Enabled = false
					end
				end
			end)
		end)

		local CreateEffect = game.ReplicatedStorage[System .. "Effect"]:Clone()
		local rightArm = betaRig:FindFirstChild("Right Arm")
		if rightArm then
			CreateEffect.CFrame = rightArm.CFrame
		else
			warn("BetaRig Right Arm is missing; skipping system effect placement.")
		end
		CreateEffect.CFrame = workspace.BetaRig["Right Arm"].CFrame
		CreateEffect.Parent = workspace.IgnoreList

		delay(1, function()
			if CreateEffect then
				CreateEffect:Destroy()
			end
		end)

		local Goal = {}
		Goal.CFrame = workspace.Effect.Rig2:WaitForChild("HumanoidRootPart").CFrame
		local Info = TweenInfo.new(1)
		local Tween = TweenService:Create(CreateEffect, Info, Goal)
		Tween:Play()

		delay(1, function()
			local Sound = script.GearRunning:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			delay(0.2 + Sound.TimeLength, function()
				if Sound then
					Sound:Destroy()
				end
			end)

			for _, Gear in pairs(workspace.Gear:GetChildren()) do
				local Goal = {}
				Goal.Transparency = 0
				local Info = TweenInfo.new(1)
				local Tween = TweenService:Create(Gear, Info, Goal)
				Tween:Play()
			end

			for i = 1, 8 do
				delay(1 * i, function()
					for _, Gear in pairs(workspace.Gear:GetChildren()) do
						local Goal = {}
						Goal.CFrame = Gear.CFrame * CFrame.fromEulerAnglesXYZ(0, math.random(-1, 1) * 179, 0)
						local Info = TweenInfo.new(1)
						local Tween = TweenService:Create(Gear, Info, Goal)
						Tween:Play()
					end
				end)
			end
		end)

		delay(10, function()
			for _, Gear in pairs(workspace.Gear:GetChildren()) do
				local Goal = {}
				Goal.Transparency = 1
				local Info = TweenInfo.new(1)
				local Tween = TweenService:Create(Gear, Info, Goal)
				Tween:Play()
			end

			delay(1, function()
				script.Parent.CharacterCreation.PathSelection.Visible = true
				script.Parent.CharacterCreation.PathSelection[UserData:WaitForChild("System").Value].Visible = true

				for _, Path in pairs(script.Parent.CharacterCreation.PathSelection[UserData.System.Value].List:GetChildren()) do
					if Path:IsA("TextButton") then
						Path.MouseEnter:Connect(function()
							local Sound = script.Enter:Clone()
							Sound:Play()
							Sound.Parent = script.Parent

							delay(0.2 + Sound.TimeLength, function()
								if Sound then
									Sound:Destroy()
								end
							end)

							Path.MouseLeave:Once(function()

							end)
						end)
						Path.MouseButton1Click:Once(function()
							local Sound = script.Confirm:Clone()
							Sound:Play()
							Sound.Parent = script.Parent

							delay(0.2 + Sound.TimeLength, function()
								if Sound then
									Sound:Destroy()
								end
							end)

							SetPath(UserData, Path.Name)
						end)
					end
				end
			end)
		end)
	end)
end

local function CharacterCreate(Slot)
	if Slot == "Slot3" and not MarketplaceService:UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, GamePass["Additional Slot"]) then
		return
	end
	if Slot == "Slot4" and not MarketplaceService:UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, GamePass["+Additional Slot"]) then
		return
	end

	script.Parent.CharacterSelection.Characters:TweenPosition(UDim2.new(-0.2, 0, 0.25, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.5)
	script.Parent.CharacterSelection.PlayDesk.Main:TweenPosition(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)

	local Goal = {}
	Goal.Transparency = 0
	local Info = TweenInfo.new(1)
	local Tween = TweenService:Create(script.Parent:WaitForChild("BlankFrame"), Info, Goal)
	Tween:Play()

	delay(1, function()
		for _, Sound in pairs(game.Workspace.Sound:GetDescendants()) do
			if Sound:IsA("Sound") then
				Sound:Stop()
			end
		end

		for _, Sound in pairs(game.Workspace.Sound.Starting:GetChildren()) do
			if Sound:IsA("Sound") then
				Sound:Play()
			end
		end

		script.Parent.CharacterCreation.SystemSelection.Visible = true

		script.Parent.CharacterCreation.SystemSelection.Murim.System.MouseEnter:Connect(function()
			script.Parent.CharacterCreation.SystemSelection.Murim.System.Size = UDim2.new(0.6, 0, 0.9, 0)
			script.Parent.CharacterCreation.SystemSelection.Murim.System.Position = UDim2.new(0.2, 0, 0.05, 0)

			local Sound = script.Enter:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			delay(0.2 + Sound.TimeLength, function()
				if Sound then
					Sound:Destroy()
				end
			end)

			script.Parent.CharacterCreation.SystemSelection.Murim.System.MouseLeave:Once(function()
				script.Parent.CharacterCreation.SystemSelection.Murim.System.Size = UDim2.new(0.5, 0, 0.8, 0)
				script.Parent.CharacterCreation.SystemSelection.Murim.System.Position = UDim2.new(0.25, 0, 0.1, 0)
			end)
		end)

		script.Parent.CharacterCreation.SystemSelection.Murim.MouseButton1Click:Once(function()
			SetSystem(Slot, "Murim")

			local Sound = script.Confirm:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			delay(0.2 + Sound.TimeLength, function()
				if Sound then
					Sound:Destroy()
				end
			end)
		end)

		script.Parent.CharacterCreation.SystemSelection.Magic.System.MouseEnter:Connect(function()
			script.Parent.CharacterCreation.SystemSelection.Magic.System.Size = UDim2.new(0.6, 0, 0.9, 0)
			script.Parent.CharacterCreation.SystemSelection.Magic.System.Position = UDim2.new(0.2, 0, 0.05, 0)

			local Sound = script.Enter:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			delay(0.2 + Sound.TimeLength, function()
				if Sound then
					Sound:Destroy()
				end
			end)

			script.Parent.CharacterCreation.SystemSelection.Magic.System.MouseLeave:Once(function()
				script.Parent.CharacterCreation.SystemSelection.Magic.System.Size = UDim2.new(0.5, 0, 0.8, 0)
				script.Parent.CharacterCreation.SystemSelection.Magic.System.Position = UDim2.new(0.25, 0, 0.1, 0)
			end)
		end)

		script.Parent.CharacterCreation.SystemSelection.Magic.MouseButton1Click:Once(function()
			SetSystem(Slot, "Magic")

			local Sound = script.Confirm:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			delay(0.2 + Sound.TimeLength, function()
				if Sound then
					Sound:Destroy()
				end
			end)
		end)
		
		script.Parent.CharacterCreation.SystemSelection.Dragon.System.MouseEnter:Connect(function()
			script.Parent.CharacterCreation.SystemSelection.Dragon.System.Size = UDim2.new(0.6, 0, 0.9, 0)
			script.Parent.CharacterCreation.SystemSelection.Dragon.System.Position = UDim2.new(0.2, 0, 0.05, 0)

			local Sound = script.Enter:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			delay(0.2 + Sound.TimeLength, function()
				if Sound then
					Sound:Destroy()
				end
			end)

			script.Parent.CharacterCreation.SystemSelection.Dragon.System.MouseLeave:Once(function()
				script.Parent.CharacterCreation.SystemSelection.Dragon.System.Size = UDim2.new(0.5, 0, 0.8, 0)
				script.Parent.CharacterCreation.SystemSelection.Dragon.System.Position = UDim2.new(0.25, 0, 0.1, 0)
			end)
		end)

		script.Parent.CharacterCreation.SystemSelection.Dragon.MouseButton1Click:Once(function()
			SetSystem(Slot, "Dragon")

			local Sound = script.Confirm:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			delay(0.2 + Sound.TimeLength, function()
				if Sound then
					Sound:Destroy()
				end
			end)
		end)

		Plr.Character:WaitForChild("HumanoidRootPart").CFrame = game.Workspace:WaitForChild("Effect").Rig2:WaitForChild("HumanoidRootPart").CFrame
		workspace.CameraView.CFrame = workspace.CreatingCharacterView.CFrame

		local Goal = {}
		Goal.Transparency = 1
		local Info = TweenInfo.new(1)
		local Tween = TweenService:Create(script.Parent:WaitForChild("BlankFrame"), Info, Goal)
		Tween:Play()
	end)
end

local function WaveEffect()
	for i = 1, 200 do
		for e = 1, math.random(2, 3) do
			delay(0.01 * i, function()
				local TargetPos = game.Workspace.Portal:WaitForChild("Sphere").Position

				local Effect = game.ReplicatedStorage.Effect:Clone()
				Effect.Position = game.Workspace.CameraView.Position + Vector3.new(math.random(-8, 8), math.random(-8, 8), math.random(-8, 8))
				Effect.CFrame = CFrame.lookAt(Effect.Position, TargetPos)
				Effect.BrickColor = BrickColor.random()
				Effect.Parent = workspace.IgnoreList

				local Goal = {}
				Goal.Size = Vector3.new(0.1, 0.1, 20)
				local Info = TweenInfo.new(0.1)
				local Tween = TweenService:Create(Effect, Info, Goal)
				Tween:Play()

				delay(0.1, function()
					local Goal = {}
					Goal.Position = TargetPos
					local Info = TweenInfo.new(1)
					local Tween = TweenService:Create(Effect, Info, Goal)
					Tween:Play()

					delay(1, function()
						if Effect then
							Effect:Destroy()
						end
					end)
				end)
			end)
		end
	end
end

script.Parent.CharacterSelection.PlayDesk.Main.Button.MouseButton1Click:Connect(TeleportEffect)

local function CharacterSelectionFunction()
	script.Parent.CharacterSelection.Characters:TweenPosition(UDim2.new(0.025, 0, 0.25, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.5)
	script.Parent.CharacterSelection.PlayDesk.Main:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 1)
end

local AnimStart
local AnimIDLE
local Effects = {}
local Thread = {}

local RaceEffect = {
	Dragon = function(Char)
		local Sound = script.Rock:Clone()
		Sound:Play()
		Sound.Parent = script.Parent

		table.insert(Effects, Sound)

		Thread["DragonThread1"] = delay(0.4, function()
			if Char == nil then
				return
			end

			local Shout = game.ReplicatedStorage.ShoutParticle.ShoutParticle:Clone()
			Shout.Parent = Char.Head

			table.insert(Effects, Shout)

			local Sound2 = script.DragonRoar:Clone()
			Sound2:Play()
			Sound2.Parent = script.Parent

			table.insert(Effects, Sound2)

			Thread["DragonThread2"] = delay(2, function()
				if Shout then
					Shout:Destroy()
				end
				if Sound2 then
					Sound2:Destroy()
				end
				if Sound then
					Sound:Destroy()
				end
			end)

			Thread["DragonThread3"] = delay(0.4, function()
				for _, Par in pairs(Shout:GetChildren()) do
					if Par:IsA("ParticleEmitter") then
						Par.Enabled = false
					end
				end
			end)
		end)
	end,
	["Arc Demon"] = function(Char)
		local Sound = script.ArcDemonAppear:Clone()
		Sound:Play()
		Sound.Parent = script.Parent

		table.insert(Effects, Sound)

		local HighLight = Instance.new("Highlight", Char)
		HighLight.FillTransparency = 0
		HighLight.FillColor = Color3.fromRGB(0, 0, 0)
		HighLight.OutlineTransparency = 0
		HighLight.OutlineColor = Color3.fromRGB(0, 0, 0)

		table.insert(Effects, HighLight)

		Thread["Arc DemonThread1"] = delay(0.3, function()
			local Sound = script.Creepy:Clone()
			Sound:Play()
			Sound.Parent = script.Parent

			table.insert(Effects, Sound)
		end)

		Thread["Arc DemonThread2"] = delay(0.8, function()
			local Goal = {}
			Goal.FillTransparency = 1
			Goal.OutlineTransparency = 1
			local Info = TweenInfo.new(0.5)
			local Tween = TweenService:Create(HighLight, Info, Goal)
			Tween:Play()

			Thread["Arc DemonThread2"] = delay(0.5, function()
				if HighLight then
					HighLight:Destroy()
				end
			end)
		end)
	end,
	["Arc Angel"] = function(Char)
		local Sound = script.ArcAngelAppear:Clone()
		Sound:Play()
		Sound.Parent = script.Parent

		table.insert(Effects, Sound)

		local AngelDescentEffect = game.ReplicatedStorage.AngelDescent:Clone()
		AngelDescentEffect.CFrame = Char.HumanoidRootPart.CFrame
		AngelDescentEffect.Parent = workspace.IgnoreList

		for i, Effect in pairs(AngelDescentEffect:GetDescendants()) do
			if Effect:IsA("Beam") then
				Effect.Width0 = 0
				Effect.Width1 = 0

				local Goal = {}
				Goal.Width0 = 25
				Goal.Width1 = 25
				local Info = TweenInfo.new(0.5)
				local Tween = TweenService:Create(Effect, Info, Goal)
				Tween:Play()

				Thread["Beam" .. i] = delay(1.3, function()
					local Goal = {}
					Goal.Width0 = 0
					Goal.Width1 = 0
					local Info = TweenInfo.new(0.2)
					local Tween = TweenService:Create(Effect, Info, Goal)
					Tween:Play()
				end)
			elseif Effect:IsA("ParticleEmitter") then
				Thread["Particle" .. i] = delay(0.3, function()
					Effect.Enabled = false
				end)
			end
		end

		table.insert(Effects, AngelDescentEffect)

		local HighLight = Instance.new("Highlight", Char)
		HighLight.FillTransparency = 0
		HighLight.FillColor = Color3.fromRGB(255, 255, 255)
		HighLight.OutlineTransparency = 0
		HighLight.OutlineColor = Color3.fromRGB(255, 255, 255)

		table.insert(Effects, HighLight)

		Thread["Arc AngelThread1"] = delay(1, function()
			local Goal = {}
			Goal.FillTransparency = 1
			Goal.OutlineTransparency = 1
			local Info = TweenInfo.new(0.5)
			local Tween = TweenService:Create(HighLight, Info, Goal)
			Tween:Play()

			Thread["Arc AngelThread2"] = delay(0.5, function()
				if HighLight then
					HighLight:Destroy()
				end
				if AngelDescentEffect then
					AngelDescentEffect:Destroy()
				end
			end)
		end)
	end,
}

local function CharacterEffect(UserData, UserTempData)
	repeat
		wait()
	until Plr.Character

	if not UserData then
		return
	end

	local Char = Plr.Character

	local Hum = Char:FindFirstChildOfClass("Humanoid")

	if not Hum then
		return
	end

	if not game.ReplicatedStorage.Animation:FindFirstChild(UserTempData.Race.Value .. "Start") then
		return
	end

	for i, v in pairs(Hum:GetPlayingAnimationTracks()) do
		v:Stop()
	end

	local AnimStart = Hum:LoadAnimation(game.ReplicatedStorage.Animation:FindFirstChild(UserTempData.Race.Value .. "Start"))
	AnimStart.Priority = Enum.AnimationPriority.Action
	AnimStart:Play()

	if RaceEffect[UserTempData.Race.Value] then
		if Effects then
			for _, v in pairs(Effects) do
				v:Destroy()
				v = nil
			end
		end

		if Thread then
			for _, v in pairs(Thread) do
				task.cancel(v)
				v = nil
			end
		end

		RaceEffect[UserTempData.Race.Value](Char)
	end

	AnimStart.Ended:Once(function()
		if AnimIDLE then
			AnimIDLE:Stop()
			AnimIDLE = nil
		end

		if not game.ReplicatedStorage.Animation:FindFirstChild(UserTempData.Race.Value .. "IDLE") then
			return
		end

		local AnimIDLE = Hum:LoadAnimation(game.ReplicatedStorage.Animation:FindFirstChild(UserTempData.Race.Value .. "IDLE"))
		AnimIDLE.Priority = Enum.AnimationPriority.Core
		AnimIDLE:Play()
	end)
end

local function SetStatus()
	local UIStatus = game.Workspace:WaitForChild("Status").UIStatus.UI.MainStatus
	local UIWorld = game.Workspace:WaitForChild("World").BillboardGui.TextLabel
	local Planet = game.Workspace:WaitForChild("World").Planet
	local PlanetCenter = game.Workspace:WaitForChild("World").PlanetCenter
	local Room1 = game.Workspace:WaitForChild("Room1")
	local UISystem = game.Workspace:WaitForChild("System").BillboardGui.TextLabel

	local UserData = Plr:FindFirstChild("UserData" .. UserSlot.NumberSlot.Value)
	local UserTempData = Plr:FindFirstChild("UserTempData" .. UserSlot.NumberSlot.Value)

	if not UserSlot["Slot" .. UserSlot.NumberSlot.Value].Value then return end
	repeat wait() until UserData and UserTempData

	CharacterEffect(UserData, UserTempData)

	local system = UserData.System.Value
	local world = UserData.World.Value
	if not system or not world then return end

	-- Set active system visuals
	for _, sys in ipairs({ "Murim", "Magic", "Dragon" }) do
		if UIStatus:FindFirstChild(sys) then
			UIStatus[sys].Visible = false
		end
		if UIStatus:FindFirstChild(sys .. "_Border") then
			UIStatus[sys .. "_Border"].Visible = false
		end
		if UIStatus:FindFirstChild(sys .. "_Extra") then
			UIStatus[sys .. "_Extra"].Visible = false
		end
	end

	-- Activate selected system UI
	if UIStatus:FindFirstChild(system) then
		UIStatus[system].Visible = true
	end
	if UIStatus:FindFirstChild(system .. "_Border") then
		UIStatus[system .. "_Border"].Visible = true
	end
	if UIStatus:FindFirstChild(system .. "_Extra") then
		UIStatus[system .. "_Extra"].Visible = true
	end

	-- Set system text and world label
	UISystem.Text = system .. " System"
	UIWorld.Text = "The " .. world

	-- Set system background color
	local systemColors = {
		Murim = Color3.fromRGB(255, 205, 7),
		Magic = Color3.fromRGB(0, 170, 255),
		Dragon = Color3.fromRGB(160, 70, 255),
	}
	UIStatus.BackgroundColor3 = systemColors[system] or Color3.fromRGB(255, 255, 255)

	-- Destroy old planets
	for _, p in ipairs(Planet:GetChildren()) do
		p:Destroy()
	end

	-- Clone and place new planet
	local planetTemplate = game.ReplicatedStorage.Planets:FindFirstChild(world)
	if planetTemplate then
		local NewPlanet = planetTemplate:Clone()
		NewPlanet:ScaleTo(1.5)
		NewPlanet.Center.CFrame = PlanetCenter.CFrame
		NewPlanet.Parent = Planet
	end

	-- Lighting: remove all, then apply new world graphics
	for _, g in ipairs(game.Lighting:GetChildren()) do
		g:Destroy()
	end

	local worldGraphics = game.ReplicatedStorage.Graphics:FindFirstChild(world)
	if worldGraphics then
		for _, g in ipairs(worldGraphics:GetChildren()) do
			g:Clone().Parent = game.Lighting
		end
	end

	-- Stop all sounds, play world-specific ones
	for _, s in ipairs(game.Workspace.Sound:GetDescendants()) do
		if s:IsA("Sound") then s:Stop() end
	end

	local worldSounds = game.Workspace.Sound:FindFirstChild(world)
	if worldSounds then
		for _, s in ipairs(worldSounds:GetChildren()) do
			if s:IsA("Sound") then s:Play() end
		end
	end

	-- Toggle room visuals
	if world ~= "" then
		for _, part in ipairs(Room1:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Transparency = 1
			elseif part:IsA("Beam") then
				part.Enabled = false
			end
		end
		local roomWorld = Room1:FindFirstChild(world)
		if roomWorld then
			for _, part in ipairs(roomWorld:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Transparency = 0
				elseif part:IsA("Beam") then
					part.Enabled = true
				end
			end
		end
	end

	-- Update labels for the active system UI
	local systemUI = UIStatus:FindFirstChild(system)
	if systemUI then
		for _, label in ipairs(systemUI:GetChildren()) do
			if label:IsA("TextLabel") and UserTempData:FindFirstChild(label.Name) then
				label.Text = label.Name .. ": " .. tostring(UserTempData[label.Name].Value)
			end
		end
	end
end

local function StartScene()
	script.Parent.Title:TweenPosition(UDim2.new(0.2, 0, -0.3, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.5)
	script.Parent.VersionLabel:TweenPosition(UDim2.new(-0.2, 0, 0.95, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.5)
	script.Parent.Reminder:TweenPosition(UDim2.new(0.35, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.5)

	local Sound = script.Sound:Clone()
	Sound:Play()
	Sound.Parent = script.Parent

	delay(0.2 + Sound.TimeLength, function()
		if Sound then
			Sound:Destroy()
		end
	end)

	WaveEffect()

	delay(0.5, function()
		local Goal = {}
		Goal.CFrame = workspace.PortalView.CFrame
		local Info = TweenInfo.new(1)
		local Tween1 = TweenService:Create(workspace.CameraView, Info, Goal)
		Tween1:Play()

		local Goal = {}
		Goal.Transparency = 0
		local Info = TweenInfo.new(1)
		local Tween = TweenService:Create(script.Parent:WaitForChild("BlankFrame"), Info, Goal)
		Tween:Play()

		Shake(game.Workspace:WaitForChild("CameraView"), 2, 10)

		local Sound1 = script.Sound1:Clone()
		Sound1:Play()
		Sound1.Parent = script.Parent

		local Sound2 = script.Sound2:Clone()
		Sound2:Play()
		Sound2.Parent = script.Parent

		delay(Sound2.TimeLength + Sound1.TimeLength, function()
			if Sound1 then
				Sound1:Destroy()
			end
			if Sound2 then
				Sound2:Destroy()
			end
		end)

		delay(1, function()
			Tween:Pause()
			Tween1:Pause()

			workspace.CameraView.CFrame = workspace.CharacterView.CFrame
			game.Lighting.Blur.Size = 0

			if UserSlot.Slot1.Value == true then
				SetStatus()

				UserSlot.NumberSlot.Changed:Connect(function()
					SetStatus()
				end)
			end

			local Goal = {}
			Goal.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
			local Info = TweenInfo.new(1)
			local Tween = TweenService:Create(script.Parent:WaitForChild("BlankFrame"), Info, Goal)
			Tween:Play()

			delay(1, function()
				local Goal = {}
				Goal.CFrame = workspace.CharacterView2.CFrame
				local Info = TweenInfo.new(1)
				local Tween = TweenService:Create(workspace.CameraView, Info, Goal)
				Tween:Play()

				local Goal = {}
				Goal.Transparency = 1
				local Info = TweenInfo.new(1)
				local Tween = TweenService:Create(script.Parent:WaitForChild("BlankFrame"), Info, Goal)
				Tween:Play()

				CharacterSelectionFunction()
			end)
		end)
	end)
end

-- Add Character buttons
Slots:WaitForChild("Slot1").AddCharacter.Button.MouseButton1Click:Connect(function()
	CharacterCreate("Slot1")
end)

Slots:WaitForChild("Slot2").AddCharacter.Button.MouseButton1Click:Connect(function()
	CharacterCreate("Slot2")
end)

Slots:WaitForChild("Slot3").AddCharacter.Button.MouseButton1Click:Connect(function()
	CharacterCreate("Slot3")
end)

Slots:WaitForChild("Slot4").AddCharacter.Button.MouseButton1Click:Connect(function()
	CharacterCreate("Slot4")
end)

local started = false

local function requestStart()
        if started then
                return
        end

        started = true
        StartScene()
        KeysEvent:FireServer()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
                return
        end
        requestStart()
end)

repeat
	wait()
until game.Workspace.Portal:FindFirstChild("Wave")

SpinPortal()
