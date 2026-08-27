# Vind Ui Reborn

A polished Luau interface library for Roblox with resizable windows, tabs, form controls, notifications, local configurations, data views, dock buttons, and optional service panels.

<p align="center">
  <img alt="Version" src="https://img.shields.io/badge/version-2.7.7-7c5cff?style=for-the-badge">
  <img alt="Language" src="https://img.shields.io/badge/Luau-Roblox-00A2FF?style=for-the-badge&logo=roblox">
  <img alt="Library" src="https://img.shields.io/badge/UI-Vind%20Ui%20Reborn-24c76a?style=for-the-badge">
</p>

<p align="center">
  <img alt="Vind Ui Reborn interface preview" src="https://raw.githubusercontent.com/Skinny-yz/VVind-UI/main/vind-ui-reborn-banner.png">
</p>

## Contents

- [Installation](#installation)
- [Quick start](#quick-start)
- [Window](#window)
- [Icons](#icons)
- [Tabs and subtabs](#tabs-and-subtabs)
- [Notifications and dialogs](#notifications-and-dialogs)
- [Elements](#elements)
- [Flags and configurations](#flags-and-configurations)
- [Panels](#panels)
- [Cloud service](#cloud-service)
- [AI assistant](#ai-assistant)
- [Complete example](#complete-example)
- [Compatibility](#compatibility)
- [Troubleshooting](#troubleshooting)

## Installation

Load the currently hosted build:

```lua
local VindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Skinny-yz/VVind-UI/refs/heads/main/src.lua"
))()
```

Official source:

```lua
local VindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Skinny-yz/VVind-UI/refs/heads/main/src.lua"
))()
```

For local development:

```lua
local VindUI = loadstring(readfile("src.lua"))()
```

## Quick start

```lua
local VindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Skinny-yz/VVind-UI/refs/heads/main/src.lua"
))()

local Window = VindUI:CreateWindow({
    Title = "Vind Ui Reborn",
    Subtitle = "My interface",
    Icon = "Lucide:sparkles",
    Size = UDim2.fromOffset(640, 455),
    MinSize = Vector2.new(500, 360),
    Draggable = true,
    Resizable = true,
    UseBlur = true,
    DefaultTab = "Home",
})

local Home = Window:AddTab({ Name = "Home", Icon = "Lucide:house" })
Home:AddSection("Main", "Lucide:settings")

Home:AddToggle({
    Text = "Enable feature",
    Description = "A simple toggle with a saved flag",
    Default = false,
    Flag = "feature_enabled",
    Callback = function(value)
        print("Enabled:", value)
    end,
})

VindUI:Notify({
    Title = "Vind Ui Reborn",
    Text = "Interface loaded.",
    Type = "success",
})
```

## Window

### `CreateWindow(options)`

Creates the main window and returns the object used to add tabs, panels, and dock buttons.

```lua
local Window = VindUI:CreateWindow({
    Title = "My Script",
    Subtitle = "v1.0.0",
    Icon = "Lucide:box",
    Size = UDim2.fromOffset(640, 455),
    MinSize = Vector2.new(500, 360),
    Draggable = true,
    Resizable = true,
    UseBlur = true,
    DefaultTab = "Home",
    ToggleKeybind = Enum.KeyCode.RightShift,
    TogglePosition = UDim2.fromOffset(20, 220),
})
```

| Option | Type | Description |
| --- | --- | --- |
| `Title` | `string` | Text displayed at the top of the window. |
| `Subtitle` | `string` | Smaller text displayed below the title. |
| `Icon` | `string` | Window icon. |
| `Size` | `UDim2` | Initial window size. |
| `MinSize` | `Vector2` | Smallest allowed size while resizing. |
| `Draggable` | `boolean` | Allows the window to be dragged. |
| `Resizable` | `boolean` | Enables the resize handle. |
| `UseBlur` | `boolean` | Enables background blur. |
| `DefaultTab` | `string` | Tab selected when the window opens. |
| `ToggleKeybind` | `Enum.KeyCode` | Key used to show or hide the interface. |
| `TogglePosition` | `UDim2` | Position of the mobile toggle button. |

### Window methods

```lua
Window:SetTitle("New title", "New subtitle")
Window:Open()
Window:Close()
Window:Toggle()
Window:ToggleFullscreen()
Window:SelectTab("Settings")
Window:JumpToElement("Primary Color")

print(Window:IsOpen())

Window:Destroy()
```

## Icons

Vind Ui Reborn supports Lucide, Material, Phosphor, Phosphor Filled, and SF icons. Lucide is used when no pack is specified.

```lua
Icon = "house"
Icon = "Lucide:house"
Icon = "Material:person"
Icon = "Phosphor:star"
Icon = "Phosphor-Filled:heart"
Icon = "SF:gear"
Icon = "rbxassetid://1234567890"
```

```lua
VindUI:PreloadIcons({ "Lucide", "Material", "Phosphor", "SF" })
local icon = VindUI:GetIcon("house", "Lucide")
```

## Tabs and subtabs

### Standard tab

```lua
local General = Window:AddTab({
    Name = "General",
    Icon = "Lucide:settings",
    GlowColor = Color3.fromRGB(124, 92, 255),
    Hidden = false,
})

local ShortForm = Window:AddTab("Other")
```

### Subtabs

```lua
local Player = General:AddSubTab({ Name = "Player", Icon = "Lucide:user" })
local Visuals = General:AddSubTab({ Name = "Visuals", Icon = "Lucide:eye" })

General:SelectSubTab(1)
General:SelectSubTabByName("Visuals")

Player:AddToggle({ Text = "Enabled", Default = true })
```

The subtab bar scrolls horizontally when it runs out of space. Selecting a hidden subtab automatically brings it into view.

### Private tab

```lua
local Admin = Window:AddPrivateTab({
    Name = "Admin",
    Icon = "Lucide:lock",
    Password = "my-password",
})
```

The password only protects access through the interface. It does not hide sensitive data stored in public source code.

Add a separator to the sidebar with:

```lua
Window:AddTabLine()
```

## Notifications and dialogs

### Notification

```lua
VindUI:Notify({
    Title = "Configuration saved",
    Text = "Your preferences have been updated.",
    Type = "success",
    Duration = 4,
    Icon = "Lucide:check",
    Actions = {
        {
            Text = "View",
            Callback = function() print("Opened") end,
        },
    },
})
```

Built-in types are `info`, `success`, `warning`, and `error`. You may also provide a custom `Color`.

### Confirmation

```lua
VindUI:Confirm({
    Window = Window,
    Title = "Delete configuration?",
    Text = "This action cannot be undone.",
    ConfirmText = "Delete",
    CancelText = "Cancel",
    Danger = true,
    Callback = function(confirmed)
        if confirmed then print("Confirmed") end
    end,
})
```

### Modal with fields

```lua
VindUI:Modal({
    Window = Window,
    Title = "Create profile",
    Text = "Fill in the details below.",
    ConfirmText = "Create",
    CancelText = "Cancel",
    Fields = {
        { Key = "name", Label = "Name", Placeholder = "My profile" },
        {
            Key = "description",
            Label = "Description",
            Placeholder = "Optional",
            Type = "textarea",
        },
    },
    Callback = function(confirmed, values)
        if confirmed then print(values.name, values.description) end
    end,
})
```

`Confirm` and `Modal` return an object with `Close()` for programmatic dismissal.

## Elements

Every element can be added to a regular tab or a subtab.

### Text and layout

#### Label

```lua
local Label = Tab:AddLabel("Status: waiting")
Label:Set("Status: ready")
print(Label:Get())
Label:Destroy()
```

#### Section

```lua
local Section = Tab:AddSection({ Text = "Combat", Icon = "Lucide:swords" })
Section:Set("Combat Settings")

Tab:AddSection("Player", "Lucide:user")
```

#### Divider and LineText

```lua
Tab:AddDivider()
Tab:AddLine()

local Line = Tab:AddLineText("Advanced options")
Line:Set("Experimental options")
```

`AddLine` is an alias for `AddDivider`.

#### Paragraph

```lua
local Paragraph = Tab:AddParagraph({
    Title = "About",
    Icon = "Lucide:info",
    Text = "A larger block for descriptions, warnings, and instructions.",
})

Paragraph:Set("New content")
Paragraph:SetTitle("Information")
print(Paragraph:Get())
```

### Actions and cards

#### Button

```lua
local Button = Tab:AddButton({
    Text = "Run action",
    Description = "Click to continue",
    Icon = "Lucide:play",
    Callback = function() print("Button pressed") end,
})
```

#### Card

```lua
Tab:AddCard({
    Title = "Profile",
    Description = "Click to view",
    UserId = game:GetService("Players").LocalPlayer.UserId,
    Callback = function() print("Card opened") end,
})

Tab:AddCard({
    Title = "Project",
    Description = "Current build",
    Image = "rbxassetid://1234567890",
    ButtonText = "Open",
    ButtonCallback = function() print("Opening project") end,
})
```

Cards may include an embedded rating through the `Rating` option. Thumbnail options include `UserId`, `ThumbnailType`, and `ThumbnailSize`.

#### GradientCard

```lua
Tab:AddGradientCard({
    Title = "Premium",
    Description = "A highlighted card with a gradient background",
    ColorA = Color3.fromRGB(124, 92, 255),
    ColorB = Color3.fromRGB(35, 200, 120),
    Callback = function() print("Card pressed") end,
})
```

#### LoadoutGroup

```lua
Tab:AddLoadoutGroup({
    Title = "Main Loadout",
    Color = Color3.fromRGB(124, 92, 255),
    Icons = { "Lucide:sword", "Lucide:shield", "Lucide:crosshair" },
    ButtonText = "Equip",
    Callback = function() print("Loadout equipped") end,
})
```

#### ChangelogEntry

```lua
Tab:AddChangelogEntry({
    Version = "2.7.7",
    Date = "August 27, 2026",
    Changes = {
        { Type = "Added", Text = "New panel" },
        { Type = "Changed", Text = "Updated layout" },
        { Type = "Fixed", Text = "Scaling issue" },
        { Type = "Removed", Text = "Legacy option" },
    },
})
```

### Inputs and settings

#### Toggle

```lua
local Toggle = Tab:AddToggle({
    Text = "Auto Farm",
    Description = "Enables or disables the feature",
    Icon = "Lucide:power",
    Default = false,
    Locked = false,
    Flag = "auto_farm",
    Callback = function(value) print(value) end,
})

Toggle:Set(true)
Toggle:SetLocked(true)
Toggle:OnChanged(function(value) print("Changed:", value) end)
print(Toggle:Get())
```

#### Slider

```lua
local Slider = Tab:AddSlider({
    Text = "Walk Speed",
    Description = "Character movement speed",
    Icon = "Lucide:gauge",
    Min = 0,
    Max = 100,
    Default = 16,
    Increment = 1,
    Suffix = " studs",
    Flag = "walk_speed",
    Callback = function(value) print(value) end,
})

Slider:Set(25)
Slider:SetRange(0, 200)
print(Slider:Get())
```

#### Dropdown

```lua
local Dropdown = Tab:AddDropdown({
    Text = "Mode",
    Description = "Select the current mode",
    Icon = "Lucide:list",
    Options = { "Legit", "Rage", "Custom" },
    Default = "Legit",
    MultiSelect = false,
    Flag = "mode",
    Callback = function(value) print(value) end,
})

Dropdown:Set("Custom")
Dropdown:SetOptions({ "A", "B", "C" })
Dropdown:Refresh({ "One", "Two", "Three" })
print(Dropdown:Get())
```

With `MultiSelect = true`, `Default`, `Set`, `Get`, and the callback use a table of selected values.

#### Textbox

```lua
local Textbox = Tab:AddTextbox({
    Text = "Nickname",
    Description = "Name displayed in the interface",
    Icon = "Lucide:type",
    Placeholder = "Type here...",
    Default = "Player",
    Flag = "nickname",
    Callback = function(text) print(text) end,
})

Textbox:Set("VindUser")
print(Textbox:Get())
```

#### ColorPicker

```lua
local Picker = Tab:AddColorPicker({
    Text = "Accent color",
    Icon = "Lucide:palette",
    Default = Color3.fromRGB(124, 92, 255),
    Flag = "accent_color",
    Callback = function(color) print(color) end,
})

Picker:Set(Color3.fromRGB(255, 90, 120))
print(Picker:Get())
```

#### Keybind

```lua
local Keybind = Tab:AddKeybind({
    Text = "Toggle menu",
    Icon = "Lucide:keyboard",
    Default = Enum.KeyCode.RightShift,
    Flag = "menu_key",
    Callback = function(key, event)
        if event == "bind" then print("New key:", key) end
        if event == "press" then print("Shortcut pressed") end
    end,
})

Keybind:Set(Enum.KeyCode.Insert)
print(Keybind:Get())
```

### Rating

```lua
local Rating = Tab:AddRating({
    Title = "Rate the interface",
    Default = 4,
    MaxStars = 5,
    StarColor = Color3.fromRGB(255, 200, 60),
    Placeholder = "Leave a comment...",
    ButtonIcon = "Lucide:send",
    ClearOnSubmit = true,
    WebhookUrl = "",
    Callback = function(stars, message) print(stars, message) end,
})

Rating:Set(5, "Great interface")
local stars, message = Rating:Get()
```

Webhook delivery is optional. Leave `WebhookUrl` empty when it is not in use.

### Data and monitoring

#### InfoGrid

```lua
local Grid = Tab:AddInfoGrid({
    Title = "Session",
    Description = "Current session details",
    Color = Color3.fromRGB(124, 92, 255),
    Columns = 2,
    Items = {
        { Label = "Status", Value = "Online" },
        { Label = "Server", Value = "Public" },
        { Label = "Players", Value = "8/12" },
        { Label = "Ping", Value = "42 ms" },
    },
})

Grid:SetValue("Ping", "38 ms")
```

#### Automatic grids

```lua
Tab:AddSystemInfoGrid({
    Title = "System Info",
    Description = "Current session data",
    Columns = 2,
})

Tab:AddActiveUsersGrid({
    Service = Cloud,
    Title = "Active Users",
    Description = "Users online right now",
    Interval = 30,
})

Tab:AddLeaderboard({
    Service = Cloud,
    Title = "Leaderboard",
    Description = "Most active users",
    Interval = 30,
    Limit = 10,
    RevealByDefault = false,
})
```

`ActiveUsersGrid` and `Leaderboard` require a configured cloud service.

#### Console

```lua
local Console = Tab:AddConsole({
    Title = "Logs",
    Height = 220,
    MaxLogs = 100,
    AutoCapture = false,
})

Console:Log("Interface loaded")
Console:Log("Warning", Enum.MessageType.MessageWarning)
Console:Log("Error", Enum.MessageType.MessageError)
Console:Clear()
```

#### Table

Tables support weighted columns, alignment, striped rows, hover states, and sorting by clicking a header.

```lua
local PlayersTable = Tab:AddTable({
    Title = "Match Leaderboard",
    Description = "Click any header to sort",
    Height = 160,
    RowHeight = 34,
    Sortable = true,
    Striped = true,
    Columns = {
        { Key = "rank", Label = "#", Weight = 0.45, Align = "Center" },
        { Key = "name", Label = "Player", Weight = 1.8, Emphasized = true },
        { Key = "score", Label = "Score", Weight = 1, Align = "Right" },
        { Key = "kd", Label = "K/D", Weight = 0.7, Align = "Right" },
    },
    Rows = {
        { rank = "01", name = "Charlie", score = 2310, kd = "3.8" },
        { rank = "02", name = "Alice", score = 1520, kd = "2.4" },
        { rank = "03", name = "Bob", score = 980, kd = "1.7" },
        { rank = "04", name = "Dana", score = 640, kd = "1.2" },
    },
})

PlayersTable:SetRows({
    { rank = "01", name = "NewPlayer", score = 1800, kd = "2.6" },
})

local rows = PlayersTable:GetRows()
```

Column options are `Key`, `Label`, `Weight`, `Align`, and `Emphasized`.

#### CardGrid

A responsive grid for catalogs, servers, scripts, profiles, or any other card collection. It includes search, sorting, adaptive columns, and asynchronous loading.

```lua
local CardGrid = Tab:AddCardGrid({
    Title = "Script Hub",
    Height = 300,
    Search = true,
    SearchPlaceholder = "Search scripts...",
    Sorts = { "Popular", "Newest" },
    DefaultSort = "Popular",
    PageSize = 12,
    Columns = 3,
    CardMinWidth = 150,
    CardHeight = 96,
    AutoCardHeight = false,
    DescriptionHeight = 22,
    OuterPadding = 12,
    LoadingText = "Loading...",
    EmptyText = "Nothing found",
    ErrorText = "Could not load the list",
    Fetch = function(state)
        return {
            {
                Title = "Example item",
                Description = "Card returned by Fetch",
                Icon = "Lucide:box",
                Byline = "Official",
                Stats = {{ Icon = "heart", Text = "2.4k" }},
                Callback = function() print("Selected") end,
            },
        }
    end,
})

CardGrid:SetQuery("example")
CardGrid:SetSort("Newest")
CardGrid:Refresh()
```

Advanced options include `MaxColumns`, `CardWidth`, `MinCardHeight`, `CardPadding`, `OuterPadding`, `ShowScrollbar`, `ScrollBarThickness`, `FixedHeight`, and `AutoCardHeight`.

### Returned control API

| Element | Main methods |
| --- | --- |
| `Label` | `Set`, `Get`, `Destroy` |
| `Section` | `Set`, `Destroy` |
| `Divider` | `Destroy` |
| `LineText` | `Set`, `Destroy` |
| `Paragraph` | `Set`, `Get`, `SetTitle`, `Destroy` |
| `Rating` | `Set`, `Get`, `Destroy` |
| `Toggle` | `Set`, `Get`, `SetLocked`, `OnChanged`, `Destroy` |
| `Slider` | `Set`, `Get`, `SetRange`, `OnChanged`, `Destroy` |
| `Dropdown` | `Set`, `Get`, `SetOptions`, `Refresh`, `OnChanged`, `Destroy` |
| `Textbox` | `Set`, `Get`, `OnChanged`, `Destroy` |
| `ColorPicker` | `Set`, `Get`, `OnChanged`, `Destroy` |
| `Keybind` | `Set`, `Get`, `OnChanged`, `Destroy` |
| `Console` | `Log`, `Clear`, `Destroy` |
| `Table` | `SetRows`, `GetRows`, `Destroy` |
| `InfoGrid` | `SetValue`, `Destroy` |
| `CardGrid` | `Refresh`, `SetQuery`, `SetSort`, `Destroy` |

Controls expose `Instance` when direct access to the underlying Roblox object is useful.

## Flags and configurations

A `Flag` connects a control to the configuration system. Keep flag names unique and stable between releases.

```lua
Tab:AddToggle({ Text = "Enabled", Default = false, Flag = "combat_enabled" })
Tab:AddSlider({ Text = "Range", Min = 1, Max = 50, Default = 15, Flag = "combat_range" })

local data = VindUI:GetConfig()

VindUI:SetConfig({
    combat_enabled = true,
    combat_range = 25,
}, true)

VindUI:SetUIElementValue("combat_range", 30)

for _, element in ipairs(VindUI:ListUIElements()) do
    print(element.Flag, element.Kind, element.Value)
end
```

Pass `true` as the final argument to apply values without firing callbacks.

### Local files

```lua
local success, err = VindUI:SaveConfig("default", {
    Description = "My main configuration",
    Tags = { "main", "public" },
})

VindUI:LoadConfig("default", true)
VindUI:RenameConfig("default", "legit")

local configs = VindUI:ListConfigs()
local meta = VindUI:GetConfigMeta("legit")
local saved = VindUI:GetSavedConfig("legit")

VindUI:DeleteConfig("legit")
```

Configurations are stored under `NullUI/Configs` to preserve compatibility with the current internal folder structure. File operations require filesystem functions in the runtime.

### Temporary snapshots

```lua
local snapshot = VindUI:CreateSnapshot()
VindUI:SetUIElementValue("combat_range", 50)
VindUI:RestoreSnapshot(snapshot, true)
```

## Panels

Panels use the main content area and can be connected to buttons in the bottom dock.

### Custom panel and dock button

```lua
local Panel = Window:AddPanelTab({
    Name = "Custom Panel",
    Icon = "Lucide:panel-right",
    Hidden = true,
    OnToggle = function(open) print("Panel open:", open) end,
})

local DockButton = Window:AddDockButton({
    Name = "Custom",
    Icon = "Lucide:panel-right",
    Callback = function() Panel:Toggle() end,
})

Panel:Open()
Panel:Close()
Panel:Toggle()
print(Panel:IsOpen())

DockButton:SetActive(true)
```

Use `Panel.Tab` to add standard UI elements to a custom panel.

### Spotify

The Spotify panel works as a remote control. It requires a compatible bridge for authentication, player state, and playback commands.

```lua
local Spotify = Window:AddSpotifyPanel({
    Name = "Spotify",
    Title = "Spotify Remote",
    Icon = "Lucide:music-2",
    BridgeUrl = "https://your-backend.example.com",
    ConnectUrl = "https://your-backend.example.com/connect",
    AutoConnect = true,
})

Spotify:Open()
Spotify:Connect()
Spotify:Send("pause")
Spotify:Disconnect()
```

Available methods: `Open`, `Close`, `Toggle`, `IsOpen`, `Connect`, `Disconnect`, `Send`, and `SetState`.

### Chat

```lua
local Chat = Window:AddChatPanel({
    Name = "Assistant",
    Title = "Vind Assistant",
    Icon = "Lucide:bot",
    Hidden = true,
    Placeholder = "Type a message...",
    SendTimeout = 60,
    OnSend = function(panel, text)
        panel:AddMessage("assistant", "You sent: " .. text)
    end,
    OnClear = function() print("History cleared") end,
    OnStop = function() print("Generation stopped") end,
    OnRegenerate = function(panel, text) print("Regenerate:", text) end,
})

Chat:AddMessage("assistant", "Hello! How can I help?")
Chat:ShowTyping()
Chat:HideTyping()
Chat:Clear()
```

Available methods: `Open`, `Close`, `Toggle`, `IsOpen`, `AddMessage`, `LogToolCall`, `HandleToolCall`, `ShowTyping`, `HideTyping`, `IsSending`, `Clear`, and `Destroy`.

### Cloud and global chat panels

```lua
local CloudPanel = Window:AddCloudPanel({
    Name = "Cloud",
    Icon = "Lucide:cloud",
    Hidden = true,
    Service = Cloud,
    OnApplied = function(profile) print("Applied:", profile) end,
})

local GlobalChat = Window:AddGlobalChatPanel({
    Name = "Global Chat",
    Title = "Community",
    Icon = "Lucide:messages-square",
    Hidden = true,
    Service = Cloud,
    Placeholder = "Write a message...",
    PollInterval = 5,
    HistoryLimit = 50,
    AnonymousByDefault = false,
})
```

Both panels require a backend compatible with the `CloudService` request contract.

## Cloud service

```lua
local Cloud = VindUI:CloudService({
    BaseUrl = "https://api.example.com",
    Script = "my-script",
})
```

| Method | Description |
| --- | --- |
| `List(state)` | Lists public configurations using search, sorting, and a cursor. |
| `ListMine()` | Lists configurations published by the current user. |
| `GetByShareCode(code)` | Finds a configuration by share code. |
| `Publish(meta, data)` | Publishes a configuration and its metadata. |
| `Delete(id)` | Deletes a publication owned by this device. |
| `Like(id)` | Registers or toggles a like. |
| `Download(id)` | Downloads a configuration. |
| `SendChatMessage(userId, text)` | Sends a global chat message. |
| `PollChatMessages(sinceId)` | Fetches newer chat messages. |
| `ReportChatMessage(messageId)` | Reports a chat message. |
| `Heartbeat(payload)` | Updates the current user's presence. |
| `GetActiveCount()` | Returns the active user count. |
| `GetLeaderboard(limit)` | Returns the activity leaderboard. |

```lua
local items, nextCursorOrError = Cloud:List({
    Query = "legit",
    Sort = "popular",
    Cursor = nil,
    PageSize = 20,
})

if not items then
    warn(nextCursorOrError)
else
    for _, item in ipairs(items) do print(item.Name) end
end
```

`CloudService` is a client integration, not a ready-made server. Your backend must implement the routes expected by the library.

## AI assistant

The assistant connects a `ChatPanel` to an endpoint compatible with the chat completions request format.

```lua
local Assistant = VindUI:CreateAIAssistant({
    Providers = {
        {
            Name = "OpenRouter",
            Endpoint = "https://openrouter.ai/api/v1/chat/completions",
            ApiKey = "YOUR_KEY",
            Model = "openrouter/free",
        },
    },
    Window = Window,
    Persist = "vind-assistant-history",
    SystemPrompt = "Keep answers short and useful.",
    MaxRounds = 6,
    MaxTokens = 800,
})

local Chat = Window:AddChatPanel({
    Title = "Assistant",
    Icon = "Lucide:bot",
    OnSend = function(panel, text) Assistant:Ask(panel, text) end,
    OnClear = function() Assistant:Reset() end,
    OnStop = function() Assistant:Stop() end,
})

Assistant:Ask(Chat, "Explain this configuration")
Assistant:Stop()
Assistant:Reset()

print(Assistant:IsBusy())
print(Assistant:GetHistory())
```

Pass `Tools` when creating the assistant to register custom handlers. Validate every argument before allowing a tool to perform an action.

## Additional library API

```lua
VindUI:SetScaleRange(0.75, 1.35)
VindUI:SetBlurEnabled(true)

local clean = VindUI:SanitizeText(userInput, { MaxLength = 300 })

VindUI:Unload()
```

Manual feedback delivery is also available:

```lua
local success, err = VindUI:SendFeedbackWebhook(
    "WEBHOOK_URL",
    5,
    "Great interface",
    { Title = "Vind Ui Reborn Feedback", Color = 0x7C5CFF }
)
```

Keep webhooks behind a private backend. Anyone can copy and abuse a webhook stored in public source code.

## Complete example

[`example.lua`](https://github.com/Skinny-yz/VVind-UI/blob/main/example.lua) presents the library as a complete, organized script. It includes every standard component, tables, responsive grids, configuration management, dialogs, notifications, dock buttons, service panels, and a configurable assistant.

Review its `CONFIG` block before running it:

```lua
local CONFIG = {
    SourceUrl = "https://raw.githubusercontent.com/Skinny-yz/VVind-UI/refs/heads/main/src.lua",
    FeedbackWebhook = "",
    CloudBaseUrl = "",
    SpotifyBridgeUrl = "",
    SpotifyConnectUrl = "",
    OpenRouterApiKey = "",
    CommunityUrl = "",
}
```

Integrations with empty values remain disabled. The rest of the showcase continues to work normally.

## Compatibility

The visual layer uses regular Roblox APIs. Optional features depend on the current runtime:

| Feature | Requirement |
| --- | --- |
| Remote loading | `game:HttpGet` and `loadstring` |
| Local configurations | `readfile`, `writefile`, `isfile`, `makefolder`, and `listfiles` |
| APIs and webhooks | A compatible HTTP request function |
| Remote icon packs | HTTP access |
| Spotify | A compatible external bridge |
| Cloud and global chat | A compatible custom backend |
| AI assistant | An AI endpoint and valid authentication |

## Security

- Never publish Spotify tokens, cookies, API keys, private webhooks, or backend secrets.
- Never trust text received from textboxes, chat, or cloud data. Validate and limit it before use.
- Use HTTPS for every external service.
- Implement authentication and abuse prevention on the backend, not only in the UI.
- A private tab password does not protect source code.
- Review remote URLs and scripts before loading them.

## Troubleshooting

### The interface does not open

Make sure the source URL returns plain Luau rather than HTML, a broken redirect, or a Markdown document. Confirm that `loadstring` and `game:HttpGet` are available.

### Icons do not appear

Use the correct prefix, such as `Lucide:house`, and preload the pack with `PreloadIcons`. An invalid `rbxassetid` also produces an empty icon.

### A configuration does not save

The runtime must provide filesystem access. Check the error returned by `SaveConfig` instead of assuming that the write succeeded.

### Spotify does not connect

`BridgeUrl` must point to a live, compatible bridge. Responses such as `400`, `401`, or `403` usually indicate invalid authentication, an incorrect endpoint, or a service-side restriction.

### Cloud, leaderboard, or global chat is empty

These components do not generate data on their own. Configure a `CloudService` backed by a server that implements the expected routes.

### The assistant does not respond

Check the provider `Endpoint`, `Model`, and authentication. Empty keys in the example are intentional.

### A removed legacy panel causes an error

Update to the latest [`src.lua`](https://github.com/Skinny-yz/VVind-UI/blob/main/src.lua). The current build safely ignores legacy `AddDefaultCreditsPanel()` calls and does not create a panel.

## Suggested repository structure

```text
Vind-Ui-Reborn/
├── README.md
├── src.lua
└── example.lua
```

Keep the library source separate from the showcase. This gives the loader a stable URL and lets users copy examples without editing the main file.
