local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local UIS=game:GetService("UserInputService")

if not LocalPlayer then return end

-- Создаем GUI
local SG=Instance.new("ScreenGui")
local MainMenu=Instance.new("Frame")
local ToggleDig=Instance.new("TextButton")
local ToggleSell=Instance.new("TextButton")
local CloseBtn=Instance.new("TextButton")

SG.Name="MobileMenu"
SG.Parent=LocalPlayer.PlayerGui
SG.ResetOnSpawn=false

MainMenu.Parent=SG
MainMenu.Size=UDim2.new(0,250,0,300)
MainMenu.Position=UDim2.new(0.5,-125,0.5,-150)
MainMenu.BackgroundColor3=Color3.fromRGB(30,30,30)
MainMenu.BorderSizePixel=0
MainMenu.Visible=false

-- Кнопка копания
ToggleDig.Parent=MainMenu
ToggleDig.Size=UDim2.new(1,0,0.33,0)
ToggleDig.Position=UDim2.new(0,0,0,0)
ToggleDig.BackgroundColor3=Color3.fromRGB(0,128,255)
ToggleDig.Text="Auto Dig: OFF"
ToggleDig.TextSize=20

-- Кнопка продажи
ToggleSell.Parent=MainMenu
ToggleSell.Size=UDim2.new(1,0,0.33,0)
ToggleSell.Position=UDim2.new(0,0,0.33,0)
ToggleSell.BackgroundColor3=Color3.fromRGB(255,128,0)
ToggleSell.Text="Auto Sell: OFF"
ToggleSell.TextSize=20

-- Кнопка закрытия
CloseBtn.Parent=MainMenu
CloseBtn.Size=UDim2.new(1,0,0.33,0)
CloseBtn.Position=UDim2.new(0,0,0.66,0)
CloseBtn.BackgroundColor3=Color3.fromRGB(255,0,0)
CloseBtn.Text="Close Menu"
CloseBtn.TextSize=20

local AD=false
local AS=false
local DD=0.5

-- Авто-копание
local function autoDig()
    while AD do
        wait(DD)
        if LocalPlayer.Character then
            local tool=LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then 
                pcall(function() 
                    tool.ClickOn:FireServer()
                    tool.Activate:FireServer()
                end) 
            end
        end
    end
end

-- Авто-продажа
local function autoSell()
    while AS do
        wait(1)
        if LocalPlayer.PlayerGui:FindFirstChild("Shop") then
            local shop=LocalPlayer.PlayerGui.Shop
            if shop then
                pcall(function()
                    shop.SellAll:FireServer()
                end)
            end
        end
    end
end

-- Открытие меню по нажатию
UIS.InputBegan:Connect(function(input)
    if input.KeyCode==Enum.KeyCode.E then
        MainMenu.Visible=not MainMenu.Visible
    end
end)

-- Закрытие меню
CloseBtn.MouseButton1Click:Connect(function()
    MainMenu.Visible=false
    AD=false
    AS=false
    ToggleDig.Text="Auto Dig: OFF"
    ToggleSell.Text="Auto Sell: OFF"
end)

-- Включение авто-копания
ToggleDig.MouseButton1Click:Connect(function()
    AD=not AD
    ToggleDig.Text="Auto Dig: "..(AD and "ON" or "OFF")
    if AD then 
        spawn(autoDig) 
    end
end)

-- Включение авто-продажи
ToggleSell.MouseButton1Click:Connect(function()
    AS=not AS
    ToggleSell.Text="Auto Sell: "..(AS and "ON" or "OFF")
    if AS then 
        spawn(autoSell) 
    end
end)
