local a = game:GetService("UserInputService")
local b = game:GetService("Players")
local c = game:GetService("RunService")
local d = game:GetService("PhysicsService")
local e = b.LocalPlayer
local f = e:GetMouse()
if not e.Parent then
    print("Waiting for player to load...")
    b.PlayerAdded:Wait()
end
print("Player fully loaded:", e.Name)
if not e.Character then
    print("Waiting for initial character to load...")
    e.CharacterAdded:Wait()
end
print("Initial character loaded:", e.Character.Name)
local g
local h = 10
local i = 1
while i <= h do
    g = e:FindFirstChild("PlayerGui")
    if g then
        print("PlayerGui found on attempt", i)
        break
    else
        warn("PlayerGui not found, attempt " .. i .. "/" .. h)
        task.wait(1)
        i = i + 1
    end
end
if not g then
    warn("PlayerGui not found after " .. h .. " attempts. GUI will not load.")
    return
end
local function j(k, l)
    print(string.format("[%s]: %s", k, l))
end
local function m(n, o, p, q, r)
    local s = Instance.new("TextButton")
    s.Size = o
    s.Position = p
    s.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    s.BorderColor3 = Color3.fromRGB(100, 0, 0)
    s.BorderSizePixel = 1
    s.TextColor3 = Color3.fromRGB(255, 255, 255)
    s.Text = q
    s.Font = Enum.Font.SourceSans
    s.TextSize = 16
    s.Parent = n
    for t, u in pairs(r or {}) do
        s[t] = u
    end
    return s
end
local function v(n, o, p, q, r)
    local w = Instance.new("TextLabel")
    w.Size = o
    w.Position = p
    w.BackgroundTransparency = 1
    w.TextColor3 = Color3.fromRGB(255, 255, 255)
    w.Text = q
    w.Font = Enum.Font.SourceSans
    w.TextSize = 14
    w.Parent = n
    for t, u in pairs(r or {}) do
        w[t] = u
    end
    return w
end
local function x()
    print("Starting createGui")
    local y = Instance.new("ScreenGui")
    y.Name = "DeleteGui"
    y.ResetOnSpawn = false
    y.Enabled = true
    y.IgnoreGuiInset = true
    print("GUI Created - Enabled:", y.Enabled)
    local z = Instance.new("Frame")
    z.Size = UDim2.new(0, 300, 0, 400)
    z.Position = UDim2.new(0.5, -150, 0.5, -200)
    z.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    z.BorderColor3 = Color3.fromRGB(150, 0, 0)
    z.BorderSizePixel = 2
    z.Active = true
    z.Draggable = true
    z.Visible = true
    z.Parent = y
    print("Frame Created - Visible:", z.Visible)
    local A = Instance.new("UIPadding")
    A.PaddingTop = UDim.new(0, 5)
    A.PaddingBottom = UDim.new(0, 5)
    A.PaddingLeft = UDim.new(0, 5)
    A.PaddingRight = UDim.new(0, 5)
    A.Parent = z
    local k =
        v(
        z,
        UDim2.new(1, -10, 0, 30),
        UDim2.new(0, 5, 0, 5),
        "Delete Tool",
        {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(200, 0, 0),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18
        }
    )
    local B =
        m(
        z,
        UDim2.new(0, 90, 0, 25),
        UDim2.new(0, 5, 0, 40),
        "Main",
        {BackgroundColor3 = Color3.fromRGB(200, 0, 0), Font = Enum.Font.SourceSansBold}
    )
    local C = m(z, UDim2.new(0, 90, 0, 25), UDim2.new(0, 95, 0, 40), "Audio", {Font = Enum.Font.SourceSansBold})
    local D = m(z, UDim2.new(0, 90, 0, 25), UDim2.new(0, 185, 0, 40), "Settings", {Font = Enum.Font.SourceSansBold})
    local E = Instance.new("Frame")
    E.Size = UDim2.new(1, -10, 0, 280)
    E.Position = UDim2.new(0, 5, 0, 70)
    E.BackgroundTransparency = 1
    E.Visible = true
    E.Parent = z
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -10, 0, 280)
    F.Position = UDim2.new(0, 5, 0, 70)
    F.BackgroundTransparency = 1
    F.Visible = false
    F.Parent = z
    local G = Instance.new("Frame")
    G.Size = UDim2.new(1, -10, 0, 280)
    G.Position = UDim2.new(0, 5, 0, 70)
    G.BackgroundTransparency = 1
    G.Visible = false
    G.Parent = z
    print("Creating settingsTabFrame UIListLayout")
    local H = Instance.new("UIListLayout")
    H.SortOrder = Enum.SortOrder.LayoutOrder
    H.Padding = UDim.new(0, 3)
    H.Parent = G
    local I = m(E, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 0), "Delete Mode: Off")
    local J = m(E, UDim2.new(0, 130, 0, 30), UDim2.new(0, 140, 0, 0), "Protect Character: Off")
    local K = m(E, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 35), "Terrain Deletion: Off")
    local L = m(E, UDim2.new(0, 130, 0, 30), UDim2.new(0, 140, 0, 35), "Outline: On")
    local M = m(E, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 70), "Right-Click Restore: On")
    local N = m(E, UDim2.new(0, 130, 0, 30), UDim2.new(0, 140, 0, 70), "Spawn Cube: Off")
    local O = m(E, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 105), "Restore All")
    local P = Instance.new("ScrollingFrame")
    P.Size = UDim2.new(1, 0, 0, 140)
    P.Position = UDim2.new(0, 0, 0, 140)
    P.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    P.BorderColor3 = Color3.fromRGB(100, 0, 0)
    P.BorderSizePixel = 1
    P.CanvasSize = UDim2.new(0, 0, 0, 0)
    P.ScrollBarThickness = 6
    P.Parent = E
    local Q = Instance.new("UIListLayout")
    Q.SortOrder = Enum.SortOrder.LayoutOrder
    Q.Padding = UDim.new(0, 3)
    Q.Parent = P
    local R = m(F, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 0), "Audio: On")
    local S =
        v(
        F,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(0, 0, 0, 35),
        "Delete Audio ID:",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold}
    )
    local T = Instance.new("Frame")
    T.Size = UDim2.new(1, 0, 0, 25)
    T.Position = UDim2.new(0, 0, 0, 55)
    T.BackgroundTransparency = 1
    T.Parent = F
    local U = Instance.new("TextBox")
    U.Size = UDim2.new(0, 210, 0, 25)
    U.Position = UDim2.new(0, 0, 0, 0)
    U.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    U.BorderColor3 = Color3.fromRGB(100, 0, 0)
    U.BorderSizePixel = 1
    U.TextColor3 = Color3.fromRGB(255, 255, 255)
    U.PlaceholderText = "e.g., 4676738150"
    U.Text = "4676738150"
    U.Font = Enum.Font.SourceSans
    U.TextSize = 14
    U.Parent = T
    local V =
        m(T, UDim2.new(0, 50, 0, 25), UDim2.new(0, 215, 0, 0), "Set", {Font = Enum.Font.SourceSansBold, TextSize = 14})
    local W =
        v(
        F,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(0, 0, 0, 85),
        "Restore Audio ID:",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold}
    )
    local X = Instance.new("Frame")
    X.Size = UDim2.new(1, 0, 0, 25)
    X.Position = UDim2.new(0, 0, 0, 105)
    X.BackgroundTransparency = 1
    X.Parent = F
    local Y = Instance.new("TextBox")
    Y.Size = UDim2.new(0, 210, 0, 25)
    Y.Position = UDim2.new(0, 0, 0, 0)
    Y.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Y.BorderColor3 = Color3.fromRGB(100, 0, 0)
    Y.BorderSizePixel = 1
    Y.TextColor3 = Color3.fromRGB(255, 250, 255)
    Y.PlaceholderText = "e.g., 773858658"
    Y.Text = "773858658"
    Y.Font = Enum.Font.SourceSans
    Y.TextSize = 14
    Y.Parent = X
    local Z =
        m(X, UDim2.new(0, 50, 0, 25), UDim2.new(0, 215, 0, 0), "Set", {Font = Enum.Font.SourceSansBold, TextSize = 14})
    local _ =
        v(
        F,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(0, 0, 0, 135),
        "Delete Volume: 1.0",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold}
    )
    local a0 =
        m(F, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 155), "", {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
    local a1 = Instance.new("Frame")
    a1.Size = UDim2.new(1, 0, 1, 0)
    a1.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    a1.BorderSizePixel = 0
    a1.Parent = a0
    local a2 =
        v(
        F,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(0, 0, 0, 180),
        "Restore Volume: 1.0",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold}
    )
    local a3 =
        m(F, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 200), "", {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
    local a4 = Instance.new("Frame")
    a4.Size = UDim2.new(1, 0, 1, 0)
    a4.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    a4.BorderSizePixel = 0
    a4.Parent = a3
    print("Creating toggleKeybindFrame")
    local a5 = Instance.new("Frame")
    a5.Size = UDim2.new(1, 0, 0, 25)
    a5.BackgroundTransparency = 1
    a5.LayoutOrder = 1
    a5.Parent = G
    print("Creating toggleKeybindLabel")
    local a6 =
        v(
        a5,
        UDim2.new(0, 110, 0, 25),
        UDim2.new(0, 0, 0, 0),
        "Toggle Keybind:",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold}
    )
    print("Creating toggleKeybindTextBox")
    local a7 = Instance.new("TextBox")
    a7.Size = UDim2.new(0, 50, 0, 25)
    a7.Position = UDim2.new(0, 115, 0, 0)
    a7.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    a7.BorderColor3 = Color3.fromRGB(100, 0, 0)
    a7.BorderSizePixel = 1
    a7.TextColor3 = Color3.fromRGB(255, 255, 255)
    a7.PlaceholderText = "e.g., H, G"
    a7.Text = "H"
    a7.Font = Enum.Font.SourceSans
    a7.TextSize = 14
    a7.Parent = a5
    print("Creating setToggleKeybindButton")
    local a8 =
        m(a5, UDim2.new(0, 50, 0, 25), UDim2.new(0, 170, 0, 0), "Set", {Font = Enum.Font.SourceSansBold, TextSize = 14})
    print("Creating actionKeybindFrame")
    local a9 = Instance.new("Frame")
    a9.Size = UDim2.new(1, 0, 0, 25)
    a9.BackgroundTransparency = 1
    a9.LayoutOrder = 2
    a9.Parent = G
    print("Creating actionKeybindLabel")
    local aa =
        v(
        a9,
        UDim2.new(0, 110, 0, 25),
        UDim2.new(0, 0, 0, 0),
        "Action Keybind:",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold}
    )
    print("Creating actionKeybindTextBox")
    local ab = Instance.new("TextBox")
    ab.Size = UDim2.new(0, 50, 0, 25)
    ab.Position = UDim2.new(0, 115, 0, 0)
    ab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ab.BorderColor3 = Color3.fromRGB(100, 0, 0)
    ab.BorderSizePixel = 1
    ab.TextColor3 = Color3.fromRGB(255, 255, 255)
    ab.PlaceholderText = "e.g., T, R"
    ab.Text = "T"
    ab.Font = Enum.Font.SourceSans
    ab.TextSize = 14
    ab.Parent = a9
    print("Creating setActionKeybindButton")
    local ac =
        m(a9, UDim2.new(0, 50, 0, 25), UDim2.new(0, 170, 0, 0), "Set", {Font = Enum.Font.SourceSansBold, TextSize = 14})
    print("Creating cubeKeybindFrame")
    local ad = Instance.new("Frame")
    ad.Size = UDim2.new(1, 0, 0, 25)
    ad.BackgroundTransparency = 1
    ad.LayoutOrder = 3
    ad.Parent = G
    print("Creating cubeKeybindLabel")
    local ae =
        v(
        ad,
        UDim2.new(0, 110, 0, 25),
        UDim2.new(0, 0, 0, 0),
        "Cube Keybind:",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold}
    )
    print("Creating cubeKeybindTextBox")
    local af = Instance.new("TextBox")
    af.Size = UDim2.new(0, 50, 0, 25)
    af.Position = UDim2.new(0, 115, 0, 0)
    af.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    af.BorderColor3 = Color3.fromRGB(100, 0, 0)
    af.BorderSizePixel = 1
    af.TextColor3 = Color3.fromRGB(255, 255, 255)
    af.PlaceholderText = "e.g., C, V"
    af.Text = "C"
    af.Font = Enum.Font.SourceSans
    af.TextSize = 14
    af.Parent = ad
    print("Creating setCubeKeybindButton")
    local ag =
        m(ad, UDim2.new(0, 50, 0, 25), UDim2.new(0, 170, 0, 0), "Set", {Font = Enum.Font.SourceSansBold, TextSize = 14})
    print("Creating cubeSizeLabel")
    local ah =
        v(
        G,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(),
        "Cube Size: 25",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold, LayoutOrder = 4}
    )
    print("Creating cubeSizeSlider")
    local ai =
        m(G, UDim2.new(1, 0, 0, 20), UDim2.new(), "", {BackgroundColor3 = Color3.fromRGB(50, 50, 50), LayoutOrder = 5})
    local aj = Instance.new("Frame")
    aj.Size = UDim2.new(0.5, 0, 1, 0)
    aj.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    aj.BorderSizePixel = 0
    aj.Parent = ai
    print("Creating cubeThicknessLabel")
    local ak =
        v(
        G,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(),
        "Cube Thickness: 1.0",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold, LayoutOrder = 6}
    )
    print("Creating cubeThicknessSlider")
    local al =
        m(G, UDim2.new(1, 0, 0, 20), UDim2.new(), "", {BackgroundColor3 = Color3.fromRGB(50, 50, 50), LayoutOrder = 7})
    local am = Instance.new("Frame")
    am.Size = UDim2.new(0.032, 0, 1, 0)
    am.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    am.BorderSizePixel = 0
    am.Parent = al
    print("Creating cubeTransparencyLabel")
    local an =
        v(
        G,
        UDim2.new(1, 0, 0, 20),
        UDim2.new(),
        "Cube Transparency: 0.7",
        {TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.SourceSansBold, LayoutOrder = 8}
    )
    print("Creating cubeTransparencySlider")
    local ao =
        m(G, UDim2.new(1, 0, 0, 20), UDim2.new(), "", {BackgroundColor3 = Color3.fromRGB(50, 50, 50), LayoutOrder = 9})
    local ap = Instance.new("Frame")
    ap.Size = UDim2.new(0.7, 0, 1, 0)
    ap.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    ap.BorderSizePixel = 0
    ap.Parent = ao
    print("Creating cubeFloorDestroyFrame")
    local aq = Instance.new("Frame")
    aq.Size = UDim2.new(1, 0, 0, 30)
    aq.BackgroundTransparency = 1
    aq.LayoutOrder = 10
    aq.Parent = G
    print("Creating cubeFloorButton")
    local ar = m(aq, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 0), "Cube Floor: Off")
    print("Creating destroyMenuButton")
    local as = m(aq, UDim2.new(0, 130, 0, 30), UDim2.new(0, 135, 0, 0), "Destroy Menu")
    print("Creating restoreDestroyRevertFrame")
    local at = Instance.new("Frame")
    at.Size = UDim2.new(1, 0, 0, 30)
    at.BackgroundTransparency = 1
    at.LayoutOrder = 11
    at.Parent = G
    print("Creating restoreKeybindsButton")
    local au = m(at, UDim2.new(0, 130, 0, 30), UDim2.new(0, 0, 0, 0), "Restore All Keybinds")
    print("Creating destroyAndRevertButton")
    local av = m(at, UDim2.new(0, 130, 0, 30), UDim2.new(0, 135, 0, 0), "Destroy & Revert")
    print("Creating removeKeybindsButton")
    local aw = m(G, UDim2.new(0, 130, 0, 30), UDim2.new(), "Remove Every Keybind", {LayoutOrder = 12})
    print("GUI parenting to PlayerGui")
    y.Parent = g
    print("DeleteGui successfully parented to PlayerGui")
    return {
        gui = y,
        frame = z,
        mainTabButton = B,
        audioTabButton = C,
        settingsTabButton = D,
        mainTabFrame = E,
        audioTabFrame = F,
        settingsTabFrame = G,
        toggleButton = I,
        protectButton = J,
        terrainButton = K,
        outlineButton = L,
        rightClickRestoreButton = M,
        restoreAllButton = O,
        logFrame = P,
        audioToggleButton = R,
        deleteAudioIdTextBox = U,
        setDeleteAudioIdButton = V,
        restoreAudioIdTextBox = Y,
        setRestoreAudioIdButton = Z,
        deleteVolumeLabel = _,
        deleteVolumeSlider = a0,
        deleteVolumeFill = a1,
        restoreVolumeLabel = a2,
        restoreVolumeSlider = a3,
        restoreVolumeFill = a4,
        toggleKeybindTextBox = a7,
        setToggleKeybindButton = a8,
        actionKeybindTextBox = ab,
        setActionKeybindButton = ac,
        restoreKeybindsButton = au,
        removeKeybindsButton = aw,
        destroyMenuButton = as,
        destroyAndRevertButton = av,
        spawnCubeButton = N,
        cubeKeybindTextBox = af,
        setCubeKeybindButton = ag,
        cubeSizeLabel = ah,
        cubeSizeSlider = ai,
        cubeSizeFill = aj,
        cubeThicknessLabel = ak,
        cubeThicknessSlider = al,
        cubeThicknessFill = am,
        cubeFloorButton = ar,
        cubeTransparencyLabel = an,
        cubeTransparencySlider = ao,
        cubeTransparencyFill = ap
    }
end
local ax = {
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
function ax.toggleState(s, ay, w, az)
    ax[ay] = not ax[ay]
    s.Text = w .. (ax[ay] and "On" or "Off")
    if az then
        az()
    end
end
function ax.toggleGui(z)
    z.Visible = not z.Visible
end
function ax.setupSlider(aA, aB, w, ay, aC, aD, aE)
    local aF = false
    aA.MouseButton1Down:Connect(
        function()
            aF = true
        end
    )
    a.InputEnded:Connect(
        function(aG)
            if aG.UserInputType == Enum.UserInputType.MouseButton1 then
                aF = false
            end
        end
    )
    aA.MouseMoved:Connect(
        function(aH)
            if aF then
                local aI = aH - aA.AbsolutePosition.X
                local aJ = math.clamp(aI / aA.AbsoluteSize.X, 0, 1)
                aB.Size = UDim2.new(aJ, 0, 1, 0)
                ax[ay] = aC + aJ * (aD - aC)
                w.Text = string.format(aE, ax[ay])
            end
        end
    )
end
local function aK(o, p, n, aL)
    local aM = Instance.new("Part")
    aM.Size = o
    aM.Position = p
    aM.Anchored = true
    aM.CanCollide = true
    aM.Transparency = aL.transparency
    aM.BrickColor = aL.brickColor
    aM.Parent = n
    return aM
end
function ax.toggleCube(N)
    ax.toggleState(
        N,
        "isCubeSpawned",
        "Spawn Cube: ",
        function()
            local aN = "PlayerCube_" .. e.Name
            local aO = game.Workspace:FindFirstChild(aN)
            if ax.isCubeSpawned then
                if not e.Character or not e.Character:FindFirstChild("HumanoidRootPart") then
                    print("Character or HumanoidRootPart not found, cannot spawn cube")
                    ax.isCubeSpawned = false
                    N.Text = "Spawn Cube: Off"
                    return
                end
                if aO then
                    aO:Destroy()
                end
                local aP = Instance.new("Model")
                aP.Name = aN
                local aQ = Vector3.new(ax.cubeSize, ax.cubeSize, ax.cubeSize)
                local aR = ax.cubeThickness
                local aS = {
                    props = {transparency = ax.cubeTransparency, brickColor = BrickColor.new("Really red")},
                    parts = {
                        {
                            name = "leftWall",
                            size = Vector3.new(aR, aQ.Y, aQ.Z),
                            offset = Vector3.new(-aQ.X / 2 + aR / 2, 0, 0)
                        },
                        {
                            name = "rightWall",
                            size = Vector3.new(aR, aQ.Y, aQ.Z),
                            offset = Vector3.new(aQ.X / 2 - aR / 2, 0, 0)
                        },
                        {
                            name = "frontWall",
                            size = Vector3.new(aQ.X, aQ.Y, aR),
                            offset = Vector3.new(0, 0, -aQ.Z / 2 + aR / 2)
                        },
                        {
                            name = "backWall",
                            size = Vector3.new(aQ.X, aQ.Y, aR),
                            offset = Vector3.new(0, 0, aQ.Z / 2 - aR / 2)
                        },
                        {
                            name = "ceiling",
                            size = Vector3.new(aQ.X, aR, aQ.Z),
                            offset = Vector3.new(0, aQ.Y / 2 - aR / 2, 0)
                        }
                    }
                }
                if ax.isCubeFloorEnabled then
                    table.insert(
                        aS.parts,
                        {
                            name = "floor",
                            size = Vector3.new(aQ.X, aR, aQ.Z),
                            offset = Vector3.new(0, -aQ.Y / 2 - 3 + aR, 0)
                        }
                    )
                end
                local aT = {}
                local aU = e.Character.HumanoidRootPart.Position
                local aV = 2.5
                local aW = aU + Vector3.new(0, aQ.Y / 2 - aV, 0)
                for aX, aY in ipairs(aS.parts) do
                    aT[aY.name] = aK(aY.size, aW + aY.offset, aP, aS.props)
                end
                aP.Parent = game.Workspace
                print("Cube spawned at:", aW)
                if ax.cubeConnection then
                    ax.cubeConnection:Disconnect()
                end
                ax.cubeConnection =
                    c.Heartbeat:Connect(
                    function()
                        if not ax.isCubeSpawned or not e.Character or not e.Character:FindFirstChild("HumanoidRootPart") then
                            if aP then
                                aP:Destroy()
                            end
                            if ax.cubeConnection then
                                ax.cubeConnection:Disconnect()
                                ax.cubeConnection = nil
                            end
                            ax.isCubeSpawned = false
                            N.Text = "Spawn Cube: Off"
                            return
                        end
                        local aZ = Vector3.new(ax.cubeSize, ax.cubeSize, ax.cubeSize)
                        local a_ = ax.cubeThickness
                        local b0 = ax.cubeTransparency
                        local b1 = e.Character.HumanoidRootPart.Position
                        local b2 = b1 + Vector3.new(0, aZ.Y / 2 - aV, 0)
                        for aX, aY in ipairs(aS.parts) do
                            local aM = aT[aY.name]
                            if aM then
                                local o = aY.size
                                local b3 = aY.offset
                                if aY.name == "leftWall" or aY.name == "rightWall" then
                                    o = Vector3.new(a_, aZ.Y, aZ.Z)
                                    b3 =
                                        aY.name == "leftWall" and Vector3.new(-aZ.X / 2 + a_ / 2, 0, 0) or
                                        Vector3.new(aZ.X / 2 - a_ / 2, 0, 0)
                                elseif aY.name == "frontWall" or aY.name == "backWall" then
                                    o = Vector3.new(aZ.X, aZ.Y, a_)
                                    b3 =
                                        aY.name == "frontWall" and Vector3.new(0, 0, -aZ.Z / 2 + a_ / 2) or
                                        Vector3.new(0, 0, aZ.Z / 2 - a_ / 2)
                                elseif aY.name == "ceiling" then
                                    o = Vector3.new(aZ.X, a_, aZ.Z)
                                    b3 = Vector3.new(0, aZ.Y / 2 - a_ / 2, 0)
                                elseif aY.name == "floor" then
                                    o = Vector3.new(aZ.X, a_, aZ.Z)
                                    b3 = Vector3.new(0, -aZ.Y / 2 - 3 + a_, 0)
                                end
                                aM.Size = o
                                aM.Position = b2 + b3
                                aM.Transparency = b0
                            end
                        end
                    end
                )
                j(
                    "Cube",
                    "Cube with Separate Walls, Ceiling, " ..
                        (ax.isCubeFloorEnabled and "and Floor " or "No Floor ") .. "Spawned"
                )
            else
                if aO then
                    aO:Destroy()
                    print("Cube despawned")
                end
                if ax.cubeConnection then
                    ax.cubeConnection:Disconnect()
                    ax.cubeConnection = nil
                end
                j("Cube", "Cube Despawned")
            end
        end
    )
end
local b4 = {deleteSound = Instance.new("Sound", game.Workspace), restoreSound = Instance.new("Sound", game.Workspace)}
b4.deleteSound.SoundId = "rbxassetid://4676738150"
b4.deleteSound.Volume = 1
b4.restoreSound.SoundId = "rbxassetid://773858658"
b4.restoreSound.Volume = 1
function b4.setAudioId(b5, b6)
    local b7 = b5.Text:match("%d+")
    if b7 then
        local b8, b9 =
            pcall(
            function()
                b6.SoundId = "rbxassetid://" .. b7
            end
        )
        if not b8 then
            warn("Failed to set audio ID: " .. tostring(b9))
            b5.Text = b6.SoundId:match("%d+") or ""
        end
    else
        b5.Text = b6.SoundId:match("%d+") or ""
    end
end
function b4.setupVolumeSlider(aA, aB, w, b6)
    local aF = false
    aA.MouseButton1Down:Connect(
        function()
            aF = true
        end
    )
    a.InputEnded:Connect(
        function(aG)
            if aG.UserInputType == Enum.UserInputType.MouseButton1 then
                aF = false
            end
        end
    )
    aA.MouseMoved:Connect(
        function(aH)
            if aF then
                local aI = aH - aA.AbsolutePosition.X
                local aJ = math.clamp(aI / aA.AbsoluteSize.X, 0, 1)
                aB.Size = UDim2.new(aJ, 0, 1, 0)
                b6.Volume = aJ
                w.Text = string.format("%s Volume: %.1f", w.Text:match("^(.-) Volume"), aJ)
            end
        end
    )
end
local ba = {
    deletedObjects = {},
    MAX_TERRAIN_BACKUPS = 5,
    deletedStorage = Instance.new("Folder", game.ReplicatedStorage),
    characterCache = {}
}
ba.deletedStorage.Name = "DeletedObjects"
function ba.isBodyPartOrCharacter(bb, bc)
    if not bc then
        return false
    end
    if ba.characterCache[bb] then
        return true
    end
    local bd = {"Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}
    for aX, aM in ipairs(bd) do
        if bb.Name == aM then
            ba.characterCache[bb] = true
            return true
        end
    end
    local be = bb:FindFirstAncestorOfClass("Model")
    if be and be:FindFirstChildOfClass("Humanoid") then
        ba.characterCache[bb] = true
        return true
    end
    return false
end
function ba.getTerrainRegion(p)
    local bf = game.Workspace.Terrain
    local bg = 4
    local bh = Vector3.new(32, 32, 32)
    local bi = bf:WorldToCell(p)
    local bj = bi - Vector3.new(bh.X / bg / 2, bh.Y / bg / 2, bh.Z / bg / 2)
    local bk = bi + Vector3.new(bh.X / bg / 2, bh.Y / bg / 2, bh.Z / bg / 2)
    local bl = bf:CellToWorld(bj.X, bj.Y, bj.Z)
    local bm = bf:CellToWorld(bk.X, bk.Y, bk.Z)
    return Region3.new(bl, bm)
end
function ba.checkTerrain(f)
    local bf = game.Workspace.Terrain
    local bn = f.Hit.Position
    local bi = bf:WorldToCell(bn)
    if bf:GetCell(bi.X, bi.Y, bi.Z) ~= Enum.Material.Air then
        return bn
    end
    return nil
end
function ba.updateLogbox(P, bo, bp)
    for aX, bq in ipairs(P:GetChildren()) do
        if bq:IsA("Frame") then
            bq:Destroy()
        end
    end
    local br = 0
    local bs = 50
    for bt, bu in ipairs(ba.deletedObjects) do
        if bt > bs then
            break
        end
        local bv = Instance.new("Frame")
        bv.Size = UDim2.new(1, -10, 0, 25)
        bv.BackgroundTransparency = 1
        bv.LayoutOrder = bt
        bv.Parent = P
        v(
            bv,
            UDim2.new(0, 170, 1, 0),
            UDim2.new(0, 0, 0, 0),
            (bu.name or "Unnamed") ..
                (bu.object and " (Parent: " .. (bu.originalParent and bu.originalParent.Name or "None") .. ")" or "")
        )
        local bw = m(bv, UDim2.new(0, 70, 1, 0), UDim2.new(1, -70, 0, 0), "Restore", {Font = Enum.Font.SourceSansBold})
        bw.MouseButton1Click:Connect(
            function()
                if bu.object then
                    local b8, b9 =
                        pcall(
                        function()
                            bu.object.Parent = bu.originalParent
                        end
                    )
                    if b8 then
                        table.remove(ba.deletedObjects, bt)
                        ba.updateLogbox(P, bo, bp)
                        if bo then
                            bp:Play()
                        end
                    else
                        warn("Failed to restore object: " .. tostring(b9))
                    end
                elseif bu.region then
                    local b8, b9 =
                        pcall(
                        function()
                            game.Workspace.Terrain:PasteRegion(bu.region, bu.position, true)
                        end
                    )
                    if b8 then
                        table.remove(ba.deletedObjects, bt)
                        ba.updateLogbox(P, bo, bp)
                        if bo then
                            bp:Play()
                        end
                    else
                        warn("Failed to restore terrain: " .. tostring(b9))
                    end
                end
            end
        )
        br = br + 28
    end
    P.CanvasSize = UDim2.new(0, 0, 0, br)
end
function ba.restoreAll(bo, bp)
    for bt = #ba.deletedObjects, 1, -1 do
        local bu = ba.deletedObjects[bt]
        local b8, b9 =
            pcall(
            function()
                if bu.object then
                    bu.object.Parent = bu.originalParent
                elseif bu.region then
                    game.Workspace.Terrain:PasteRegion(bu.region, bu.position, true)
                end
                if bo then
                    bp:Play()
                end
            end
        )
        if not b8 then
            warn("Failed to restore: " .. tostring(b9))
        end
    end
    ba.deletedObjects = {}
end
function ba.handleOutline(f, bx, by, bz, bA, bc)
    if by and bz and bA then
        local bb = f.Target
        if bb and not ba.isBodyPartOrCharacter(bb, bc) then
            bx.Adornee = bb
            bx.Visible = true
        else
            bx.Adornee = nil
            bx.Visible = false
        end
    else
        bx.Adornee = nil
        bx.Visible = false
    end
end
local bB = x()
if not bB or not bB.gui then
    warn("GUI creation failed")
    return
end
print("GUI created successfully")
local y = bB.gui
local z = bB.frame
local B = bB.mainTabButton
local C = bB.audioTabButton
local D = bB.settingsTabButton
local E = bB.mainTabFrame
local F = bB.audioTabFrame
local G = bB.settingsTabFrame
local I = bB.toggleButton
local J = bB.protectButton
local K = bB.terrainButton
local L = bB.outlineButton
local M = bB.rightClickRestoreButton
local O = bB.restoreAllButton
local P = bB.logFrame
local R = bB.audioToggleButton
local U = bB.deleteAudioIdTextBox
local V = bB.setDeleteAudioIdButton
local Y = bB.restoreAudioIdTextBox
local Z = bB.setRestoreAudioIdButton
local _ = bB.deleteVolumeLabel
local a0 = bB.deleteVolumeSlider
local a1 = bB.deleteVolumeFill
local a2 = bB.restoreVolumeLabel
local a3 = bB.restoreVolumeSlider
local a4 = bB.restoreVolumeFill
local a7 = bB.toggleKeybindTextBox
local a8 = bB.setToggleKeybindButton
local ab = bB.actionKeybindTextBox
local ac = bB.setActionKeybindButton
local au = bB.restoreKeybindsButton
local aw = bB.removeKeybindsButton
local as = bB.destroyMenuButton
local av = bB.destroyAndRevertButton
local N = bB.spawnCubeButton
local af = bB.cubeKeybindTextBox
local ag = bB.setCubeKeybindButton
local ah = bB.cubeSizeLabel
local ai = bB.cubeSizeSlider
local aj = bB.cubeSizeFill
local ak = bB.cubeThicknessLabel
local al = bB.cubeThicknessSlider
local am = bB.cubeThicknessFill
local ar = bB.cubeFloorButton
local an = bB.cubeTransparencyLabel
local ao = bB.cubeTransparencySlider
local ap = bB.cubeTransparencyFill
local bx = Instance.new("SelectionBox", game.Workspace)
bx.Name = "DeleteSelectionBox"
bx.LineThickness = 0.01
bx.Color3 = Color3.fromRGB(255, 0, 0)
bx.Visible = false
local function bC(s)
    s.MouseEnter:Connect(
        function()
            if s.BackgroundColor3 ~= Color3.fromRGB(200, 0, 0) then
                s.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
            end
        end
    )
    s.MouseLeave:Connect(
        function()
            if s.BackgroundColor3 ~= Color3.fromRGB(200, 0, 0) then
                s.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        end
    )
end
for aX, bD in ipairs({I, J, K, L, M, N, O, R, V, Z, B, C, D, au, aw, as, av, a8, ac, ag, ar}) do
    bC(bD)
end
local function bE(bF, bG)
    E.Visible = bG == E
    F.Visible = bG == F
    G.Visible = bG == G
    B.BackgroundColor3 = bF == B and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
    C.BackgroundColor3 = bF == C and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
    D.BackgroundColor3 = bF == D and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
end
B.MouseButton1Click:Connect(
    function()
        bE(B, E)
    end
)
C.MouseButton1Click:Connect(
    function()
        bE(C, F)
    end
)
D.MouseButton1Click:Connect(
    function()
        bE(D, G)
    end
)
I.MouseButton1Click:Connect(
    function()
        ax.toggleState(I, "isDeleteModeEnabled", "Delete Mode: ")
    end
)
J.MouseButton1Click:Connect(
    function()
        ax.toggleState(J, "isCharacterProtected", "Protect Character: ")
    end
)
K.MouseButton1Click:Connect(
    function()
        ax.toggleState(K, "isTerrainDeletionEnabled", "Terrain Deletion: ")
    end
)
L.MouseButton1Click:Connect(
    function()
        ax.toggleState(
            L,
            "isOutlineEnabled",
            "Outline: ",
            function()
                bx.Visible = ax.isOutlineEnabled and ax.isDeleteModeEnabled and ax.isActionKeyHeld
            end
        )
    end
)
M.MouseButton1Click:Connect(
    function()
        ax.toggleState(M, "isRightClickRestoreEnabled", "Right-Click Restore: ")
    end
)
R.MouseButton1Click:Connect(
    function()
        ax.toggleState(R, "isAudioEnabled", "Audio: ")
    end
)
N.MouseButton1Click:Connect(
    function()
        ax.toggleCube(N)
    end
)
ar.MouseButton1Click:Connect(
    function()
        ax.toggleState(
            ar,
            "isCubeFloorEnabled",
            "Cube Floor: ",
            function()
                if ax.isCubeSpawned then
                    ax.toggleCube(N)
                    ax.toggleCube(N)
                end
            end
        )
    end
)
V.MouseButton1Click:Connect(
    function()
        b4.setAudioId(U, b4.deleteSound)
    end
)
Z.MouseButton1Click:Connect(
    function()
        b4.setAudioId(Y, b4.restoreSound)
    end
)
b4.setupVolumeSlider(a0, a1, _, b4.deleteSound)
b4.setupVolumeSlider(a3, a4, a2, b4.restoreSound)
ax.setupSlider(ai, aj, ah, "cubeSize", 10, 50, "Cube Size: %d")
ax.setupSlider(al, am, ak, "cubeThickness", 0.2, 25, "Cube Thickness: %.1f")
ax.setupSlider(ao, ap, an, "cubeTransparency", 0, 1, "Cube Transparency: %.1f")
O.MouseButton1Click:Connect(
    function()
        ba.restoreAll(ax.isAudioEnabled, b4.restoreSound)
        ba.updateLogbox(P, ax.isAudioEnabled, b4.restoreSound)
    end
)
local function bH()
    local bI = game.Workspace:FindFirstChild("PlayerCube_" .. e.Name)
    if bI then
        bI:Destroy()
    end
    if ax.cubeConnection then
        ax.cubeConnection:Disconnect()
        ax.cubeConnection = nil
    end
    for aX, bJ in ipairs(ax.connections) do
        bJ:Disconnect()
    end
    ax.connections = {}
    ax.toggleKeybind = nil
    ax.actionKeybind = nil
    ax.cubeKeybind = nil
    ax.guiToggleKeybind = nil
    ax.isDeleteModeEnabled = false
    ax.isActionKeyHeld = false
    ax.isCubeSpawned = false
    y:Destroy()
    bx:Destroy()
    b4.deleteSound:Destroy()
    b4.restoreSound:Destroy()
    ba.deletedStorage:Destroy()
end
as.MouseButton1Click:Connect(bH)
av.MouseButton1Click:Connect(
    function()
        ba.restoreAll(ax.isAudioEnabled, b4.restoreSound)
        bH()
    end
)
local function bK(b5, ay, bL)
    local bM = b5.Text:upper():match("^%s*(.-)%s*$")
    if bM == "" then
        ax[ay] = nil
        b5.Text = ""
        return
    end
    local bN = Enum.KeyCode[bM]
    if bN and not table.find(bL, bN) then
        ax[ay] = bN
        b5.Text = bM
    else
        b5.Text = ax[ay] and ax[ay].Name or ""
    end
end
a8.MouseButton1Click:Connect(
    function()
        bK(a7, "toggleKeybind", {ax.actionKeybind, ax.guiToggleKeybind, ax.cubeKeybind})
    end
)
ac.MouseButton1Click:Connect(
    function()
        bK(ab, "actionKeybind", {ax.toggleKeybind, ax.guiToggleKeybind, ax.cubeKeybind})
    end
)
ag.MouseButton1Click:Connect(
    function()
        bK(af, "cubeKeybind", {ax.toggleKeybind, ax.actionKeybind, ax.guiToggleKeybind})
    end
)
au.MouseButton1Click:Connect(
    function()
        ax.toggleKeybind = Enum.KeyCode.H
        ax.actionKeybind = Enum.KeyCode.T
        ax.cubeKeybind = Enum.KeyCode.C
        a7.Text = "H"
        ab.Text = "T"
        af.Text = "C"
    end
)
aw.MouseButton1Click:Connect(
    function()
        ax.toggleKeybind = nil
        ax.actionKeybind = nil
        ax.guiToggleKeybind = nil
        ax.cubeKeybind = nil
        a7.Text = ""
        ab.Text = ""
        af.Text = ""
    end
)
ax.connections.inputBegan =
    a.InputBegan:Connect(
    function(aG, bO)
        if bO then
            return
        end
        if aG.KeyCode == ax.guiToggleKeybind then
            ax.toggleGui(z)
        elseif aG.KeyCode == ax.toggleKeybind then
            ax.toggleState(I, "isDeleteModeEnabled", "Delete Mode: ")
        elseif aG.KeyCode == ax.actionKeybind then
            ax.isActionKeyHeld = true
        elseif aG.KeyCode == ax.cubeKeybind then
            ax.toggleCube(N)
        end
    end
)
ax.connections.inputEnded =
    a.InputEnded:Connect(
    function(aG, bO)
        if bO then
            return
        end
        if aG.KeyCode == ax.actionKeybind then
            ax.isActionKeyHeld = false
        end
    end
)
ax.connections.outline =
    c.RenderStepped:Connect(
    function()
        ba.handleOutline(
            f,
            bx,
            ax.isDeleteModeEnabled,
            ax.isActionKeyHeld,
            ax.isOutlineEnabled,
            ax.isCharacterProtected
        )
    end
)
local bP = false
ax.connections.delete =
    f.Button1Down:Connect(
    function()
        if bP or not ax.isDeleteModeEnabled or not ax.isActionKeyHeld then
            bP = false
            return
        end
        bP = true
        if ax.isTerrainDeletionEnabled then
            local bn = ba.checkTerrain(f)
            if bn then
                local bf = game.Workspace.Terrain
                local bQ = ba.getTerrainRegion(bn)
                local bR = bQ.CFrame.Position - bQ.Size / 2
                local bS = bf:CopyRegion(bQ)
                table.insert(ba.deletedObjects, {region = bS, position = bR, name = "Terrain"})
                local bT = 0
                for aX, bu in ipairs(ba.deletedObjects) do
                    if bu.region then
                        bT = bT + 1
                    end
                end
                while bT > ba.MAX_TERRAIN_BACKUPS do
                    for bt, bu in ipairs(ba.deletedObjects) do
                        if bu.region then
                            table.remove(ba.deletedObjects, bt)
                            bT = bT - 1
                            break
                        end
                    end
                end
                local b8, b9 =
                    pcall(
                    function()
                        bf:FillRegion(bQ, 4, Enum.Material.Air)
                        if ax.isAudioEnabled then
                            b4.deleteSound:Play()
                        end
                    end
                )
                if b8 then
                    ba.updateLogbox(P, ax.isAudioEnabled, b4.restoreSound)
                else
                    warn("Failed to clear terrain: " .. tostring(b9))
                end
                bP = false
                return
            end
        end
        local bb = f.Target
        if not bb or bb:IsA("Terrain") or ba.isBodyPartOrCharacter(bb, ax.isCharacterProtected) then
            bP = false
            return
        end
        table.insert(ba.deletedObjects, {object = bb, originalParent = bb.Parent, name = bb.Name})
        local b8, b9 =
            pcall(
            function()
                bb.Parent = ba.deletedStorage
                if ax.isAudioEnabled then
                    b4.deleteSound:Play()
                end
            end
        )
        if b8 then
            ba.updateLogbox(P, ax.isAudioEnabled, b4.restoreSound)
        else
            warn("Failed to delete object: " .. tostring(b9))
        end
        task.wait(0.1)
        bP = false
    end
)
ax.connections.restore =
    f.Button2Down:Connect(
    function()
        if not ax.isActionKeyHeld or not ax.isRightClickRestoreEnabled or #ba.deletedObjects == 0 then
            return
        end
        local bu = table.remove(ba.deletedObjects)
        local b8, b9 =
            pcall(
            function()
                if bu.object then
                    bu.object.Parent = bu.originalParent
                elseif bu.region then
                    game.Workspace.Terrain:PasteRegion(bu.region, bu.position, true)
                end
                if ax.isAudioEnabled then
                    b4.restoreSound:Play()
                end
            end
        )
        if b8 then
            ba.updateLogbox(P, ax.isAudioEnabled, b4.restoreSound)
        else
            warn("Failed to restore: " .. tostring(b9))
        end
    end
)
e.CharacterAdded:Connect(
    function(be)
        print("Character respawned:", be.Name)
        ba.characterCache = {}
        if ax.isCubeSpawned then
            ax.toggleCube(N)
            ax.toggleCube(N)
        end
    end
)
