-- Universal Combat Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configurações
local Config = {
    Aimbot = true,
    AutoFire = true,
    ESP = true,
    AimbotFOV = 200,
    AimbotSmooth = 0.1,
    ESPColor = Color3.fromRGB(255, 0, 0)
}

-- Funções auxiliares
local function IsEnemy(player)
    if not player or player == LocalPlayer then return false end
    
    -- Verifica se tem sistema de times
    if player.Team and LocalPlayer.Team then
        return player.Team ~= LocalPlayer.Team
    end
    
    -- Se não tem times, considera todos como inimigos
    return true
end

local function GetCharacter(player)
    return player.Character
end

local function GetRootPart(character)
    return character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
end

local function GetHead(character)
    return character and character:FindFirstChild("Head")
end

local function IsAlive(character)
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

-- ESP System
local ESPObjects = {}

local function CreateESP(player)
    local character = GetCharacter(player)
    if not character then return end
    
    local rootPart = GetRootPart(character)
    if not rootPart then return end
    
    -- Box ESP
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Config.ESPColor
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    
    -- Name ESP
    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = Config.ESPColor
    name.Size = 18
    name.Center = true
    name.Outline = true
    name.Text = player.Name
    
    -- Health ESP
    local health = Drawing.new("Text")
    health.Visible = false
    health.Color = Color3.fromRGB(0, 255, 0)
    health.Size = 16
    health.Center = true
    health.Outline = true
    
    ESPObjects[player] = {box = box, name = name, health = health}
end

local function UpdateESP(player)
    if not Config.ESP or not IsEnemy(player) then
        if ESPObjects[player] then
            ESPObjects[player].box.Visible = false
            ESPObjects[player].name.Visible = false
            ESPObjects[player].health.Visible = false
        end
        return
    end
    
    local character = GetCharacter(player)
    if not IsAlive(character) then
        if ESPObjects[player] then
            ESPObjects[player].box.Visible = false
            ESPObjects[player].name.Visible = false
            ESPObjects[player].health.Visible = false
        end
        return
    end
    
    if not ESPObjects[player] then
        CreateESP(player)
    end
    
    local rootPart = GetRootPart(character)
    local head = GetHead(character)
    if not rootPart or not head then return end
    
    local rootPos, rootVis = Camera:WorldToViewportPoint(rootPart.Position)
    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
    local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
    
    if rootVis then
        local height = (headPos.Y - legPos.Y)
        local width = height / 2
        
        ESPObjects[player].box.Size = Vector2.new(width, height)
        ESPObjects[player].box.Position = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
        ESPObjects[player].box.Visible = true
        
        ESPObjects[player].name.Position = Vector2.new(rootPos.X, headPos.Y - 20)
        ESPObjects[player].name.Visible = true
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            ESPObjects[player].health.Text = math.floor(humanoid.Health)
            ESPObjects[player].health.Position = Vector2.new(rootPos.X, legPos.Y + 5)
            ESPObjects[player].health.Visible = true
        end
    else
        ESPObjects[player].box.Visible = false
        ESPObjects[player].name.Visible = false
        ESPObjects[player].health.Visible = false
    end
end

local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player].box:Remove()
        ESPObjects[player].name:Remove()
        ESPObjects[player].health:Remove()
        ESPObjects[player] = nil
    end
end

-- Aimbot System
local function GetClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = Config.AimbotFOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if IsEnemy(player) then
            local character = GetCharacter(player)
            if IsAlive(character) then
                local head = GetHead(character)
                if head then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                        if distance < shortestDistance then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function AimAt(target)
    local character = GetCharacter(target)
    if not IsAlive(character) then return end
    
    local head = GetHead(character)
    if not head then return end
    
    local targetPos = head.Position
    local cameraPos = Camera.CFrame.Position
    local direction = (targetPos - cameraPos).Unit
    
    local newCFrame = CFrame.new(cameraPos, cameraPos + direction)
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Config.AimbotSmooth)
end

-- Auto Fire System
local function GetTool()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
end

local function FireWeapon()
    local tool = GetTool()
    if not tool then return end
    
    -- Método 1: Ativar tool
    tool:Activate()
    
    -- Método 2: Simular clique (para alguns jogos)
    local args = {[1] = "Fire"}
    for _, v in pairs(tool:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            v:FireServer(unpack(args))
        elseif v:IsA("RemoteFunction") then
            v:InvokeServer(unpack(args))
        end
    end
end

-- Main Loop
local currentTarget = nil

RunService.RenderStepped:Connect(function()
    -- ESP Update
    for _, player in pairs(Players:GetPlayers()) do
        UpdateESP(player)
    end
    
    -- Aimbot
    if Config.Aimbot then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            currentTarget = GetClosestEnemy()
            if currentTarget then
                AimAt(currentTarget)
                
                -- Auto Fire
                if Config.AutoFire then
                    FireWeapon()
                end
            end
        else
            currentTarget = nil
        end
    end
end)

-- Player Events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(0.5)
        CreateESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

print("Universal Combat Script carregado!")
print("Aimbot: Segure botão direito do mouse")
print("AutoFire: Automático quando mirar")
print("ESP: Sempre ativo")
