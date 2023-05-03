local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/dizyhvh/test_scripts/main/2.lua')))();

local gui = library:NewGui();
local tab1 = gui:NewTab("Main");

local game_settings = require(game:GetService("ReplicatedStorage"):FindFirstChild("Shared"):FindFirstChild("GameSettings"));
local throw_event = game:GetService("ReplicatedStorage"):FindFirstChild("Remote"):FindFirstChild("Bomb"):FindFirstChild("BombThrow");

getgenv().AutoTrain = false;
getgenv().AutoBomb = false;
getgenv().TPtoMine = false;
getgenv().BombQuantity = 1;
getgenv().AutoWin = false;
getgenv().AutoRebirth = false;
getgenv().Optimization = false;

local auto_bomb_opt1 = nil;
local auto_bomb_opt2 = nil;

local auto_rebirth_con = nil;

-- < functions > 

local function throw_bomb(quantity, position)
    assert(tonumber(quantity) ~= nil, "expected a number, got nil (throw bomb func)");
    assert(position ~= nil, "expected a vector3, got nil (throw bomb func)");
    
    for i=1, quantity do
        if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb"):FindFirstChild("Primary") == nil then
            return;
        end
        
        throw_event:Fire(game:GetService("Players").LocalPlayer, game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb"):FindFirstChild("Primary"), position, (Vector3.new(0, 0, 0)));
        if getgenv().Optimization then task.wait(); end
    end
end

-- < ui >

tab1:NewCheckbox("Auto Train", function(bool)
    getgenv().AutoTrain = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if not getgenv().AutoTrain then
                    coroutine.yield();
                end
                
                if getgenv().AutoBomb or game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb"):FindFirstChild("Primary") == nil then
                    continue;
                end
                    
                local nearest_trainer = nil;
                local distance = 30;
                    
                for _,world in pairs(game:GetService("Workspace"):FindFirstChild("World"):GetChildren()) do
                    if world:IsA("Folder") then
                        for _,trainer in pairs(world:FindFirstChild("Train"):GetChildren()) do
                            if trainer:IsA("Model") and trainer:FindFirstChild("Primary") ~= nil and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-trainer:FindFirstChild("Primary").Position).Magnitude < distance then
                                nearest_trainer = trainer:FindFirstChild("Primary");
                                distance = (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-trainer:FindFirstChild("Primary").Position).Magnitude;
                            end
                        end
                    end
                end
                    
                if nearest_trainer ~= nil then
                    throw_bomb(getgenv().BombQuantity, nearest_trainer.Position);
                end
            end
        end))
    end
end)

tab1:NewCheckbox("Auto Bomb", function(bool)
    getgenv().AutoBomb = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if not getgenv().AutoBomb then
                    coroutine.yield();
                end
                
                if getgenv().AutoTrain or game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb"):FindFirstChild("Primary") == nil then
                    continue;
                end
                    
                local nearest_block = nil;
                local distance = getgenv().TPtoMine and 100 or 30;
                    
                for _,world in pairs(game:GetService("Workspace"):FindFirstChild("Mine"):GetChildren()) do
                    if world:IsA("Folder") then
                        for _,block in pairs(world:FindFirstChild("Block"):GetChildren()) do
                            if block:IsA("BasePart") and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-block.Position).Magnitude < distance then
                                nearest_block = block;
                                distance = (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-block.Position).Magnitude;
                            end
                        end
                    end
                end
                    
                if nearest_block ~= nil then
                    if getgenv().TPtoMine then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(nearest_block.CFrame.X+math.random(), nearest_block.CFrame.Y+7.85, nearest_block.CFrame.Z);
                    end
                    
                    throw_bomb(getgenv().BombQuantity, nearest_block.Position);
                end
            end
        end))
    end
end)

tab1:NewSlider("Bomb Quantity", 1, 100, true, function(value)
    getgenv().BombQuantity = value;
end)

tab1:NewCheckbox("Auto TP to Mine", function(bool)
    getgenv().TPtoMine = bool;
end)

tab1:NewCheckbox("Auto Win", function(bool)
    getgenv().AutoWin = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while task.wait() do
                if not getgenv().AutoWin then
                    coroutine.yield();
                end
                
                if getgenv().AutoTrain or game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb"):FindFirstChild("Primary") == nil then
                    continue;
                end
                    
                local nearest_win = nil;
                local distance = 30;
                    
                for _,world in pairs(game:GetService("Workspace"):FindFirstChild("Mine"):GetChildren()) do
                    if world:IsA("Folder") then
                        if (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-world:FindFirstChild("Stage"):FindFirstChild("Win").Position).Magnitude < distance then
                            nearest_win = world:FindFirstChild("Stage"):FindFirstChild("Win");
                            distance = (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-world:FindFirstChild("Stage"):FindFirstChild("Win").Position).Magnitude;
                        end
                    end
                end
                    
                if nearest_win ~= nil then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = nearest_win.CFrame;
                end
            end
        end))
    end
end)

tab1:NewCheckbox("Auto Rebirth", function(bool)
    getgenv().AutoRebirth = bool;
    
    if bool then
        auto_rebirth_con = game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("\240\159\146\165Power"):GetPropertyChangedSignal("Value"):Connect(function()
            if not getgenv().AutoRebirth then
                auto_rebirth_con:Disconnect();
            end
            
            if game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("\240\159\146\165Power").Value > game_settings.RebirthCost[game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("\240\159\152\135Rebirths").Value + 1] then
                game:GetService("ReplicatedStorage").Remote.Mine.RebirthRequest:InvokeServer();
            end
        end)
    else
        if auto_rebirth_con ~= nil then
            auto_rebirth_con:Disconnect();
        end
    end
end)

tab1:NewCheckbox("Optimize Game", function(bool)
    getgenv().Optimization = bool;
    
    if bool then
        auto_bomb_opt1 = game:GetService("Workspace").ChildAdded:Connect(function(i)
            if i:IsA("BasePart") and i.Name == "Effect" then
                i:Destroy();
            end
        end)
        
        auto_bomb_opt2 = game:GetService("Workspace"):FindFirstChild("CosmeticBulletsFolder").ChildAdded:Connect(function(i)
            i:Destroy();
        end)
    else
        if auto_bomb_opt1 ~= nil then
            auto_bomb_opt1:Disconnect();
        end
        
        if auto_bomb_opt2 ~= nil then
            auto_bomb_opt2:Disconnect();
        end
    end
end)

gui:BindToClose(function()
    getgenv().AutoBomb = false;
    getgenv().AutoTrain = false;
    getgenv().AutoWin = false;
    
    if auto_bomb_opt1 ~= nil then
        auto_bomb_opt1:Disconnect();
    end
        
    if auto_bomb_opt2 ~= nil then
        auto_bomb_opt2:Disconnect();
    end
    
    if auto_rebirth_con ~= nil then
        auto_rebirth_con:Disconnect();
    end
end)
