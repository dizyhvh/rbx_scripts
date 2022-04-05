--[[
    Coordmaster - undetected way of teleporting.
    Bypasses most of games' anti-teleport.
    
    Soon I will add new feature to this script: Coordfly.
]]

local coordmaster = {};
local debounce = false;
local stop_coroutine;

function coordmaster:Teleport(position, step_length, step_delay, bypass_anti_tp, callback)
    if step_length == nil then return warn("[Coordmaster] Step length is nil/undefined."); end if step_delay == nil then return warn("[Coordmaster] Delay is nil/undefined."); end

    if not debounce then
        if typeof(position) == "CFrame" or typeof(position) == "Vector3" then
            if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
                debounce = true;

                local current_position = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position;
                local steps = math.floor(math.sqrt((position.X - current_position.X) ^ 2 + (position.Y - current_position.Y) ^ 2 + (position.Z - current_position.Z) ^ 2 ) / step_length);
                local path = {};

                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, false);
                
                for i=1, steps do
                    path[#path+1] = {
                        x = current_position.X + ((position.X - current_position.X) / steps) * i,
                        y = current_position.Y + ((position.Y - current_position.Y) / steps) * i,
                        z = current_position.Z + ((position.Z - current_position.Z) / steps) * i,
                    }
                end
                path[#path+1] = {x = position.X, y = position.Y, z = position.Z};

                if bypass_anti_tp then
                    coroutine.resume(coroutine.create(function()
                         if not stop_coroutine then
                             if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
                                 game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Swimming);
                             else
                                 coroutine.yield()
                             end
                         else
                             coroutine.yield()
                         end
                    end))
                end
                
                for i=1, steps do
                    wait(step_delay);
                    if bypass_anti_tp then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall, false);
                        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
                        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Flying, false);
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z);
                        task.wait(0.025);
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
                    else
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(path[i].x, path[i].y, path[i].z);
                    end
                end

                game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, true);
                wait(2);
                
                callback();
                
                if bypass_anti_tp then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall, true);
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.FallingDown, true);
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Flying, true);
                end

                debounce = false;
            end
        end
    else
        return;
    end
end

return coordmaster;
