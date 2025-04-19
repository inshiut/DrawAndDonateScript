-- Pixel Art: Coração 8x8 (1 = desenhar, 0 = ignorar)
local pixelData = {
    {0,1,0,0,0,0,1,0},
    {1,1,1,0,0,1,1,1},
    {1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1},
    {0,1,1,1,1,1,1,0},
    {0,0,1,1,1,1,0,0},
    {0,0,0,1,1,0,0,0},
    {0,0,0,0,1,0,0,0}
}

-- Função para pintar pixels
local function paintPixel(x, y)
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or game:GetService("ReplicatedStorage")
    local drawFunc = remotes:FindFirstChild("DrawPixel") or remotes:FindFirstChild("PaintPixel")

    if drawFunc then
        drawFunc:FireServer(x, y, Color3.fromRGB(255, 0, 0)) -- Vermelho
    else
        warn("Não foi possível encontrar a função de desenho.")
    end
end

-- Desenhar a imagem no canvas
local function drawImage()
    for y = 1, #pixelData do
        for x = 1, #pixelData[y] do
            if pixelData[y][x] == 1 then
                paintPixel(x, y)
                wait(0.01) -- Delay para evitar flood
            end
        end
    end
end

-- Criar HUD
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0, 30, 0, 30)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "Desenhar Coração"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 18
button.MouseButton1Click:Connect(drawImage)

local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(1, -20, 0, 30)
minimize.Position = UDim2.new(0, 10, 0, 60)
minimize.Text = "Minimizar HUD"
minimize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 16

local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in pairs(frame:GetChildren()) do
		if child ~= minimize then
			child.Visible = not minimized
		end
	end
	minimize.Text = minimized and "Restaurar HUD" or "Minimizar HUD"
end)
