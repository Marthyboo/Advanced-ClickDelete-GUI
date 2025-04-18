-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Player setup
local player = Players.LocalPlayer
local mouse = player:GetMouse()
print("Player:", player.Name)

-- Wait for PlayerGui
local playerGui
local maxAttempts = 30
local attempt = 1
while attempt <= maxAttempts do
    playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        print("PlayerGui found on attempt", attempt)
        break
    else
        warn("PlayerGui not found, attempt " .. attempt .. "/" .. maxAttempts)
        task.wait(0.5)
        attempt = attempt + 1
    end
end
if not playerGui then
    error("PlayerGui not found after " .. maxAttempts .. " attempts. Aborting.")
    return
end

-- Helper Functions
local function createButton(parent, size, position, text, extraProps)
    local success, button = pcall(function()
        local btn = Instance.new("TextButton")
        btn.Size = size
        btn.Position = position
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BorderColor3 = Color3.fromRGB(100, 0, 0)
        btn.BorderSizePixel = 1
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = text
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.TextScaled = false
        btn.TextWrapped = true
        btn.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.5, 0)
        corner.Parent = btn
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 6)
        padding.PaddingLeft = UDim.new(0, 6)
        padding.PaddingRight = UDim.new(0, 6)
        padding.Parent = btn
        for key, value in pairs(extraProps or {}) do
            btn[key] = value
        end
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end)
        btn.MouseButton1Down:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end)
        btn.MouseButton1Up:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        end)
        return btn
    end)
    if success then
        print("Created button:", text, "at", position)
        return button
    else
        warn("Failed to create button:", text, "Error:", button)
        return nil
    end
end

local function createFrame(parent, size, position, extraProps)
    local success, frame = pcall(function()
        local frm = Instance.new("Frame")
        frm.Size = size
        frm.Position = position
        frm.BackgroundTransparency = extraProps and extraProps.BackgroundTransparency or 1
        frm.BackgroundColor3 = extraProps and extraProps.BackgroundColor3 or Color3.fromRGB(30, 30, 30)
        frm.BorderColor3 = extraProps and extraProps.BorderColor3 or Color3.fromRGB(100, 0, 0)
        frm.BorderSizePixel = extraProps and extraProps.BorderSizePixel or 0
        frm.Parent = parent
        for key, value in pairs(extraProps or {}) do
            frm[key] = value
        end
        return frm
    end)
    if success then
        print("Created frame at", position)
        return frame
    else
        warn("Failed to create frame at", position, "Error:", frame)
        return nil
    end
end

local function createLabel(parent, size, position, text, extraProps)
    local success, label = pcall(function()
        local lbl = Instance.new("TextLabel")
        lbl.Size = size
        lbl.Position = position
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Text = text
        lbl.Font = Enum.Font.SourceSans
        lbl.TextSize = 14
        lbl.TextScaled = false
        lbl.TextWrapped = true
        lbl.Parent = parent
        for key, value in pairs(extraProps or {}) do
            lbl[key] = value
        end
        return lbl
    end)
    if success then
        print("Created label:", text, "at", position)
        return label
    else
        warn("Failed to create label:", text, "Error:", label)
        return nil
    end
end

local function createTextBox(parent, size, position, placeholder, extraProps)
    local success, textBox = pcall(function()
        local tb = Instance.new("TextBox")
        tb.Size = size
        tb.Position = position
        tb.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tb.BorderColor3 = Color3.fromRGB(100, 0, 0)
        tb.TextColor3 = Color3.fromRGB(255, 255, 255)
        tb.PlaceholderText = placeholder
        tb.Text = extraProps and extraProps.Text or ""
        tb.Font = Enum.Font.SourceSans
        tb.TextSize = 14
        tb.TextScaled = false
        tb.TextWrapped = true
        tb.Parent = parent
        for key, value in pairs(extraProps or {}) do
            tb[key] = value
        end
        tb.FocusLost:Connect(function()
            if tb.Text == "" then
                tb.BorderColor3 = Color3.fromRGB(200, 0, 0)
            else
                tb.BorderColor3 = Color3.fromRGB(100, 0, 0)
            end
        end)
        return tb
    end)
    if success then
        print("Created textbox:", placeholder, "at", position)
        return textBox
    else
        warn("Failed to create textbox:", placeholder, "Error:", textBox)
        return nil
    end
end

local function tweenElement(element, properties, duration, delay)
    if not element then
        warn("Cannot tween nil element")
        return
    end
    local success, tween = pcall(function()
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, delay or 0)
        local tw = TweenService:Create(element, tweenInfo, properties)
        tw:Play()
        return tw
    end)
    if not success then
        warn("Failed to tween element:", element.Name, "Error:", tween)
    end
end

-- GUI Creation
local function createGui()
    print("Starting createGui")
    local success, result = pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "DeleteGui"
        gui.ResetOnSpawn = false
        gui.Enabled = true
        gui.IgnoreGuiInset = true
        print("GUI created - Enabled:", gui.Enabled)

        -- Central Button
        local centralButton = createButton(gui, UDim2.new(0, 64, 0, 64), UDim2.new(0.5, -32, 0.5, -32), "Menu", {
            BackgroundColor3 = Color3.fromRGB(200, 0, 0),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18
        })
        if not centralButton then return nil end

        -- Primary Ring Frame
        local primaryRingFrame = createFrame(gui, UDim2.new(0, 420, 0, 420), UDim2.new(0.5, -210, 0.5, -210), {
            Visible = false
        })
        if not primaryRingFrame then return nil end

        -- Secondary Ring Frame
        local secondaryRingFrame = createFrame(gui, UDim2.new(0, 520, 0, 520), UDim2.new(0.5, -260, 0.5, -260), {
            Visible = false
        })
        if not secondaryRingFrame then return nil end

        -- Primary Buttons
        local primaryRadius = 130
        local primaryButtons = {
            { name = "Main", angle = 0, button = nil, subFrame = nil },
            { name = "Audio", angle = 120, button = nil, subFrame = nil },
            { name = "Settings", angle = 240, button = nil, subFrame = nil }
        }

        for i, tab in ipairs(primaryButtons) do
            local rad = math.rad(tab.angle)
            local x = primaryRadius * math.cos(rad)
            local y = primaryRadius * math.sin(rad)
            tab.button = createButton(primaryRingFrame, UDim2.new(0, 54, 0, 54), UDim2.new(0.5, x - 27, 0.5, y - 27), tab.name, {
                Font = Enum.Font.SourceSansBold,
                TextSize = 16
            })
            if not tab.button then return nil end
            tab.subFrame = createFrame(secondaryRingFrame, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), {
                Visible = false
            })
            if not tab.subFrame then return nil end
        end

        -- Main Tab Sub-Menu
        local mainSubRadius = 240
        local mainButtons = {
            { name = "toggleButton", text = "Delete Mode: Off", angle = 0 },
            { name = "protectButton", text = "Protect: Off", angle = 51.43 },
            { name = "terrainButton", text = "Terrain: Off", angle = 102.86 },
            { name = "outlineButton", text = "Outline: On", angle = 154.29 },
            { name = "rightClickRestoreButton", text = "R-Click: On", angle = 205.71 },
            { name = "spawnCubeButton", text = "Cube: Off", angle = 257.14 },
            { name = "restoreAllButton", text = "Restore All", angle = 308.57 }
        }

        local mainElements = {}
        for i, btn in ipairs(mainButtons) do
            local rad = math.rad(btn.angle)
            local x = mainSubRadius * math.cos(rad)
            local y = mainSubRadius * math.sin(rad)
            mainElements[btn.name] = createButton(primaryButtons[1].subFrame, UDim2.new(0, 64, 0, 64), UDim2.new(0.5, x - 32, 0.5, y - 32), btn.text)
            if not mainElements[btn.name] then return nil end
        end

        -- Log Frame
        local logFrame = createFrame(primaryButtons[1].subFrame, UDim2.new(0, 120, 0, 100), UDim2.new(0.5, -60, 0.5, -120), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BorderColor3 = Color3.fromRGB(100, 0, 0),
            BorderSizePixel = 1
        })
        if not logFrame then return nil end
        local logLayout = Instance.new("UIListLayout")
        logLayout.SortOrder = Enum.SortOrder.LayoutOrder
        logLayout.Padding = UDim.new(0, 6)
        logLayout.Parent = logFrame

        -- Audio Tab Sub-Menu
        local audioSubRadius = 240
        local audioItems = {
            { name = "audioToggleButton", text = "Audio: On", angle = 0 },
            { name = "deleteAudioFrame", angle = 72 },
            { name = "restoreAudioFrame", angle = 144 },
            { name = "deleteVolumeFrame", angle = 216 },
            { name = "restoreVolumeFrame", angle = 288 }
        }

        local audioElements = {}
        for i, item in ipairs(audioItems) do
            local rad = math.rad(item.angle)
            local x = audioSubRadius * math.cos(rad)
            local y = audioSubRadius * math.sin(rad)
            if item.name == "audioToggleButton" then
                audioElements[item.name] = createButton(primaryButtons[2].subFrame, UDim2.new(0, 64, 0, 64), UDim2.new(0.5, x - 32, 0.5, y - 32), item.text)
            else
                audioElements[item.name] = createFrame(primaryButtons[2].subFrame, UDim2.new(0, 120, 0, 80), UDim2.new(0.5, x - 60, 0.5, y - 40), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderColor3 = Color3.fromRGB(100, 0, 0),
                    BorderSizePixel = 1
                })
                local layout = Instance.new("UIListLayout")
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Padding = UDim.new(0, 6)
                layout.Parent = audioElements[item.name]
            end
            if not audioElements[item.name] then return nil end
        end

        audioElements.deleteAudioLabel = createLabel(audioElements.deleteAudioFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Del Audio ID:")
        audioElements.deleteAudioIdTextBox = createTextBox(audioElements.deleteAudioFrame, UDim2.new(0, 80, 0, 24), UDim2.new(0, 5, 0, 24), "e.g., 4676738150", { Text = "4676738150" })
        audioElements.setDeleteAudioIdButton = createButton(audioElements.deleteAudioFrame, UDim2.new(0, 35, 0, 24), UDim2.new(0, 85, 0, 24), "Set")

        audioElements.restoreAudioLabel = createLabel(audioElements.restoreAudioFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Res Audio ID:")
        audioElements.restoreAudioIdTextBox = createTextBox(audioElements.restoreAudioFrame, UDim2.new(0, 80, 0, 24), UDim2.new(0, 5, 0, 24), "e.g., 773858658", { Text = "773858658" })
        audioElements.setRestoreAudioIdButton = createButton(audioElements.restoreAudioFrame, UDim2.new(0, 35, 0, 24), UDim2.new(0, 85, 0, 24), "Set")

        audioElements.deleteVolumeLabel = createLabel(audioElements.deleteVolumeFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Del Vol: 1.0")
        audioElements.deleteVolumeSlider = createButton(audioElements.deleteVolumeFrame, UDim2.new(1, -10, 0, 16), UDim2.new(0, 5, 0, 24), "", {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        })
        audioElements.deleteVolumeFill = createFrame(audioElements.deleteVolumeSlider, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), {
            BackgroundColor3 = Color3.fromRGB(200, 0, 0),
            BorderSizePixel = 0
        })

        audioElements.restoreVolumeLabel = createLabel(audioElements.restoreVolumeFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Res Vol: 1.0")
        audioElements.restoreVolumeSlider = createButton(audioElements.restoreVolumeFrame, UDim2.new(1, -10, 0, 16), UDim2.new(0, 5, 0, 24), "", {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        })
        audioElements.restoreVolumeFill = createFrame(audioElements.restoreVolumeSlider, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), {
            BackgroundColor3 = Color3.fromRGB(200, 0, 0),
            BorderSizePixel = 0
        })

        -- Settings Tab Sub-Menu
        local settingsSubRadius = 240
        local settingsItems = {
            { name = "toggleKeybindFrame", angle = 0 },
            { name = "actionKeybindFrame", angle = 45 },
            { name = "cubeKeybindFrame", angle = 90 },
            { name = "cubeSizeFrame", angle = 135 },
            { name = "cubeThicknessFrame", angle = 180 },
            { name = "cubeTransparencyFrame", angle = 225 },
            { name = "cubeFloorButton", text = "Floor: Off", angle = 270 },
            { name = "destroyMenuButton", text = "Destroy", angle = 315 }
        }

        local settingsElements = {}
        for i, item in ipairs(settingsItems) do
            local rad = math.rad(item.angle)
            local x = settingsSubRadius * math.cos(rad)
            local y = settingsSubRadius * math.sin(rad)
            if item.text then
                settingsElements[item.name] = createButton(primaryButtons[3].subFrame, UDim2.new(0, 64, 0, 64), UDim2.new(0.5, x - 32, 0.5, y - 32), item.text)
            else
                settingsElements[item.name] = createFrame(primaryButtons[3].subFrame, UDim2.new(0, 120, 0, 80), UDim2.new(0.5, x - 60, 0.5, y - 40), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderColor3 = Color3.fromRGB(100, 0, 0),
                    BorderSizePixel = 1
                })
                local layout = Instance.new("UIListLayout")
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Padding = UDim.new(0, 6)
                layout.Parent = settingsElements[item.name]
            end
            if not settingsElements[item.name] then return nil end
        end

        settingsElements.toggleKeybindLabel = createLabel(settingsElements.toggleKeybindFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Toggle Key:")
        settingsElements.toggleKeybindTextBox = createTextBox(settingsElements.toggleKeybindFrame, UDim2.new(0, 70, 0, 24), UDim2.new(0, 5, 0, 24), "e.g., H", { Text = "H" })
        settingsElements.setToggleKeybindButton = createButton(settingsElements.toggleKeybindFrame, UDim2.new(0, 45, 0, 24), UDim2.new(0, 75, 0, 24), "Set")

        settingsElements.actionKeybindLabel = createLabel(settingsElements.actionKeybindFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Action Key:")
        settingsElements.actionKeybindTextBox = createTextBox(settingsElements.actionKeybindFrame, UDim2.new(0, 70, 0, 24), UDim2.new(0, 5, 0, 24), "e.g., T", { Text = "T" })
        settingsElements.setActionKeybindButton = createButton(settingsElements.actionKeybindFrame, UDim2.new(0, 45, 0, 24), UDim2.new(0, 75, 0, 24), "Set")

        settingsElements.cubeKeybindLabel = createLabel(settingsElements.cubeKeybindFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Cube Key:")
        settingsElements.cubeKeybindTextBox = createTextBox(settingsElements.cubeKeybindFrame, UDim2.new(0, 70, 0, 24), UDim2.new(0, 5, 0, 24), "e.g., C", { Text = "C" })
        settingsElements.setCubeKeybindButton = createButton(settingsElements.cubeKeybindFrame, UDim2.new(0, 45, 0, 24), UDim2.new(0, 75, 0, 24), "Set")

        settingsElements.cubeSizeLabel = createLabel(settingsElements.cubeSizeFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Size: 25")
        settingsElements.cubeSizeSlider = createButton(settingsElements.cubeSizeFrame, UDim2.new(1, -10, 0, 16), UDim2.new(0, 5, 0, 24), "", {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        })
        settingsElements.cubeSizeFill = createFrame(settingsElements.cubeSizeSlider, UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 0, 0, 0), {
            BackgroundColor3 = Color3.fromRGB(200, 0, 0),
            BorderSizePixel = 0
        })

        settingsElements.cubeThicknessLabel = createLabel(settingsElements.cubeThicknessFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Thick: 1.0")
        settingsElements.cubeThicknessSlider = createButton(settingsElements.cubeThicknessFrame, UDim2.new(1, -10, 0, 16), UDim2.new(0, 5, 0, 24), "", {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        })
        settingsElements.cubeThicknessFill = createFrame(settingsElements.cubeThicknessSlider, UDim2.new(0.032, 0, 1, 0), UDim2.new(0, 0, 0, 0), {
            BackgroundColor3 = Color3.fromRGB(200, 0, 0),
            BorderSizePixel = 0
        })

        settingsElements.cubeTransparencyLabel = createLabel(settingsElements.cubeTransparencyFrame, UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 0), "Trans: 0.7")
        settingsElements.cubeTransparencySlider = createButton(settingsElements.cubeTransparencyFrame, UDim2.new(1, -10, 0, 16), UDim2.new(0, 5, 0, 24), "", {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        })
        settingsElements.cubeTransparencyFill = createFrame(settingsElements.cubeTransparencySlider, UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 0, 0, 0), {
            BackgroundColor3 = Color3.fromRGB(200, 0, 0),
            BorderSizePixel = 0
        })

        -- Menu Animation Logic
        local function openPrimaryRing()
            primaryRingFrame.Visible = true
            secondaryRingFrame.Visible = false
            for i, tab in ipairs(primaryButtons) do
                tab.subFrame.Visible = false
                local rad = math.rad(tab.angle)
                local x = primaryRadius * math.cos(rad)
                local y = primaryRadius * math.sin(rad)
                tab.button.Position = UDim2.new(0.5, x - 27, 0.5, y - 27)
                tab.button.Size = UDim2.new(0, 54, 0, 54)
                tweenElement(tab.button, { Size = UDim2.new(0, 54, 0, 54) }, 0.2, (i - 1) * 0.05)
            end
            print("Primary ring opened")
        end

        local function closePrimaryRing()
            for i, tab in ipairs(primaryButtons) do
                tweenElement(tab.button, { Size = UDim2.new(0, 0, 0, 0) }, 0.2, (i - 1) * 0.05)
            end
            task.delay(0.3, function()
                primaryRingFrame.Visible = false
                print("Primary ring closed")
            end)
        end

        local function openSubMenu(tabIndex)
            secondaryRingFrame.Visible = true
            for i, tab in ipairs(primaryButtons) do
                tab.subFrame.Visible = (i == tabIndex)
                if i == tabIndex then
                    local subFrame = tab.subFrame
                    local children = subFrame:GetChildren()
                    for j, child in ipairs(children) do
                        if child:IsA("GuiButton") or child:IsA("Frame") then
                            local origPos = child.Position
                            local origSize = child.Size
                            child.Position = origPos
                            child.Size = origSize
                            tweenElement(child, { Size = origSize }, 0.2, (j - 1) * 0.05)
                        end
                    end
                end
            end
            print("Sub-menu opened for tab", primaryButtons[tabIndex].name)
        end

        centralButton.MouseButton1Click:Connect(function()
            if primaryRingFrame.Visible then
                closePrimaryRing()
            else
                openPrimaryRing()
            end
        end)

        for i, tab in ipairs(primaryButtons) do
            tab.button.MouseButton1Click:Connect(function()
                print(tab.name .. " tab clicked")
                openSubMenu(i)
            end)
        end

        gui.Parent = playerGui
        print("DeleteGui parented to PlayerGui")

        return {
            gui = gui,
            centralButton = centralButton,
            primaryRingFrame = primaryRingFrame,
            secondaryRingFrame = secondaryRingFrame,
            mainTabButton = primaryButtons[1].button,
            audioTabButton = primaryButtons[2].button,
            settingsTabButton = primaryButtons[3].button,
            toggleButton = mainElements.toggleButton,
            protectButton = mainElements.protectButton,
            terrainButton = mainElements.terrainButton,
            outlineButton = mainElements.outlineButton,
            rightClickRestoreButton = mainElements.rightClickRestoreButton,
            spawnCubeButton = mainElements.spawnCubeButton,
            restoreAllButton = mainElements.restoreAllButton,
            logFrame = logFrame,
            audioToggleButton = audioElements.audioToggleButton,
            deleteAudioIdTextBox = audioElements.deleteAudioIdTextBox,
            setDeleteAudioIdButton = audioElements.setDeleteAudioIdButton,
            restoreAudioIdTextBox = audioElements.restoreAudioIdTextBox,
            setRestoreAudioIdButton = audioElements.setRestoreAudioIdButton,
            deleteVolumeLabel = audioElements.deleteVolumeLabel,
            deleteVolumeSlider = audioElements.deleteVolumeSlider,
            deleteVolumeFill = audioElements.deleteVolumeFill,
            restoreVolumeLabel = audioElements.restoreVolumeLabel,
            restoreVolumeSlider = audioElements.restoreVolumeSlider,
            restoreVolumeFill = audioElements.restoreVolumeFill,
            toggleKeybindTextBox = settingsElements.toggleKeybindTextBox,
            setToggleKeybindButton = settingsElements.setToggleKeybindButton,
            actionKeybindTextBox = settingsElements.actionKeybindTextBox,
            setActionKeybindButton = settingsElements.setActionKeybindButton,
            cubeKeybindTextBox = settingsElements.cubeKeybindTextBox,
            setCubeKeybindButton = settingsElements.setCubeKeybindButton,
            cubeSizeLabel = settingsElements.cubeSizeLabel,
            cubeSizeSlider = settingsElements.cubeSizeSlider,
            cubeSizeFill = settingsElements.cubeSizeFill,
            cubeThicknessLabel = settingsElements.cubeThicknessLabel,
            cubeThicknessSlider = settingsElements.cubeThicknessSlider,
            cubeThicknessFill = settingsElements.cubeThicknessFill,
            cubeTransparencyLabel = settingsElements.cubeTransparencyLabel,
            cubeTransparencySlider = settingsElements.cubeTransparencySlider,
            cubeTransparencyFill = settingsElements.cubeTransparencyFill,
            cubeFloorButton = settingsElements.cubeFloorButton,
            destroyMenuButton = settingsElements.destroyMenuButton
        }
    end)

    if not success then
        warn("GUI creation failed:", result)
        return nil
    end
    return result
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
    deletedItems = {},
    deleteAudioId = 4676738150,
    restoreAudioId = 773858658,
    deleteVolume = 1.0,
    restoreVolume = 1.0,
    connections = {}
}

function StateManager.toggleState(button, stateKey, label, callback)
    if not button then
        warn("Cannot toggle state, button is nil")
        return
    end
    StateManager[stateKey] = not StateManager[stateKey]
    button.Text = label .. (StateManager[stateKey] and "On" or "Off")
    print("Toggled", stateKey, "to", StateManager[stateKey])
    if callback then callback() end
end

function StateManager.updateToggleButton(button, stateKey, label)
    if not button then return end
    button.Text = label .. (StateManager[stateKey] and "On" or "Off")
end

function StateManager.toggleGui(centralButton)
    if not centralButton then
        warn("Cannot toggle GUI, centralButton is nil")
        return
    end
    centralButton.Visible = not centralButton.Visible
    print("Central button visibility:", centralButton.Visible)
end

function StateManager.setupSlider(slider, fill, label, stateKey, minVal, maxVal, formatStr)
    if not (slider and fill and label) then
        warn("Cannot setup slider, missing elements")
        return
    end
    local dragging = false
    local connection1 = slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    local connection2 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    local connection3 = slider.MouseMoved:Connect(function(x)
        if dragging then
            local relativeX = x - slider.AbsolutePosition.X
            local fraction = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(fraction, 0, 1, 0)
            StateManager[stateKey] = minVal + fraction * (maxVal - minVal)
            label.Text = string.format(formatStr, StateManager[stateKey])
            print("Slider", stateKey, "set to", StateManager[stateKey])
        end
    end)
    table.insert(StateManager.connections, connection1)
    table.insert(StateManager.connections, connection2)
    table.insert(StateManager.connections, connection3)
end

function StateManager.updateLogFrame(logFrame)
    if not logFrame then return end
    for _, child in ipairs(logFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, item in ipairs(StateManager.deletedItems) do
        if i > 3 then break end
        local itemFrame = createFrame(logFrame, UDim2.new(1, -10, 0, 24), UDim2.new(0, 5, 0, 0), {
            BackgroundTransparency = 1
        })
        local displayName = string.sub(item.name, 1, 15)
        if #item.name > 15 then displayName = displayName .. "..." end
        local itemLabel = createLabel(itemFrame, UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 0, 0, 0), displayName)
        local restoreButton = createButton(itemFrame, UDim2.new(0.3, -5, 1, 0), UDim2.new(0.7, 0, 0, 0), "Restore", {
            TextSize = 14
        })
        local connection = restoreButton.MouseButton1Click:Connect(function()
            item:Restore()
            table.remove(StateManager.deletedItems, i)
            StateManager.updateLogFrame(logFrame)
            if StateManager.isAudioEnabled then
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://" .. StateManager.restoreAudioId
                sound.Volume = StateManager.restoreVolume
                sound.Parent = game.Workspace
                sound:Play()
                task.delay(5, function() sound:Destroy() end)
            end
            print("Restored item:", item.name)
        end)
        table.insert(StateManager.connections, connection)
    end
end

local function createCubePart(size, position, parent, props)
    local part = Instance.new("Part")
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
    if not spawnCubeButton then
        warn("Cannot toggle cube, button is nil")
        return
    end
    StateManager.toggleState(spawnCubeButton, "isCubeSpawned", "Cube: ", function()
        local cubeName = "PlayerCube_" .. player.Name
        local existingCube = game.Workspace:FindFirstChild(cubeName)
        if StateManager.isCubeSpawned then
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                print("Character or HumanoidRootPart not found, cannot spawn cube")
                StateManager.isCubeSpawned = false
                spawnCubeButton.Text = "Cube: Off"
                return
            end
            if existingCube then existingCube:Destroy() end

            local cubeModel = Instance.new("Model")
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
                StateManager.cubeConnection = nil
            end
            StateManager.cubeConnection = RunService.Heartbeat:Connect(function()
                if not StateManager.isCubeSpawned or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    if cubeModel then cubeModel:Destroy() end
                    if StateManager.cubeConnection then
                        StateManager.cubeConnection:Disconnect()
                        StateManager.cubeConnection = nil
                    end
                    StateManager.isCubeSpawned = false
                    spawnCubeButton.Text = "Cube: Off"
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
                        if partConfig.name == "leftWall" or partConfig.name == "rightWall" then
                            size = Vector3.new(newWallThickness, newCubeSize.Y, newCubeSize.Z)
                        elseif partConfig.name == "frontWall" or partConfig.name == "backWall" then
                            size = Vector3.new(newCubeSize.X, newCubeSize.Y, newWallThickness)
                        elseif partConfig.name == "ceiling" or partConfig.name == "floor" then
                            size = Vector3.new(newCubeSize.X, newWallThickness, newCubeSize.Z)
                        end
                        part.Size = size
                        part.Position = newCenterPos + partConfig.offset
                        part.Transparency = newTransparency
                    end
                end
            end)
            table.insert(StateManager.connections, StateManager.cubeConnection)
        else
            if existingCube then existingCube:Destroy() end
            if StateManager.cubeConnection then
                StateManager.cubeConnection:Disconnect()
                StateManager.cubeConnection = nil
            end
            print("Cube despawned")
        end
    end)
end

-- Main Logic
local guiElements = createGui()
if not guiElements or not guiElements.gui then
    warn("GUI creation failed, aborting")
    return
end
print("GUI created successfully")

-- Extract GUI elements
local centralButton = guiElements.centralButton
local toggleButton = guiElements.toggleButton
local protectButton = guiElements.protectButton
local terrainButton = guiElements.terrainButton
local outlineButton = guiElements.outlineButton
local rightClickRestoreButton = guiElements.rightClickRestoreButton
local spawnCubeButton = guiElements.spawnCubeButton
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
local cubeKeybindTextBox = guiElements.cubeKeybindTextBox
local setCubeKeybindButton = guiElements.setCubeKeybindButton
local cubeSizeLabel = guiElements.cubeSizeLabel
local cubeSizeSlider = guiElements.cubeSizeSlider
local cubeSizeFill = guiElements.cubeSizeFill
local cubeThicknessLabel = guiElements.cubeThicknessLabel
local cubeThicknessSlider = guiElements.cubeThicknessSlider
local cubeThicknessFill = guiElements.cubeThicknessFill
local cubeTransparencyLabel = guiElements.cubeTransparencyLabel
local cubeTransparencySlider = guiElements.cubeTransparencySlider
local cubeTransparencyFill = guiElements.cubeTransparencyFill
local cubeFloorButton = guiElements.cubeFloorButton
local destroyMenuButton = guiElements.destroyMenuButton

-- Connect Main Tab Buttons
if toggleButton then
    local connection = toggleButton.MouseButton1Click:Connect(function()
        StateManager.toggleState(toggleButton, "isDeleteModeEnabled", "Delete Mode: ")
    end)
    table.insert(StateManager.connections, connection)
end
if protectButton then
    local connection = protectButton.MouseButton1Click:Connect(function()
        StateManager.toggleState(protectButton, "isCharacterProtected", "Protect: ")
    end)
    table.insert(StateManager.connections, connection)
end
if terrainButton then
    local connection = terrainButton.MouseButton1Click:Connect(function()
        StateManager.toggleState(terrainButton, "isTerrainDeletionEnabled", "Terrain: ")
    end)
    table.insert(StateManager.connections, connection)
end
if outlineButton then
    local connection = outlineButton.MouseButton1Click:Connect(function()
        StateManager.toggleState(outlineButton, "isOutlineEnabled", "Outline: ")
    end)
    table.insert(StateManager.connections, connection)
end
if rightClickRestoreButton then
    local connection = rightClickRestoreButton.MouseButton1Click:Connect(function()
        StateManager.toggleState(rightClickRestoreButton, "isRightClickRestoreEnabled", "R-Click: ")
    end)
    table.insert(StateManager.connections, connection)
end
if spawnCubeButton then
    local connection = spawnCubeButton.MouseButton1Click:Connect(function()
        StateManager.toggleCube(spawnCubeButton)
    end)
    table.insert(StateManager.connections, connection)
end
if restoreAllButton then
    local connection = restoreAllButton.MouseButton1Click:Connect(function()
        for _, item in ipairs(StateManager.deletedItems) do
            item:Restore()
        end
        StateManager.deletedItems = {}
        StateManager.updateLogFrame(logFrame)
        if StateManager.isAudioEnabled then
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. StateManager.restoreAudioId
            sound.Volume = StateManager.restoreVolume
            sound.Parent = game.Workspace
            sound:Play()
            task.delay(5, function() sound:Destroy() end)
        end
        print("Restored all items")
    end)
    table.insert(StateManager.connections, connection)
end

-- Connect Audio Tab Buttons
if audioToggleButton then
    local connection = audioToggleButton.MouseButton1Click:Connect(function()
        StateManager.toggleState(audioToggleButton, "isAudioEnabled", "Audio: ")
    end)
    table.insert(StateManager.connections, connection)
end
if setDeleteAudioIdButton and deleteAudioIdTextBox then
    local connection = setDeleteAudioIdButton.MouseButton1Click:Connect(function()
        local id = tonumber(deleteAudioIdTextBox.Text)
        if id and id > 0 then
            StateManager.deleteAudioId = id
            deleteAudioIdTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
            print("Delete Audio ID set to:", id)
        else
            deleteAudioIdTextBox.BorderColor3 = Color3.fromRGB(200, 0, 0)
            warn("Invalid Delete Audio ID")
        end
    end)
    table.insert(StateManager.connections, connection)
end
if setRestoreAudioIdButton and restoreAudioIdTextBox then
    local connection = setRestoreAudioIdButton.MouseButton1Click:Connect(function()
        local id = tonumber(restoreAudioIdTextBox.Text)
        if id and id > 0 then
            StateManager.restoreAudioId = id
            restoreAudioIdTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
            print("Restore Audio ID set to:", id)
        else
            restoreAudioIdTextBox.BorderColor3 = Color3.fromRGB(200, 0, 0)
            warn("Invalid Restore Audio ID")
        end
    end)
    table.insert(StateManager.connections, connection)
end
if deleteVolumeSlider and deleteVolumeFill and deleteVolumeLabel then
    StateManager.setupSlider(deleteVolumeSlider, deleteVolumeFill, deleteVolumeLabel, "deleteVolume", 0, 3, "Del Vol: %.1f")
end
if restoreVolumeSlider and restoreVolumeFill and restoreVolumeLabel then
    StateManager.setupSlider(restoreVolumeSlider, restoreVolumeFill, restoreVolumeLabel, "restoreVolume", 0, 3, "Res Vol: %.1f")
end

-- Connect Settings Tab Buttons
if setToggleKeybindButton and toggleKeybindTextBox then
    local connection = setToggleKeybindButton.MouseButton1Click:Connect(function()
        local key = Enum.KeyCode[toggleKeybindTextBox.Text]
        if key then
            StateManager.toggleKeybind = key
            toggleKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
            print("Toggle keybind set to:", toggleKeybindTextBox.Text)
        else
            toggleKeybindTextBox.BorderColor3 = Color3.fromRGB(200, 0, 0)
            warn("Invalid keybind")
        end
    end)
    table.insert(StateManager.connections, connection)
end
if setActionKeybindButton and actionKeybindTextBox then
    local connection = setActionKeybindButton.MouseButton1Click:Connect(function()
        local key = Enum.KeyCode[actionKeybindTextBox.Text]
        if key then
            StateManager.actionKeybind = key
            actionKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
            print("Action keybind set to:", actionKeybindTextBox.Text)
        else
            actionKeybindTextBox.BorderColor3 = Color3.fromRGB(200, 0, 0)
            warn("Invalid keybind")
        end
    end)
    table.insert(StateManager.connections, connection)
end
if setCubeKeybindButton and cubeKeybindTextBox then
    local connection = setCubeKeybindButton.MouseButton1Click:Connect(function()
        local key = Enum.KeyCode[cubeKeybindTextBox.Text]
        if key then
            StateManager.cubeKeybind = key
            cubeKeybindTextBox.BorderColor3 = Color3.fromRGB(100, 0, 0)
            print("Cube keybind set to:", cubeKeybindTextBox.Text)
        else
            cubeKeybindTextBox.BorderColor3 = Color3.fromRGB(200, 0, 0)
            warn("Invalid keybind")
        end
    end)
    table.insert(StateManager.connections, connection)
end
if cubeSizeSlider and cubeSizeFill and cubeSizeLabel then
    StateManager.setupSlider(cubeSizeSlider, cubeSizeFill, cubeSizeLabel, "cubeSize", 5, 50, "Size: %.0f")
end
if cubeThicknessSlider and cubeThicknessFill and cubeThicknessLabel then
    StateManager.setupSlider(cubeThicknessSlider, cubeThicknessFill, cubeThicknessLabel, "cubeThickness", 0.5, 5, "Thick: %.1f")
end
if cubeTransparencySlider and cubeTransparencyFill and cubeTransparencyLabel then
    StateManager.setupSlider(cubeTransparencySlider, cubeTransparencyFill, cubeTransparencyLabel, "cubeTransparency", 0, 1, "Trans: %.1f")
end
if cubeFloorButton then
    local connection = cubeFloorButton.MouseButton1Click:Connect(function()
        StateManager.toggleState(cubeFloorButton, "isCubeFloorEnabled", "Floor: ")
    end)
    table.insert(StateManager.connections, connection)
end
if destroyMenuButton then
    local connection = destroyMenuButton.MouseButton1Click:Connect(function()
        StateManager.cleanup()
        print("Menu destroyed")
    end)
    table.insert(StateManager.connections, connection)
end

-- Object Deletion and Restoration
local selectionBox
if StateManager.isOutlineEnabled then
    selectionBox = Instance.new("SelectionBox")
    selectionBox.Color3 = Color3.fromRGB(200, 0, 0)
    selectionBox.LineThickness = 0.05
    selectionBox.Parent = game.Workspace
end

local function deleteItem(item)
    if not item or item.Locked or (StateManager.isCharacterProtected and item:IsDescendantOf(player.Character)) then
        return
    end
    local deletedItem = {
        name = item.Name,
        instance = item,
        parent = item.Parent,
        Restore = function(self)
            if self.instance and self.parent then
                self.instance.Parent = self.parent
            end
        end
    }
    table.insert(StateManager.deletedItems, 1, deletedItem)
    if #StateManager.deletedItems > 3 then
        table.remove(StateManager.deletedItems, 4)
    end
    item.Parent = nil
    StateManager.updateLogFrame(logFrame)
    if StateManager.isAudioEnabled then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. StateManager.deleteAudioId
        sound.Volume = StateManager.deleteVolume
        sound.Parent = game.Workspace
        sound:Play()
        task.delay(5, function() sound:Destroy() end)
    end
    print("Deleted item:", item.Name)
end

local function restoreLastItem()
    if #StateManager.deletedItems > 0 and StateManager.isRightClickRestoreEnabled then
        local item = table.remove(StateManager.deletedItems, 1)
        item:Restore()
        StateManager.updateLogFrame(logFrame)
        if StateManager.isAudioEnabled then
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. StateManager.restoreAudioId
            sound.Volume = StateManager.restoreVolume
            sound.Parent = game.Workspace
            sound:Play()
            task.delay(5, function() sound:Destroy() end)
        end
        print("Restored item:", item.name)
    end
end

-- Input Handling
StateManager.connections.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == StateManager.guiToggleKeybind then
        StateManager.toggleGui(centralButton)
    elseif input.KeyCode == StateManager.toggleKeybind and toggleButton then
        StateManager.toggleState(toggleButton, "isDeleteModeEnabled", "Delete Mode: ")
        StateManager.updateToggleButton(toggleButton, "isDeleteModeEnabled", "Delete Mode: ")
    elseif input.KeyCode == StateManager.actionKeybind then
        StateManager.isActionKeyHeld = true
    elseif input.KeyCode == StateManager.cubeKeybind and spawnCubeButton then
        StateManager.toggleCube(spawnCubeButton)
    end
end)

StateManager.connections.inputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == StateManager.actionKeybind then
        StateManager.isActionKeyHeld = false
    end
end)

StateManager.connections.mouseButton1 = mouse.Button1Down:Connect(function()
    if StateManager.isDeleteModeEnabled and StateManager.isActionKeyHeld and mouse.Target then
        deleteItem(mouse.Target)
    end
end)

StateManager.connections.mouseButton2 = mouse.Button2Down:Connect(function()
    restoreLastItem()
end)

-- Outline Update
StateManager.connections.renderStepped = RunService.RenderStepped:Connect(function()
    if StateManager.isDeleteModeEnabled and StateManager.isOutlineEnabled and mouse.Target and selectionBox then
        selectionBox.Adornee = mouse.Target
    else
        selectionBox.Adornee = nil
    end
end)

-- Cleanup
function StateManager.cleanup()
    for key, connection in pairs(StateManager.connections) do
        if connection then
            connection:Disconnect()
            print("Disconnected connection:", key)
        end
    end
    StateManager.connections = {}
    if StateManager.cubeConnection then
        StateManager.cubeConnection:Disconnect()
        StateManager.cubeConnection = nil
        print("Disconnected cube connection")
    end
    if guiElements.gui then
        guiElements.gui:Destroy()
        print("GUI destroyed")
    end
    if selectionBox then
        selectionBox:Destroy()
        print("SelectionBox destroyed")
    end
    print("Cleanup complete, all connections and GUI removed")
end

-- Test cleanup after 120 seconds
task.delay(120, StateManager.cleanup)
