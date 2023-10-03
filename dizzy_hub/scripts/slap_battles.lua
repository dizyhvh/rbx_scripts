local ui_library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/dizyhvh/test_scripts/main/2.lua')))();
local gui = ui_library:NewGui();
local tab1 = gui:NewTab("Combat");
local tab2 = gui:NewTab("Visuals");
local tab3 = gui:NewTab("Misc");
local tab4 = gui:NewTab("Badges");

getgenv().AutoFarm = {
    ForceInvisibillity = false,
    GloveToUse = "Default",
    State = false
};
getgenv().SlapAura = {
    Mode = "Old",
    Distance = 10,
    Reach = false,
    IgnoreReverse = false,
    IgnoreFriends = false,
    IgnoreInvisible = false,
    State = false
};
getgenv().NoSlapCooldown = false;
getgenv().AntiRagdoll = false;
getgenv().AntiReaper = false;
getgenv().AntiSwapper = false;
getgenv().AntiTimestop = false;
getgenv().DefenseExploit = false;
getgenv().Godmode = {
    Method = "Golden",
    State = false
};
getgenv().GetTycoonGlove = false;
getgenv().TycoonAutoclicker = false;
getgenv().HideVisuals = false;

local AF_OldSlaps = game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats") ~= nil and game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Slaps").Value or nil;
local AF_SlapsAmount = 0;
local AF_VelocityFix = nil;
local AF_SlapChecker = nil;

local AR_OldPos = nil;
local AR_OldAngle = nil;
local AR_OldWalkSpeed = nil;

local AS_OldPos = nil;
local AS_OldAngle = nil;

local GM_OldCFrame = nil;

local no_slap_cooldown = nil;
no_slap_cooldown = hookfunction(wait, function(_time)
    return no_slap_cooldown((_time > 0) and getgenv().NoSlapCooldown and -math.huge or _time);
end);

tab1:NewCheckbox("Auto Farm",function(bool)
    getgenv().AutoFarm["State"] = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().AutoFarm["State"] then
                    if AF_SlapChecker ~= nil then
                        AF_SlapChecker:Disconnect();
                    end
                    
                    for _,grass in pairs(game:GetService("Workspace"):FindFirstChild("Arena"):FindFirstChild("main island"):GetChildren()) do
                        if grass:IsA("MeshPart") and string.find(string.lower(grass.Name), "cone") or string.find(string.lower(grass.Name), "grass") then
                            grass.CanTouch = true;
                            grass.CanCollide = true;
                        end
                    end
                
                    coroutine.yield();
                end
                
                wait();
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
                    continue;
                end
                
                if game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    if getgenv().AutoFarm["ForceInvisibillity"] then
                        if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Torso").Transparency <= 0 then
                            if game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats") ~= nil and game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Glove") ~= nil and game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Glove").Value == "Ghost" then
                                game:GetService("ReplicatedStorage"):FindFirstChild("Ghostinvisibilityactivated"):FireServer();
                            else
                                fireclickdetector(game:GetService("Workspace"):FindFirstChild("Lobby"):FindFirstChild("Ghost"):FindFirstChildOfClass("ClickDetector"), math.huge);
                            end
                            
                            task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000);
                            continue;
                        else
                            for _,acc in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                                if acc:IsA("Accessory") then
                                    if acc:FindFirstChild("Handle") ~= nil and acc:FindFirstChild("Handle"):FindFirstChild("AccessoryWeld") ~= nil then
                                        acc:FindFirstChild("Handle"):FindFirstChild("AccessoryWeld"):Destroy();
                                    end
                                end
                            end
                            
                            if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("BillboardGui") ~= nil then
                                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("BillboardGui"):Destroy();
                            end
                        end
                    end
                    
                    if game:GetService("Workspace"):FindFirstChild("Lobby"):FindFirstChild(tostring(getgenv().AutoFarm["GloveToUse"])) ~= nil and game:GetService("Workspace"):FindFirstChild("Lobby"):FindFirstChild(tostring(getgenv().AutoFarm["GloveToUse"])):FindFirstChildOfClass("ClickDetector") ~= nil then
                        fireclickdetector(game:GetService("Workspace"):FindFirstChild("Lobby"):FindFirstChild(tostring(getgenv().AutoFarm["GloveToUse"])):FindFirstChildOfClass("ClickDetector"), math.huge);
                        task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000);
                        
                        if game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats") == nil or game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Glove") == nil or game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Glove").Value ~= tostring(getgenv().AutoFarm["GloveToUse"]) then
                            continue;
                        end
                    end
                    
                    firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game:GetService("Workspace"):FindFirstChild("Lobby"):FindFirstChild("Teleport1"), 0);
                    firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game:GetService("Workspace"):FindFirstChild("Lobby"):FindFirstChild("Teleport1"), 1);
                    task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000);
                else
                    if AF_VelocityFix == nil then
                        AF_VelocityFix = game:GetService("RunService").Heartbeat:Connect(function()
                            if not getgenv().AutoFarm["State"] then
                                AF_VelocityFix:Disconnect();
                            end
                            
                            if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil then
                                return;
                            end
                            
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, 0, 0);
                        end)
                    end
                    
                    if AF_SlapChecker == nil then
                        AF_SlapChecker = game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Slaps"):GetPropertyChangedSignal("Value"):Connect(function()
                            if not getgenv().AutoFarm["State"] then
                                AF_SlapChecker:Disconnect();
                            end
                            
                            if AF_OldSlaps == nil then
                                AF_OldSlaps = game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Slaps").Value;
                                return;
                            end
                            
                            local difference = game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Slaps").Value - AF_OldSlaps;
                            
                            if difference > 1 then
                                AF_SlapsAmount += difference;
                                AF_OldSlaps = game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Slaps").Value;
                            end
                        end)
                    end
                    
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ragdolled") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ragdolled").Value == true then
                        continue;
                    end
                    
                    local lp_glove = nil;
                
                    for _,tool in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name ~= "Radio" and tool.Name ~= "Spectator" then
                            if tool:FindFirstChild("Glove") ~= nil then
                                tool.Parent = game:GetService("Players").LocalPlayer.Character;
                            end
                        end
                    end
                
                    for _,tool in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name ~= "Radio" and tool.Name ~= "Spectator" then
                            if tool:FindFirstChild("Glove") ~= nil then
                                lp_glove = tool;
                            end
                        end
                    end
                
                    for _,grass in pairs(game:GetService("Workspace"):FindFirstChild("Arena"):FindFirstChild("main island"):GetChildren()) do
                        if grass:IsA("MeshPart") and string.find(string.lower(grass.Name), "cone") or string.find(string.lower(grass.Name), "grass") then
                            grass.CanTouch = false;
                            grass.CanCollide = false;
                        end
                    end
                    
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false;
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-4.08817, -15, 1.83554);
                    
                    if AF_SlapsAmount >= 100 then
                        task.wait(5);
                        AF_SlapsAmount = 0;
                    end
                    
                    local noobiest_target = nil;
                    local amount_of_slaps = math.huge;
                    local distance = math.huge;
                        
                    for _,plr in pairs(game:GetService("Players"):GetPlayers()) do
                        if plr == game:GetService("Players").LocalPlayer or (getgenv().SlapAura["IgnoreFriends"] and game:GetService("Players").LocalPlayer:IsFriendsWith(plr.UserId)) or plr.Character == nil or plr.Character:FindFirstChild("HumanoidRootPart") == nil or plr.Character:FindFirstChildOfClass("Humanoid") == nil or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or plr.Character:FindFirstChild("entered") == nil or not (plr.Character:FindFirstChild("Ragdolled") == nil or plr.Character:FindFirstChild("Ragdolled").Value == false) or plr.Character:FindFirstChild("rock") ~= nil or plr.Character:FindFirstChild("Torso") == nil or plr.Character:FindFirstChild("Torso").Transparency > 0 and plr.Character:FindFirstChild("Torso").Transparency < 1 or (getgenv().SlapAura["IgnoreInvisible"] and plr.Character:FindFirstChild("Torso").Transparency == 1) or (plr.Character:FindFirstChild("Right Leg") ~= nil and plr.Character:FindFirstChild("Right Leg"):FindFirstChildOfClass("SelectionBox") ~= nil or plr.Character:FindFirstChild("Left Leg") ~= nil and plr.Character:FindFirstChild("Left Leg"):FindFirstChildOfClass("SelectionBox") ~= nil or plr.Character:FindFirstChild("Right Arm") ~= nil and plr.Character:FindFirstChild("Right Arm"):FindFirstChildOfClass("SelectionBox") ~= nil or plr.Character:FindFirstChild("Left Arm") ~= nil and plr.Character:FindFirstChild("Left Arm"):FindFirstChildOfClass("SelectionBox") ~= nil) or plr.Character:FindFirstChild("HumanoidRootPart").Color == Color3.fromRGB(255, 255, 0) or plr.Character:FindFirstChild("HumanoidRootPart").CFrame.Y < -105 then
                            continue;
                        end
                            
                        if plr:FindFirstChild("leaderstats") ~= nil and plr:FindFirstChild("leaderstats"):FindFirstChild("Slaps") ~= nil and plr:FindFirstChild("leaderstats"):FindFirstChild("Slaps").Value < amount_of_slaps and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-plr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < distance then
                            amount_of_slaps = plr:FindFirstChild("leaderstats"):FindFirstChild("Slaps").Value;
                            distance = (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-plr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude;
                            noobiest_target = plr;
                        end
                    end
                        
                    if noobiest_target ~= nil and lp_glove ~= nil then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                        
                        if noobiest_target.Character:FindFirstChildOfClass("Humanoid").MoveDirection ~= Vector3.new(0, 0, 0) then
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(noobiest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.X, noobiest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.Y-11, noobiest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.Z) * CFrame.Angles(math.rad(-90), 0, 0) + noobiest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * (noobiest_target.Character:FindFirstChildOfClass("Humanoid").WalkSpeed / 5);
                        else
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(noobiest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.X, noobiest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.Y-11, noobiest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.Z) * CFrame.Angles(math.rad(-90), 0, 0);
                        end
                        
                        task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000);
                        
                        if lp_glove ~= nil and lp_glove:FindFirstChild("Glove") ~= nil and noobiest_target ~= nil and noobiest_target.Character ~= nil and noobiest_target.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                            firetouchinterest(lp_glove:FindFirstChild("Glove"), noobiest_target.Character:FindFirstChild("HumanoidRootPart"), 0);
                            lp_glove:Activate();
                            firetouchinterest(lp_glove:FindFirstChild("Glove"), noobiest_target.Character:FindFirstChild("HumanoidRootPart"), 1);
                        end
                    end
                end
            end
        end))
    end
end)

tab1:NewDropdown("Glove", {"Default", "Diamond", "Flash", "Magnet", "Dream"}, function(option)
    getgenv().AutoFarm["GloveToUse"] = tostring(option);
end)

tab1:NewCheckbox("Force Invisibillity",function(bool)
    getgenv().AutoFarm["ForceInvisibillity"] = bool;
end)

tab1:NewCheckbox("Slap Aura",function(bool)
    getgenv().SlapAura["State"] = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().SlapAura["State"] then
                    coroutine.yield();
                end
                
                task.wait();
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    continue;
                end
                
                local lp_glove = nil;
                
                for _,tool in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name ~= "Radio" and tool.Name ~= "Spectator" then
                        if tool:FindFirstChild("Glove") ~= nil then
                            lp_glove = tool;
                        end
                    end
                end
                
                if lp_glove ~= nil then
                    if getgenv().SlapAura["Mode"] ~= "Old (fixed)" then
                        if lp_glove:FindFirstChild("Glоvе") ~= nil then
                            lp_glove:FindFirstChild("Glоvе"):Destroy();
                            lp_glove:FindFirstChild("Glove").Size = Vector3.new(2.5, 1.7, 1.7);
                            lp_glove:FindFirstChild("Glove").Transparency = 0;
                        end
                    end
                    
                    local nearest_target = nil;
                    local distance = getgenv().SlapAura["Distance"];
                        
                    for _,plr in pairs(game:GetService("Players"):GetPlayers()) do
                        if plr == game:GetService("Players").LocalPlayer or (getgenv().SlapAura["IgnoreFriends"] and game:GetService("Players").LocalPlayer:IsFriendsWith(plr.UserId)) or plr.Character == nil or plr.Character:FindFirstChild("HumanoidRootPart") == nil or plr.Character:FindFirstChildOfClass("Humanoid") == nil or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or plr.Character:FindFirstChild("entered") == nil or (plr.Character:FindFirstChild("Ragdolled") == nil or plr.Character:FindFirstChild("Ragdolled").Value == true) or plr.Character:FindFirstChild("rock") ~= nil or plr.Character:FindFirstChild("Torso") == nil or plr.Character:FindFirstChild("Torso").Transparency > 0 and plr.Character:FindFirstChild("Torso").Transparency < 1 or (getgenv().SlapAura["IgnoreInvisible"] and plr.Character:FindFirstChild("Torso").Transparency == 1) or getgenv().SlapAura["IgnoreReverse"] and (plr.Character:FindFirstChild("Right Leg") ~= nil and plr.Character:FindFirstChild("Right Leg"):FindFirstChildOfClass("SelectionBox") ~= nil or plr.Character:FindFirstChild("Left Leg") ~= nil and plr.Character:FindFirstChild("Left Leg"):FindFirstChildOfClass("SelectionBox") ~= nil or plr.Character:FindFirstChild("Right Arm") ~= nil and plr.Character:FindFirstChild("Right Arm"):FindFirstChildOfClass("SelectionBox") ~= nil or plr.Character:FindFirstChild("Left Arm") ~= nil and plr.Character:FindFirstChild("Left Arm"):FindFirstChildOfClass("SelectionBox") ~= nil) or plr.Character:FindFirstChild("HumanoidRootPart").Color == Color3.fromRGB(255, 255, 0) then
                            continue;
                        end
                            
                        if game:GetService("Workspace"):FindFirstChild(tostring(utf8.char(197)..plr.Name)) ~= nil then
                            if game:GetService("Workspace"):FindFirstChild(tostring(utf8.char(197)..plr.Name)):FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Workspace"):FindFirstChild(tostring(utf8.char(197)..plr.Name)):FindFirstChildOfClass("Humanoid").Health < 20 then
                                if (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-game:GetService("Workspace"):FindFirstChild(tostring(utf8.char(197)..plr.Name)):FindFirstChild("HumanoidRootPart").Position).Magnitude < distance then
                                    distance = (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-game:GetService("Workspace"):FindFirstChild(tostring(utf8.char(197)..plr.Name)):FindFirstChild("HumanoidRootPart").Position).Magnitude;
                                    nearest_target = game:GetService("Workspace"):FindFirstChild(tostring(utf8.char(197)..plr.Name));
                                end
                            end
                        end
                                
                        if (not getgenv().AutoFarm["Reach"] and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-plr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 20) and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-plr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < distance then
                            distance = (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-plr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude;
                            nearest_target = plr;
                        end
                    end
                        
                    if nearest_target ~= nil then
                        local old_cframe = nil;
                        
                        if getgenv().SlapAura["Reach"] then
                            old_cframe = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame;
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = nearest_target.Character:FindFirstChild("HumanoidRootPart").CFrame;
                            task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000);
                        end
                        
                        if getgenv().SlapAura["Mode"] == "Old (fixed)" then
                            if lp_glove:FindFirstChild("Glоvе") == nil then
                                local fake_glove = lp_glove:FindFirstChild("Glove"):Clone();
                                fake_glove.Name = "Glоvе";
                                fake_glove.Parent = lp_glove;
                                
                                local weld = Instance.new("WeldConstraint");
                                weld.Part0 = lp_glove:FindFirstChild("Handle");
                                weld.Part1 = fake_glove;
                                weld.Parent = fake_glove;
                            end
                            
                            local box = nil;
                            
                            if lp_glove:FindFirstChildOfClass("BoxHandleAdornment") == nil then
                                box = Instance.new("BoxHandleAdornment");
                                box.Adornee = lp_glove:FindFirstChild("Glove");
                                box.Size = lp_glove:FindFirstChild("Glove").Size;
                                box.AlwaysOnTop = false;
                                box.ZIndex = 1;
                                box.Visible = true;
                                box.Transparency = 0.75;
                                box.Parent = lp_glove;
                            elseif box == nil and lp_glove:FindFirstChildOfClass("BoxHandleAdornment") ~= nil then
                                box = lp_glove:FindFirstChildOfClass("BoxHandleAdornment");
                            end
                            
                            if lp_glove:FindFirstChild("Glove"):FindFirstChildOfClass("BlockMesh") ~= nil then
                                lp_glove:FindFirstChild("Glove"):FindFirstChildOfClass("BlockMesh"):Destroy();
                            elseif lp_glove:FindFirstChild("Glove"):FindFirstChildOfClass("SpecialMesh") ~= nil then
                                lp_glove:FindFirstChild("Glove"):FindFirstChildOfClass("SpecialMesh"):Destroy();
                            elseif lp_glove:FindFirstChild("Glove"):IsA("MeshPart") then
                                lp_glove:FindFirstChild("Glove").MeshId = "rbxassetid://0";
                            end
                            
                            lp_glove:FindFirstChild("Glove").Transparency = 1;
                            lp_glove:FindFirstChild("Glove").Size = Vector3.new(25,25,25);
                            box.Size = lp_glove:FindFirstChild("Glove").Size;
    
                            if distance < 10 then
                                lp_glove:FindFirstChild("Glove").Size = Vector3.new(distance-1, distance, distance-1);
                            elseif distance > 10 then
                                lp_glove:FindFirstChild("Glove").Size = Vector3.new(distance+2, distance, distance);
                            end
    
                            box.Size = lp_glove:FindFirstChild("Glove").Size;
                            lp_glove:Activate();
                        elseif getgenv().SlapAura["Mode"] == "Perfect" then
                            if nearest_target:IsA("Player") then
                                firetouchinterest(lp_glove:FindFirstChild("Glove"), nearest_target.Character:FindFirstChild("HumanoidRootPart"), 0);
                                firetouchinterest(lp_glove:FindFirstChild("Glove"), nearest_target.Character:FindFirstChild("HumanoidRootPart"), 1);
                            elseif nearest_target:IsA("Model") then
                                firetouchinterest(lp_glove:FindFirstChild("Glove"), nearest_target:FindFirstChild("HumanoidRootPart"), 0);
                                firetouchinterest(lp_glove:FindFirstChild("Glove"), nearest_target:FindFirstChild("HumanoidRootPart"), 1);
                            end
                            
                            lp_glove:Activate();
                        end
                        
                        if getgenv().SlapAura["Reach"] then
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = old_cframe;
                        end
                    end
                end
            end
        end))
    end
end)

tab1:NewDropdown("Mode", {"Old (fixed)", "Perfect"}, function(option)
    getgenv().SlapAura["Mode"] = tostring(option);
end)

tab1:NewCheckbox("Reach",function(bool)
    getgenv().SlapAura["Reach"] = bool;
end)

tab1:NewSlider("Distance", 10, 50, false, function(value)
    getgenv().SlapAura["Distance"] = value;
end)

tab1:NewCheckbox("Ignore Reverse",function(bool)
    getgenv().SlapAura["IgnoreReverse"] = bool;
end)

tab1:NewCheckbox("Ignore Friends",function(bool)
    getgenv().SlapAura["IgnoreFriends"] = bool;
end)

tab1:NewCheckbox("Ignore Invisible Players",function(bool)
    getgenv().SlapAura["IgnoreInvisible"] = bool;
end)

tab1:NewCheckbox("No Slap Cooldown",function(bool)
    getgenv().NoSlapCooldown = bool;
end)

tab1:NewCheckbox("Anti Ragdoll",function(bool)
    getgenv().AntiRagdoll = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().AntiRagdoll then
                    if AR_OldPos ~= nil then
                        AR_OldPos = nil;
                    end
                    
                    if AR_OldAngle ~= nil then
                        AR_OldAngle = nil;
                    end
                    
                    coroutine.yield();
                end
                
                task.wait();
                
                if AntiSlap_RealRootPart ~= nil or AntiSlap_FakeRootPart ~= nil or game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    continue;
                end
                
                if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ragdolled") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ragdolled").Value == false then
                    if AR_OldPos ~= nil then
                        if (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-Vector3.new(AR_OldPos.X, AR_OldPos.Y, AR_OldPos.Z)).Magnitude > 3.5 then
                            if AR_OldAngle ~= nil then
                                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AR_OldPos * CFrame.Angles(0, math.rad(AR_OldAngle), 0);
                                AR_OldAngle = nil;
                            else
                                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AR_OldPos;
                            end
                            AR_OldPos = nil;
                        end
                        
                        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Physics, true);
                        for _,bp in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                            if bp:IsA("BasePart") and bp.Anchored == true then
                                bp.Anchored = false;
                            end
                        end
                    else
                        AR_OldWalkSpeed = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed;
                    end
                elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ragdolled") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ragdolled").Value == true then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Physics, false);
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false;
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50;
                    if AR_OldWalkSpeed ~= nil then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = AR_OldWalkSpeed;
                    else
                        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16;
                    end
                    for _,bp in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                        if bp:IsA("BasePart") and bp.Anchored == false then
                            bp.Anchored = true;
                        end
                    end
                    
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, Random.new(tick()):NextNumber(-17, -20), 0);
                    
                    for _,trash in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                        if trash:IsA("BodyVelocity") or trash:IsA("BodyAngularVelocity") or trash:IsA("Attachment") and (trash.Name == "a0" or trash.Name == "a1") then
                            trash:Destroy();
                        elseif trash:IsA("Motor6D") and trash.Enabled == false then
                            trash.Enabled = true;
                        elseif trash:IsA("BasePart") and string.find(trash.Name, "Fake") then
                            trash.Anchored = true;
                        end
                    end
                    
                    if AR_OldPos == nil then
                        AR_OldPos = CFrame.new(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X, game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y, game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z);
                    end
                    
                    if AR_OldAngle == nil then
                        AR_OldAngle = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Orientation.Y;
                    end
                end
            end
        end))
    end
end)

tab1:NewCheckbox("Anti Reaper",function(bool)
    getgenv().AntiReaper = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().AntiReaper then
                    coroutine.yield();
                end
                
                wait();
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("DeathMark") == nil then
                    continue;
                end
                
                game:GetService("ReplicatedStorage"):FindFirstChild("ReaperGone"):FireServer(game:GetService("Players").LocalPlayer.Character:FindFirstChild("DeathMark"));
            end
        end))
    end
end)

tab1:NewCheckbox("Anti Swapper",function(bool)
    getgenv().AntiSwapper = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().AntiSwapper then
                    if AS_OldPos ~= nil then
                        AS_OldPos = nil;
                    end
                    
                    if AS_OldAngle ~= nil then
                        AS_OldAngle = nil;
                    end
                    
                    coroutine.yield();
                end
                
                task.wait();
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    continue;
                end
                
                local got_swapped = false;
                local swap_part = nil;
                
                for _,swap_effect in pairs(game:GetService("Workspace"):GetChildren()) do
                    if swap_effect:IsA("BasePart") and swap_effect.Name == "SwapEffect" and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-swap_effect.Position).Magnitude <= 7.5 then
                        got_swapped = true;
                        swap_part = swap_effect;
                    end
                end
                
                if not got_swapped then
                    AS_OldPos = CFrame.new(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X, game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y, game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z);
                    AS_OldAngle = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Orientation.Y;
                else
                    if swap_part == nil then
                        got_swapped = false;
                    end
                    
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AS_OldPos * CFrame.new(0, math.rad(AS_OldAngle), 0);
                end
            end
        end))
    end
end)

tab1:NewCheckbox("Anti Timestop",function(bool)
    getgenv().AntiTimestop = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().AntiTimestop then
                    coroutine.yield();
                end
                
                task.wait();
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    continue;
                end
                
                local remove_tsvuln = false;
                
                if game:GetService("Workspace"):FindFirstChild("universalts") ~= nil then
                    remove_tsvuln = true;
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false;
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("TSVulnerability") ~= nil then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("TSVulnerability").Value = false;
                    end
                else
                    if remove_tsvuln then
                        remove_tsvuln = false;
                        if game:GetService("Players").LocalPlayer.Character:FindFirstChild("TSVulnerability") ~= nil then
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("TSVulnerability").Value = true;
                        end
                    end
                end
            end
        end))
    end
end)

tab3:NewCheckbox("Defense Exploit",function(bool)
    getgenv().DefenseExploit = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().DefenseExploit then
                    coroutine.yield();
                end
                
                task.wait();
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    continue;
                end
            
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                
                local nearest_target = nil;
                local distance = math.huge;
                        
                for _,plr in pairs(game:GetService("Players"):GetPlayers()) do
                    if plr == game:GetService("Players").LocalPlayer or plr.Character == nil or plr.Character:FindFirstChild("HumanoidRootPart") == nil or plr.Character:FindFirstChildOfClass("Humanoid") == nil or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or plr.Character:FindFirstChild("entered") == nil or not (plr.Character:FindFirstChild("Ragdolled") == nil or plr.Character:FindFirstChild("Ragdolled").Value == false) or plr.Character:GetPivot().Position.Y < -7.5 or plr.Character:FindFirstChild("rock") then
                        continue;
                    end
                            
                    if (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-plr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < distance then
                        distance = (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-plr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude;
                        nearest_target = plr;
                    end
                end
                        
                if nearest_target ~= nil then
                    if nearest_target.Character:FindFirstChildOfClass("Humanoid").MoveDirection ~= Vector3.new(0, 0, 0) then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(nearest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.X, nearest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.Y+2.5, nearest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.Z) + nearest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 20;
                    else
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(nearest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.X, nearest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.Y+2.5, nearest_target.Character:FindFirstChild("HumanoidRootPart").CFrame.Z);
                    end
                    
                    game:GetService("ReplicatedStorage"):FindFirstChild("Barrier"):FireServer();
                    task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000);
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
                    task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000);
                end
            end
        end))
    end
end)

tab3:NewCheckbox("Auto Collect Slapples",function(bool)
    getgenv().AutoCollectSlapples = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().AutoCollectSlapples then
                    coroutine.yield();
                end
                
                wait();

                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    continue;
                end
                
                for _,slapple in pairs(game:GetService("Workspace"):FindFirstChild("Arena"):FindFirstChild("island5"):FindFirstChild("Slapples"):GetChildren()) do
                    if slapple:FindFirstChild("Glove") ~= nil and slapple:FindFirstChild("Glove").Transparency < 1 then
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), slapple:FindFirstChild("Glove"), 0);
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), slapple:FindFirstChild("Glove"), 1);
                    end
                end
            end
        end))
    end
end)

tab1:NewCheckbox("God Mode",function(bool)
    getgenv().Godmode["State"] = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().Godmode["State"] then
                    if getgenv().GMG_Part ~= nil then
                        getgenv().GMG_Part:Destroy();
                        getgenv().GMG_Part = nil;
                    end
                    coroutine.yield();
                end
                
                task.wait();
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    continue;
                end
                
                if getgenv().Godmode["Method"] == "Golden" then
                    if game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats") == nil or game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Glove").Value ~= "Golden" then
                        continue;
                    end
            
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Color ~= Color3.fromRGB(255, 255, 0) then
                        game:GetService("ReplicatedStorage"):FindFirstChild("Goldify"):FireServer(true);
                    end
                elseif getgenv().Godmode["Method"] == "Reverse" then
                    if game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats") == nil or game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Glove").Value ~= "Reverse" then
                        continue;
                    end
                    
                    if not (game:GetService("Players").LocalPlayer.Character:FindFirstChild("Right Leg") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Right Leg"):FindFirstChildOfClass("SelectionBox") ~= nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Left Leg") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Left Leg"):FindFirstChildOfClass("SelectionBox") ~= nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Right Arm") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Right Arm"):FindFirstChildOfClass("SelectionBox") ~= nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Left Arm") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Left Arm"):FindFirstChildOfClass("SelectionBox") ~= nil) then
                        game:GetService("ReplicatedStorage"):FindFirstChild("ReverseAbility"):FireServer();
                        wait(5.1);
                    end
                elseif getgenv().Godmode["Method"] == "Ghetto" then
                    if getgenv().GMG_Part == nil then
                        local fake_part = game:GetService("Workspace"):FindFirstChild("Arena"):FindFirstChild("main island"):FindFirstChild("Grass"):Clone();
                        fake_part.Color = Color3.fromRGB(105, 64, 40);
                        fake_part.Name = "Part";
                        fake_part.Size = Vector3.new(0.2, 550, 550);
                        fake_part.CFrame = CFrame.new(fake_part.CFrame.X, fake_part.CFrame.Y-1.3, fake_part.CFrame.Z) * CFrame.Angles(0, 0, math.rad(90));
                        fake_part.Transparency = 1;
                        fake_part.Parent = game:GetService("Workspace"):FindFirstChild("Arena"):FindFirstChild("main island");
                        
                        getgenv().GMG_Part = fake_part;
                    end
                end
            end
        end))
    end
end)

tab1:NewDropdown("Method", {"Golden", "Reverse", "Ghetto"}, function(option)
    getgenv().Godmode["Method"] = tostring(option);
end)

tab4:NewCheckbox("Get Tycoon Glove",function(bool)
    getgenv().GetTycoonGlove = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().GetTycoonGlove then
                    coroutine.yield();
                end
                
                task.wait();
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    continue;
                end
                
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(game:GetService("Workspace"):FindFirstChild("Arena"):FindFirstChild("Plate").CFrame.X, game:GetService("Workspace"):FindFirstChild("Arena"):FindFirstChild("Plate").CFrame.Y+math.random(1.5, 2), game:GetService("Workspace"):FindFirstChild("Arena"):FindFirstChild("Plate").CFrame.Z);
            end
        end))
    end
end)

tab4:NewCheckbox("Tycoon Auto Clicker",function(bool)
    getgenv().TycoonAutoclicker = bool;
    
    if bool then
        coroutine.resume(coroutine.create(function()
            while true do
                if not getgenv().TycoonAutoclicker then
                    coroutine.yield();
                end
                
                task.wait();
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") == nil then
                    continue;
                end
                
                for _,tycoon in pairs(game:GetService("Workspace"):GetChildren()) do
                    if tycoon:IsA("Model") and string.find(tycoon.Name, "Tycoon") and string.find(tycoon.Name, game:GetService("Players").LocalPlayer.Name) then
                        if tycoon:FindFirstChild("Click") ~= nil and tycoon:FindFirstChild("Click").Transparency == 0 then
                            fireclickdetector(tycoon:FindFirstChild("Click"):FindFirstChildOfClass("ClickDetector"), math.huge);
                        end
                    end
                end
            end
        end))
    end
end)

tab4:NewButton("Get Elude Glove", function()
    if game:GetService("Workspace"):FindFirstChild("Keypad") == nil then
        return;
    end
    
    local pass = tostring(#game:GetService("Players"):GetPlayers() * 25 + 1100 - 7)
    fireclickdetector(game:GetService("Workspace"):FindFirstChild("Keypad"):WaitForChild("Buttons"):WaitForChild("Reset"):FindFirstChildWhichIsA("ClickDetector"));
    
    task.wait(.2);
    
    for x=1, 4 do
        local c = pass:sub(x, x);
        fireclickdetector(game:GetService("Workspace"):FindFirstChild("Keypad"):WaitForChild("Buttons"):WaitForChild(c):FindFirstChildWhichIsA("ClickDetector"));
        task.wait(.2);
    end
    
    fireclickdetector(game:GetService("Workspace"):FindFirstChild("Keypad"):WaitForChild("Buttons"):WaitForChild("Enter"):FindFirstChildWhichIsA("ClickDetector"));
    game:GetService("TeleportService"):Teleport(11828384869, game:GetService("Players").LocalPlayer);
    
    if syn ~= nil then
        syn.queue_on_teleport([[
            repeat task.wait() until game:IsLoaded() or game.IsLoaded;
            repeat task.wait() until game:GetService("Players").LocalPlayer ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil;
            
            for _,collectible in pairs(game:GetService("Workspace"):FindFirstChild("Collectable"):GetChildren()) do
                if collectible:IsA("BasePart") then
                    if firetouchinterest ~= nil then
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), collectible, 0);
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), collectible, 1);
                    else
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = collectible.CFrame;
                        wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000);
                    end
                end
            end
            
            if firetouchinterest ~= nil then
                firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game:GetService("Workspace"):FindFirstChild("Ruins"):FindFirstChild("Elude"):FindFirstChild("Glove"), 0);
                firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game:GetService("Workspace"):FindFirstChild("Ruins"):FindFirstChild("Elude"):FindFirstChild("Glove"), 1);
            else
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game:GetService("Workspace"):FindFirstChild("Ruins"):FindFirstChild("Elude"):FindFirstChild("Glove").CFrame;
            end
        ]]);
    else
        warn("[Warning] Your exploit doesn't seem to support queue_on_teleport function! Click this button once you got teleported in the game, else it will not work.");
        
        if game.PlaceId == 11828384869 then
            for _,collectible in pairs(game:GetService("Workspace"):FindFirstChild("Collectable"):GetChildren()) do
                if collectible:IsA("BasePart") then
                    if firetouchinterest ~= nil then
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), collectible, 0);
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), collectible, 1);
                    else
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = collectible.CFrame;
                        wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000);
                    end
                end
            end
            
            if firetouchinterest ~= nil then
                firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game:GetService("Workspace"):FindFirstChild("Ruins"):FindFirstChild("Elude"):FindFirstChild("Glove"), 0);
                firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game:GetService("Workspace"):FindFirstChild("Ruins"):FindFirstChild("Elude"):FindFirstChild("Glove"), 1);
            else
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game:GetService("Workspace"):FindFirstChild("Ruins"):FindFirstChild("Elude"):FindFirstChild("Glove").CFrame;
            end
        end
    end
end)

tab2:NewCheckbox("Hide Visuals",function(bool)
    getgenv().HideVisuals = bool;
    
    if bool then
        if getgenv().HV_LConnection == nil then
            getgenv().HV_LConnection = game:GetService("Lighting").ChildAdded:Connect(function(child)
                if not getgenv().HideVisuals then
                    getgenv().HV_LConnection:Disconnect();
                end
                
                repeat task.wait() until child ~= nil;
                
                if child:IsA("ColorCorrectionEffect") or child:IsA("BlurEffect") or child:IsA("Sky") then
                    child:Destroy();
                    
                    if game:GetService("Lighting"):FindFirstChildOfClass("Bloom") ~= nil and game:GetService("Lighting"):FindFirstChildOfClass("Bloom").Enabled == true then
                        game:GetService("Lighting"):FindFirstChildOfClass("Bloom").Enabled = false;
                    end
                end
            end)
        end
        
        if getgenv().HV_L1Connection == nil then
            getgenv().HV_L1Connection = game:GetService("Lighting").Changed:Connect(function(prop)
                if not getgenv().HideVisuals then
                    getgenv().HV_L1Connection:Disconnect();
                end
                
                if tostring(prop) == "ExposureCompensation" then
                    game:GetService("Lighting")[tostring(prop)] = 0;
                end
            end)
        end
        
        if getgenv().HV_WConnection == nil then
            getgenv().HV_WConnection = game:GetService("Workspace").ChildAdded:Connect(function(child)
                if not getgenv().HideVisuals then
                    getgenv().HV_WConnection:Disconnect();
                end
            
                if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then
                    if child.Name == "wall" or child.Name == "BusModel" or child.Name == "Union" or child.Name == "Jet" or child.Name == "Missile" or child.Name == "ClonnedBall" or child.Name == "Pumpkin" or string.match(child.Name, tostring(utf8.char(197).."Barrier")) or string.find(child.Name, "ObbyItem") and (string.find(child.Name, "LavaSpinner") or string.find(child.Name, "LavaBlock")) or child.BrickColor == BrickColor.new("Smoky grey") then
                        child.CanCollide = false;
                        child.CanTouch = false;
                        child.Transparency = 0.9;
                    end
                elseif child:IsA("Model") then
                    if string.match(child.Name, tostring(utf8.char(197).."BOB")) then
                        child:Destroy();
                    end
                end
            end)
        end
    else
        if getgenv().HV_LConnection ~= nil then
            getgenv().HV_LConnection:Disconnect();
        end
        
        if getgenv().HV_L1Connection ~= nil then
            getgenv().HV_L1Connection:Disconnect();
        end
        
        if getgenv().HV_WConnection ~= nil then
            getgenv().HV_WConnection:Disconnect();
        end
    end
end)

gui:BindToClose(function()
    getgenv().AutoFarm["State"] = false;
    getgenv().AntiSlap["State"] = false;
    getgenv().SlapAura["State"] = false;
    getgenv().NoSlapCooldown = false;
    getgenv().AntiRagdoll = false;
    getgenv().AntiReaper = false;
    getgenv().AntiSwapper = false;
    getgenv().AntiTimestop = false;
    getgenv().DefenseExploit = false;
    getgenv().Godmode["State"] = false;
    getgenv().GetTycoonGlove = false;
    getgenv().TycoonAutoclicker = false;
    getgenv().HideVisuals = false;
    
    if getgenv().GMG_Part ~= nil then
        getgenv().GMG_Part:Destroy();
    end
    
    if getgenv().HV_LConnection ~= nil then
        getgenv().HV_LConnection:Disconnect();
    end
    
    if getgenv().HV_L1Connection ~= nil then
        getgenv().HV_L1Connection:Disconnect();
    end
    
    if getgenv().HV_WConnection ~= nil then
        getgenv().HV_WConnection:Disconnect();
    end
end)
