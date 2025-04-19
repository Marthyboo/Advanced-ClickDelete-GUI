-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

-- Player setup
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Wait for player to be fully loaded
if not player.Parent then
    print("Waiting for player to load...")
    Players.PlayerAdded:Wait()
end
print("Player fully loaded:", player.Name)

-- Wait for character to load initially
if not player.Character then
    print("Waiting for initial character to load...")
    player.CharacterAdded:Wait()
end
print("Initial character loaded:", player.Character.Name)

-- Check for PlayerGui availability
local playerGui
local maxAttempts = 10
local attempt = 1
while attempt <= maxAttempts do
    playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        print("PlayerGui found on attempt", attempt)
        break
    else
        warn("PlayerGui not found, attempt " .. attempt .. "/" .. maxAttempts)
        task.wait(1)
        attempt = attempt + 1
    end
end
if not playerGui then
    warn("PlayerGui not found after " .. maxAttempts .. " attempts. GUI will not load.")
    return
end

-- Placeholder notify function
local function notify(title, message)
    print(string.format("[%s]: %s", title, message))
end

-- Helper Functions for UI Creation
local function createButton(parent, size, position, text, extraProps)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BorderColor3 = Color3.fromRGB(100, 0, 0)
    button.BorderSizePixel = 1
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Parent = parent
    for key, value in pairs(extraProps or {}) do
        button[key] = value
    end
    return button
end

local function createLabel(parent, size, position, text, extraProps)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.Parent = parent
    for key, value in pairs(extraProps or {}) do
        label[key] = value
    end
    return label
end

-- GUI Creation Function
local function createGui()
    print("Starting createGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "DeleteGui"
    gui.ResetOnSpawn = false
    gui.Enabled = true
    gui.IgnoreGuiInset = true
    print("GUI Created - Enabled:", gui.Enabled)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 450)
    frame.Position = UDim2.new(0.5, -150, 0.5, -225)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderColor3 = Color3.fromRGB(150, 0, 0)
    frame.BorderSizePixel = 2
    frame.Active = true
    frame.Draggable = true
    frame.Visible = true
    frame.Parent = gui
    print("Frame Created - Visible:", frame.Visible)

    local framePadding = Instance.new("UIPadding")
    framePadding.PaddingTop = UDim.new(0, 5)
    framePadding.PaddingBottom = UDim.new(0, 5)
    framePadding.PaddingLeft = UDim.new(0, 5)
    framePadding.PaddingRight = UDim.new(0, 5)
    framePadding.Parent = frame

    local title = createLabel(frame, UDim2.new(1, -10, 0, 30), UDim2.new(0, 5, 0, 5), "Delete Tool", {
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(200, 0, 0),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18
    })

    -- Tab Buttons
    local mainTabButton = createButton(frame, UDim2.new(0, 90, 0, 25), UDim2.new(0, 5, 0, 40), "Main", {
        BackgroundColor3 = Color3.fromRGB(200, 0, 0),
        Font = Enum.Font.SourceSansBold
    })

    local audioTabButton = createButton(frame, UDim2.new(0, 90, 0, 25), UDim2.new(0, 95, 0, 40), "Audio", {
        Font = Enum.Font.SourceSansBold
    })

    local settingsTabButton = createButton(frame, UDim2.new(0, 90, 0, 25), UDim2.new(0, 185, 0, 40), "Settings", {
        Font = Enum.Font.SourceSansBold
    })

    -- Tab Frames
    local mainTabFrame = Instance.new("Frame")
    mainTabFrame.Size = UDim2.new(1, -10, 0, 330)
    mainTabFrame.Position = UDim2.new(0, 5, 0, 70)
    mainTabFrame.BackgroundTransparency = 1
    mainTabFrame.Visible = true
    mainTabFrame.Parent = frame

    local audioTabFrame = Instance.new("Frame")
    audioTabFrame.Size = UDim2.new(1, -10, 0, 330)
    audioTabFrame.Position = UDim2.new(0, 5, 0, 70)
    audioTabFrame.BackgroundTransparency = 1
    audioTabFrame.Visible = false
    audioTabFrame.Parent = frame

    local settingsTabFrame = Instance.new("Frame")
    settingsTabFrame.Size = UDim2.new(1, -10, 0, 450)
    settingsTabFrame.Position = UDim2.new(0, 5, 0, 70)
    settingsTabFrame.BackgroundTransparency = 1
    settingsTabFrame.Visible = false
    settingsTabFrame.Parent = frame

    -- Settings Tab Layout
    print("Creating settingsTabFrame UIListLayout")
    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.Padding = UDim.new(0, 2)
    settingsLayout.Parent = settingsTabFrame

    -- Main Tab Contents
    local toggleButton = createButton(mainTabFrame, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 0), "Delete Mode: Off")
    local protectButton = createButton(mainTabFrame, UDim2.new(0, 130, 0, 30), UDim2.new(0, 140, 0, 0), "Protect Character: Off")
    local infiniteYieldButton = createButton(mainTabFrame, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 35), "Run Infinite Yield")
    local outlineButton = createButton(mainTabFrame, UDim2.new(0, 130, 0, 30), UDim2.new(0, 140, 0, 35), "Outline: On")
    local rightClickRestoreButton = createButton(mainTabFrame, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 70), "Right-Click Restore: On")
    local spawnShapeButton = createButton(mainTabFrame, UDim2.new(0, 130, 0, 30), UDim2.new(0, 140, 0, 70), "Spawn Shape: Off")
    local restoreAllButton = createButton(mainTabFrame, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 105), "Restore All")

    local logFrame = Instance.new("ScrollingFrame")
    logFrame.Size = UDim2.new(1, 0, 0, 190)
    logFrame.Position = UDim2.new(0, 0, 0, 140)
    logFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    logFrame.BorderColor3 = Color3.fromRGB(100, 0, 0)
    logFrame.BorderSizePixel = 1
    logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    logFrame.ScrollBarThickness = 6
    logFrame.Parent = mainTabFrame

    local logLayout = Instance.new("UIListLayout")
    logLayout.SortOrder = Enum.SortOrder.LayoutOrder
    logLayout.Padding = UDim.new(0, 3)
    logLayout.Parent = logFrame

    -- Audio Tab Contents
    local audioToggleButton = createButton(audioTabFrame, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 0), "Audio: On")
    local deleteAudioIdLabel = createLabel(audioTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 35), "Delete Audio ID:", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    local deleteAudioIdFrame = Instance.new("Frame")
    deleteAudioIdFrame.Size = UDim2.new(1, 0, 0, 25)
    deleteAudioIdFrame.Position = UDim2.new(0, 0, 0, 55)
    deleteAudioIdFrame.BackgroundTransparency = 1
    deleteAudioIdFrame.Parent = audioTabFrame

    local deleteAudioIdTextBox = Instance.new("TextBox")
    deleteAudioIdTextBox.Size = UDim2.new(0, 210, 0, 25)
    deleteAudioIdTextBox.Position = UDim2.new(0, 0, 0, 0)
    deleteAudioIdTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    deleteAudioIdTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
    deleteAudioIdTextBox.BorderSizePixel = 1
    deleteAudioIdTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    deleteAudioIdTextBox.PlaceholderText = "e.g., 4676738150"
    deleteAudioIdTextBox.Text = "4676738150"
    deleteAudioIdTextBox.Font = Enum.Font.SourceSans
    deleteAudioIdTextBox.TextSize = 14
    deleteAudioIdTextBox.Parent = deleteAudioIdFrame

    local setDeleteAudioIdButton = createButton(deleteAudioIdFrame, UDim2.new(0, 50, 0, 25), UDim2.new(0, 215, 0, 0), "Set", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    local restoreAudioIdLabel = createLabel(audioTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 85), "Restore Audio ID:", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    local restoreAudioIdFrame = Instance.new("Frame")
    restoreAudioIdFrame.Size = UDim2.new(1, 0, 0, 25)
    restoreAudioIdFrame.Position = UDim2.new(0, 0, 0, 105)
    restoreAudioIdFrame.BackgroundTransparency = 1
    restoreAudioIdFrame.Parent = audioTabFrame

    local restoreAudioIdTextBox = Instance.new("TextBox")
    restoreAudioIdTextBox.Size = UDim2.new(0, 210, 0, 25)
    restoreAudioIdTextBox.Position = UDim2.new(0, 0, 0, 0)
    restoreAudioIdTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    restoreAudioIdTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
    restoreAudioIdTextBox.BorderSizePixel = 1
    restoreAudioIdTextBox.TextColor3 = Color3.fromRGB(255, 250, 255)
    restoreAudioIdTextBox.PlaceholderText = "e.g., 773858658"
    restoreAudioIdTextBox.Text = "773858658"
    restoreAudioIdTextBox.Font = Enum.Font.SourceSans
    restoreAudioIdTextBox.TextSize = 14
    restoreAudioIdTextBox.Parent = restoreAudioIdFrame

    local setRestoreAudioIdButton = createButton(restoreAudioIdFrame, UDim2.new(0, 50, 0, 25), UDim2.new(0, 215, 0, 0), "Set", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    local deleteVolumeLabel = createLabel(audioTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 135), "Delete Volume: 1.0", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    local deleteVolumeSlider = createButton(audioTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 155), "", {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    })

    local deleteVolumeFill = Instance.new("Frame")
    deleteVolumeFill.Size = UDim2.new(1, 0, 1, 0)
    deleteVolumeFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    deleteVolumeFill.BorderSizePixel = 0
    deleteVolumeFill.Parent = deleteVolumeSlider

    local restoreVolumeLabel = createLabel(audioTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 180), "Restore Volume: 1.0", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    local restoreVolumeSlider = createButton(audioTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 200), "", {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    })

    local restoreVolumeFill = Instance.new("Frame")
    restoreVolumeFill.Size = UDim2.new(1, 0, 1, 0)
    restoreVolumeFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    restoreVolumeFill.BorderSizePixel = 0
    restoreVolumeFill.Parent = restoreVolumeSlider

    -- Settings Tab Contents
    print("Creating toggleKeybindFrame")
    local toggleKeybindFrame = Instance.new("Frame")
    toggleKeybindFrame.Size = UDim2.new(1, 0, 0, 22)
    toggleKeybindFrame.BackgroundTransparency = 1
    toggleKeybindFrame.LayoutOrder = 1
    toggleKeybindFrame.Parent = settingsTabFrame

    print("Creating toggleKeybindLabel")
    local toggleKeybindLabel = createLabel(toggleKeybindFrame, UDim2.new(0, 110, 0, 22), UDim2.new(0, 0, 0, 0), "Toggle Keybind:", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    print("Creating toggleKeybindTextBox")
    local toggleKeybindTextBox = Instance.new("TextBox")
    toggleKeybindTextBox.Size = UDim2.new(0, 50, 0, 22)
    toggleKeybindTextBox.Position = UDim2.new(0, 115, 0, 0)
    toggleKeybindTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
    toggleKeybindTextBox.BorderSizePixel = 1
    toggleKeybindTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleKeybindTextBox.PlaceholderText = "e.g., H, G"
    toggleKeybindTextBox.Text = "H"
    toggleKeybindTextBox.Font = Enum.Font.SourceSans
    toggleKeybindTextBox.TextSize = 14
    toggleKeybindTextBox.Parent = toggleKeybindFrame

    print("Creating setToggleKeybindButton")
    local setToggleKeybindButton = createButton(toggleKeybindFrame, UDim2.new(0, 50, 0, 22), UDim2.new(0, 170, 0, 0), "Set", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    print("Creating removeToggleKeybindButton")
    local removeToggleKeybindButton = createButton(toggleKeybindFrame, UDim2.new(0, 50, 0, 22), UDim2.new(0, 225, 0, 0), "Remove", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    print("Creating actionKeybindFrame")
    local actionKeybindFrame = Instance.new("Frame")
    actionKeybindFrame.Size = UDim2.new(1, 0, 0, 22)
    actionKeybindFrame.BackgroundTransparency = 1
    actionKeybindFrame.LayoutOrder = 2
    actionKeybindFrame.Parent = settingsTabFrame

    print("Creating actionKeybindLabel")
    local actionKeybindLabel = createLabel(actionKeybindFrame, UDim2.new(0, 110, 0, 22), UDim2.new(0, 0, 0, 0), "Action Keybind:", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    print("Creating actionKeybindTextBox")
    local actionKeybindTextBox = Instance.new("TextBox")
    actionKeybindTextBox.Size = UDim2.new(0, 50, 0, 22)
    actionKeybindTextBox.Position = UDim2.new(0, 115, 0, 0)
    actionKeybindTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    actionKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
    actionKeybindTextBox.BorderSizePixel = 1
    actionKeybindTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionKeybindTextBox.PlaceholderText = "e.g., T, R"
    actionKeybindTextBox.Text = "T"
    actionKeybindTextBox.Font = Enum.Font.SourceSans
    actionKeybindTextBox.TextSize = 14
    actionKeybindTextBox.Parent = actionKeybindFrame

    print("Creating setActionKeybindButton")
    local setActionKeybindButton = createButton(actionKeybindFrame, UDim2.new(0, 50, 0, 22), UDim2.new(0, 170, 0, 0), "Set", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    print("Creating removeActionKeybindButton")
    local removeActionKeybindButton = createButton(actionKeybindFrame, UDim2.new(0, 50, 0, 22), UDim2.new(0, 225, 0, 0), "Remove", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    print("Creating shapeKeybindFrame")
    local shapeKeybindFrame = Instance.new("Frame")
    shapeKeybindFrame.Size = UDim2.new(1, 0, 0, 22)
    shapeKeybindFrame.BackgroundTransparency = 1
    shapeKeybindFrame.LayoutOrder = 3
    shapeKeybindFrame.Parent = settingsTabFrame

    print("Creating shapeKeybindLabel")
    local shapeKeybindLabel = createLabel(shapeKeybindFrame, UDim2.new(0, 110, 0, 22), UDim2.new(0, 0, 0, 0), "Shape Keybind:", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    print("Creating shapeKeybindTextBox")
    local shapeKeybindTextBox = Instance.new("TextBox")
    shapeKeybindTextBox.Size = UDim2.new(0, 50, 0, 22)
    shapeKeybindTextBox.Position = UDim2.new(0, 115, 0, 0)
    shapeKeybindTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    shapeKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
    shapeKeybindTextBox.BorderSizePixel = 1
    shapeKeybindTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    shapeKeybindTextBox.PlaceholderText = "e.g., C, V"
    shapeKeybindTextBox.Text = "C"
    shapeKeybindTextBox.Font = Enum.Font.SourceSans
    shapeKeybindTextBox.TextSize = 14
    shapeKeybindTextBox.Parent = shapeKeybindFrame

    print("Creating setShapeKeybindButton")
    local setShapeKeybindButton = createButton(shapeKeybindFrame, UDim2.new(0, 50, 0, 22), UDim2.new(0, 170, 0, 0), "Set", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    print("Creating removeShapeKeybindButton")
    local removeShapeKeybindButton = createButton(shapeKeybindFrame, UDim2.new(0, 50, 0, 22), UDim2.new(0, 225, 0, 0), "Remove", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    print("Creating scrollWheelKeybindFrame")
    local scrollWheelKeybindFrame = Instance.new("Frame")
    scrollWheelKeybindFrame.Size = UDim2.new(1, 0, 0, 22)
    scrollWheelKeybindFrame.BackgroundTransparency = 1
    scrollWheelKeybindFrame.LayoutOrder = 4
    scrollWheelKeybindFrame.Parent = settingsTabFrame

    print("Creating scrollWheelKeybindLabel")
    local scrollWheelKeybindLabel = createLabel(scrollWheelKeybindFrame, UDim2.new(0, 110, 0, 22), UDim2.new(0, 0, 0, 0), "Scroll Wheel Keybind:", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    print("Creating scrollWheelKeybindTextBox")
    local scrollWheelKeybindTextBox = Instance.new("TextBox")
    scrollWheelKeybindTextBox.Size = UDim2.new(0, 50, 0, 22)
    scrollWheelKeybindTextBox.Position = UDim2.new(0, 115, 0, 0)
    scrollWheelKeybindTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    scrollWheelKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
    scrollWheelKeybindTextBox.BorderSizePixel = 1
    scrollWheelKeybindTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    scrollWheelKeybindTextBox.PlaceholderText = "e.g., Z, X"
    scrollWheelKeybindTextBox.Text = ""
    scrollWheelKeybindTextBox.Font = Enum.Font.SourceSans
    scrollWheelKeybindTextBox.TextSize = 14
    scrollWheelKeybindTextBox.Parent = scrollWheelKeybindFrame

    print("Creating setScrollWheelKeybindButton")
    local setScrollWheelKeybindButton = createButton(scrollWheelKeybindFrame, UDim2.new(0, 50, 0, 22), UDim2.new(0, 170, 0, 0), "Set", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    print("Creating removeScrollWheelKeybindButton")
    local removeScrollWheelKeybindButton = createButton(scrollWheelKeybindFrame, UDim2.new(0, 50, 0, 22), UDim2.new(0, 225, 0, 0), "Remove", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    print("Creating shapeSizeLabel")
    local shapeSizeLabel = createLabel(settingsTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(), "Shape Size: 25", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold,
        LayoutOrder = 5
    })

    print("Creating shapeSizeSlider")
    local shapeSizeSlider = createButton(settingsTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(), "", {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        LayoutOrder = 6
    })

    local shapeSizeFill = Instance.new("Frame")
    shapeSizeFill.Size = UDim2.new(0.5, 0, 1, 0)
    shapeSizeFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    shapeSizeFill.BorderSizePixel = 0
    shapeSizeFill.Parent = shapeSizeSlider

    print("Creating shapeThicknessLabel")
    local shapeThicknessLabel = createLabel(settingsTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(), "Shape Thickness: 1.0", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold,
        LayoutOrder = 7
    })

    print("Creating shapeThicknessSlider")
    local shapeThicknessSlider = createButton(settingsTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(), "", {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        LayoutOrder = 8
    })

    local shapeThicknessFill = Instance.new("Frame")
    shapeThicknessFill.Size = UDim2.new(0.032, 0, 1, 0)
    shapeThicknessFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    shapeThicknessFill.BorderSizePixel = 0
    shapeThicknessFill.Parent = shapeThicknessSlider

    print("Creating shapeTransparencyLabel")
    local shapeTransparencyLabel = createLabel(settingsTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(), "Shape Transparency: 0.7", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold,
        LayoutOrder = 9
    })

    print("Creating shapeTransparencySlider")
    local shapeTransparencySlider = createButton(settingsTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(), "", {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        LayoutOrder = 10
    })

    local shapeTransparencyFill = Instance.new("Frame")
    shapeTransparencyFill.Size = UDim2.new(0.7, 0, 1, 0)
    shapeTransparencyFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    shapeTransparencyFill.BorderSizePixel = 0
    shapeTransparencyFill.Parent = shapeTransparencySlider

    print("Creating wallExtensionLabel")
    local wallExtensionLabel = createLabel(settingsTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(), "Wall Extension: 5.0", {
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold,
        LayoutOrder = 11
    })

    print("Creating wallExtensionSlider")
    local wallExtensionSlider = createButton(settingsTabFrame, UDim2.new(1, 0, 0, 20), UDim2.new(), "", {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        LayoutOrder = 12
    })

    local wallExtensionFill = Instance.new("Frame")
    wallExtensionFill.Size = UDim2.new(0.5, 0, 1, 0)
    wallExtensionFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    wallExtensionFill.BorderSizePixel = 0
    wallExtensionFill.Parent = wallExtensionSlider

    print("Creating shapeToggleFrame")
    local shapeToggleFrame = Instance.new("Frame")
    shapeToggleFrame.Size = UDim2.new(1, 0, 0, 25)
    shapeToggleFrame.BackgroundTransparency = 1
    shapeToggleFrame.LayoutOrder = 13
    shapeToggleFrame.Parent = settingsTabFrame

    print("Creating shapeFloorButton")
    local shapeFloorButton = createButton(shapeToggleFrame, UDim2.new(0, 130, 0, 25), UDim2.new(0, 0, 0, 0), "Shape Floor: Off")

    print("Creating scrollWheelSizeFrame")
    local scrollWheelSizeFrame = Instance.new("Frame")
    scrollWheelSizeFrame.Size = UDim2.new(1, 0, 0, 25)
    scrollWheelSizeFrame.BackgroundTransparency = 1
    scrollWheelSizeFrame.LayoutOrder = 14
    scrollWheelSizeFrame.Parent = settingsTabFrame

    print("Creating scrollWheelSizeButton")
    local scrollWheelSizeButton = createButton(scrollWheelSizeFrame, UDim2.new(0, 130, 0, 25), UDim2.new(0, 0, 0, 0), "Scroll Wheel Size: Off")

    print("Creating destroyMenuFrame")
    local destroyMenuFrame = Instance.new("Frame")
    destroyMenuFrame.Size = UDim2.new(1, 0, 0, 25)
    destroyMenuFrame.BackgroundTransparency = 1
    destroyMenuFrame.LayoutOrder = 15
    destroyMenuFrame.Parent = settingsTabFrame

    print("Creating destroyMenuButton")
    local destroyMenuButton = createButton(destroyMenuFrame, UDim2.new(0, 130, 0, 25), UDim2.new(0, 0, 0, 0), "Destroy Menu")

    print("Creating restoreDestroyRevertFrame")
    local restoreDestroyRevertFrame = Instance.new("Frame")
    restoreDestroyRevertFrame.Size = UDim2.new(1, 0, 0, 25)
    restoreDestroyRevertFrame.BackgroundTransparency = 1
    restoreDestroyRevertFrame.LayoutOrder = 16
    restoreDestroyRevertFrame.Parent = settingsTabFrame

    print("Creating restoreKeybindsButton")
    local restoreKeybindsButton = createButton(restoreDestroyRevertFrame, UDim2.new(0, 130, 0, 25), UDim2.new(0, 0, 0, 0), "Restore All Keybinds")

    print("Creating destroyAndRevertButton")
    local destroyAndRevertButton = createButton(restoreDestroyRevertFrame, UDim2.new(0, 130, 0, 25), UDim2.new(0, 135, 0, 0), "Destroy & Revert")

    print("Creating removeKeybindsButton")
    local removeKeybindsButton = createButton(settingsTabFrame, UDim2.new(0, 130, 0, 25), UDim2.new(), "Remove Every Keybind", {
        LayoutOrder = 17
    })

    print("GUI parenting to PlayerGui")
    gui.Parent = playerGui
    print("DeleteGui successfully parented to PlayerGui")

    return {
        gui = gui,
        frame = frame,
        mainTabButton = mainTabButton,
        audioTabButton = audioTabButton,
        settingsTabButton = settingsTabButton,
        mainTabFrame = mainTabFrame,
        audioTabFrame = audioTabFrame,
        settingsTabFrame = settingsTabFrame,
        toggleButton = toggleButton,
        protectButton = protectButton,
        infiniteYieldButton = infiniteYieldButton,
        outlineButton = outlineButton,
        rightClickRestoreButton = rightClickRestoreButton,
        spawnShapeButton = spawnShapeButton,
        restoreAllButton = restoreAllButton,
        logFrame = logFrame,
        audioToggleButton = audioToggleButton,
        deleteAudioIdTextBox = deleteAudioIdTextBox,
        setDeleteAudioIdButton = setDeleteAudioIdButton,
        restoreAudioIdTextBox = restoreAudioIdTextBox,
        setRestoreAudioIdButton = setRestoreAudioIdButton,
        deleteVolumeLabel = deleteVolumeLabel,
        deleteVolumeSlider = deleteVolumeSlider,
        deleteVolumeFill = deleteVolumeFill,
        restoreVolumeLabel = restoreVolumeLabel,
        restoreVolumeSlider = restoreVolumeSlider,
        restoreVolumeFill = restoreVolumeFill,
        toggleKeybindTextBox = toggleKeybindTextBox,
        setToggleKeybindButton = setToggleKeybindButton,
        removeToggleKeybindButton = removeToggleKeybindButton,
        actionKeybindTextBox = actionKeybindTextBox,
        setActionKeybindButton = setActionKeybindButton,
        removeActionKeybindButton = removeActionKeybindButton,
        shapeKeybindTextBox = shapeKeybindTextBox,
        setShapeKeybindButton = setShapeKeybindButton,
        removeShapeKeybindButton = removeShapeKeybindButton,
        scrollWheelKeybindTextBox = scrollWheelKeybindTextBox,
        setScrollWheelKeybindButton = setScrollWheelKeybindButton,
        removeScrollWheelKeybindButton = removeScrollWheelKeybindButton,
        shapeSizeLabel = shapeSizeLabel,
        shapeSizeSlider = shapeSizeSlider,
        shapeSizeFill = shapeSizeFill,
        shapeThicknessLabel = shapeThicknessLabel,
        shapeThicknessSlider = shapeThicknessSlider,
        shapeThicknessFill = shapeThicknessFill,
        shapeFloorButton = shapeFloorButton,
        shapeTransparencyLabel = shapeTransparencyLabel,
        shapeTransparencySlider = shapeTransparencySlider,
        shapeTransparencyFill = shapeTransparencyFill,
        wallExtensionLabel = wallExtensionLabel,
        wallExtensionSlider = wallExtensionSlider,
        wallExtensionFill = wallExtensionFill,
        scrollWheelSizeButton = scrollWheelSizeButton,
        restoreKeybindsButton = restoreKeybindsButton,
        removeKeybindsButton = removeKeybindsButton,
        destroyMenuButton = destroyMenuButton,
        destroyAndRevertButton = destroyAndRevertButton
    }
end

-- StateManager
local StateManager = {
    isDeleteModeEnabled = false,
    isCharacterProtected = false,
    isOutlineEnabled = true,
    isRightClickRestoreEnabled = true,
    isAudioEnabled = true,
    toggleKeybind = Enum.KeyCode.H,
    actionKeybind = Enum.KeyCode.T,
    guiToggleKeybind = Enum.KeyCode.F1,
    isActionKeyHeld = false,
    isShapeSpawned = false,
    shapeKeybind = Enum.KeyCode.C,
    scrollWheelKeybind = nil, -- Empty by default
    shapeConnection = nil,
    shapeSize = 25,
    shapeThickness = 1,
    shapeTransparency = 0.7,
    isShapeFloorEnabled = false,
    wallExtensionDelta = 5,
    isScrollWheelSizeEnabled = false,
    defaultMinZoomDistance = 0.5,
    defaultMaxZoomDistance = 400,
    lockedZoomDistance = nil,
    connections = {}
}

function StateManager.toggleState(button, stateKey, label, callback)
    StateManager[stateKey] = not StateManager[stateKey]
    button.Text = label .. (StateManager[stateKey] and "On" or "Off")
    if callback then callback() end
end

function StateManager.toggleGui(frame)
    frame.Visible = not frame.Visible
end

function StateManager.setupSlider(slider, fill, label, stateKey, minVal, maxVal, formatStr)
    local dragging = false
    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.MouseMoved:Connect(function(x)
        if dragging then
            local relativeX = x - slider.AbsolutePosition.X
            local fraction = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(fraction, 0, 1, 0)
            StateManager[stateKey] = minVal + fraction * (maxVal - minVal)
            label.Text = string.format(formatStr, StateManager[stateKey])
        end
    end)
end

local function createShapePart(size, position, parent, props)
    local part = Instance.new("Part")
    part.Size = size
    part.Position = position
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = props.transparency
    part.BrickColor = props.brickColor
    part.Shape = Enum.PartType.Block
    part.Parent = parent
    return part
end

function StateManager.toggleShape(spawnShapeButton)
    StateManager.toggleState(spawnShapeButton, "isShapeSpawned", "Spawn Shape: ", function()
        local shapeName = "PlayerShape_" .. player.Name
        local existingShape = game.Workspace:FindFirstChild(shapeName)
        if StateManager.isShapeSpawned then
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                print("Character or HumanoidRootPart not found, cannot spawn shape")
                StateManager.isShapeSpawned = false
                spawnShapeButton.Text = "Spawn Shape: Off"
                return
            end
            if existingShape then existingShape:Destroy() end

            local shapeModel = Instance.new("Model")
            shapeModel.Name = shapeName
            local shapeSize = StateManager.shapeSize
            local wallThickness = StateManager.shapeThickness
            local wallExtension = StateManager.wallExtensionDelta
            local shapeConfig = {
                props = { transparency = StateManager.shapeTransparency, brickColor = BrickColor.new("Really red") },
                parts = {
                    { name = "leftWall", size = Vector3.new(wallThickness, shapeSize + wallExtension, shapeSize), offset = Vector3.new(-shapeSize / 2 + wallThickness / 2, -wallExtension / 2, 0) },
                    { name = "rightWall", size = Vector3.new(wallThickness, shapeSize + wallExtension, shapeSize), offset = Vector3.new(shapeSize / 2 - wallThickness / 2, -wallExtension / 2, 0) },
                    { name = "frontWall", size = Vector3.new(shapeSize, shapeSize + wallExtension, wallThickness), offset = Vector3.new(0, -wallExtension / 2, -shapeSize / 2 + wallThickness / 2) },
                    { name = "backWall", size = Vector3.new(shapeSize, shapeSize + wallExtension, wallThickness), offset = Vector3.new(0, -wallExtension / 2, shapeSize / 2 - wallThickness / 2) },
                    { name = "ceiling", size = Vector3.new(shapeSize, wallThickness, shapeSize), offset = Vector3.new(0, shapeSize / 2 - wallThickness / 2, 0) }
                }
            }
            if StateManager.isShapeFloorEnabled then
                table.insert(shapeConfig.parts, {
                    name = "floor",
                    size = Vector3.new(shapeSize, wallThickness, shapeSize),
                    offset = Vector3.new(0, -shapeSize / 2 - wallExtension + wallThickness / 2, 0)
                })
            end

            local playerPos = player.Character.HumanoidRootPart.Position
            local centerPos = playerPos + Vector3.new(0, wallThickness / 2 + wallExtension - 2.5, 0)
            local parts = {}
            for _, partConfig in ipairs(shapeConfig.parts) do
                parts[partConfig.name] = createShapePart(partConfig.size, centerPos + partConfig.offset, shapeModel, shapeConfig.props)
            end

            shapeModel.Parent = game.Workspace
            print("Cube spawned at:", centerPos)

            if StateManager.shapeConnection then
                StateManager.shapeConnection:Disconnect()
            end
            StateManager.shapeConnection = RunService.Heartbeat:Connect(function()
                task.desynchronize()
                if not StateManager.isShapeSpawned or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    task.synchronize()
                    if shapeModel then shapeModel:Destroy() end
                    if StateManager.shapeConnection then
                        StateManager.shapeConnection:Disconnect()
                        StateManager.shapeConnection = nil
                    end
                    StateManager.isShapeSpawned = false
                    spawnShapeButton.Text = "Spawn Shape: Off"
                    return
                end

                local newShapeSize = StateManager.shapeSize
                local newWallThickness = StateManager.shapeThickness
                local newTransparency = StateManager.shapeTransparency
                local newWallExtension = StateManager.wallExtensionDelta
                local newPos = player.Character.HumanoidRootPart.Position
                local newCenterPos = newPos + Vector3.new(0, newWallThickness / 2 + newWallExtension - 2.5, 0)

                task.synchronize()
                for _, partConfig in ipairs(shapeConfig.parts) do
                    local part = parts[partConfig.name]
                    if part then
                        local size = partConfig.size
                        local offset = partConfig.offset
                        local cubeSize = Vector3.new(newShapeSize, newShapeSize, newShapeSize)
                        if partConfig.name == "leftWall" or partConfig.name == "rightWall" then
                            size = Vector3.new(newWallThickness, cubeSize.Y + newWallExtension, cubeSize.Z)
                            offset = partConfig.name == "leftWall" and Vector3.new(-cubeSize.X / 2 + newWallThickness / 2, -newWallExtension / 2, 0) or
                                     Vector3.new(cubeSize.X / 2 - newWallThickness / 2, -newWallExtension / 2, 0)
                        elseif partConfig.name == "frontWall" or partConfig.name == "backWall" then
                            size = Vector3.new(cubeSize.X, cubeSize.Y + newWallExtension, newWallThickness)
                            offset = partConfig.name == "frontWall" and Vector3.new(0, -newWallExtension / 2, -cubeSize.Z / 2 + newWallThickness / 2) or
                                     Vector3.new(0, -newWallExtension / 2, cubeSize.Z / 2 - newWallThickness / 2)
                        elseif partConfig.name == "ceiling" then
                            size = Vector3.new(cubeSize.X, newWallThickness, cubeSize.Z)
                            offset = Vector3.new(0, cubeSize.Y / 2 - newWallThickness / 2, 0)
                        elseif partConfig.name == "floor" then
                            size = Vector3.new(cubeSize.X, newWallThickness, cubeSize.Z)
                            offset = Vector3.new(0, -cubeSize.Y / 2 - newWallExtension + newWallThickness / 2, 0)
                        end
                        part.Size = size
                        part.Position = newCenterPos + offset
                        part.Transparency = newTransparency
                    end
                end
            end)

            notify('Shape', 'Cube with Separate Walls, Ceiling, ' .. (StateManager.isShapeFloorEnabled and 'and Floor ' or 'No Floor ') .. 'Spawned, following player')
        else
            if existingShape then
                existingShape:Destroy()
                print("Shape despawned")
            end
            if StateManager.shapeConnection then
                StateManager.shapeConnection:Disconnect()
                StateManager.shapeConnection = nil
            end
            notify('Shape', 'Shape Despawned')
        end
    end)
end

-- AudioManager
local AudioManager = {
    deleteSound = Instance.new("Sound", game.Workspace),
    restoreSound = Instance.new("Sound", game.Workspace)
}
AudioManager.deleteSound.SoundId = "rbxassetid://4676738150"
AudioManager.deleteSound.Volume = 1
AudioManager.restoreSound.SoundId = "rbxassetid://773858658"
AudioManager.restoreSound.Volume = 1

function AudioManager.setAudioId(textBox, sound)
    local audioId = textBox.Text:match("%d+")
    if audioId then
        local success, err = pcall(function()
            sound.SoundId = "rbxassetid://" .. audioId
        end)
        if not success then
            warn("Failed to set audio ID: " .. tostring(err))
            textBox.Text = sound.SoundId:match("%d+") or ""
        end
    else
        textBox.Text = sound.SoundId:match("%d+") or ""
    end
end

function AudioManager.setupVolumeSlider(slider, fill, label, sound)
    local dragging = false
    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.MouseMoved:Connect(function(x)
        if dragging then
            local relativeX = x - slider.AbsolutePosition.X
            local fraction = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(fraction, 0, 1, 0)
            sound.Volume = fraction
            label.Text = string.format("%s Volume: %.1f", label.Text:match("^(.-) Volume"), fraction)
        end
    end)
end

-- DeleteRestoreManager
local DeleteRestoreManager = {
    deletedObjects = {},
    deletedStorage = Instance.new("Folder", game.ReplicatedStorage),
    characterCache = {}
}
DeleteRestoreManager.deletedStorage.Name = "DeletedObjects"

function DeleteRestoreManager.isBodyPartOrCharacter(target, isCharacterProtected)
    if not isCharacterProtected then return false end
    if DeleteRestoreManager.characterCache[target] then return true end

    local bodyParts = { "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart" }
    for _, part in ipairs(bodyParts) do
        if target.Name == part then
            DeleteRestoreManager.characterCache[target] = true
            return true
        end
    end

    local character = target:FindFirstAncestorOfClass("Model")
    if character and character:FindFirstChildOfClass("Humanoid") then
        DeleteRestoreManager.characterCache[target] = true
        return true
    end
    return false
end

function DeleteRestoreManager.updateLogbox(logFrame, isAudioEnabled, restoreSound)
    for _, child in ipairs(logFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local canvasHeight = 0
    local maxDisplay = 50
    for i, data in ipairs(DeleteRestoreManager.deletedObjects) do
        if i > maxDisplay then break end
        local entryFrame = Instance.new("Frame")
        entryFrame.Size = UDim2.new(1, -10, 0, 25)
        entryFrame.BackgroundTransparency = 1
        entryFrame.LayoutOrder = i
        entryFrame.Parent = logFrame

        createLabel(entryFrame, UDim2.new(0, 170, 1, 0), UDim2.new(0, 0, 0, 0),
            (data.name or "Unnamed") .. (data.object and " (Parent: " .. (data.originalParent and data.originalParent.Name or "None") .. ")" or ""))

        local restoreButton = createButton(entryFrame, UDim2.new(0, 70, 1, 0), UDim2.new(1, -70, 0, 0), "Restore", {
            Font = Enum.Font.SourceSansBold
        })

        restoreButton.MouseButton1Click:Connect(function()
            if data.object then
                local success, err = pcall(function()
                    data.object.Parent = data.originalParent
                end)
                if success then
                    table.remove(DeleteRestoreManager.deletedObjects, i)
                    DeleteRestoreManager.updateLogbox(logFrame, isAudioEnabled, restoreSound)
                    if isAudioEnabled then restoreSound:Play() end
                else
                    warn("Failed to restore object: " .. tostring(err))
                end
            end
        end)

        canvasHeight = canvasHeight + 28
    end
    logFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)
end

function DeleteRestoreManager.restoreAll(isAudioEnabled, restoreSound)
    for i = #DeleteRestoreManager.deletedObjects, 1, -1 do
        local data = DeleteRestoreManager.deletedObjects[i]
        local success, err = pcall(function()
            if data.object then
                data.object.Parent = data.originalParent
            end
            if isAudioEnabled then restoreSound:Play() end
        end)
        if not success then
            warn("Failed to restore: " .. tostring(err))
        end
    end
    DeleteRestoreManager.deletedObjects = {}
end

function DeleteRestoreManager.handleOutline(mouse, selectionBox, isDeleteModeEnabled, isActionKeyHeld, isOutlineEnabled, isCharacterProtected)
    if isDeleteModeEnabled and isActionKeyHeld and isOutlineEnabled then
        local target = mouse.Target
        if target and not DeleteRestoreManager.isBodyPartOrCharacter(target, isCharacterProtected) then
            selectionBox.Adornee = target
            selectionBox.Visible = true
        else
            selectionBox.Adornee = nil
            selectionBox.Visible = false
        end
    else
        selectionBox.Adornee = nil
        selectionBox.Visible = false
    end
end

-- Main Script Logic
local guiElements = createGui()
if not guiElements or not guiElements.gui then
    warn("GUI creation failed")
    return
end
print("GUI created successfully")

-- Extract GUI elements
local gui = guiElements.gui
local frame = guiElements.frame
local mainTabButton = guiElements.mainTabButton
local audioTabButton = guiElements.audioTabButton
local settingsTabButton = guiElements.settingsTabButton
local mainTabFrame = guiElements.mainTabFrame
local audioTabFrame = guiElements.audioTabFrame
local settingsTabFrame = guiElements.settingsTabFrame
local toggleButton = guiElements.toggleButton
local protectButton = guiElements.protectButton
local infiniteYieldButton = guiElements.infiniteYieldButton
local outlineButton = guiElements.outlineButton
local rightClickRestoreButton = guiElements.rightClickRestoreButton
local spawnShapeButton = guiElements.spawnShapeButton
local restoreAllButton = guiElements.restoreAllButton
local logFrame = guiElements.logFrame
local audioToggleButton = guiElements.audioToggleButton
local deleteAudioIdTextBox = guiElements.deleteAudioIdTextBox
local setDeleteAudioIdButton = guiElements.setDeleteAudioIdButton
local restoreAudioIdTextBox = guiElements.restoreAudioIdTextBox
local setRestoreAudioIdButton = guiElements.setRestoreAudioIdButton
local deleteVolumeLabel = guiElements.deleteVolumeLabel
local deleteVolumeSlider = guiElements.deleteVolumeSlider
local deleteVolumeFill = guiElements.deleteVolumeFill
local restoreVolumeLabel = guiElements.restoreVolumeLabel
local restoreVolumeSlider = guiElements.restoreVolumeSlider
local restoreVolumeFill = guiElements.restoreVolumeFill
local toggleKeybindTextBox = guiElements.toggleKeybindTextBox
local setToggleKeybindButton = guiElements.setToggleKeybindButton
local removeToggleKeybindButton = guiElements.removeToggleKeybindButton
local actionKeybindTextBox = guiElements.actionKeybindTextBox
local setActionKeybindButton = guiElements.setActionKeybindButton
local removeActionKeybindButton = guiElements.removeActionKeybindButton
local shapeKeybindTextBox = guiElements.shapeKeybindTextBox
local setShapeKeybindButton = guiElements.setShapeKeybindButton
local removeShapeKeybindButton = guiElements.removeShapeKeybindButton
local scrollWheelKeybindTextBox = guiElements.scrollWheelKeybindTextBox
local setScrollWheelKeybindButton = guiElements.setScrollWheelKeybindButton
local removeScrollWheelKeybindButton = guiElements.removeScrollWheelKeybindButton
local shapeSizeLabel = guiElements.shapeSizeLabel
local shapeSizeSlider = guiElements.shapeSizeSlider
local shapeSizeFill = guiElements.shapeSizeFill
local shapeThicknessLabel = guiElements.shapeThicknessLabel
local shapeThicknessSlider = guiElements.shapeThicknessSlider
local shapeThicknessFill = guiElements.shapeThicknessFill
local shapeFloorButton = guiElements.shapeFloorButton
local shapeTransparencyLabel = guiElements.shapeTransparencyLabel
local shapeTransparencySlider = guiElements.shapeTransparencySlider
local shapeTransparencyFill = guiElements.shapeTransparencyFill
local wallExtensionLabel = guiElements.wallExtensionLabel
local wallExtensionSlider = guiElements.wallExtensionSlider
local wallExtensionFill = guiElements.wallExtensionFill
local scrollWheelSizeButton = guiElements.scrollWheelSizeButton
local restoreKeybindsButton = guiElements.restoreKeybindsButton
local removeKeybindsButton = guiElements.removeKeybindsButton
local destroyMenuButton = guiElements.destroyMenuButton
local destroyAndRevertButton = guiElements.destroyAndRevertButton

-- Visual feedback
local selectionBox = Instance.new("SelectionBox", game.Workspace)
selectionBox.Name = "DeleteSelectionBox"
selectionBox.LineThickness = 0.01
selectionBox.Color3 = Color3.fromRGB(255, 0, 0)
selectionBox.Visible = false

-- Hover effect
local function applyHover(button)
    button.MouseEnter:Connect(function()
        if button.BackgroundColor3 ~= Color3.fromRGB(200, 0, 0) then
            button.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
        end
    end)
    button.MouseLeave:Connect(function()
        if button.BackgroundColor3 ~= Color3.fromRGB(200, 0, 0) then
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
    end)
end
for _, btn in ipairs({
    toggleButton, protectButton, infiniteYieldButton, outlineButton, rightClickRestoreButton, spawnShapeButton,
    restoreAllButton, audioToggleButton, setDeleteAudioIdButton, setRestoreAudioIdButton,
    mainTabButton, audioTabButton, settingsTabButton, restoreKeybindsButton, removeKeybindsButton,
    destroyMenuButton, destroyAndRevertButton, setToggleKeybindButton, setActionKeybindButton,
    setShapeKeybindButton, setScrollWheelKeybindButton, removeToggleKeybindButton, removeActionKeybindButton,
    removeShapeKeybindButton, removeScrollWheelKeybindButton, shapeFloorButton, scrollWheelSizeButton
}) do
    applyHover(btn)
end

-- Tab Switching
local function switchTab(activeButton, activeFrame)
    mainTabFrame.Visible = activeFrame == mainTabFrame
    audioTabFrame.Visible = activeFrame == audioTabFrame
    settingsTabFrame.Visible = activeFrame == settingsTabFrame
    mainTabButton.BackgroundColor3 = activeButton == mainTabButton and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
    audioTabButton.BackgroundColor3 = activeButton == audioTabButton and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
    settingsTabButton.BackgroundColor3 = activeButton == settingsTabButton and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
end

mainTabButton.MouseButton1Click:Connect(function() switchTab(mainTabButton, mainTabFrame) end)
audioTabButton.MouseButton1Click:Connect(function() switchTab(audioTabButton, audioTabFrame) end)
settingsTabButton.MouseButton1Click:Connect(function() switchTab(settingsTabButton, settingsTabFrame) end)

-- StateManager Connections
toggleButton.MouseButton1Click:Connect(function()
    StateManager.toggleState(toggleButton, "isDeleteModeEnabled", "Delete Mode: ")
end)

protectButton.MouseButton1Click:Connect(function()
    StateManager.toggleState(protectButton, "isCharacterProtected", "Protect Character: ")
end)

infiniteYieldButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/RyXeleron/infiniteyield-reborn/refs/heads/master/source'))()
    end)
    if success then
        notify("Infinite Yield", "Successfully loaded Infinite Yield Reborn")
    else
        warn("Failed to load Infinite Yield Reborn: " .. tostring(err))
        notify("Infinite Yield", "Failed to load Infinite Yield Reborn")
    end
end)

outlineButton.MouseButton1Click:Connect(function()
    StateManager.toggleState(outlineButton, "isOutlineEnabled", "Outline: ", function()
        selectionBox.Visible = StateManager.isOutlineEnabled and StateManager.isDeleteModeEnabled and StateManager.isActionKeyHeld
    end)
end)

rightClickRestoreButton.MouseButton1Click:Connect(function()
    StateManager.toggleState(rightClickRestoreButton, "isRightClickRestoreEnabled", "Right-Click Restore: ")
end)

audioToggleButton.MouseButton1Click:Connect(function()
    StateManager.toggleState(audioToggleButton, "isAudioEnabled", "Audio: ")
end)

spawnShapeButton.MouseButton1Click:Connect(function()
    StateManager.toggleShape(spawnShapeButton)
end)

shapeFloorButton.MouseButton1Click:Connect(function()
    StateManager.toggleState(shapeFloorButton, "isShapeFloorEnabled", "Shape Floor: ", function()
        if StateManager.isShapeSpawned then
            StateManager.toggleShape(spawnShapeButton)
            StateManager.toggleShape(spawnShapeButton)
        end
    end)
end)

scrollWheelSizeButton.MouseButton1Click:Connect(function()
    StateManager.toggleState(scrollWheelSizeButton, "isScrollWheelSizeEnabled", "Scroll Wheel Size: ", function()
        if StateManager.isScrollWheelSizeEnabled then
            -- Lock camera zoom
            local camera = game.Workspace.CurrentCamera
            if camera then
                local cameraPos = camera.CFrame.Position
                local focusPos = camera.Focus.Position
                local distance = (cameraPos - focusPos).Magnitude
                StateManager.lockedZoomDistance = distance
                player.CameraMinZoomDistance = distance
                player.CameraMaxZoomDistance = distance
                print("Camera zoom locked at distance:", distance)
            end
        else
            -- Restore default zoom limits
            StateManager.lockedZoomDistance = nil
            player.CameraMinZoomDistance = StateManager.defaultMinZoomDistance
            player.CameraMaxZoomDistance = StateManager.defaultMaxZoomDistance
            print("Camera zoom restored to default limits")
        end
    end)
end)

-- AudioManager Connections
setDeleteAudioIdButton.MouseButton1Click:Connect(function()
    AudioManager.setAudioId(deleteAudioIdTextBox, AudioManager.deleteSound)
end)

setRestoreAudioIdButton.MouseButton1Click:Connect(function()
    AudioManager.setAudioId(restoreAudioIdTextBox, AudioManager.restoreSound)
end)

AudioManager.setupVolumeSlider(deleteVolumeSlider, deleteVolumeFill, deleteVolumeLabel, AudioManager.deleteSound)
AudioManager.setupVolumeSlider(restoreVolumeSlider, restoreVolumeFill, restoreVolumeLabel, AudioManager.restoreSound)

-- Slider Connections
StateManager.setupSlider(shapeSizeSlider, shapeSizeFill, shapeSizeLabel, "shapeSize", 10, 355, "Shape Size: %d")
StateManager.setupSlider(shapeThicknessSlider, shapeThicknessFill, shapeThicknessLabel, "shapeThickness", 0.2, 25, "Shape Thickness: %.1f")
StateManager.setupSlider(shapeTransparencySlider, shapeTransparencyFill, shapeTransparencyLabel, "shapeTransparency", 0, 1, "Shape Transparency: %.1f")
StateManager.setupSlider(wallExtensionSlider, wallExtensionFill, wallExtensionLabel, "wallExtensionDelta", 0, 10, "Wall Extension: %.1f")

-- DeleteRestoreManager Connections
restoreAllButton.MouseButton1Click:Connect(function()
    DeleteRestoreManager.restoreAll(StateManager.isAudioEnabled, AudioManager.restoreSound)
    DeleteRestoreManager.updateLogbox(logFrame, StateManager.isAudioEnabled, AudioManager.restoreSound)
end)

local function cleanup()
    local shape = game.Workspace:FindFirstChild("PlayerShape_" .. player.Name)
    if shape then shape:Destroy() end
    if StateManager.shapeConnection then
        StateManager.shapeConnection:Disconnect()
        StateManager.shapeConnection = nil
    end
    for _, connection in ipairs(StateManager.connections) do
        connection:Disconnect()
    end
    StateManager.connections = {}
    StateManager.toggleKeybind = nil
    StateManager.actionKeybind = nil
    StateManager.shapeKeybind = nil
    StateManager.scrollWheelKeybind = nil
    StateManager.guiToggleKeybind = nil
    StateManager.isDeleteModeEnabled = false
    StateManager.isActionKeyHeld = false
    StateManager.isShapeSpawned = false
    -- Restore camera zoom limits on cleanup
    if StateManager.isScrollWheelSizeEnabled then
        player.CameraMinZoomDistance = StateManager.defaultMinZoomDistance
        player.CameraMaxZoomDistance = StateManager.defaultMaxZoomDistance
        StateManager.lockedZoomDistance = nil
        StateManager.isScrollWheelSizeEnabled = false
        scrollWheelSizeButton.Text = "Scroll Wheel Size: Off"
    end
    gui:Destroy()
    selectionBox:Destroy()
    AudioManager.deleteSound:Destroy()
    AudioManager.restoreSound:Destroy()
    DeleteRestoreManager.deletedStorage:Destroy()
end

destroyMenuButton.MouseButton1Click:Connect(cleanup)
destroyAndRevertButton.MouseButton1Click:Connect(function()
    DeleteRestoreManager.restoreAll(StateManager.isAudioEnabled, AudioManager.restoreSound)
    cleanup()
end)

-- Keybind Management
local function setKeybind(textBox, stateKey, otherKeys)
    local inputKey = textBox.Text:upper():match("^%s*(.-)%s*$")
    if inputKey == "" then
        StateManager[stateKey] = nil
        textBox.Text = ""
        notify("Keybind", "Keybind for " .. stateKey .. " cleared")
        return
    end
    local keyCode = Enum.KeyCode[inputKey]
    if not keyCode then
        notify("Keybind", "Invalid key: " .. inputKey)
        textBox.Text = StateManager[stateKey] and StateManager[stateKey].Name or ""
        return
    end
    -- Check for conflicts
    for _, otherKey in ipairs(otherKeys) do
        if otherKey and keyCode == otherKey then
            notify("Keybind", "Key " .. inputKey .. " is already assigned")
            textBox.Text = StateManager[stateKey] and StateManager[stateKey].Name or ""
            return
        end
    end
    StateManager[stateKey] = keyCode
    textBox.Text = inputKey
    notify("Keybind", "Set " .. stateKey .. " to " .. inputKey)
end

local function removeKeybind(stateKey, textBox)
    StateManager[stateKey] = nil
    textBox.Text = ""
    notify("Keybind", "Removed keybind for " .. stateKey)
end

setToggleKeybindButton.MouseButton1Click:Connect(function()
    local otherKeys = { StateManager.actionKeybind, StateManager.guiToggleKeybind, StateManager.shapeKeybind, StateManager.scrollWheelKeybind }
    setKeybind(toggleKeybindTextBox, "toggleKeybind", otherKeys)
end)

removeToggleKeybindButton.MouseButton1Click:Connect(function()
    removeKeybind("toggleKeybind", toggleKeybindTextBox)
end)

setActionKeybindButton.MouseButton1Click:Connect(function()
    local otherKeys = { StateManager.toggleKeybind, StateManager.guiToggleKeybind, StateManager.shapeKeybind, StateManager.scrollWheelKeybind }
    setKeybind(actionKeybindTextBox, "actionKeybind", otherKeys)
end)

removeActionKeybindButton.MouseButton1Click:Connect(function()
    removeKeybind("actionKeybind", actionKeybindTextBox)
end)

setShapeKeybindButton.MouseButton1Click:Connect(function()
    local otherKeys = { StateManager.toggleKeybind, StateManager.actionKeybind, StateManager.guiToggleKeybind, StateManager.scrollWheelKeybind }
    setKeybind(shapeKeybindTextBox, "shapeKeybind", otherKeys)
end)

removeShapeKeybindButton.MouseButton1Click:Connect(function()
    removeKeybind("shapeKeybind", shapeKeybindTextBox)
end)

setScrollWheelKeybindButton.MouseButton1Click:Connect(function()
    local otherKeys = { StateManager.toggleKeybind, StateManager.actionKeybind, StateManager.shapeKeybind, StateManager.guiToggleKeybind }
    setKeybind(scrollWheelKeybindTextBox, "scrollWheelKeybind", otherKeys)
end)

removeScrollWheelKeybindButton.MouseButton1Click:Connect(function()
    removeKeybind("scrollWheelKeybind", scrollWheelKeybindTextBox)
end)

restoreKeybindsButton.MouseButton1Click:Connect(function()
    StateManager.toggleKeybind = Enum.KeyCode.H
    StateManager.actionKeybind = Enum.KeyCode.T
    StateManager.shapeKeybind = Enum.KeyCode.C
    StateManager.scrollWheelKeybind = nil
    toggleKeybindTextBox.Text = "H"
    actionKeybindTextBox.Text = "T"
    shapeKeybindTextBox.Text = "C"
    scrollWheelKeybindTextBox.Text = ""
    notify("Keybind", "Restored default keybinds")
end)

removeKeybindsButton.MouseButton1Click:Connect(function()
    StateManager.toggleKeybind = nil
    StateManager.actionKeybind = nil
    StateManager.guiToggleKeybind = nil
    StateManager.shapeKeybind = nil
    StateManager.scrollWheelKeybind = nil
    toggleKeybindTextBox.Text = ""
    actionKeybindTextBox.Text = ""
    shapeKeybindTextBox.Text = ""
    scrollWheelKeybindTextBox.Text = ""
    notify("Keybind", "Removed all keybinds")
end)

-- Input Handling
StateManager.connections.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    local keyCode = input.KeyCode
    if keyCode == StateManager.guiToggleKeybind then
        StateManager.toggleGui(frame)
    elseif keyCode == StateManager.toggleKeybind then
        StateManager.toggleState(toggleButton, "isDeleteModeEnabled", "Delete Mode: ")
    elseif keyCode == StateManager.actionKeybind then
        StateManager.isActionKeyHeld = true
    elseif keyCode == StateManager.shapeKeybind then
        StateManager.toggleShape(spawnShapeButton)
    elseif keyCode == StateManager.scrollWheelKeybind then
        StateManager.toggleState(scrollWheelSizeButton, "isScrollWheelSizeEnabled", "Scroll Wheel Size: ", function()
            if StateManager.isScrollWheelSizeEnabled then
                local camera = game.Workspace.CurrentCamera
                if camera then
                    local cameraPos = camera.CFrame.Position
                    local focusPos = camera.Focus.Position
                    local distance = (cameraPos - focusPos).Magnitude
                    StateManager.lockedZoomDistance = distance
                    player.CameraMinZoomDistance = distance
                    player.CameraMaxZoomDistance = distance
                    print("Camera zoom locked at distance:", distance)
                end
            else
                StateManager.lockedZoomDistance = nil
                player.CameraMinZoomDistance = StateManager.defaultMinZoomDistance
                player.CameraMaxZoomDistance = StateManager.defaultMaxZoomDistance
                print("Camera zoom restored to default limits")
            end
        end)
    end
end)

StateManager.connections.inputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == StateManager.actionKeybind then
        StateManager.isActionKeyHeld = false
    end
end)

StateManager.connections.inputChanged = UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent or not StateManager.isScrollWheelSizeEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        local delta = input.Position.Z
        local sizeIncrement = 5
        local newSize = StateManager.shapeSize + (delta * sizeIncrement)
        newSize = math.clamp(newSize, 10, 355)
        StateManager.shapeSize = newSize
        local fraction = (newSize - 10) / (355 - 10)
        shapeSizeFill.Size = UDim2.new(fraction, 0, 1, 0)
        shapeSizeLabel.Text = string.format("Shape Size: %d", newSize)
    end
end)

-- Outline Handling
StateManager.connections.outline = RunService.Heartbeat:Connect(function()
    DeleteRestoreManager.handleOutline(
        mouse,
        selectionBox,
        StateManager.isDeleteModeEnabled,
        StateManager.isActionKeyHeld,
        StateManager.isOutlineEnabled,
        StateManager.isCharacterProtected
    )
end)

-- Delete Objects
local debounce = false
StateManager.connections.delete = mouse.Button1Down:Connect(function()
    if debounce or not StateManager.isDeleteModeEnabled or not StateManager.isActionKeyHeld then
        debounce = false
        return
    end
    debounce = true

    local target = mouse.Target
    if not target or target:IsA("Terrain") or DeleteRestoreManager.isBodyPartOrCharacter(target, StateManager.isCharacterProtected) then
        debounce = false
        return
    end

    table.insert(DeleteRestoreManager.deletedObjects, { object = target, originalParent = target.Parent, name = target.Name })
    local success, err = pcall(function()
        target.Parent = DeleteRestoreManager.deletedStorage
        if StateManager.isAudioEnabled then AudioManager.deleteSound:Play() end
    end)
    if success then
        DeleteRestoreManager.updateLogbox(logFrame, StateManager.isAudioEnabled, AudioManager.restoreSound)
    else
        warn("Failed to delete object: " .. tostring(err))
    end

    task.wait(0.1)
    debounce = false
end)

-- Restore Objects
StateManager.connections.restore = mouse.Button2Down:Connect(function()
    if not StateManager.isActionKeyHeld or not StateManager.isRightClickRestoreEnabled or #DeleteRestoreManager.deletedObjects == 0 then return end
    local data = table.remove(DeleteRestoreManager.deletedObjects)
    local success, err = pcall(function()
        if data.object then
            data.object.Parent = data.originalParent
        end
        if StateManager.isAudioEnabled then AudioManager.restoreSound:Play() end
    end)
    if success then
        DeleteRestoreManager.updateLogbox(logFrame, StateManager.isAudioEnabled, AudioManager.restoreSound)
    else
        warn("Failed to restore: " .. tostring(err))
    end
end)

-- Handle Character Respawn
player.CharacterAdded:Connect(function(character)
    print("Character respawned:", character.Name)
    DeleteRestoreManager.characterCache = {}
    if StateManager.isShapeSpawned then
        StateManager.toggleShape(spawnShapeButton)
        StateManager.toggleShape(spawnShapeButton)
    end
end)
