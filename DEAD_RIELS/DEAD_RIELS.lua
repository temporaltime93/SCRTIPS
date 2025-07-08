local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer


-- Cargar la librería Kavo
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/temporaltime93/-HUBS-/main/[GENERAL]/HUB.lua"))()
local gui = game:GetService("CoreGui"):FindFirstChildWhichIsA("ScreenGui", true)

-- Eliminar cualquier GUI previa con nuestro nombre personalizado
local function removeExistingUI()
    local existing = game.CoreGui:FindFirstChild("[PROTOTYPE]")
    if existing then
        existing:Destroy()
    end
end

-- Crear el UI
local function createUI()
    removeExistingUI()

    -- Crear la ventana
    local Window = Library.CreateLib("[PROTOTYPE]", "BloodTheme")

    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v:FindFirstChild("Main") then
            v.Name = "[PROTOTYPE]"
        end
    end

    local PPT = Window:NewTab("📄 PPT")
    local _PRESENTACION_ = PPT:NewSection("TEAM [PROTOTYPE]:")
    _PRESENTACION_:NewLabel("💖 ¡HOLIII~! COMO ESTAS SOY RUBI~ 💖")
    _PRESENTACION_:NewLabel("🛠  REPRESENTANDO A: TEAM PROTOTYPE  🛠")
    _PRESENTACION_:NewLabel("🎯 TECNOLOGIA PARA TODOS 🎯")
    _PRESENTACION_:NewButton("JOIN SERVER", "PEGA EL LINK EN GOOGLE", function()
        setclipboard("discord.gg/2qcRceCmtC")
        _G.mensaje = {M = "success",  T = "SE COPIO EL LINK"}
    end)
    local HOME = Window:NewTab("🏠 HOME")
    local _HOME_ = HOME:NewSection("🏠 HOME")
    _HOME_:NewLabel("💖 ACA ESTA LOS SCRIPTS GENERALES 💖")
    _HOME_:NewButton("AUTO BONOS EJECUTADO", "PEGA EL LINK EN GOOGLE", function()
        
        loadstring(game:HttpGet("https://raw.githubusercontent.com/temporaltime93/-HUBS-/refs/heads/main/%5BGENERAL%5D/SCRIPTS/PARTES/auto_bonos.lua"))()
        _G.mensaje = { M = "success", T = "AUTO BONOS EJECUTADO" } -- Opciones: error, log, success, help
    end)
end

-- Ejecutar
createUI()


