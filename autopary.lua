--[[
Pilgrammed Autoparry Script (Mobile + HUD)
Feito por Copilot, adaptável para desktop e mobile.
Troque o nome do RemoteEvent se necessário!
]]

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- Nome do RemoteEvent de parry (confira pelo Explorer/Synapse, etc)
local PARRY_REMOTE_NAME = "ParryRemote" -- Edite para o correto!

local enabled = false

-- HUD: botão para ativar/desativar
local gui = Instance.new("ScreenGui")
gui.Name = "AutoParryHUD"
gui.Parent = game:GetService("CoreGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 140, 0, 48)
btn.Position = UDim2.new(0.5, -70, 0.85, 0)
btn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
btn.TextColor3 = Color3.new(1,1,1)
btn.Text = "AutoParry: OFF"
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.Parent = gui

btn.MouseButton1Click:Connect(function()
    enabled = not enabled
    btn.Text = enabled and "AutoParry: ON" or "AutoParry: OFF"
    btn.BackgroundColor3 = enabled and Color3.fromRGB(200,40,40) or Color3.fromRGB(60,200,80)
end)

-- Detectar ataque e parry automático
local function parryCheck()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    humanoid.HealthChanged:Connect(function(newHealth)
        if enabled and newHealth < humanoid.Health then
            local remote = rs:FindFirstChild(PARRY_REMOTE_NAME)
            if remote then
                remote:FireServer()
            end
        end
    end)
end

parryCheck()
lp.CharacterAdded:Connect(parryCheck)

-- Dica: se Pilgrammed usar outro sinal (flag/valor/efeito), monitore também!
