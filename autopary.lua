--[[ Auto Parry Script for Pilgrammed (Mobile Friendly) ]]--

-- CONFIG
local ParryDistance = 12         -- Distância para ativar parry
local ParryDelay = 0.15          -- Delay antes do parry
local ProjectilSpeedCheck = true

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AutoParryHUD"

local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 140, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Auto Parry: ON"
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.BorderSizePixel = 0
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.Visible = true
ToggleButton.Active = true
ToggleButton.Draggable = true

local autoParryEnabled = true
ToggleButton.MouseButton1Click:Connect(function()
    autoParryEnabled = not autoParryEnabled
    ToggleButton.Text = "Auto Parry: " .. (autoParryEnabled and "ON" or "OFF")
end)

-- Parry Function
local function performParry()
    local char = game.Players.LocalPlayer.Character
    if char then
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
        task.wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
    end
end

-- Enemy & Projectile Detection
local function monitorCombat()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local RunService = game:GetService("RunService")

    RunService.Heartbeat:Connect(function()
        if not autoParryEnabled then return end

        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local humRoot = char.HumanoidRootPart

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= char then
                local enemyHRP = obj:FindFirstChild("HumanoidRootPart")
                if enemyHRP and (enemyHRP.Position - humRoot.Position).Magnitude <= ParryDistance then
                    performParry()
                end
            elseif ProjectilSpeedCheck and obj:IsA("BasePart") and obj.Velocity.Magnitude > 20 and obj.Size.Magnitude < 10 then
                if (obj.Position - humRoot.Position).Magnitude <= ParryDistance then
                    performParry()
                end
            end
        end
    end)
end

-- Respawn protection
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if not ScreenGui or not ScreenGui.Parent then
        ScreenGui.Parent = game.CoreGui
    end
end)

-- Start
task.spawn(monitorCombat)
print("[Auto Parry] Script loaded.")
