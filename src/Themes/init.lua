local Themes = {
	Names = {
		"Dimensi",
		"Dark",
		"Darker",
		"Light",
		"Aqua",
		"Amethyst",
		"Rose",
	},
}

for _, Theme in next, script:GetChildren() do
	if Theme:IsA("ModuleScript") then
		local Required = require(Theme)
		Themes[Required.Name] = Required
	end
end

return Themes
