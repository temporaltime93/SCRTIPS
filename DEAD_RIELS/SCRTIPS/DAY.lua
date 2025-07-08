-- [[ DÍA AMARILLO OSCURO SIN NUBES ]]

-- Eliminar elementos atmosféricos no deseados
for _, v in pairs(game.Lighting:GetChildren()) do
    if v:IsA("Sky") or v:IsA("BlurEffect") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") then
        v:Destroy()
    end
end

-- Colores cálidos pero con tono más oscuro
local warmDarkAmbient = Color3.fromRGB(200, 180, 130) -- Luz ambiente suave y oscura
local topColor = Color3.fromRGB(220, 200, 150)
local bottomColor = Color3.fromRGB(190, 170, 120)
local fogColor = Color3.fromRGB(180, 160, 110)

-- Configuración de día oscuro con toque dorado
game.Lighting.Ambient = warmDarkAmbient
game.Lighting.Brightness = 1.8 -- Menos brillante
game.Lighting.ClockTime = 16 -- Tarde (4 PM)
game.Lighting.ColorShift_Bottom = bottomColor
game.Lighting.ColorShift_Top = topColor
game.Lighting.ExposureCompensation = -0.2 -- Un poco más oscuro visualmente
game.Lighting.FogColor = fogColor
game.Lighting.FogEnd = 999999999 -- Sin niebla
game.Lighting.GeographicLatitude = 41.733
game.Lighting.OutdoorAmbient = warmDarkAmbient
game.Lighting.GlobalShadows = true

-- Bloqueo para evitar cambios externos
if not _G.lightingLocked then
    _G.lightingLocked = true

    -- Restablecer configuración si cambia
    game.Lighting.Changed:Connect(function()
        game.Lighting.Ambient = warmDarkAmbient
        game.Lighting.Brightness = 1.8
        game.Lighting.ClockTime = 16
        game.Lighting.ColorShift_Bottom = bottomColor
        game.Lighting.ColorShift_Top = topColor
        game.Lighting.ExposureCompensation = -0.2
        game.Lighting.FogColor = fogColor
        game.Lighting.FogEnd = 999999999
        game.Lighting.GeographicLatitude = 41.733
        game.Lighting.OutdoorAmbient = warmDarkAmbient
        game.Lighting.GlobalShadows = true
    end)

    -- Elimina automáticamente cualquier Sky o efecto añadido después
    game.Lighting.DescendantAdded:Connect(function(obj)
        if obj:IsA("Sky") or obj:IsA("BlurEffect") or obj:IsA("BloomEffect") or obj:IsA("SunRaysEffect") then
            obj:Destroy()
        end
    end)
end
