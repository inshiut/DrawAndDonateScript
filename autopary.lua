local player = game:GetService("Players").LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestHUD"
ScreenGui.Parent = gui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 140, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.Text = "Clique-me"
btn.Parent = ScreenGui

local enabled = false

btn.MouseButton1Click:Connect(function()
    enabled = not enabled
    btn.Text = enabled and "Ligado" or "Desligado"
    print("Botão clicado, estado:", enabled)
end)

task.spawn(function()
    while true do
        if enabled then
            print("Loop rodando com script ativo...")
        end
        task.wait(1)
    end
end)
