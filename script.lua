-- Script para Defesa Automática de Bola com Precisão

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- A bola do jogo
local ball = game.Workspace:WaitForChild("Bola")

-- Distância crítica para considerar que a bola está próxima
local defenseDistance = 5  -- Ajuste a distância conforme necessário

-- Função de defesa (sem movimentação, apenas bloqueio)
local function defendBall()
    while ball and ball.Parent do
        -- Calcular a distância entre o jogador e a bola
        local ballPosition = ball.Position
        local distance = (ballPosition - rootPart.Position).magnitude

        -- Se a bola estiver dentro da distância crítica, ativar defesa
        if distance <= defenseDistance then
            -- Aqui você pode adicionar a lógica de defesa precisa
            -- Vamos assumir que existe uma função ou evento que faz a defesa
            -- Exemplo de defesa (substitua pelo método correto para seu jogo)
            -- Se for necessário chamar um RemoteEvent ou animar algo, coloque aqui.
            
            -- Exemplo simples: quando a bola está próxima, simula um bloqueio perfeito
            print("Defendendo a bola com precisão!")
            
            -- Caso haja algum tipo de animação ou comando específico de defesa, ative aqui.
            -- humanoid:PlayAnimation(defenseAnimation) ou algo similar.
        end

        wait(0.1)  -- Espera um curto período antes de verificar novamente
    end
end

-- Iniciar a defesa
defendBall()
