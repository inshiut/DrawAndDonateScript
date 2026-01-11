-- [[ SPRAY PAINT ULTIMATE AUTODRAW - 2026 ]]
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- 1. LOCALIZADOR AUTOMÁTICO DE REMOTES (Anti-Patch)
local PaintRemote = nil
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and (v.Name:find("Paint") or v.Name:find("Spray") or v.Name:find("Draw")) then
        PaintRemote = v
        break
    end
end

-- 2. INTERFACE FLUIDA (DESIGN DARK)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 180)
Main.Position = UDim2.new(0.5, -130, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "SPRAY PAINT PERFECT"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local UrlBox = Instance.new("TextBox", Main)
UrlBox.Size = UDim2.new(0.9, 0, 0, 35)
UrlBox.Position = UDim2.new(0.05, 0, 0.3, 0)
UrlBox.PlaceholderText = "Link da Imagem (.jpg/.png)"
UrlBox.Text = ""

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0.9, 0, 0, 40)
StartBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
StartBtn.Text = "DESENHAR (4 MINUTOS)"
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
StartBtn.TextColor3 = Color3.new(1,1,1)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 0.85, 0)
Status.Text = "Aguardando..."
Status.TextColor3 = Color3.new(0.7, 0.7, 0.7)
Status.BackgroundTransparency = 1

-- 3. MOTOR DE DESENHO OTIMIZADO
local function DrawImage(url)
    if not PaintRemote then 
        Status.Text = "Erro: Remote não achado!" 
        return 
    end
    
    task.spawn(function()
        Status.Text = "Processando Imagem..."
        
        -- Proxy estável para converter a imagem em dados de cor
        -- Se este proxy estiver lento, o tempo de 4 min é respeitado pelo wait
        local apiUrl = "https://api.paints.io/render?url=" .. url
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(apiUrl))
        end)

        if not success then
            Status.Text = "Erro na API. Link direto?"
            return
        end

        Status.Text = "Desenhando... Fique parado!"
        
        -- Cálculo para durar 4 minutos (240 segundos)
        -- Ajustamos o delay dinamicamente baseado no número de pixels
        local delayTime = 240 / #response 
        if delayTime < 0.025 then delayTime = 0.025 end -- Trava de segurança Anti-Kick

        for i, pixel in ipairs(response) do
            -- Executa a pintura no servidor
            PaintRemote:FireServer(
                Vector2.new(pixel.x, pixel.y), -- Posição
                Color3.fromHex(pixel.hex),     -- Cor
                1,                             -- Tamanho do pincel
                "Circle"                       -- Formato
            )

            -- Atualiza HUD a cada 100 pixels para não travar o FPS do mobile
            if i % 100 == 0 then
                Status.Text = "Progresso: " .. math.floor((i / #response) * 100) .. "%"
            end
            
            task.wait(delayTime)
        end
        
        Status.Text = "Concluído!"
        StartBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end)
end

StartBtn.MouseButton1Click:Connect(function()
    if UrlBox.Text ~= "" then
        DrawImage(UrlBox.Text)
    end
end)
