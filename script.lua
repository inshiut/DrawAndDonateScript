local decalID = "96792002723138"  -- ID do Decal que você obteve após o upload
-- Criar a Parte para aplicar o Decal
local part = Instance.new("Part")
part.Size = Vector3.new(4, 1, 4)
part.Position = Vector3.new(0, 10, 0)
part.Anchored = true
part.Parent = game.Workspace

-- Criar o Decal e aplicar na Parte
local decal = Instance.new("Decal")
decal.Texture = "rbxassetid://" .. decalID
decal.Parent = part

-- Criar o HUD (Interface Gráfica do Usuário)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Criar o quadro do HUD
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

-- Criar um texto no HUD
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 280, 0, 100)
label.Position = UDim2.new(0, 10, 0, 25)
label.Text = "Bem-vindo ao Draw and Donate!"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 24
label.BackgroundTransparency = 1
label.Parent = frame

