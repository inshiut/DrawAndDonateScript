-- AUTOPARRY para Roblox "Parry" - Suporte para Celular e PC
-- HUD: Botão para ativar/desativar

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- HUD
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoParryHUD"
ScreenGui.Parent = game:GetService("CoreGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 140, 0, 50)
ToggleButton.Position = UDim2.new(0, 15, 0, 15)
ToggleButton.Text = "AutoParry: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 24
ToggleButton.Parent = ScreenGui

local autoparryEnabled = false

ToggleButton.MouseButton1Click:Connect(function()
    autoparryEnabled = not autoparryEnabled
    ToggleButton.Text = "AutoParry: " .. (autoparryEnabled and "ON" or "OFF")
    ToggleButton.BackgroundColor3 = autoparryEnabled and Color3.fromRGB(50,200,50) or Color3.fromRGB(40,40,40)
end)

-- Função para tentar parry
local function tryParry()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- Detecta ataques próximos (por nome genérico)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and (obj.Name:lower():find("attack") or obj.Name:lower():find("ball")) then
            local dist = (char.HumanoidRootPart.Position - obj.Position).Magnitude
            if dist < 12 then -- Ajuste o alcance conforme necessário
                -- PC: Simula pressionar tecla F (se RemoteEvent existir)
                local parryRemote = char:FindFirstChild("Parry") or workspace:FindFirstChild("Parry")
                if parryRemote and parryRemote:IsA("RemoteEvent") then
                    parryRemote:FireServer()
                end
                -- Celular: Procura botão F virtual e simula clique
                for _, gui in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                    if gui:IsA("TextButton") and (gui.Text == "F" or gui.Name:lower():find("parry")) then
                        gui:Activate()
                    end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if autoparryEnabled then
        pcall(tryParry)
    end
end)
