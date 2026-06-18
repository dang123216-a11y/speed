local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedInput = Instance.new("TextBox")
local ToggleSpeedBtn = Instance.new("TextButton")
local ToggleFlyBtn = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "SuperMenu"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "MENU SPEED & FLY"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

SpeedInput.Parent = MainFrame
SpeedInput.Position = UDim2.new(0.1, 0, 0.25, 0)
SpeedInput.Size = UDim2.new(0.8, 0, 0.2, 0)
SpeedInput.Text = "100"
SpeedInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)

local IsSpeedToggled = false
ToggleSpeedBtn.Parent = MainFrame
ToggleSpeedBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleSpeedBtn.Size = UDim2.new(0.8, 0, 0.2, 0)
ToggleSpeedBtn.Text = "BAT SPEED"
ToggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local IsFlyToggled = false
ToggleFlyBtn.Parent = MainFrame
ToggleFlyBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
ToggleFlyBtn.Size = UDim2.new(0.8, 0, 0.2, 0)
ToggleFlyBtn.Text = "BAT BAY"
ToggleFlyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleFlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function ApplySpeed(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if IsSpeedToggled then
            local targetSpeed = tonumber(SpeedInput.Text) or 16
            if humanoid.WalkSpeed ~= targetSpeed then
                humanoid.WalkSpeed = targetSpeed
            end
        end
    end)
end

if LocalPlayer.Character then ApplySpeed(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(ApplySpeed)

ToggleSpeedBtn.MouseButton1Click:Connect(function()
    IsSpeedToggled = not IsSpeedToggled
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        if IsSpeedToggled then
            ToggleSpeedBtn.Text = "TAT SPEED"
            ToggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            character.Humanoid.WalkSpeed = tonumber(SpeedInput.Text) or 16
        else
            ToggleSpeedBtn.Text = "BAT SPEED"
            ToggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            character.Humanoid.WalkSpeed = 16
        end
    end
end)

local BodyGyro, BodyVelocity
local FlyConnection

local function StartFlying()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if not rootPart then return end
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e5, 9e5, 9e5)
    BodyGyro.cframe = rootPart.CFrame
    BodyGyro.Parent = rootPart
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    BodyVelocity.maxForce = Vector3.new(9e5, 9e5, 9e5)
    BodyVelocity.Parent = rootPart
    
    local camera = workspace.CurrentCamera
    
    FlyConnection = RunService.RenderStepped:Connect(function()
        if character and rootPart and character:FindFirstChild("Humanoid") then
            character.Humanoid.PlatformStand = true
            BodyGyro.cframe = camera.CFrame
            
            local moveDirection = character.Humanoid.MoveDirection
            if moveDirection.Magnitude > 0 then
                BodyVelocity.velocity = camera.CFrame.LookVector * (tonumber(SpeedInput.Text) or 50)
            else
                BodyVelocity.velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

local function StopFlying()
    if FlyConnection then FlyConnection:Disconnect() end
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
    
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
end

ToggleFlyBtn.MouseButton1Click:Connect(function()
    IsFlyToggled = not IsFlyToggled
    if IsFlyToggled then
        ToggleFlyBtn.Text = "TAT BAY"
        ToggleFlyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        StartFlying()
    else
        ToggleFlyBtn.Text = "BAT BAY"
        ToggleFlyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StopFlying()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    IsFlyToggled = false
    ToggleFlyBtn.Text = "BAT BAY"
    ToggleFlyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)
