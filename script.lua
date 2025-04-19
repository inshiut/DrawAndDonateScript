-- Definir o jogador e o personagem
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Criar o HUD
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 280, 0, 60)
label.Position = UDim2.new(0, 10, 0, 25)
label.Text = "Defendendo a bola!"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 24
label.BackgroundTransparency = 1
label.Parent = frame

-- Função para bloquear a bola (simular defesa)
local function defendBall()
    while true do
        local ball = game.Workspace:FindFirstChild("Ball")
        
        if ball then
            -- Calcular a distância entre o jogador e a bola
            local ballPosition = ball.Position
            local distance = (ballPosition - humanoidRootPart.Position).Magnitude

            -- Se a bola estiver próxima, bloqueia a bola
            if distance <= 5 then
                -- Simular defesa (aqui você pode adicionar ações específicas)
                print("Bola defendida com sucesso!")
                -- Exemplo: disparar um RemoteEvent ou animar o personagem
            end
        end
        
        wait(0.1)  -- Checar a cada 0.1 segundos
    end
end

-- Função para ativar e desativar a defesa
local isDefending = false

local function toggleDefense()
    isDefending = not isDefending
    if isDefending then
        print("Defesa ativada!")
        defendBall()  -- Iniciar a defesa
    else
        print("Defesa desativada!")
        -- Se necessário, parar a defesa aqui
    end
end

-- Botão para ativar/desativar defesa
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 50, 0, 160)
toggleButton.Text = "Ativar Defesa"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

toggleButton.MouseButton1Click:Connect(function()
    toggleDefense()  -- Alterna entre ativar e desativar
    if isDefending then
        toggleButton.Text = "Desativar Defesa"
    else
        toggleButton.Text = "Ativar Defesa"
    end
end)

print("HUD e defesa carregados com sucesso!")
