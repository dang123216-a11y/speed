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

-- 1. Xử lý Tăng Tốc
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

-- 2. Xử lý chức năng Bay Siêu Nhân R6 cực mượt
local flyVelocity, flyGyro, flyConnection

local function StartFlying()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    flyGyro = Instance.new("BodyGyro")
    flyGyro.maxTorque = Vector3.new(4e5, 4e5, 4e5)
    flyGyro.P = 1e4
    flyGyro.cframe = rootPart.CFrame
    flyGyro.Parent = rootPart
    
    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.maxForce = Vector3.new(4e5, 4e5, 4e5)
    flyVelocity.velocity = Vector3.new(0, 0, 0)
    flyVelocity.Parent = rootPart
    
    local camera = workspace.CurrentCamera
    local humanoid = character:FindFirstChild("Humanoid")
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if character and rootPart and humanoid then
            humanoid.PlatformStand = true -- Đổi tư thế lơ lửng nằm ngang như siêu nhân
            flyGyro.cframe = camera.CFrame
            
            -- Tính toán hướng di chuyển dựa trên cần gạt Joystick/Nút di chuyển
            local moveDirection = humanoid.MoveDirection
            local speed = tonumber(SpeedInput.Text) or 70
            
            if moveDirection.Magnitude > 0 then
                -- Ép nhân vật bay thẳng theo hướng nhìn của camera
                flyVelocity.velocity = camera.CFrame.LookVector * speed
            else
                -- Đứng im trên không khi thả tay
                flyVelocity.velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

local function StopFlying()
    if flyConnection then flyConnection:Disconnect() end
    if flyGyro then flyGyro:Destroy() end
    if flyVelocity then flyVelocity:Destroy() end
    
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
end

ToggleFlyBtn.MouseButton1Click:Connect(function()
    IsFlyToggled = not IsFlyToggled
    if IsFlyToggled then
        ToggleFlyBtn.Text = "TAT
