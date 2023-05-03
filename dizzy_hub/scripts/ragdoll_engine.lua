local ui_library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/dizyhvh/test_scripts/main/2.lua')))();
local gui = ui_library:NewGui();
local tab1 = gui:NewTab("Main");

getgenv().PushAura = false;

tab1:NewCheckbox("Push Aura", function(bool)
    getgenv().PushAura = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while wait() do
                if not getgenv().PushAura then
                    getgenv().PACon = true;
                    coroutine.yield();
                end
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Push") == nil then
                    continue; 
                end
                
                for _,plr in pairs(game:GetService("Players"):GetPlayers()) do
                    if plr == game:GetService("Players").LocalPlayer or plr.Character == nil or plr.Character:FindFirstChild("HumanoidRootPart") == nil or (plr.Character:FindFirstChild("HumanoidRootPart").Position-game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude > 15 then
                        continue;
                    end
                    
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("Push"):FindFirstChild("PushTool"):FireServer(plr.Character);
                end
            end
        end))
    end
end)

local ar_con1 = nil;

tab1:NewCheckbox("Anti Ragdoll", function(bool)
    if bool then
        task.spawn(function()
            if game:GetService("Players").LocalPlayer.Character ~= nil then
                game:GetService("Debris"):AddItem(game:GetService("Players").LocalPlayer.Character:FindFirstChild("Falling down"), 0);
                game:GetService("Debris"):AddItem(game:GetService("Players").LocalPlayer.Character:FindFirstChild("StartRagdoll"), 0);
                game:GetService("Debris"):AddItem(game:GetService("Players").LocalPlayer.Character:FindFirstChild("RagdollMe"), 0);
                game:GetService("Debris"):AddItem(game:GetService("Players").LocalPlayer.Character:FindFirstChild("Pushed"), 0);
                
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
            end
        end)
        
        ar_con1 = game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
            repeat wait() until char ~= nil and char:FindFirstChild("Falling down") ~= nil and char:FindFirstChild("StartRagdoll") ~= nil and char:FindFirstChild("RagdollMe") ~= nil and char:FindFirstChild("Pushed") ~= nil;
            
            game:GetService("Debris"):AddItem(char:FindFirstChild("Falling down"), 0);
            game:GetService("Debris"):AddItem(char:FindFirstChild("StartRagdoll"), 0);
            game:GetService("Debris"):AddItem(char:FindFirstChild("RagdollMe"), 0);
            game:GetService("Debris"):AddItem(char:FindFirstChild("Pushed"), 0);
            
            char:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
        end)
    else
        if ar_con1 ~= nil then
            ar_con1:Disconnect();
        end
    end
end)

gui:BindToClose(function()
    getgenv().PushAura = false;
        
    if ar_con1 ~= nil then
        ar_con1:Disconnect();
    end
end)
