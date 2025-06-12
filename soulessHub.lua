-- OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GRPGaming/Key-System/refs/heads/Xycer-Hub-Script/ZusumeLib(Slider)"))()

-- Services
local UIS = game:GetService("UserInputService")
local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- UI Init
local Window = OrionLib:MakeWindow({
    Name = "Souless Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "SoulessHub"
})

---

-- MOVEMENT TAB

local MovementTab = Window:MakeTab({
    Name = "Movement",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local speedEnabled = false
local jumpEnabled = false
local flyEnabled = false
local tpWalkEnabled = false
local speedValue = 16
local jumpValue = 50
local flySpeed = 2
local tpWalkSpeed = 5

-- Speed Toggle + Slider
MovementTab:AddToggle({
    Name = "Enable Speed",
    Default = false,
    Callback = function(v)
        speedEnabled = v
        if speedEnabled then
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = speedValue end
        else
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
})

MovementTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 16,
    Increment = 1,
    Callback = function(v)
        speedValue = v
        if speedEnabled then
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end
})

-- Jump Toggle + Slider
MovementTab:AddToggle({
    Name = "Enable Jump",
    Default = false,
    Callback = function(v)
        jumpEnabled = v
        if jumpEnabled then
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = jumpValue end
        else
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = 50 end
        end
    end
})

MovementTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Increment = 5,
    Callback = function(v)
        jumpValue = v
        if jumpEnabled then
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v end
        end
    end
})

-- Fly Toggle + Slider (Mobile Compatible)
local flying = false
local flyGui = nil

MovementTab:AddToggle({
    Name = "Enable Fly",
    Default = false,
    Callback = function(v)
        flyEnabled = v
        if flyEnabled then
            createFlyGui()
        else
            if flyGui then
                flyGui:Destroy()
                flyGui = nil
            end
        end
    end
})

MovementTab:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(v)
        flySpeed = v
    end
})

-- TPWalk Toggle + Slider
local tpWalkConnection

MovementTab:AddToggle({
    Name = "Enable TPWalk",
    Default = false,
    Callback = function(v)
        tpWalkEnabled = v
        if tpWalkEnabled then
            tpWalkConnection = RunService.Heartbeat:Connect(function()
                local char = LP.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local humanoid = char.Humanoid
                    local rootPart = char.HumanoidRootPart
                    
                    if humanoid.MoveDirection.Magnitude > 0 then
                        local moveVector = humanoid.MoveDirection * tpWalkSpeed
                        rootPart.CFrame = rootPart.CFrame + moveVector
                    end
                end
            end)
        else
            if tpWalkConnection then
                tpWalkConnection:Disconnect()
                tpWalkConnection = nil
            end
        end
    end
})

MovementTab:AddSlider({
    Name = "TPWalk Speed",
    Min = 1,
    Max = 20,
    Default = 5,
    Increment = 1,
    Callback = function(v)
        tpWalkSpeed = v
    end
})

-- Mobile-Compatible Fly System
local function createFlyGui()
    -- Wait for PlayerGui to be ready
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Check if fly GUI already exists and remove it
    local existingGui = playerGui:FindFirstChild("SoulessFlyScript")
    if existingGui then
        existingGui:Destroy()
    end
    
    local FlyScript = Instance.new("ScreenGui")
    local Gradient = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local UICorner = Instance.new("UICorner")
    local Button = Instance.new("TextButton")
    local Shadow = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")

    --Properties:
    FlyScript.Name = "SoulessFlyScript"
    FlyScript.Parent = playerGui
    FlyScript.ResetOnSpawn = false

    Gradient.Name = "Gradient"
    Gradient.Parent = FlyScript
    Gradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Gradient.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Gradient.BorderSizePixel = 0
    Gradient.Position = UDim2.new(0.0199062824, 0, 0.781767964, 0)
    Gradient.Size = UDim2.new(0, 231, 0, 81)

    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(57, 104, 252)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(51, 68, 175))}
    UIGradient.Parent = Gradient

    UICorner.CornerRadius = UDim.new(0.0399999991, 0)
    UICorner.Parent = Gradient

    Button.Name = "Button"
    Button.Parent = Gradient
    Button.BackgroundColor3 = Color3.fromRGB(77, 100, 150)
    Button.BorderSizePixel = 0
    Button.Position = UDim2.new(0.0921155736, 0, 0.238353431, 0)
    Button.Size = UDim2.new(0, 187, 0, 41)
    Button.ZIndex = 2
    Button.Font = Enum.Font.GothamSemibold
    Button.Text = ""
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.TextSize = 14.000
    Button.TextWrapped = true

    Shadow.Name = "Shadow"
    Shadow.Parent = Button
    Shadow.BackgroundColor3 = Color3.fromRGB(53, 69, 103)
    Shadow.BorderSizePixel = 0
    Shadow.Size = UDim2.new(1, 0, 1, 4)

    TextLabel.Parent = Gradient
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.new(0.487012982, 0, 0.5, 0)
    TextLabel.Size = UDim2.new(0.878787875, -20, 0.728395045, -20)
    TextLabel.ZIndex = 2
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = "Fly"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14.000
    TextLabel.TextWrapped = true

    -- Make frame draggable
    Gradient.Draggable = true
    Gradient.Active = true
    Gradient.Selectable = true

    flyGui = FlyScript

    Button.MouseButton1Down:Connect(function()
        -- Wait for character to be ready
        local player = game.Players.LocalPlayer
        repeat wait() until player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid")
        
        local char = player.Character
        local torso = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        
        if not torso then
            warn("Could not find character torso/HumanoidRootPart")
            return
        end
        
        local mouse = player:GetMouse()
        repeat wait() until mouse
        
        local flying = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = flySpeed or 50
        local speed = 0

        function Fly()
            local bg = Instance.new("BodyGyro")
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = torso.CFrame
            bg.Parent = torso
            
            local bv = Instance.new("BodyVelocity")
            bv.velocity = Vector3.new(0,0.1,0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = torso
            
            repeat wait()
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.PlatformStand = true
                end
                
                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed = speed+.5+(speed/maxspeed)
                    if speed > maxspeed then
                        speed = maxspeed
                    end
                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                    speed = speed-1
                    if speed < 0 then
                        speed = 0
                    end
                end
                
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                    bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
                else
                    bv.velocity = Vector3.new(0,0.1,0)
                end
                bg.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
            until not flying
            
            ctrl = {f = 0, b = 0, l = 0, r = 0}
            lastctrl = {f = 0, b = 0, l = 0, r = 0}
            speed = 0
            
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = false
            end
        end

        mouse.KeyDown:Connect(function(key)
            if key:lower() == "e" then
                if flying then 
                    flying = false
                else
                    flying = true
                    Fly()
                end
            elseif key:lower() == "w" then
                ctrl.f = 1
            elseif key:lower() == "s" then
                ctrl.b = -1
            elseif key:lower() == "a" then
                ctrl.l = -1
            elseif key:lower() == "d" then
                ctrl.r = 1
            end
        end)

        mouse.KeyUp:Connect(function(key)
            if key:lower() == "w" then
                ctrl.f = 0
            elseif key:lower() == "s" then
                ctrl.b = 0
            elseif key:lower() == "a" then
                ctrl.l = 0
            elseif key:lower() == "d" then
                ctrl.r = 0
            end
        end)
        
        Fly()
    end)
end

---

-- VISUALS TAB

local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
ESP:Toggle(false) -- Start disabled
ESP.Players = false
ESP.Boxes = false
ESP.Tracers = false
ESP.Health = false

local espEnabled = false

VisualsTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(v)
        espEnabled = v
        ESP:Toggle(v)
        ESP.Players = v
    end
})

VisualsTab:AddToggle({
    Name = "ESP Boxes",
    Default = false,
    Callback = function(v)
        if espEnabled then
            ESP.Boxes = v
        end
    end
})

VisualsTab:AddToggle({
    Name = "ESP Tracers",
    Default = false,
    Callback = function(v)
        if espEnabled then
            ESP.Tracers = v
        end
    end
})

VisualsTab:AddToggle({
    Name = "Health Bars",
    Default = false,
    Callback = function(v)
        if espEnabled then
            ESP.Health = v
        end
    end
})

-- Color Picker for ESP
VisualsTab:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v)
        if espEnabled then
            ESP.Color = v
        end
    end
})

-- Part ESP
local partESPEnabled = false
local partESPName = ""
local partESPBoxes = {}
local lastPartESPUpdate = 0

VisualsTab:AddToggle({
    Name = "Enable Part ESP",
    Default = false,
    Callback = function(v)
        partESPEnabled = v
        if not v then
            -- Clear existing boxes
            for _, box in pairs(partESPBoxes) do
                if box then box:Destroy() end
            end
            partESPBoxes = {}
        end
    end
})

VisualsTab:AddTextbox({
    Name = "Part Name for ESP",
    Default = "",
    TextDisappear = false,
    Callback = function(v)
        partESPName = v
    end
})

-- Part ESP System (Fixed)
local function createPartESP(part)
    local box = Instance.new("SelectionBox")
    box.Adornee = part
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.5
    box.Parent = part
    return box
end

local function updatePartESP()
    if not partESPEnabled or partESPName == "" then return end
    
    -- Clear existing boxes
    for _, box in pairs(partESPBoxes) do
        if box then box:Destroy() end
    end
    partESPBoxes = {}
    
    -- Find and highlight parts
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.lower(obj.Name):find(string.lower(partESPName)) then
            local box = createPartESP(obj)
            table.insert(partESPBoxes, box)
        end
    end
end

-- Update part ESP efficiently
RunService.Heartbeat:Connect(function()
    if partESPEnabled and partESPName ~= "" then
        local currentTime = tick()
        if currentTime - lastPartESPUpdate >= 2 then -- Update every 2 seconds
            updatePartESP()
            lastPartESPUpdate = currentTime
        end
    end
end)

---

-- PVP TAB

local PvPTab = Window:MakeTab({
    Name = "PvP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local aimbotEnabled = false
local silentAimEnabled = false
local lockAimEnabled = false
local lockedPlayer = nil

-- Aimbot Toggle
PvPTab:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(v)
        aimbotEnabled = v
    end
})

-- Silent Aim Toggle
PvPTab:AddToggle({
    Name = "Enable Silent Aim",
    Default = false,
    Callback = function(v)
        silentAimEnabled = v
    end
})

-- Lock Aim Toggle
PvPTab:AddToggle({
    Name = "Enable Lock Aim",
    Default = false,
    Callback = function(v)
        lockAimEnabled = v
    end
})

-- Player selection for lock aim
local function getPlayerList()
    local names = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local lockTargetDropdown = PvPTab:AddDropdown({
    Name = "Lock Target",
    Default = "",
    Options = getPlayerList(),
    Callback = function(val)
        lockedPlayer = val
    end
})

-- Update dropdown periodically
spawn(function()
    while wait(5) do
        lockTargetDropdown:Refresh(getPlayerList(), true)
    end
end)

-- Basic Aimbot Function
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    
    return closestPlayer
end

-- Aimbot System
RunService.Heartbeat:Connect(function()
    if (aimbotEnabled or lockAimEnabled) and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local target = nil
        
        if lockAimEnabled and lockedPlayer then
            target = game.Players:FindFirstChild(lockedPlayer)
        elseif aimbotEnabled then
            target = getClosestPlayer()
        end
        
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local camera = workspace.CurrentCamera
            local targetPosition = target.Character.Head.Position
            local cameraPosition = camera.CFrame.Position
            local direction = (targetPosition - cameraPosition).Unit
            
            camera.CFrame = CFrame.lookAt(cameraPosition, targetPosition)
        end
    end
end)

---

-- MISC TAB

local MiscTab = Window:MakeTab({
    Name = "Miscellaneous",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local selectedPlayer = nil
local infJumpEnabled = false
local noclipEnabled = false
local infJumpConnection
local noclipConnection

-- Player Selection
local playerDropdown = MiscTab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = getPlayerList(),
    Callback = function(val)
        selectedPlayer = val
    end
})

-- Update player dropdown periodically
spawn(function()
    while wait(5) do
        playerDropdown:Refresh(getPlayerList(), true)
    end
end)

MiscTab:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        if not selectedPlayer or selectedPlayer == "" then
            OrionLib:MakeNotification({
                Name = "Teleport Failed",
                Content = "No player selected.",
                Time = 3
            })
            return
        end
        
        local target = game.Players:FindFirstChild(selectedPlayer)
        local char = game.Players.LocalPlayer.Character
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
            OrionLib:MakeNotification({
                Name = "Teleport Success",
                Content = "Teleported to " .. selectedPlayer,
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "Teleport Failed",
                Content = "Could not find the player or target.",
                Time = 4
            })
        end
    end
})

MiscTab:AddTextbox({
    Name = "Manual Teleport (Name)",
    Default = "",
    TextDisappear = true,
    Callback = function(name)
        if name == "" then return end
        
        local target = game.Players:FindFirstChild(name)
        local char = game.Players.LocalPlayer.Character
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
            OrionLib:MakeNotification({
                Name = "Teleport Success",
                Content = "Teleported to " .. name,
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "Teleport Failed",
                Content = "Invalid player name.",
                Time = 3
            })
        end
    end
})

-- Infinite Jump (Fixed)
MiscTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(v)
        infJumpEnabled = v
        if infJumpEnabled then
            infJumpConnection = UIS.JumpRequest:Connect(function()
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                    LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end
})

-- Noclip (Fixed and Complete)
MiscTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(v)
        noclipEnabled = v
        if noclipEnabled then
            noclipConnection = RunService.Stepped:Connect(function()
                if LP.Character then
                    for _, part in pairs(LP.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            -- Restore collision
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- Auto-reconnect features when character respawns
LP.CharacterAdded:Connect(function()
    wait(2) -- Wait for character to fully load
    
    -- Reapply speed if enabled
    if speedEnabled then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speedValue end
    end
    
    -- Reapply jump if enabled
    if jumpEnabled then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = jumpValue end
    end
end)

-- Init
OrionLib:Init()