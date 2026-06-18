local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedInput = Instance.new("TextBox")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "SpeedMenu"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0.25, 0)
Title.Text = "MENU TOC DO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

SpeedInput.Parent = MainFrame
SpeedInput.Position = UDim2.new(0.1, 0, 0.35, 0)
SpeedInput.Size = UDim2.new(0.8, 0, 0.25, 0)
SpeedInput.Text = "100"
SpeedInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)

local IsToggled = false
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
ToggleBtn.Text = "BAT SPEED"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function ApplySpeed(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if IsToggled then
            local targetSpeed = tonumber(SpeedInput.Text) or 16
            if humanoid.WalkSpeed ~= targetSpeed then
                humanoid.WalkSpeed = targetSpeed
            end
        end
    end)
end

if LocalPlayer.Character then ApplySpeed(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(ApplySpeed)

ToggleBtn.MouseButton1Click:Connect(function()
    IsToggled = not IsToggled
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        if IsToggled then
            ToggleBtn.Text = "TAT SPEED"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            character.Humanoid.WalkSpeed = tonumber(SpeedInput.Text) or 16
        else
            ToggleBtn.Text = "BAT SPEED"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            character.Humanoid.WalkSpeed = 16
        end
    end
end)
