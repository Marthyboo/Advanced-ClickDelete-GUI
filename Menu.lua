-- Services
local Players = game:GetService("Players")

-- Player setup
local player = Players.LocalPlayer

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
    return nil
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
    protectButton.Font = Enum.Font.SourceSans
    protectButton.TextSize = 16
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
    restoreAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    restoreAudioIdLabel.Position = UDim2.new(0, 0 purchasers = Instance.new("TextBox")
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
    restoreKeybindsButton.Position = UDim2.new(0, 0, 0, 275)
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
    removeKeybindsButton.Position = UDim2.new(0, 0, 0, 310)
    removeKeybindsButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    removeKeybindsButton.BorderColor3 = Color3.fromRGB(100, 0, 0)
    removeKeybindsButton.BorderSizePixel = 1
    removeKeybindsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    removeKeybindsButton.Text = "Remove Every Keybind"
    removeKeybindsButton.Font = Enum.Font.SourceSans
    removeKeybindsButton.TextSize = 16
    removeKeybindsButton.Parent = settingsTabFrame

    local destroyMenuButton = Instance.new("TextButton")
    destroyMenuButton.Size = UDim2.new(0, 130, 0, 30)
    destroyMenuButton.Position = UDim2.new(0, 0, 0, 345)
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
    destroyAndRevertButton.Position = UDim2.new(0, 140, 0, 345)
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
        cubeFloorButton = cubeFloorButton
    }
end

-- Return the createGui function result
return createGui()
