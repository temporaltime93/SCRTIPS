--_G.MARCA_DEL_JUEGO = "DEAD_RIELS"
--_G.User_ID = "922173773631877150"
--// Servicios
local enlace = "https://discord.gg/2qcRceCmtC" 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

--// Estado Global
_G.Bond = 0
local textBox -- ? Referencia para actualizar el texto
local TIEMPO_ESPERA = 40 -- segundos sin cambio
local intervalo = 5      -- cada cuántos segundos revisa
local ultimoValor = _G.Bond or 0
local tiempoSinCambios = 0
--// Función 1: Crear GUI para mostrar contador de bonos
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")



local function crearGUIBond()

	if player.PlayerGui:FindFirstChild("CustomGui") then return end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CustomGui"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 999999
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.ZIndex = 10
	frame.Parent = screenGui

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Image = "rbxassetid://114117028561272"
	imageLabel.BackgroundTransparency = 1
	imageLabel.Size = UDim2.new(0, 1100, 0, 750)
	imageLabel.Position = UDim2.new(0.5, -550, 0.5, -375)
	imageLabel.ZIndex = 11
	imageLabel.Parent = frame

	local joinServer = Instance.new("TextButton")
	joinServer.Name = "join_server"
	joinServer.BackgroundTransparency = 1
	joinServer.TextTransparency = 1
	joinServer.Size = UDim2.new(0, 309, 0, 115)
	joinServer.Position = UDim2.new(0.5, 225, 0.5, 235)
	joinServer.ZIndex = 12
	joinServer.Parent = frame

	textBox = Instance.new("TextBox")
	textBox.ClearTextOnFocus = false
	textBox.Text = tostring(_G.Bond)
	textBox.Font = Enum.Font.Code
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.TextSize = 64
	textBox.BackgroundTransparency = 1
	textBox.Size = UDim2.new(0, 115, 0, 78)
	textBox.Position = UDim2.new(0.5, -57, 0.5, 165)
	textBox.ZIndex = 12
	textBox.Parent = frame
    joinServer.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(enlace)
            print("✅ Enlace copiado al portapapeles")
        else
            print("❌ No se pudo copiar. setclipboard no disponible.")
        end
    end)
end

--// Función 2: Contar bonos destruidos
local bondContados = {}

local function contarBonos()
	Workspace.RuntimeItems.ChildAdded:Connect(function(v)
		if v.Name:find("Bond") and v:FindFirstChild("Part") then
			if bondContados[v] then return end
			bondContados[v] = true

			v.Destroying:Once(function()
				_G.Bond += 1
			end)
		end
	end)
end

--// Función 3: Actualizar visualmente el contador en el TextBox
local function actualizarTextoGUI()
	spawn(function()
		repeat task.wait()
			if textBox and textBox.Parent then
				textBox.Text = tostring(_G.Bond)
			end
		until not player.PlayerGui:FindFirstChild("CustomGui")
	end)
end

--// Función 4: Configurar cámara y personaje
local function configurarCamara()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")

	Workspace.CurrentCamera.CameraSubject = humanoid
	player.CameraMode = "Classic"
	player.CameraMaxZoomDistance = math.huge
	player.CameraMinZoomDistance = 30
	humanoid.RootPart.Anchored = true
end

--// Función 5: Sentarse en MaximGun
local function sentarseEnMaximGun()
	repeat
		task.wait()
		player.Character.HumanoidRootPart.Anchored = true
		task.wait(0.5)
		player.Character.HumanoidRootPart.CFrame = CFrame.new(80, 3, -9000)
	until Workspace.RuntimeItems:FindFirstChild("MaximGun")

	task.wait(0.3)
	for _, v in ipairs(Workspace.RuntimeItems:GetChildren()) do
		if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
			v.VehicleSeat.Disabled = false
			v.VehicleSeat:SetAttribute("Disabled", false)
			v.VehicleSeat:Sit(player.Character.Humanoid)
		end
	end

	task.wait(0.5)
	for _, v in ipairs(Workspace.RuntimeItems:GetChildren()) do
		if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
			if (player.Character.HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude < 400 then
				player.Character.HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
			end
		end
	end

	task.wait(1)
	player.Character.HumanoidRootPart.Anchored = false
	repeat task.wait() until player.Character.Humanoid.Sit == true
	task.wait(0.5)
	player.Character.Humanoid.Sit = false

	repeat
		task.wait()
		for _, v in ipairs(Workspace.RuntimeItems:GetChildren()) do
			if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
				if (player.Character.HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude < 400 then
					player.Character.HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
				end
			end
		end
	until player.Character.Humanoid.Sit == true
end

--// Función 6: Ir al tren y hacer Tween hasta el asiento
local function irAlTren()
	task.wait(0.9)
	for _, v in ipairs(Workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("RequiredComponents") then
			local seat = v.RequiredComponents:FindFirstChild("Controls")
			if seat and seat:FindFirstChild("ConductorSeat") and seat.ConductorSeat:FindFirstChild("VehicleSeat") then
				local target = seat.ConductorSeat.VehicleSeat.CFrame * CFrame.new(0, 20, 0)
				local tp = TweenService:Create(player.Character.HumanoidRootPart, TweenInfo.new(25, Enum.EasingStyle.Quad), {CFrame = target})
				tp:Play()

				if not player.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") then
					local bv = Instance.new("BodyVelocity")
					bv.Name = "VelocityHandler"
					bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
					bv.Velocity = Vector3.new(0, 0, 0)
					bv.Parent = player.Character.HumanoidRootPart
				end

				tp.Completed:Wait()
			end
		end
	end
end

--// Función 7: Bucle infinito de recolección de bonos
local function autoRecolectarBonos()
	while true do
		if player.Character.Humanoid.Sit then
			local tpEnd = TweenService:Create(player.Character.HumanoidRootPart, TweenInfo.new(17, Enum.EasingStyle.Quad), {
				CFrame = CFrame.new(0.5, -78, -49429),
			})
			tpEnd:Play()

			if not player.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") then
				local bv = Instance.new("BodyVelocity")
				bv.Name = "VelocityHandler"
				bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
				bv.Velocity = Vector3.new(0, 0, 0)
				bv.Parent = player.Character.HumanoidRootPart
			end

			repeat task.wait() until Workspace.RuntimeItems:FindFirstChild("Bond")
			tpEnd:Cancel()

			-- ? Recolectar bonos visibles
			for _, v in ipairs(Workspace.RuntimeItems:GetChildren()) do
				if v.Name:find("Bond") and v:FindFirstChild("Part") then
					repeat
						task.wait()
						if v:FindFirstChild("Part") then
							player.Character.HumanoidRootPart.CFrame = v.Part.CFrame
							ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
						end
					until not v:FindFirstChild("Part")
				end
			end
		end
		task.wait()
	end
end
task.spawn(function()
	while true do
		task.wait(intervalo)

		local valorActual = _G.Bond or 0

		if valorActual ~= ultimoValor then
			-- * Hubo cambio en el contador: reinicia el temporizador
			ultimoValor = valorActual
			tiempoSinCambios = 0
			print("✅ Bond cambió a:", valorActual)
		else
			-- ? No hubo cambio → aumentar tiempo de inactividad
			tiempoSinCambios += intervalo
			print("⏱️ Sin cambios desde hace:", tiempoSinCambios, "segundos")

			if tiempoSinCambios >= TIEMPO_ESPERA then
				local Player = game.Players.LocalPlayer
				local function ResetCharacter()
					if Player.Character then
						local humanoid = Player.Character:FindFirstChild("Humanoid")
						if humanoid then
							humanoid.Health = 0
						end

					else
						warn("El personaje no está disponible.")
					end
				end
				ResetCharacter()
			end
		end
	end
end)

--// Sistema de salud crítico (vida < 20%)
local ejecutado = false

local function obtenerPorcentajeVida(h)
	local vidaActual = h.Health
	local vidaMaxima = h.MaxHealth
	local porcentaje = (vidaActual / vidaMaxima) * 100
	return math.floor(porcentaje)
end

local function manejarCambiosDeVida(humanoid)
	humanoid.HealthChanged:Connect(function()
		local porcentaje = obtenerPorcentajeVida(humanoid)
		print("❤️ Vida actual: " .. porcentaje .. "%")

		if porcentaje <= 20 and not ejecutado then
			ejecutado = true

			print("🚨 ¡Vida crítica! Ejecutando acción de emergencia...")

			local bonos = tostring(_G.Bond or "0")
			_G.enviar = {
				["BONOS: "]  = bonos,
				["VERSION: "] = "v1",
			}

			task.wait(2)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/temporaltime93/-PROTOTYPE-/main/[INTEGRACIONES]/api.lua"))()

			game.StarterGui:SetCore("SendNotification", {
				Title = "⚠️ Emergencia",
				Text = "¡Tu vida está por debajo del 20%! Datos enviados.",
				Duration = 3
			})
		end
	end)
end

-- * Escuchar respawns para reconectar el evento de vida
player.CharacterAdded:Connect(function(char)
	local h = char:WaitForChild("Humanoid")
	manejarCambiosDeVida(h)
end)

-- * Conectar si ya hay personaje activo
if player.Character and player.Character:FindFirstChild("Humanoid") then
	manejarCambiosDeVida(player.Character.Humanoid)
end

--// INICIAR SISTEMA
local function inicializarSistema()
	if not game:IsLoaded() then game.Loaded:Wait() end
	repeat task.wait() until player.Character and not player.PlayerGui:FindFirstChild("LoadingScreenPrefab")

	ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EndDecision"):FireServer(false)

	crearGUIBond()
	contarBonos()
	actualizarTextoGUI()
	configurarCamara()
	sentarseEnMaximGun()
	irAlTren()
	autoRecolectarBonos()
end

inicializarSistema()
