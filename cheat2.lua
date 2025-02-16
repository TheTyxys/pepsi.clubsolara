local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

Library:Notify('Loading UI...')
wait(3)

local Window = Library:CreateWindow({
    Title = 'pepsi.club',
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    Legitbot = Window:AddTab('Aimbot'), 
    Visuals = Window:AddTab('Visuals'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('Settings'),
}

local AimbotSec1 = Tabs.Legitbot:AddLeftGroupbox('Bullet Redirection')
local AimbotSec2 = Tabs.Legitbot:AddRightGroupbox('Aim Assist')

local ESPTabbox = Tabs.Visuals:AddLeftTabbox()
local ESPTab  = ESPTabbox:AddTab('ESP')
local ESPSTab = Tabs.Visuals:AddLeftGroupbox('ESP Settings')
local LocalTab = ESPTabbox:AddTab('Local')

local CameraTabbox = Tabs.Visuals:AddRightTabbox()
local CamTab  = CameraTabbox:AddTab('Client')
local VWTab = CameraTabbox:AddTab('Viewmodel')

local MiscTabbox = Tabs.Visuals:AddRightTabbox()
local WRLTab  = MiscTabbox:AddTab('World')
local MiscTab  = MiscTabbox:AddTab('Misc')
local ArmsTab = MiscTabbox:AddTab('Self')
local BulletsTab = MiscTabbox:AddTab('Bullet')
local MiscESPTab = Tabs.Visuals:AddLeftGroupbox('Misc ESP')

local MiscSec1 = Tabs.Misc:AddLeftGroupbox('Main')
local MiscSec2 = Tabs.Misc:AddLeftGroupbox('Movement')
local MiscSec3 = Tabs.Misc:AddRightGroupbox('Tweaks')
local MiscSec4 = Tabs.Misc:AddRightGroupbox('Hit')
local MiscSec5 = Tabs.Misc:AddRightGroupbox('Others')
local MiscSec6 = Tabs.Misc:AddLeftGroupbox('Gun Mods')

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- Пример добавления переключателя для Bhop
MiscSec2:AddToggle('mov_bhop', {
    Text = 'Bhop',
    Default = false,
    Tooltip = 'Автоматический прыжок при удержании пробела.',
})

-- Пример добавления выпадающего списка для Hit Sound
MiscSec4:AddDropdown('hit_hitsoundtype', {
    Values = {'Bameware', 'Bell', 'Bubble', 'Pick', 'Pop', 'Rust', 'Skeet', 'Neverlose', 'Minecraft'},
    Default = 1,
    Multi = false,
    Text = 'Hit Sound Type',
})

-- Пример добавления кнопки для сброса настроек
MenuGroup:AddButton('Reset Settings', function()
    Library:ResetConfiguration()
end)

local bhopEnabled = false
MiscSec2:GetToggle('mov_bhop'):OnChanged(function()
    bhopEnabled = not bhopEnabled
end)

local function Bhop()
    if bhopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Humanoid = LocalPlayer.Character.Humanoid
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

RunService.Heartbeat:Connect(function()
    Bhop()
end)

local watermark = Instance.new("ScreenGui")
local ScreenLabel = Instance.new("Frame")
local WatermarkColor = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local Container = Instance.new("Frame")
local UIPadding = Instance.new("UIPadding")
local Text = Instance.new("TextLabel")
local Background = Instance.new("Frame")

watermark.Name = "watermark"
watermark.Parent = game.CoreGui
watermark.Enabled = false

ScreenLabel.Name = "ScreenLabel"
ScreenLabel.Parent = watermark
ScreenLabel.BackgroundColor3 = C3(28, 28, 28)
ScreenLabel.BackgroundTransparency = 1.000
ScreenLabel.BorderColor3 = C3(20, 20, 20)
ScreenLabel.Position = UDim2.new(0, 12, 0, 7)
ScreenLabel.Size = UDim2.new(0, 260, 0, 20)

WatermarkColor.Name = "Color"
WatermarkColor.Parent = ScreenLabel
WatermarkColor.BackgroundColor3 = C3(0, 89, 149)
WatermarkColor.BorderSizePixel = 0
WatermarkColor.Size = UDim2.new(0.534260333, 0, 0, 2)
WatermarkColor.ZIndex = 2

UIGradient.Color = CNew{ColorSequenceKeypoint.new(0.00, C3(255, 255, 255)), ColorSequenceKeypoint.new(1.00, C3(60, 60, 60))}
UIGradient.Rotation = 90
UIGradient.Parent = WatermarkColor

Container.Name = "Container"
Container.Parent = ScreenLabel
Container.BackgroundTransparency = 1.000
Container.BorderSizePixel = 0
Container.Position = UDim2.new(0, 0, 0, 4)
Container.Size = UDim2.new(1, 0, 0, 14)
Container.ZIndex = 3

UIPadding.Parent = Container
UIPadding.PaddingLeft = UDim.new(0, 4)

Text.Name = "Text"
Text.Parent = Container
Text.BackgroundTransparency = 1.000
Text.Position = UDim2.new(0.0230768919, 0, 0, 0)
Text.Size = UDim2.new(0.48046875, 0, 1, 0)
Text.ZIndex = 4
Text.Font = Enum.Font.RobotoMono
Text.Text = "pepsi.club | user"
Text.TextColor3 = C3(65025, 65025, 65025)
Text.TextSize = 14.000
Text.TextStrokeTransparency = 0.000
Text.TextXAlignment = Enum.TextXAlignment.Left

Background.Name = "Background"
Background.Parent = ScreenLabel
Background.BackgroundColor3 = C3(23, 23, 23)
Background.BorderColor3 = C3(20, 20, 20)
Background.Size = UDim2.new(0.534260333, 0, 1, 0)

local aimbotEnabled = false
local bulletRedirectionEnabled = false

AimbotSec1:AddToggle('aim_bulletredirection', {
    Text = 'Bullet Redirection',
    Default = false,
    Tooltip = 'Перенаправление пуль в сторону врага.',
})

AimbotSec2:AddToggle('aim_aimbot', {
    Text = 'Aim Assist',
    Default = false,
    Tooltip = 'Автоматическое наведение на врага.',
})

AimbotSec1:GetToggle('aim_bulletredirection'):OnChanged(function()
    bulletRedirectionEnabled = not bulletRedirectionEnabled
end)

AimbotSec2:GetToggle('aim_aimbot'):OnChanged(function()
    aimbotEnabled = not aimbotEnabled
end)

local function Aimbot()
    if aimbotEnabled then
        -- Ваш код для Aimbot
    end
end

local function BulletRedirection()
    if bulletRedirectionEnabled then
        -- Ваш код для Bullet Redirection
    end
end

RunService.Heartbeat:Connect(function()
    Aimbot()
    BulletRedirection()
end)

local espEnabled = false

ESPTab:AddToggle('esp_enabled', {
    Text = 'ESP',
    Default = false,
    Tooltip = 'Включение ESP.',
})

ESPTab:GetToggle('esp_enabled'):OnChanged(function()
    espEnabled = not espEnabled
end)

local function ESP()
    if espEnabled then
        -- Ваш код для ESP
    end
end

RunService.Heartbeat:Connect(function()
    ESP()
end)

local hitSoundEnabled = false
local hitSoundType = 'Bameware'

MiscSec4:AddToggle('hit_hitsound', {
    Text = 'Hit Sound',
    Default = false,
    Tooltip = 'Включение звука при попадании.',
})

MiscSec4:GetToggle('hit_hitsound'):OnChanged(function()
    hitSoundEnabled = not hitSoundEnabled
end)

MiscSec4:GetDropdown('hit_hitsoundtype'):OnChanged(function(value)
    hitSoundType = value
end)

local function PlayHitSound()
    if hitSoundEnabled then
        -- Ваш код для воспроизведения звука в зависимости от hitSoundType
    end
end

RunService.Heartbeat:Connect(function()
    PlayHitSound()
end)

local watermarkEnabled = false

MenuGroup:AddToggle('ui_watermark', {
    Text = 'Watermark',
    Default = false,
    Tooltip = 'Включение водяного знака.',
})

MenuGroup:GetToggle('ui_watermark'):OnChanged(function()
    watermarkEnabled = not watermarkEnabled
    watermark.Enabled = watermarkEnabled
end)

MenuGroup:AddButton('Reset Settings', function()
    Library:ResetConfiguration()
    -- Сброс всех переменных
    bhopEnabled = false
    aimbotEnabled = false
    bulletRedirectionEnabled = false
    espEnabled = false
    hitSoundEnabled = false
    watermarkEnabled = false
    watermark.Enabled = false
end)
