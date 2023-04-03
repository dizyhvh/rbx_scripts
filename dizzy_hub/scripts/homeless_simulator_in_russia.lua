local ui_library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/dizyhvh/test_scripts/main/2.lua')))();
local gui = ui_library:NewGui();
local tab1 = gui:NewTab("Main");

getgenv().AutoClicker = false;

tab1:NewCheckbox("Auto Clicker", function(bool)
    getgenv().AutoClicker = bool;
    
    if bool then
        getgenv().ACCon = false;
        
        coroutine.resume(coroutine.create(function()
            while wait() do
                if not getgenv().AutoClicker or getgenv().ACCon == true then
                    getgenv().ACCon = false;
                    continue;
                end
                
                if game:GetService("Players").LocalPlayer.Character == nil or game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool") == nil then
                    continue;
                end
                
                game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):Activate();
            end
        end))
    else
        getgenv().ACCon = true;
    end
end)
