-- Universal Combat Script
local success, err = pcall(function()
    print("[Universal] Iniciando...")
end)

if not success then
    warn("[Universal] Erro ao iniciar:", err)
end

local player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

repeat task.wait() until player.Character or player.CharacterAdded:Wait()
task.wait(0.5)

local guiParent = gethui and gethui() or game:GetService("CoreGui")
if not guiParent then
    guiParent = player:WaitForChild("PlayerGui")
end

pcall(function()
    local existing = guiParent:FindFirstChild("UniversalGui")
    if existing then existing:Destroy() end
end)

task.wait(0.3)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 360)
MainFrame.BackgroundTransparency = 0.05

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(90, 50, 180)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3

local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BorderSizePixel = 0
local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local TitleBarFix = Instance.new("Frame")
TitleBarFix.Parent = TitleBar
TitleBarFix.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBarFix.Size = UDim2.new(1, 0, 0, 14)
TitleBarFix.Position = UDim2.new(0, 0, 1, -14)
TitleBarFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚔ Universal"
Title.TextColor3 = Color3.fromRGB(180, 140, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Active = true

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Parent = TitleBar
rejoinBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
rejoinBtn.Position = UDim2.new(1, -36, 0, 6)
rejoinBtn.Size = UDim2.new(0, 30, 0, 30)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.Text = "R"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.TextSize = 13

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 8)
rejoinCorner.Parent = rejoinBtn

local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function createButton(text, position)
    local Button = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local Indicator = Instance.new("Frame")
    local IndicatorCorner = Instance.new("UICorner")
    local IndicatorStroke = Instance.new("UIStroke")
    
    Button.Parent = MainFrame
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    Button.Position = position
    Button.Size = UDim2.new(0, 145, 0, 32)
    Button.Font = Enum.Font.GothamSemibold
    Button.Text = "  " .. text
    Button.TextColor3 = Color3.fromRGB(210, 210, 220)
    Button.TextSize = 12
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.AutoButtonColor = false
    
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Parent = Button
    BtnStroke.Color = Color3.fromRGB(50, 50, 70)
    BtnStroke.Thickness = 1
    BtnStroke.Transparency = 0.5
    
    Indicator.Parent = Button
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    Indicator.Position = UDim2.new(1, -24, 0.5, -6)
    Indicator.Size = UDim2.new(0, 12, 0, 12)
    Indicator.BorderSizePixel = 0
    
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    IndicatorStroke.Parent = Indicator
    IndicatorStroke.Color = Color3.fromRGB(255, 255, 255)
    IndicatorStroke.Thickness = 1
    IndicatorStroke.Transparency = 0.7
    
    return Button, Indicator
end

local function createKeyBox(text, position)
    local Box = Instance.new("TextBox")
    Box.Parent = MainFrame
    Box.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Box.Position = position
    Box.Size = UDim2.new(0, 38, 0, 32)
    Box.Font = Enum.Font.GothamBold
    Box.Text = text
    Box.TextColor3 = Color3.fromRGB(180, 140, 255)
    Box.TextSize = 11
    Box.ClearTextOnFocus = false
    Box.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Box
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Box
    Stroke.Color = Color3.fromRGB(60, 50, 100)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.5
    
    return Box
end

local espKey = Enum.KeyCode.J
local aimbotKey = Enum.KeyCode.X
local autoFireKey = Enum.KeyCode.C
local maxKey = Enum.KeyCode.V
local noclipKey = Enum.KeyCode.N
local toggleKey = Enum.KeyCode.Z

local aimbotEnabled = false
local aimbotFOV = 300
local rightMouseDown = false
local autoFireEnabled = false
local maxEnabled = false
local maxSlowMode = false
local noclipEnabled = false
local perfEnabled = false

local espEnabled = false
local espBoxes = {}
local espConnections = {}
local botCharacters = {}

local function isBot(character)
    if not character then return false end
    local plr = game.Players:GetPlayerFromCharacter(character)
    if plr then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local head = character:FindFirstChild("Head")
    return humanoid and head and humanoid.Health > 0
end

local function isBotEnemy(character)
    if not isBot(character) then return false end
    if character == player.Character then return false end
    
    -- Verifica pasta Characters no Workspace
    local charactersFolder = workspace:FindFirstChild("Characters")
    if charactersFolder then
        local terroristsFolder = charactersFolder:FindFirstChild("Terrorists")
        local ctsFolder = charactersFolder:FindFirstChild("Counter-Terrorists")
        
        if terroristsFolder and ctsFolder then
            local isInTerrorists = character:IsDescendantOf(terroristsFolder)
            local isInCTs = character:IsDescendantOf(ctsFolder)
            
            if player.Team then
                local myTeamName = player.Team.Name
                if myTeamName:match("Terrorist") and isInTerrorists then return false end
                if myTeamName:match("Counter") and isInCTs then return false end
                if isInTerrorists or isInCTs then return true end
            end
        end
    end
    
    return true
end

local function isEnemy(otherPlayer)
    if not otherPlayer or otherPlayer == player then return false end
    if not player.Character or not otherPlayer.Character then return false end
    
    if not player.Team or not otherPlayer.Team then return true end
    
    if player.Team.Name == "FFA" or otherPlayer.Team.Name == "FFA" then return true end
    
    if player.Team ~= otherPlayer.Team then return true end
    
    return false
end

local function addESP(plr)
    if plr == player or not espEnabled then return end
    
    local function createHighlight(char)
        if not espEnabled or not char:FindFirstChild("Head") then return end
        
        pcall(function()
            for _, obj in pairs(char:GetChildren()) do
                if obj:IsA("Highlight") then
                    obj:Destroy()
                end
            end
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    for _, obj in pairs(part:GetChildren()) do
                        if obj:IsA("BillboardGui") and obj.Name ~= "HealthBar" then
                            obj:Destroy()
                        end
                    end
                end
            end
            
            local head = char:FindFirstChild("Head")
            if not head then return end
            
            local color, isAlly
            if isEnemy(plr) then
                color = Color3.fromRGB(180, 0, 0)
                isAlly = false
            else
                color = Color3.fromRGB(0, 200, 0)
                isAlly = true
            end
            
            local highlight = Instance.new("Highlight")
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.FillTransparency = 0.85
            highlight.OutlineTransparency = 0.5
            highlight.Adornee = char
            highlight.Parent = char
            
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = plr.Name .. (isAlly and " [ALLY]" or "")
            nameLabel.TextColor3 = color
            nameLabel.TextStrokeTransparency = 0.3
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 14
            nameLabel.Parent = billboard
            
            if not espBoxes[plr] then espBoxes[plr] = {} end
            table.insert(espBoxes[plr], highlight)
            table.insert(espBoxes[plr], billboard)
        end)
    end
    
    if plr.Character then createHighlight(plr.Character) end
    if espConnections[plr] then espConnections[plr]:Disconnect() end
    espConnections[plr] = plr.CharacterAdded:Connect(function(char)
        if espEnabled then 
            task.wait(0.3)
            createHighlight(char) 
        end
    end)
end

local function addBotESP(character)
    if not espEnabled or not isBotEnemy(character) then return end
    
    pcall(function()
        local head = character:FindFirstChild("Head")
        if not head then return end
        
        local color = Color3.fromRGB(200, 130, 0)
        
        local highlight = Instance.new("Highlight")
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.85
        highlight.OutlineTransparency = 0.5
        highlight.Adornee = character
        highlight.Parent = character
        
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "Bot"
        nameLabel.TextColor3 = color
        nameLabel.TextStrokeTransparency = 0.3
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
        
        if not espBoxes[character] then espBoxes[character] = {} end
        table.insert(espBoxes[character], highlight)
        table.insert(espBoxes[character], billboard)
        botCharacters[character] = true
    end)
end

local function removeESP(plr)
    if espBoxes[plr] then
        for _, v in pairs(espBoxes[plr]) do
            pcall(function() v:Destroy() end)
        end
        espBoxes[plr] = nil
    end
    if espConnections[plr] then
        espConnections[plr]:Disconnect()
        espConnections[plr] = nil
    end
end

local function updateESPColors()
    for plr, boxes in pairs(espBoxes) do
        if typeof(plr) == "Instance" and plr:IsA("Player") and plr.Character then
            pcall(function()
                local color, isAlly
                if isEnemy(plr) then
                    color = Color3.fromRGB(180, 0, 0)
                    isAlly = false
                else
                    color = Color3.fromRGB(0, 200, 0)
                    isAlly = true
                end
                
                for _, obj in pairs(boxes) do
                    if obj:IsA("Highlight") then
                        obj.FillColor = color
                        obj.OutlineColor = color
                    elseif obj:IsA("BillboardGui") then
                        local label = obj:FindFirstChildOfClass("TextLabel")
                        if label then
                            label.TextColor3 = color
                            label.Text = plr.Name .. (isAlly and " [ALLY]" or "")
                        end
                    end
                end
            end)
        end
    end
end

local function refreshESP()
    for plr, boxes in pairs(espBoxes) do
        if typeof(plr) == "Instance" and plr:IsA("Player") then
            if not plr.Character or not plr.Character:FindFirstChild("Head") then
                removeESP(plr)
            end
        elseif typeof(plr) ~= "Instance" or not plr.Parent then
            espBoxes[plr] = nil
        end
    end
    
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            if plr.Character and plr.Character:FindFirstChild("Head") then
                if not espBoxes[plr] or #espBoxes[plr] == 0 then
                    removeESP(plr)
                    addESP(plr)
                end
            end
        end
    end
    
    for _, char in pairs(workspace:GetChildren()) do
        if isBot(char) and isBotEnemy(char) then
            if not espBoxes[char] or #espBoxes[char] == 0 then
                addBotESP(char)
            end
        end
    end
end

local function enableESP()
    for _, plr in pairs(game.Players:GetPlayers()) do addESP(plr) end
    espConnections.playerAdded = game.Players.PlayerAdded:Connect(function(plr)
        if espEnabled then 
            task.wait(0.5)
            addESP(plr) 
        end
    end)
    espConnections.playerRemoving = game.Players.PlayerRemoving:Connect(function(plr)
        removeESP(plr)
    end)
    espConnections.refresh = RunService.Heartbeat:Connect(function()
        if espEnabled and tick() % 1.5 < 0.016 then
            refreshESP()
        end
    end)
    espConnections.colorUpdate = RunService.Heartbeat:Connect(function()
        if espEnabled and tick() % 0.5 < 0.016 then
            updateESPColors()
        end
    end)
end

local function disableESP()
    for plr, _ in pairs(espBoxes) do removeESP(plr) end
    if espConnections.playerAdded then
        espConnections.playerAdded:Disconnect()
        espConnections.playerAdded = nil
    end
    if espConnections.playerRemoving then
        espConnections.playerRemoving:Disconnect()
        espConnections.playerRemoving = nil
    end
    if espConnections.refresh then
        espConnections.refresh:Disconnect()
        espConnections.refresh = nil
    end
    if espConnections.colorUpdate then
        espConnections.colorUpdate:Disconnect()
        espConnections.colorUpdate = nil
    end
end

local espBtn, espIndicator = createButton("ESP", UDim2.new(0, 12, 0, 52))
local espKeyBox = createKeyBox("J", UDim2.new(0, 162, 0, 52))

local aimbotBtn, aimbotIndicator = createButton("Aimbot", UDim2.new(0, 12, 0, 92))
local aimbotKeyBox = createKeyBox("X", UDim2.new(0, 162, 0, 92))

local autoFireBtn, autoFireIndicator = createButton("Auto Fire", UDim2.new(0, 12, 0, 132))
local autoFireKeyBox = createKeyBox("C", UDim2.new(0, 162, 0, 132))

local maxBtn, maxIndicator = createButton("Max", UDim2.new(0, 12, 0, 172))
local maxKeyBox = createKeyBox("V", UDim2.new(0, 162, 0, 172))

local maxModeLabel = Instance.new("TextLabel")
maxModeLabel.Parent = MainFrame
maxModeLabel.BackgroundTransparency = 1
maxModeLabel.Position = UDim2.new(0, 12, 0, 210)
maxModeLabel.Size = UDim2.new(0, 45, 0, 22)
maxModeLabel.Font = Enum.Font.GothamSemibold
maxModeLabel.Text = "Mode:"
maxModeLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
maxModeLabel.TextSize = 11
maxModeLabel.TextXAlignment = Enum.TextXAlignment.Left

local maxFastBtn = Instance.new("TextButton")
maxFastBtn.Parent = MainFrame
maxFastBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
maxFastBtn.Position = UDim2.new(0, 58, 0, 210)
maxFastBtn.Size = UDim2.new(0, 65, 0, 22)
maxFastBtn.Font = Enum.Font.GothamSemibold
maxFastBtn.Text = "Fast"
maxFastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
maxFastBtn.TextSize = 11
maxFastBtn.BorderSizePixel = 0
maxFastBtn.AutoButtonColor = false

local maxFastCorner = Instance.new("UICorner")
maxFastCorner.CornerRadius = UDim.new(0, 6)
maxFastCorner.Parent = maxFastBtn

local maxSlowBtn = Instance.new("TextButton")
maxSlowBtn.Parent = MainFrame
maxSlowBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
maxSlowBtn.Position = UDim2.new(0, 128, 0, 210)
maxSlowBtn.Size = UDim2.new(0, 65, 0, 22)
maxSlowBtn.Font = Enum.Font.GothamSemibold
maxSlowBtn.Text = "Slow"
maxSlowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
maxSlowBtn.TextSize = 11
maxSlowBtn.BorderSizePixel = 0
maxSlowBtn.AutoButtonColor = false

local maxSlowCorner = Instance.new("UICorner")
maxSlowCorner.CornerRadius = UDim.new(0, 6)
maxSlowCorner.Parent = maxSlowBtn

local noclipBtn, noclipIndicator = createButton("Noclip", UDim2.new(0, 12, 0, 242))
local noclipKeyBox = createKeyBox("N", UDim2.new(0, 162, 0, 242))

local perfBtn, perfIndicator = createButton("Performance", UDim2.new(0, 12, 0, 282))

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        enableESP()
        espIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        disableESP()
        espIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

local function getClosestEnemy()
    local mouse = player:GetMouse()
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local closest = nil
    local shortestDistance = aimbotFOV
    
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and isEnemy(plr) and plr.Character and plr.Character ~= player.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            local head = plr.Character:FindFirstChild("Head")
            
            if humanoid and head and humanoid.Health > 0 then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {player.Character}
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        local result = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, (head.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000, raycastParams)
                        if result and result.Instance:IsDescendantOf(plr.Character) then
                            shortestDistance = distance
                            closest = head
                        end
                    end
                end
            end
        end
    end
    
    for _, char in pairs(workspace:GetChildren()) do
        if char ~= player.Character and isBot(char) and isBotEnemy(char) then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")
            
            if humanoid and head and humanoid.Health > 0 then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {player.Character}
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        local result = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, (head.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000, raycastParams)
                        if result and result.Instance:IsDescendantOf(char) then
                            shortestDistance = distance
                            closest = head
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

local function getClosestEnemyMax()
    local cam = workspace.CurrentCamera
    local closest = nil
    local shortestDistance = math.huge
    
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and isEnemy(plr) and plr.Character and plr.Character ~= player.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            local head = plr.Character:FindFirstChild("Head")
            
            if humanoid and head and humanoid.Health > 0 then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {player.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = workspace:Raycast(cam.CFrame.Position, (head.Position - cam.CFrame.Position).Unit * 1000, raycastParams)
                    if result and result.Instance:IsDescendantOf(plr.Character) then
                        local distance = (cam.CFrame.Position - head.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closest = head
                        end
                    end
                end
            end
        end
    end
    
    for _, char in pairs(workspace:GetChildren()) do
        if char ~= player.Character and isBot(char) and isBotEnemy(char) then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")
            
            if humanoid and head and humanoid.Health > 0 then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {player.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = workspace:Raycast(cam.CFrame.Position, (head.Position - cam.CFrame.Position).Unit * 1000, raycastParams)
                    if result and result.Instance:IsDescendantOf(char) then
                        local distance = (cam.CFrame.Position - head.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closest = head
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

local function isEnemyInCrosshair()
    local cam = workspace.CurrentCamera
    local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local ray = cam:ViewportPointToRay(screenCenter.X, screenCenter.Y)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
    
    if result and result.Instance then
        local hitChar = result.Instance.Parent
        if hitChar == player.Character then return false, nil end
        
        local hitPlayer = game.Players:GetPlayerFromCharacter(hitChar)
        
        if hitPlayer and hitPlayer ~= player and isEnemy(hitPlayer) then
            local humanoid = hitChar:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                return true, hitPlayer
            end
        end
        
        if hitChar ~= player.Character and isBot(hitChar) and isBotEnemy(hitChar) then
            local humanoid = hitChar:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                return true, hitChar
            end
        end
    end
    return false, nil
end

RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        if not player.Character then return end
        
        local cam = workspace.CurrentCamera
        local target = nil
        
        if maxEnabled then
            target = getClosestEnemyMax()
        elseif aimbotEnabled and rightMouseDown then
            target = getClosestEnemy()
        end
        
        if target and target.Parent then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if humanoidRootPart and humanoid then
                local targetPos = target.Position
                local lookVector = (targetPos - cam.CFrame.Position).Unit
                
                cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + lookVector)
                
                if humanoid.AutoRotate == true then
                    local rootPos = humanoidRootPart.Position
                    local targetDirection = Vector3.new(targetPos.X, rootPos.Y, targetPos.Z)
                    humanoidRootPart.CFrame = CFrame.new(rootPos, targetDirection)
                end
            end
        end
    end)
end)

local lastFireTime = 0
local fireDelay = 0.03
local slowFireDelay = 0.15
local isFiring = false

local mouse1press = mouse1press or mouse1click or function() end
local mouse1release = mouse1release or function() end
local setfpscap = setfpscap or function() end

RunService.Heartbeat:Connect(function()
    pcall(function()
        local currentTime = tick()
        local currentDelay = (maxEnabled and maxSlowMode) and slowFireDelay or fireDelay
        
        if (maxEnabled or autoFireEnabled) and not isFiring then
            local hasEnemy, enemyPlayer = isEnemyInCrosshair()
            
            if hasEnemy and (currentTime - lastFireTime) >= currentDelay then
                isFiring = true
                lastFireTime = currentTime
                
                task.spawn(function()
                    pcall(function()
                        if mouse1press then
                            mouse1press()
                            task.wait(0.02)
                            if mouse1release then
                                mouse1release()
                            end
                        end
                        task.wait(0.01)
                        isFiring = false
                    end)
                end)
            end
        end
    end)
end)

aimbotBtn.MouseButton1Click:Connect(function()
    if maxEnabled then return end
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        aimbotIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        aimbotIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

autoFireBtn.MouseButton1Click:Connect(function()
    if maxEnabled then return end
    autoFireEnabled = not autoFireEnabled
    if autoFireEnabled then
        autoFireIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        autoFireIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

maxBtn.MouseButton1Click:Connect(function()
    maxEnabled = not maxEnabled
    if maxEnabled then
        aimbotEnabled = false
        autoFireEnabled = false
        aimbotIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        autoFireIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        maxIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        maxIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

maxFastBtn.MouseButton1Click:Connect(function()
    maxSlowMode = false
    maxFastBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
    maxSlowBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
end)

maxSlowBtn.MouseButton1Click:Connect(function()
    maxSlowMode = true
    maxFastBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    maxSlowBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        noclipIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

rejoinBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

local lighting = game:GetService("Lighting")
local originalSettings = {}
local originalTextures = {}

perfBtn.MouseButton1Click:Connect(function()
    perfEnabled = not perfEnabled
    pcall(function()
        if perfEnabled then
            perfIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
            
            originalSettings.Brightness = lighting.Brightness
            originalSettings.GlobalShadows = lighting.GlobalShadows
            originalSettings.OutdoorAmbient = lighting.OutdoorAmbient
            originalSettings.Ambient = lighting.Ambient
            
            lighting.Brightness = 2
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            lighting.Ambient = Color3.fromRGB(128, 128, 128)
            
            for _, obj in pairs(lighting:GetChildren()) do
                if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") then
                    obj.Enabled = false
                end
            end
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    originalTextures[obj] = {Enabled = obj.Enabled}
                    obj.Enabled = false
                elseif obj:IsA("BasePart") and not obj.Parent:IsA("Model") or (obj.Parent:IsA("Model") and not game.Players:GetPlayerFromCharacter(obj.Parent)) then
                    if obj:IsA("MeshPart") then
                        originalTextures[obj] = {TextureID = obj.TextureID}
                        obj.TextureID = ""
                    elseif obj:IsA("Part") or obj:IsA("WedgePart") or obj:IsA("CornerWedgePart") then
                        for _, decal in pairs(obj:GetChildren()) do
                            if decal:IsA("Decal") or decal:IsA("Texture") then
                                originalTextures[decal] = {Transparency = decal.Transparency}
                                decal.Transparency = 1
                            end
                        end
                    end
                end
            end
            
            if setfpscap then setfpscap(999) end
        else
            perfIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            
            lighting.Brightness = originalSettings.Brightness or 1
            lighting.GlobalShadows = originalSettings.GlobalShadows or true
            lighting.OutdoorAmbient = originalSettings.OutdoorAmbient or Color3.fromRGB(70, 70, 70)
            lighting.Ambient = originalSettings.Ambient or Color3.fromRGB(70, 70, 70)
            
            for _, obj in pairs(lighting:GetChildren()) do
                if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") then
                    obj.Enabled = true
                end
            end
            
            for obj, data in pairs(originalTextures) do
                if obj:IsA("MeshPart") then
                    obj.TextureID = data.TextureID
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = data.Transparency
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = data.Enabled
                end
            end
            originalTextures = {}
            
            if setfpscap then setfpscap(60) end
        end
    end)
end)

local originalCollisions = {}

RunService.Stepped:Connect(function()
    pcall(function()
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if noclipEnabled then
                        if originalCollisions[part] == nil then
                            originalCollisions[part] = part.CanCollide
                        end
                        part.CanCollide = false
                    else
                        if originalCollisions[part] ~= nil then
                            part.CanCollide = originalCollisions[part]
                            originalCollisions[part] = nil
                        end
                    end
                end
            end
        end
    end)
end)

espKeyBox.FocusLost:Connect(function()
    local text = espKeyBox.Text:upper()
    local success, key = pcall(function() return Enum.KeyCode[text] end)
    if success and key then
        espKey = key
        espKeyBox.Text = text
    else
        espKeyBox.Text = "J"
        espKey = Enum.KeyCode.J
    end
end)

aimbotKeyBox.FocusLost:Connect(function()
    local text = aimbotKeyBox.Text:upper()
    local success, key = pcall(function() return Enum.KeyCode[text] end)
    if success and key then
        aimbotKey = key
        aimbotKeyBox.Text = text
    else
        aimbotKeyBox.Text = "X"
        aimbotKey = Enum.KeyCode.X
    end
end)

autoFireKeyBox.FocusLost:Connect(function()
    local text = autoFireKeyBox.Text:upper()
    local success, key = pcall(function() return Enum.KeyCode[text] end)
    if success and key then
        autoFireKey = key
        autoFireKeyBox.Text = text
    else
        autoFireKeyBox.Text = "C"
        autoFireKey = Enum.KeyCode.C
    end
end)

maxKeyBox.FocusLost:Connect(function()
    local text = maxKeyBox.Text:upper()
    local success, key = pcall(function() return Enum.KeyCode[text] end)
    if success and key then
        maxKey = key
        maxKeyBox.Text = text
    else
        maxKeyBox.Text = "V"
        maxKey = Enum.KeyCode.V
    end
end)

noclipKeyBox.FocusLost:Connect(function()
    local text = noclipKeyBox.Text:upper()
    local success, key = pcall(function() return Enum.KeyCode[text] end)
    if success and key then
        noclipKey = key
        noclipKeyBox.Text = text
    else
        noclipKeyBox.Text = "N"
        noclipKey = Enum.KeyCode.N
    end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        rightMouseDown = true
        return
    end
    
    if gameProcessed then return end
    
    if input.KeyCode == toggleKey then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == espKey then
        espEnabled = not espEnabled
        if espEnabled then
            enableESP()
            espIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        else
            disableESP()
            espIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        end
    elseif input.KeyCode == aimbotKey then
        if maxEnabled then return end
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            aimbotIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        else
            aimbotIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        end
    elseif input.KeyCode == autoFireKey then
        if maxEnabled then return end
        autoFireEnabled = not autoFireEnabled
        if autoFireEnabled then
            autoFireIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        else
            autoFireIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        end
    elseif input.KeyCode == maxKey then
        maxEnabled = not maxEnabled
        if maxEnabled then
            aimbotEnabled = false
            autoFireEnabled = false
            aimbotIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            autoFireIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            maxIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        else
            maxIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        end
    elseif input.KeyCode == noclipKey then
        noclipEnabled = not noclipEnabled
        if noclipEnabled then
            noclipIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        else
            noclipIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        rightMouseDown = false
    end
end)

pcall(function()
    ScreenGui.Parent = guiParent
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

pcall(function()
    print("[Universal] Carregado! Z=Menu J=ESP X=Aimbot C=AutoFire V=Max N=Noclip | Aimbot: Segure BOTAO DIREITO")
end)
