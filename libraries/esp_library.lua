local esp_lib = {}

function esp_lib:DrawESP(base_part, esp_type, properties)
	if base_part == nil or base_part ~= nil and not base_part:IsA("BasePart") and not base_part:IsA("Part") and not base_part:IsA("MeshPart") and not basepart:IsA("UnionOperation") then return error("[dizy's esp lib] Basepart is undefined.") end
	if esp_type == nil then return error("[dizy's esp lib] ESP Type is undefined.") elseif esp_type ~= nil and type(esp_type) == "string" and not esp_type == "Text" and not esp_type == "Circle" and not esp_type == "Square" then return error("[dizy's esp lib] Current ESP type doesn't exist.") end
	
	local drawing = Drawing.new(tostring(esp_type));
	local destroy_drawing = false;
	
	if drawing.Color ~= nil then drawing.Color = properties["Color"]; else drawing.Color = Color3.fromRGB(255, 255, 255); end
	if properties["Transparency"] ~= nil then drawing.Transparency = tonumber(properties["Transparency"]); end
	if properties["ZIndex"] ~= nil then drawing.ZIndex = tonumber(properties["ZIndex"]); end
	
	if tostring(esp_type) == "Text" then
		drawing.Text = tostring(properties["Text"]);
		drawing.Size = tonumber(properties["Size"]);
		drawing.Center = properties["Center"];
		drawing.Outline = properties["Outline"];
		if properties["OutlineColor"] ~= nil then drawing.OutlineColor = properties["OutlineColor"]; else drawing.OutlineColor = Color3.fromRGB(255, 255, 255); end
		if properties["TextBounds"] ~= nil then drawing.TextBounds = properties["TextBounds"]; end
		drawing.Font = properties["Font"];
	elseif tostring(esp_type) == "Square" then
		drawing.Thickness = tonumber(properties["Thickness"]);
		drawing.Size = properties["Size"];
		drawing.Filled = properties["Filled"];
	elseif tostring(esp_type) == "Circle" then
		drawing.Thickness = tonumber(properties["Thickness"]);
		drawing.Filled = properties["Filled"];
		drawing.NumSides = tonumber(properties["NumSides"]);
		drawing.Radius = tonumber(properties["Radius"]);
	end
	
	drawing.Visible = true;
	
	coroutine.resume(coroutine.create(function()
		while true do
			task.wait()
			if base_part == nil or not base_part:IsDescendantOf(game:GetService("Workspace")) or destroy_drawing then
				drawing:Remove();
				coroutine.yield();
			end

			local s_p, isvisible = game:GetService("Workspace").CurrentCamera:WorldToScreenPoint(base_part.Position);

			if isvisible then
				if not drawing.Visible then drawing.Visible = true; end

                local esp_points = {
                    base_part.CFrame * CFrame.new(base_part.CFrame.X / 2, base_part.CFrame.Y / 2, base_part.CFrame.Z / 2),
                    base_part.CFrame * CFrame.new(-base_part.CFrame.X / 2, base_part.CFrame.Y / 2, base_part.CFrame.Z / 2),
                    base_part.CFrame * CFrame.new(-base_part.CFrame.X / 2, -base_part.CFrame.Y / 2, base_part.CFrame.Z / 2),
                    base_part.CFrame * CFrame.new(base_part.CFrame.X / 2, -base_part.CFrame.Y / 2, base_part.CFrame.Z / 2),
                    base_part.CFrame * CFrame.new(base_part.CFrame.X / 2, base_part.CFrame.Y / 2, -base_part.CFrame.Z / 2),
                    base_part.CFrame * CFrame.new(-base_part.CFrame.X / 2, base_part.CFrame.Y / 2, -base_part.CFrame.Z / 2),
                    base_part.CFrame * CFrame.new(base_part.CFrame.X / 2, -base_part.CFrame.Y / 2, -base_part.CFrame.Z / 2),
                    base_part.CFrame * CFrame.new(-base_part.CFrame.X / 2, -base_part.CFrame.Y / 2, -base_part.CFrame.Z / 2),
                };
                local pos_x1, pos_y1 = 0, 0;
                local pos_x2, pos_y2 = game:GetService("Workspace").CurrentCamera.ViewportSize.X, game:GetService("Workspace").CurrentCamera.ViewportSize.Y;

                for _,point in pairs(esp_points) do
                    local camera_pos = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(point.Position);
                    
                    if camera_pos.X > pos_x1 then pos_x1 = camera_pos.X; end
                    if camera_pos.X < pos_x2 then pos_x2 = camera_pos.X; end
                    if camera_pos.Y > pos_x1 then pos_y1 = camera_pos.Y; end
                    if camera_pos.Y < pos_y2 then pos_y2 = camera_pos.Y; end
                end

				if properties["PositionOffset"] ~= nil then
				    drawing.Position = Vector2.new((pos_x1 - (pos_x1 - pos_x2))+properties["PositionOffset"].X, (pos_y1 - (pos_y1 - pos_y2))+properties["PositionOffset"].Y);
				else
				    drawing.Position = Vector2.new(pos_x1 - (pos_x1 - pos_x2), pos_y1 - (pos_y1 - pos_y2));
			    end
				
				if properties["SizeHandler"] ~= nil and properties["SizeHandler"] == true then
				    if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                        if (((game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-base_part.Position).Magnitude*1.75)+properties["Size"].X) < properties["Size"].X*1.5 and (((game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-base_part.Position).Magnitude*1.75)+properties["Size"].Y) < properties["Size"].Y*1.5 then 
                             drawing.Size = Vector2.new(properties["Size"].X, properties["Size"].Y);
                        else
                             drawing.Size = Vector2.new((((game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-base_part.Position).Magnitude*1.75)+properties["Size"].X), (((game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-base_part.Position).Magnitude*1.75)+properties["Size"].Y))
                        end
				    end
				end
				--[[ SizeHandler is in beta and it can give errors. Please, do not use it expecting it to perfectly work. ]]
			else
				drawing.Visible = false;
			end
		end
	end))
	
	local drawing_functions = {}
	
	if tostring(esp_type) == "Text" then
	    function drawing_functions:UpdateText(text)
            drawing.Text = tostring(text);
	    end
	end
	
	function drawing_functions:Destroy()
		destroy_drawing = true;
	end
	
	return drawing_functions;
end

return esp_lib
