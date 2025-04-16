-- Delete Tool Script (With Hollow Following Cube Made of Separate Parts, Toggleable Floor, Adjustable Size and Thickness)

-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

-- Player setup
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Wait for the player to be fully loaded
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

-- Placeholder notify function (since the original command system isn't provided)
local function notify(title, message)
    print(string.format("[%s]: %s", title, message))
end

-- GUI Creation Function
local function createGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "DeleteGui"
    gui.ResetOnSpawn = false
    gui.Enabled = true
    gui.IgnoreGuiInset = true
    print("GUI Created - Enabled:", gui.Enabled)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 460)
    frame.Position = UDim2.new(0.5, -150, 0.5, -230)
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

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 30)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "Delete Tool"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = frame

    -- Tab Buttons
    local mainTabButton = Instance.new("TextButton")
    mainTabButton.Size = UDim2.new(0, 90, 0, 25)
    mainTabButton.Position = UDim2.new(0, 5, 0, 40)
    mainTabButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    mainTabButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    mainTabButton.BorderSizePixel = 1
    mainTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainTabButton.Text = "Main"
    mainTabButton.Font = Enum.Font.SourceSansBold
    mainTabButton.TextSize = 16
    mainTabButton.Parent = frame

    local audioTabButton = Instance.new("TextButton")
    audioTabButton.Size = UDim2.new(0, 90, 0, 25)
    audioTabButton.Position = UDim2.new(0, 95, 0, 40)
    audioTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    audioTabButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    audioTabButton.BorderSizePixel = 1
    audioTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    audioTabButton.Text = "Audio"
    audioTabButton.Font = Enum.Font.SourceSansBold
    audioTabButton.TextSize = 16
    audioTabButton.Parent = frame

    local settingsTabButton = Instance.new("TextButton")
    settingsTabButton.Size = UDim2.new(0, 90, 0, 25)
    settingsTabButton.Position = UDim2.new(0, 185, 0, 40)
    settingsTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    settingsTabButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    settingsTabButton.BorderSizePixel = 1
    settingsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsTabButton.Text = "Settings"
    settingsTabButton.Font = Enum.Font.SourceSansBold
    settingsTabButton.TextSize = 16
    settingsTabButton.Parent = frame

    -- Main Tab Frame
    local mainTabFrame = Instance.new("Frame")
    mainTabFrame.Size = UDim2.new(1, -10, 0, 385)
    mainTabFrame.Position = UDim2.new(0, 5, 0, 70)
    mainTabFrame.BackgroundTransparency = 1
    mainTabFrame.Visible = true
    mainTabFrame.Parent = frame

    -- Audio Tab Frame
    local audioTabFrame = Instance.new("Frame")
    audioTabFrame.Size = UDim2.new(1, -10, 0, 385)
    audioTabFrame.Position = UDim2.new(0, 5, 0, 70)
    audioTabFrame.BackgroundTransparency = 1
    audioTabFrame.Visible = false
    audioTabFrame.Parent = frame

    -- Settings Tab Frame
    local settingsTabFrame = Instance.new("Frame")
    settingsTabFrame.Size = UDim2.new(1, -10, 0, 385)
    settingsTabFrame.Position = UDim2.new(0, 5, 0, 70)
    settingsTabFrame.BackgroundTransparency = 1
    settingsTabFrame.Visible = false
    settingsTabFrame.Parent = frame

    -- Main Tab Contents
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 130, 0, 30)
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    toggleButton.BorderSizePixel = 1
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "Delete Mode: Off"
    toggleButton.Font = Enum.Font.SourceSans
    toggleButton.TextSize = 16
    toggleButton.Parent = mainTabFrame

    local protectButton = Instance.new("TextButton")
    protectButton.Size = UDim2.new(0, 130, 0, 30)
    protectButton.Position = UDim2.new(0, 140, 0, 0)
    protectButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    protectButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    protectButton.BorderSizePixel = 1
    protectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    protectButton.Text = "Protect Character: Off"
    toggleButton.Font = Enum.Font.SourceSans
    toggleButton.TextSize = 16
    protectButton.Parent = mainTabFrame

    local terrainButton = Instance.new("TextButton")
    terrainButton.Size = UDim2.new(0, 130, 0, 30)
    terrainButton.Position = UDim2.new(0, 0, 0, 35)
    terrainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    terrainButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    terrainButton.BorderSizePixel = 1
    terrainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    terrainButton.Text = "Terrain Deletion: Off"
    terrainButton.Font = Enum.Font.SourceSans
    terrainButton.TextSize = 16
    terrainButton.Parent = mainTabFrame

    local outlineButton = Instance.new("TextButton")
    outlineButton.Size = UDim2.new(0, 130, 0, 30)
    outlineButton.Position = UDim2.new(0, 140, 0, 35)
    outlineButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    outlineButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    outlineButton.BorderSizePixel = 1
    outlineButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    outlineButton.Text = "Outline: On"
    outlineButton.Font = Enum.Font.SourceSans
    outlineButton.TextSize = 16
    outlineButton.Parent = mainTabFrame

    local rightClickRestoreButton = Instance.new("TextButton")
    rightClickRestoreButton.Size = UDim2.new(0, 130, 0, 30)
    rightClickRestoreButton.Position = UDim2.new(0, 0, 0, 70)
    rightClickRestoreButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    rightClickRestoreButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    rightClickRestoreButton.BorderSizePixel = 1
    rightClickRestoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    rightClickRestoreButton.Text = "Right-Click Restore: On"
    rightClickRestoreButton.Font = Enum.Font.SourceSans
    rightClickRestoreButton.TextSize = 16
    rightClickRestoreButton.Parent = mainTabFrame

    local spawnCubeButton = Instance.new("TextButton")
    spawnCubeButton.Size = UDim2.new(0, 130, 0, 30)
    spawnCubeButton.Position = UDim2.new(0, 140, 0, 70)
    spawnCubeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    spawnCubeButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    spawnCubeButton.BorderSizePixel = 1
    spawnCubeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    spawnCubeButton.Text = "Spawn Cube: Off"
    spawnCubeButton.Font = Enum.Font.SourceSans
    spawnCubeButton.TextSize = 16
    spawnCubeButton.Parent = mainTabFrame

    local restoreAllButton = Instance.new("TextButton")
    restoreAllButton.Size = UDim2.new(1, 0, 0, 30)
    restoreAllButton.Position = UDim2.new(0, 0, 0, 105)
    restoreAllButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    restoreAllButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    restoreAllButton.BorderSizePixel = 1
    restoreAllButton.TextColor3 = Color3.fromRGB(255, 257, 255)
    restoreAllButton.Text = "Restore All"
    restoreAllButton.Font = Enum.Font.SourceSans
    restoreAllButton.TextSize = 16
    restoreAllButton.Parent = mainTabFrame

    local logFrame = Instance.new("ScrollingFrame")
    logFrame.Size = UDim2.new(1, 0, 0, 200)
    logFrame.Position = UDim2.new(0, 0, 0, 150)
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
    local audioToggleButton = Instance.new("TextButton")
    audioToggleButton.Size = UDim2.new(0, 130, 0, 30)
    audioToggleButton.Position = UDim2.new(0, 0, 0, 0)
    audioToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    audioToggleButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    audioToggleButton.BorderSizePixel = 1
    audioToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    audioToggleButton.Text = "Audio: On"
    audioToggleButton.Font = Enum.Font.SourceSans
    audioToggleButton.TextSize = 16
    audioToggleButton.Parent = audioTabFrame

    local deleteAudioIdLabel = Instance.new("TextLabel")
    deleteAudioIdLabel.Size = UDim2.new(1, 0, 0, 20)
    deleteAudioIdLabel.Position = UDim2.new(0, 0, 0, 35)
    deleteAudioIdLabel.BackgroundTransparency = 1
    deleteAudioIdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    deleteAudioIdLabel.Text = "Delete Audio ID:"
    deleteAudioIdLabel.Font = Enum.Font.SourceSansBold
    deleteAudioIdLabel.TextSize = 14
    deleteAudioIdLabel.Parent = audioTabFrame

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

    local setDeleteAudioIdButton = Instance.new("TextButton")
    setDeleteAudioIdButton.Size = UDim2.new(0, 50, 0, 25)
    setDeleteAudioIdButton.Position = UDim2.new(0, 215, 0, 0)
    setDeleteAudioIdButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    setDeleteAudioIdButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    setDeleteAudioIdButton.BorderSizePixel = 1
    setDeleteAudioIdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    setDeleteAudioIdButton.Text = "Set"
    setDeleteAudioIdButton.Font = Enum.Font.SourceSansBold
    setDeleteAudioIdButton.TextSize = 14
    setDeleteAudioIdButton.Parent = deleteAudioIdFrame

    local restoreAudioIdLabel = Instance.new("TextLabel")
    restoreAudioIdLabel.Size = UDim2.new(1, 0, 0, 20)
    restoreAudioIdLabel.Position = UDim2.new(0, 0, 0, 85)
    restoreAudioIdLabel.BackgroundTransparency = 1
    restoreAudioIdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    restoreAudioIdLabel.Text = "Restore Audio ID:"
    restoreAudioIdLabel.Font = Enum.Font.SourceSansBold
    restoreAudioIdLabel.TextSize = 14
    restoreAudioIdLabel.Parent = audioTabFrame

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
    restoreAudioIdTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    restoreAudioIdTextBox.PlaceholderText = "e.g., 773858658"
    restoreAudioIdTextBox.Text = "773858658"
    restoreAudioIdTextBox.Font = Enum.Font.SourceSans
    restoreAudioIdTextBox.TextSize = 14
    restoreAudioIdTextBox.Parent = restoreAudioIdFrame

    local setRestoreAudioIdButton = Instance.new("TextButton")
    setRestoreAudioIdButton.Size = UDim2.new(0, 50, 0, 25)
    setRestoreAudioIdButton.Position = UDim2.new(0, 215, 0, 0)
    setRestoreAudioIdButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    setRestoreAudioIdButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    setRestoreAudioIdButton.BorderSizePixel = 1
    setRestoreAudioIdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    setRestoreAudioIdButton.Text = "Set"
    setRestoreAudioIdButton.Font = Enum.Font.SourceSansBold
    setRestoreAudioIdButton.TextSize = 14
    setRestoreAudioIdButton.Parent = restoreAudioIdFrame

    local deleteVolumeLabel = Instance.new("TextLabel")
    deleteVolumeLabel.Size = UDim2.new(1, 0, 0, 20)
    deleteVolumeLabel.Position = UDim2.new(0, 0, 0, 135)
    deleteVolumeLabel.BackgroundTransparency = 1
    deleteVolumeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    deleteVolumeLabel.Text = "Delete Volume: 1.0"
    deleteVolumeLabel.Font = Enum.Font.SourceSansBold
    deleteVolumeLabel.TextSize = 14
    deleteVolumeLabel.Parent = audioTabFrame

    local deleteVolumeSlider = Instance.new("TextButton")
    deleteVolumeSlider.Size = UDim2.new(1, 0, 0, 20)
    deleteVolumeSlider.Position = UDim2.new(0, 0, 0, 155)
    deleteVolumeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    deleteVolumeSlider.BorderColor3 = Color3.fromRGB(100, 0, 0)
    deleteVolumeSlider.BorderSizePixel = 1
    deleteVolumeSlider.Text = ""
    deleteVolumeSlider.Parent = audioTabFrame

    local deleteVolumeFill = Instance.new("Frame")
    deleteVolumeFill.Size = UDim2.new(1, 0, 1, 0)
    deleteVolumeFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    deleteVolumeFill.BorderSizePixel = 0
    deleteVolumeFill.Parent = deleteVolumeSlider

    local restoreVolumeLabel = Instance.new("TextLabel")
    restoreVolumeLabel.Size = UDim2.new(1, 0, 0, 20)
    restoreVolumeLabel.Position = UDim2.new(0, 0, 0, 180)
    restoreVolumeLabel.BackgroundTransparency = 1
    restoreVolumeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    restoreVolumeLabel.Text = "Restore Volume: 1.0"
    restoreVolumeLabel.Font = Enum.Font.SourceSansBold
    restoreVolumeLabel.TextSize = 14
    restoreVolumeLabel.Parent = audioTabFrame

    local restoreVolumeSlider = Instance.new("TextButton")
    restoreVolumeSlider.Size = UDim2.new(1, 0, 0, 20)
    restoreVolumeSlider.Position = UDim2.new(0, 0, 0, 200)
    restoreVolumeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    restoreVolumeSlider.BorderColor3 = Color3.fromRGB(100, 0, 0)
    restoreVolumeSlider.BorderSizePixel = 1
    restoreVolumeSlider.Text = ""
    restoreVolumeSlider.Parent = audioTabFrame

    local restoreVolumeFill = Instance.new("Frame")
    restoreVolumeFill.Size = UDim2.new(1, 0, 1, 0)
    restoreVolumeFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    restoreVolumeFill.BorderSizePixel = 0
    restoreVolumeFill.Parent = restoreVolumeSlider

    -- Settings Tab Contents
    local toggleKeybindLabel = Instance.new("TextLabel")
    toggleKeybindLabel.Size = UDim2.new(1, 0, 0, 20)
    toggleKeybindLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleKeybindLabel.BackgroundTransparency = 1
    toggleKeybindLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleKeybindLabel.Text = "Toggle Keybind:"
    toggleKeybindLabel.Font = Enum.Font.SourceSansBold
    toggleKeybindLabel.TextSize = 14
    toggleKeybindLabel.Parent = settingsTabFrame

    local toggleKeybindFrame = Instance.new("Frame")
    toggleKeybindFrame.Size = UDim2.new(1, 0, 0, 25)
    toggleKeybindFrame.Position = UDim2.new(0, 0, 0, 20)
    toggleKeybindFrame.BackgroundTransparency = 1
    toggleKeybindFrame.Parent = settingsTabFrame

    local toggleKeybindTextBox = Instance.new("TextBox")
    toggleKeybindTextBox.Size = UDim2.new(0, 210, 0, 25)
    toggleKeybindTextBox.Position = UDim2.new(0, 0, 0, 0)
    toggleKeybindTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
    toggleKeybindTextBox.BorderSizePixel = 1
    toggleKeybindTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleKeybindTextBox.PlaceholderText = "e.g., H, G"
    toggleKeybindTextBox.Text = "H"
    toggleKeybindTextBox.Font = Enum.Font.SourceSans
    toggleKeybindTextBox.TextSize = 14
    toggleKeybindTextBox.Parent = toggleKeybindFrame

    local setToggleKeybindButton = Instance.new("TextButton")
    setToggleKeybindButton.Size = UDim2.new(0, 50, 0, 25)
    setToggleKeybindButton.Position = UDim2.new(0, 215, 0, 0)
    setToggleKeybindButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    setToggleKeybindButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    setToggleKeybindButton.BorderSizePixel = 1
    setToggleKeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    setToggleKeybindButton.Text = "Set"
    setToggleKeybindButton.Font = Enum.Font.SourceSansBold
    setToggleKeybindButton.TextSize = 14
    setToggleKeybindButton.Parent = toggleKeybindFrame

    local actionKeybindLabel = Instance.new("TextLabel")
    actionKeybindLabel.Size = UDim2.new(1, 0, 0, 20)
    actionKeybindLabel.Position = UDim2.new(0, 0, 0, 50)
    actionKeybindLabel.BackgroundTransparency = 1
    actionKeybindLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    actionKeybindLabel.Text = "Action Keybind:"
    actionKeybindLabel.Font = Enum.Font.SourceSansBold
    actionKeybindLabel.TextSize = 14
    actionKeybindLabel.Parent = settingsTabFrame

    local actionKeybindFrame = Instance.new("Frame")
    actionKeybindFrame.Size = UDim2.new(1, 0, 0, 25)
    actionKeybindFrame.Position = UDim2.new(0, 0, 0, 70)
    actionKeybindFrame.BackgroundTransparency = 1
    actionKeybindFrame.Parent = settingsTabFrame

    local actionKeybindTextBox = Instance.new("TextBox")
    actionKeybindTextBox.Size = UDim2.new(0, 210, 0, 25)
    actionKeybindTextBox.Position = UDim2.new(0, 0, 0, 0)
    actionKeybindTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    actionKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
    actionKeybindTextBox.BorderSizePixel = 1
    actionKeybindTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionKeybindTextBox.PlaceholderText = "e.g., T, R"
    actionKeybindTextBox.Text = "T"
    actionKeybindTextBox.Font = Enum.Font.SourceSans
    actionKeybindTextBox.TextSize = 14
    actionKeybindTextBox.Parent = actionKeybindFrame

    local setActionKeybindButton = Instance.new("TextButton")
    setActionKeybindButton.Size = UDim2.new(0, 50, 0, 25)
    setActionKeybindButton.Position = UDim2.new(0, 215, 0, 0)
    setActionKeybindButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    setActionKeybindButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    setActionKeybindButton.BorderSizePixel = 1
    setActionKeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    setActionKeybindButton.Text = "Set"
    setActionKeybindButton.Font = Enum.Font.SourceSansBold
    setActionKeybindButton.TextSize = 14
    setActionKeybindButton.Parent = actionKeybindFrame

    local cubeKeybindLabel = Instance.new("TextLabel")
    cubeKeybindLabel.Size = UDim2.new(1, 0, 0, 20)
    cubeKeybindLabel.Position = UDim2.new(0, 0, 0, 100)
    cubeKeybindLabel.BackgroundTransparency = 1
    cubeKeybindLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    cubeKeybindLabel.Text = "Cube Keybind:"
    cubeKeybindLabel.Font = Enum.Font.SourceSansBold
    cubeKeybindLabel.TextSize = 14
    cubeKeybindLabel.Parent = settingsTabFrame

    local cubeKeybindFrame = Instance.new("Frame")
    cubeKeybindFrame.Size = UDim2.new(1, 0, 0, 25)
    cubeKeybindFrame.Position = UDim2.new(0, 0, 0, 120)
    cubeKeybindFrame.BackgroundTransparency = 1
    cubeKeybindFrame.Parent = settingsTabFrame

    local cubeKeybindTextBox = Instance.new("TextBox")
    cubeKeybindTextBox.Size = UDim2.new(0, 210, 0, 25)
    cubeKeybindTextBox.Position = UDim2.new(0, 0, 0, 0)
    cubeKeybindTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    cubeKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
    cubeKeybindTextBox.BorderSizePixel = 1
    cubeKeybindTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    cubeKeybindTextBox.PlaceholderText = "e.g., C, V"
    cubeKeybindTextBox.Text = "C"
    cubeKeybindTextBox.Font = Enum.Font.SourceSans
    cubeKeybindTextBox.TextSize = 14
    cubeKeybindTextBox.Parent = cubeKeybindFrame

    local setCubeKeybindButton = Instance.new("TextButton")
    setCubeKeybindButton.Size = UDim2.new(0, 50, 0, 25)
    setCubeKeybindButton.Position = UDim2.new(0, 215, 0, 0)
    setCubeKeybindButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    setCubeKeybindButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    setCubeKeybindButton.BorderSizePixel = 1
    setCubeKeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    setCubeKeybindButton.Text = "Set"
    setCubeKeybindButton.Font = Enum.Font.SourceSansBold
    setCubeKeybindButton.TextSize = 14
    setCubeKeybindButton.Parent = cubeKeybindFrame

    -- Cube Size Slider
    local cubeSizeLabel = Instance.new("TextLabel")
    cubeSizeLabel.Size = UDim2.new(1, 0, 0, 20)
    cubeSizeLabel.Position = UDim2.new(0, 0, 0, 150)
    cubeSizeLabel.BackgroundTransparency = 1
    cubeSizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    cubeSizeLabel.Text = "Cube Size: 25"
    cubeSizeLabel.Font = Enum.Font.SourceSansBold
    cubeSizeLabel.TextSize = 14
    cubeSizeLabel.Parent = settingsTabFrame

    local cubeSizeSlider = Instance.new("TextButton")
    cubeSizeSlider.Size = UDim2.new(1, 0, 0, 20)
    cubeSizeSlider.Position = UDim2.new(0, 0, 0, 170)
    cubeSizeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    cubeSizeSlider.BorderColor3 = Color3.fromRGB(100, 0, 0)
    cubeSizeSlider.BorderSizePixel = 1
    cubeSizeSlider.Text = ""
    cubeSizeSlider.Parent = settingsTabFrame

    local cubeSizeFill = Instance.new("Frame")
    cubeSizeFill.Size = UDim2.new(0.5, 0, 1, 0) -- Default at 25 (midpoint between 10 and 50)
    cubeSizeFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    cubeSizeFill.BorderSizePixel = 0
    cubeSizeFill.Parent = cubeSizeSlider

    -- Cube Thickness Slider
    local cubeThicknessLabel = Instance.new("TextLabel")
    cubeThicknessLabel.Size = UDim2.new(1, 0, 0, 20)
    cubeThicknessLabel.Position = UDim2.new(0, 0, 0, 195)
    cubeThicknessLabel.BackgroundTransparency = 1
    cubeThicknessLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    cubeThicknessLabel.Text = "Cube Thickness: 1.0"
    cubeThicknessLabel.Font = Enum.Font.SourceSansBold
    cubeThicknessLabel.TextSize = 14
    cubeThicknessLabel.Parent = settingsTabFrame

    local cubeThicknessSlider = Instance.new("TextButton")
    cubeThicknessSlider.Size = UDim2.new(1, 0, 0, 20)
    cubeThicknessSlider.Position = UDim2.new(0, 0, 0, 215)
    cubeThicknessSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    cubeThicknessSlider.BorderColor3 = Color3.fromRGB(100, 0, 0)
    cubeThicknessSlider.BorderSizePixel = 1
    cubeThicknessSlider.Text = ""
    cubeThicknessSlider.Parent = settingsTabFrame

    local cubeThicknessFill = Instance.new("Frame")
    cubeThicknessFill.Size = UDim2.new(0.032, 0, 1, 0) -- Default at 1 (3.2% between 0.2 and 25)
    cubeThicknessFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    cubeThicknessFill.BorderSizePixel = 0
    cubeThicknessFill.Parent = cubeThicknessSlider

    -- Cube Floor Toggle
    local cubeFloorButton = Instance.new("TextButton")
    cubeFloorButton.Size = UDim2.new(0, 130, 0, 30)
    cubeFloorButton.Position = UDim2.new(0, 0, 0, 240)
    cubeFloorButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    cubeFloorButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    cubeFloorButton.BorderSizePixel = 1
    cubeFloorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cubeFloorButton.Text = "Cube Floor: Off"
    cubeFloorButton.Font = Enum.Font.SourceSans
    cubeFloorButton.TextSize = 16
    cubeFloorButton.Parent = settingsTabFrame

    -- Adjust positions of subsequent buttons to accommodate the new button
    local restoreKeybindsButton = Instance.new("TextButton")
    restoreKeybindsButton.Size = UDim2.new(0, 130, 0, 30)
    restoreKeybindsButton.Position = UDim2.new(0, 0, 0, 275) -- Shifted down by 35
    restoreKeybindsButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    restoreKeybindsButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    restoreKeybindsButton.BorderSizePixel = 1
    restoreKeybindsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    restoreKeybindsButton.Text = "Restore All Keybinds"
    restoreKeybindsButton.Font = Enum.Font.SourceSans
    restoreKeybindsButton.TextSize = 16
    restoreKeybindsButton.Parent = settingsTabFrame

    local removeKeybindsButton = Instance.new("TextButton")
    removeKeybindsButton.Size = UDim2.new(0, 130, 0, 30)
    removeKeybindsButton.Position = UDim2.new(0, 0, 0, 310) -- Shifted down by 35
    removeKeybindsButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    removeKeybindsButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    restoreKeybindsButton.BorderSizePixel = 1
    removeKeybindsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    removeKeybindsButton.Text = "Remove Every Keybind"
    removeKeybindsButton.Font = Enum.Font.SourceSans
    removeKeybindsButton.TextSize = 16
    removeKeybindsButton.Parent = settingsTabFrame

    local destroyMenuButton = Instance.new("TextButton")
    destroyMenuButton.Size = UDim2.new(0, 130, 0, 30)
    destroyMenuButton.Position = UDim2.new(0, 0, 0, 345) -- Shifted down by 35
    destroyMenuButton.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    destroyMenuButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    destroyMenuButton.BorderSizePixel = 1
    destroyMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    destroyMenuButton.Text = "Destroy Menu"
    destroyMenuButton.Font = Enum.Font.SourceSans
    destroyMenuButton.TextSize = 16
    destroyMenuButton.Parent = settingsTabFrame

    local destroyAndRevertButton = Instance.new("TextButton")
    destroyAndRevertButton.Size = UDim2.new(0, 130, 0, 30)
    destroyAndRevertButton.Position = UDim2.new(0, 140, 0, 345) -- Shifted down by 35
    destroyAndRevertButton.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    destroyAndRevertButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    destroyAndRevertButton.BorderSizePixel = 1
    destroyAndRevertButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    destroyAndRevertButton.Text = "Destroy & Revert"
    destroyAndRevertButton.Font = Enum.Font.SourceSans
    destroyAndRevertButton.TextSize = 16
    destroyAndRevertButton.Parent = settingsTabFrame

    -- Parent the GUI to PlayerGui
    gui.Parent = playerGui
    print("DeleteGui successfully parented to PlayerGui")
    print("GUI Parent:", gui.Parent:GetFullName())
    print("GUI Enabled (post-parenting):", gui.Enabled)
    print("Frame Visible (post-parenting):", frame.Visible)

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
        terrainButton = terrainButton,
        outlineButton = outlineButton,
        rightClickRestoreButton = rightClickRestoreButton,
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
        actionKeybindTextBox = actionKeybindTextBox,
        setActionKeybindButton = setActionKeybindButton,
        restoreKeybindsButton = restoreKeybindsButton,
        removeKeybindsButton = removeKeybindsButton,
        destroyMenuButton = destroyMenuButton,
        destroyAndRevertButton = destroyAndRevertButton,
        spawnCubeButton = spawnCubeButton,
        cubeKeybindTextBox = cubeKeybindTextBox,
        setCubeKeybindButton = setCubeKeybindButton,
        cubeSizeLabel = cubeSizeLabel,
        cubeSizeSlider = cubeSizeSlider,
        cubeSizeFill = cubeSizeFill,
        cubeThicknessLabel = cubeThicknessLabel,
        cubeThicknessSlider = cubeThicknessSlider,
        cubeThicknessFill = cubeThicknessFill,
        cubeFloorButton = cubeFloorButton -- Added new button to the return table
    }
end

-- StateManager
local StateManager = {
    isDeleteModeEnabled = false,
    isCharacterProtected = false,
    isTerrainDeletionEnabled = false,
    isOutlineEnabled = true,
    isRightClickRestoreEnabled = true,
    isAudioEnabled = true,
    toggleKeybind = Enum.KeyCode.H,
    actionKeybind = Enum.KeyCode.T,
    guiToggleKeybind = Enum.KeyCode.F1,
    isActionKeyHeld = false,
    isCubeSpawned = false,
    cubeKeybind = Enum.KeyCode.C,
    cubeConnection = nil, -- To store the Heartbeat connection for cube following
    cubeSize = 25, -- Default cube size (matches slider default)
    cubeThickness = 1, -- Default cube thickness (matches slider default)
    isCubeFloorEnabled = false -- New state to track floor toggle
}

function StateManager.toggleDeleteMode(toggleButton)
    StateManager.isDeleteModeEnabled = not StateManager.isDeleteModeEnabled
    toggleButton.Text = "Delete Mode: " .. (StateManager.isDeleteModeEnabled and "On" or "Off")
end

function StateManager.toggleCharacterProtection(protectButton)
    StateManager.isCharacterProtected = not StateManager.isCharacterProtected
    protectButton.Text = "Protect Character: " .. (StateManager.isCharacterProtected and "On" or "Off")
end

function StateManager.toggleTerrainDeletion(terrainButton)
    StateManager.isTerrainDeletionEnabled = not StateManager.isTerrainDeletionEnabled
    terrainButton.Text = "Terrain Deletion: " .. (StateManager.isTerrainDeletionEnabled and "On" or "Off")
end

function StateManager.toggleOutline(outlineButton, selectionBox)
    StateManager.isOutlineEnabled = not StateManager.isOutlineEnabled
    outlineButton.Text = "Outline: " .. (StateManager.isOutlineEnabled and "On" or "Off")
    selectionBox.Visible = StateManager.isOutlineEnabled and StateManager.isDeleteModeEnabled and StateManager.isActionKeyHeld
end

function StateManager.toggleRightClickRestore(rightClickRestoreButton)
    StateManager.isRightClickRestoreEnabled = not StateManager.isRightClickRestoreEnabled
    rightClickRestoreButton.Text = "Right-Click Restore: " .. (StateManager.isRightClickRestoreEnabled and "On" or "Off")
end

function StateManager.toggleAudio(audioToggleButton)
    StateManager.isAudioEnabled = not StateManager.isAudioEnabled
    audioToggleButton.Text = "Audio: " .. (StateManager.isAudioEnabled and "On" or "Off")
end

function StateManager.toggleCubeFloor(cubeFloorButton)
    StateManager.isCubeFloorEnabled = not StateManager.isCubeFloorEnabled
    cubeFloorButton.Text = "Cube Floor: " .. (StateManager.isCubeFloorEnabled and "On" or "Off")
    -- If cube is already spawned, despawn and respawn to apply floor setting
    if StateManager.isCubeSpawned then
        local spawnCubeButton = cubeFloorButton.Parent.Parent.Parent.Parent:FindFirstChild("MainTabFrame"):FindFirstChild("SpawnCubeButton")
        if spawnCubeButton then
            StateManager.toggleCube(spawnCubeButton) -- Turn off
            StateManager.toggleCube(spawnCubeButton) -- Turn back on to reset with new floor setting
        end
    end
end

function StateManager.toggleCube(spawnCubeButton)
    StateManager.isCubeSpawned = not StateManager.isCubeSpawned
    spawnCubeButton.Text = "Spawn Cube: " .. (StateManager.isCubeSpawned and "On" or "Off")

    local existingCube = game.Workspace:FindFirstChild("PlayerCube_" .. player.Name)
    if StateManager.isCubeSpawned then
        -- Check if character and HumanoidRootPart exist
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            print("Character or HumanoidRootPart not found, cannot spawn cube")
            StateManager.isCubeSpawned = false
            spawnCubeButton.Text = "Spawn Cube: Off"
            return
        end

        if existingCube then
            existingCube:Destroy()
        end

        -- Create a Model to hold the cube parts
        local cubeModel = Instance.new("Model")
        cubeModel.Name = "PlayerCube_" .. player.Name

        -- Define cube properties
        local cubeSize = Vector3.new(StateManager.cubeSize, StateManager.cubeSize, StateManager.cubeSize) -- Use dynamic cube size
        local wallThickness = StateManager.cubeThickness -- Use dynamic thickness
        local transparency = 0.7
        local brickColor = BrickColor.new("Really red")

        -- Get the player's position as the center of the cube
        local playerPos = player.Character.HumanoidRootPart.Position
        -- Adjust the vertical offset to account for player's height (approx. 5 studs tall)
        local playerHeightOffset = 2.5 -- Half of player's height to center the cube vertically
        local verticalShift = StateManager.isCubeFloorEnabled and (wallThickness / 2) or 0 -- Shift cube up if floor is enabled
        local centerPos = playerPos + Vector3.new(0, cubeSize.Y / 2 - playerHeightOffset + verticalShift, 0)

        -- Create the four walls and ceiling
        -- Wall 1: Left Wall (X = -cubeSize.X/2)
        local leftWall = Instance.new("Part")
        leftWall.Size = Vector3.new(wallThickness, cubeSize.Y, cubeSize.Z)
        leftWall.Position = centerPos + Vector3.new(-cubeSize.X / 2 + wallThickness / 2, 0, 0)
        leftWall.Anchored = true
        leftWall.CanCollide = true
        leftWall.Transparency = transparency
        leftWall.BrickColor = brickColor
        leftWall.Parent = cubeModel

        -- Wall 2: Right Wall (X = cubeSize.X/2)
        local rightWall = Instance.new("Part")
        rightWall.Size = Vector3.new(wallThickness, cubeSize.Y, cubeSize.Z)
        rightWall.Position = centerPos + Vector3.new(cubeSize.X / 2 - wallThickness / 2, 0, 0)
        rightWall.Anchored = true
        rightWall.CanCollide = true
        rightWall.Transparency = transparency
        rightWall.BrickColor = brickColor
        rightWall.Parent = cubeModel

        -- Wall 3: Front Wall (Z = -cubeSize.Z/2)
        local frontWall = Instance.new("Part")
        frontWall.Size = Vector3.new(cubeSize.X, cubeSize.Y, wallThickness)
        frontWall.Position = centerPos + Vector3.new(0, 0, -cubeSize.Z / 2 + wallThickness / 2)
        frontWall.Anchored = true
        frontWall.CanCollide = true
        frontWall.Transparency = transparency
        frontWall.BrickColor = brickColor
        frontWall.Parent = cubeModel

        -- Wall 4: Back Wall (Z = cubeSize.Z/2)
        local backWall = Instance.new("Part")
        backWall.Size = Vector3.new(cubeSize.X, cubeSize.Y, wallThickness)
        backWall.Position = centerPos + Vector3.new(0, 0, cubeSize.Z / 2 - wallThickness / 2)
        backWall.Anchored = true
        backWall.CanCollide = true
        backWall.Transparency = transparency
        backWall.BrickColor = brickColor
        backWall.Parent = cubeModel

        -- Ceiling (Y = cubeSize.Y/2)
        local ceiling = Instance.new("Part")
        ceiling.Size = Vector3.new(cubeSize.X, wallThickness, cubeSize.Z)
        ceiling.Position = centerPos + Vector3.new(0, cubeSize.Y / 2 - wallThickness / 2, 0)
        ceiling.Anchored = true
        ceiling.CanCollide = true
        ceiling.Transparency = transparency
        ceiling.BrickColor = brickColor
        ceiling.Parent = cubeModel

        -- Floor (Y = -cubeSize.Y/2) - Only if enabled
        local floorPart
        if StateManager.isCubeFloorEnabled then
            floorPart = Instance.new("Part")
            floorPart.Size = Vector3.new(cubeSize.X, wallThickness, cubeSize.Z)
            floorPart.Position = centerPos + Vector3.new(0, -cubeSize.Y / 2 + wallThickness / 2, 0)
            floorPart.Anchored = true
            floorPart.CanCollide = true
            floorPart.Transparency = transparency
            floorPart.BrickColor = brickColor
            floorPart.Parent = cubeModel
        end

        -- Parent the model to Workspace
        cubeModel.Parent = game.Workspace
        print("Cube with separate parts (walls, ceiling, " .. (StateManager.isCubeFloorEnabled and "floor" or "no floor") .. ") spawned at position:", centerPos)

        -- Make the cube follow the player
        if StateManager.cubeConnection then
            StateManager.cubeConnection:Disconnect()
            StateManager.cubeConnection = nil
        end
        StateManager.cubeConnection = RunService.Heartbeat:Connect(function()
            if not StateManager.isCubeSpawned or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                if cubeModel then
                    cubeModel:Destroy()
                end
                if StateManager.cubeConnection then
                    StateManager.cubeConnection:Disconnect()
                    StateManager.cubeConnection = nil
                end
                StateManager.isCubeSpawned = false
                spawnCubeButton.Text = "Spawn Cube: Off"
                return
            end
            -- Update cube size and thickness dynamically in case they change
            cubeSize = Vector3.new(StateManager.cubeSize, StateManager.cubeSize, StateManager.cubeSize)
            wallThickness = StateManager.cubeThickness
            leftWall.Size = Vector3.new(wallThickness, cubeSize.Y, cubeSize.Z)
            rightWall.Size = Vector3.new(wallThickness, cubeSize.Y, cubeSize.Z)
            frontWall.Size = Vector3.new(cubeSize.X, cubeSize.Y, wallThickness)
            backWall.Size = Vector3.new(cubeSize.X, cubeSize.Y, wallThickness)
            ceiling.Size = Vector3.new(cubeSize.X, wallThickness, cubeSize.Z)
            if floorPart then
                floorPart.Size = Vector3.new(cubeSize.X, wallThickness, cubeSize.Z)
            end

            local newPlayerPos = player.Character.HumanoidRootPart.Position
            verticalShift = StateManager.isCubeFloorEnabled and (wallThickness / 2) or 0
            local newCenterPos = newPlayerPos + Vector3.new(0, cubeSize.Y / 2 - playerHeightOffset + verticalShift, 0)
            -- Update positions of all parts relative to the new center, accounting for thickness
            leftWall.Position = newCenterPos + Vector3.new(-cubeSize.X / 2 + wallThickness / 2, 0, 0)
            rightWall.Position = newCenterPos + Vector3.new(cubeSize.X / 2 - wallThickness / 2, 0, 0)
            frontWall.Position = newCenterPos + Vector3.new(0, 0, -cubeSize.Z / 2 + wallThickness / 2)
            backWall.Position = newCenterPos + Vector3.new(0, 0, cubeSize.Z / 2 - wallThickness / 2)
            ceiling.Position = newCenterPos + Vector3.new(0, cubeSize.Y / 2 - wallThickness / 2, 0)
            if floorPart then
                floorPart.Position = newCenterPos + Vector3.new(0, -cubeSize.Y / 2 + wallThickness / 2, 0)
            end
        end)

        notify('Cube', 'Cube with Separate Walls, Ceiling, ' .. (StateManager.isCubeFloorEnabled and 'and Floor ' or 'No Floor ') .. '(Collidable) Spawned and Following')
    else
        if existingCube then
            existingCube:Destroy()
            print("Cube despawned")
        end
        if StateManager.cubeConnection then
            StateManager.cubeConnection:Disconnect()
            StateManager.cubeConnection = nil
        end
        notify('Cube', 'Cube Despawned')
    end
end

function StateManager.toggleGui(frame)
    frame.Visible = not frame.Visible
end

function StateManager.setupCubeSizeSlider(slider, fill, label)
    local dragging = false
    local minSize = 10
    local maxSize = 50
    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.MouseMoved:Connect(function(x, y)
        if dragging then
            local relativeX = x - slider.AbsolutePosition.X
            local fraction = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(fraction, 0, 1, 0)
            -- Map fraction (0 to 1) to cube size (10 to 50)
            StateManager.cubeSize = math.floor(minSize + fraction * (maxSize - minSize))
            label.Text = string.format("Cube Size: %d", StateManager.cubeSize)
        end
    end)
end

function StateManager.setupCubeThicknessSlider(slider, fill, label)
    local dragging = false
    local minThickness = 0.2
    local maxThickness = 25
    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.MouseMoved:Connect(function(x, y)
        if dragging then
            local relativeX = x - slider.AbsolutePosition.X
            local fraction = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(fraction, 0, 1, 0)
            -- Map fraction (0 to 1) to cube thickness (0.2 to 25)
            StateManager.cubeThickness = minThickness + fraction * (maxThickness - minThickness)
            label.Text = string.format("Cube Thickness: %.1f", StateManager.cubeThickness)
        end
    end)
end

-- AudioManager
local AudioManager = {}

AudioManager.deleteSound = Instance.new("Sound")
AudioManager.deleteSound.SoundId = "rbxassetid://4676738150"
AudioManager.deleteSound.Parent = game.Workspace
AudioManager.deleteSound.Volume = 1

AudioManager.restoreSound = Instance.new("Sound")
AudioManager.restoreSound.SoundId = "rbxassetid://773858658"
AudioManager.restoreSound.Parent = game.Workspace
AudioManager.restoreSound.Volume = 1

function AudioManager.setDeleteAudioId(deleteAudioIdTextBox)
    local audioId = deleteAudioIdTextBox.Text:match("%d+")
    if audioId then
        local success, err = pcall(function()
            AudioManager.deleteSound.SoundId = "rbxassetid://" .. audioId
        end)
        if not success then
            warn("Failed to set delete audio ID: " .. tostring(err))
            deleteAudioIdTextBox.Text = AudioManager.deleteSound.SoundId:match("%d+") or ""
        end
    else
        deleteAudioIdTextBox.Text = AudioManager.deleteSound.SoundId:match("%d+") or ""
    end
end

function AudioManager.setRestoreAudioId(restoreAudioIdTextBox)
    local audioId = restoreAudioIdTextBox.Text:match("%d+")
    if audioId then
        local success, err = pcall(function()
            AudioManager.restoreSound.SoundId = "rbxassetid://" .. audioId
        end)
        if not success then
            warn("Failed to set restore audio ID: " .. tostring(err))
            restoreAudioIdTextBox.Text = AudioManager.restoreSound.SoundId:match("%d+") or ""
        end
    else
        restoreAudioIdTextBox.Text = AudioManager.restoreSound.SoundId:match("%d+") or ""
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
    slider.MouseMoved:Connect(function(x, y)
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
local DeleteRestoreManager = {}

DeleteRestoreManager.deletedObjects = {}
DeleteRestoreManager.MAX_TERRAIN_BACKUPS = 5
DeleteRestoreManager.deletedStorage = Instance.new("Folder")
DeleteRestoreManager.deletedStorage.Name = "DeletedObjects"
DeleteRestoreManager.deletedStorage.Parent = game.ReplicatedStorage

DeleteRestoreManager.characterCache = {}

function DeleteRestoreManager.isBodyPartOrCharacter(target, isCharacterProtected)
    if not isCharacterProtected then return false end

    if DeleteRestoreManager.characterCache[target] then return true end

    local bodyPartFilters = {
        "Torso",
        "Head",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg",
        "HumanoidRootPart"
    }

    for _, bodyPart in pairs(bodyPartFilters) do
        if target.Name == bodyPart then
            DeleteRestoreManager.characterCache[target] = true
            return true
        end
    end

    local character = target:FindFirstAncestorOfClass("Model")
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            DeleteRestoreManager.characterCache[target] = true
            return true
        end
    end

    return false
end

function DeleteRestoreManager.getTerrainRegionAroundPoint(position)
    local terrain = game.Workspace.Terrain
    local cellSize = 4
    local regionSize = Vector3.new(32, 32, 32)

    local cellPos = terrain:WorldToCell(position)
    local minCell = cellPos - Vector3.new(regionSize.X / cellSize / 2, regionSize.Y / cellSize / 2, regionSize.Z / cellSize / 2)
    local maxCell = cellPos + Vector3.new(regionSize.X / cellSize / 2, regionSize.Y / cellSize / 2, regionSize.Z / cellSize / 2)

    local minWorld = terrain:CellToWorld(minCell.X, minCell.Y, minCell.Z)
    local maxWorld = terrain:CellToWorld(maxCell.X, maxCell.Y, maxCell.Z)

    return Region3.new(minWorld, maxWorld)
end

function DeleteRestoreManager.checkTerrainAtMousePosition(mouse)
    local terrain = game.Workspace.Terrain
    local hitPosition = mouse.Hit.Position
    local cellPos = terrain:WorldToCell(hitPosition)
    local material = terrain:GetCell(cellPos.X, cellPos.Y, cellPos.Z)
    
    if material ~= Enum.Material.Air then
        return hitPosition
    end
    return nil
end

function DeleteRestoreManager.updateLogbox(logFrame, isAudioEnabled, restoreSound)
    for _, child in ipairs(logFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
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

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 170, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Text = (data.name or "Unnamed") .. (data.object and " (Parent: " .. (data.originalParent and data.originalParent.Name or "None") .. ")" or "")
        nameLabel.Font = Enum.Font.SourceSans
        nameLabel.TextSize = 14
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = entryFrame

        local restoreButton = Instance.new("TextButton")
        restoreButton.Size = UDim2.new(0, 70, 1, 0)
        restoreButton.Position = UDim2.new(1, -70, 0, 0)
        restoreButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        restoreButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
        restoreButton.BorderSizePixel = 1
        restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        restoreButton.Text = "Restore"
        restoreButton.Font = Enum.Font.SourceSansBold
        restoreButton.TextSize = 14
        restoreButton.Parent = entryFrame

        restoreButton.MouseEnter:Connect(function()
            if restoreButton.BackgroundColor3 ~= Color3.fromRGB(200, 0, 0) then
                restoreButton.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
            end
        end)
        restoreButton.MouseLeave:Connect(function()
            if restoreButton.BackgroundColor3 ~= Color3.fromRGB(200, 0, 0) then
                restoreButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        end)

        restoreButton.MouseButton1Click:Connect(function()
            if data.object then
                local object = data.object
                local originalParent = data.originalParent
                local success, err = pcall(function()
                    object.Parent = originalParent
                end)
                if success then
                    table.remove(DeleteRestoreManager.deletedObjects, i)
                    DeleteRestoreManager.updateLogbox(logFrame, isAudioEnabled, restoreSound)
                    if isAudioEnabled then
                        restoreSound:Play()
                    end
                else
                    warn("Failed to restore object: " .. tostring(err))
                end
            elseif data.region then
                local success, err = pcall(function()
                    game.Workspace.Terrain:PasteRegion(data.region, data.position, true)
                end)
                if success then
                    table.remove(DeleteRestoreManager.deletedObjects, i)
                    DeleteRestoreManager.updateLogbox(logFrame, isAudioEnabled, restoreSound)
                    if isAudioEnabled then
                        restoreSound:Play()
                    end
                else
                    warn("Failed to restore terrain: " .. tostring(err))
                end
            end
        end)

        canvasHeight = canvasHeight + 28
    end
    logFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)
end

function DeleteRestoreManager.restoreAllDeleted(isAudioEnabled, restoreSound)
    for i = #DeleteRestoreManager.deletedObjects, 1, -1 do
        local data = DeleteRestoreManager.deletedObjects[i]
        if data.object then
            local object = data.object
            local originalParent = data.originalParent
            local success, err = pcall(function()
                object.Parent = originalParent
                if isAudioEnabled then
                    restoreSound:Play()
                end
            end)
            if not success then
                warn("Failed to restore object: " .. tostring(err))
            end
        elseif data.region then
            local success, err = pcall(function()
                game.Workspace.Terrain:PasteRegion(data.region, data.position, true)
                if isAudioEnabled then
                    restoreSound:Play()
                end
            end)
            if not success then
                warn("Failed to restore terrain: " .. tostring(err))
            end
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
-- Create GUI
print("Creating GUI...")
local guiElements = createGui()
if not guiElements then
    warn("GUI elements could not be loaded (guiElements is nil).")
    return
end
if not guiElements.gui then
    warn("GUI elements loaded, but guiElements.gui is nil.")
    return
end
print("GUI elements created successfully")
print("GUI Enabled:", guiElements.gui.Enabled)
print("Frame Visible:", guiElements.frame.Visible)
print("GUI Parent after creation:", guiElements.gui.Parent and guiElements.gui.Parent:GetFullName() or "nil")

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
local terrainButton = guiElements.terrainButton
local outlineButton = guiElements.outlineButton
local rightClickRestoreButton = guiElements.rightClickRestoreButton
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
local actionKeybindTextBox = guiElements.actionKeybindTextBox
local setActionKeybindButton = guiElements.setActionKeybindButton
local restoreKeybindsButton = guiElements.restoreKeybindsButton
local removeKeybindsButton = guiElements.removeKeybindsButton
local destroyMenuButton = guiElements.destroyMenuButton
local destroyAndRevertButton = guiElements.destroyAndRevertButton
local spawnCubeButton = guiElements.spawnCubeButton
local cubeKeybindTextBox = guiElements.cubeKeybindTextBox
local setCubeKeybindButton = guiElements.setCubeKeybindButton
local cubeSizeLabel = guiElements.cubeSizeLabel
local cubeSizeSlider = guiElements.cubeSizeSlider
local cubeSizeFill = guiElements.cubeSizeFill
local cubeThicknessLabel = guiElements.cubeThicknessLabel
local cubeThicknessSlider = guiElements.cubeThicknessSlider
local cubeThicknessFill = guiElements.cubeThicknessFill
local cubeFloorButton = guiElements.cubeFloorButton

-- Visual feedback (Outline)
local selectionBox = Instance.new("SelectionBox")
selectionBox.Name = "DeleteSelectionBox"
selectionBox.LineThickness = 0.01
selectionBox.Color3 = Color3.fromRGB(255, 0, 0)
selectionBox.Visible = false
selectionBox.Parent = game.Workspace

-- Function to apply hover effect
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
applyHover(toggleButton)
applyHover(protectButton)
applyHover(terrainButton)
applyHover(restoreAllButton)
applyHover(outlineButton)
applyHover(rightClickRestoreButton)
applyHover(audioToggleButton)
applyHover(setDeleteAudioIdButton)
applyHover(setRestoreAudioIdButton)
applyHover(mainTabButton)
applyHover(audioTabButton)
applyHover(settingsTabButton)
applyHover(restoreKeybindsButton)
applyHover(removeKeybindsButton)
applyHover(destroyMenuButton)
applyHover(destroyAndRevertButton)
applyHover(spawnCubeButton)
applyHover(setCubeKeybindButton)
applyHover(cubeFloorButton) -- Apply hover effect to the new button

-- Tab Switching
mainTabButton.MouseButton1Click:Connect(function()
    mainTabFrame.Visible = true
    audioTabFrame.Visible = false
    settingsTabFrame.Visible = false
    mainTabButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    audioTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    settingsTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

audioTabButton.MouseButton1Click:Connect(function()
    mainTabFrame.Visible = false
    audioTabFrame.Visible = true
    settingsTabFrame.Visible = false
    mainTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    audioTabButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    settingsTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

settingsTabButton.MouseButton1Click:Connect(function()
    mainTabFrame.Visible = false
    audioTabFrame.Visible = false
    settingsTabFrame.Visible = true
    mainTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    audioTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    settingsTabButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end)

-- Connect StateManager functions
toggleButton.MouseButton1Click:Connect(function()
    StateManager.toggleDeleteMode(toggleButton)
end)

protectButton.MouseButton1Click:Connect(function()
    StateManager.toggleCharacterProtection(protectButton)
end)

terrainButton.MouseButton1Click:Connect(function()
    StateManager.toggleTerrainDeletion(terrainButton)
end)

outlineButton.MouseButton1Click:Connect(function()
    StateManager.toggleOutline(outlineButton, selectionBox)
end)

rightClickRestoreButton.MouseButton1Click:Connect(function()
    StateManager.toggleRightClickRestore(rightClickRestoreButton)
end)

audioToggleButton.MouseButton1Click:Connect(function()
    StateManager.toggleAudio(audioToggleButton)
end)

spawnCubeButton.MouseButton1Click:Connect(function()
    StateManager.toggleCube(spawnCubeButton)
end)

cubeFloorButton.MouseButton1Click:Connect(function()
    StateManager.toggleCubeFloor(cubeFloorButton)
end)

-- Connect AudioManager functions
setDeleteAudioIdButton.MouseButton1Click:Connect(function()
    AudioManager.setDeleteAudioId(deleteAudioIdTextBox)
end)

setRestoreAudioIdButton.MouseButton1Click:Connect(function()
    AudioManager.setRestoreAudioId(restoreAudioIdTextBox)
end)

AudioManager.setupVolumeSlider(deleteVolumeSlider, deleteVolumeFill, deleteVolumeLabel, AudioManager.deleteSound)
AudioManager.setupVolumeSlider(restoreVolumeSlider, restoreVolumeFill, restoreVolumeLabel, AudioManager.restoreSound)

-- Connect StateManager sliders
StateManager.setupCubeSizeSlider(cubeSizeSlider, cubeSizeFill, cubeSizeLabel)
StateManager.setupCubeThicknessSlider(cubeThicknessSlider, cubeThicknessFill, cubeThicknessLabel)

-- Connect DeleteRestoreManager functions
restoreAllButton.MouseButton1Click:Connect(function()
    DeleteRestoreManager.restoreAllDeleted(StateManager.isAudioEnabled, AudioManager.restoreSound)
    DeleteRestoreManager.updateLogbox(logFrame, StateManager.isAudioEnabled, AudioManager.restoreSound)
end)

destroyMenuButton.MouseButton1Click:Connect(function()
    local existingCube = game.Workspace:FindFirstChild("PlayerCube_" .. player.Name)
    if existingCube then
        existingCube:Destroy()
    end
    if StateManager.cubeConnection then
        StateManager.cubeConnection:Disconnect()
        StateManager.cubeConnection = nil
    end
    gui:Destroy()
    selectionBox:Destroy()
    AudioManager.deleteSound:Destroy()
    AudioManager.restoreSound:Destroy()
    DeleteRestoreManager.deletedStorage:Destroy()
end)

destroyAndRevertButton.MouseButton1Click:Connect(function()
    DeleteRestoreManager.restoreAllDeleted(StateManager.isAudioEnabled, AudioManager.restoreSound)
    local existingCube = game.Workspace:FindFirstChild("PlayerCube_" .. player.Name)
    if existingCube then
        existingCube:Destroy()
    end
    if StateManager.cubeConnection then
        StateManager.cubeConnection:Disconnect()
        StateManager.cubeConnection = nil
    end
    gui:Destroy()
    selectionBox:Destroy()
    AudioManager.deleteSound:Destroy()
    AudioManager.restoreSound:Destroy()
    DeleteRestoreManager.deletedStorage:Destroy()
end)

-- Keybind Management
setToggleKeybindButton.MouseButton1Click:Connect(function()
    local previousKeybind = StateManager.toggleKeybind
    local inputKey = toggleKeybindTextBox.Text:upper():match("^%s*(.-)%s*$")
    if inputKey == "" then
        StateManager.toggleKeybind = nil
        toggleKeybindTextBox.Text = ""
        return
    end

    local keyCode = Enum.KeyCode[inputKey]
    if keyCode and (keyCode ~= StateManager.actionKeybind or StateManager.actionKeybind == nil) and (keyCode ~= StateManager.guiToggleKeybind or StateManager.guiToggleKeybind == nil) then
        StateManager.toggleKeybind = keyCode
        toggleKeybindTextBox.Text = inputKey
    else
        toggleKeybindTextBox.Text = previousKeybind and previousKeybind.Name or ""
    end
end)

setActionKeybindButton.MouseButton1Click:Connect(function()
    local previousKeybind = StateManager.actionKeybind
    local inputKey = actionKeybindTextBox.Text:upper():match("^%s*(.-)%s*$")
    if inputKey == "" then
        StateManager.actionKeybind = nil
        actionKeybindTextBox.Text = ""
        return
    end

    local keyCode = Enum.KeyCode[inputKey]
    if keyCode and (keyCode ~= StateManager.toggleKeybind or StateManager.toggleKeybind == nil) and (keyCode ~= StateManager.guiToggleKeybind or StateManager.guiToggleKeybind == nil) then
        StateManager.actionKeybind = keyCode
        actionKeybindTextBox.Text = inputKey
    else
        actionKeybindTextBox.Text = previousKeybind and previousKeybind.Name or ""
    end
end)

setCubeKeybindButton.MouseButton1Click:Connect(function()
    local previousKeybind = StateManager.cubeKeybind
    local inputKey = cubeKeybindTextBox.Text:upper():match("^%s*(.-)%s*$")
    if inputKey == "" then
        StateManager.cubeKeybind = nil
        cubeKeybindTextBox.Text = ""
        return
    end

    local keyCode = Enum.KeyCode[inputKey]
    if keyCode and (keyCode ~= StateManager.toggleKeybind or StateManager.toggleKeybind == nil) and (keyCode ~= StateManager.actionKeybind or StateManager.actionKeybind == nil) and (keyCode ~= StateManager.guiToggleKeybind or StateManager.guiToggleKeybind == nil) then
        StateManager.cubeKeybind = keyCode
        cubeKeybindTextBox.Text = inputKey
    else
        cubeKeybindTextBox.Text = previousKeybind and previousKeybind.Name or ""
    end
end)

restoreKeybindsButton.MouseButton1Click:Connect(function()
    StateManager.toggleKeybind = Enum.KeyCode.H
    StateManager.actionKeybind = Enum.KeyCode.T
    toggleKeybindTextBox.Text = "H"
    actionKeybindTextBox.Text = "T"
    StateManager.cubeKeybind = Enum.KeyCode.C
    cubeKeybindTextBox.Text = "C"
end)

removeKeybindsButton.MouseButton1Click:Connect(function()
    StateManager.toggleKeybind = nil
    StateManager.actionKeybind = nil
    StateManager.guiToggleKeybind = nil
    toggleKeybindTextBox.Text = ""
    actionKeybindTextBox.Text = ""
    StateManager.cubeKeybind = nil
    cubeKeybindTextBox.Text = ""
end)

-- Detect key presses
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if StateManager.guiToggleKeybind and input.KeyCode == StateManager.guiToggleKeybind then
        StateManager.toggleGui(frame)
    elseif StateManager.toggleKeybind and input.KeyCode == StateManager.toggleKeybind then
        StateManager.toggleDeleteMode(toggleButton)
    elseif StateManager.actionKeybind and input.KeyCode == StateManager.actionKeybind then
        StateManager.isActionKeyHeld = true
    elseif StateManager.cubeKeybind and input.KeyCode == StateManager.cubeKeybind then
        StateManager.toggleCube(spawnCubeButton)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if StateManager.actionKeybind and input.KeyCode == StateManager.actionKeybind then
        StateManager.isActionKeyHeld = false
    end
end)

-- Handle outline
RunService.RenderStepped:Connect(function()
    DeleteRestoreManager.handleOutline(
        mouse,
        selectionBox,
        StateManager.isDeleteModeEnabled,
        StateManager.isActionKeyHeld,
        StateManager.isOutlineEnabled,
        StateManager.isCharacterProtected
    )
end)

-- Handle left-click to delete objects or terrain
local debounce = false
mouse.Button1Down:Connect(function()
    if debounce then return end
    debounce = true

    if not StateManager.isDeleteModeEnabled then
        debounce = false
        return
    end
    if not StateManager.isActionKeyHeld then
        debounce = false
        return
    end

    if StateManager.isTerrainDeletionEnabled then
        local hitPosition = DeleteRestoreManager.checkTerrainAtMousePosition(mouse)
        if hitPosition then
            local terrain = game.Workspace.Terrain
            local region = DeleteRestoreManager.getTerrainRegionAroundPoint(hitPosition)
            
            local regionMin = region.CFrame.Position - region.Size / 2
            local regionCells = terrain:WorldToCell(regionMin)
            local backup = terrain:CopyRegion(region)
            
            table.insert(DeleteRestoreManager.deletedObjects, {
                region = backup,
                position = regionMin,
                name = "Terrain"
            })

            local terrainCount = 0
            for _, data in ipairs(DeleteRestoreManager.deletedObjects) do
                if data.region then terrainCount = terrainCount + 1 end
            end
            while terrainCount > DeleteRestoreManager.MAX_TERRAIN_BACKUPS do
                for i, data in ipairs(DeleteRestoreManager.deletedObjects) do
                    if data.region then
                        table.remove(DeleteRestoreManager.deletedObjects, i)
                        terrainCount = terrainCount - 1
                        break
                    end
                end
            end

            local success, err = pcall(function()
                terrain:FillRegion(region, 4, Enum.Material.Air)
                if StateManager.isAudioEnabled then
                    AudioManager.deleteSound:Play()
                end
            end)
            if success then
                DeleteRestoreManager.updateLogbox(logFrame, StateManager.isAudioEnabled, AudioManager.restoreSound)
            else
                warn("Failed to clear terrain: " .. tostring(err))
            end
            debounce = false
            return
        end
    end

    local target = mouse.Target
    if not target or target:IsA("Terrain") then
        debounce = false
        return
    end

    if DeleteRestoreManager.isBodyPartOrCharacter(target, StateManager.isCharacterProtected) then
        debounce = false
        return
    end

    local targetName = target.Name
    table.insert(DeleteRestoreManager.deletedObjects, {
        object = target,
        originalParent = target.Parent,
        name = targetName
    })

    local success, err = pcall(function()
        target.Parent = DeleteRestoreManager.deletedStorage
        if StateManager.isAudioEnabled then
            AudioManager.deleteSound:Play()
        end
    end)
    if success then
        DeleteRestoreManager.updateLogbox(logFrame, StateManager.isAudioEnabled, AudioManager.restoreSound)
    else
        warn("Failed to delete object: " .. tostring(err))
    end

    task.wait(0.1)
    debounce = false
end)

-- Handle right-click to restore objects
mouse.Button2Down:Connect(function()
    if not StateManager.isActionKeyHeld then return end
    if not StateManager.isRightClickRestoreEnabled then return end
    if #DeleteRestoreManager.deletedObjects == 0 then return end

    local data = table.remove(DeleteRestoreManager.deletedObjects)
    if data.object then
        local object = data.object
        local originalParent = data.originalParent
        local success, err = pcall(function()
            object.Parent = originalParent
            if StateManager.isAudioEnabled then
                AudioManager.restoreSound:Play()
            end
        end)
        if success then
            DeleteRestoreManager.updateLogbox(logFrame, StateManager.isAudioEnabled, AudioManager.restoreSound)
        else
            warn("Failed to restore object: " .. tostring(err))
        end
    elseif data.region then
        local success, err = pcall(function()
            game.Workspace.Terrain:PasteRegion(data.region, data.position, true)
            if StateManager.isAudioEnabled then
                AudioManager.restoreSound:Play()
            end
        end)
        if success then
            DeleteRestoreManager.updateLogbox(logFrame, StateManager.isAudioEnabled, AudioManager.restoreSound)
        else
            warn("Failed to restore terrain: " .. tostring(err))
        end
    end
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(character)
    print("Character respawned:", character.Name)
    DeleteRestoreManager.characterCache = {} -- Clear cache on respawn
    -- If cube is active, ensure it continues to follow the new character
    if StateManager.isCubeSpawned then
        StateManager.toggleCube(spawnCubeButton) -- Turn off
        StateManager.toggleCube(spawnCubeButton) -- Turn back on to reset with new character
    end
end)
