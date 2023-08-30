local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;

local Debounce = false;
local coordmaster = {};
function coordmaster:Teleport(args, callback)
    if Debounce then
        return;
    end
    
    if LocalPlayer.Character == nil or LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil then
        return;
    end

    assert(args ~= nil or typeof(args) ~= "table", "[Coordmaster] Arguments are undefined. (should be table)");
    if typeof(args["Position"]) ~= "CFrame" and typeof(args["Position"]) ~= "Vector3" then
        return error("[Coordmaster] Position is undefined. (expected Vector3 or CFrame)");
    end
    assert(args["StepLength"] ~= nil, "[Coordmaster] Step length is undefined. (expected number)");
    if args["StepDelay"] == nil and args["DynamicStepDelay"] == nil then
        return error("[Coordmaster] Delay is undefined. (expected number or function)");
    end
    
    if typeof(args["Rotation"]) ~= "CFrame" then
        args["Rotation"] = CFrame.Angles(0, math.rad(90), 0);
    end
    
    if typeof(args["StepType"]) ~= "number" then
        args["StepType"] = 1; 
    end
    
    if typeof(args["VelocityFix"]) ~= "number" then
        args["VelocityFix"] = 1; 
    end

    local currentPosition = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position;

    if (currentPosition-Vector3.new(args["Position"].X, args["Position"].Y, args["Position"].Z)).Magnitude <= args["StepLength"] then
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(args["Position"].X, args["Position"].Y, args["Position"].Z);
        return;
    end

    local steps = nil;
    if args["StepType"] == 2 then
        steps = math.floor(math.sqrt((args["Position"].X - currentPosition.X) ^ 2 + (args["Position"].Y - currentPosition.Y) ^ 2 + (args["Position"].Z - currentPosition.Z) ^ 2 ) / args["StepLength"]);
    else
        local randomStepLength = Random.new(tick()):NextNumber(args["StepLength"] / 1.5, args["StepLength"]);
        steps = math.floor(math.sqrt((args["Position"].X - currentPosition.X) ^ 2 + (args["Position"].Y - currentPosition.Y) ^ 2 + (args["Position"].Z - currentPosition.Z) ^ 2 ) / randomStepLength);
    end
    local path = {};

    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, false);
                
    for i=1, steps do
        if args["StepType"] == 2 then
            
            steps = math.floor(math.sqrt((args["Position"].X - currentPosition.X) ^ 2 + (args["Position"].Y - currentPosition.Y) ^ 2 + (args["Position"].Z - currentPosition.Z) ^ 2 ) / random_step_length);
        end

        path[#path+1] = {
            x = currentPosition.X + ((args["Position"].X - currentPosition.X) / steps) * i,
            y = currentPosition.Y + ((args["Position"].Y - currentPosition.Y) / steps) * i,
            z = currentPosition.Z + ((args["Position"].Z - currentPosition.Z) / steps) * i,
        }
    end
    path[#path+1] = {x = args["Position"].X, y = args["Position"].Y, z = args["Position"].Z};
            
    if args["VelocityFix"] == 2 then
        velFix = game:GetService("RunService").Stepped:Connect(function()
            if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil then
                vel_fix:Disconnect();
            end
                    
            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").AssemblyAngularVelocity = Vector3.new(0, 0, 0);
            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, 0, 0);
        end)
    end
            
    Debounce = true;

    for i=1, steps do
        if LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil or args["StopCondition"] ~= nil and args["StopCondition"]() == true then
            if velFix ~= nil then
                velFix:Disconnect();
            end
                        
            Debounce = false;
            return;
        end

        if path[i] == nil then
            break;
        end
                    
        if args["VelocityFix"] <= 1 then
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, Random.new(tick()):NextInteger(17, 20), 0);
        end
                        
        if args["BypassAntiTP"] then
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;      
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
        else
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
        end

        local delay = args["StepDelay"] ~= nil and args["StepDelay"] or args["DynamicStepDelay"]();
        task.wait(delay);
    end

    if velFix ~= nil then
        velFix:Disconnect();
    end
            
    if LocalPlayer.Character ~= nil then
        if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
        end
        if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, true);
        end
    end
            
    Debounce = false;
                
    if typeof(callback) == "function" then
        task.spawn(callback);
    end
end

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

            local currentPosition = args["Instance"].Position;
            local steps = math.floor(math.sqrt((args["Position"].X - currentPosition.X) ^ 2 + (args["Position"].Y - currentPosition.Y) ^ 2 + (args["Position"].Z - currentPosition.Z) ^ 2 ) / args["StepLength"]);
            local path = {};

            if args["StepType"] == 2 then
                for i=1, steps do
                    local random_step_length = Random.new(tick()):NextNumber(args["StepLength"] / 2, args["StepLength"]);
                        
                    steps = math.floor(math.sqrt((args["Position"].X - currentPosition.X) ^ 2 + (args["Position"].Y - currentPosition.Y) ^ 2 + (args["Position"].Z - currentPosition.Z) ^ 2 ) / random_step_length);
                        
                    path[#path+1] = {
                        x = currentPosition.X + ((args["Position"].X - currentPosition.X) / steps) * i,
                        y = currentPosition.Y + ((args["Position"].Y - currentPosition.Y) / steps) * i,
                        z = currentPosition.Z + ((args["Position"].Z - currentPosition.Z) / steps) * i,
                    }
                end
            else
                for i=1, steps do
                    path[#path+1] = {
                        x = currentPosition.X + ((args["Position"].X - currentPosition.X) / steps) * i,
                        y = currentPosition.Y + ((args["Position"].Y - currentPosition.Y) / steps) * i,
                        z = currentPosition.Z + ((args["Position"].Z - currentPosition.Z) / steps) * i,
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
