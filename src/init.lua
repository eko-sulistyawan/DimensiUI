local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Root = script
local Creator = require(Root.Creator)
local ElementsTable = require(Root.Elements)
local Acrylic = require(Root.Acrylic)
local Components = Root.Components
local NotificationModule = require(Components.Notification)

local New = Creator.New

local function GetGuiParent()
	if RunService:IsStudio() then
		return LocalPlayer:WaitForChild("PlayerGui")
	end
	if type(gethui) == "function" then
		local ok, hui = pcall(gethui)
		if ok and hui then
			return hui
		end
	end
	local ok, coreGui = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok and coreGui then
		return coreGui
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
local GUI = New("ScreenGui", {
	Parent = GetGuiParent(),
})
ProtectGui(GUI)
NotificationModule:Init(GUI)

local Library = {
	Name = "DimensiUI",
	Version = "1.0.0",
	BaseVersion = "1.1.0",

	OpenFrames = {},
	Options = {},
	Themes = require(Root.Themes).Names,

	Window = nil,
	WindowFrame = nil,
	Unloaded = false,

	Theme = "Dimensi",
	DialogOpen = false,
	UseAcrylic = true,
	Acrylic = true,
	Transparency = true,
	MinimizeKeybind = nil,
	MinimizeKey = Enum.KeyCode.LeftControl,

	GUI = GUI,
}

function Library:SafeCallback(Function, ...)
	if not Function then
		return
	end

	local Success, Event = pcall(Function, ...)
	if not Success then
		local _, i = tostring(Event):find(":%d+: ")

		if not i then
			return Library:Notify({
				Title = "Interface",
				Content = "Callback error",
				SubContent = tostring(Event),
				Duration = 5,
			})
		end

		return Library:Notify({
			Title = "Interface",
			Content = "Callback error",
			SubContent = tostring(Event):sub(i + 1),
			Duration = 5,
		})
	end
end

function Library:Round(Number, Factor)
	if Factor == 0 then
		return math.floor(Number)
	end
	Number = tostring(Number)
	return Number:find("%.") and tonumber(Number:sub(1, Number:find("%.") + Factor)) or Number
end

local Icons = require(Root.Icons).assets
function Library:GetIcon(Name)
	if Name ~= nil and Icons["lucide-" .. Name] then
		return Icons["lucide-" .. Name]
	end
	return nil
end

local Elements = {}
Elements.__index = Elements
Elements.__namecall = function(Table, Key, ...)
	return Elements[Key](...)
end

for _, ElementComponent in ipairs(ElementsTable) do
	Elements["Add" .. ElementComponent.__type] = function(self, Idx, Config)
		ElementComponent.Container = self.Container
		ElementComponent.Type = self.Type
		ElementComponent.ScrollFrame = self.ScrollFrame
		ElementComponent.Library = Library

		return ElementComponent:New(Idx, Config)
	end
end

Library.Elements = Elements

function Library:CreateWindow(Config)
	assert(Config.Title, "Window - Missing Title")

	Config.SubTitle = Config.SubTitle or ""
	Config.TabWidth = Config.TabWidth or 170
	Config.Size = Config.Size or UDim2.fromOffset(590, 470)
	if Config.Acrylic == nil then
		Config.Acrylic = true
	end
	Config.Theme = Config.Theme or "Dimensi"
	Config.MinimizeKey = Config.MinimizeKey or Enum.KeyCode.LeftControl

	if Library.Window then
		print("You cannot create more than one window.")
		return
	end

	local Window = require(Components.Window)({
		Parent = GUI,
		Size = Config.Size,
		Title = Config.Title,
		SubTitle = Config.SubTitle,
		TabWidth = Config.TabWidth,
	})

	Library.MinimizeKey = Config.MinimizeKey

	Library.UseAcrylic = Config.Acrylic
	if Library.UseAcrylic then
		Acrylic.init()
	end

	Library.Window = Window
	Library:SetTheme(Config.Theme)

	return Window
end

function Library:SetTheme(Value)
	if Library.Window and table.find(Library.Themes, Value) then
		Library.Theme = Value
		Creator.UpdateTheme()
	end
end

function Library:SetAccent(Color)
	assert(typeof(Color) == "Color3", "DimensiUI:SetAccent expects a Color3")
	local ThemesModule = require(Root.Themes)
	for _, ThemeData in pairs(ThemesModule) do
		if type(ThemeData) == "table" and ThemeData.Accent then
			ThemeData.Accent = Color
		end
	end
	Creator.UpdateTheme()
end

function Library:Destroy()
	if Library.Unloaded then
		return
	end
	Library.Unloaded = true
	if Library.Window and Library.UseAcrylic and Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Model then
		pcall(function()
			Library.Window.AcrylicPaint.Model:Destroy()
		end)
	end
	Creator.Disconnect()
	if Library.GUI then
		Library.GUI:Destroy()
	end
	Library.Window = nil
end

function Library:ToggleAcrylic(Value)
	if Library.Window then
		if Library.UseAcrylic then
			Library.Acrylic = Value
			Library.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
			if Value then
				Acrylic.Enable()
			else
				Acrylic.Disable()
			end
		end
	end
end

function Library:ToggleTransparency(Value)
	if Library.Window then
		Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = Value and 0.35 or 0
	end
end

function Library:Notify(Config)
	return NotificationModule:New(Config)
end

if getgenv then
	getgenv().DimensiUI = Library
	getgenv().Fluent = Library
end

return Library
