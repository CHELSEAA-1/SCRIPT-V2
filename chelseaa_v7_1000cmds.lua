-- ============================================================================
-- CHELSEAA SYSTEM V7 // 1,000 ADMIN COMMAND ENGINE (GITHUB RAW EDITION)
-- Theme: Obsidian Black x Silver | Support: Chat Command (/ or ;) & Command Bar
-- Devices: PC, iPad / Tablet & Mobile (1,000 Functional Commands)
-- Usage via GitHub Raw: loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()
-- ============================================================================

local Plrs = game:GetService("Players")
local RS = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local TPS = game:GetService("TeleportService")
local HS = game:GetService("HttpService")
local Light = game:GetService("Lighting")
local VU = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local WS = game:GetService("Workspace")
local CG = game:GetService("CoreGui")

local LP = Plrs.LocalPlayer
local Cam = WS.CurrentCamera
local Mouse = LP:GetMouse()
local C3, V3, CF, UD2 = Color3.fromRGB, Vector3.new, CFrame.new, UDim2.new

-- Tetapan Background Naga (Simpan "chelseaa_dragon.png" di folder workspace executor)
local DRAGON_FILE = "chelseaa_dragon.png"
local DRAGON_ID = "rbxassetid://0"

local S = {
    Fly = false, FlySpd = 65,
    FC = false, FCSpd = 60,
    Noclip = false, Float = false, FloatPad = nil, Swim = false,
    BHop = false, Spider = false, AutoWalk = false, NoSlow = false,
    Glide = false, SpinJump = false, AntiFall = false,
    WSOn = false, WSVal = 16,
    JPOn = false, JPVal = 50,
    HHOn = false, HHVal = 2,
    InfJump = false, God = false, Ghost = false,
    AntiStun = false, AutoSpawn = false, LastDeath = nil,
    ESP = false, DistESP = false, HpESP = false, Chams = false,
    TeamChk = false, ESPCol = C3(225, 230, 240),
    Tracers = false, XRay = false, XRayA = 0.65,
    Hitbox = false, HBSize = 10,
    Orbit = false, OrbitT = nil, OrbitSpd = 3, OrbitRad = 7,
    Headsit = nil, Attach = nil, Follow = nil, Carpet = nil,
    Backpack = nil, Bring = nil, Stare = nil,
    AntiAim = false, Spin = false, SpinSpd = 25,
    AutoSteal = false, InstPrompt = false, SpamPrompt = false,
    AutoCollect = false, AutoCD = false, Range = 25,
    AutoClick = false, ClickDelay = 0.08, AutoSwing = false, Aimlock = false,
    Fling = false, WalkFling = false, AntiFling = false,
    AntiVoid = false, AntiKick = false, AntiAFK = true, AutoRejoin = false,
    FB = false, NV = false, SilverW = false, Disco = false,
    Muted = false, LowGFX = false,
    Light = false, LightR = 35, Trail = false,
    HUD = false, Cross = false, Radar = false,
    OrbitCam = false, TopView = false, SideView = false, Tilt = 0,
    ChatSpam = false, SpamTxt = "CHELSEAA SYSTEM V7",
    Rewind = false, ClickTP = false, ClickDel = false,
    ViewIdx = 0, BaseCF = nil, BaseMark = nil, WP = {}
}

local OrigL = {
    B = Light.Brightness,
    T = Light.ClockTime,
    F = Light.FogEnd,
    S = Light.GlobalShadows,
    A = Light.Ambient
}

local Conns = {}
local Cache = {
    ESP = {}, Tr = {}, XR = {}, LG = {},
    Del = {}, Hist = {}, Snd = {}, Reach = {}, Scale = {}
}

local function new(cls, props, par)
    local o = Instance.new(cls)
    for k, v in pairs(props) do o[k] = v end
    if par then o.Parent = par end
    return o
end

local function loop(k, on, sig, fn)
    if Conns[k] then Conns[k]:Disconnect(); Conns[k] = nil end
    if on then Conns[k] = sig:Connect(fn) end
end

local function getChar() return LP.Character end
local function getRoot() local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function isEnemy(p) return not S.TeamChk or not LP.Team or not p.Team or LP.Team ~= p.Team end

local function findPlr(q)
    if not q or q == "" then return nil end
    q = q:lower()
    if q == "random" then
        local t = {}
        for _, p in ipairs(Plrs:GetPlayers()) do if p ~= LP then t[#t + 1] = p end end
        return #t > 0 and t[math.random(1, #t)] or nil
    end
    for _, p in ipairs(Plrs:GetPlayers()) do
        if p ~= LP and (p.Name:lower():sub(1, #q) == q or p.DisplayName:lower():sub(1, #q) == q) then return p end
    end
    for _, p in ipairs(Plrs:GetPlayers()) do
        if p ~= LP and (p.Name:lower():find(q, 1, true) or p.DisplayName:lower():find(q, 1, true)) then return p end
    end
end

local function nearestPlr()
    local mr = getRoot(); if not mr then return nil, math.huge end
    local best, bd = nil, math.huge
    for _, p in ipairs(Plrs:GetPlayers()) do
        if p ~= LP and isEnemy(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - mr.Position).Magnitude
            if d < bd then best, bd = p, d end
        end
    end
    return best, bd
end

-- ==================== GUI SETUP (OBSIDIAN BLACK x SILVER) ====================
local guiPar = (function()
    local ok, h = pcall(function() return typeof(gethui) == "function" and gethui() or nil end)
    if ok and h then return h end
    local ok2 = pcall(function() local _ = CG.Name end)
    return ok2 and CG or LP:WaitForChild("PlayerGui")
end)()
if guiPar:FindFirstChild("CHELSEAA_ADMIN_CMD") then guiPar.CHELSEAA_ADMIN_CMD:Destroy() end

local SG = new("ScreenGui", {Name = "CHELSEAA_ADMIN_CMD", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, guiPar)

local Pill = new("TextButton", {
    Size = UD2(0, 174, 0, 30), Position = UD2(0.5, -87, 0, 10),
    BackgroundColor3 = C3(10, 10, 13), BackgroundTransparency = 0.08,
    Text = "◈ CHELSEAA V7 [/]", TextColor3 = C3(238, 240, 245),
    Font = Enum.Font.GothamBold, TextSize = 11
}, SG)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, Pill)
local PillSt = new("UIStroke", {Color = C3(185, 190, 200), Thickness = 1.1, Transparency = 0.4}, Pill)

local StatsF = new("Frame", {
    Size = UD2(0, 310, 0, 28), Position = UD2(0, 14, 1, -42),
    BackgroundColor3 = C3(10, 10, 13), BackgroundTransparency = 0.12, Visible = false
}, SG)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, StatsF)
new("UIStroke", {Color = C3(185, 190, 200), Thickness = 1, Transparency = 0.45}, StatsF)
local StatsL = new("TextLabel", {
    Size = UD2(1, -16, 1, 0), Position = UD2(0, 8, 0, 0), BackgroundTransparency = 1,
    Text = "FPS:60 | PING:0ms | SPD:0 | PLR:1", TextColor3 = C3(235, 238, 245),
    Font = Enum.Font.Code, TextSize = 11
}, StatsF)

local RadarF = new("Frame", {
    Size = UD2(0, 280, 0, 28), Position = UD2(0.5, -140, 1, -42),
    BackgroundColor3 = C3(10, 10, 13), BackgroundTransparency = 0.12, Visible = false
}, SG)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, RadarF)
new("UIStroke", {Color = C3(185, 190, 200), Thickness = 1, Transparency = 0.45}, RadarF)
local RadarL = new("TextLabel", {
    Size = UD2(1, -16, 1, 0), Position = UD2(0, 8, 0, 0), BackgroundTransparency = 1,
    Text = "RADAR: Scanning...", TextColor3 = C3(235, 238, 245),
    Font = Enum.Font.Code, TextSize = 11
}, RadarF)

local CrossF = new("Frame", {Size = UD2(0, 18, 0, 18), Position = UD2(0.5, -9, 0.5, -9), BackgroundTransparency = 1, Visible = false}, SG)
new("Frame", {Size = UD2(1, 0, 0, 2), Position = UD2(0, 0, 0.5, -1), BackgroundColor3 = C3(240, 244, 252), BorderSizePixel = 0}, CrossF)
new("Frame", {Size = UD2(0, 2, 1, 0), Position = UD2(0.5, -1, 0, 0), BackgroundColor3 = C3(240, 244, 252), BorderSizePixel = 0}, CrossF)

local Wrap = new("Frame", {
    Name = "CmdWrapper", Size = UD2(0, 468, 0, 68), Position = UD2(0.5, -234, 0, 48),
    BackgroundColor3 = C3(10, 10, 13), BackgroundTransparency = 0.08, BorderSizePixel = 0
}, SG)
new("UICorner", {CornerRadius = UDim.new(0, 12)}, Wrap)
local WrapSt = new("UIStroke", {Color = C3(190, 195, 205), Thickness = 1.2, Transparency = 0.45}, Wrap)

local dImg = DRAGON_ID
pcall(function()
    if typeof(isfile) == "function" and typeof(getcustomasset) == "function" and isfile(DRAGON_FILE) then
        dImg = getcustomasset(DRAGON_FILE)
    end
end)
local DragImg = new("ImageLabel", {
    Size = UD2(1, 0, 1, 0), BackgroundTransparency = 1, Image = dImg,
    ImageTransparency = 0.85, ScaleType = Enum.ScaleType.Crop, ZIndex = 0
}, Wrap)
new("UICorner", {CornerRadius = UDim.new(0, 12)}, DragImg)

local InRow = new("Frame", {
    Size = UD2(1, -16, 0, 34), Position = UD2(0, 8, 0, 8),
    BackgroundColor3 = C3(18, 19, 24), BackgroundTransparency = 0.15
}, Wrap)
new("UICorner", {CornerRadius = UDim.new(0, 8)}, InRow)
new("TextLabel", {
    Size = UD2(0, 26, 1, 0), Position = UD2(0, 6, 0, 0), BackgroundTransparency = 1,
    Text = ">_", TextColor3 = C3(200, 205, 215), Font = Enum.Font.Code, TextSize = 13
}, InRow)

local Box = new("TextBox", {
    Size = UD2(1, -124, 1, 0), Position = UD2(0, 32, 0, 0), BackgroundTransparency = 1,
    PlaceholderText = "Taip command (1,000 cmds): /fly100, /ws200, /cmds...",
    PlaceholderColor3 = C3(115, 120, 132), Text = "", TextColor3 = C3(248, 248, 252),
    Font = Enum.Font.Code, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false
}, InRow)

local CmdBtn = new("TextButton", {
    Size = UD2(0, 44, 0, 24), Position = UD2(1, -92, 0.5, -12),
    BackgroundColor3 = C3(28, 30, 37), Text = "CMDS", TextColor3 = C3(215, 220, 230),
    Font = Enum.Font.GothamBold, TextSize = 10
}, InRow)
new("UICorner", {CornerRadius = UDim.new(0, 6)}, CmdBtn)

local RunBtn = new("TextButton", {
    Size = UD2(0, 40, 0, 24), Position = UD2(1, -44, 0.5, -12),
    BackgroundColor3 = C3(235, 237, 242), Text = "RUN", TextColor3 = C3(10, 10, 13),
    Font = Enum.Font.GothamBold, TextSize = 10
}, InRow)
new("UICorner", {CornerRadius = UDim.new(0, 6)}, RunBtn)

local StatusL = new("TextLabel", {
    Size = UD2(1, -20, 0, 18), Position = UD2(0, 10, 0, 45), BackgroundTransparency = 1,
    Text = "CHELSEAA SYSTEM V7 READY • 1,000 Commands (/cmds)",
    TextColor3 = C3(165, 170, 182), Font = Enum.Font.Code, TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd
}, Wrap)

local function notify(m, act)
    StatusL.Text = "> " .. m
    StatusL.TextColor3 = act and C3(245, 247, 252) or C3(165, 170, 182)
end

local SugF = new("ScrollingFrame", {
    Size = UD2(1, 0, 0, 230), Position = UD2(0, 0, 1, 6),
    BackgroundColor3 = C3(11, 11, 15), BackgroundTransparency = 0.05, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = C3(180, 185, 195),
    AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UD2(0, 0, 0, 0), Visible = false
}, Wrap)
new("UICorner", {CornerRadius = UDim.new(0, 10)}, SugF)
local SugSt = new("UIStroke", {Color = C3(170, 175, 185), Thickness = 1, Transparency = 0.55}, SugF)
new("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, SugF)
new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, SugF)

local SugHeader = new("TextLabel", {
    Size = UD2(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = 0,
    Text = "Menunjukkan 60 / 1,000 commands (taip untuk tapis)",
    TextColor3 = C3(150, 158, 172), Font = Enum.Font.Code, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
}, SugF)

-- ==================== CORE ENGINE ====================
task.spawn(function()
    while SG and SG.Parent do
        if not S.Rewind then
            local r = getRoot()
            if r then
                local last = Cache.Hist[#Cache.Hist]
                if not last or (last.Position - r.Position).Magnitude > 0.5 then
                    Cache.Hist[#Cache.Hist + 1] = r.CFrame
                    if #Cache.Hist > 120 then table.remove(Cache.Hist, 1) end
                end
            end
        end
        task.wait(0.15)
    end
end)

local Eng = {}
function Eng.StopFly()
    S.Fly = false; loop("Fly", false)
    local r = getRoot()
    if r then for _, n in ipairs({"CFlyV", "CFlyG"}) do if r:FindFirstChild(n) then r[n]:Destroy() end end end
    local h = getHum(); if h then h.PlatformStand = false end
end

function Eng.StartFly(spd)
    if spd and tonumber(spd) then S.FlySpd = math.clamp(tonumber(spd), 10, 1000) end
    if S.Fly then notify("Fly Speed: " .. S.FlySpd, true); return end
    local r, h = getRoot(), getHum(); if not r or not h then return end
    S.Fly = true; h.PlatformStand = true
    local bv = new("BodyVelocity", {Name = "CFlyV", MaxForce = V3(9e9, 9e9, 9e9)}, r)
    local bg = new("BodyGyro", {Name = "CFlyG", MaxTorque = V3(9e9, 9e9, 9e9), P = 9e4, D = 500}, r)
    loop("Fly", true, RS.RenderStepped, function()
        local cr, ch = getRoot(), getHum()
        if not S.Fly or not cr or not ch or ch.Health <= 0 then Eng.StopFly(); return end
        local cf = Cam.CFrame; bg.CFrame = cf; local mv = Vector3.zero
        if ch.MoveDirection.Magnitude > 0 then
            local fl = V3(cf.LookVector.X, 0, cf.LookVector.Z)
            mv = fl.Magnitude > 0 and (cf.LookVector * ch.MoveDirection:Dot(fl.Unit) + cf.RightVector * ch.MoveDirection:Dot(cf.RightVector)) or ch.MoveDirection
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then mv = mv + V3(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then mv = mv - V3(0, 1, 0) end
        bv.Velocity = mv.Magnitude > 0 and mv.Unit * S.FlySpd or Vector3.zero
    end)
    notify("Fly: ON (" .. S.FlySpd .. ")", true)
end

function Eng.StopFC()
    S.FC = false; loop("FC", false)
    local r = getRoot(); if r then r.Anchored = false end
    local h = getHum(); if h then Cam.CameraSubject = h end
    Cam.CameraType = Enum.CameraType.Custom
end

function Eng.StartFC(spd)
    if spd and tonumber(spd) then S.FCSpd = math.clamp(tonumber(spd), 10, 500) end
    if S.FC then notify("Freecam Speed: " .. S.FCSpd, true); return end
    local r = getRoot(); if not r then return end
    S.FC = true; r.Anchored = true; local pos = Cam.CFrame.Position; Cam.CameraType = Enum.CameraType.Scriptable
    loop("FC", true, RS.RenderStepped, function(dt)
        local cf = Cam.CFrame; local mv = Vector3.zero; local h = getHum()
        if h and h.MoveDirection.Magnitude > 0 then
            local fl = V3(cf.LookVector.X, 0, cf.LookVector.Z)
            if fl.Magnitude > 0 then mv = cf.LookVector * h.MoveDirection:Dot(fl.Unit) + cf.RightVector * h.MoveDirection:Dot(cf.RightVector) end
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) then mv = mv + V3(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.Q) then mv = mv - V3(0, 1, 0) end
        if mv.Magnitude > 0 then pos = pos + mv.Unit * S.FCSpd * dt end
        Cam.CFrame = CF(pos) * (cf - cf.Position)
    end)
    notify("Freecam: ON (" .. S.FCSpd .. ")", true)
end

function Eng.RefreshESP()
    for _, o in ipairs(Cache.ESP) do if o and o.Parent then o:Destroy() end end
    Cache.ESP = {}
    if not (S.ESP or S.Chams or S.DistESP or S.HpESP) then return end
    for _, p in ipairs(Plrs:GetPlayers()) do
        if p ~= LP and isEnemy(p) and p.Character then
            local c = p.Character; local hd = c:FindFirstChild("Head")
            if S.ESP or S.Chams then
                Cache.ESP[#Cache.ESP + 1] = new("Highlight", {
                    FillColor = S.ESPCol, FillTransparency = S.Chams and 0.25 or 0.72,
                    OutlineColor = C3(255, 255, 255), DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Adornee = c
                }, c)
            end
            if hd and (S.ESP or S.DistESP or S.HpESP) then
                local bb = new("BillboardGui", {Size = UD2(0, 180, 0, 30), StudsOffset = V3(0, 2.7, 0), AlwaysOnTop = true, Adornee = hd}, hd)
                local tx = new("TextLabel", {
                    Size = UD2(1, 0, 1, 0), BackgroundTransparency = 1, Text = p.DisplayName,
                    TextColor3 = C3(245, 247, 252), TextStrokeTransparency = 0.3, Font = Enum.Font.GothamBold, TextSize = 11
                }, bb)
                Cache.ESP[#Cache.ESP + 1] = bb
                if S.DistESP or S.HpESP then
                    local cn
                    cn = RS.Heartbeat:Connect(function()
                        if not tx or not tx.Parent or not (S.DistESP or S.HpESP) then cn:Disconnect(); return end
                        local t = {p.DisplayName}
                        if S.HpESP then local h = c:FindFirstChildOfClass("Humanoid"); if h then t[#t + 1] = string.format("[%dHP]", math.floor(h.Health)) end end
                        if S.DistESP then local mr, tr = getRoot(), c:FindFirstChild("HumanoidRootPart"); if mr and tr then t[#t + 1] = string.format("[%dm]", math.floor((mr.Position - tr.Position).Magnitude)) end end
                        tx.Text = table.concat(t, " ")
                    end)
                end
            end
        end
    end
end

function Eng.Tracers(f)
    S.Tracers = (f ~= nil) and f or not S.Tracers
    for _, o in ipairs(Cache.Tr) do if o and o.Parent then o:Destroy() end end
    Cache.Tr = {}
    if S.Tracers then
        local mr = getRoot()
        for _, p in ipairs(Plrs:GetPlayers()) do
            if p ~= LP and isEnemy(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and mr then
                local a0 = new("Attachment", {}, mr)
                local a1 = new("Attachment", {}, p.Character.HumanoidRootPart)
                local bm = new("Beam", {
                    Attachment0 = a0, Attachment1 = a1, Width0 = 0.08, Width1 = 0.08,
                    FaceCamera = true, LightEmission = 1, Color = ColorSequence.new(S.ESPCol)
                }, mr)
                Cache.Tr[#Cache.Tr + 1] = a0; Cache.Tr[#Cache.Tr + 1] = a1; Cache.Tr[#Cache.Tr + 1] = bm
            end
        end
        notify("Tracers: ON", true)
    else notify("Tracers: OFF", false) end
end

function Eng.FirePrompt(pr)
    if not pr or not pr:IsA("ProximityPrompt") then return false end
    pcall(function() pr.HoldDuration = 0; pr.RequiresLineOfSight = false end)
    if typeof(fireproximityprompt) == "function" then
        pcall(function() fireproximityprompt(pr) end)
    else
        pcall(function() pr:InputHoldBegin(); task.wait(0.02); pr:InputHoldEnd() end)
    end
    return true
end

function Eng.PromptsRange(retBase)
    local r = getRoot(); if not r then return end
    local cnt = 0
    for _, o in ipairs(WS:GetDescendants()) do
        if o:IsA("ProximityPrompt") and o.Enabled then
            local p = o.Parent and (o.Parent:IsA("BasePart") and o.Parent or o.Parent:FindFirstChildWhichIsA("BasePart", true))
            if p and (p.Position - r.Position).Magnitude <= S.Range and Eng.FirePrompt(o) then cnt = cnt + 1 end
        end
    end
    notify(cnt > 0 and ("Triggered " .. cnt .. " prompts.") or ("Tiada prompt dalam " .. S.Range .. " studs."), cnt > 0)
    if cnt > 0 and retBase and S.BaseCF then task.wait(0.1); r.CFrame = S.BaseCF + V3(0, 2, 0) end
end

function Eng.TouchAll(drops)
    local r = getRoot()
    if not r or typeof(firetouchinterest) ~= "function" then notify("firetouchinterest tidak disokong.", false); return end
    local cnt = 0
    for _, o in ipairs(WS:GetDescendants()) do
        if o:IsA("TouchTransmitter") and o.Parent and o.Parent:IsA("BasePart") then
            local p = o.Parent; local ok = true
            if drops then
                local n = (p.Name .. " " .. (p.Parent and p.Parent.Name or "")):lower()
                ok = n:find("coin") or n:find("cash") or n:find("money") or n:find("gem") or n:find("orb") or n:find("drop")
            end
            if ok then pcall(function() firetouchinterest(r, p, 0); firetouchinterest(r, p, 1); cnt = cnt + 1 end) end
        end
    end
    notify((drops and "Collect: " or "FireTouch: ") .. cnt .. " objek.", cnt > 0)
end

-- ==================== CATALOG & HANDLER REGISTRY ====================
local Catalog = {}
local H = {}
local RegisteredMap = {}

local function reg(cmdKey, usage, desc, fn)
    local k = cmdKey:lower()
    if not RegisteredMap[k] then
        RegisteredMap[k] = true
        Catalog[#Catalog + 1] = {cmd = usage, desc = desc, key = k}
    end
    H[k] = fn
end

local function renderCmds(flt)
    for _, ch in ipairs(SugF:GetChildren()) do
        if ch:IsA("TextButton") then ch:Destroy() end
    end
    local q = (flt or ""):lower()
    local shown, totalMatch = 0, 0
    for _, it in ipairs(Catalog) do
        if q == "" or it.cmd:lower():find(q, 1, true) or it.desc:lower():find(q, 1, true) then
            totalMatch = totalMatch + 1
            if shown < 60 then
                shown = shown + 1
                local b = new("TextButton", {
                    Size = UD2(1, 0, 0, 26), BackgroundColor3 = C3(20, 21, 27), LayoutOrder = shown,
                    Text = "  " .. it.cmd .. "  —  " .. it.desc, TextColor3 = C3(228, 232, 240),
                    Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }, SugF)
                new("UICorner", {CornerRadius = UDim.new(0, 6)}, b)
                b.MouseButton1Click:Connect(function()
                    local base = it.cmd:match("^(%S+)") or it.cmd
                    Box.Text = base .. " "
                    SugF.Visible = false
                    Box:CaptureFocus()
                end)
            end
        end
    end
    SugHeader.Text = string.format("Menunjukkan %d daripada %d padanan (Jumlah: %d cmds)", shown, totalMatch, #Catalog)
    SugF.Visible = totalMatch > 0
end

-- ==================== 1. BASE 205 CORE COMMANDS ====================
reg("fly", "/fly [speed]", "Terbang terus dengan kelajuan", function(a) Eng.StartFly(a) end)
reg("unfly", "/unfly", "Matikan mod terbang", function() Eng.StopFly(); notify("Fly: OFF", false) end)
reg("freecam", "/freecam [speed]", "Kamera terbang bebas meninjau peta", function(a) Eng.StartFC(a) end); H.fc = H.freecam
reg("unfreecam", "/unfreecam", "Kembali ke kamera karakter", function() Eng.StopFC(); notify("Freecam: OFF", false) end); H.unfc = H.unfreecam

reg("float", "/float", "Platform lutsinar di bawah kaki di udara", function(f)
    S.Float = (f ~= nil) and f or not S.Float
    if S.FloatPad then S.FloatPad:Destroy(); S.FloatPad = nil end
    if S.Float then
        local r = getRoot(); if not r then return end
        local p = new("Part", {Size = V3(6, 0.5, 6), Anchored = true, CanCollide = true, Material = Enum.Material.ForceField, Color = C3(210, 215, 225), Transparency = 0.65}, WS)
        S.FloatPad = p; local y = r.Position.Y - 3.25
        loop("Float", true, RS.Heartbeat, function()
            local cr = getRoot(); if not cr or not S.FloatPad then return end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then y = y + 0.45 elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then y = y - 0.45 end
            S.FloatPad.CFrame = CF(cr.Position.X, y, cr.Position.Z)
        end)
        notify("Float: ON", true)
    else loop("Float", false); notify("Float: OFF", false) end
end)
reg("unfloat", "/unfloat", "Matikan Air Float", function() H.float(false) end)

reg("swim", "/swim", "Berenang bebas di udara", function(f)
    S.Swim = (f ~= nil) and f or not S.Swim; local h = getHum()
    if S.Swim then
        if h then h:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false); h:ChangeState(Enum.HumanoidStateType.Swimming) end
        loop("Swim", true, RS.Heartbeat, function() local ch = getHum(); if ch and ch:GetState() ~= Enum.HumanoidStateType.Swimming then ch:ChangeState(Enum.HumanoidStateType.Swimming) end end)
        notify("Air Swim: ON", true)
    else loop("Swim", false); if h then h:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true); h:ChangeState(Enum.HumanoidStateType.Running) end; notify("Air Swim: OFF", false) end
end)
reg("unswim", "/unswim", "Matikan Air Swim", function() H.swim(false) end)

reg("bhop", "/bhop", "Auto Bunny Hop berterusan", function(f)
    S.BHop = (f ~= nil) and f or not S.BHop
    loop("BHop", S.BHop, RS.Heartbeat, function() local h = getHum(); if h and h.MoveDirection.Magnitude > 0 and h.FloorMaterial ~= Enum.Material.Air then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)
    notify("BHop: " .. (S.BHop and "ON" or "OFF"), S.BHop)
end)
reg("unbhop", "/unbhop", "Matikan Auto Bunny Hop", function() H.bhop(false) end)

reg("spider", "/spider", "Memanjat dinding menegak seperti labah-labah", function(f)
    S.Spider = (f ~= nil) and f or not S.Spider
    local pr = RaycastParams.new(); pr.FilterType = Enum.RaycastFilterType.Exclude
    loop("Spider", S.Spider, RS.Heartbeat, function()
        local c, r, h = getChar(), getRoot(), getHum(); if not c or not r or not h or h.MoveDirection.Magnitude == 0 then return end
        pr.FilterDescendantsInstances = {c}
        if WS:Raycast(r.Position, r.CFrame.LookVector * 2.6, pr) then r.AssemblyLinearVelocity = V3(r.AssemblyLinearVelocity.X, 32, r.AssemblyLinearVelocity.Z) end
    end)
    notify("Spider: " .. (S.Spider and "ON" or "OFF"), S.Spider)
end)
reg("unspider", "/unspider", "Matikan Spider Wall Climb", function() H.spider(false) end)

reg("phase", "/phase [studs]", "Tembus dinding nipis di hadapan", function(a)
    local r = getRoot(); local d = math.clamp(tonumber(a) or 6, 1, 80)
    if r then r.CFrame = r.CFrame * CF(0, 0, -d); notify("Phased " .. d .. " studs", true) end
end)

reg("autowalk", "/autowalk", "Berjalan ke hadapan secara automatik", function(f)
    S.AutoWalk = (f ~= nil) and f or not S.AutoWalk
    loop("AutoW", S.AutoWalk, RS.RenderStepped, function() local h = getHum(); if h then h:Move(V3(0, 0, -1), true) end end)
    notify("AutoWalk: " .. (S.AutoWalk and "ON" or "OFF"), S.AutoWalk)
end)
reg("unautowalk", "/unautowalk", "Matikan AutoWalk", function() H.autowalk(false) end)

reg("noslow", "/noslow", "Kebal daripada kesan perlahan peta", function(f)
    S.NoSlow = (f ~= nil) and f or not S.NoSlow
    loop("NoSlow", S.NoSlow, RS.Heartbeat, function() local h = getHum(); local m = S.WSOn and S.WSVal or 16; if h and h.WalkSpeed < m then h.WalkSpeed = m end end)
    notify("NoSlow: " .. (S.NoSlow and "ON" or "OFF"), S.NoSlow)
end)
reg("unnoslow", "/unnoslow", "Matikan NoSlow", function() H.noslow(false) end)

reg("glide", "/glide", "Luncur udara perlahan ketika jatuh tinggi", function(f)
    S.Glide = (f ~= nil) and f or not S.Glide
    loop("Glide", S.Glide, RS.Heartbeat, function() local r = getRoot(); if r and r.AssemblyLinearVelocity.Y < -14 then r.AssemblyLinearVelocity = V3(r.AssemblyLinearVelocity.X, -14, r.AssemblyLinearVelocity.Z) end end)
    notify("Glide: " .. (S.Glide and "ON" or "OFF"), S.Glide)
end)
reg("unglide", "/unglide", "Matikan Air Glide", function() H.glide(false) end)

reg("boost", "/boost [kuasa]", "Lonjakan pecutan udara arah kamera", function(a)
    local r = getRoot(); local p = math.clamp(tonumber(a) or 95, 20, 500)
    if r then r.AssemblyLinearVelocity = Cam.CFrame.LookVector * p + V3(0, 25, 0); notify("Boosted (" .. p .. ")!", true) end
end)
reg("dash", "/dash [studs]", "Meluncur pantas ke hadapan", function(a)
    local r = getRoot(); local d = math.clamp(tonumber(a) or 35, 5, 400)
    if r then r.AssemblyLinearVelocity = Vector3.zero; r.CFrame = r.CFrame * CF(0, 0, -d); notify("Dash " .. d, true) end
end)
reg("up", "/up [studs]", "Naik menegak", function(a) local r = getRoot(); local y = tonumber(a) or 40; if r then r.CFrame = r.CFrame + V3(0, y, 0); notify("UP +" .. y, true) end end)
reg("down", "/down [studs]", "Turun menegak", function(a) local r = getRoot(); local y = tonumber(a) or 30; if r then r.CFrame = r.CFrame - V3(0, y, 0); notify("DOWN -" .. y, true) end end)
reg("forward", "/forward [studs]", "Anjak ke hadapan", function(a) local r = getRoot(); local d = tonumber(a) or 20; if r then r.CFrame = r.CFrame * CF(0, 0, -d); notify("Forward " .. d, true) end end); H.fwd = H.forward
reg("back", "/back [studs]", "Anjak ke belakang", function(a) local r = getRoot(); local d = tonumber(a) or 20; if r then r.CFrame = r.CFrame * CF(0, 0, d); notify("Back " .. d, true) end end)
reg("left", "/left [studs]", "Anjak ke kiri", function(a) local r = getRoot(); local d = tonumber(a) or 20; if r then r.CFrame = r.CFrame * CF(-d, 0, 0); notify("Left " .. d, true) end end)
reg("right", "/right [studs]", "Anjak ke kanan", function(a) local r = getRoot(); local d = tonumber(a) or 20; if r then r.CFrame = r.CFrame * CF(d, 0, 0); notify("Right " .. d, true) end end)

reg("speed", "/speed [num]", "Tukar WalkSpeed terus", function(a)
    local n = tonumber(a)
    if n then S.WSVal = math.clamp(n, 1, 1000); S.WSOn = true else S.WSOn = not S.WSOn; if S.WSOn and S.WSVal == 16 then S.WSVal = 50 end end
    loop("WS", S.WSOn, RS.Heartbeat, function() local h = getHum(); if h then h.WalkSpeed = S.WSVal end end)
    if not S.WSOn then local h = getHum(); if h then h.WalkSpeed = 16 end end
    notify(S.WSOn and ("WalkSpeed: " .. S.WSVal) or "WalkSpeed: 16", S.WSOn)
end); H.ws = H.speed
reg("unspeed", "/unspeed", "Kembalikan WalkSpeed asal (16)", function() S.WSOn = true; H.speed(nil) end)

reg("jump", "/jump [num]", "Tukar kuasa lompatan", function(a)
    local n = tonumber(a)
    if n then S.JPVal = math.clamp(n, 10, 1000); S.JPOn = true else S.JPOn = not S.JPOn; if S.JPOn and S.JPVal == 50 then S.JPVal = 120 end end
    loop("JP", S.JPOn, RS.Heartbeat, function() local h = getHum(); if h then h.UseJumpPower = true; h.JumpPower = S.JPVal end end)
    if not S.JPOn then local h = getHum(); if h then h.JumpPower = 50 end end
    notify(S.JPOn and ("JumpPower: " .. S.JPVal) or "JumpPower: 50", S.JPOn)
end); H.jp = H.jump
reg("unjump", "/unjump", "Kembalikan JumpPower asal (50)", function() S.JPOn = true; H.jump(nil) end)

reg("infjump", "/infjump", "Lompat tanpa had di udara", function(f)
    S.InfJump = (f ~= nil) and f or not S.InfJump
    loop("InfJ", S.InfJump, UIS.JumpRequest, function() local h = getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)
    notify("InfJump: " .. (S.InfJump and "ON" or "OFF"), S.InfJump)
end)
reg("uninfjump", "/uninfjump", "Matikan Infinite Jump", function() H.infjump(false) end)

reg("spinjump", "/spinjump", "Berpusing 360 setiap lompatan", function(f)
    S.SpinJump = (f ~= nil) and f or not S.SpinJump
    loop("SpinJ", S.SpinJump, UIS.JumpRequest, function() local r = getRoot(); if r then TS:Create(r, TweenInfo.new(0.35), {CFrame = r.CFrame * CFrame.Angles(0, math.pi, 0)}):Play() end end)
    notify("SpinJump: " .. (S.SpinJump and "ON" or "OFF"), S.SpinJump)
end)
reg("unspinjump", "/unspinjump", "Matikan SpinJump", function() H.spinjump(false) end)

reg("antifall", "/antifall", "Elak fall damage ketika jatuh", function(f)
    S.AntiFall = (f ~= nil) and f or not S.AntiFall
    local pr = RaycastParams.new(); pr.FilterType = Enum.RaycastFilterType.Exclude
    loop("AntiF", S.AntiFall, RS.Heartbeat, function()
        local c, r = getChar(), getRoot(); if not c or not r or r.AssemblyLinearVelocity.Y > -45 then return end
        pr.FilterDescendantsInstances = {c}
        if WS:Raycast(r.Position, V3(0, -14, 0), pr) then r.AssemblyLinearVelocity = V3(r.AssemblyLinearVelocity.X, -5, r.AssemblyLinearVelocity.Z) end
    end)
    notify("AntiFall: " .. (S.AntiFall and "ON" or "OFF"), S.AntiFall)
end)
reg("unantifall", "/unantifall", "Matikan AntiFall", function() H.antifall(false) end)

reg("hipheight", "/hipheight [num]", "Tinggi terapung badan", function(a)
    local n = tonumber(a)
    if n then S.HHVal = math.clamp(n, -5, 100); S.HHOn = true else S.HHOn = not S.HHOn; if S.HHOn then S.HHVal = 8 end end
    loop("HH", S.HHOn, RS.Heartbeat, function() local h = getHum(); if h then h.HipHeight = S.HHVal end end)
    if not S.HHOn then local h = getHum(); if h then h.HipHeight = 2 end end
    notify(S.HHOn and ("HipHeight: " .. S.HHVal) or "HipHeight: 2", S.HHOn)
end)
reg("unhipheight", "/unhipheight", "Kembalikan HipHeight asal (2)", function() S.HHOn = true; H.hipheight(nil) end)

reg("noclip", "/noclip", "Tembus dinding & objek", function(f)
    S.Noclip = (f ~= nil) and f or not S.Noclip
    loop("NC", S.Noclip, RS.Stepped, function() local c = getChar(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end end)
    notify("Noclip: " .. (S.Noclip and "ON" or "OFF"), S.Noclip)
end)
reg("unnoclip", "/unnoclip", "Matikan Noclip", function() H.noclip(false) end)

reg("freeze", "/freeze", "Bekukan posisi karakter di udara", function() local r = getRoot(); if r then r.Anchored = true; notify("Frozen.", true) end end)
reg("unfreeze", "/unfreeze", "Nyahbeku posisi karakter", function() local r = getRoot(); if r then r.Anchored = false; notify("Unfrozen.", false) end end)
reg("sit", "/sit", "Duduk di tempat semasa", function() local h = getHum(); if h then h.Sit = true; notify("Sit: ON", true) end end)
reg("lay", "/lay", "Baringkan karakter di lantai", function() local r, h = getRoot(), getHum(); if r and h then h.Sit = true; task.wait(); r.CFrame = r.CFrame * CFrame.Angles(math.rad(-90), 0, 0); notify("Lay: ON", true) end end)
reg("handstand", "/handstand", "Terbalikkan badan berdiri atas tangan", function() local r, h = getRoot(), getHum(); if r and h then h.PlatformStand = true; r.CFrame = r.CFrame * CFrame.Angles(math.rad(180), 0, 0); notify("Handstand: ON", true) end end)
reg("trip", "/trip", "Jatuhkan karakter ragdoll sementara", function()
    local r, h = getRoot(), getHum()
    if r and h then h:ChangeState(Enum.HumanoidStateType.Physics); r.AssemblyAngularVelocity = r.CFrame.RightVector * -18; notify("Tripped!", true); task.delay(1.5, function() local ch = getHum(); if ch then ch:ChangeState(Enum.HumanoidStateType.GettingUp) end end) end
end)
reg("flashback", "/flashback [saat]", "Undur masa & posisi ke belakang", function(a)
    if S.Rewind then return end
    local r = getRoot(); if not r or #Cache.Hist < 2 then notify("Tiada rekod.", false); return end
    local sec = math.clamp(tonumber(a) or 3, 1, 15); local fr = math.min(#Cache.Hist, math.floor(sec / 0.15))
    S.Rewind = true; notify("Flashback (" .. sec .. "s)...", true)
    task.spawn(function()
        for _ = 1, fr do
            if not S.Rewind then break end
            local cf = table.remove(Cache.Hist); local cr = getRoot()
            if cf and cr then cr.AssemblyLinearVelocity = Vector3.zero; cr.CFrame = cf else break end
            task.wait(0.025)
        end
        S.Rewind = false; notify("Flashback selesai.", false)
    end)
end)

reg("god", "/god", "Aktifkan God Mode client", function()
    S.God = true; local h = getHum()
    if h then
        pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Dead, false); h.MaxHealth = math.huge; h.Health = math.huge end)
        loop("God", true, h.HealthChanged, function() if S.God and h then h.MaxHealth = math.huge; h.Health = math.huge end end)
    end
    notify("God Mode: ON", true)
end)
reg("ungod", "/ungod", "Matikan God Mode", function()
    S.God = false; loop("God", false); local h = getHum()
    if h then pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Dead, true); h.MaxHealth = 100; h.Health = 100 end) end
    notify("God Mode: OFF", false)
end)

reg("antistun", "/antistun", "Elak ragdoll & stun", function(f)
    S.AntiStun = (f ~= nil) and f or not S.AntiStun
    loop("Stun", S.AntiStun, RS.Heartbeat, function()
        local h = getHum(); if h then h.PlatformStand = S.Fly; if h:GetState() == Enum.HumanoidStateType.Ragdoll or h:GetState() == Enum.HumanoidStateType.FallingDown then h:ChangeState(Enum.HumanoidStateType.GettingUp) end end
    end)
    notify("AntiStun: " .. (S.AntiStun and "ON" or "OFF"), S.AntiStun)
end)
reg("unantistun", "/unantistun", "Matikan AntiStun", function() H.antistun(false) end)
reg("autospawn", "/autospawn", "Respawn semula di tempat mati", function() S.AutoSpawn = not S.AutoSpawn; notify("AutoSpawn: " .. (S.AutoSpawn and "ON" or "OFF"), S.AutoSpawn) end)

reg("ghost", "/ghost", "Karakter lutsinar perak", function(f)
    S.Ghost = (f ~= nil) and f or not S.Ghost; local c = getChar()
    if c then for _, o in ipairs(c:GetDescendants()) do if o:IsA("BasePart") and o.Name ~= "HumanoidRootPart" then o.LocalTransparencyModifier = S.Ghost and 0.72 or 0 elseif o:IsA("Decal") then o.Transparency = S.Ghost and 0.72 or 0 end end end
    notify("Ghost: " .. (S.Ghost and "ON" or "OFF"), S.Ghost)
end)
reg("unghost", "/unghost", "Matikan mod Ghost", function() H.ghost(false) end)

reg("headless", "/headless", "Kepala halimunan gaya Headless", function(f)
    local c = getChar(); local hd = c and c:FindFirstChild("Head")
    if hd then local on = (f ~= nil) and f or (hd.Transparency < 1); hd.Transparency = on and 1 or 0; for _, d in ipairs(hd:GetDescendants()) do if d:IsA("Decal") then d.Transparency = on and 1 or 0 end end; notify("Headless: " .. (on and "ON" or "OFF"), on) end
end)
reg("unheadless", "/unheadless", "Kembalikan kepala asal", function() H.headless(false) end)

reg("korblox", "/korblox", "Kaki kanan halimunan Korblox", function(f)
    local c = getChar(); if not c then return end; local on = f
    for _, n in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
        local p = c:FindFirstChild(n); if p and p:IsA("BasePart") then if on == nil then on = (p.Transparency < 1) end; p.Transparency = on and 1 or 0 end
    end
    notify("Korblox: " .. (on and "ON" or "OFF"), on)
end)
reg("unkorblox", "/unkorblox", "Kembalikan kaki kanan asal", function() H.korblox(false) end)

local function setMat(m, col, lb)
    local c = getChar(); if not c then return end
    for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Material = m; if col then p.Color = col end end end
    notify(lb, true)
end
reg("neonchar", "/neonchar", "Badan Neon Perak", function() setMat(Enum.Material.Neon, C3(235, 240, 250), "Neon Body: ON") end)
reg("unneonchar", "/unneonchar", "Kembalikan bahan badan asal", function() setMat(Enum.Material.SmoothPlastic, nil, "Body Material: Reset") end)
reg("glasschar", "/glasschar", "Badan kaca lutsinar", function() setMat(Enum.Material.Glass, nil, "Glass Body: ON") end)
reg("unglasschar", "/unglasschar", "Matikan Glass Body", function() H.unneonchar() end)
reg("forcefield", "/forcefield", "Badan ForceField", function() setMat(Enum.Material.ForceField, C3(220, 225, 240), "ForceField Body: ON") end)
reg("unforcefield", "/unforcefield", "Matikan ForceField Body", function() H.unneonchar() end)
reg("nohats", "/nohats", "Tanggalkan semua aksesori", function() local c = getChar(); if c then for _, a in ipairs(c:GetChildren()) do if a:IsA("Accessory") then a:Destroy() end end; notify("Hats removed.", true) end end)
reg("naked", "/naked", "Tanggalkan pakaian luar", function() local c = getChar(); if c then for _, o in ipairs(c:GetChildren()) do if o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") then o:Destroy() end end; notify("Clothes removed.", true) end end)
reg("animspeed", "/animspeed [num]", "Kelajuan animasi berjalan", function(a) local s = math.clamp(tonumber(a) or 2, 0, 20); local h = getHum(); local an = h and h:FindFirstChildOfClass("Animator"); if an then for _, t in ipairs(an:GetPlayingAnimationTracks()) do t:AdjustSpeed(s) end end; notify("AnimSpeed: " .. s, true) end)
reg("noanim", "/noanim", "T-Pose / matikan animasi", function() local c = getChar(); local a = c and c:FindFirstChild("Animate"); if a then a.Disabled = true; notify("NoAnim: ON", true) end end)
reg("reanim", "/reanim", "Pulihkan animasi karakter", function() local c = getChar(); local a = c and c:FindFirstChild("Animate"); if a then a.Disabled = false; notify("Anim Restored.", false) end end)
reg("gravity", "/gravity [num]", "Tukar graviti dunia", function(a) local g = tonumber(a) or 196.2; WS.Gravity = g; notify("Gravity: " .. g, true) end)
reg("ungravity", "/ungravity", "Kembalikan graviti asal (196.2)", function() WS.Gravity = 196.2; notify("Gravity: 196.2", false) end)
reg("reset", "/reset", "Respawn karakter", function() local h = getHum(); if h then h.Health = 0 end end)
reg("godall", "/godall", "God + AntiStun + AntiFling + AntiVoid", function() H.god(); H.antistun(true); H.antifling(true); H.antivoid(true); notify("GODALL Active!", true) end)

-- Base, Waypoints & Teleport
reg("setbase", "/setbase", "Simpan koordinat base utama", function()
    local r = getRoot(); if not r then return end
    S.BaseCF = r.CFrame; if S.BaseMark then S.BaseMark:Destroy() end
    S.BaseMark = new("Part", {Size = V3(4.5, 0.25, 4.5), CFrame = r.CFrame * CF(0, -2.8, 0), Anchored = true, CanCollide = false, Material = Enum.Material.Neon, Color = C3(235, 238, 245), Transparency = 0.4}, WS)
    notify(string.format("Base Saved: [%.0f,%.0f,%.0f]", r.Position.X, r.Position.Y, r.Position.Z), true)
end)
reg("base", "/base", "Teleport pulang ke Saved Base", function() local r = getRoot(); if r and S.BaseCF then r.AssemblyLinearVelocity = Vector3.zero; r.CFrame = S.BaseCF + V3(0, 2, 0); notify("TP Saved Base.", true) else notify("Guna /setbase dulu.", false) end end)
reg("tweenbase", "/tweenbase", "Meluncur Tween ke Saved Base", function() local r = getRoot(); if r and S.BaseCF then local cf = S.BaseCF + V3(0, 2, 0); TS:Create(r, TweenInfo.new(math.clamp((cf.Position - r.Position).Magnitude / 220, 0.15, 4), Enum.EasingStyle.Linear), {CFrame = cf}):Play(); notify("Tweening Base...", true) end end)
reg("setwp", "/setwp [nama]", "Simpan waypoint", function(a) local r = getRoot(); local n = a or "1"; if r then S.WP[n:lower()] = r.CFrame; notify("WP '" .. n .. "' saved.", true) end end)
reg("wp", "/wp [nama]", "Teleport ke waypoint", function(a) local r = getRoot(); local n = (a or "1"):lower(); if r and S.WP[n] then r.AssemblyLinearVelocity = Vector3.zero; r.CFrame = S.WP[n] + V3(0, 2, 0); notify("TP WP '" .. n .. "'", true) else notify("WP tiada.", false) end end)
reg("delwp", "/delwp [nama]", "Padam satu waypoint", function(a) S.WP[(a or "1"):lower()] = nil; notify("WP deleted.", false) end)
reg("listwp", "/listwp", "Papar senarai waypoint", function() local t = {}; for k in pairs(S.WP) do t[#t + 1] = k end; notify(#t > 0 and ("WPs: " .. table.concat(t, ", ")) or "Tiada WP.", #t > 0) end)
reg("clearwp", "/clearwp", "Padam semua waypoint", function() S.WP = {}; notify("All WPs cleared.", false) end)

reg("safezone", "/safezone", "Platform selamat di langit (Y+500)", function()
    local r = getRoot(); if not r then return end
    local pos = V3(r.Position.X, r.Position.Y + 500, r.Position.Z)
    local p = WS:FindFirstChild("CSafeZone") or new("Part", {Name = "CSafeZone", Size = V3(24, 1, 24), Anchored = true, CanCollide = true, Material = Enum.Material.ForceField, Color = C3(220, 225, 235), Transparency = 0.45}, WS)
    p.CFrame = CF(pos - V3(0, 3.5, 0)); r.AssemblyLinearVelocity = Vector3.zero; r.CFrame = CF(pos); notify("SafeZone (+500Y)", true)
end)
reg("ground", "/ground", "Turun terus ke lantai bawah", function()
    local c, r = getChar(), getRoot(); if not c or not r then return end
    local pr = RaycastParams.new(); pr.FilterType = Enum.RaycastFilterType.Exclude; pr.FilterDescendantsInstances = {c}
    local hit = WS:Raycast(r.Position, V3(0, -2000, 0), pr)
    if hit then r.AssemblyLinearVelocity = Vector3.zero; r.CFrame = CF(hit.Position + V3(0, 3.2, 0)); notify("Landed.", true) end
end)
reg("sky", "/sky [tinggi]", "Lancar tinggi ke udara", function(a) local r = getRoot(); local h = tonumber(a) or 250; if r then r.AssemblyLinearVelocity = Vector3.zero; r.CFrame = r.CFrame + V3(0, h, 0); notify("Sky +" .. h, true) end end)
reg("spawn", "/spawn", "Teleport ke SpawnLocation", function() local r = getRoot(); local sp = WS:FindFirstChildWhichIsA("SpawnLocation", true); if r and sp then r.CFrame = sp.CFrame + V3(0, 4, 0); notify("TP Spawn.", true) end end)
reg("highest", "/highest", "TP ke pemain paling tinggi", function()
    local r = getRoot(); local b, my = nil, -math.huge
    for _, p in ipairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local y = p.Character.HumanoidRootPart.Position.Y; if y > my then b, my = p, y end end end
    if r and b then r.CFrame = b.Character.HumanoidRootPart.CFrame * CF(0, 0, 3); notify("Highest: " .. b.DisplayName, true) end
end)
reg("lowest", "/lowest", "TP ke pemain paling rendah", function()
    local r = getRoot(); local b, my = nil, math.huge
    for _, p in ipairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local y = p.Character.HumanoidRootPart.Position.Y; if y < my then b, my = p, y end end end
    if r and b then r.CFrame = b.Character.HumanoidRootPart.CFrame * CF(0, 0, 3); notify("Lowest: " .. b.DisplayName, true) end
end)
reg("nearest", "/nearest", "TP ke pemain paling dekat", function() local r = getRoot(); local p, d = nearestPlr(); if r and p and p.Character then r.CFrame = p.Character.HumanoidRootPart.CFrame * CF(0, 0, 3); notify("Nearest: " .. p.DisplayName .. " (" .. math.floor(d) .. "m)", true) end end)
reg("farthest", "/farthest", "TP ke pemain paling jauh", function()
    local r = getRoot(); if not r then return end; local b, md = nil, -1
    for _, p in ipairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local d = (p.Character.HumanoidRootPart.Position - r.Position).Magnitude; if d > md then b, md = p, d end end end
    if b then r.CFrame = b.Character.HumanoidRootPart.CFrame * CF(0, 0, 3); notify("Farthest: " .. b.DisplayName, true) end
end)

reg("clicktp", "/clicktp", "Ctrl+Klik / Sentuh untuk TP", function(f)
    S.ClickTP = (f ~= nil) and f or not S.ClickTP
    loop("CTP", S.ClickTP, UIS.InputBegan, function(i, gp)
        if gp then return end
        if (i.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl)) or i.UserInputType == Enum.UserInputType.Touch then
            local r = getRoot(); if r and Mouse.Hit then r.AssemblyLinearVelocity = Vector3.zero; r.CFrame = CF(Mouse.Hit.Position + V3(0, 3.2, 0)) end
        end
    end)
    notify("ClickTP: " .. (S.ClickTP and "ON" or "OFF"), S.ClickTP)
end)
reg("unclicktp", "/unclicktp", "Matikan ClickTP", function() H.clicktp(false) end)

reg("coords", "/coords", "Papar koordinat X Y Z", function() local r = getRoot(); if r then notify(string.format("%.1f, %.1f, %.1f", r.Position.X, r.Position.Y, r.Position.Z), true) end end)
reg("copycoords", "/copycoords", "Salin CFrame ke clipboard", function() local r = getRoot(); if r then local s = string.format("CFrame.new(%.2f,%.2f,%.2f)", r.Position.X, r.Position.Y, r.Position.Z); pcall(function() if typeof(setclipboard) == "function" then setclipboard(s) end end); notify("Copied: " .. s, true) end end)
reg("tpcoords", "/tpcoords [x] [y] [z]", "TP ke koordinat tepat", function(a, b, c) local r = getRoot(); local x, y, z = tonumber(a), tonumber(b), tonumber(c); if r and x and y and z then r.CFrame = CF(x, y, z); notify("TP Coords", true) end end)
reg("walkto", "/walkto [x] [y] [z]", "Jalan automatik ke koordinat", function(a, b, c) local h = getHum(); local x, y, z = tonumber(a), tonumber(b), tonumber(c); if h and x and y and z then h:MoveTo(V3(x, y, z)); notify("Walking...", true) end end)
reg("walktoplr", "/walktoplr [player]", "Kejar pemain automatik", function(a)
    local t = findPlr(a); if not t then return end
    loop("WalkP", true, RS.Heartbeat, function() local h = getHum(); local tr = t.Character and t.Character:FindFirstChild("HumanoidRootPart"); if h and tr then h:MoveTo(tr.Position) end end)
    notify("WalkTo: " .. t.DisplayName, true)
end)
reg("cancelwalk", "/cancelwalk", "Henti jalan automatik", function() loop("WalkP", false); local r, h = getRoot(), getHum(); if r and h then h:MoveTo(r.Position) end; notify("Walk cancelled.", false) end)
reg("tp", "/tp [player]", "Teleport ke pemain", function(a) local t = findPlr(a); local r = getRoot(); if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and r then r.CFrame = t.Character.HumanoidRootPart.CFrame * CF(0, 0, 3); notify("TP: " .. t.DisplayName, true) end end); H.to = H.tp
reg("tweentp", "/tweentp [player]", "Meluncur Tween ke pemain", function(a) local t = findPlr(a); local r = getRoot(); if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and r then local cf = t.Character.HumanoidRootPart.CFrame * CF(0, 0, 3); TS:Create(r, TweenInfo.new(math.clamp((cf.Position - r.Position).Magnitude / 220, 0.15, 4), Enum.EasingStyle.Linear), {CFrame = cf}):Play(); notify("Tweening...", true) end end)
reg("bring", "/bring [player]", "Tarik pemain ke hadapan (Client)", function(a) local t = findPlr(a); local r = getRoot(); if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and r then t.Character.HumanoidRootPart.CFrame = r.CFrame * CF(0, 0, -4); notify("Brought " .. t.DisplayName, true) end end)

local function targetLoop(key, plrName, fn, label)
    local t = findPlr(plrName); if not t then notify("Pemain tiada.", false); return end
    S[key] = t
    loop(key, true, RS.Heartbeat, function(dt)
        if not S[key] or not S[key].Character then loop(key, false); return end
        local tr, mr = S[key].Character:FindFirstChild("HumanoidRootPart"), getRoot()
        if tr and mr then fn(tr, mr, S[key].Character, dt) end
    end)
    notify(label .. ": " .. t.DisplayName, true)
end
reg("loopbring", "/loopbring [player]", "Tarik pemain berterusan", function(a) targetLoop("Bring", a, function(tr, mr) tr.AssemblyLinearVelocity = Vector3.zero; tr.CFrame = mr.CFrame * CF(0, 0, -4) end, "LoopBring") end)
reg("unloopbring", "/unloopbring", "Matikan LoopBring", function() S.Bring = nil; loop("Bring", false); notify("LoopBring: OFF", false) end)
reg("stare", "/stare [player]", "Kunci arah hadap pemain", function(a) targetLoop("Stare", a, function(tr, mr) mr.CFrame = CF(mr.Position, V3(tr.Position.X, mr.Position.Y, tr.Position.Z)) end, "Stare") end)
reg("unstare", "/unstare", "Matikan Stare", function() S.Stare = nil; loop("Stare", false); notify("Stare: OFF", false) end)
reg("follow", "/follow [player]", "Ikut belakang pemain", function(a) targetLoop("Follow", a, function(tr, mr) mr.AssemblyLinearVelocity = Vector3.zero; mr.CFrame = tr.CFrame * CF(0, 0, 4.5) end, "Follow") end)
reg("unfollow", "/unfollow", "Matikan Follow", function() S.Follow = nil; loop("Follow", false); notify("Follow: OFF", false) end)
reg("headsit", "/headsit [player]", "Duduk atas kepala pemain", function(a) targetLoop("Headsit", a, function(_, mr, tc) local hd, h = tc:FindFirstChild("Head"), getHum(); if hd and h then h.Sit = true; mr.AssemblyLinearVelocity = Vector3.zero; mr.CFrame = hd.CFrame * CF(0, 1.6, 0) end end, "Headsit") end)
reg("unheadsit", "/unheadsit", "Matikan Headsit", function() S.Headsit = nil; loop("Headsit", false); local h = getHum(); if h then h.Sit = false end; notify("Headsit: OFF", false) end)
reg("attach", "/attach [player]", "Melekat belakang pemain", function(a) targetLoop("Attach", a, function(tr, mr) mr.AssemblyLinearVelocity = Vector3.zero; mr.CFrame = tr.CFrame * CF(0, 0, 2.2) end, "Attach") end)
reg("unattach", "/unattach", "Matikan Attach", function() S.Attach = nil; loop("Attach", false); notify("Attach: OFF", false) end)
reg("carpet", "/carpet [player]", "Jadi permaidani bawah kaki", function(a) targetLoop("Carpet", a, function(tr, mr) mr.AssemblyLinearVelocity = Vector3.zero; mr.CFrame = tr.CFrame * CF(0, -3.2, 0) * CFrame.Angles(math.rad(-90), 0, 0) end, "Carpet") end)
reg("uncarpet", "/uncarpet", "Matikan Carpet", function() S.Carpet = nil; loop("Carpet", false); notify("Carpet: OFF", false) end)
reg("backpack", "/backpack [player]", "Jadi beg galas pemain", function(a) targetLoop("Backpack", a, function(tr, mr) local h = getHum(); if h then h.Sit = true; mr.AssemblyLinearVelocity = Vector3.zero; mr.CFrame = tr.CFrame * CF(0, 0.5, 1.4) end end, "Backpack") end)
reg("unbackpack", "/unbackpack", "Matikan Backpack", function() S.Backpack = nil; loop("Backpack", false); local h = getHum(); if h then h.Sit = false end; notify("Backpack: OFF", false) end)

reg("stealth", "/stealth", "Ghost + Noclip + Trail serentak", function() H.ghost(true); H.noclip(true); H.trail(true); notify("STEALTH Active!", true) end)
reg("view", "/view [player]", "Intai kamera pemain", function(a) local t = findPlr(a); if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then Cam.CameraSubject = t.Character:FindFirstChildOfClass("Humanoid"); notify("View: " .. t.DisplayName, true) end end)
reg("viewnext", "/viewnext", "Intai kamera pemain seterusnya", function()
    local t = {}; for _, p in ipairs(Plrs:GetPlayers()) do if p ~= LP then t[#t + 1] = p end end
    if #t > 0 then S.ViewIdx = (S.ViewIdx % #t) + 1; local p = t[S.ViewIdx]; if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then Cam.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid"); notify("View [" .. S.ViewIdx .. "/" .. #t .. "]: " .. p.DisplayName, true) end end
end)
reg("unview", "/unview", "Pulihkan kamera ke diri sendiri", function() local h = getHum(); if h then Cam.CameraSubject = h; notify("View: Reset", false) end end)

reg("orbit", "/orbit [player] [spd]", "Mengelilingi pemain", function(a, b)
    local t = findPlr(a); if not t then return end
    if b and tonumber(b) then S.OrbitSpd = math.clamp(tonumber(b), 1, 20) end
    S.Orbit = true; S.OrbitT = t; local ang = 0
    loop("Orbit", true, RS.Heartbeat, function(dt)
        if not S.Orbit or not S.OrbitT or not S.OrbitT.Character then loop("Orbit", false); return end
        local tr, mr = S.OrbitT.Character:FindFirstChild("HumanoidRootPart"), getRoot()
        if tr and mr then ang = ang + S.OrbitSpd * dt; mr.AssemblyLinearVelocity = Vector3.zero; mr.CFrame = CF(tr.Position + V3(math.cos(ang) * S.OrbitRad, 1.5, math.sin(ang) * S.OrbitRad), tr.Position) end
    end)
    notify("Orbit: " .. t.DisplayName, true)
end)
reg("unorbit", "/unorbit", "Matikan Orbit", function() S.Orbit = false; loop("Orbit", false); notify("Orbit: OFF", false) end)
reg("circle", "/circle [radius]", "Tukar jejari orbit", function(a) S.OrbitRad = math.clamp(tonumber(a) or 7, 2, 50); notify("Orbit Radius: " .. S.OrbitRad, true) end)

reg("copyavatar", "/copyavatar [player]", "Salin pakaian pemain", function(a)
    local t = findPlr(a); local c = getChar(); if not t or not t.Character or not c then return end
    for _, o in ipairs(c:GetChildren()) do if o:IsA("Shirt") or o:IsA("Pants") or o:IsA("BodyColors") then o:Destroy() end end
    for _, o in ipairs(t.Character:GetChildren()) do if o:IsA("Shirt") or o:IsA("Pants") or o:IsA("BodyColors") then o:Clone().Parent = c end end
    notify("Copied avatar: " .. t.DisplayName, true)
end)
reg("plrinfo", "/plrinfo [player]", "Info ID, umur akaun & jarak", function(a)
    local t = findPlr(a); local mr = getRoot(); if not t then return end
    local d = (mr and t.Character and t.Character:FindFirstChild("HumanoidRootPart")) and math.floor((mr.Position - t.Character.HumanoidRootPart.Position).Magnitude) or 0
    notify(string.format("%s (@%s) | ID:%d | Age:%dd | %dm", t.DisplayName, t.Name, t.UserId, t.AccountAge, d), true)
end)
reg("plrcount", "/plrcount", "Senarai semua pemain server", function() local t = {}; for _, p in ipairs(Plrs:GetPlayers()) do t[#t + 1] = p.DisplayName end; notify("Players (" .. #t .. "): " .. table.concat(t, ", "), true) end)

reg("antiaim", "/antiaim", "Pusing badan rawak elak sasaran", function(f)
    S.AntiAim = (f ~= nil) and f or not S.AntiAim
    loop("AA", S.AntiAim, RS.RenderStepped, function() local r = getRoot(); if r then r.CFrame = CF(r.Position) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0) end end)
    notify("AntiAim: " .. (S.AntiAim and "ON" or "OFF"), S.AntiAim)
end)
reg("unantiaim", "/unantiaim", "Matikan AntiAim", function() H.antiaim(false) end)

reg("aimlock", "/aimlock", "Kunci kamera sasaran Right-Click", function(f)
    S.Aimlock = (f ~= nil) and f or not S.Aimlock
    loop("Aim", S.Aimlock, RS.RenderStepped, function()
        if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local p = nearestPlr(); if p and p.Character and p.Character:FindFirstChild("Head") then Cam.CFrame = CF(Cam.CFrame.Position, p.Character.Head.Position) end
        end
    end)
    notify("Aimlock (RightClick): " .. (S.Aimlock and "ON" or "OFF"), S.Aimlock)
end)
reg("unaimlock", "/unaimlock", "Matikan Aimlock", function() H.aimlock(false) end)

reg("hitbox", "/hitbox [size]", "Besarkan hitbox pemain", function(a)
    if a and tonumber(a) then S.HBSize = math.clamp(tonumber(a), 2, 60); S.Hitbox = true else S.Hitbox = not S.Hitbox end
    loop("HB", S.Hitbox, RS.Heartbeat, function()
        for _, p in ipairs(Plrs:GetPlayers()) do
            if p ~= LP and isEnemy(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart; hrp.Size = V3(S.HBSize, S.HBSize, S.HBSize); hrp.Transparency = 0.78; hrp.Color = S.ESPCol; hrp.Material = Enum.Material.Neon; hrp.CanCollide = false
            end
        end
    end)
    if not S.Hitbox then for _, p in ipairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Size = V3(2, 2, 1); p.Character.HumanoidRootPart.Transparency = 1 end end end
    notify(S.Hitbox and ("Hitbox: " .. S.HBSize) or "Hitbox: OFF", S.Hitbox)
end)
reg("unhitbox", "/unhitbox", "Matikan Hitbox Expander", function() S.Hitbox = true; H.hitbox(nil) end)

reg("reach", "/reach [size]", "Besarkan jangkauan senjata", function(a)
    local sz = math.clamp(tonumber(a) or 15, 2, 60); local c = getChar(); local t = c and c:FindFirstChildOfClass("Tool"); local hd = t and t:FindFirstChild("Handle")
    if hd and hd:IsA("BasePart") then if not Cache.Reach[hd] then Cache.Reach[hd] = hd.Size end; hd.Size = V3(sz, sz, sz); hd.Transparency = 0.6; hd.Massless = true; notify("Reach: " .. sz, true) else notify("Pegang Tool dulu.", false) end
end)
reg("unreach", "/unreach", "Kembalikan jangkauan senjata asal", function() for h, o in pairs(Cache.Reach) do if h and h.Parent then h.Size = o; h.Transparency = 0 end end; Cache.Reach = {}; notify("Reach: Reset", false) end)
reg("grip", "/grip [x] [y] [z]", "Ubah posisi genggaman senjata", function(a, b, c) local ch = getChar(); local t = ch and ch:FindFirstChildOfClass("Tool"); if t then t.GripPos = V3(tonumber(a) or 0, tonumber(b) or 0, tonumber(c) or 0); notify("Grip updated.", true) end end)
reg("equiptools", "/equiptools", "Pegang semua alatan Backpack", function() local bp, c = LP:FindFirstChildOfClass("Backpack"), getChar(); if bp and c then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then t.Parent = c end end; notify("Equipped all.", true) end end)
reg("droptools", "/droptools", "Jatuhkan semua alatan", function() local c = getChar(); if c then for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then t.Parent = WS end end; notify("Dropped tools.", true) end end)
reg("toolcount", "/toolcount", "Senarai alatan dalam Backpack", function() local bp = LP:FindFirstChildOfClass("Backpack"); local t = {}; if bp then for _, o in ipairs(bp:GetChildren()) do if o:IsA("Tool") then t[#t + 1] = o.Name end end end; notify("Tools (" .. #t .. "): " .. table.concat(t, ", "), true) end)
reg("autoswing", "/autoswing", "Serang alatan berterusan", function(f)
    S.AutoSwing = (f ~= nil) and f or not S.AutoSwing
    loop("Swing", S.AutoSwing, RS.Heartbeat, function() local c = getChar(); local t = c and c:FindFirstChildOfClass("Tool"); if t then t:Activate() end end)
    notify("AutoSwing: " .. (S.AutoSwing and "ON" or "OFF"), S.AutoSwing)
end)
reg("unautoswing", "/unautoswing", "Matikan AutoSwing", function() H.autoswing(false) end)

reg("spin", "/spin [speed]", "Pusingkan karakter", function(a)
    if a and tonumber(a) then S.SpinSpd = math.clamp(tonumber(a), 1, 200); S.Spin = true else S.Spin = not S.Spin end
    loop("Spin", S.Spin, RS.Heartbeat, function() local r = getRoot(); if r then r.AssemblyAngularVelocity = V3(0, S.SpinSpd, 0) end end)
    if not S.Spin then local r = getRoot(); if r then r.AssemblyAngularVelocity = Vector3.zero end end
    notify(S.Spin and ("Spin: " .. S.SpinSpd) or "Spin: OFF", S.Spin)
end)
reg("unspin", "/unspin", "Matikan Spin", function() S.Spin = true; H.spin(nil) end)

reg("fling", "/fling", "Aktifkan spin fling", function(f)
    S.Fling = (f ~= nil) and f or not S.Fling
    loop("Fling", S.Fling, RS.Heartbeat, function() local r = getRoot(); if r then r.AssemblyAngularVelocity = V3(0, 9999, 0) end end)
    if not S.Fling then local r = getRoot(); if r then r.AssemblyAngularVelocity = Vector3.zero end end
    notify("Fling: " .. (S.Fling and "ON" or "OFF"), S.Fling)
end)
reg("unfling", "/unfling", "Matikan Spin Fling", function() H.fling(false) end)

reg("walkfling", "/walkfling", "Fling pemain bila bersentuhan", function(f)
    S.WalkFling = (f ~= nil) and f or not S.WalkFling
    loop("WFling", S.WalkFling, RS.Heartbeat, function() local r = getRoot(); if r then local v = r.Velocity; r.Velocity = v * 10000 + V3(0, 10000, 0); RS.RenderStepped:Wait(); if r and r.Parent then r.Velocity = v end end end)
    notify("WalkFling: " .. (S.WalkFling and "ON" or "OFF"), S.WalkFling)
end)
reg("unwalkfling", "/unwalkfling", "Matikan WalkFling", function() H.walkfling(false) end)

reg("antifling", "/antifling", "Elak dilanggar pemain lain", function(f)
    S.AntiFling = (f ~= nil) and f or not S.AntiFling
    loop("AFling", S.AntiFling, RS.Stepped, function()
        for _, p in ipairs(Plrs:GetPlayers()) do if p ~= LP and p.Character then for _, pt in ipairs(p.Character:GetDescendants()) do if pt:IsA("BasePart") then pt.CanCollide = false end end end end
    end)
    notify("AntiFling: " .. (S.AntiFling and "ON" or "OFF"), S.AntiFling)
end)
reg("unantifling", "/unantifling", "Matikan AntiFling", function() H.antifling(false) end)

-- Steal, Prompts, Farm & World
reg("steal", "/steal", "Instant steal item berdekatan", function() Eng.PromptsRange(false) end)
reg("stealbase", "/stealbase", "Instant steal & balik Saved Base", function() Eng.PromptsRange(true) end)
reg("range", "/range [studs]", "Tetapkan jarak interaksi", function(a) S.Range = math.clamp(tonumber(a) or 25, 5, 250); notify("Range: " .. S.Range, true) end)
reg("autosteal", "/autosteal", "Auto kutip item dalam jarak", function(f)
    S.AutoSteal = (f ~= nil) and f or not S.AutoSteal
    loop("ASteal", S.AutoSteal, RS.Heartbeat, function() Eng.PromptsRange(false) end)
    notify("AutoSteal: " .. (S.AutoSteal and "ON" or "OFF"), S.AutoSteal)
end)
reg("unautosteal", "/unautosteal", "Matikan AutoSteal", function() H.autosteal(false) end)
reg("autoprompt", "/autoprompt", "Auto aktifkan prompt dalam jarak", function(f) H.autosteal(f) end)
reg("unautoprompt", "/unautoprompt", "Matikan AutoPrompt", function() H.autosteal(false) end)

reg("spamprompt", "/spamprompt", "Spam interaksi prompt", function(f)
    S.SpamPrompt = (f ~= nil) and f or not S.SpamPrompt
    loop("SPrompt", S.SpamPrompt, RS.RenderStepped, function() Eng.PromptsRange(false) end)
    notify("SpamPrompt: " .. (S.SpamPrompt and "ON" or "OFF"), S.SpamPrompt)
end)
reg("unspamprompt", "/unspamprompt", "Matikan SpamPrompt", function() H.spamprompt(false) end)

reg("instantprompt", "/instantprompt", "Semua interaksi 0s hold", function(f)
    S.InstPrompt = (f ~= nil) and f or not S.InstPrompt
    if S.InstPrompt then for _, o in ipairs(WS:GetDescendants()) do if o:IsA("ProximityPrompt") then o.HoldDuration = 0 end end end
    loop("IPrompt", S.InstPrompt, WS.DescendantAdded, function(o) if S.InstPrompt and o:IsA("ProximityPrompt") then o.HoldDuration = 0 end end)
    notify("InstantPrompt: " .. (S.InstPrompt and "ON" or "OFF"), S.InstPrompt)
end)
reg("uninstantprompt", "/uninstantprompt", "Matikan InstantPrompt", function() H.instantprompt(false) end)

reg("firetouch", "/firetouch", "Cetuskan semua Touch pad peta", function() Eng.TouchAll(false) end)
reg("collect", "/collect", "Kumpul semua Coin/Cash/Gem/Orb", function() Eng.TouchAll(true) end)
reg("autocollect", "/autocollect", "Kumpul Coin/Drop berterusan", function(f)
    S.AutoCollect = (f ~= nil) and f or not S.AutoCollect
    if S.AutoCollect then task.spawn(function() while S.AutoCollect do Eng.TouchAll(true); task.wait(0.6) end end) end
    notify("AutoCollect: " .. (S.AutoCollect and "ON" or "OFF"), S.AutoCollect)
end)
reg("unautocollect", "/unautocollect", "Matikan AutoCollect", function() H.autocollect(false) end)

reg("clickdetectors", "/clickdetectors", "Klik semua ClickDetector dekat", function()
    local r = getRoot(); if not r or typeof(fireclickdetector) ~= "function" then return end
    local c = 0
    for _, o in ipairs(WS:GetDescendants()) do
        if o:IsA("ClickDetector") and o.Parent and o.Parent:IsA("BasePart") and (o.Parent.Position - r.Position).Magnitude <= 45 then
            pcall(function() fireclickdetector(o); c = c + 1 end)
        end
    end
    notify("Fired " .. c .. " ClickDetectors.", c > 0)
end)
reg("autoclickdet", "/autoclickdet", "Auto klik ClickDetector", function(f)
    S.AutoCD = (f ~= nil) and f or not S.AutoCD
    if S.AutoCD then task.spawn(function() while S.AutoCD do H.clickdetectors(); task.wait(0.4) end end) end
    notify("AutoClickDet: " .. (S.AutoCD and "ON" or "OFF"), S.AutoCD)
end)
reg("unautoclickdet", "/unautoclickdet", "Matikan AutoClickDet", function() H.autoclickdet(false) end)

reg("clickdel", "/clickdel", "Klik dinding untuk padam client", function(f)
    S.ClickDel = (f ~= nil) and f or not S.ClickDel
    loop("CDel", S.ClickDel, UIS.InputBegan, function(i, gp)
        if gp then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local t = Mouse.Target; local c = getChar()
            if t and t:IsA("BasePart") and (not c or not t:IsDescendantOf(c)) then Cache.Del[#Cache.Del + 1] = {P = t, Par = t.Parent}; t.Parent = nil; notify("Deleted (" .. #Cache.Del .. ")", true) end
        end
    end)
    notify("ClickDel: " .. (S.ClickDel and "ON" or "OFF"), S.ClickDel)
end)
reg("unclickdel", "/unclickdel", "Matikan ClickDel", function() H.clickdel(false) end)

reg("undel", "/undel", "Pulihkan bahagian peta dipadam", function() local e = table.remove(Cache.Del); if e and e.P then e.P.Parent = e.Par or WS; notify("Restored (" .. #Cache.Del .. ")", true) else notify("Tiada part.", false) end end)
reg("btools", "/btools", "Tambah Delete & Blink TP ke Backpack", function()
    local bp = LP:FindFirstChildOfClass("Backpack"); if not bp then return end
    local d = new("Tool", {Name = "CHELSEAA Delete", RequiresHandle = false}, bp)
    d.Activated:Connect(function() local t = Mouse.Target; local c = getChar(); if t and t:IsA("BasePart") and (not c or not t:IsDescendantOf(c)) then Cache.Del[#Cache.Del + 1] = {P = t, Par = t.Parent}; t.Parent = nil end end)
    local tp = new("Tool", {Name = "CHELSEAA Blink TP", RequiresHandle = false}, bp)
    tp.Activated:Connect(function() local r = getRoot(); if r and Mouse.Hit then r.CFrame = CF(Mouse.Hit.Position + V3(0, 3.2, 0)) end end)
    notify("Added BTools.", true)
end)
reg("unlockws", "/unlockws", "Buka kunci semua bahagian Workspace", function() local n = 0; for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") and o.Locked then o.Locked = false; n = n + 1 end end; notify("Unlocked " .. n, true) end)
reg("hidewalls", "/hidewalls", "Sembunyikan dinding halangan lutsinar", function() local n = 0; for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") and o.Transparency > 0.1 and o.Transparency < 0.95 and o.CanCollide then o.CanCollide = false; o.Transparency = 0.95; n = n + 1 end end; notify("Hidden " .. n .. " walls.", true) end)
reg("autoclick", "/autoclick [ms]", "Auto klik/tap skrin", function(a)
    if a and tonumber(a) then S.ClickDelay = math.clamp(tonumber(a) / 1000, 0.01, 5); S.AutoClick = true else S.AutoClick = not S.AutoClick end
    if S.AutoClick then task.spawn(function() while S.AutoClick do pcall(function() local vp = Cam.ViewportSize; VIM:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, true, game, 1); task.wait(0.01); VIM:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, false, game, 1) end); task.wait(S.ClickDelay) end end) end
    notify("AutoClick: " .. (S.AutoClick and "ON" or "OFF"), S.AutoClick)
end)
reg("unautoclick", "/unautoclick", "Matikan AutoClick", function() S.AutoClick = false; notify("AutoClick: OFF", false) end)

-- System, Audio & Server
reg("antivoid", "/antivoid", "Selamatkan diri jika jatuh gaung", function(f)
    S.AntiVoid = (f ~= nil) and f or not S.AntiVoid
    loop("AVoid", S.AntiVoid, RS.Heartbeat, function()
        local r = getRoot(); if not r then return end
        if r.Position.Y <= (WS.FallenPartsDestroyHeight or -500) + 18 then
            r.AssemblyLinearVelocity = Vector3.zero; r.CFrame = S.BaseCF and (S.BaseCF + V3(0, 3, 0)) or CF(r.Position.X, 60, r.Position.Z); notify("AntiVoid Saved!", true)
        end
    end)
    notify("AntiVoid: " .. (S.AntiVoid and "ON" or "OFF"), S.AntiVoid)
end)
reg("unantivoid", "/unantivoid", "Matikan AntiVoid", function() H.antivoid(false) end)

reg("antikick", "/antikick", "Sekat panggilan Kick client", function()
    if S.AntiKick then return end
    pcall(function() if typeof(hookmetamethod) == "function" then local old; old = hookmetamethod(game, "__namecall", function(self, ...) local m = getnamecallmethod and getnamecallmethod() or ""; if self == LP and (m == "Kick" or m == "kick") then return nil end; return old(self, ...) end) end end)
    S.AntiKick = true; notify("AntiKick: ON", true)
end)
reg("antiafk", "/antiafk", "Elak kick idle/AFK", function() S.AntiAFK = true; notify("AntiAFK: ON", true) end)
reg("unantiafk", "/unantiafk", "Matikan AntiAFK", function() S.AntiAFK = false; notify("AntiAFK: OFF", false) end)
reg("antiafk2", "/antiafk2", "Anti-AFK pergerakan mikro", function() S.AntiAFK = true; task.spawn(function() while S.AntiAFK do local h = getHum(); if h and h.MoveDirection.Magnitude == 0 then h:Move(V3(0.05, 0, 0), true) end; task.wait(45) end end); notify("AntiAFK2: ON", true) end)
reg("autorejoin", "/autorejoin", "Masuk semula jika terputus", function(f)
    S.AutoRejoin = (f ~= nil) and f or not S.AutoRejoin
    if S.AutoRejoin then
        pcall(function()
            local ov = CG:WaitForChild("RobloxPromptGui", 5):WaitForChild("promptOverlay", 5)
            loop("ARJ", true, ov.ChildAdded, function(c) if S.AutoRejoin and c.Name == "ErrorPrompt" then task.wait(1); TPS:Teleport(game.PlaceId, LP) end end)
        end)
    else loop("ARJ", false) end
    notify("AutoRejoin: " .. (S.AutoRejoin and "ON" or "OFF"), S.AutoRejoin)
end)
reg("unautorejoin", "/unautorejoin", "Matikan AutoRejoin", function() H.autorejoin(false) end)

reg("mute", "/mute", "Senyapkan bunyi game", function(f)
    S.Muted = (f ~= nil) and f or not S.Muted
    if S.Muted then for _, s in ipairs(game:GetDescendants()) do if s:IsA("Sound") and s.Volume > 0 then Cache.Snd[s] = s.Volume; s.Volume = 0 end end
    else for s, v in pairs(Cache.Snd) do if s and s.Parent then s.Volume = v end end; Cache.Snd = {} end
    notify("Mute: " .. (S.Muted and "ON" or "OFF"), S.Muted)
end)
reg("unmute", "/unmute", "Pulihkan bunyi game", function() H.mute(false) end)
reg("volume", "/volume [0-10]", "Laraskan kelantangan audio", function(a) local v = math.clamp(tonumber(a) or 1, 0, 10); for _, s in ipairs(game:GetDescendants()) do if s:IsA("Sound") then s.Volume = v end end; notify("Volume: " .. v, true) end)
reg("playid", "/playid [id]", "Mainkan muzik Asset ID", function(a) if not a then return end; if WS:FindFirstChild("CAudio") then WS.CAudio:Destroy() end; new("Sound", {Name = "CAudio", SoundId = "rbxassetid://" .. tostring(a):gsub("%D", ""), Volume = 2, Looped = true}, WS):Play(); notify("Playing ID: " .. a, true) end)
reg("stopid", "/stopid", "Hentikan muzik Asset ID", function() if WS:FindFirstChild("CAudio") then WS.CAudio:Destroy() end; notify("Audio stopped.", false) end)
reg("chatspam", "/chatspam [teks]", "Hantar mesej chat berulang", function(a, b, c)
    local msg = table.concat({a or "", b or "", c or ""}, " "):gsub("^%s*(.-)%s*$", "%1")
    if msg ~= "" then S.SpamTxt = msg; S.ChatSpam = true else S.ChatSpam = not S.ChatSpam end
    if S.ChatSpam then task.spawn(function() while S.ChatSpam do pcall(function() local tcs = game:GetService("TextChatService"); if tcs.ChatVersion == Enum.ChatVersion.TextChatService then tcs.TextChannels.RBXGeneral:SendAsync(S.SpamTxt) else game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(S.SpamTxt, "All") end end); task.wait(2.5) end end) end
    notify("ChatSpam: " .. (S.ChatSpam and "ON" or "OFF"), S.ChatSpam)
end)
reg("unchatspam", "/unchatspam", "Matikan ChatSpam", function() S.ChatSpam = false; notify("ChatSpam: OFF", false) end)
reg("clearchat", "/clearchat", "Bersihkan tetingkap chat", function() pcall(function() game:GetService("TextChatService").TextChannels.RBXGeneral:DisplaySystemMessage(string.rep("\n", 35)) end); notify("Chat cleared.", false) end)
reg("partcount", "/partcount", "Kira jumlah BasePart peta", function() local n = 0; for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") then n = n + 1 end end; notify("BaseParts: " .. n, true) end)
reg("charpos", "/charpos", "Semak lantai yang dipijak", function() local c, r = getChar(), getRoot(); if not c or not r then return end; local pr = RaycastParams.new(); pr.FilterType = Enum.RaycastFilterType.Exclude; pr.FilterDescendantsInstances = {c}; local hit = WS:Raycast(r.Position, V3(0, -15, 0), pr); notify(hit and ("Floor: " .. hit.Instance.Name) or "In Air", true) end)
reg("ping", "/ping", "Papar nilai Ping (ms)", function() local p = 0; pcall(function() p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end); notify("Ping: " .. p .. "ms", true) end)
reg("fps", "/fps", "Papar nilai FPS", function() notify("FPS: ~" .. math.floor(1 / math.max(RS.RenderStepped:Wait(), 0.001)), true) end)
reg("jobid", "/jobid", "Salin JobId server", function() pcall(function() if typeof(setclipboard) == "function" then setclipboard(game.JobId) end end); notify("JobId copied.", true) end)
reg("joinjob", "/joinjob [jobid]", "Sertai server guna JobId", function(a) if a and a ~= "" then TPS:TeleportToPlaceInstance(game.PlaceId, a, LP) end end)
reg("copyplace", "/copyplace", "Salin PlaceId game", function() pcall(function() if typeof(setclipboard) == "function" then setclipboard(tostring(game.PlaceId)) end end); notify("PlaceId: " .. game.PlaceId, true) end)
reg("serverinfo", "/serverinfo", "Info PlaceId, pemain & uptime", function() notify(string.format("Place:%d | Plr:%d/%d | Time:%ds", game.PlaceId, #Plrs:GetPlayers(), Plrs.MaxPlayers, math.floor(WS.DistributedGameTime)), true) end)
reg("rejoin", "/rejoin", "Masuk semula server ini", function() TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end)

local function hopSrv(low)
    notify("Mencari server...", true)
    pcall(function()
        local d = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        if d and d.data then for _, s in ipairs(d.data) do if s.id ~= game.JobId and s.playing < s.maxPlayers and (not low or s.playing <= 4) then TPS:TeleportToPlaceInstance(game.PlaceId, s.id, LP); return end end end
        TPS:Teleport(game.PlaceId, LP)
    end)
end
reg("hop", "/hop", "Pindah ke server lain", function() hopSrv(false) end)
reg("lowserver", "/lowserver", "Masuk server sepi (1-4 orang)", function() hopSrv(true) end)

-- Visual, ESP & World
reg("esp", "/esp", "Lokasi & nama pemain", function(f) S.ESP = (f ~= nil) and f or not S.ESP; Eng.RefreshESP(); notify("ESP: " .. (S.ESP and "ON" or "OFF"), S.ESP) end)
reg("unesp", "/unesp", "Matikan ESP", function() H.esp(false) end)
reg("distesp", "/distesp", "ESP dengan jarak meter", function(f) S.DistESP = (f ~= nil) and f or not S.DistESP; Eng.RefreshESP(); notify("DistESP: " .. (S.DistESP and "ON" or "OFF"), S.DistESP) end)
reg("undistesp", "/undistesp", "Matikan DistESP", function() H.distesp(false) end)
reg("healthesp", "/healthesp", "ESP dengan nyawa HP", function(f) S.HpESP = (f ~= nil) and f or not S.HpESP; Eng.RefreshESP(); notify("HealthESP: " .. (S.HpESP and "ON" or "OFF"), S.HpESP) end)
reg("unhealthesp", "/unhealthesp", "Matikan HealthESP", function() H.healthesp(false) end)
reg("chams", "/chams", "Sorotan penuh tembus dinding", function(f) S.Chams = (f ~= nil) and f or not S.Chams; Eng.RefreshESP(); notify("Chams: " .. (S.Chams and "ON" or "OFF"), S.Chams) end)
reg("unchams", "/unchams", "Matikan Chams", function() H.chams(false) end)
reg("teamcheck", "/teamcheck", "Tapis musuh sahaja", function(f) S.TeamChk = (f ~= nil) and f or not S.TeamChk; Eng.RefreshESP(); notify("TeamCheck: " .. (S.TeamChk and "ON" or "OFF"), S.TeamChk) end)
reg("unteamcheck", "/unteamcheck", "Matikan TeamCheck", function() H.teamcheck(false) end)
reg("espcolor", "/espcolor [r] [g] [b]", "Tukar warna ESP & Tracers", function(a, b, c) S.ESPCol = C3(tonumber(a) or 225, tonumber(b) or 230, tonumber(c) or 240); Eng.RefreshESP(); notify("ESP Color updated.", true) end)
reg("tracers", "/tracers", "Garisan penjejak pemain", function(f) Eng.Tracers(f) end)
reg("untracers", "/untracers", "Matikan Tracers", function() Eng.Tracers(false) end)

reg("xray", "/xray [0.1-0.9]", "Tembus pandang dinding", function(a)
    if a and tonumber(a) then S.XRayA = math.clamp(tonumber(a), 0.1, 0.95); S.XRay = true else S.XRay = not S.XRay end
    if S.XRay then
        local c = getChar()
        for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") and (not c or not o:IsDescendantOf(c)) and o.Transparency < S.XRayA and o.Size.Magnitude > 4 then if Cache.XR[o] == nil then Cache.XR[o] = o.Transparency end; o.Transparency = S.XRayA end end
    else for p, t in pairs(Cache.XR) do if p and p.Parent then p.Transparency = t end end; Cache.XR = {} end
    notify("XRay: " .. (S.XRay and "ON" or "OFF"), S.XRay)
end)
reg("unxray", "/unxray", "Matikan X-Ray", function() S.XRay = true; H.xray(nil) end)

reg("light", "/light [jarak]", "Lampu aura perak", function(a)
    if a and tonumber(a) then S.LightR = math.clamp(tonumber(a), 8, 120); S.Light = true else S.Light = not S.Light end
    local r = getRoot(); if not r then return end
    if r:FindFirstChild("CLight") then r.CLight:Destroy() end
    if S.Light then new("PointLight", {Name = "CLight", Color = C3(235, 240, 252), Brightness = 2.2, Range = S.LightR}, r) end
    notify("Light: " .. (S.Light and "ON" or "OFF"), S.Light)
end)
reg("unlight", "/unlight", "Matikan lampu aura", function() S.Light = true; H.light(nil) end)

reg("trail", "/trail", "Jejak cahaya perak", function(f)
    S.Trail = (f ~= nil) and f or not S.Trail; local r = getRoot(); if not r then return end
    for _, n in ipairs({"CTA0", "CTA1", "CTrail"}) do if r:FindFirstChild(n) then r[n]:Destroy() end end
    if S.Trail then
        local a0 = new("Attachment", {Name = "CTA0", Position = V3(0, 1.8, 0)}, r)
        local a1 = new("Attachment", {Name = "CTA1", Position = V3(0, -1.8, 0)}, r)
        new("Trail", {Name = "CTrail", Attachment0 = a0, Attachment1 = a1, Lifetime = 0.55, LightEmission = 1, Color = ColorSequence.new(C3(245, 248, 255), C3(130, 135, 145))}, r)
    end
    notify("Trail: " .. (S.Trail and "ON" or "OFF"), S.Trail)
end)
reg("untrail", "/untrail", "Matikan jejak cahaya", function() H.trail(false) end)

reg("crosshair", "/crosshair", "Titik sasaran tengah skrin", function(f) S.Cross = (f ~= nil) and f or not S.Cross; CrossF.Visible = S.Cross; notify("Crosshair: " .. (S.Cross and "ON" or "OFF"), S.Cross) end)
reg("uncrosshair", "/uncrosshair", "Matikan Crosshair", function() H.crosshair(false) end)
reg("radar", "/radar", "Kompas jarak pemain terdekat", function(f)
    S.Radar = (f ~= nil) and f or not S.Radar; RadarF.Visible = S.Radar
    loop("Radar", S.Radar, RS.Heartbeat, function() local p, d = nearestPlr(); RadarL.Text = p and string.format("RADAR: %s | %d studs", p.DisplayName, math.floor(d)) or "RADAR: Tiada sasaran" end)
    notify("Radar: " .. (S.Radar and "ON" or "OFF"), S.Radar)
end)
reg("unradar", "/unradar", "Matikan Radar", function() H.radar(false) end)

reg("nv", "/nv", "Penglihatan malam perak", function(f)
    S.NV = (f ~= nil) and f or not S.NV; if Light:FindFirstChild("CNV") then Light.CNV:Destroy() end
    if S.NV then new("ColorCorrectionEffect", {Name = "CNV", Brightness = 0.22, Contrast = 0.35, Saturation = -0.75, TintColor = C3(220, 230, 248)}, Light) end
    notify("NightVision: " .. (S.NV and "ON" or "OFF"), S.NV)
end)
reg("unnv", "/unnv", "Matikan NightVision", function() H.nv(false) end)

reg("fullbright", "/fullbright", "Terangkan peta gelap", function(f)
    S.FB = (f ~= nil) and f or not S.FB
    if S.FB then Light.Brightness = 2; Light.ClockTime = 14; Light.FogEnd = 1e5; Light.GlobalShadows = false; Light.Ambient = C3(200, 200, 200)
    else Light.Brightness = OrigL.B; Light.ClockTime = OrigL.T; Light.FogEnd = OrigL.F; Light.GlobalShadows = OrigL.S; Light.Ambient = OrigL.A end
    notify("Fullbright: " .. (S.FB and "ON" or "OFF"), S.FB)
end)
reg("unfullbright", "/unfullbright", "Matikan Fullbright", function() H.fullbright(false) end)

reg("silverworld", "/silverworld", "Dunia sinematik hitam-perak", function(f)
    S.SilverW = (f ~= nil) and f or not S.SilverW; if Light:FindFirstChild("CSW") then Light.CSW:Destroy() end
    if S.SilverW then new("ColorCorrectionEffect", {Name = "CSW", Saturation = -1, Contrast = 0.25}, Light) end
    notify("SilverWorld: " .. (S.SilverW and "ON" or "OFF"), S.SilverW)
end)
reg("unsilverworld", "/unsilverworld", "Matikan SilverWorld", function() H.silverworld(false) end)

reg("disco", "/disco", "Pencahayaan warna berkelip", function(f)
    S.Disco = (f ~= nil) and f or not S.Disco
    if S.Disco then task.spawn(function() local h = 0; while S.Disco do h = (h + 0.02) % 1; Light.Ambient = Color3.fromHSV(h, 0.7, 1); task.wait(0.05) end; Light.Ambient = OrigL.A end) end
    notify("Disco: " .. (S.Disco and "ON" or "OFF"), S.Disco)
end)
reg("undisco", "/undisco", "Matikan Disco", function() S.Disco = false; notify("Disco: OFF", false) end)
reg("ambient", "/ambient [r] [g] [b]", "Tukar warna cahaya peta", function(a, b, c) Light.Ambient = C3(tonumber(a) or 200, tonumber(b) or 200, tonumber(c) or 210); notify("Ambient set.", true) end)
reg("brightness", "/brightness [num]", "Tahap kecerahan Lighting", function(a) Light.Brightness = math.clamp(tonumber(a) or 2, 0, 10); notify("Brightness: " .. Light.Brightness, true) end)
reg("shadows", "/shadows", "Hidupkan bayang-bayang", function() Light.GlobalShadows = true; notify("Shadows: ON", true) end)
reg("noshadows", "/noshadows", "Matikan bayang-bayang", function() Light.GlobalShadows = false; notify("Shadows: OFF", false) end)
reg("removewater", "/removewater", "Keringkan air Terrain", function() pcall(function() WS.Terrain:Clear() end); notify("Water removed.", true) end)
reg("notextures", "/notextures", "Buang tekstur & decal peta", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("Decal") or o:IsA("Texture") then o.Transparency = 1 elseif o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end end; notify("Textures removed.", true) end)
reg("noparticles", "/noparticles", "Matikan zarah asap/api", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Smoke") or o:IsA("Fire") then o.Enabled = false end end; notify("Particles disabled.", true) end)
reg("brightsky", "/brightsky", "Langit cerah tanpa bayang", function() Light.ClockTime = 14; Light.Ambient = C3(220, 225, 235); Light.OutdoorAmbient = C3(220, 225, 235); notify("BrightSky: ON", true) end)
reg("sunset", "/sunset", "Waktu senja (17:45)", function() Light.ClockTime = 17.75; notify("Sunset.", true) end)
reg("midnight", "/midnight", "Waktu tengah malam (00:00)", function() Light.ClockTime = 0; notify("Midnight.", true) end)
reg("day", "/day", "Waktu siang (14:00)", function() Light.ClockTime = 14; notify("Day.", true) end)
reg("night", "/night", "Waktu malam (00:00)", function() Light.ClockTime = 0; notify("Night.", true) end)
reg("time", "/time [0-24]", "Tetapkan waktu langit", function(a) Light.ClockTime = math.clamp(tonumber(a) or 14, 0, 24); notify("Time: " .. Light.ClockTime, true) end)
reg("nofog", "/nofog", "Buang kabus jauh", function() Light.FogEnd = 1e6; for _, o in ipairs(Light:GetDescendants()) do if o:IsA("Atmosphere") then o.Density = 0 end end; notify("NoFog: ON", true) end)
reg("fogcolor", "/fogcolor [r] [g] [b]", "Tukar warna kabus", function(a, b, c) Light.FogColor = C3(tonumber(a) or 200, tonumber(b) or 200, tonumber(c) or 210); notify("FogColor set.", true) end)
reg("fogdist", "/fogdist [jarak]", "Jarak kabus peta", function(a) Light.FogEnd = tonumber(a) or 500; notify("FogEnd: " .. Light.FogEnd, true) end)

reg("lowgfx", "/lowgfx", "Naikkan FPS & kurangkan lag", function(f)
    S.LowGFX = (f ~= nil) and f or not S.LowGFX
    if S.LowGFX then
        Light.GlobalShadows = false
        for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") then if Cache.LG[o] == nil then Cache.LG[o] = o.Material end; o.Material = Enum.Material.SmoothPlastic elseif o:IsA("ParticleEmitter") or o:IsA("Trail") then o.Enabled = false end end
    else Light.GlobalShadows = OrigL.S; for p, m in pairs(Cache.LG) do if p and p.Parent then p.Material = m end end; Cache.LG = {} end
    notify("LowGFX: " .. (S.LowGFX and "ON" or "OFF"), S.LowGFX)
end)
reg("unlowgfx", "/unlowgfx", "Matikan LowGFX", function() H.lowgfx(false) end)
reg("fpscap", "/fpscap [num]", "Buka had FPS", function(a) local c = tonumber(a) or 240; pcall(function() if typeof(setfpscap) == "function" then setfpscap(c) end end); notify("FPS Cap: " .. c, true) end)

reg("hud", "/hud", "Meter FPS, Ping, Kelajuan & Pemain", function(f)
    S.HUD = (f ~= nil) and f or not S.HUD; StatsF.Visible = S.HUD
    local fr, last = 0, os.clock()
    loop("HUD", S.HUD, RS.RenderStepped, function()
        fr = fr + 1; local now = os.clock()
        if now - last >= 0.4 then
            local fps = math.floor(fr / (now - last)); fr = 0; last = now
            local ping = 0; pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            local r = getRoot(); local spd = r and math.floor(r.AssemblyLinearVelocity.Magnitude) or 0
            StatsL.Text = string.format("FPS:%d | PING:%dms | SPD:%d | PLR:%d", fps, ping, spd, #Plrs:GetPlayers())
        end
    end)
    notify("HUD: " .. (S.HUD and "ON" or "OFF"), S.HUD)
end)
reg("unhud", "/unhud", "Matikan Telemetry HUD", function() H.hud(false) end)

-- Camera & UI
reg("fov", "/fov [num]", "Sudut pandang kamera", function(a) Cam.FieldOfView = math.clamp(tonumber(a) or 70, 20, 120); notify("FOV: " .. Cam.FieldOfView, true) end)
reg("unfov", "/unfov", "Kembalikan FOV asal (70)", function() Cam.FieldOfView = 70; notify("FOV: 70", false) end)
reg("noclipcam", "/noclipcam", "Kamera tembus dinding", function() LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam; notify("NoclipCam: ON", true) end)
reg("unnoclipcam", "/unnoclipcam", "Matikan NoclipCam", function() LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom; notify("NoclipCam: OFF", false) end)
reg("maxzoom", "/maxzoom [num]", "Had zoom maksimum kamera", function(a) LP.CameraMaxZoomDistance = tonumber(a) or 1e5; notify("MaxZoom set.", true) end)
reg("minzoom", "/minzoom [num]", "Had zoom terdekat kamera", function(a) LP.CameraMinZoomDistance = tonumber(a) or 0.5; notify("MinZoom set.", true) end)
reg("zoom", "/zoom [jarak]", "Tetapkan jarak zoom semasa", function(a) local d = tonumber(a) or 12; LP.CameraMinZoomDistance = d; LP.CameraMaxZoomDistance = d; task.wait(); LP.CameraMinZoomDistance = 0.5; LP.CameraMaxZoomDistance = 400; notify("Zoom: " .. d, true) end)
reg("shiftlock", "/shiftlock", "Paksa mod Shift-Lock", function() LP.DevEnableMouseLock = true; notify("ShiftLock: ON", true) end)
reg("unshiftlock", "/unshiftlock", "Matikan ShiftLock", function() LP.DevEnableMouseLock = false; notify("ShiftLock: OFF", false) end)
reg("firstperson", "/firstperson", "Kunci kamera orang pertama", function() LP.CameraMode = Enum.CameraMode.LockFirstPerson; notify("FirstPerson.", true) end)
reg("thirdperson", "/thirdperson", "Kamera orang ketiga", function() LP.CameraMode = Enum.CameraMode.Classic; notify("ThirdPerson.", false) end)
reg("camlock", "/camlock", "Bekukan posisi kamera", function() Cam.CameraType = Enum.CameraType.Scriptable; notify("CamLocked.", true) end)
reg("uncamlock", "/uncamlock", "Nyahbeku posisi kamera", function() Cam.CameraType = Enum.CameraType.Custom; local h = getHum(); if h then Cam.CameraSubject = h end; notify("CamUnlocked.", false) end)
reg("fixcam", "/fixcam", "Pulihkan kamera tersekat", function() H.uncamlock() end)
reg("shake", "/shake [kuasa]", "Gegaran kamera sinematik", function(a) local p = math.clamp(tonumber(a) or 1.5, 0.2, 10); task.spawn(function() local t = os.clock(); while os.clock() - t < 1.5 do Cam.CFrame = Cam.CFrame * CF((math.random() - 0.5) * p, (math.random() - 0.5) * p, 0); RS.RenderStepped:Wait() end end); notify("Shake!", true) end)

reg("orbitcam", "/orbitcam", "Kamera pusing mengelilingi anda", function(f)
    S.OrbitCam = (f ~= nil) and f or not S.OrbitCam
    if S.OrbitCam then local a = 0; Cam.CameraType = Enum.CameraType.Scriptable; loop("OCam", true, RS.RenderStepped, function(dt) local r = getRoot(); if r then a = a + dt * 1.4; Cam.CFrame = CF(r.Position + V3(math.cos(a) * 14, 5, math.sin(a) * 14), r.Position) end end)
    else loop("OCam", false); H.fixcam() end
    notify("OrbitCam: " .. (S.OrbitCam and "ON" or "OFF"), S.OrbitCam)
end)
reg("unorbitcam", "/unorbitcam", "Matikan OrbitCam", function() H.orbitcam(false) end)

reg("topview", "/topview", "Pandangan dari atas langit", function(f)
    S.TopView = (f ~= nil) and f or not S.TopView
    if S.TopView then Cam.CameraType = Enum.CameraType.Scriptable; loop("TView", true, RS.RenderStepped, function() local r = getRoot(); if r then Cam.CFrame = CF(r.Position + V3(0, 45, 0.1), r.Position) end end)
    else loop("TView", false); H.fixcam() end
    notify("TopView: " .. (S.TopView and "ON" or "OFF"), S.TopView)
end)
reg("untopview", "/untopview", "Matikan TopView", function() H.topview(false) end)

reg("sideview", "/sideview", "Pandangan dari sisi", function(f)
    S.SideView = (f ~= nil) and f or not S.SideView
    if S.SideView then Cam.CameraType = Enum.CameraType.Scriptable; loop("SView", true, RS.RenderStepped, function() local r = getRoot(); if r then Cam.CFrame = CF(r.Position + V3(22, 4, 0), r.Position) end end)
    else loop("SView", false); H.fixcam() end
    notify("SideView: " .. (S.SideView and "ON" or "OFF"), S.SideView)
end)
reg("unsideview", "/unsideview", "Matikan SideView", function() H.sideview(false) end)

reg("tilt", "/tilt [darjah]", "Sengetkan kamera", function(a) S.Tilt = tonumber(a) or 15; loop("Tilt", true, RS.RenderStepped, function() if S.Tilt ~= 0 then Cam.CFrame = Cam.CFrame * CFrame.Angles(0, 0, math.rad(S.Tilt)) end end); notify("Tilt: " .. S.Tilt, true) end)
reg("untilt", "/untilt", "Luruskan semula sudut kamera", function() S.Tilt = 0; loop("Tilt", false); notify("Tilt: 0", false) end)
reg("blur", "/blur [saiz]", "Kesan blur skrin", function(a) if Light:FindFirstChild("CBlur") then Light.CBlur:Destroy() end; new("BlurEffect", {Name = "CBlur", Size = math.clamp(tonumber(a) or 10, 1, 56)}, Light); notify("Blur: ON", true) end)
reg("unblur", "/unblur", "Matikan kesan blur", function() if Light:FindFirstChild("CBlur") then Light.CBlur:Destroy() end; notify("Blur: OFF", false) end)
reg("hideui", "/hideui", "Sembunyikan UI game", function() local pg = LP:FindFirstChildOfClass("PlayerGui"); if pg then for _, g in ipairs(pg:GetChildren()) do if g:IsA("ScreenGui") then g.Enabled = false end end end; notify("UI Hidden.", true) end)
reg("showui", "/showui", "Paparkan semula UI game", function() local pg = LP:FindFirstChildOfClass("PlayerGui"); if pg then for _, g in ipairs(pg:GetChildren()) do if g:IsA("ScreenGui") then g.Enabled = true end end end; notify("UI Restored.", false) end)
reg("hidecore", "/hidecore", "Sembunyikan CoreGui", function() pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false) end); notify("CoreGui Hidden.", true) end)
reg("showcore", "/showcore", "Paparkan semula CoreGui", function() pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true) end); notify("CoreGui Restored.", false) end)
reg("theme", "/theme [silver|red|cyan|gold]", "Tukar warna tema UI", function(a)
    local m = {silver = C3(190, 195, 205), red = C3(220, 45, 55), cyan = C3(70, 210, 235), gold = C3(235, 195, 65), purple = C3(175, 110, 250), emerald = C3(60, 220, 145)}
    local col = m[(a or "silver"):lower()] or m.silver; WrapSt.Color = col; PillSt.Color = col; SugSt.Color = col; notify("Theme: " .. (a or "silver"):upper(), true)
end)
reg("opacity", "/opacity [0-1]", "Ketelusan Command Bar", function(a) local op = math.clamp(tonumber(a) or 0.08, 0, 0.95); Wrap.BackgroundTransparency = op; Pill.BackgroundTransparency = op; notify("Opacity: " .. op, true) end)
reg("resetui", "/resetui", "Kembalikan posisi UI ke tengah", function() Wrap.Position = UD2(0.5, -234, 0, 48); Wrap.Visible = true; notify("UI Reset.", true) end)
reg("cls", "/cls", "Bersihkan status terminal", function() StatusL.Text = "CHELSEAA SYSTEM V7 READY • " .. #Catalog .. " Commands"; StatusL.TextColor3 = C3(165, 170, 182) end); H.clear = H.cls

reg("stopall", "/stopall", "Matikan semua mod aktif", function()
    S.Rewind = false; S.AutoClick = false; S.AutoCollect = false; S.AutoCD = false; S.Disco = false; S.ChatSpam = false
    S.ESP = false; S.DistESP = false; S.HpESP = false; S.Chams = false
    Eng.StopFly(); Eng.StopFC(); Eng.RefreshESP(); Eng.Tracers(false)
    for _, k in ipairs({"float", "swim", "bhop", "spider", "autowalk", "noslow", "glide", "spinjump", "antifall", "noclip", "antistun", "ghost", "unorbit", "unheadsit", "unattach", "uncarpet", "unbackpack", "unloopbring", "unstare", "unfollow", "antiaim", "aimlock", "unhitbox", "autoswing", "unspin", "fling", "walkfling", "autosteal", "spamprompt", "instantprompt", "clicktp", "clickdel", "unlight", "trail", "crosshair", "radar", "nv", "fullbright", "silverworld", "orbitcam", "topview", "sideview", "untilt", "unblur"}) do
        if H[k] then pcall(H[k], false) end
    end
    notify("Semua mod aktif dimatikan.", false)
end)
reg("destroyui", "/destroyui", "Buang keseluruhan CHELSEAA SYSTEM", function() H.stopall(); if SG then SG:Destroy() end end)
reg("cmds", "/cmds", "Buka senarai 1,000 arahan", function() SugF.Visible = not SugF.Visible; if SugF.Visible then renderCmds("") end end); H.help = H.cmds

-- ==================== 2. 795 EXPANDED PRESETS & FUNCTIONAL COMMANDS (TOTAL = 1,000) ====================
-- A. Speed, Fly, Jump, Gravity, HipHeight, FOV, Spin, Hitbox, Reach, Range Presets (135 cmds)
for _, v in ipairs({10, 25, 40, 50, 65, 75, 100, 125, 150, 200, 250, 300, 400, 500, 1000}) do
    reg("fly" .. v, "/fly" .. v, "Terbang terus kelajuan " .. v, function() Eng.StartFly(v) end)
end
for _, v in ipairs({16, 20, 24, 28, 32, 36, 40, 45, 50, 60, 70, 80, 90, 100, 120, 140, 160, 180, 200, 250, 300, 400, 500, 750, 1000}) do
    reg("ws" .. v, "/ws" .. v, "Tetapkan WalkSpeed kepada " .. v, function() H.speed(v) end)
end
for _, v in ipairs({50, 65, 80, 100, 120, 150, 175, 200, 250, 300, 400, 500, 650, 800, 1000}) do
    reg("jp" .. v, "/jp" .. v, "Tetapkan JumpPower kepada " .. v, function() H.jump(v) end)
end
for _, v in ipairs({0, 10, 25, 40, 50, 75, 100, 125, 150, 196, 250, 300, 400, 500, 1000}) do
    reg("grav" .. v, "/grav" .. v, "Tetapkan graviti dunia kepada " .. v, function() H.gravity(v == 196 and 196.2 or v) end)
end
for _, v in ipairs({0, 1, 2, 3, 4, 5, 8, 10, 15, 20, 30, 50}) do
    reg("hh" .. v, "/hh" .. v, "Tetapkan HipHeight kepada " .. v, function() H.hipheight(v) end)
end
for _, v in ipairs({20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120}) do
    reg("fov" .. v, "/fov" .. v, "Tetapkan sudut FOV kamera kepada " .. v, function() H.fov(v) end)
end
for _, v in ipairs({5, 10, 15, 25, 35, 50, 75, 100, 150, 200}) do
    reg("spin" .. v, "/spin" .. v, "Pusing karakter pada kelajuan " .. v, function() H.spin(v) end)
end
for _, v in ipairs({4, 6, 8, 10, 12, 15, 18, 20, 25, 30, 45, 60}) do
    reg("hb" .. v, "/hb" .. v, "Besarkan Hitbox musuh saiz " .. v, function() H.hitbox(v) end)
end
for _, v in ipairs({5, 8, 10, 15, 20, 25, 30, 40, 50, 60}) do
    reg("reach" .. v, "/reach" .. v, "Tetapkan jarak serangan Tool " .. v .. " studs", function() H.reach(v) end)
end
for _, v in ipairs({10, 15, 25, 40, 60, 80, 100, 150, 200, 250}) do
    reg("range" .. v, "/range" .. v, "Tetapkan jarak steal/prompt " .. v .. " studs", function() H.range(v) end)
end

-- B. Directional Micro/Macro Teleports, Phases, Dashes & Boosts (120 cmds)
for _, v in ipairs({5, 10, 15, 20, 25, 30, 40, 50, 75, 100, 150, 200, 300, 400, 500, 1000}) do
    reg("up" .. v, "/up" .. v, "Naik ke atas " .. v .. " studs", function() H.up(v) end)
end
for _, v in ipairs({5, 10, 15, 20, 25, 30, 40, 50, 75, 100, 150, 200, 300, 400, 500}) do
    reg("down" .. v, "/down" .. v, "Turun ke bawah " .. v .. " studs", function() H.down(v) end)
end
for _, v in ipairs({5, 10, 15, 20, 25, 30, 40, 50, 75, 100, 150, 200, 300, 400, 500}) do
    reg("fwd" .. v, "/fwd" .. v, "Anjak ke hadapan " .. v .. " studs", function() H.forward(v) end)
end
for _, v in ipairs({5, 10, 15, 20, 25, 30, 40, 50, 75, 100, 150, 200, 250, 300}) do
    reg("back" .. v, "/back" .. v, "Anjak ke belakang " .. v .. " studs", function() H.back(v) end)
end
for _, v in ipairs({5, 10, 15, 20, 25, 30, 40, 50, 75, 100, 150, 200, 250, 300}) do
    reg("left" .. v, "/left" .. v, "Anjak ke kiri " .. v .. " studs", function() H.left(v) end)
end
for _, v in ipairs({5, 10, 15, 20, 25, 30, 40, 50, 75, 100, 150, 200, 250, 300}) do
    reg("right" .. v, "/right" .. v, "Anjak ke kanan " .. v .. " studs", function() H.right(v) end)
end
for _, v in ipairs({2, 3, 4, 5, 6, 8, 10, 12, 15, 20, 25, 30, 40, 50}) do
    reg("phase" .. v, "/phase" .. v, "Tembus dinding hadapan " .. v .. " studs", function() H.phase(v) end)
end
for _, v in ipairs({10, 20, 30, 45, 60, 80, 100, 150, 250}) do
    reg("dash" .. v, "/dash" .. v, "Luncur pantas " .. v .. " studs", function() H.dash(v) end)
end
for _, v in ipairs({30, 50, 75, 100, 125, 150, 200, 250, 300}) do
    reg("boost" .. v, "/boost" .. v, "Lonjakan udara kuasa " .. v, function() H.boost(v) end)
end

-- C. 60 Numbered Instant Waypoints: setwp1..60, wp1..60, delwp1..60 (180 cmds)
for i = 1, 60 do
    local slot = tostring(i)
    reg("setwp" .. i, "/setwp" .. i, "Simpan lokasi ke slot Waypoint #" .. i, function() H.setwp(slot) end)
    reg("wp" .. i, "/wp" .. i, "Teleport segera ke Waypoint #" .. i, function() H.wp(slot) end)
    reg("delwp" .. i, "/delwp" .. i, "Padam slot Waypoint #" .. i, function() H.delwp(slot) end)
end

-- D. Character Proportions, Materials, Colors, Transparencies & Physics Rigs (140 cmds)
local function applyScale(d, h, w, hd, lbl)
    local hum = getHum(); if not hum then return end
    local map = {BodyDepthScale = d, BodyHeightScale = h, BodyWidthScale = w, HeadScale = hd}
    for k, val in pairs(map) do
        local nv = hum:FindFirstChild(k)
        if nv and nv:IsA("NumberValue") then nv.Value = val end
    end
    notify(lbl, true)
end

local scaleList = {
    {"scale03", 0.3}, {"scale05", 0.5}, {"scale07", 0.7}, {"scale08", 0.85}, {"scale1", 1},
    {"scale12", 1.25}, {"scale15", 1.5}, {"scale18", 1.8}, {"scale2", 2}, {"scale25", 2.5},
    {"scale3", 3}, {"scale4", 4}, {"scale5", 5}, {"scale7", 7}, {"scale10", 10}
}
for _, item in ipairs(scaleList) do
    local k, sc = item[1], item[2]
    reg(k, "/" .. k, "Ubah saiz keseluruhan karakter ke " .. sc .. "x", function() applyScale(sc, sc, sc, sc, "Character Scale: " .. sc .. "x") end)
end

for _, sc in ipairs({0.5, 0.8, 1, 1.3, 1.5, 2, 2.5, 3, 4, 5}) do
    local k = "head" .. tostring(sc):gsub("%.", "")
    reg(k, "/" .. k, "Ubah saiz kepala kepada " .. sc .. "x", function()
        local hum = getHum(); local nv = hum and hum:FindFirstChild("HeadScale")
        if nv then nv.Value = sc end; notify("Head Scale: " .. sc .. "x", true)
    end)
end

local shapePresets = {
    {"tall", 0.9, 1.8, 0.9, 1.0, "Tall Body Applied"},
    {"supertall", 0.85, 2.8, 0.85, 1.0, "Super Tall Body Applied"},
    {"short", 1.0, 0.6, 1.0, 1.0, "Short Body Applied"},
    {"mini", 0.45, 0.45, 0.45, 0.5, "Mini Character Applied"},
    {"micro", 0.25, 0.25, 0.25, 0.3, "Micro Character Applied"},
    {"wide", 1.2, 1.0, 2.2, 1.0, "Wide Body Applied"},
    {"superwide", 1.4, 1.0, 3.5, 1.0, "Super Wide Body Applied"},
    {"thin", 0.4, 1.0, 0.4, 1.0, "Thin Body Applied"},
    {"paperthin", 0.12, 1.0, 1.1, 1.0, "Paper-Thin 2D Body Applied"},
    {"giant", 3.5, 3.5, 3.5, 3.5, "Giant Body Applied"},
    {"titan", 6.0, 6.0, 6.0, 6.0, "Titan Body Applied"},
    {"normalscale", 1.0, 1.0, 1.0, 1.0, "Normal Proportions Restored"},
    {"bigheadmode", 1.0, 1.0, 1.0, 3.2, "Big Head Mode Applied"},
    {"tinyheadmode", 1.0, 1.0, 1.0, 0.35, "Tiny Head Mode Applied"},
    {"chibi", 0.8, 0.65, 0.85, 1.45, "Chibi Proportions Applied"}
}
for _, sp in ipairs(shapePresets) do
    reg(sp[1], "/" .. sp[1], sp[6], function() applyScale(sp[2], sp[3], sp[4], sp[5], sp[6]) end)
end

local charMaterials = {
    {"matplastic", Enum.Material.Plastic}, {"matsmooth", Enum.Material.SmoothPlastic},
    {"matneon", Enum.Material.Neon}, {"matglass", Enum.Material.Glass},
    {"matforcefield", Enum.Material.ForceField}, {"matmetal", Enum.Material.Metal},
    {"matdiamond", Enum.Material.DiamondPlate}, {"matwood", Enum.Material.Wood},
    {"matwoodplanks", Enum.Material.WoodPlanks}, {"matmarble", Enum.Material.Marble},
    {"matgranite", Enum.Material.Granite}, {"matbrick", Enum.Material.Brick},
    {"matcobblestone", Enum.Material.Cobblestone}, {"matconcrete", Enum.Material.Concrete},
    {"matcorrodedmetal", Enum.Material.CorrodedMetal}, {"matfoil", Enum.Material.Foil},
    {"matgrass", Enum.Material.Grass}, {"matice", Enum.Material.Ice},
    {"matpebble", Enum.Material.Pebble}, {"matsand", Enum.Material.Sand},
    {"matslate", Enum.Material.Slate}, {"matfabric", Enum.Material.Fabric},
    {"matcrackedlava", Enum.Material.CrackedLava}, {"matglacier", Enum.Material.Glacier},
    {"matsalt", Enum.Material.Salt}
}
for _, cm in ipairs(charMaterials) do
    reg(cm[1], "/" .. cm[1], "Tukar bahan karakter kepada " .. cm[2].Name, function() setMat(cm[2], nil, "Char Material: " .. cm[2].Name) end)
end

local palette25 = {
    {"white", C3(248, 249, 252)}, {"black", C3(14, 14, 18)}, {"silver", C3(195, 200, 210)},
    {"gray", C3(120, 125, 135)}, {"red", C3(230, 45, 55)}, {"crimson", C3(175, 20, 35)},
    {"maroon", C3(115, 15, 25)}, {"orange", C3(245, 125, 35)}, {"gold", C3(240, 195, 60)},
    {"yellow", C3(250, 235, 70)}, {"lime", C3(145, 240, 55)}, {"green", C3(45, 200, 85)},
    {"emerald", C3(35, 185, 130)}, {"mint", C3(110, 245, 195)}, {"cyan", C3(55, 225, 245)},
    {"sky", C3(105, 185, 255)}, {"blue", C3(45, 105, 245)}, {"navy", C3(20, 40, 120)},
    {"indigo", C3(85, 55, 215)}, {"purple", C3(155, 65, 240)}, {"violet", C3(195, 105, 250)},
    {"magenta", C3(235, 55, 195)}, {"pink", C3(250, 130, 195)}, {"rose", C3(240, 85, 125)},
    {"brown", C3(125, 80, 50)}
}
for _, colItem in ipairs(palette25) do
    local cname, cval = colItem[1], colItem[2]
    reg("char" .. cname, "/char" .. cname, "Warnakan badan karakter dengan warna " .. cname, function()
        local c = getChar(); if not c then return end
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Color = cval end end
        notify("Char Color: " .. cname:upper(), true)
    end)
end

for _, pct in ipairs({0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100}) do
    reg("alpha" .. pct, "/alpha" .. pct, "Tetapkan ketelusan badan " .. pct .. "%", function()
        local c = getChar(); if not c then return end
        local a = pct / 100
        for _, o in ipairs(c:GetDescendants()) do
            if o:IsA("BasePart") and o.Name ~= "HumanoidRootPart" then o.LocalTransparencyModifier = a
            elseif o:IsA("Decal") then o.Transparency = a end
        end
        notify("Character Transparency: " .. pct .. "%", true)
    end)
end

local bodyPartsToggle = {
    {"noface", "Sembunyikan muka karakter", function() local c = getChar(); local hd = c and c:FindFirstChild("Head"); if hd then for _, d in ipairs(hd:GetDescendants()) do if d:IsA("Decal") then d.Transparency = 1 end end; notify("Face Hidden.", true) end end},
    {"faceless", "Pulihkan muka karakter", function() local c = getChar(); local hd = c and c:FindFirstChild("Head"); if hd then for _, d in ipairs(hd:GetDescendants()) do if d:IsA("Decal") then d.Transparency = 0 end end; notify("Face Restored.", false) end end},
    {"blockhead", "Tukar bentuk kepala kepada blok", function() local c = getChar(); local hd = c and c:FindFirstChild("Head"); if hd then for _, m in ipairs(hd:GetChildren()) do if m:IsA("SpecialMesh") then m:Destroy() end end; notify("Blockhead Applied.", true) end end},
    {"noleftarm", "Sembunyikan tangan kiri", function() local c = getChar(); if c then for _, n in ipairs({"LeftUpperArm", "LeftLowerArm", "LeftHand", "Left Arm"}) do local p = c:FindFirstChild(n); if p then p.Transparency = 1 end end; notify("Left Arm Hidden.", true) end end},
    {"norightarm", "Sembunyikan tangan kanan", function() local c = getChar(); if c then for _, n in ipairs({"RightUpperArm", "RightLowerArm", "RightHand", "Right Arm"}) do local p = c:FindFirstChild(n); if p then p.Transparency = 1 end end; notify("Right Arm Hidden.", true) end end},
    {"noleftleg", "Sembunyikan kaki kiri", function() local c = getChar(); if c then for _, n in ipairs({"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do local p = c:FindFirstChild(n); if p then p.Transparency = 1 end end; notify("Left Leg Hidden.", true) end end},
    {"norightleg", "Sembunyikan kaki kanan", function() H.korblox(true) end},
    {"noarms", "Sembunyikan kedua-dua tangan", function() H.noleftarm(); H.norightarm(); notify("Both Arms Hidden.", true) end},
    {"nolegs", "Sembunyikan kedua-dua kaki", function() H.noleftleg(); H.norightleg(); notify("Both Legs Hidden.", true) end},
    {"glowchar", "Tambah aura bersinar pada karakter", function() local r = getRoot(); if r then local hl = getChar():FindFirstChild("CGlow") or new("Highlight", {Name = "CGlow"}, getChar()); hl.FillColor = C3(235, 240, 255); hl.FillTransparency = 0.5; notify("Character Glow: ON", true) end end},
    {"unglowchar", "Matikan aura bersinar karakter", function() local c = getChar(); if c and c:FindFirstChild("CGlow") then c.CGlow:Destroy() end; notify("Character Glow: OFF", false) end},
    {"trailred", "Jejak cahaya merah", function() H.trail(true); local r = getRoot(); local tr = r and r:FindFirstChild("CTrail"); if tr then tr.Color = ColorSequence.new(C3(240, 55, 65), C3(90, 15, 20)) end end},
    {"trailcyan", "Jejak cahaya sian", function() H.trail(true); local r = getRoot(); local tr = r and r:FindFirstChild("CTrail"); if tr then tr.Color = ColorSequence.new(C3(65, 230, 250), C3(20, 90, 120)) end end},
    {"trailgold", "Jejak cahaya emas", function() H.trail(true); local r = getRoot(); local tr = r and r:FindFirstChild("CTrail"); if tr then tr.Color = ColorSequence.new(C3(245, 200, 65), C3(120, 90, 20)) end end}
}
for _, bp in ipairs(bodyPartsToggle) do
    reg(bp[1], "/" .. bp[1], bp[2], bp[3])
end

local physicsPresets = {
    {"zerog", "Graviti sifar (0)", function() H.gravity(0) end},
    {"lowg", "Graviti rendah (45)", function() H.gravity(45) end},
    {"moong", "Graviti Bulan (32)", function() H.gravity(32) end},
    {"marsg", "Graviti Marikh (74)", function() H.gravity(74) end},
    {"mercuryg", "Graviti Utarid (73)", function() H.gravity(73) end},
    {"venusg", "Graviti Zuhrah (177)", function() H.gravity(177) end},
    {"jupiterg", "Graviti Musytari (490)", function() H.gravity(490) end},
    {"saturng", "Graviti Zuhal (210)", function() H.gravity(210) end},
    {"neptuneg", "Graviti Neptun (225)", function() H.gravity(225) end},
    {"earthg", "Graviti Bumi asal (196.2)", function() H.gravity(196.2) end},
    {"superjump", "Lompatan tinggi (JumpPower 150)", function() H.jump(150) end},
    {"megajump", "Lompatan mega (JumpPower 300)", function() H.jump(300) end},
    {"ultrajump", "Lompatan ultra (JumpPower 600)", function() H.jump(600) end},
    {"flashspeed", "Kelajuan kilat (WalkSpeed 150)", function() H.speed(150) end},
    {"sonicspeed", "Kelajuan sonik (WalkSpeed 300)", function() H.speed(300) end},
    {"lightspeed", "Kelajuan cahaya (WalkSpeed 750)", function() H.speed(750) end},
    {"walkslow", "Jalan perlahan sinematik (WalkSpeed 8)", function() H.speed(8) end},
    {"crouch", "Rendahkan ketinggian badan (HipHeight 0.5)", function() H.hipheight(0.5) end},
    {"prone", "Posisi merangkak rendah (HipHeight -1.5)", function() H.hipheight(-1.5) end},
    {"backflip", "Aksi akrobatik Backflip", function() local r = getRoot(); if r then r.AssemblyLinearVelocity = V3(0, 42, 0); TS:Create(r, TweenInfo.new(0.45), {CFrame = r.CFrame * CFrame.Angles(math.rad(180), 0, 0)}):Play(); notify("Backflip!", true) end end},
    {"frontflip", "Aksi akrobatik Frontflip", function() local r = getRoot(); if r then r.AssemblyLinearVelocity = V3(0, 42, 0); TS:Create(r, TweenInfo.new(0.45), {CFrame = r.CFrame * CFrame.Angles(math.rad(-180), 0, 0)}):Play(); notify("Frontflip!", true) end end},
    {"sideflip", "Aksi akrobatik Sideflip", function() local r = getRoot(); if r then r.AssemblyLinearVelocity = V3(0, 42, 0); TS:Create(r, TweenInfo.new(0.45), {CFrame = r.CFrame * CFrame.Angles(0, 0, math.rad(180))}):Play(); notify("Sideflip!", true) end end},
    {"spin360", "Pusingan pantas 360 darjah", function() local r = getRoot(); if r then TS:Create(r, TweenInfo.new(0.35), {CFrame = r.CFrame * CFrame.Angles(0, math.pi, 0)}):Play(); notify("360 Spin!", true) end end},
    {"launch500", "Lancar ke langit +500 studs", function() local r = getRoot(); if r then r.AssemblyLinearVelocity = V3(0, 260, 0); notify("Launched!", true) end end},
    {"launch1000", "Lancar ke angkasa +1000 studs", function() local r = getRoot(); if r then r.AssemblyLinearVelocity = V3(0, 480, 0); notify("Mega Launch!", true) end end}
}
for _, pp in ipairs(physicsPresets) do
    reg(pp[1], "/" .. pp[1], pp[2], pp[3])
end

-- E. 24-Hour Time, ESP Colors, World Themes, Fog, Post-Processing, Audio & Map Tools (155 cmds)
for hr = 0, 23 do
    reg("time" .. hr, "/time" .. hr, string.format("Tetapkan waktu langit ke jam %02d:00", hr), function() H.time(hr) end)
end

for _, colItem in ipairs(palette25) do
    local cname, cval = colItem[1], colItem[2]
    reg("esp" .. cname, "/esp" .. cname, "Tukar warna ESP & Tracers kepada " .. cname, function()
        S.ESPCol = cval; Eng.RefreshESP()
        if S.Tracers then Eng.Tracers(true) end
        notify("ESP Color: " .. cname:upper(), true)
    end)
end

local worldThemes = {
    {"worldobsidian", C3(25, 25, 32), C3(210, 215, 230), -0.4, 0.25, "Obsidian Dark Theme"},
    {"worldsilver", C3(180, 185, 195), C3(235, 238, 245), -1.0, 0.2, "Monochrome Silver Theme"},
    {"worldcrimson", C3(130, 20, 30), C3(255, 140, 150), 0.1, 0.2, "Crimson Eclipse Theme"},
    {"worldabyss", C3(15, 25, 55), C3(130, 165, 255), -0.2, 0.25, "Deep Abyss Theme"},
    {"worldcyber", C3(35, 110, 140), C3(140, 240, 255), 0.2, 0.2, "Cyberpunk Cyan Theme"},
    {"worldmatrix", C3(15, 95, 35), C3(130, 255, 150), 0.1, 0.3, "Matrix Green Theme"},
    {"worldblood", C3(110, 10, 10), C3(255, 90, 90), 0.2, 0.35, "Blood Moon Theme"},
    {"worldice", C3(150, 210, 240), C3(215, 245, 255), -0.1, 0.15, "Glacial Ice Theme"},
    {"worldvoid", C3(8, 8, 12), C3(150, 140, 180), -0.7, 0.35, "Null Void Theme"},
    {"worldgold", C3(165, 130, 45), C3(255, 235, 165), 0.15, 0.15, "Imperial Gold Theme"},
    {"worldsunset", C3(190, 95, 55), C3(255, 190, 140), 0.25, 0.15, "Warm Sunset Theme"},
    {"worlddawn", C3(175, 135, 160), C3(250, 215, 230), 0.1, 0.1, "Rose Dawn Theme"},
    {"worlddusk", C3(65, 55, 105), C3(185, 175, 245), -0.15, 0.2, "Twilight Dusk Theme"},
    {"worldneon", C3(120, 35, 165), C3(235, 155, 255), 0.4, 0.3, "Neon Ultraviolet Theme"},
    {"worldtoxic", C3(85, 135, 25), C3(205, 255, 120), 0.3, 0.25, "Toxic Lime Theme"},
    {"worldvapor", C3(165, 85, 155), C3(255, 180, 245), 0.25, 0.15, "Vaporwave Theme"},
    {"worldnoir", C3(40, 40, 40), C3(220, 220, 220), -1.0, 0.45, "Film Noir Contrast Theme"},
    {"worldsepia", C3(135, 110, 80), C3(240, 215, 180), -0.5, 0.15, "Vintage Sepia Theme"},
    {"worldpastel", C3(195, 185, 210), C3(245, 235, 250), -0.25, -0.05, "Soft Pastel Theme"},
    {"worldarctic", C3(190, 215, 235), C3(235, 248, 255), -0.2, 0.1, "Arctic Frost Theme"},
    {"worlddesert", C3(185, 150, 95), C3(255, 230, 185), 0.1, 0.15, "Dune Desert Theme"},
    {"worldforest", C3(45, 95, 55), C3(175, 235, 180), 0.1, 0.15, "Emerald Forest Theme"},
    {"worldocean", C3(25, 85, 135), C3(140, 215, 255), 0.15, 0.15, "Deep Ocean Theme"},
    {"worldlava", C3(165, 45, 15), C3(255, 145, 95), 0.3, 0.3, "Molten Lava Theme"},
    {"worldreset", OrigL.A, C3(255, 255, 255), 0, 0, "World Theme Reset"}
}
for _, wt in ipairs(worldThemes) do
    reg(wt[1], "/" .. wt[1], wt[6], function()
        if Light:FindFirstChild("CTheme") then Light.CTheme:Destroy() end
        Light.Ambient = wt[2]
        if wt[1] ~= "worldreset" then
            new("ColorCorrectionEffect", {Name = "CTheme", TintColor = wt[3], Saturation = wt[4], Contrast = wt[5]}, Light)
        end
        notify(wt[6], true)
    end)
end

for _, dist in ipairs({0, 50, 100, 200, 350, 500, 750, 1000, 2500, 5000}) do
    reg("fog" .. dist, "/fog" .. dist, "Tetapkan jarak kabus kepada " .. dist .. " studs", function() H.fogdist(dist) end)
end
for _, fc in ipairs({
    {"fogwhite", C3(245, 245, 250)}, {"fogblack", C3(12, 12, 16)}, {"fogsilver", C3(185, 190, 200)},
    {"fogred", C3(210, 45, 55)}, {"fogblue", C3(45, 95, 220)}, {"fogcyan", C3(60, 210, 235)},
    {"fogpurple", C3(155, 70, 225)}, {"foggold", C3(230, 190, 65)}, {"foggreen", C3(45, 190, 85)},
    {"fogpink", C3(240, 120, 185)}
}) do
    reg(fc[1], "/" .. fc[1], "Tukar warna kabus (" .. fc[1]:sub(4) .. ")", function() Light.FogColor = fc[2]; notify("Fog Color: " .. fc[1]:sub(4):upper(), true) end)
end

for _, br in ipairs({0, 1, 2, 3, 5, 8, 10}) do
    reg("bright" .. br, "/bright" .. br, "Tetapkan kecerahan Lighting kepada " .. br, function() H.brightness(br) end)
end
local function getFX() return Light:FindFirstChild("CFX") or new("ColorCorrectionEffect", {Name = "CFX"}, Light) end
reg("contrast0", "/contrast0", "Kontras skrin normal (0)", function() getFX().Contrast = 0; notify("Contrast: 0", true) end)
reg("contrast1", "/contrast1", "Kontras skrin tinggi (0.35)", function() getFX().Contrast = 0.35; notify("Contrast: 0.35", true) end)
reg("contrast2", "/contrast2", "Kontras skrin maksimum (0.75)", function() getFX().Contrast = 0.75; notify("Contrast: 0.75", true) end)
reg("sat0", "/sat0", "Warna hitam putih (Saturation -1)", function() getFX().Saturation = -1; notify("Saturation: -1", true) end)
reg("sat1", "/sat1", "Warna normal (Saturation 0)", function() getFX().Saturation = 0; notify("Saturation: 0", true) end)
reg("sat2", "/sat2", "Warna terang hidup (Saturation +0.6)", function() getFX().Saturation = 0.6; notify("Saturation: +0.6", true) end)
reg("bloom", "/bloom", "Aktifkan kesan cahaya Bloom", function() if not Light:FindFirstChild("CBloom") then new("BloomEffect", {Name = "CBloom", Intensity = 1.2, Size = 24, Threshold = 0.9}, Light) end; notify("Bloom: ON", true) end)
reg("unbloom", "/unbloom", "Matikan kesan cahaya Bloom", function() if Light:FindFirstChild("CBloom") then Light.CBloom:Destroy() end; notify("Bloom: OFF", false) end)
reg("sunrays", "/sunrays", "Aktifkan pancaran cahaya matahari", function() if not Light:FindFirstChild("CSun") then new("SunRaysEffect", {Name = "CSun", Intensity = 0.25, Spread = 0.8}, Light) end; notify("SunRays: ON", true) end)
reg("unsunrays", "/unsunrays", "Matikan pancaran cahaya matahari", function() if Light:FindFirstChild("CSun") then Light.CSun:Destroy() end; notify("SunRays: OFF", false) end)
reg("dof", "/dof", "Aktifkan Depth of Field kamera", function() if not Light:FindFirstChild("CDoF") then new("DepthOfFieldEffect", {Name = "CDoF", FarIntensity = 0.4, FocusDistance = 35}, Light) end; notify("DepthOfField: ON", true) end)
reg("undof", "/undof", "Matikan Depth of Field", function() if Light:FindFirstChild("CDoF") then Light.CDoF:Destroy() end; notify("DepthOfField: OFF", false) end)
reg("clearfx", "/clearfx", "Buang semua kesan post-processing", function() for _, n in ipairs({"CFX", "CBloom", "CSun", "CDoF", "CBlur", "CNV", "CSW", "CTheme"}) do if Light:FindFirstChild(n) then Light[n]:Destroy() end end; notify("All PostFX Cleared.", false) end)

for _, v in ipairs({0, 1, 2, 3, 5, 8, 10}) do
    reg("vol" .. v, "/vol" .. v, "Tetapkan kelantangan bunyi kepada " .. v, function() H.volume(v) end)
end
reg("stopsounds", "/stopsounds", "Hentikan semua bunyi sedang dimainkan", function() for _, s in ipairs(game:GetDescendants()) do if s:IsA("Sound") and s.IsPlaying then s:Stop() end end; notify("All Sounds Stopped.", true) end)
reg("resumesounds", "/resumesounds", "Mainkan semula bunyi berulang", function() for _, s in ipairs(game:GetDescendants()) do if s:IsA("Sound") and s.Looped then s:Play() end end; notify("Looped Sounds Resumed.", true) end)
for _, f in ipairs({30, 60, 90, 120, 144, 240}) do
    reg("fps" .. f, "/fps" .. f, "Kunci had FPS kepada " .. f, function() H.fpscap(f) end)
end
reg("fpsunlim", "/fpsunlim", "Buka had FPS tanpa sekatan (999)", function() H.fpscap(999) end)

local mapUtils = {
    {"deldecals", "Padam semua Decal dalam peta", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("Decal") then o:Destroy() end end; notify("Decals Deleted.", true) end},
    {"deltextures", "Padam semua Texture dalam peta", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("Texture") then o:Destroy() end end; notify("Textures Deleted.", true) end},
    {"delparticles", "Padam semua ParticleEmitter", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("ParticleEmitter") then o:Destroy() end end; notify("Particles Deleted.", true) end},
    {"delbeams", "Padam semua Beam dalam peta", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("Beam") then o:Destroy() end end; notify("Beams Deleted.", true) end},
    {"deltrails", "Padam semua Trail dalam peta", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("Trail") then o:Destroy() end end; notify("Trails Deleted.", true) end},
    {"delsmoke", "Padam semua kesan asap Smoke", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("Smoke") then o:Destroy() end end; notify("Smoke Deleted.", true) end},
    {"delfire", "Padam semua kesan api Fire", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("Fire") then o:Destroy() end end; notify("Fire Deleted.", true) end},
    {"delsparkles", "Padam semua kesan Sparkles", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("Sparkles") then o:Destroy() end end; notify("Sparkles Deleted.", true) end},
    {"deltrees", "Sembunyikan pokok & dedaun peta", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") and (o.Name:lower():find("tree") or o.Name:lower():find("leaf") or o.Name:lower():find("leaves")) then o.Transparency = 1; o.CanCollide = false end end; notify("Trees Hidden.", true) end},
    {"delgrass", "Matikan rumput 3D Terrain", function() pcall(function() sethiddenproperty(WS.Terrain, "Decoration", false) end); notify("Terrain Grass Disabled.", true) end},
    {"smoothmap", "Tukar semua bahagian peta ke SmoothPlastic", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end end; notify("Map: SmoothPlastic", true) end},
    {"plasticmap", "Tukar semua bahagian peta ke Plastic", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.Plastic end end; notify("Map: Plastic", true) end},
    {"neonmap", "Tukar semua bahagian peta ke Neon", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.Neon end end; notify("Map: Neon", true) end},
    {"glassmap", "Tukar semua bahagian peta ke Glass", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.Glass end end; notify("Map: Glass", true) end},
    {"icemap", "Tukar semua bahagian peta ke Ice licin", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.Ice end end; notify("Map: Ice", true) end},
    {"wireframe", "Aktifkan mod garisan Wireframe peta", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") and not o:FindFirstChild("CWire") then new("SelectionBox", {Name = "CWire", Adornee = o, LineThickness = 0.02, Color3 = C3(180, 190, 210)}, o) end end; notify("Wireframe: ON", true) end},
    {"unwireframe", "Matikan mod Wireframe peta", function() for _, o in ipairs(WS:GetDescendants()) do if o.Name == "CWire" then o:Destroy() end end; notify("Wireframe: OFF", false) end},
    {"unlockall", "Buka kunci semua bahagian peta", function() H.unlockws() end},
    {"lockall", "Kunci semua bahagian peta", function() for _, o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") then o.Locked = true end end; notify("All Parts Locked.", true) end},
    {"anchorchar", "Sauhkan semua bahagian badan karakter", function() local c = getChar(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Anchored = true end end; notify("Character Anchored.", true) end end},
    {"unanchorchar", "Lepaskan sauh badan karakter", function() local c = getChar(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Anchored = false end end; notify("Character Unanchored.", false) end end},
    {"cancollideon", "Hidupkan perlanggaran badan karakter", function() local c = getChar(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end; notify("CanCollide: ON", true) end end},
    {"cancollideoff", "Matikan perlanggaran badan karakter", function() local c = getChar(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end; notify("CanCollide: OFF", false) end end},
    {"massless", "Jadikan karakter ringan tanpa jisim", function() local c = getChar(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Massless = true end end; notify("Massless: ON", true) end end},
    {"unmassless", "Kembalikan jisim asal karakter", function() local c = getChar(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Massless = false end end; notify("Massless: OFF", false) end end}
}
for _, mu in ipairs(mapUtils) do
    reg(mu[1], "/" .. mu[1], mu[2], mu[3])
end

-- F. Camera Tilts, Zooms, Blurs, Auto-Clicker Speeds, Tool Slots & Combo Suites (65 cmds)
for _, deg in ipairs({0, 5, 10, 15, 20, 30, 45, 60, 90, 180, -5, -10, -15, -30, -45, -90}) do
    reg("tilt" .. deg, "/tilt" .. deg, "Sengetkan sudut kamera ke " .. deg .. " darjah", function()
        if deg == 0 then H.untilt() else H.tilt(deg) end
    end)
end
for _, zm in ipairs({1, 3, 5, 8, 12, 15, 20, 35, 50, 100, 250, 500}) do
    reg("zoom" .. zm, "/zoom" .. zm, "Tetapkan jarak zoom kamera ke " .. zm, function() H.zoom(zm) end)
end
for _, bl in ipairs({0, 3, 6, 10, 16, 24, 36, 56}) do
    reg("blur" .. bl, "/blur" .. bl, "Tetapkan tahap kabur skrin ke " .. bl, function()
        if bl == 0 then H.unblur() else H.blur(bl) end
    end)
end
for _, ms in ipairs({10, 25, 50, 100, 200, 300, 500, 1000, 2000, 5000}) do
    reg("click" .. ms, "/click" .. ms, "Auto-Clicker selang " .. ms .. "ms", function() H.autoclick(ms) end)
end
for idx = 1, 5 do
    reg("equip" .. idx, "/equip" .. idx, "Pegang Tool slot #" .. idx .. " dari Backpack", function()
        local bp, c = LP:FindFirstChildOfClass("Backpack"), getChar()
        if bp and c then
            local tools = {}; for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then tools[#tools + 1] = t end end
            if tools[idx] then tools[idx].Parent = c; notify("Equipped: " .. tools[idx].Name, true) end
        end
    end)
    reg("use" .. idx, "/use" .. idx, "Aktifkan Tool slot #" .. idx, function()
        H["equip" .. idx]()
        local c = getChar(); local t = c and c:FindFirstChildOfClass("Tool")
        if t then t:Activate(); notify("Activated Tool #" .. idx, true) end
    end)
end

local combos = {
    {"combatmode", "Aktifkan Aimlock + Hitbox 10 + ESP + Crosshair", function() H.aimlock(true); H.hitbox(10); H.esp(true); H.crosshair(true); notify("COMBAT SUITE: ON", true) end},
    {"uncombatmode", "Matikan suite pertempuran", function() H.aimlock(false); H.unhitbox(); H.esp(false); H.crosshair(false); notify("COMBAT SUITE: OFF", false) end},
    {"farmmode", "Aktifkan AutoCollect + AutoPrompt + InstantPrompt + AntiAFK", function() H.autocollect(true); H.autosteal(true); H.instantprompt(true); H.antiafk2(); notify("FARM SUITE: ON", true) end},
    {"unfarmmode", "Matikan suite auto-farm", function() H.autocollect(false); H.autosteal(false); H.instantprompt(false); notify("FARM SUITE: OFF", false) end},
    {"explorermode", "Aktifkan Fly 120 + Noclip + Fullbright + NoFog", function() Eng.StartFly(120); H.noclip(true); H.fullbright(true); H.nofog(); notify("EXPLORER SUITE: ON", true) end},
    {"unexplorermode", "Matikan suite penerokaan peta", function() Eng.StopFly(); H.noclip(false); H.fullbright(false); notify("EXPLORER SUITE: OFF", false) end},
    {"fpsboost", "Optimumkan FPS maksimum (LowGFX + NoTextures + NoParticles)", function() H.lowgfx(true); H.notextures(); H.noparticles(); H.noshadows(); notify("MAX FPS BOOST APPLIED!", true) end},
    {"cinematic", "Mod rakaman sinematik (HideUI + OrbitCam + Bloom)", function() H.hideui(); H.orbitcam(true); H.bloom(); notify("CINEMATIC MODE: ON", true) end},
    {"uncinematic", "Keluar daripada mod rakaman sinematik", function() H.showui(); H.orbitcam(false); H.unbloom(); notify("CINEMATIC MODE: OFF", false) end}
}
for _, cb in ipairs(combos) do
    reg(cb[1], "/" .. cb[1], cb[2], cb[3])
end

-- Kemaskini label dengan jumlah rasmi yang didaftarkan
StatusL.Text = "CHELSEAA SYSTEM V7 READY • " .. #Catalog .. " Commands (/cmds)"

-- ==================== PARSER & EVENTS ====================
local function exec(raw)
    local t = (raw or ""):gsub("^%s*(.-)%s*$", "%1"); if t == "" then return end
    if t:sub(1, 1) == "/" or t:sub(1, 1) == ";" or t:sub(1, 1) == "!" then t = t:sub(2) end
    local args = {}; for w in t:gmatch("%S+") do args[#args + 1] = w end
    local fn = H[(args[1] or ""):lower()]
    if fn then
        fn(args[2], args[3], args[4])
        SugF.Visible = false
    else
        notify("Unknown: /" .. (args[1] or ""), false)
    end
end

RunBtn.MouseButton1Click:Connect(function() exec(Box.Text); Box.Text = "" end)
CmdBtn.MouseButton1Click:Connect(function() H.cmds() end)
Box.FocusLost:Connect(function(e) if e then exec(Box.Text); Box.Text = "" end end)
Box:GetPropertyChangedSignal("Text"):Connect(function()
    if Box.Text ~= "" then renderCmds(Box.Text) else SugF.Visible = false end
end)

-- Chat Command Support (/command atau ;command)
LP.Chatted:Connect(function(m)
    if m:sub(1, 1) == "/" or m:sub(1, 1) == ";" then exec(m) end
end)

UIS.InputBegan:Connect(function(i, gp)
    if not gp and (i.KeyCode == Enum.KeyCode.Semicolon or i.KeyCode == Enum.KeyCode.Slash) then
        Wrap.Visible = true; task.wait(); Box:CaptureFocus()
    end
end)

local function onChar(c)
    Cache.Hist = {}; local h = c:WaitForChild("Humanoid", 5)
    if h then
        if S.God then H.god() end
        h.Died:Connect(function() local r = c:FindFirstChild("HumanoidRootPart"); if r then S.LastDeath = r.CFrame end end)
    end
    if S.AutoSpawn and S.LastDeath then
        local r = c:WaitForChild("HumanoidRootPart", 5)
        if r then task.wait(0.1); r.CFrame = S.LastDeath + V3(0, 2, 0) end
    end
    if S.Ghost then task.wait(0.2); H.ghost(true) end
    if S.Light then task.wait(0.2); S.Light = false; H.light(S.LightR) end
    if S.Trail then task.wait(0.2); H.trail(true) end
    if S.Tracers then task.wait(0.3); Eng.Tracers(true) end
end
if LP.Character then task.spawn(onChar, LP.Character) end
LP.CharacterAdded:Connect(onChar)
Plrs.PlayerAdded:Connect(function() Eng.RefreshESP(); if S.Tracers then Eng.Tracers(true) end end)
LP.Idled:Connect(function() if S.AntiAFK then pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end) end end)

local drag, dIn, dStart, sPos
Wrap.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = true; dStart = i.Position; sPos = Wrap.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
    end
end)
Wrap.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then dIn = i end
end)
UIS.InputChanged:Connect(function(i)
    if i == dIn and drag then
        local d = i.Position - dStart
        Wrap.Position = UD2(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
    end
end)
Pill.MouseButton1Click:Connect(function()
    Wrap.Visible = not Wrap.Visible
    if not Wrap.Visible then SugF.Visible = false end
end)
