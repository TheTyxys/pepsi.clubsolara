local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'pepsi.club',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    Misc = Window:AddTab('Misc'),
    Settings = Window:AddTab('Settings'),
}

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local currentCamera = workspace.CurrentCamera

-- Безопасные функции
local function IsAlive(plr)
    return plr and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
end

local function CreateNotification(title, text)
    Library:Notify(title, text)
end

-- ESP
local espSettings = {
    enabled = false,
    teamCheck = true,
    box = true,
    name = true,
    health = true,
}

local function DrawESP(player)
    if not espSettings.enabled or not IsAlive(player) then return end

    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")

    if humanoidRootPart and head then
        local position, onScreen = currentCamera:WorldToViewportPoint(humanoidRootPart.Position)
        if onScreen then
            -- Рисуем ESP (безопасно, без хуков)
            local size = (currentCamera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0)).Y - currentCamera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
            local boxSize = Vector2.new(math.floor(size * 1.5), math.floor(size * 1.9))
            local boxPos = Vector2.new(math.floor(position.X - size * 1.5 / 2), math.floor(position.Y - size * 1.6 / 2))

            if espSettings.box then
                -- Рисуем рамку
                local box = Drawing.new("Square")
                box.Visible = true
                box.Color = Color3.new(1, 1, 1)
                box.Size = boxSize
                box.Position = boxPos
                box.Thickness = 1
                box.Filled = false
                box.ZIndex = 10
            end

            if espSettings.name then
                -- Рисуем имя игрока
                local name = Drawing.new("Text")
                name.Visible = true
                name.Text = player.Name
                name.Color = Color3.new(1, 1, 1)
                name.Size = 13
                name.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y - 16)
                name.Center = true
                name.Outline = true
                name.ZIndex = 10
            end

            if espSettings.health then
                -- Рисуем здоровье
                local health = Drawing.new("Text")
                health.Visible = true
                health.Text = "HP: " .. math.floor(character.Humanoid.Health)
                health.Color = Color3.new(0, 1, 0)
                health.Size = 13
                health.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 5)
                health.Center = true
                health.Outline = true
                health.ZIndex = 10
            end
        end
    end
end

-- Bunny Hop (Bhop)
local bhopEnabled = false
local bhopSpeed = 25

local function BunnyHop()
    if bhopEnabled and IsAlive(localPlayer) and userInput:IsKeyDown(Enum.KeyCode.Space) then
        localPlayer.Character.Humanoid.Jump = true
        local dir = currentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
        local move = Vector3.new()

        if userInput:IsKeyDown(Enum.KeyCode.W) then move = move + dir end
        if userInput:IsKeyDown(Enum.KeyCode.S) then move = move - dir end
        if userInput:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(-dir.Z, 0, dir.X) end
        if userInput:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(dir.Z, 0, -dir.X) end

        if move.Magnitude > 0 then
            move = move.Unit
            localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(move.X * bhopSpeed, localPlayer.Character.HumanoidRootPart.Velocity.Y, move.Z * bhopSpeed)
        end
    end
end

-- Edgebug (безопасная реализация)
local ebCooldown = false
local oldState = Enum.HumanoidStateType.None
local ebenabled = false

local function Edgebug()
    if IsAlive(localPlayer) then
        local humanoid = localPlayer.Character.Humanoid
        local currentState = humanoid:GetState()

        if ebenabled and not ebCooldown and userInput:IsKeyDown(Enum.KeyCode.E) then
            if oldState == Enum.HumanoidStateType.Freefall and currentState == Enum.HumanoidStateType.Landed then
                ebCooldown = true

                -- Изменение скорости персонажа
                localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) -- Подбрасываем персонажа вверх

                -- Воспроизведение звука (безопасно)
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://6887181639" -- Пример звука
                sound.Parent = localPlayer.Character.HumanoidRootPart
                sound:Play()

                -- Сообщение в чат (безопасно)
                game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer("Edgebug!", false, false, false, true)

                -- Сброс кулдауна
                task.delay(1, function()
                    ebCooldown = false
                end)
            end
        end

        oldState = currentState
    end
end

-- Основной цикл
runService.RenderStepped:Connect(function()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            DrawESP(player)
        end
    end

    BunnyHop()
    Edgebug()
end)

-- Настройки интерфейса
Tabs.Main:AddToggle('esp_enabled', { Text = 'Enable ESP', Default = false, Callback = function(value) espSettings.enabled = value end })
Tabs.Main:AddToggle('bhop_enabled', { Text = 'Enable Bhop', Default = false, Callback = function(value) bhopEnabled = value end })
Tabs.Main:AddToggle('edgebug_enabled', { Text = 'Enable Edgebug', Default = false, Callback = function(value) ebenabled = value end })

Tabs.Settings:AddButton('Unload', function()
    Library:Unload()
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('pepsi.club')
SaveManager:SetFolder('pepsi.club/main')

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

CreateNotification('Script Loaded', 'Welcome to pepsi.club!')
