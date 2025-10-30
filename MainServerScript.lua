local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TeleportService = game:GetService("TeleportService")

local function ensureRemote(parent, name, className)
        local remote = parent:FindFirstChild(name)
        if not remote then
                remote = Instance.new(className)
                remote.Name = name
                remote.Parent = parent
        end
        return remote
end

local function getRemotesFolder()
        local folder = ReplicatedStorage:FindFirstChild("Remotes")
        if not folder then
                folder = Instance.new("Folder")
                folder.Name = "Remotes"
                folder.Parent = ReplicatedStorage
        end
        return folder
end

local RemotesFolder = getRemotesFolder()
local KeysEvent = ensureRemote(RemotesFolder, "Keys", "RemoteEvent")
local TeleportRequestEvent = ensureRemote(RemotesFolder, "TeleportRequest", "RemoteEvent")

local EnvironmentModule
local function getEnvironmentModule()
        if EnvironmentModule then
                return EnvironmentModule
        end

        local success, result = pcall(function()
                return require(ServerStorage.Config.GameEnvironment)
        end)

        if success then
                EnvironmentModule = result
        else
                warn("[ServerMainScript] Failed to load GameEnvironment module:", result)
        end

        return EnvironmentModule
end

local function anchorCharacter(player)
        local character = player.Character or player.CharacterAdded:Wait()
        if not character then
                return
        end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
                humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
        end
        if not humanoidRootPart then
                return
        end

        humanoidRootPart.Anchored = true

        local effectFolder = workspace:FindFirstChild("Effect")
        if effectFolder then
                local rig = effectFolder:FindFirstChild("Rig")
                if rig then
                        local target = rig:FindFirstChild("HumanoidRootPart")
                        if target then
                                humanoidRootPart.CFrame = target.CFrame
                        end
                end
        end

        local forceField = character:FindFirstChildOfClass("ForceField")
        if forceField then
                forceField:Destroy()
        end
end

KeysEvent.OnServerEvent:Connect(function(player)
        if player:FindFirstChild("Started") then
                return
        end

        local startedFolder = Instance.new("Folder")
        startedFolder.Name = "Started"
        startedFolder.Parent = player

        anchorCharacter(player)
end)

local function validateSlot(player, slotNumber)
        local userSlot = player:FindFirstChild("UserSlot")
        if not userSlot then
                warn("[Teleport] UserSlot missing for", player.Name)
                return nil
        end

        local slotValue = userSlot:FindFirstChild("Slot" .. slotNumber)
        if not slotValue or slotValue.Value == false then
                warn("[Teleport] Invalid or inactive slot", slotNumber, "for", player.Name)
                return nil
        end

        return userSlot
end

TeleportRequestEvent.OnServerEvent:Connect(function(player, slotNumber)
        if typeof(slotNumber) ~= "number" then
                warn("[Teleport] Invalid slot number payload from", player.Name)
                return
        end

        local userSlot = validateSlot(player, slotNumber)
        if not userSlot then
                return
        end

        local userData = player:FindFirstChild("UserData" .. slotNumber)
        if not userData then
                warn("[Teleport] Missing UserData" .. slotNumber .. " for", player.Name)
                return
        end

        local systemValue = userData:FindFirstChild("System")
        local worldValue = userData:FindFirstChild("World")
        if not systemValue or systemValue.Value == "" then
                warn("[Teleport] Missing system information for", player.Name)
                return
        end

        local environment = getEnvironmentModule()
        if not environment then
                warn("[Teleport] Environment module unavailable; cannot teleport", player.Name)
                return
        end

        local targetPlaceId = environment:GetWorldIdBySystem(systemValue.Value)
        if not targetPlaceId then
                warn("[Teleport] No place id for system", systemValue.Value, "player", player.Name)
                return
        end

        local success = false
        local retryCount = 0
        while retryCount < 5 and not success do
                retryCount += 1
                local ok, err = pcall(function()
                        local reservedServerId = TeleportService:ReserveServer(targetPlaceId)

                        local teleportData = {
                                UserId = player.UserId,
                                SlotNumber = slotNumber,
                                System = systemValue.Value,
                                World = worldValue and worldValue.Value or "",
                                Timestamp = os.time(),
                        }

                        if game.PrivateServerId and game.PrivateServerId ~= "" then
                                TeleportService:TeleportToPrivateServer(targetPlaceId, reservedServerId, { player }, nil, teleportData)
                        else
                                TeleportService:Teleport(targetPlaceId, player, teleportData)
                        end
                end)

                if ok then
                        success = true
                else
                        warn(string.format("[Teleport] Attempt %d failed for %s: %s", retryCount, player.Name, tostring(err)))
                        task.wait(1)
                end
        end

        if not success then
                warn("[Teleport] Failed to teleport" , player.Name, "after retries")
        end
end)
