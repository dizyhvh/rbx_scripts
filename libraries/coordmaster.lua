--[[
    Coordmaster - undetected way of teleporting.
    Bypasses most of games' anti-teleport.
    
    Soon I will add new feature to this script: Coordfly.
    
    2023 - i still didn't add coordfly, lmao. maybe one day i'll find a use of it and add it to the library.
]]

local coordmaster = {};
local debounce = false;
local debounce2 = {};

function coordmaster:Teleport(position, angles, step_type, step_length, step_delay, bypass_anti_tp, callback)
    assert(position ~= nil, "[Coordmaster] Position is nil/undefined.");
    assert(step_length ~= nil, "[Coordmaster] Step length is nil/undefined.");
    assert(step_delay ~= nil, "[Coordmaster] Delay is nil/undefined.");

    if debounce then
        return;
    end
    
    if not (typeof(angles) == "CFrame" or typeof(angles) == "Vector3") or angles == nil then
        angles = CFrame.Angles(0, math.rad(90), 0);
    end
    
    if typeof(position) == "CFrame" or typeof(position) == "Vector3" then
        if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
            debounce = true;

            local current_position = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position;
            local steps = math.floor(math.sqrt((position.X - current_position.X) ^ 2 + (position.Y - current_position.Y) ^ 2 + (position.Z - current_position.Z) ^ 2 ) / step_length);
            local path = {};

            game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, false);
                
            if step_type == 2 then
                for i=1, steps do
                    local random_step_length = Random.new(tick()):NextNumber(step_length-1, step_length);
                        
                    steps = math.floor(math.sqrt((position.X - current_position.X) ^ 2 + (position.Y - current_position.Y) ^ 2 + (position.Z - current_position.Z) ^ 2 ) / random_step_length);
                        
                    path[#path+1] = {
                        x = current_position.X + ((position.X - current_position.X) / steps) * i,
                        y = current_position.Y + ((position.Y - current_position.Y) / steps) * i,
                        z = current_position.Z + ((position.Z - current_position.Z) / steps) * i,
                    }
                end
            else
                for i=1, steps do
                    path[#path+1] = {
                        x = current_position.X + ((position.X - current_position.X) / steps) * i,
                        y = current_position.Y + ((position.Y - current_position.Y) / steps) * i,
                        z = current_position.Z + ((position.Z - current_position.Z) / steps) * i,
                    }
                end
            end
            path[#path+1] = {x = position.X, y = position.Y, z = position.Z};
                
            local stop_tping = false;
            
            for i=1, steps do
                if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-Vector3.new(path[#path].x, path[#path].y, path[#path].z)).Magnitude <= 5 or stop_tping then
                    stop_tping = true;
                    continue;
                end
                
                task.wait(step_delay);
                
                if i > 1 and (game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil) then
                    return warn("[Coordmaster] Character's RootPart (HumanoidRootPart) got destroyed! For security reasons, script has previously stopped.");
                end
                
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, Random.new(tick()):NextInteger(17, 20), 0);
                
                if bypass_anti_tp then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                    
                    task.wait();
                    
                    if i > 1 and (game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil) then
                        return warn("[Coordmaster] Character's RootPart (HumanoidRootPart) got destroyed! For security reasons, script has previously stopped.");
                    end
                    
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * angles;
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
                else
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * angles;
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

function coordmaster:TeleportInstance(instance, position, angles, step_type, step_length, step_delay, bypass_anti_tp, callback)
    assert(instance ~= nil, "[Coordmaster] Instance is nil/undefined.");
    assert(position ~= nil, "[Coordmaster] Position is nil/undefined.");
    assert(step_length ~= nil, "[Coordmaster] Step length is nil/undefined.");
    assert(step_delay ~= nil, "[Coordmaster] Delay is nil/undefined.");

    if table.find(debounce2, instance) then
        return;
    end
    
    if not (typeof(angles) == "CFrame" or typeof(angles) == "Vector3") or angles == nil then
        angles = CFrame.Angles(0, math.rad(90), 0);
    end
    
    if typeof(position) == "CFrame" or typeof(position) == "Vector3" then
        if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
            table.insert(debounce2, instance);

            local current_position = instance.Position;
            local steps = math.floor(math.sqrt((position.X - current_position.X) ^ 2 + (position.Y - current_position.Y) ^ 2 + (position.Z - current_position.Z) ^ 2 ) / step_length);
            local path = {};

            instance.Anchored = true;

            if step_type == 2 then
                for i=1, steps do
                    local random_step_length = Random.new(tick()):NextNumber(step_length-1, step_length);
                        
                    steps = math.floor(math.sqrt((position.X - current_position.X) ^ 2 + (position.Y - current_position.Y) ^ 2 + (position.Z - current_position.Z) ^ 2 ) / random_step_length);
                        
                    path[#path+1] = {
                        x = current_position.X + ((position.X - current_position.X) / steps) * i,
                        y = current_position.Y + ((position.Y - current_position.Y) / steps) * i,
                        z = current_position.Z + ((position.Z - current_position.Z) / steps) * i,
                    }
                end
            else
                for i=1, steps do
                    path[#path+1] = {
                        x = current_position.X + ((position.X - current_position.X) / steps) * i,
                        y = current_position.Y + ((position.Y - current_position.Y) / steps) * i,
                        z = current_position.Z + ((position.Z - current_position.Z) / steps) * i,
                    }
                end
            end
            path[#path+1] = {x = position.X, y = position.Y, z = position.Z};
                
            local stop_tping = false;
            
            for i=1, steps do
                if instance ~= nil and (instance.Position-Vector3.new(path[#path].x, path[#path].y, path[#path].z)).Magnitude <= 5 or stop_tping then
                    stop_tping = true;
                    continue;
                end
                
                task.wait(step_delay);
                
                if i > 1 and instance == nil then
                    return warn("[Coordmaster] Instance got destroyed! For security reasons, script has previously stopped.");
                end
                
                instance.Velocity = Vector3.new(0, Random.new(tick()):NextInteger(17, 20), 0);
                if bypass_anti_tp then
                    instance.Anchored = false;
                    
                    task.wait();
                    
                    if i > 1 and instance == nil then
                        return warn("[Coordmaster] Instance got destroyed! For security reasons, script has previously stopped.");
                    end
            
                    instance.CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * angles;
                    instance.Anchored = true;
                else
                    instance.CFrame = CFrame.new(path[i].x, path[i].y, path[i].z) * angles;
                end
            end

            if instance ~= nil then
                instance.Anchored = false;
            end
                
            callback();

            if table.find(debounce2, instance) then
                table.remove(debounce2, table.find(debounce2, instance));
            end
        end
    end
end

return coordmaster;
