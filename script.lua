-- Script settings
local clickDelay = 0.01 -- Delay between clicks (in seconds)
local running = false   -- Script running flag
local menuOpen = false  -- Menu visibility flag
local selling = false   -- Selling flag

-- Create GUI elements
local gui = Instance.new("ScreenGui")
local mainMenu = Instance.new("Frame")
local toggleButton = Instance.new("TextButton")
local sellButton = Instance.new("TextButton")  -- Новая кнопка для автоселла
local closeButton = Instance.new("TextButton")
local openMenuButton = Instance.new("TextButton")

-- Initialize GUI
gui.Name = "AutoClickMenu"
gui.Parent = game:GetService("CoreGui")

mainMenu.Parent = gui
mainMenu.Size = UDim2.new(0, 250, 0, 300)
mainMenu.Position = UDim2.new(0.5, -125, 0.5, -150)
mainMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainMenu.BorderSizePixel = 0
mainMenu.Visible = false

-- Кнопка открытия меню
openMenuButton.Parent = gui
openMenuButton.Size = UDim2.new(0, 100, 0, 50)
openMenuButton.Position = UDim2.new(0.5, -50, 0.9, 0)
openMenuButton.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
openMenuButton.Text = "Open Menu"
openMenuButton.TextSize = 20
openMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Кнопка автоклика
toggleButton.Parent = mainMenu
toggleButton.Size = UDim2.new(1, 0, 0.3, 0)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toggleButton.Text = "Auto Click: OFF"
toggleButton.TextSize = 20
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Новая кнопка автоселла
sellButton.Parent = mainMenu
sellButton.Size = UDim2.new(1, 0, 0.3, 0)
sellButton.Position = UDim2.new(0, 0, 0.3, 0)
sellButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
sellButton.Text = "Auto Sell: OFF"
sellButton.TextSize = 20
sellButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Кнопка закрытия
closeButton.Parent = mainMenu
closeButton.Size = UDim2.new(1, 0, 0.1, 0)
closeButton.Position = UDim2.new(0, 0, 0.8, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "Close Menu"
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Функция автоклика
local function toggleClick()
    running = not running
    if running then
        print("Auto click enabled")
        spawn(function()
            while running do
                wait(clickDelay)
                game:GetService("VirtualUser"):Click()
            end
        end)
    else
        print("Auto click disabled")
    end
    toggleButton.Text = "Auto Click: " .. (running and "ON" or "OFF")
end

-- Функция автоселла
local function toggleSell()
    selling = not selling
    if selling then
        print("Auto sell enabled")
        spawn(function()
            while selling do
                wait(1)
                pcall(function()
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Packages")
                        :Wait
