--[[
    Coordmaster - undetected way of teleporting.
    Bypasses most of games' anti-teleport.
    
    Soon I will add new feature to this script: Coordfly.
    
    2023 - i still didn't add coordfly, lmao. maybe one day i'll find a use of it and add it to the library.
]]

local coordmaster = {};

local debounce = false;
local debounce2 = {};

--[[
    Usage:
     - coordmaster:Teleport({args["Position"] = CFrame.new(), args["Rotation"] = Vector3.new(), args["StepLength"] = 1, args["StepDelay"] = 0.1, args["StepType"] = 1, args["VelocityFix"] = 1, args["StopCondition"]}, callback);
                           (destination position,            (Angles of Character)                                                              (1 - DEFAULT step,     (1 - UNSAFE fix,         (function to stop tp
                           COULD BE Vector3.new())                                                                                               2 - DYNAMIC step)      2 - SAFE fix)           on conditions)
]]

function coordmaster:Teleport(args, callback)
    if debounce then
        return;
    end
    
    assert(args ~= nil or typeof(args) ~= "table", "[Coordmaster] Arguments are nil/undefined. (should be table)");
    assert(args["Position"] ~= nil, "[Coordmaster] Position is nil/undefined.");
    assert(args["StepLength"] ~= nil, "[Coordmaster] Step length is nil/undefined.");
    if args["StepDelay"] == nil and args["DynamicStepDelay"] == nil then
        error("[Coordmaster] Delay is nil/undefined.");
    end
    
    if args["Rotation"] == nil or typeof(args["Rotation"]) ~= "CFrame" then
        args["Rotation"] = CFrame.Angles(0, math.rad(90), 0);
    end
    
    if args["StepType"] == nil or typeof(args["StepType"]) ~= "number" then
        args["StepType"] = 1; 
    end
    
    if args["VelocityFix"] == nil or typeof(args["VelocityFix"]) ~= "number" then
        args["VelocityFix"] = 1; 
    end
    
    if typeof(args["Position"]) == "CFrame" or typeof(args["Position"]) == "Vector3" then
        if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
            debounce = true;

            local current_position = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position;
            local steps = math.floor(math.sqrt((args["Position"].X - current_position.X) ^ 2 + (args["Position"].Y - current_position.Y) ^ 2 + (args["Position"].Z - current_position.Z) ^ 2 ) / args["StepLength"]);
            local path = {};

            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, false);
                
            for i=1, steps do
                if args["StepType"] == 2 then
                    local random_step_length = Random.new(tick()):NextNumber(args["StepLength"] / 2, args["StepLength"]);
                    steps = math.floor(math.sqrt((args["Position"].X - current_position.X) ^ 2 + (args["Position"].Y - current_position.Y) ^ 2 + (args["Position"].Z - current_position.Z) ^ 2 ) / random_step_length);
                end

                path[#path+1] = {
                    x = current_position.X + ((args["Position"].X - current_position.X) / steps) * i,
                    y = current_position.Y + ((args["Position"].Y - current_position.Y) / steps) * i,
                    z = current_position.Z + ((args["Position"].Z - current_position.Z) / steps) * i,
                }
            end
            path[#path+1] = {x = args["Position"].X, y = args["Position"].Y, z = args["Position"].Z};
            
            local stop_tping = false;
            if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-Vector3.new(path[#path].x, path[#path].y, path[#path].z)).Magnitude <= args["StepLength"] then
                stop_tping = true;
            elseif args["VelocityFix"] == 2 then
                vel_fix = game:GetService("RunService").Stepped:Connect(function()
                    if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil then
                        vel_fix:Disconnect();
                    end
                    
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, 0, 0);
                end)
            end
            
            if not stop_tping then
                for i=1, steps do
                    if i > 1 and (game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil) then
                        if vel_fix ~= nil then
                            vel_fix:Disconnect();
                        end
                        
                        debounce = false;
                        return warn("[Coordmaster] Character's RootPart (HumanoidRootPart) got destroyed! For security reasons, script has previously stopped.");
                    end

                    if args["StopCondition"] ~= nil and args["StopCondition"]() == true then
                        if vel_fix ~= nil then
                            vel_fix:Disconnect();
                        end
                        
                        debounce = false;
                        break;
                    end
                    
                    if args["VelocityFix"] <= 1 then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, Random.new(tick()):NextInteger(17, 20), 0);
                    end
                    
                    if args["BypassAntiTP"] then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                        
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
                    else
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
                    end

                    local delay = args["StepDelay"] ~= nil and args["StepDelay"] or args["DynamicStepDelay"]();
                    print(delay)
                    task.wait(delay);
                end
            else
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[#path].x, path[#path].y, path[#path].z) * args["Rotation"];
            end

            if vel_fix ~= nil then
                vel_fix:Disconnect();
            end
            
            if game:GetService("Players").LocalPlayer.Character ~= nil then
                if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                end
                if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, true);
                end
            end
            
            debounce = false;
                
            if callback ~= nil and typeof(callback) == "function" then
                task.spawn(callback);
            end
        end
    end
end

--[[
    Usage:
     - coordmaster:TeleportInstance({args["Instance"} = <BasePart>, args["Position"] = CFrame.new(), args["Rotation"] = Vector3.new(), args["StepLength"] = 1, args["StepDelay"] = 0.1, args["StepType"] = 1, args["VelocityFix"] = 1}, callback);
                                                                  (destination position,            (Angles of Character)                                                              (1 - DEFAULT step,     (1 - UNSAFE fix,
                                                                  COULD BE Vector3.new())                                                                                               2 - DYNAMIC step)      2 - SAFE fix)
]]

function coordmaster:TeleportInstance(args, callback)
    assert(args ~= nil or typeof(args) ~= "table", "[Coordmaster] Arguments are nil/undefined. (should be table)");
    assert(args["Instance"] ~= nil, "[Coordmaster] Instance is nil/undefined.");
    
    if table.find(debounce2, args["Instance"]) then
        return;
    end
    
    assert(args["Position"] ~= nil, "[Coordmaster] Position is nil/undefined.");
    assert(args["StepLength"] ~= nil, "[Coordmaster] Step length is nil/undefined.");
    assert(args["StepDelay"] ~= nil, "[Coordmaster] Delay is nil/undefined.");
    
    if args["Rotation"] == nil or typeof(args["Rotation"]) ~= "CFrame" then
        args["Rotation"] = CFrame.Angles(0, math.rad(90), 0);
    end
    
    if args["StepType"] == nil or typeof(args["StepType"]) ~= "number" then
        args["StepType"] = 1; 
    end
    
    if args["VelocityFix"] == nil or typeof(args["VelocityFix"]) ~= "number" then
        args["VelocityFix"] = 1; 
    end
    
    if typeof(args["Position"]) == "CFrame" or typeof(args["Position"]) == "Vector3" then
        if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
            table.insert(debounce2, args["Instance"]);

            local current_position = args["Instance"].Position;
            local steps = math.floor(math.sqrt((args["Position"].X - current_position.X) ^ 2 + (args["Position"].Y - current_position.Y) ^ 2 + (args["Position"].Z - current_position.Z) ^ 2 ) / args["StepLength"]);
            local path = {};

            if args["StepType"] == 2 then
                for i=1, steps do
                    local random_step_length = Random.new(tick()):NextNumber(args["StepLength"] / 2, args["StepLength"]);
                        
                    steps = math.floor(math.sqrt((args["Position"].X - current_position.X) ^ 2 + (args["Position"].Y - current_position.Y) ^ 2 + (args["Position"].Z - current_position.Z) ^ 2 ) / random_step_length);
                        
                    path[#path+1] = {
                        x = current_position.X + ((args["Position"].X - current_position.X) / steps) * i,
                        y = current_position.Y + ((args["Position"].Y - current_position.Y) / steps) * i,
                        z = current_position.Z + ((args["Position"].Z - current_position.Z) / steps) * i,
                    }
                end
            else
                for i=1, steps do
                    path[#path+1] = {
                        x = current_position.X + ((args["Position"].X - current_position.X) / steps) * i,
                        y = current_position.Y + ((args["Position"].Y - current_position.Y) / steps) * i,
                        z = current_position.Z + ((args["Position"].Z - current_position.Z) / steps) * i,
                    }
                end
            end
            path[#path+1] = {x = args["Position"].X, y = args["Position"].Y, z = args["Position"].Z};
            
            local vel_fix = nil;
            local stop_tping = false;
            if args["Instance"] ~= nil and (args["Instance"].Position-Vector3.new(path[#path].x, path[#path].y, path[#path].z)).Magnitude <= 3.5 then
                stop_tping = true;
            elseif args["VelocityFix"] == 2 then
                vel_fix = game:GetService("RunService").Stepped:Connect(function()
                    if args["Instance"] == nil then
                        vel_fix:Disconnect();
                    end
                    
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, 0, 0);
                end)
            end
            
            if not stop_tping then
                for i=1, steps do
                    if i > 1 and args["Instance"] == nil then
                        debounce = false;
                        return warn("[Coordmaster] Instance got destroyed! For security reasons, script has previously stopped.");
                    end

                    if args["StopCondition"] ~= nil and args["StopCondition"]() == true then
                        debounce = false;
                        break;
                    end
                    
                    if step["VelocityFix"] <= 1 then
                        args["Instance"].Velocity = Vector3.new(0, Random.new(tick()):NextInteger(17, 20), 0);
                    end
                    
                    if args["BypassAntiTP"] then
                        args["Instance"].Anchored = false;
    
                        args["Instance"].CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
                        args["Instance"].Anchored = true;
                    else
                        args["Instance"].CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
                    end
                    
                    task.wait(args["StepDelay"]);
                end
            end

            if vel_fix ~= nil then
                vel_fix:Disconnect();
            end
            
            if args["Instance"] ~= nil then
                args["Instance"].Anchored = false;
                
                if table.find(debounce2, args["Instance"]) then
                    table.remove(debounce2, table.find(debounce2, args["Instance"]));
                end
            end
               
            if callback ~= nil and typeof(callback) == "function" then
                task.spawn(callback);
            end
        end
    end
end

return coordmaster;
