local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local UserInputService = game:GetService("UserInputService")
local language = "en"
local censorship = "True"

local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/AbstractPoo/Main/main/Notifications.lua", true))()


_G.BreakAPI=false --// don't touch this

_G.Cooldown=false

local utf8 = {
    ["A"] = 0x41,
    ["B"] = 0x42,
    ["C"] = 0x43,
    ["D"] = 0x44,
    ["E"] = 0x45,
    ["F"] = 0x46,
    ["G"] = 0x47,
    ["H"] = 0x48,
    ["I"] = 0x49,
    ["J"] = 0x4A,
    ["K"] = 0x4B,
    ["L"] = 0x4C,
    ["M"] = 0x4D,
    ["N"] = 0x4E,
    ["O"] = 0x4F,
    ["P"] = 0x50,
    ["Q"] = 0x51,
    ["R"] = 0x52,
    ["S"] = 0x53,
    ["T"] = 0x54,
    ["U"] = 0x55,
    ["V"] = 0x56,
    ["W"] = 0x57,
    ["X"] = 0x58,
    ["Y"] = 0x59,
    ["Z"] = 0x5A,
    ["."] = 0xBE,
    ["0"] = 0x30,
    ["1"] = 0x31,
    ["2"] = 0x32,
    ["3"] = 0x33,
    ["4"] = 0x34,
    ["5"] = 0x35,
    ["6"] = 0x36,
    ["7"] = 0x37,
    ["8"] = 0x38,
    ["9"] = 0x39,
    [" "] = 0x20,
    ["-"] = 0xBD,
    ["+"] = 0xBB,
    [","] = 0xBC, 
    ["~"] = 0xC0,
    ['"'] = 0xDE,
}

local isTyping = false

function Type(str)
    if not isTyping then
        local split = string.split(str, "")
        isTyping = true
        if split then
            for _,key in pairs(split) do wait(.02)
                if utf8[string.upper(key)] then
                    keypress(utf8[string.upper(key)]);
                end 
            end
            wait(.3)
            keypress(0x0D);
            isTyping=false
        else 
            error("[TypeError]: No String provided or split errored.")
        end
    end
end

local Player = Players.LocalPlayer

activated=false
function ChatAPI()
    if _G.BreakAPI then _G.BreakAPI=false end
    if not activated then activated=true elseif activated then warn("already on") return end
    local function request(msg)
        local text = msg
        --chat("Chat API:".."\n".."Could not create responce")
        local request;
        pcall(function()
            request = game:HttpGet("https://api.simsimi.net/v2/?text="..text.."&lc="..language.."&cf="..censorship)
        end)
        if (not request) then warn("bad request") return end
        local Responce = game:HttpGet("https://api.simsimi.net/v2/?text="..text.."&lc="..language.."&cf="..censorship)
        local data = HttpService:JSONDecode(Responce)
        _G.Cooldown=true
        task.wait(.5)
        keypress(0x6F)
        task.wait(.5)
        Type(data.success);
        task.wait(.3)
        _G.Cooldown=false
        --game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(data.success, "All")
    end
    local con
    con = Players.PlayerChatted:Connect(function(type, plr, message)
        task.spawn(function()
            if _G.Cooldown then return end
            if _G.BreakAPI then con:Disconnect() return end
            if plr == Player then return end
            if not plr.Character or not Player.Character then return end
            if (Player.Character and plr.Character) and (Player.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("HumanoidRootPart")) and ((plr.Character["HumanoidRootPart"].CFrame.Position - Player.Character["HumanoidRootPart"].CFrame.Position).Magnitude <= 10) then
                request(message)
            end
            --if plr.Name ~= game.Players.LocalPlayer.Name then
                --[[for i,v in pairs(workspace:GetChildren()) do
                    local hum = v:FindFirstChildOfClass("Humanoid")
                    if hum and v:FindFirstChild("Head") and v.Name ~= game.Players.LocalPlayer.Name then
                        pcall(function()
                            if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                                if game.Players[v.Name].Chatted ~= nil then
                                    request(game.Players[v.Name].Chatted)
                                end
                            end
                        end)
                    end
                end
                -for _,plrs in pairs(game.Players:GetPlayers()) do
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - plrs.Character:WaitForChild("HumanoidRootPart").Position).magnitude <= 15 then
                        if plr.Name == plrs.Name then
                            request(message) 
                        end
                    end
                end]]
            --end
        end)
    end)
end

ChatAPI()

local mouse = game.Players.LocalPlayer:GetMouse()
mouse.KeyDown:Connect(function(k)
    if k == "z" then
        if not _G.BreakAPI then
            NotificationHolder:message {Title = "<font color='rgb(255,0,0)'>Disabled</font>",Description = "Chat API Disabled",Icon = 10952973354}
            _G.BreakAPI=true
            activated=false
            warn("API TURNED OFF")
        elseif _G.BreakAPI then
            NotificationHolder:message {Title = "<font color='rgb(0,255,0)'>Enabled</font>",Description = "Chat API Enabled",Icon = 10952973354}
            ChatAPI()
            _G.BreakAPI=false
            warn("CHAT API TURNED ON")
        end
    end
end)
