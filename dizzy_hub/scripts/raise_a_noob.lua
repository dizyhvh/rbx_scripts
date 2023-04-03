local ui_library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/dizyhvh/test_scripts/main/2.lua')))();
local gui = ui_library:NewGui();
local tab1 = gui:NewTab("Main");

getgenv().AutoClickNoob = false;
getgenv().PickupMoney = false;
getgenv().AutoFeedNoob = false;

local feeding_noob = false;

tab1:NewCheckbox("Auto Click Noob", function(bool)
    getgenv().AutoClickNoob = bool;
    
    if bool then
        getgenv().ACNCon = false;
        
        coroutine.resume(coroutine.create(function()
            while wait() do
                if not getgenv().AutoClickNoob or getgenv().ACNCon == true then
                    getgenv().ACNCon = false;
                    coroutine.yield();
                end
                
                if game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Cube") == nil or game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Cube"):FindFirstChild("XboxClick") == nil then
                    continue;
                end
                
                if feeding_noob ~= true and game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                    if (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Cube").Position).Magnitude > game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Cube"):FindFirstChild("XboxClick").MaxActivationDistance then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Cube").CFrame.X, game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Cube").CFrame.Y+1, game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Cube").CFrame.Z);
                    end
                end
                
                fireproximityprompt(game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Cube"):FindFirstChild("XboxClick"), game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Cube"):FindFirstChild("XboxClick").MaxActivationDistance);
            end
        end))
    else
        getgenv().ACNCon = true;
    end
end)

tab1:NewCheckbox("Auto Pickup Money", function(bool)
    getgenv().PickupMoney = bool;
    
    if bool then
        getgenv().PMCon = false;
        
        coroutine.resume(coroutine.create(function()
            while wait() do
                if not getgenv().PickupMoney or getgenv().PMCon == true then
                    getgenv().PMCon = false;
                    coroutine.yield();
                end
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil then
                    continue;
                end
                
                for _,money in pairs(game:GetService("Workspace"):FindFirstChild("SpawnedBobux"):GetChildren()) do
                    if money:IsA("BasePart") then
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), money, 0);
                        wait();
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), money, 1);
                    end
                end
            end
        end))
    else
        getgenv().PMCon = true;
    end
end)

tab1:NewCheckbox("Auto Feed Noob", function(bool)
    getgenv().AutoFeedNoob = bool;
    
    if bool then
        getgenv().AFNCon = false;
        
        coroutine.resume(coroutine.create(function()
            while wait() do
                if not getgenv().AutoFeedNoob or getgenv().AFNCon == true then
                    getgenv().AFNCon = false;
                    coroutine.yield();
                end
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil then
                    continue;
                end
                
                local hunger = 100 - game:GetService("Workspace"):FindFirstChild("Noob"):FindFirstChild("Hunger").Value;
                
                if hunger > 70 and game:GetService("Workspace"):FindFirstChild("Dish"):FindFirstChild("Filled").Value ~= true then
                    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Noob Food") == nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Noob Food") == nil then
                        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainGui"):FindFirstChild("General"):FindFirstChild("Shops"):FindFirstChild("narket").Visible then
                            game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainGui"):FindFirstChild("General"):FindFirstChild("Shops"):FindFirstChild("narket").Visible = false;
                        end
                        
                        if (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-game:GetService("Workspace"):FindFirstChild("House"):FindFirstChild("Furniture"):FindFirstChild("Table"):FindFirstChild("Gaming Setup"):FindFirstChild("ClickPart").Position).Magnitude > game:GetService("Workspace"):FindFirstChild("House"):FindFirstChild("Furniture"):FindFirstChild("Table"):FindFirstChild("Gaming Setup"):FindFirstChild("ClickPart"):FindFirstChildOfClass("ClickDetector").MaxActivationDistance then
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(game:GetService("Workspace"):FindFirstChild("House"):FindFirstChild("Furniture"):FindFirstChild("Table"):FindFirstChild("Gaming Setup"):FindFirstChild("ClickPart").CFrame.X, game:GetService("Workspace"):FindFirstChild("House"):FindFirstChild("Furniture"):FindFirstChild("Table"):FindFirstChild("Gaming Setup"):FindFirstChild("ClickPart").CFrame.Y+1, game:GetService("Workspace"):FindFirstChild("House"):FindFirstChild("Furniture"):FindFirstChild("Table"):FindFirstChild("Gaming Setup"):FindFirstChild("ClickPart").CFrame.Z);
                        end
                        
                        fireclickdetector(game:GetService("Workspace"):FindFirstChild("House"):FindFirstChild("Furniture"):FindFirstChild("Table"):FindFirstChild("Gaming Setup"):FindFirstChild("ClickPart"):FindFirstChildOfClass("ClickDetector"), game:GetService("Workspace"):FindFirstChild("House"):FindFirstChild("Furniture"):FindFirstChild("Table"):FindFirstChild("Gaming Setup"):FindFirstChild("ClickPart"):FindFirstChildOfClass("ClickDetector").MaxActivationDistance);
                        game:GetService("ReplicatedStorage"):FindFirstChild("BuyEvent"):InvokeServer("narket", 1, "Noob Food");
                    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Noob Food") ~= nil then
                        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Noob Food").Parent = game:GetService("Players").LocalPlayer.Character;
                    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Noob Food") ~= nil then
                        feeding_noob = true;
                        
                        if (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-game:GetService("Workspace"):FindFirstChild("Dish").Position).Magnitude > game:GetService("Workspace"):FindFirstChild("Dish"):FindFirstChildOfClass("ProximityPrompt").MaxActivationDistance then
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(game:GetService("Workspace"):FindFirstChild("Dish").CFrame.X, game:GetService("Workspace"):FindFirstChild("Dish").CFrame.Y+1, game:GetService("Workspace"):FindFirstChild("Dish").CFrame.Z);
                        end
                        
                        fireproximityprompt(game:GetService("Workspace"):FindFirstChild("Dish"):FindFirstChildOfClass("ProximityPrompt"), game:GetService("Workspace"):FindFirstChild("Dish"):FindFirstChildOfClass("ProximityPrompt").MaxActivationDistance);
                    end
                else
                    feeding_noob = false;
                end
            end
        end))
    else
        getgenv().AFNCon = true;
    end
end)
