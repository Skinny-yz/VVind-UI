
-- Vind Ui Reborn v2.7.7
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CONFIG = {
	SourceUrl = "https://raw.githubusercontent.com/Skinny-yz/VVind-UI/refs/heads/main/src.lua",
	FeedbackWebhook = "",
	CloudBaseUrl = "",
	SpotifyBridgeUrl = "",
	SpotifyConnectUrl = "",
	OpenRouterApiKey = "",
	CommunityUrl = "",
}

local VindUI = loadstring(game:HttpGet(CONFIG.SourceUrl))()
VindUI:PreloadIcons({ "Lucide", "Material", "Phosphor", "SF" })
VindUI:SetScaleRange(0.75, 1.35)

local TOGGLE_KEY = Enum.KeyCode.RightShift
local Tabs = {}

local Window = VindUI:CreateWindow({
	Title = "Vind Ui Reborn",
	Subtitle = "Complete Showcase · v" .. tostring(VindUI.Version),
	Icon = "Lucide:sparkles",
	Size = UDim2.fromOffset(640, 455),
	MinSize = Vector2.new(500, 360),
	Draggable = true,
	Resizable = true,
	UseBlur = true,
	DefaultTab = "Home",
})

VindUI:Notify({
	Title = "Vind Ui Reborn",
	Text = "Showcase loaded. Use the search button to find any element.",
	Type = "success",
	Duration = 4,
})

-- Optional integrations. Blank values keep the showcase safe for GitHub.
local Assistant = VindUI:CreateAIAssistant({
	Providers = {{
		Name = "OpenRouter",
		Endpoint = "https://openrouter.ai/api/v1/chat/completions",
		ApiKey = CONFIG.OpenRouterApiKey,
		Model = "openrouter/free",
	}},
	Window = Window,
	Persist = "vind-showcase-assistant",
})

local Cloud = VindUI:CloudService({
	BaseUrl = CONFIG.CloudBaseUrl,
	Script = "vind-ui-reborn-showcase",
})

local ChatDockButton, CloudDockButton, GlobalChatDockButton

local ChatPanel = Window:AddChatPanel({
	Title = "Vind Assistant",
	Icon = "bot",
	Placeholder = "Ask about this interface...",
	OnToggle = function(open)
		if ChatDockButton then ChatDockButton:SetActive(open) end
	end,
	OnClear = function() Assistant:Reset() end,
	OnSend = function(panel, text)
		if CONFIG.OpenRouterApiKey == "" then
			panel:AddMessage("assistant", "Add your API key to CONFIG.OpenRouterApiKey to enable the assistant.")
			return
		end
		Assistant:Ask(panel, text)
	end,
	OnStop = function() Assistant:Stop() end,
	OnRegenerate = function(panel, text)
		if CONFIG.OpenRouterApiKey ~= "" then Assistant:Ask(panel, text) end
	end,
})

local CloudPanel = Window:AddCloudPanel({
	Service = Cloud,
	OnToggle = function(open)
		if CloudDockButton then CloudDockButton:SetActive(open) end
	end,
})

local GlobalChatPanel = Window:AddGlobalChatPanel({
	Service = Cloud,
	Icon = "messages-square",
	OnToggle = function(open)
		if GlobalChatDockButton then GlobalChatDockButton:SetActive(open) end
	end,
})

Window:AddSpotifyPanel({
	Title = "Spotify Remote",
	Icon = "Lucide:music-2",
	BridgeUrl = CONFIG.SpotifyBridgeUrl,
	ConnectUrl = CONFIG.SpotifyConnectUrl,
	EmbedMode = true,
	AutoConnect = CONFIG.SpotifyBridgeUrl ~= "",
})

ChatDockButton = Window:AddDockButton({
	Icon = "Lucide:bot",
	Callback = function() ChatPanel:Toggle() end,
})
CloudDockButton = Window:AddDockButton({
	Icon = "Lucide:cloud",
	Callback = function() CloudPanel.Toggle() end,
})
GlobalChatDockButton = Window:AddDockButton({
	Icon = "Lucide:messages-square",
	Callback = function() GlobalChatPanel.Toggle() end,
})

-- ==================== HOME ====================

Tabs.Home = Window:AddTab({ Name = "Home", Icon = "Lucide:layout-dashboard" })

local Details = Tabs.Home:AddSubTab({ Name = "Details And Info", Icon = "Lucide:layout-grid" })

local function greeting()
	local hour = tonumber(os.date("%H"))
	if hour < 5 then return "Burning the midnight oil, huh?" end
	if hour < 12 then return "Good morning." end
	if hour < 18 then return "Good afternoon." end
	return "Good evening."
end

Details:AddCard({
	UserId      = LocalPlayer.UserId,
	Title       = "Hello, " .. LocalPlayer.DisplayName,
	Description = greeting(),
	Rating = {
		Title       = "Rate Vind Ui Reborn",
		Placeholder = "Tell us what you think...",
		WebhookUrl  = CONFIG.FeedbackWebhook,
	},
})

-- FPS, ping, executor, run count, region, and time of day all update
-- themselves -- nothing to wire up here.
local systemGrid = Details:AddSystemInfoGrid({
	Description = "Live session and client info",
})

-- Heartbeats this device to the same backend used by the cloud configs/
-- chat panels above (Cloud, declared in the CLOUD CONFIGS section).
-- Shows how many devices are currently running this script.
local activeUsersGrid = Details:AddActiveUsersGrid({
	Service     = CONFIG.CloudBaseUrl ~= "" and Cloud or nil,
	Description = "Live users — configure CloudBaseUrl to enable",
	Interval    = 30,
})

local ScriptChangelog = Tabs.Home:AddSubTab({ Name = "Script Changelog", Icon = "Lucide:file-text" })
ScriptChangelog:AddChangelogEntry({
	Version = "Vind Ui Reborn 2.7.7",
	Date    = "Showcase release",
	Changes = {
		{ Type = "Added",   Text = "Complete public usage example" },
		{ Type = "Added",   Text = "Spotify, assistant, cloud and global chat panels" },
		{ Type = "Changed", Text = "Showcase reorganized around real workflows" },
		{ Type = "Fixed",   Text = "All public credentials replaced with safe placeholders" },
	},
})

ScriptChangelog:AddChangelogEntry({
	Version = "Library 2.7",
	Date = "Previous release",
	Changes = {
		{ Type = "Added", Text = "Configuration metadata and cloud profiles" },
		{ Type = "Added", Text = "Responsive card grids and sortable tables" },
		{ Type = "Changed", Text = "Improved mobile scaling and window behavior" },
	},
})

-- Same anonymous backend as the Active Users grid above (Cloud) -- ranks
-- devices by lifetime total_seconds heartbeated, no avatar/username/UserId
-- involved anywhere. Replaces the old UI Changelog sub-tab.
local Leaderboard = Tabs.Home:AddSubTab({ Name = "Leaderboard", Icon = "Lucide:trophy" })
local leaderboard = Leaderboard:AddLeaderboard({
	Service     = CONFIG.CloudBaseUrl ~= "" and Cloud or nil,
	Description = "Community activity — configure CloudBaseUrl to enable",
})

-- ==================== GENERAL ====================

Tabs.General = Window:AddTab({ Name = "General", Icon = "Lucide:house" })

local Welcome = Tabs.General:AddSubTab({ Name = "Welcome", Icon = "Lucide:info" })
Welcome:AddParagraph({
	Title = "Built like a real script",
	Icon  = "Lucide:sparkles",
	Text  = "This showcase demonstrates every public Vind Ui Reborn component in a polished, usable layout.\n\n"
		.. "Use the sub-tabs above to navigate, or press Ctrl+K to search every labeled control.",
})

local Profile = Tabs.General:AddSubTab({ Name = "Profile", Icon = "Material:person" })
Profile:AddCard({
	UserId      = LocalPlayer.UserId,
	Title       = "My Profile",
	Description = "Click to view your information",
	Callback = function()
		VindUI:Notify({
			Title = "Profile",
			Text  = "Name: " .. LocalPlayer.Name,
			Type  = "info",
			Duration = 3,
		})
	end,
})
Profile:AddDivider()
Profile:AddButton({
	Text        = "Show User ID",
	Description = "Displays your User ID",
	Icon        = "Material:badge",
	Callback = function()
		VindUI:Notify({
			Title = "User ID",
			Text  = tostring(LocalPlayer.UserId),
			Type  = "info",
			Duration = 3,
		})
	end,
})
Profile:AddDivider()
Profile:AddRating({
	Title       = "How's the Profile tab?",
	Placeholder = "Optional comment...",
	MaxStars    = 5,
	WebhookUrl  = CONFIG.FeedbackWebhook,
})

local Actions = Tabs.General:AddSubTab({ Name = "Actions", Icon = "Phosphor:lightning" })
Actions:AddSection("Quick Actions", "Phosphor:lightning")

Actions:AddButton({
	Text        = "Save Settings",
	Description = "Saves every setting marked with a Flag",
	Icon        = "Phosphor:floppy-disk",
	Callback = function()
		local saved, err = VindUI:SaveConfig("example", {
			Description = "Vind Ui Reborn complete showcase",
			Tags = { "showcase", "public" },
		})
		VindUI:Notify({
			Title = saved and "Saved" or "Could not save",
			Text  = saved and "Settings written to NullUI/Configs/example.json"
				or tostring(err),
			Type  = saved and "success" or "error",
			Duration = 3,
		})
	end,
})

Actions:AddButton({
	Text        = "Load Settings",
	Description = "Restores whatever was last saved",
	Icon        = "Phosphor:folder-open",
	Callback = function()
		local loaded, err = VindUI:LoadConfig("example", true)
		VindUI:Notify({
			Title = loaded and "Loaded" or "Nothing to load",
			Text  = loaded and "Settings restored" or tostring(err),
			Type  = loaded and "success" or "warning",
			Duration = 3,
		})
	end,
})

Actions:AddButton({
	Text        = "Print Current Config",
	Description = "Dumps every flagged value to the console via VindUI:GetConfig()",
	Icon        = "Phosphor:code",
	Callback = function()
		local config = VindUI:GetConfig()
		for flag, value in pairs(config) do
			print(("[Config] %s = %s"):format(flag, tostring(value)))
		end
		VindUI:Notify({ Title = "Config", Text = "Printed to console/output", Type = "info", Duration = 3 })
	end,
})

Actions:AddButton({
	Text = "List Saved Configs",
	Description = "Shows every local profile returned by VindUI:ListConfigs()",
	Icon = "Lucide:list-tree",
	Callback = function()
		local configs, err = VindUI:ListConfigs()
		if err then
			VindUI:Notify({ Title = "Configs", Text = tostring(err), Type = "warning", Duration = 4 })
			return
		end
		local names = {}
		for _, config in ipairs(configs) do table.insert(names, config.Name) end
		VindUI:Notify({
			Title = "Saved Configs",
			Text = #names > 0 and table.concat(names, ", ") or "No saved configs yet.",
			Type = "info",
			Duration = 4,
		})
	end,
})

Actions:AddButton({
	Text = "Open Profile Modal",
	Description = "Demonstrates VindUI:Modal() with multiple fields",
	Icon = "Lucide:panel-top-open",
	Callback = function()
		VindUI:Modal({
			Title = "Create a profile",
			Text = "Enter a name and optional tags for this configuration.",
			Window = Window,
			Fields = {
				{ Name = "Name", Placeholder = "Profile name" },
				{ Name = "Tags", Placeholder = "clean, mobile, visuals", Type = "tags" },
			},
			ConfirmText = "Create",
			Callback = function(confirmed, values)
				if not confirmed then return end
				VindUI:Notify({ Title = "Profile", Text = "Created " .. tostring(values.Name), Type = "success" })
			end,
		})
	end,
})

Actions:AddButton({
	Text        = "Reset All",
	Description = "Restores every setting to its default (asks for confirmation)",
	Icon        = "Phosphor:arrow-counter-clockwise",
	Callback = function()
		VindUI:Confirm({
			Title  = "Reset everything?",
			Text   = "Every setting goes back to its default value. This cannot be undone.",
			ConfirmText = "Reset",
			CancelText  = "Cancel",
			Danger = true,
			Window = Window,
			Callback = function(confirmed)
				if not confirmed then return end
				VindUI:SetConfig({
					darkMode = true,
					blur = true,
					sfx = true,
					renderDistance = 250,
					maxFps = 60,
				}, false)
				VindUI:Notify({ Title = "Reset", Text = "Everything was reset", Type = "warning", Duration = 3 })
			end,
		})
	end,
})

Actions:AddDivider()
Actions:AddParagraph({
	Title = "Statistics",
	Icon  = "Phosphor:chart-bar",
	Text  = "Players online: " .. #Players:GetPlayers(),
})

local WindowControls = Tabs.General:AddSubTab({ Name = "Window", Icon = "Lucide:app-window" })
WindowControls:AddSection("Window API", "Lucide:app-window")

WindowControls:AddButton({
	Text        = "Toggle Fullscreen",
	Description = "Window:ToggleFullscreen()",
	Icon        = "Lucide:maximize",
	Callback    = function() Window:ToggleFullscreen() end,
})
WindowControls:AddButton({
	Text        = "Rename Window",
	Description = "Window:SetTitle(title, subtitle)",
	Icon        = "Lucide:pencil",
	Callback = function()
		Window:SetTitle("Vind Ui Reborn", "Renamed at " .. os.date("%H:%M:%S"))
	end,
})
WindowControls:AddButton({
	Text        = "Jump To Settings Tab",
	Description = "Window:SelectTab(\"Settings\")",
	Icon        = "Lucide:arrow-right",
	Callback    = function() Window:SelectTab("Settings") end,
})
WindowControls:AddButton({
	Text        = "Close Window",
	Description = "Window:Close() -- reopen with " .. TOGGLE_KEY.Name,
	Icon        = "Lucide:x",
	Callback    = function() Window:Close() end,
})
WindowControls:AddDivider()
WindowControls:AddLabel("Window:IsOpen() currently reports: will print to console below")
WindowControls:AddButton({
	Text = "Print IsOpen()",
	Icon = "Lucide:terminal",
	Callback = function() print("[Window] IsOpen:", Window:IsOpen()) end,
})

local ApiLab = Tabs.General:AddSubTab({ Name = "API Lab", Icon = "Lucide:braces" })
ApiLab:AddParagraph({
	Title = "Programmatic API",
	Icon = "Lucide:code-xml",
	Text = "These actions demonstrate snapshots, direct flag updates, navigation, metadata and text sanitization without cluttering the main showcase.",
})

local LastSnapshot
ApiLab:AddButton({
	Text = "Create Snapshot",
	Description = "Stores every flagged value in memory",
	Icon = "Lucide:camera",
	Callback = function()
		LastSnapshot = VindUI:CreateSnapshot()
		VindUI:Notify({ Title = "Snapshot", Text = "Current UI state captured.", Type = "success" })
	end,
})
ApiLab:AddButton({
	Text = "Restore Snapshot",
	Description = "Restores the last state captured above",
	Icon = "Lucide:history",
	Callback = function()
		local ok, err = VindUI:RestoreSnapshot(LastSnapshot, false)
		VindUI:Notify({ Title = ok and "Restored" or "No snapshot", Text = ok and "UI state restored." or tostring(err), Type = ok and "success" or "warning" })
	end,
})
ApiLab:AddButton({
	Text = "Toggle Blur Through Its Flag",
	Description = "Uses SetUIElementValue instead of holding the component object",
	Icon = "Lucide:scan",
	Callback = function()
		local current = VindUI:GetConfig().blur
		VindUI:SetUIElementValue("blur", not current, false)
	end,
})
ApiLab:AddButton({
	Text = "Jump To Primary Color",
	Description = "Opens the correct tab and highlights the matching control",
	Icon = "Lucide:locate-fixed",
	Callback = function() Window:JumpToElement("Primary Color") end,
})
ApiLab:AddButton({
	Text = "Inspect Example Config Metadata",
	Description = "Reads GetConfigMeta() after a local save",
	Icon = "Lucide:file-json-2",
	Callback = function()
		local meta, err = VindUI:GetConfigMeta("example")
		VindUI:Notify({
			Title = meta and (meta.Name or "example") or "No metadata",
			Text = meta and (meta.Description ~= "" and meta.Description or "Saved configuration") or tostring(err),
			Type = meta and "info" or "warning",
		})
	end,
})
ApiLab:AddButton({
	Text = "Sanitize Sample Text",
	Description = "Demonstrates the public text sanitizer used by feedback tools",
	Icon = "Lucide:shield-check",
	Callback = function()
		local clean, blocked, reason = VindUI:SanitizeText("Vind Ui Reborn — public showcase!", { MaxLength = 120 })
		VindUI:Notify({ Title = blocked and "Blocked" or "Sanitized", Text = blocked and tostring(reason) or clean, Type = blocked and "warning" or "success" })
	end,
})

ApiLab:AddLineText("Navigation methods")
ApiLab:AddButton({
	Text = "Select Settings / Customization",
	Description = "Uses SelectTab and SelectSubTabByName together",
	Icon = "Lucide:route",
	Callback = function()
		Window:SelectTab("Settings")
		task.defer(function() Tabs.Settings:SelectSubTabByName("Customization") end)
	end,
})
ApiLab:AddButton({
	Text = "Close and Reopen",
	Description = "Demonstrates Window:Close() and Window:Open()",
	Icon = "Lucide:refresh-cw",
	Callback = function()
		Window:Close()
		task.delay(1, function() Window:Open() end)
	end,
})

-- ==================== SETTINGS ====================

Tabs.Settings = Window:AddTab({ Name = "Settings", Icon = "SF:gear" })

local GeneralSettings = Tabs.Settings:AddSubTab({ Name = "General", Icon = "SF:slider.horizontal.3" })
GeneralSettings:AddSection("General Settings")

local DarkModeToggle = GeneralSettings:AddToggle({
	Text        = "Dark Mode",
	Description = "Enable the dark theme",
	Icon        = "SF:moon",
	Flag        = "darkMode",
	Default     = true,
	Callback    = function(value) print("Dark Mode:", value) end,
})

local BlurToggle = GeneralSettings:AddToggle({
	Text        = "Background Blur",
	Description = "Blurs the world while the panel is open",
	Icon        = "SF:drop",
	Flag        = "blur",
	Default     = true,
	Callback    = function(value) VindUI:SetBlurEnabled(value) end,
})

local SoundToggle = GeneralSettings:AddToggle({
	Text        = "Sound Effects",
	Description = "Turns sounds on or off",
	Icon        = "SF:speaker.wave.2",
	Flag        = "sfx",
	Default     = true,
	Callback    = function(value) print("Sound Effects:", value) end,
})

GeneralSettings:AddDivider()
GeneralSettings:AddSection("Performance")

local RenderSlider = GeneralSettings:AddSlider({
	Text        = "Render Distance",
	Description = "Adjusts the render distance",
	Icon        = "SF:eye",
	Flag        = "renderDistance",
	Min = 50, Max = 500, Default = 250, Increment = 25,
	Suffix      = " studs",
	Callback    = function(value) print("Render Distance:", value) end,
})

local FpsSlider = GeneralSettings:AddSlider({
	Text        = "Max FPS",
	Description = "Limits the game's frame rate",
	Icon        = "SF:gauge",
	Flag        = "maxFps",
	Min = 30, Max = 240, Default = 60, Increment = 5,
	Callback    = function(value) print("Max FPS:", value) end,
})

local Audio = Tabs.Settings:AddSubTab({ Name = "Audio", Icon = "Material:volume_up" })
Audio:AddSection("Audio Controls", "Material:tune")

Audio:AddSlider({
	Text = "Master Volume", Description = "Overall volume", Icon = "Material:volume_up",
	Flag = "volMaster", Min = 0, Max = 100, Default = 80, Increment = 5, Suffix = "%",
	Callback = function(value) print("Master Volume:", value) end,
})
Audio:AddSlider({
	Text = "Music Volume", Description = "Music volume", Icon = "Material:music_note",
	Flag = "volMusic", Min = 0, Max = 100, Default = 70, Increment = 5, Suffix = "%",
	Callback = function(value) print("Music Volume:", value) end,
})
Audio:AddSlider({
	Text = "SFX Volume", Description = "Sound effects volume", Icon = "Material:audiotrack",
	Flag = "volSfx", Min = 0, Max = 100, Default = 85, Increment = 5, Suffix = "%",
	Callback = function(value) print("SFX Volume:", value) end,
})

local Customization = Tabs.Settings:AddSubTab({ Name = "Customization", Icon = "Phosphor:paint-brush" })
Customization:AddSection("Colors", "Phosphor:palette")

local PrimaryColor = Customization:AddColorPicker({
	Text        = "Primary Color",
	Description = "Main interface color",
	Icon        = "Phosphor:palette",
	Flag        = "primaryColor",
	Default     = Color3.fromRGB(255, 90, 90),
	Callback    = function(color) print("Primary Color:", color) end,
})

local SecondaryColor = Customization:AddColorPicker({
	Text        = "Secondary Color",
	Description = "Secondary interface color",
	Icon        = "Phosphor:swatches",
	Flag        = "secondaryColor",
	Default     = Color3.fromRGB(90, 90, 255),
	Callback    = function(color) print("Secondary Color:", color) end,
})

Customization:AddDivider()
Customization:AddSection("Keybinds", "Phosphor:keyboard")

Customization:AddKeybind({
	Text        = "Open Menu",
	Description = "Key that opens and closes the panel",
	Icon        = "Phosphor:keyboard",
	Flag        = "toggleKey",
	Default     = TOGGLE_KEY,
	Callback = function(key, kind)
		if kind == "press" then
			Window:Toggle()
		end
	end,
})

Customization:AddKeybind({
	Text        = "Screenshot",
	Description = "Key that takes a screenshot",
	Icon        = "Phosphor:camera",
	Flag        = "screenshotKey",
	Default     = Enum.KeyCode.F12,
	Callback    = function(key, kind) print("Screenshot key:", key and key.Name, kind) end,
})

-- ==================== COMPONENTS ====================

Tabs.Components = Window:AddTab({ Name = "Components", Icon = "Material:grid_on" })
Tabs.Components:AddSection("All Components", "Material:widgets")

Tabs.Components:AddLabel("This is a simple label")
Tabs.Components:AddDivider()

Tabs.Components:AddParagraph({
	Title = "Paragraph Example",
	Icon  = "Lucide:file-text",
	Text  = "A paragraph with a title, an icon, and text that wraps on its own when it gets long.",
})
Tabs.Components:AddDivider()

Tabs.Components:AddButton({
	Text        = "Button Example",
	Description = "A clickable button",
	Icon        = "Lucide:mouse-pointer",
	Callback    = function() print("Button clicked") end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddCard({
	Image       = "Material:face",
	Title       = "Card Example",
	Description = "A card with an image on the left",
})
Tabs.Components:AddDivider()

Tabs.Components:AddGradientCard({
	Title       = "Gradient Card Example",
	Description = "A card with a two-color gradient background",
	ColorA      = Color3.fromRGB(88, 101, 242),
	ColorB      = Color3.fromRGB(52, 58, 138),
	Callback    = function() print("Gradient card clicked") end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddRating({
	Title       = "Standalone Rating Example",
	Placeholder = "Sends straight to the configured webhook",
	MaxStars    = 5,
	WebhookUrl  = CONFIG.FeedbackWebhook,
})
Tabs.Components:AddDivider()

Tabs.Components:AddToggle({
	Text        = "Toggle Example",
	Description = "An on/off switch",
	Icon        = "SF:switch.2",
	Default     = false,
	Callback    = function(value) print("Toggle:", value) end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddSlider({
	Text        = "Slider Example",
	Description = "A draggable slider control",
	Icon        = "SF:slider.horizontal.3",
	Min = 0, Max = 100, Default = 50, Increment = 5,
	Callback    = function(value) print("Slider:", value) end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddDropdown({
	Text        = "Dropdown Example",
	Description = "Single selection, scrolls past a handful of options",
	Icon        = "Material:arrow_drop_down",
	Options     = { "Option 1", "Option 2", "Option 3", "Option 4",
	                "Option 5", "Option 6", "Option 7", "Option 8" },
	Default     = "Option 1",
	Callback    = function(value) print("Dropdown:", value) end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddDropdown({
	Text        = "Multi-Select Dropdown",
	Description = "Select multiple options at once",
	Icon        = "Material:checklist",
	Options     = { "Red", "Blue", "Green", "Yellow" },
	MultiSelect = true,
	Default     = { "Red", "Blue" },
	Callback    = function(list) print("Selected:", table.concat(list, ", ")) end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddTextbox({
	Text        = "Textbox Example",
	Description = "Grows smoothly as you type",
	Icon        = "Lucide:edit-3",
	Placeholder = "Type something long to see it grow...",
	Default     = "Hello World",
	Callback    = function(text, enter) print("Text:", text, enter) end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddColorPicker({
	Text        = "Color Picker",
	Description = "Pick any color",
	Icon        = "Phosphor:drop",
	Default     = Color3.fromRGB(255, 255, 255),
	Callback    = function(color) print("Color:", color) end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddKeybind({
	Text        = "Keybind Example",
	Description = "Click, then press a key to bind it",
	Icon        = "Lucide:keyboard",
	Default     = Enum.KeyCode.F,
	Callback    = function(key, kind) print("Keybind:", key and key.Name, kind) end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddToggle({
	Text        = "Long Description",
	Description = "This text is deliberately long to show that the card grows "
		.. "to fit it instead of clipping it, which is what any description "
		.. "longer than one line used to do.",
	Default     = false,
	Callback    = function(value) print("Long:", value) end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddLineText("Text Divider Example")

Tabs.Components:AddLabel("A line-text divider draws a horizontal rule with a centered label, and the line shrinks to make room instead of overlapping the text.")
Tabs.Components:AddLineText("Second Line Divider")
Tabs.Components:AddDivider()

Tabs.Components:AddSection("Console Example", "Lucide:terminal")
local console = Tabs.Components:AddConsole({
	Height = 180,
})

Tabs.Components:AddButton({
	Text = "Log Random Message",
	Icon = "Lucide:plus",
	Callback = function()
		local kinds = {
			{ Enum.MessageType.MessageOutput,  "Plain log line #" },
			{ Enum.MessageType.MessageInfo,    "Info: cache warmed in " },
			{ Enum.MessageType.MessageWarning, "Warning: high ping detected " },
			{ Enum.MessageType.MessageError,   "Error: failed to load asset " },
		}
		local kind = kinds[math.random(1, #kinds)]
		console:Log(kind[2] .. math.random(1, 999), kind[1])
	end,
})
Tabs.Components:AddDivider()

Tabs.Components:AddSection("Table Example", "Lucide:table")
local playerTable = Tabs.Components:AddTable({
	Title       = "Leaderboard",
	Description = "Click a column header to sort by it",
	Height      = 160,
	Columns = {
		{ Key = "name",  Label = "Player", Weight = 2 },
		{ Key = "score", Label = "Score",  Weight = 1, Align = "Right" },
		{ Key = "kills", Label = "Kills",  Weight = 1, Align = "Right" },
	},
	Rows = {
		{ name = "Alice",   score = 1520, kills = 12 },
		{ name = "Bob",     score = 980,  kills = 7 },
		{ name = "Charlie", score = 2310, kills = 19 },
		{ name = "Dana",    score = 640,  kills = 3 },
	},
})

Tabs.Components:AddButton({
	Text        = "Add Random Row",
	Description = "Table:SetRows() replaces the data and re-renders",
	Icon        = "Lucide:plus",
	Callback = function()
		local rows = playerTable:GetRows()
		table.insert(rows, {
			name  = "Player" .. math.random(100, 999),
			score = math.random(0, 3000),
			kills = math.random(0, 25),
		})
		playerTable:SetRows(rows)
	end,
})

Tabs.Components:AddDivider()
Tabs.Components:AddSection("Info Grid Example", "Lucide:grid-2x2")
Tabs.Components:AddInfoGrid({
	Title = "Showcase Status",
	Description = "A compact grid for related label/value pairs",
	Color = Color3.fromRGB(115, 145, 255),
	Columns = 2,
	Items = {
		{ Label = "Library", Value = "Vind Ui Reborn" },
		{ Label = "Version", Value = tostring(VindUI.Version) },
		{ Label = "Players", Value = tostring(#Players:GetPlayers()) },
		{ Label = "Place", Value = tostring(game.PlaceId) },
	},
})

Tabs.Components:AddDivider()
Tabs.Components:AddSection("Responsive Card Grid", "Lucide:layout-grid")
Tabs.Components:AddCardGrid({
	Title = "Community Presets",
	Height = 330,
	Search = true,
	Sorts = { "Popular", "Recent" },
	DefaultSort = "Popular",
	Columns = 2,
	Fetch = function(request)
		local presets = {
			{ Title = "Aurora", Description = "Blue and violet glass preset", Icon = "Lucide:sparkles", Byline = "Official", Stats = {{ Icon = "heart", Text = "2.4k" }} },
			{ Title = "Midnight", Description = "Deep black minimal preset", Icon = "Lucide:moon", Byline = "Community", Stats = {{ Icon = "star", Text = "4.9" }} },
			{ Title = "Velocity", Description = "Compact performance layout", Icon = "Lucide:gauge", Byline = "Official", Stats = {{ Icon = "download", Text = "810" }} },
			{ Title = "Rose", Description = "Warm pink gradient preset", Icon = "Lucide:flower-2", Byline = "Community", Stats = {{ Icon = "heart", Text = "940" }} },
		}
		local filtered = {}
		for _, preset in ipairs(presets) do
			if request.Query == "" or preset.Title:lower():find(request.Query:lower(), 1, true) then
				table.insert(filtered, preset)
			end
		end
		return filtered
	end,
})

Window:AddTabLine()

-- ==================== LOADOUTS ====================

Tabs.Loadouts = Window:AddTab({ Name = "Loadouts", Icon = "Lucide:swords" })
Tabs.Loadouts:AddSection("Loadout Groups", "Lucide:swords")

Tabs.Loadouts:AddLoadoutGroup({
	Title      = "Attack",
	Color      = Color3.fromRGB(230, 70, 70),
	Icons      = {
		"rbxassetid://135350366891639",
		"rbxassetid://87178049860169",
		"rbxassetid://116166473864467",
	},
	ButtonText = "Equip Attack Build",
	Callback = function()
		VindUI:Notify({ Title = "Loadout", Text = "Attack build equipped", Type = "success", Duration = 3 })
	end,
})

Tabs.Loadouts:AddLoadoutGroup({
	Title      = "Dribble",
	Color      = Color3.fromRGB(80, 210, 120),
	Icons      = {
		"rbxassetid://114049630237452",
		"rbxassetid://79671190065861",
		"rbxassetid://102644686530043",
	},
	ButtonText = "Equip Dribble Build",
	Callback = function()
		VindUI:Notify({ Title = "Loadout", Text = "Dribble build equipped", Type = "success", Duration = 3 })
	end,
})

Tabs.Loadouts:AddLoadoutGroup({
	Title      = "Defender",
	Color      = Color3.fromRGB(80, 150, 230),
	Icons      = {
		"rbxassetid://138377942629789",
		"rbxassetid://77490063187431",
		"rbxassetid://86084774035342",
	},
	ButtonText = "Equip Defense Build",
	Callback = function()
		VindUI:Notify({ Title = "Loadout", Text = "Defense build equipped", Type = "success", Duration = 3 })
	end,
})

-- ==================== ADMIN (PRIVATE TAB) ====================

Tabs.Admin = Window:AddPrivateTab({
	Name     = "Admin",
	Icon     = "Lucide:shield",
	Password = "vind",
})
Tabs.Admin:AddSection("Admin Only", "Lucide:shield-alert")
Tabs.Admin:AddParagraph({
	Title = "You're in",
	Icon  = "Lucide:check-circle",
	Text  = "This tab only opened because you entered the right password. "
		.. "Everything below is just as functional as any other tab.",
})
Tabs.Admin:AddDivider()
Tabs.Admin:AddToggle({
	Text        = "Developer Mode",
	Description = "Example of a private setting protected by the tab password",
	Icon        = "Lucide:code-2",
	Default     = false,
	Callback    = function(value) print("God Mode:", value) end,
})
Tabs.Admin:AddButton({
	Text        = "Inspect Registered Elements",
	Description = "Prints every flagged element and its current value",
	Icon        = "Lucide:list-code",
	Callback    = function()
		for _, element in ipairs(VindUI:ListUIElements()) do
			print(element.Flag, element.Kind, element.Label, element.Value)
		end
		VindUI:Notify({ Title = "Developer", Text = "Registered elements printed to the console.", Type = "info", Duration = 3 })
	end,
})
Tabs.Admin:AddDivider()
Tabs.Admin:AddButton({
	Text        = "Unload Vind Ui Reborn",
	Description = "VindUI:Unload() -- tears down the whole interface",
	Icon        = "Lucide:power",
	Callback = function()
		VindUI:Confirm({
			Title = "Unload the UI?",
			Text  = "This destroys the entire panel. You'll need to re-run the script to get it back.",
			ConfirmText = "Unload",
			CancelText  = "Cancel",
			Danger = true,
			Window = Window,
			Callback = function(confirmed)
				if confirmed then VindUI:Unload() end
			end,
		})
	end,
})

-- ==================== ABOUT ====================

Tabs.About = Window:AddTab({ Name = "About", Icon = "Phosphor:info" })

Tabs.About:AddParagraph({
	Title = "Vind Ui Reborn v2.7.7",
	Icon  = "SF:info.circle",
	Text  = "A UI library for Roblox.\n\n"
		.. "Icon packs: Lucide (default), Material, Phosphor, Phosphor-Filled, SF Symbols.\n\n"
		.. "Drag the little handle in the bottom-right corner of the window to resize it.",
})
Tabs.About:AddDivider()

Tabs.About:AddSection("Support", "Lucide:message-circle")
Tabs.About:AddCard({
	Image       = "Lucide:github",
	Title       = "Project Repository",
	Description = "Set CONFIG.CommunityUrl to your GitHub or community page",
	ButtonText  = "Copy project link",
	ButtonCallback = function()
		if CONFIG.CommunityUrl == "" then
			VindUI:Notify({ Title = "Not configured", Text = "Add your public URL to CONFIG.CommunityUrl.", Type = "warning", Duration = 3 })
			return
		end
		local setclipboard = (syn and syn.write_clipboard)
			or (getgenv and getgenv().setclipboard)
			or setclipboard
		if setclipboard then
			pcall(setclipboard, CONFIG.CommunityUrl)
			VindUI:Notify({ Title = "Copied", Text = "Project link copied to your clipboard", Type = "success", Duration = 3 })
		else
			VindUI:Notify({ Title = "Unavailable", Text = "Your executor doesn't support setclipboard", Type = "warning", Duration = 3 })
		end
	end,
})
Tabs.About:AddDivider()

Tabs.About:AddSection("Notification Types", "Lucide:bell")
Tabs.About:AddButton({
	Text = "Info Notification", Icon = "Lucide:info",
	Callback = function()
		VindUI:Notify({ Title = "Heads up", Text = "This is an info notification.", Type = "info", Duration = 3 })
	end,
})
Tabs.About:AddButton({
	Text = "Success Notification", Icon = "Lucide:check-circle",
	Callback = function()
		VindUI:Notify({ Title = "All good", Text = "This is a success notification.", Type = "success", Duration = 3 })
	end,
})
Tabs.About:AddButton({
	Text = "Warning Notification", Icon = "Lucide:triangle-alert",
	Callback = function()
		VindUI:Notify({ Title = "Careful", Text = "This is a warning notification.", Type = "warning", Duration = 3 })
	end,
})
Tabs.About:AddButton({
	Text = "Error Notification", Icon = "Lucide:circle-x",
	Callback = function()
		VindUI:Notify({ Title = "Something went wrong", Text = "This is an error notification.", Type = "error", Duration = 3 })
	end,
})
Tabs.About:AddDivider()

Tabs.About:AddButton({
	Text        = "Spam 10 Notifications",
	Description = "Stacks toasts one after another",
	Icon        = "Lucide:layers",
	Callback = function()
		for i = 1, 10 do
			VindUI:Notify({ Title = "Toast #" .. i, Text = "Auto-dismisses after a few seconds", Duration = 5 })
			task.wait(0.15)
		end
	end,
})
Tabs.About:AddDivider()

Tabs.About:AddButton({
	Text        = "Confirm Dialog Example",
	Description = "VindUI:Confirm({...})",
	Icon        = "Lucide:message-square-warning",
	Callback = function()
		VindUI:Confirm({
			Title  = "Just a demo",
			Text   = "This is what a non-destructive confirmation dialog looks like.",
			ConfirmText = "Nice",
			CancelText  = "Close",
			Window = Window,
			Callback = function(confirmed) print("Confirmed:", confirmed) end,
		})
	end,
})

local conn = FpsSlider:OnChanged(function(v)
	print("[OnChanged] Max FPS ->", v)
end)

Tabs.Empty = Window:AddTab({ Name = "Empty", Icon = "Material:grid_on" })

Window:SelectTab("Home")
Window:Open()

print("Vind Ui Reborn complete showcase loaded successfully")
