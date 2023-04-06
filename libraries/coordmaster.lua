--[[
    Coordmaster - undetected way of teleporting.
    Bypasses most of games' anti-teleport.
    
    Soon I will add new feature to this script: Coordfly.
    
    2023 - i still didn't add coordfly, lmao. maybe one day i'll find a use of it and add it to the library.
]]

local coordmaster = {};

local debounce = false;
local debounce2 = {};

function coordmaster:Teleport(args, callback)
    assert(args ~= nil or typeof(args) ~= "table", "[Coordmaster] Arguments are nil/undefined. (should be table)");
    assert(args["Position"] ~= nil, "[Coordmaster] Position is nil/undefined.");
    assert(args["StepLength"] ~= nil, "[Coordmaster] Step length is nil/undefined.");
    assert(args["StepDelay"] ~= nil, "[Coordmaster] Delay is nil/undefined.");

    if debounce then
        return;
    end
    
    if not (typeof(args["Rotation"]) == "CFrame" or typeof(args["Rotation"]) == "Vector3") or args["Rotation"] == nil then
        args["Rotation"] = CFrame.Angles(0, math.rad(90), 0);
    end
    
    if typeof(args["Position"]) == "CFrame" or typeof(args["Position"]) == "Vector3" then
        if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
            debounce = true;

            local current_position = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position;
            local steps = math.floor(math.sqrt((args["Position"].X - current_position.X) ^ 2 + (args["Position"].Y - current_position.Y) ^ 2 + (args["Position"].Z - current_position.Z) ^ 2 ) / args["StepLength"]);
            local path = {};

            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
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
            
            for i=1, steps do
                if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-Vector3.new(path[#path].x, path[#path].y, path[#path].z)).Magnitude <= 5 or stop_tping then
                    stop_tping = true;
                    continue;
                end
                
                task.wait(args["StepDelay"]);
                
                if i > 1 and (game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil) then
                    debounce = false;
                    return warn("[Coordmaster] Character's RootPart (HumanoidRootPart) got destroyed! For security reasons, script has previously stopped.");
                end
                
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, Random.new(tick()):NextInteger(17, 20), 0);
                
                if args["BypassAntiTP"] then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                    
                    task.wait();
                    
                    if i > 1 and (game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil) then
                        debounce = false;
                        return warn("[Coordmaster] Character's RootPart (HumanoidRootPart) got destroyed! For security reasons, script has previously stopped.");
                    end
                    
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
                else
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
                end
            end

            if game:GetService("Players").LocalPlayer.Character ~= nil then
                if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                end
                if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, true);
                end
            end
                
            callback();

            debounce = false;
        end
    end
end

function coordmaster:TeleportInstance(args, callback)
    assert(args ~= nil or typeof(args) ~= "table", "[Coordmaster] Arguments are nil/undefined. (should be table)");
    assert(args["Instance"] ~= nil, "[Coordmaster] Instance is nil/undefined.");
    assert(args["Position"] ~= nil, "[Coordmaster] Position is nil/undefined.");
    assert(args["StepLength"] ~= nil, "[Coordmaster] Step length is nil/undefined.");
    assert(args["StepDelay"] ~= nil, "[Coordmaster] Delay is nil/undefined.");

    if table.find(debounce2, args["Instance"]) then
        return;
    end
    
    if not (typeof(args["Rotation"]) == "CFrame" or typeof(args["Rotation"]) == "Vector3") or args["Rotation"] == nil then
        args["Rotation"] = CFrame.Angles(0, math.rad(90), 0);
    end
    
    if typeof(args["Position"]) == "CFrame" or typeof(args["Position"]) == "Vector3" then
        if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
            table.insert(debounce2, args["Instance"]);

            local current_position = args["Instance"].Position;
            local steps = math.floor(math.sqrt((args["Position"].X - current_position.X) ^ 2 + (args["Position"].Y - current_position.Y) ^ 2 + (args["Position"].Z - current_position.Z) ^ 2 ) / args["StepLength"]);
            local path = {};

            args["Instance"].Anchored = true;

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
                
            local stop_tping = false;
            
            for i=1, steps do
                if args["Instance"] ~= nil and (args["Instance"].Position-Vector3.new(path[#path].x, path[#path].y, path[#path].z)).Magnitude <= 5 or stop_tping then
                    stop_tping = true;
                    continue;
                end
                
                task.wait(args["StepDelay"]);
                
                if i > 1 and args["Instance"] == nil then
                    debounce = false;
                    return warn("[Coordmaster] Instance got destroyed! For security reasons, script has previously stopped.");
                end
                
                args["Instance"].Velocity = Vector3.new(0, Random.new(tick()):NextInteger(17, 20), 0);
                if args["BypassAntiTP"] then
                    args["Instance"].Anchored = false;
                    
                    task.wait();
                    
                    if i > 1 and args["Instance"] == nil then
                        debounce = false;
                        return warn("[Coordmaster] Instance got destroyed! For security reasons, script has previously stopped.");
                    end
            
                    args["Instance"].CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
                    args["Instance"].Anchored = true;
                else
                    args["Instance"].CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * args["Rotation"];
                end
            end

            if args["Instance"] ~= nil then
                args["Instance"].Anchored = false;
            end
                
            callback();

            if table.find(debounce2, args["Instance"]) then
                table.remove(debounce2, table.find(debounce2, args["Instance"]));
            end
        end
    end
end

return coordmaster;
