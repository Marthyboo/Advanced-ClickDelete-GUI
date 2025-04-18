-- (Previous script content up to `cleanup` function is unchanged)

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
StateManager.connections.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
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

StateManager.connections.inputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
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
