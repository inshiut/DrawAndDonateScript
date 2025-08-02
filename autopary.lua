local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ParryEnabled = false
local GuiName = "AutoParryHUD"

-- Função para criar o HUD
local function createHUD()
    local gui = Instance.new("ScreenGui")
    gui.Name = GuiName
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 140, 0, 40)
    toggle.Position = UDim2.new(0, 20, 0, 100)
    toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Text = "Auto Parry: OFF"
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 18
    toggle.Parent = gui

    toggle.MouseButton1Click:Connect(function()
        ParryEnabled = not ParryEnabled
        toggle.Text = ParryEnabled and "Auto Parry: ON" or "Auto Parry: OFF"
        toggle.BackgroundColor3 = ParryEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 30, 30)
    end)
end

-- Recriar HUD após respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if not LocalPlayer.PlayerGui:FindFirstChild(GuiName) then
        createHUD()
    end
end)

-- Criar HUD no início
if not LocalPlayer.PlayerGui:FindFirstChild(GuiName) then
    createHUD()
end

-- Função para detectar e dar parry
local function tryParry()
    if not ParryEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local root = char.HumanoidRootPart
    local enemies = workspace:GetDescendants()

    for _, obj in pairs(enemies) do
        if obj:IsA("BasePart") and obj.Name == "Projectile" and obj:FindFirstAncestorWhichIsA("Model") ~= char then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < 15 then
                -- Aqui você pode ajustar a distância e timing
                local input = game:GetService("ReplicatedStorage"):FindFirstChild("Parry")
                if input then
                    input:FireServer()
                    print("Parry em projétil detectado!")
                end
            end
        end
    end
end

-- Loop do auto parry
RunService.RenderStepped:Connect(function()
    pcall(tryParry)
end)
