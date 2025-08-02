-- Auto Parry Pilgrammed • Com ajuste de timing
-- By ChatGPT

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoParryHUD"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0,20,0,120)
frame.Size = UDim2.new(0,200,0,120)
frame.BackgroundTransparency = 0.3
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Text = "Auto Parry"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local toggle = Instance.new("TextButton", frame)
toggle.Text = "OFF"
toggle.Position = UDim2.new(0,10,0,40)
toggle.Size = UDim2.new(0,80,0,30)
toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 18

local sliderLabel = Instance.new("TextLabel", frame)
sliderLabel.Text = "Delay (s): 0.2"
sliderLabel.Position = UDim2.new(0,10,0,80)
sliderLabel.Size = UDim2.new(0,120,0,20)
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextColor3 = Color3.new(1,1,1)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 14

local slider = Instance.new("TextButton", frame)
slider.Position = UDim2.new(0,130,0,80)
slider.Size = UDim2.new(0,50,0,20)
slider.Text = "-"
slider.BackgroundColor3 = Color3.fromRGB(70,70,70)
slider.TextColor3 = Color3.new(1,1,1)
slider.Font = Enum.Font.Gotham
slider.TextSize = 18

local sliderInc = Instance.new("TextButton", frame)
sliderInc.Position = UDim2.new(0,180,0,80)
sliderInc.Size = UDim2.new(0,50,0,20)
sliderInc.Text = "+"
sliderInc.BackgroundColor3 = Color3.fromRGB(70,70,70)
sliderInc.TextColor3 = Color3.new(1,1,1)
sliderInc.Font = Enum.Font.Gotham
sliderInc.TextSize = 18

local active = false
local delayTime = 0.2
local cooling = false

toggle.MouseButton1Click:Connect(function()
    active = not active
    toggle.Text = active and "ON" or "OFF"
end)

slider.MouseButton1Click:Connect(function()
    delayTime = math.max(0, delayTime - 0.05)
    sliderLabel.Text = ("Delay (s): %.2f"):format(delayTime)
end)
sliderInc.MouseButton1Click:Connect(function()
    delayTime = delayTime + 0.05
    sliderLabel.Text = ("Delay (s): %.2f"):format(delayTime)
end)

-- Função de bloqueio seguido de parry remoto (ajustável)
local function doParry()
    local char = player.Character
    if not char then return end
    local remoteBlock = char:FindFirstChild("Block")
    local remoteParry = char:FindFirstChild("Parry")
    if remoteBlock and remoteParry and remoteBlock:IsA("RemoteEvent") and remoteParry:IsA("RemoteEvent") then
        remoteBlock:FireServer(true)  -- inicia o block
        task.wait(delayTime)
        remoteParry:FireServer()       -- faz o parry
        task.wait(0.1)
        remoteBlock:FireServer(false) -- libera o block
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    if not active or cooling then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for _, hit in pairs(workspace:GetDescendants()) do
        if hit:IsA("Hitbox") and hit:FindFirstChild("Owner") then
            local enemy = hit.Owner.Value
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                if (char.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude < 10 then
                    cooling = true
                    doParry()
                    task.delay(0.7, function() cooling = false end)
                    break
                end
            end
        end
    end
end)
