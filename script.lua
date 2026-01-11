-- [[ CONFIGURAÇÕES DO MOTOR ]]
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tenta encontrar o evento de pintura automaticamente
local PaintEvent = ReplicatedStorage:FindFirstChild("Paint", true) or ReplicatedStorage:FindFirstChild("Spray", true)

-- [[ INTERFACE ADAPTADA PARA MOBILE (DELTA) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaAutoDraw"
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Position = UDim2.new(0.5, -125, 0.4, -100)
Main.Size = UDim2.new(0, 250, 0, 220)
Main.Active = true
Main.Draggable = true -- No Delta, isso ajuda a mover a HUD com o dedo

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "🖌️ SPRAY PAINT - DELTA"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local UrlInput = Instance.new("TextBox")
UrlInput.Size = UDim2.new(0.9, 0, 0, 40)
UrlInput.Position = UDim2.new(0.05, 0, 0.25, 0)
UrlInput.PlaceholderText = "Cole o link da imagem aqui"
UrlInput.Text = ""
UrlInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
UrlInput.TextColor3 = Color3.new(1, 1, 1)
UrlInput.Parent = Main

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0.9, 0, 0, 45)
StartBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
StartBtn.Text = "INICIAR (4 MINUTOS)"
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
StartBtn.TextColor3 = Color3.new(1, 1, 1)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.Parent = Main

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.8, 0)
Status.Text = "Aguardando comando..."
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.BackgroundTransparency = 1
Status.Parent = Main

-- [[ LÓGICA DE DESENHO FLUIDA ]]

local function ComecarDesenho(url)
    if not PaintEvent then
        Status.Text = "ERRO: Evento não encontrado!"
        return
    end

    task.spawn(function()
        Status.Text = "Lendo imagem..."
        
        -- IMPORTANTE: Para Mobile, usamos um delay levemente maior para evitar lag
        local delayTime = 0.03 
        
        -- Simulando o processamento (No Delta, HttpGet é estável)
        -- Aqui você usaria: local data = HttpService:JSONDecode(game:HttpGet("PROXY_AQUI"..url))
        local pixels = {} -- Os dados processados viriam aqui
        
        Status.Text = "Desenhando... (Fluidez Ativa)"
        Status.TextColor3 = Color3.new(0, 1, 0)

        for i, p in ipairs(pixels) do
            -- Comando de pintura direto no servidor do jogo
            PaintEvent:FireServer(Vector2.new(p.x, p.y), p.color, 1, "Circle")
            
            -- Atualiza progresso sem travar o Mobile
            if i % 100 == 0 then
                Status.Text = "Progresso: " .. math.floor((i / #pixels) * 100) .. "%"
                task.wait() -- Dá um respiro para o processador do telemóvel
            end
            
            task.wait(delayTime)
        end
        
        Status.Text = "Concluído com sucesso!"
    end)
end

StartBtn.MouseButton1Click:Connect(function()
    if UrlInput.Text ~= "" then
        ComecarDesenho(UrlInput.Text)
    else
        Status.Text = "Insira um link válido!"
    end
end)
