local decalID = "96792002723138"  -- ID do Decal que você obteve após o upload

-- Criar o HUD
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Criar o quadro do HUD
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Texto do HUD
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 0, 50)
label.Position = UDim2.new(0, 10, 0, 10)
label.Text = "Draw and Donate Helper"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 24
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSansBold
label.Parent = frame

-- Botão de desenhar automático
local drawButton = Instance.new("TextButton")
drawButton.Size = UDim2.new(0, 260, 0, 40)
drawButton.Position = UDim2.new(0, 20, 0, 70)
drawButton.Text = "Desenhar Imagem"
drawButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
drawButton.TextColor3 = Color3.fromRGB(255, 255, 255)
drawButton.TextSize = 18
drawButton.Font = Enum.Font.SourceSansBold
drawButton.Parent = frame

-- Função para desenhar (spawnar o decal)
local function desenharImagem()
	local part = Instance.new("Part")
	part.Size = Vector3.new(4, 1, 4)
	part.Position = Vector3.new(0, 10, 0)
	part.Anchored = true
	part.Parent = game.Workspace

	local decal = Instance.new("Decal")
	decal.Texture = "rbxassetid://" .. decalID
	decal.Parent = part
end

drawButton.MouseButton1Click:Connect(desenharImagem)

-- Botão de minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 260, 0, 30)
minimizeButton.Position = UDim2.new(0, 20, 0, 130)
minimizeButton.Text = "Minimizar HUD"
minimizeButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Parent = frame

local minimized = false

minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in pairs(frame:GetChildren()) do
		if child ~= minimizeButton then
			child.Visible = not minimized
		end
	end
	minimizeButton.Text = minimized and "Restaurar HUD" or "Minimizar HUD"
end)


