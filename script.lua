-- [[ UNIVERSAL AUTODRAW - QUALQUER LINK ]]
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Identifica o jogo e o evento
local Remote = ReplicatedStorage:FindFirstChild("UpdatePixel") or ReplicatedStorage:FindFirstChild("PaintRemote")

-- 2. Interface Adaptável
local sg = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 260, 0, 200)
Main.Position = UDim2.new(0.5, -130, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "AUTODRAW UNIVERSAL"
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.new(1, 1, 1)

local Box = Instance.new("TextBox", Main)
Box.Size = UDim2.new(0.9, 0, 0, 40)
Box.Position = UDim2.new(0.05, 0, 0.25, 0)
Box.PlaceholderText = "Cole o link da imagem aqui"
Box.Text = "" -- Deixe vazio para você colar o que quiser
Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Box.TextColor3 = Color3.new(1, 1, 1)

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0.9, 0, 0, 45)
StartBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
StartBtn.Text = "DESENHAR (4 MINUTOS)"
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
StartBtn.TextColor3 = Color3.new(1, 1, 1)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.82, 0)
Status.Text = "Aguardando link..."
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.BackgroundTransparency = 1

-- 3. Lógica que aceita qualquer link
local function Desenhar(url)
    Status.Text = "Conectando à API..."
    
    task.spawn(function()
        -- Usando Proxy estável para evitar o erro de API que você teve
        local apiUrl = "https://api.paints.io/render?url=" .. url
        local success, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(apiUrl))
        end)

        if not success or not data then
            Status.Text = "Erro: API não leu este link."
            return
        end

        -- Ajuste para 4 minutos (240 segundos)
        local totalPixels = #data
        local delayTime = 240 / totalPixels
        if delayTime < 0.02 then delayTime = 0.02 end -- Proteção Anti-Kick

        Status.Text = "Desenhando..."
        for i, p in ipairs(data) do
            if Remote then
                -- O Remote do Draw & Donate geralmente usa (X, Y, Color3)
                Remote:FireServer(p.x, p.y, Color3.fromHex(p.hex))
            end
            
            if i % 50 == 0 then
                Status.Text = "Progresso: " .. math.floor((i/#data)*100) .. "%"
                task.wait() -- Evita crash no Delta
            end
            task.wait(delayTime)
        end
        Status.Text = "Finalizado!"
    end)
end

StartBtn.MouseButton1Click:Connect(function()
    if Box.Text ~= "" then
        Desenhar(Box.Text)
    else
        Status.Text = "Cole um link primeiro!"
    end
end)
