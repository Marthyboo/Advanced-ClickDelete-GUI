local new = Instance.new
local rgb = Color3.fromRGB
local ud = UDim2.new

-- Services
local UIS = game:GetService("UserInputService")
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

-- Default UI properties
local defaultButtonProps = {
    BackgroundColor3 = rgb(30, 30, 30),
    BorderColor3 = rgb(100, 0, 0),
    BorderSizePixel = 1,
    TextColor3 = rgb(255, 255, 255),
    Font = Enum.Font.SourceSans,
    TextSize = 16
}
local defaultLabelProps = {
    BackgroundTransparency = 1,
    TextColor3 = rgb(255, 255, 255),
    Font = Enum.Font.SourceSans,
    TextSize = 14
}

-- Helper Functions for UI Creation
local function createButton(parent, size, position, text, extraProps)
    local button = new("TextButton")
    button.Size = size
    button.Position = position
    button.Text = text
    button.Parent = parent
    for key, value in pairs(defaultButtonProps) do
        button[key] = value
    end
    for key, value in pairs(extraProps or {}) do
        button[key] = value
    end
    return button
end

local function createLabel(parent, size, position, text, extraProps)
    local label = new("TextLabel")
    label.Size = size
    label.Position = position
    label.Text = text
    label.Parent = parent
    for key, value in pairs(defaultLabelProps) do
        label[key] = value
    end
    for key, value in pairs(extraProps or {}) do
        label[key] = value
    end
    return label
end

-- GUI Creation Function
local function createGui()
    print("Starting createGui")
    local gui = new("ScreenGui")
    gui.Name = "DeleteGui"
    gui.ResetOnSpawn = false
    gui.Enabled = true
    gui.IgnoreGuiInset = true
    print("GUI Created - Enabled:", gui.Enabled)

    local frame = new("Frame")
    frame.Size = ud(0, 300, 0, 400)
    frame.Position = ud(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = rgb(20, 20, 20)
    frame.BorderColor3 = rgb(150, 0, 0)
    frame.BorderSizePixel = 2
    frame.Active = true
    frame.Draggable = true
    frame.Visible = true
    frame.Parent = gui
    print("Frame Created - Visible:", frame.Visible)

    local framePadding = new("UIPadding")
    framePadding.PaddingTop = UDim.new(0, 5)
    framePadding.PaddingBottom = UDim.new(0, 5)
    framePadding.PaddingLeft = UDim.new(0, 5)
    framePadding.PaddingRight = UDim.new(0, 5)
    framePadding.Parent = frame

    local title = createLabel(frame, ud(1, -10, 0, 30), ud(0, 5, 0, 5), "Delete Tool", {
        BackgroundTransparency = 0,
        BackgroundColor3 = rgb(200, 0, 0),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18
    })

    -- Tab Buttons
    local tabButtons = {
        { name = "Main", pos = ud(0, 5, 0, 40), props = { BackgroundColor3 = rgb(200, 0, 0), Font = Enum.Font.SourceSansBold } },
        { name = "Audio", pos = ud(0, 95, 0, 40), props = { Font = Enum.Font.SourceSansBold } },
        { name = "Settings", pos = ud(0, 185, 0, 40), props = { Font = Enum.Font.SourceSansBold } }
    }
    local tabButtonInstances = {}
    for i, tab in ipairs(tabButtons) do
        tabButtonInstances[i] = createButton(frame, ud(0, 90, 0, 25), tab.pos, tab.name, tab.props)
    end
    local mainTabButton, audioTabButton, settingsTabButton = tabButtonInstances[1], tabButtonInstances[2], tabButtonInstances[3]

    -- Tab Frames
    local tabFrameProps = { Size = ud(1, -10, 0, 280), Position = ud(0, 5, 0, 70), BackgroundTransparency = 1 }
    local mainTabFrame = new("Frame")
    mainTabFrame.Visible = true
    mainTabFrame.Parent = frame
    local audioTabFrame = new("Frame")
    audioTabFrame.Visible = false
    audioTabFrame.Parent = frame
    local settingsTabFrame = new("Frame")
    settingsTabFrame.Visible = false
    settingsTabFrame.Parent = frame
    for key, value in pairs(tabFrameProps) do
        mainTabFrame[key] = value
        audioTabFrame[key] = value
        settingsTabFrame[key] = value
    end

    -- Settings Tab Layout
    print("Creating settingsTabFrame UIListLayout")
    local settingsLayout = new("UIListLayout")
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.Padding = UDim.new(0, 3)
    settingsLayout.Parent = settingsTabFrame

    -- Main Tab Contents
    local mainButtons = {
        { name = "toggleButton", text = "Delete Mode: Off", size = ud(0, 130, 0, 30), pos = ud(0, 0, 0, 0) },
        { name = "protectButton", text = "Protect Character: Off", size = ud(0, 130, 0, 30), pos = ud(0, 140, 0, 0) },
        { name = "terrainButton", text = "Terrain Deletion: Off", size = ud(0, 130, 0, 30), pos = ud(0, 0, 0, 35) },
        { name = "outlineButton", text = "Outline: On", size = ud(0, 130, 0, 30), pos = ud(0, 140, 0, 35) },
        { name = "rightClickRestoreButton", text = "Right-Click Restore: On", size = ud(0, 130, 0, 30), pos = ud(0, 0, 0, 70) },
        { name = "spawnCubeButton", text = "Spawn Cube: Off", size = ud(0, 130, 0, 30), pos = ud(0, 140, 0, 70) },
        { name = "restoreAllButton", text = "Restore All", size = ud(1, 0, 0, 30), pos = ud(0, 0, 0, 105) }
    }
    local mainButtonInstances = {}
    for _, btn in ipairs(mainButtons) do
        mainButtonInstances[btn.name] = createButton(mainTabFrame, btn.size, btn.pos, btn.text)
    end

    local logFrame = new("ScrollingFrame")
    logFrame.Size = ud(1, 0, 0, 140)
    logFrame.Position = ud(0, 0, 0, 140)
    logFrame.BackgroundColor3 = rgb(30, 30, 30)
    logFrame.BorderColor3 = rgb(100, 0, 0)
    logFrame.BorderSizePixel = 1
    logFrame.CanvasSize = ud(0, 0, 0, 0)
    logFrame.ScrollBarThickness = 6
    logFrame.Parent = mainTabFrame

    local logLayout = new("UIListLayout")
    logLayout.SortOrder = Enum.SortOrder.LayoutOrder
    logLayout.Padding = UDim.new(0, 3)
    logLayout.Parent = logFrame

    -- Audio Tab Contents
    local audioToggleButton = createButton(audioTabFrame, ud(0, 130, 0, 30), ud(0, 0, 0, 0), "Audio: On")
    local deleteAudioIdLabel = createLabel(audioTabFrame, ud(1, 0, 0, 20), ud(0, 0, 0, 35), "Delete Audio ID:", {
        TextColor3 = rgb(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    local deleteAudioIdFrame = new("Frame")
    deleteAudioIdFrame.Size = ud(1, 0, 0, 25)
    deleteAudioIdFrame.Position = ud(0, 0, 0, 55)
    deleteAudioIdFrame.BackgroundTransparency = 1
    deleteAudioIdFrame.Parent = audioTabFrame

    local deleteAudioIdTextBox = new("TextBox")
    deleteAudioIdTextBox.Size = ud(0, 210, 0, 25)
    deleteAudioIdTextBox.Position = ud(0, 0, 0, 0)
    deleteAudioIdTextBox.BackgroundColor3 = rgb(50, 50, 50)
    deleteAudioIdTextBox.BorderColor3 = rgb(100, 0, 0)
    deleteAudioIdTextBox.BorderSizePixel = 1
    deleteAudioIdTextBox.TextColor3 = rgb(255, 255, 255)
    deleteAudioIdTextBox.PlaceholderText = "e.g., 4676738150"
    deleteAudioIdTextBox.Text = "4676738150"
    deleteAudioIdTextBox.Font = Enum.Font.SourceSans
    deleteAudioIdTextBox.TextSize = 14
    deleteAudioIdTextBox.Parent = deleteAudioIdFrame

    local setDeleteAudioIdButton = createButton(deleteAudioIdFrame, ud(0, 50, 0, 25), ud(0, 215, 0, 0), "Set", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    local restoreAudioIdLabel = createLabel(audioTabFrame, ud(1, 0, 0, 20), ud(0, 0, 0, 85), "Restore Audio ID:", {
        TextColor3 = rgb(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    local restoreAudioIdFrame = new("Frame")
    restoreAudioIdFrame.Size = ud(1, 0, 0, 25)
    restoreAudioIdFrame.Position = ud(0, 0, 0, 105)
    restoreAudioIdFrame.BackgroundTransparency = 1
    restoreAudioIdFrame.Parent = audioTabFrame

    local restoreAudioIdTextBox = new("TextBox")
    restoreAudioIdTextBox.Size = ud(0, 210, 0, 25)
    restoreAudioIdTextBox.Position = ud(0, 0, 0, 0)
    restoreAudioIdTextBox.BackgroundColor3 = rgb(50, 50, 50)
    restoreAudioIdTextBox.BorderColor3 = rgb(100, 0, 0)
    restoreAudioIdTextBox.BorderSizePixel = 1
    restoreAudioIdTextBox.TextColor3 = rgb(255, 250, 255)
    restoreAudioIdTextBox.PlaceholderText = "e.g., 773858658"
    restoreAudioIdTextBox.Text = "773858658"
    restoreAudioIdTextBox.Font = Enum.Font.SourceSans
    restoreAudioIdTextBox.TextSize = 14
    restoreAudioIdTextBox.Parent = restoreAudioIdFrame

    local setRestoreAudioIdButton = createButton(restoreAudioIdFrame, ud(0, 50, 0, 25), ud(0, 215, 0, 0), "Set", {
        Font = Enum.Font.SourceSansBold,
        TextSize = 14
    })

    local deleteVolumeLabel = createLabel(audioTabFrame, ud(1, 0, 0, 20), ud(0, 0, 0, 135), "Delete Volume: 1.0", {
        TextColor3 = rgb(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    local deleteVolumeSlider = createButton(audioTabFrame, ud(1, 0, 0, 20), ud(0, 0, 0, 155), "", {
        BackgroundColor3 = rgb(50, 50, 50)
    })

    local deleteVolumeFill = new("Frame")
    deleteVolumeFill.Size = ud(1, 0, 1, 0)
    deleteVolumeFill.BackgroundColor3 = rgb(200, 0, 0)
    deleteVolumeFill.BorderSizePixel = 0
    deleteVolumeFill.Parent = deleteVolumeSlider

    local restoreVolumeLabel = createLabel(audioTabFrame, ud(1, 0, 0, 20), ud(0, 0, 0, 180), "Restore Volume: 1.0", {
        TextColor3 = rgb(200, 200, 200),
        Font = Enum.Font.SourceSansBold
    })

    local restoreVolumeSlider = createButton(audioTabFrame, ud(1, 0, 0, 20), ud(0, 0, 0, 200), "", {
        BackgroundColor3 = rgb(50, 50, 50)
    })

    local restoreVolumeFill = new("Frame")
    restoreVolumeFill.Size = ud(1, 0, 1, 0)
    restoreVolumeFill.BackgroundColor3 = rgb(200, 0, 0)
    restoreVolumeFill.BorderSizePixel = 0
    restoreVolumeFill.Parent = restoreVolumeSlider

    -- Settings Tab Contents
    print("Creating toggleKeybindFrame")
    local keybindFrames = {
        { name = "toggle", labelText = "Toggle Keybind:", placeholder = "e.g., H, G", defaultText = "H", stateKey = "toggleKeybind" },
        { name = "action", labelText = "Action Keybind:", placeholder = "e.g., T, R", defaultText = "T", stateKey = "actionKeybind" },
        { name = "cube", labelText = "Cube Keybind:", placeholder = "e.g., C, V", defaultText = "C", stateKey = "cubeKeybind" }
    }
    local keybindElements = {}
    for i, kf in ipairs(keybindFrames) do
        local frame = new("Frame")
        frame.Size = ud(1, 0, 0, 25)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = i
        frame.Parent = settingsTabFrame

        local label = createLabel(frame, ud(0, 110, 0, 25), ud(0, 0, 0, 0), kf.labelText, {
            TextColor3 = rgb(200, 200, 200),
            Font = Enum.Font.SourceSansBold
        })

        local textBox = new("TextBox")
        textBox.Size = ud(0, 50, 0, 25)
        textBox.Position = ud(0, 115, 0, 0)
        textBox.BackgroundColor3 = rgb(50, 50, 50)
        textBox.BorderColor3 = rgb(100, 0, 0)
        textBox.BorderSizePixel = 1
        textBox.TextColor3 = rgb(255, 255, 255)
        textBox.PlaceholderText = kf.placeholder
        textBox.Text = kf.defaultText
        textBox.Font = Enum.Font.SourceSans
        textBox.TextSize = 14
        textBox.Parent = frame

        local button = createButton(frame, ud(0, 50, 0, 25), ud(0, 170, 0, 0), "Set", {
            Font = Enum.Font.SourceSansBold,
            TextSize = 14
        })

        keybindElements[kf.name] = { frame = frame, label = label, textBox = textBox, button = button }
    end

    local sliders = {
        { labelText = "Cube Size: 25", stateKey = "cubeSize", minVal = 10, maxVal = 50, format = "Cube Size: %d", fillSize = ud(0.5, 0, 1, 0), layoutOrder = 4 },
        { labelText = "Cube Thickness: 1.0", stateKey = "cubeThickness", minVal = 0.2, maxVal = 25, format = "Cube Thickness: %.1f", fillSize = ud(0.032, 0, 1, 0), layoutOrder = 6 },
        { labelText = "Cube Transparency: 0.7", stateKey = "cubeTransparency", minVal = 0, maxVal = 1, format = "Cube Transparency: %.1f", fillSize = ud(0.7, 0, 1, 0), layoutOrder = 8 }
    }
    local sliderElements = {}
    for _, sl in ipairs(sliders) do
        local label = createLabel(settingsTabFrame, ud(1, 0, 0, 20), ud(), sl.labelText, {
            TextColor3 = rgb(200, 200, 200),
            Font = Enum.Font.SourceSansBold,
            LayoutOrder = sl.layoutOrder
        })
        local slider = createButton(settingsTabFrame, ud(1, 0, 0, 20), ud(), "", {
            BackgroundColor3 = rgb(50, 50, 50),
            LayoutOrder = sl.layoutOrder + 1
        })
        local fill = new("Frame")
        fill.Size = sl.fillSize
        fill.BackgroundColor3 = rgb(200, 0, 0)
        fill.BorderSizePixel = 0
        fill.Parent = slider
        sliderElements[sl.stateKey] = { label = label, slider = slider, fill = fill, minVal = sl.minVal, maxVal = sl.maxVal, format = sl.format }
    end

    local cubeFloorDestroyFrame = new("Frame")
    cubeFloorDestroyFrame.Size = ud(1, 0, 0, 30)
    cubeFloorDestroyFrame.BackgroundTransparency = 1
    cubeFloorDestroyFrame.LayoutOrder = 10
    cubeFloorDestroyFrame.Parent = settingsTabFrame

    local cubeFloorButton = createButton(cubeFloorDestroyFrame, ud(0, 130, 0, 30), ud(0, 0, 0, 0), "Cube Floor: Off")
    local destroyMenuButton = createButton(cubeFloorDestroyFrame, ud(0, 130, 0, 30), ud(0, 135, 0, 0), "Destroy Menu")

    local restoreDestroyRevertFrame = new("Frame")
    restoreDestroyRevertFrame.Size = ud(1, 0, 0, 30)
    restoreDestroyRevertFrame.BackgroundTransparency = 1
    restoreDestroyRevertFrame.LayoutOrder = 11
    restoreDestroyRevertFrame.Parent = settingsTabFrame

    local restoreKeybindsButton = createButton(restoreDestroyRevertFrame, ud(0, 130, 0, 30), ud(0, 0, 0, 0), "Restore All Keybinds")
    local destroyAndRevertButton = createButton(restoreDestroyRevertFrame, ud(0, 130, 0, 30), ud(0, 135, 0, 0), "Destroy & Revert")

    local removeKeybindsButton = createButton(settingsTabFrame, ud(0, 130, 0, 30), ud(), "Remove Every Keybind", {
        LayoutOrder = 12
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
        toggleButton = mainButtonInstances.toggleButton,
        protectButton = mainButtonInstances.protectButton,
        terrainButton = mainButtonInstances.terrainButton,
        outlineButton = mainButtonInstances.outlineButton,
        rightClickRestoreButton = mainButtonInstances.rightClickRestoreButton,
        restoreAllButton = mainButtonInstances.restoreAllButton,
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
        toggleKeybindTextBox = keybindElements.toggle.textBox,
        setToggleKeybindButton = keybindElements.toggle.button,
        actionKeybindTextBox = keybindElements.action.textBox,
        setActionKeybindButton = keybindElements.action.button,
        restoreKeybindsButton = restoreKeybindsButton,
        removeKeybindsButton = removeKeybindsButton,
        destroyMenuButton = destroyMenuButton,
        destroyAndRevertButton = destroyAndRevertButton,
        spawnCubeButton = mainButtonInstances.spawnCubeButton,
        cubeKeybindTextBox = keybindElements.cube.textBox,
        setCubeKeybindButton = keybindElements.cube.button,
        cubeSizeLabel = sliderElements.cubeSize.label,
        cubeSizeSlider = sliderElements.cubeSize.slider,
        cubeSizeFill = sliderElements.cubeSize.fill,
        cubeThicknessLabel = sliderElements.cubeThickness.label,
        cubeThicknessSlider = sliderElements.cubeThickness.slider,
        cubeThicknessFill = sliderElements.cubeThickness.fill,
        cubeFloorButton = cubeFloorButton,
        cubeTransparencyLabel = sliderElements.cubeTransparency.label,
        cubeTransparencySlider = sliderElements.cubeTransparency.slider,
        cubeTransparencyFill = sliderElements.cubeTransparency.fill
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
    cubeConnection = nil,
    cubeSize = 25,
    cubeThickness = 1,
    cubeTransparency = 0.7,
    isCubeFloorEnabled = false,
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
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.MouseMoved:Connect(function(x)
        if dragging then
            local relativeX = x - slider.AbsolutePosition.X
            local fraction = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            fill.Size = ud(fraction, 0, 1, 0)
            StateManager[stateKey] = minVal + fraction * (maxVal - minVal)
            label.Text = string.format(formatStr, StateManager[stateKey])
        end
    end)
end

local function createCubePart(size, position, parent, props)
    local part = new("Part")
    part.Size = size
    part.Position = position
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = props.transparency
    part.BrickColor = props.brickColor
    part.Parent = parent
    return part
end

function StateManager.toggleCube(spawnCubeButton)
    StateManager.toggleState(spawnCubeButton, "isCubeSpawned", "Spawn Cube: ", function()
        local cubeName = "PlayerCube_" .. player.Name
        local existingCube = game.Workspace:FindFirstChild(cubeName)
        if StateManager.isCubeSpawned then
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                print("Character or HumanoidRootPart not found, cannot spawn cube")
                StateManager.isCubeSpawned = false
                spawnCubeButton.Text = "Spawn Cube: Off"
                return
            end
            if existingCube then existingCube:Destroy() end

            local cubeModel = new("Model")
            cubeModel.Name = cubeName
            local cubeSize = Vector3.new(StateManager.cubeSize, StateManager.cubeSize, StateManager.cubeSize)
            local wallThickness = StateManager.cubeThickness
            local cubeConfig = {
                props = { transparency = StateManager.cubeTransparency, brickColor = BrickColor.new("Really red") },
                parts = {
                    { name = "leftWall", size = Vector3.new(wallThickness, cubeSize.Y, cubeSize.Z), offset = Vector3.new(-cubeSize.X / 2 + wallThickness / 2, 0, 0) },
                    { name = "rightWall", size = Vector3.new(wallThickness, cubeSize.Y, cubeSize.Z), offset = Vector3.new(cubeSize.X / 2 - wallThickness / 2, 0, 0) },
                    { name = "frontWall", size = Vector3.new(cubeSize.X, cubeSize.Y, wallThickness), offset = Vector3.new(0, 0, -cubeSize.Z / 2 + wallThickness / 2) },
                    { name = "backWall", size = Vector3.new(cubeSize.X, cubeSize.Y, wallThickness), offset = Vector3.new(0, 0, cubeSize.Z / 2 - wallThickness / 2) },
                    { name = "ceiling", size = Vector3.new(cubeSize.X, wallThickness, cubeSize.Z), offset = Vector3.new(0, cubeSize.Y / 2 - wallThickness / 2, 0) }
                }
            }
            if StateManager.isCubeFloorEnabled then
                table.insert(cubeConfig.parts, {
                    name = "floor",
                    size = Vector3.new(cubeSize.X, wallThickness, cubeSize.Z),
                    offset = Vector3.new(0, -cubeSize.Y / 2 - 3 + wallThickness, 0)
                })
            end

            local parts = {}
            local playerPos = player.Character.HumanoidRootPart.Position
            local playerHeightOffset = 2.5
            local centerPos = playerPos + Vector3.new(0, cubeSize.Y / 2 - playerHeightOffset, 0)

            for _, partConfig in ipairs(cubeConfig.parts) do
                parts[partConfig.name] = createCubePart(partConfig.size, centerPos + partConfig.offset, cubeModel, cubeConfig.props)
            end

            cubeModel.Parent = game.Workspace
            print("Cube spawned at:", centerPos)

            if StateManager.cubeConnection then
                StateManager.cubeConnection:Disconnect()
            end
            StateManager.cubeConnection = RunService.Heartbeat:Connect(function()
                if not StateManager.isCubeSpawned or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    if cubeModel then cubeModel:Destroy() end
                    if StateManager.cubeConnection then
                        StateManager.cubeConnection:Disconnect()
                        StateManager.cubeConnection = nil
                    end
                    StateManager.isCubeSpawned = false
                    spawnCubeButton.Text = "Spawn Cube: Off"
                    return
                end
                local newCubeSize = Vector3.new(StateManager.cubeSize, StateManager.cubeSize, StateManager.cubeSize)
                local newWallThickness = StateManager.cubeThickness
                local newTransparency = StateManager.cubeTransparency
                local newPos = player.Character.HumanoidRootPart.Position
                local newCenterPos = newPos + Vector3.new(0, newCubeSize.Y / 2 - playerHeightOffset, 0)

                for _, partConfig in ipairs(cubeConfig.parts) do
                    local part = parts[partConfig.name]
                    if part then
                        local size = partConfig.size
                        local offset = partConfig.offset
                        if partConfig.name == "leftWall" or partConfig.name == "rightWall" then
                            size = Vector3.new(newWallThickness, newCubeSize.Y, newCubeSize.Z)
                            offset = partConfig.name == "leftWall" and Vector3.new(-newCubeSize.X / 2 + newWallThickness / 2, 0, 0) or
                                     Vector3.new(newCubeSize.X / 2 - newWallThickness / 2, 0, 0)
                        elseif partConfig.name == "frontWall" or partConfig.name == "backWall" then
                            size = Vector3.new(newCubeSize.X, newCubeSize.Y, newWallThickness)
                            offset = partConfig.name == "frontWall" and Vector3.new(0, 0, -newCubeSize.Z / 2 + newWallThickness / 2) or
                                     Vector3.new(0, 0, newCubeSize.Z / 2 - newWallThickness / 2)
                        elseif partConfig.name == "ceiling" then
                            size = Vector3.new(newCubeSize.X, newWallThickness, newCubeSize.Z)
                            offset = Vector3.new(0, newCubeSize.Y / 2 - newWallThickness / 2, 0)
                        elseif partConfig.name == "floor" then
                            size = Vector3.new(newCubeSize.X, newWallThickness, newCubeSize.Z)
                            offset = Vector3.new(0, -newCubeSize.Y / 2 - 3 + newWallThickness, 0)
                        end
                        part.Size = size
                        part.Position = newCenterPos + offset
                        part.Transparency = newTransparency
                    end
                end
            end)

            notify('Cube', 'Cube with Separate Walls, Ceiling, ' .. (StateManager.isCubeFloorEnabled and 'and Floor ' or 'No Floor ') .. 'Spawned')
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
    end)
end

-- AudioManager
local AudioManager = {
    deleteSound = new("Sound", game.Workspace),
    restoreSound = new("Sound", game.Workspace)
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
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.MouseMoved:Connect(function(x)
        if dragging then
            local relativeX = x - slider.AbsolutePosition.X
            local fraction = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            fill.Size = ud(fraction, 0, 1, 0)
            sound.Volume = fraction
            label.Text = string.format("%s Volume: %.1f", label.Text:match("^(.-) Volume"), fraction)
        end
    end)
end

-- DeleteRestoreManager
local DeleteRestoreManager = {
    deletedObjects = {},
    MAX_TERRAIN_BACKUPS = 5,
    deletedStorage = new("Folder", game.ReplicatedStorage),
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

function DeleteRestoreManager.getTerrainRegion(position)
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

function DeleteRestoreManager.checkTerrain(mouse)
    local terrain = game.Workspace.Terrain
    local hitPosition = mouse.Hit.Position
    local cellPos = terrain:WorldToCell(hitPosition)
    if terrain:GetCell(cellPos.X, cellPos.Y, cellPos.Z) ~= Enum.Material.Air then
        return hitPosition
    end
    return nil
end

function DeleteRestoreManager.updateLogbox(logFrame, isAudioEnabled, restoreSound)
    for _, child in ipairs(logFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local canvasHeight = 0
    local maxDisplay = 50
    for i, data in ipairs(DeleteRestoreManager.deletedObjects) do
        if i > maxDisplay then break end
        local entryFrame = new("Frame")
        entryFrame.Size = ud(1, -10, 0, 25)
        entryFrame.BackgroundTransparency = 1
        entryFrame.LayoutOrder = i
        entryFrame.Parent = logFrame

        createLabel(entryFrame, ud(0, 170, 1, 0), ud(0, 0, 0, 0),
            (data.name or "Unnamed") .. (data.object and " (Parent: " .. (data.originalParent and data.originalParent.Name or "None") .. ")" or ""))

        local restoreButton = createButton(entryFrame, ud(0, 70, 1, 0), ud(1, -70, 0, 0), "Restore", {
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
            elseif data.region then
                local success, err = pcall(function()
                    game.Workspace.Terrain:PasteRegion(data.region, data.position, true)
                end)
                if success then
                    table.remove(DeleteRestoreManager.deletedObjects, i)
                    DeleteRestoreManager.updateLogbox(logFrame, isAudioEnabled, restoreSound)
                    if isAudioEnabled then restoreSound:Play() end
                else
                    warn("Failed to restore terrain: " .. tostring(err))
                end
            end
        end)

        canvasHeight = canvasHeight + 28
    end
    logFrame.CanvasSize = ud(0, 0, 0, canvasHeight)
end

function DeleteRestoreManager.restoreAll(isAudioEnabled, restoreSound)
    for i = #DeleteRestoreManager.deletedObjects, 1, -1 do
        local data = DeleteRestoreManager.deletedObjects[i]
        local success, err = pcall(function()
            if data.object then
                data.object.Parent = data.originalParent
            elseif data.region then
                game.Workspace.Terrain:PasteRegion(data.region, data.position, true)
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
local cubeTransparencyLabel = guiElements.cubeTransparencyLabel
local cubeTransparencySlider = guiElements.cubeTransparencySlider
local cubeTransparencyFill = guiElements.cubeTransparencyFill

-- Visual feedback
local selectionBox = new("SelectionBox", game.Workspace)
selectionBox.Name = "DeleteSelectionBox"
selectionBox.LineThickness = 0.01
selectionBox.Color3 = rgb(255, 0, 0)
selectionBox.Visible = false

-- Hover effect
local function applyHover(button)
    button.MouseEnter:Connect(function()
        if button.BackgroundColor3 ~= rgb(200, 0, 0) then
            button.BackgroundColor3 = rgb(220, 0, 0)
        end
    end)
    button.MouseLeave:Connect(function()
        if button.BackgroundColor3 ~= rgb(200, 0, 0) then
            button.BackgroundColor3 = rgb(30, 30, 30)
        end
    end)
end
for _, btn in ipairs({
    toggleButton, protectButton, terrainButton, outlineButton, rightClickRestoreButton, spawnCubeButton,
    restoreAllButton, audioToggleButton, setDeleteAudioIdButton, setRestoreAudioIdButton,
    mainTabButton, audioTabButton, settingsTabButton, restoreKeybindsButton, removeKeybindsButton,
    destroyMenuButton, destroyAndRevertButton, setToggleKeybindButton, setActionKeybindButton,
    setCubeKeybindButton, cubeFloorButton
}) do
    applyHover(btn)
end

-- Tab Switching
local function switchTab(activeButton, activeFrame)
    mainTabFrame.Visible = activeFrame == mainTabFrame
    audioTabFrame.Visible = activeFrame == audioTabFrame
    settingsTabFrame.Visible = activeFrame == settingsTabFrame
    mainTabButton.BackgroundColor3 = activeButton == mainTabButton and rgb(200, 0, 0) or rgb(30, 30, 30)
    audioTabButton.BackgroundColor3 = activeButton == audioTabButton and rgb(200, 0, 0) or rgb(30, 30, 30)
    settingsTabButton.BackgroundColor3 = activeButton == settingsTabButton and rgb(200, 0, 0) or rgb(30, 30, 30)
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

terrainButton.MouseButton1Click:Connect(function()
    StateManager.toggleState(terrainButton, "isTerrainDeletionEnabled", "Terrain Deletion: ")
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

spawnCubeButton.MouseButton1Click:Connect(function()
    StateManager.toggleCube(spawnCubeButton)
end)

cubeFloorButton.MouseButton1Click:Connect(function()
    StateManager.toggleState(cubeFloorButton, "isCubeFloorEnabled", "Cube Floor: ", function()
        if StateManager.isCubeSpawned then
            StateManager.toggleCube(spawnCubeButton)
            StateManager.toggleCube(spawnCubeButton)
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
for _, sl in pairs(sliderElements) do
    StateManager.setupSlider(sl.slider, sl.fill, sl.label, sl.stateKey, sl.minVal, sl.maxVal, sl.format)
end

-- DeleteRestoreManager Connections
restoreAllButton.MouseButton1Click:Connect(function()
    DeleteRestoreManager.restoreAll(StateManager.isAudioEnabled, AudioManager.restoreSound)
    DeleteRestoreManager.updateLogbox(logFrame, StateManager.isAudioEnabled, AudioManager.restoreSound)
end)

local function cleanup()
    local cube = game.Workspace:FindFirstChild("PlayerCube_" .. player.Name)
    if cube then cube:Destroy() end
    if StateManager.cubeConnection then
        StateManager.cubeConnection:Disconnect()
        StateManager.cubeConnection = nil
    end
    for _, connection in ipairs(StateManager.connections) do
        connection:Disconnect()
    end
    StateManager.connections = {}
    StateManager.toggleKeybind = nil
    StateManager.actionKeybind = nil
    StateManager.cubeKeybind = nil
    StateManager.guiToggleKeybind = nil
    StateManager.isDeleteModeEnabled = false
    StateManager.isActionKeyHeld = false
    StateManager.isCubeSpawned = false
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
        return
    end
    local keyCode = Enum.KeyCode[inputKey]
    if keyCode and not table.find(otherKeys, keyCode) then
        StateManager[stateKey] = keyCode
        textBox.Text = inputKey
    else
        textBox.Text = StateManager[stateKey] and StateManager[stateKey].Name or ""
    end
end

setToggleKeybindButton.MouseButton1Click:Connect(function()
    setKeybind(toggleKeybindTextBox, "toggleKeybind", { StateManager.actionKeybind, StateManager.guiToggleKeybind, StateManager.cubeKeybind })
end)

setActionKeybindButton.MouseButton1Click:Connect(function()
    setKeybind(actionKeybindTextBox, "actionKeybind", { StateManager.toggleKeybind, StateManager.guiToggleKeybind, StateManager.cubeKeybind })
end)

setCubeKeybindButton.MouseButton1Click:Connect(function()
    setKeybind(cubeKeybindTextBox, "cubeKeybind", { StateManager.toggleKeybind, StateManager.actionKeybind, StateManager.guiToggleKeybind })
end)

restoreKeybindsButton.MouseButton1Click:Connect(function()
    StateManager.toggleKeybind = Enum.KeyCode.H
    StateManager.actionKeybind = Enum.KeyCode.T
    StateManager.cubeKeybind = Enum.KeyCode.C
    toggleKeybindTextBox.Text = "H"
    actionKeybindTextBox.Text = "T"
    cubeKeybindTextBox.Text = "C"
end)

removeKeybindsButton.MouseButton1Click:Connect(function()
    StateManager.toggleKeybind = nil
    StateManager.actionKeybind = nil
    StateManager.guiToggleKeybind = nil
    StateManager.cubeKeybind = nil
    toggleKeybindTextBox.Text = ""
    actionKeybindTextBox.Text = ""
    cubeKeybindTextBox.Text = ""
end)

-- Input Handling
StateManager.connections.inputBegan = UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == StateManager.guiToggleKeybind then
        StateManager.toggleGui(frame)
    elseif input.KeyCode == StateManager.toggleKeybind then
        StateManager.toggleState(toggleButton, "isDeleteModeEnabled", "Delete Mode: ")
    elseif input.KeyCode == StateManager.actionKeybind then
        StateManager.isActionKeyHeld = true
    elseif input.KeyCode == StateManager.cubeKeybind then
        StateManager.toggleCube(spawnCubeButton)
    end
end)

StateManager.connections.inputEnded = UIS.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == StateManager.actionKeybind then
        StateManager.isActionKeyHeld = false
    end
end)

-- Outline Handling
StateManager.connections.outline = RunService.RenderStepped:Connect(function()
    DeleteRestoreManager.handleOutline(
        mouse,
        selectionBox,
        StateManager.isDeleteModeEnabled,
        StateManager.isActionKeyHeld,
        StateManager.isOutlineEnabled,
        StateManager.isCharacterProtected
    )
end)

-- Delete Objects or Terrain
local debounce = false
StateManager.connections.delete = mouse.Button1Down:Connect(function()
    if debounce or not StateManager.isDeleteModeEnabled or not StateManager.isActionKeyHeld then
        debounce = false
        return
    end
    debounce = true

    if StateManager.isTerrainDeletionEnabled then
        local hitPosition = DeleteRestoreManager.checkTerrain(mouse)
        if hitPosition then
            local terrain = game.Workspace.Terrain
            local region = DeleteRestoreManager.getTerrainRegion(hitPosition)
            local regionMin = region.CFrame.Position - region.Size / 2
            local backup = terrain:CopyRegion(region)
            table.insert(DeleteRestoreManager.deletedObjects, { region = backup, position = regionMin, name = "Terrain" })

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
                if StateManager.isAudioEnabled then AudioManager.deleteSound:Play() end
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
        elseif data.region then
            game.Workspace.Terrain:PasteRegion(data.region, data.position, true)
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
    if StateManager.isCubeSpawned then
        StateManager.toggleCube(spawnCubeButton)
        StateManager.toggleCube(spawnCubeButton)
    end
end)
