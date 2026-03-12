local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local UIS=game:GetService("UserInputService")

if not LocalPlayer then return end

local SG=Instance.new("ScreenGui")
local F=Instance.new("Frame")
local B=Instance.new("TextButton")

SG.Name="AutoDig"
SG.Parent=LocalPlayer.PlayerGui

F.Parent=SG
F.Size=UDim2.new(0,200,0,100)
F.Position=UDim2.new(0.5,-100,0.5,-50)
F.BackgroundColor3=Color3.fromRGB(50,50,50)

B.Parent=F
B.Size=UDim2.new(1,-20,0.5,-10)
B.Position=UDim2.new(0.5,-90,0.5,20)
B.BackgroundColor3=Color3.fromRGB(0,128,255)
B.Text="Auto Dig: OFF"

local AD=false
local DD=0.5
local ST=true
local RD=true
local MRD=0.2
local MDT=3600
local DC=5
local t=os.time()
local cc=0
local M=LocalPlayer:GetMouse()

local function cC()
    local c=LocalPlayer.Character
    return c and c:FindFirstChild("Humanoid") and c.Humanoid.MoveDirection~=Vector3.new(0,0,0) or false
end

local function gRD()
    return RD and math.random()*MRD or 0
end

local function sAD()
    while AD do
        wait(DD+gRD())
        if os.time()-t>MDT then break end
        if cc>=DC then break end
        if ST and cC() then break end
        if ST and LocalPlayer.Character then
            local t=LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if t then pcall(function() t.ClickOn.Click:FireServer() end) cc=cc+1 end
        else M.Button1Down:Connect(function() M.ClickOn() end) end
    end
end

B.MouseButton1Click:connect(function()
    AD=not AD
    B.Text="Auto Dig: "..(AD and "ON" or "OFF")
    if AD then t=os.time() cc=0 spawn(sAD) end
end)

UIS.InputBegan:connect(function(i)
    if i.KeyCode==Enum.KeyCode.Escape then AD=false B.Text="Auto Dig: OFF" end
end)
