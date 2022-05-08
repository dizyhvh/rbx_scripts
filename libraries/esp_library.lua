local esp_lib = {}

function esp_lib:DrawESP(base_part, esp_type, properties)
	if base_part == nil or base_part ~= nil and not base_part:IsA("BasePart") and not base_part:IsA("Part") and not base_part:IsA("MeshPart") then return error("[dizy's esp lib] Basepart is undefined.") end
	if esp_type == nil then return error("[dizy's esp lib] ESP Type is undefined.") elseif esp_type ~= nil and type(esp_type) == "string" and not esp_type == "Text" and not esp_type == "Circle" and not esp_type == "Square" then return error("[dizy's esp lib] Current ESP type doesn't exist.") end
	
	local drawing = Drawing.new(tostring(esp_type));
	local destroy_drawing = false;
	
	drawing.Color = properties["Color"];
	drawing.Transparency = tonumber(properties["Transparency"]);
	drawing.ZIndex = tonumber(properties["ZIndex"]);
	
	if tostring(esp_type) == "Text" then
		drawing.Text = tostring(properties["Text"]);
		drawing.Size = tonumber(properties["Size"]);
		drawing.Center = properties["Center"];
		drawing.Outline = properties["Outline"];
		if properties["OutlineColor"] ~= nil then drawing.OutlineColor = properties["OutlineColor"]; end
		drawing.TextBounds = properties["TextBounds"];
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
		while wait() do
			if base_part == nil or not base_part:IsDescendantOf(game:GetService("Workspace")) or destroy_drawing then
				drawing:Remove();
				coroutine.yield();
			end

			local s_p, isvisible = game:GetService("Workspace").CurrentCamera:WorldToScreenPoint(base_part.Position);

			if isvisible then
				if not drawing.Visible then drawing.Visible = true; end
				drawing.Position = Vector2.new(s_p.X, s_p.Y);
			else
				drawing.Visible = false;
			end
		end
	end))
	
	local drawing_functions = {}
	
	function drawing_functions:Destroy()
		destroy_drawing = true;
	end
	
	return drawing_functions;
end

return esp_lib
