local LocalPlayer = game:GetService("Players").LocalPlayer;
for i=1,math.huge do
    wait();
    if LocalPlayer:FindFirstChild("launched").Value == false then
        game:GetService("ReplicatedStorage").Remotes.launchBoat:FireServer();
    else
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(2930, 415, -4.5) * CFrame.Angles(0, math.rad(90), 0);
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
        wait(0.1);
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
        local tween = game:GetService("TweenService"):Create(LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(2), {CFrame = CFrame.new(-3575, 415, -4.5) * CFrame.Angles(0, math.rad(90), 0)});
        tween:Play();
        tween.Completed:Wait();
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
        wait(2);
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-4195.18, 177.535, -17.7879) * CFrame.Angles(0, math.rad(90), 0);
        pcall(function() repeat wait(0.1); if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-4215.18, 177.535, -17.7879) * CFrame.Angles(0, math.rad(90), 0); wait(0.1); end if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-4215.18, 177.535, -17.7879) * CFrame.Angles(0, math.rad(90), 0); wait(0.1); end until LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Main"):FindFirstChild("goldShow2").Visible == true; end)
        for _,z in pairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
            for _,b in pairs(getconnections(LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Main"):FindFirstChild("goldShow2"):FindFirstChild("Frame2"):FindFirstChild("1180850802"):FindFirstChild("TextButton")[z])) do
                b:Fire();
            end
        end
        wait(10.5);
    end
end
