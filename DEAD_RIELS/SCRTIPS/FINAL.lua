--!strict

--// Servicios
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer


--// Función 1: Configurar cámara y personaje
local function configurarCamara()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")

	Workspace.CurrentCamera.CameraSubject = humanoid
	player.CameraMode = "Classic"
	player.CameraMaxZoomDistance = math.huge
	player.CameraMinZoomDistance = 30
	humanoid.RootPart.Anchored = true
end

--// Función 2: Restaurar cámara al estado normal (predefinido)
local function stringACFrame(cadena: string): CFrame
	local valores = {}
	for valor in string.gmatch(cadena, "[^,%s]+") do
		table.insert(valores, tonumber(valor))
	end

	if #valores == 12 then
		return CFrame.new(
			valores[1], valores[2], valores[3],
			valores[4], valores[5], valores[6],
			valores[7], valores[8], valores[9],
			valores[10], valores[11], valores[12]
		)
	else
		warn("❌ Formato de CFrame inválido")
		return CFrame.new()
	end
end

local function restaurarCamara()
	local estadoGuardado = {
		FieldOfView = 70,
		CameraType = "Custom",
		CameraMode = "LockFirstPerson",
		CameraSubject = "Humanoid",
		CameraMinZoom = 0.5,
		CameraMaxZoom = 128,
		CFrame = "8.77192974, 4.76570702, 29833.2949, 0.19610092, 0.423039109, -0.884636939, 0, 0.902153492, 0.431415558, 0.980583787, -0.0846009851, 0.176913098"
	}

	task.wait(0.5)
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		warn("❌ No se encontró el Humanoid para asignar como CameraSubject")
		return
	end

	local cam = Workspace.CurrentCamera
	cam.CameraType = Enum.CameraType[estadoGuardado.CameraType]
	cam.CameraSubject = humanoid
	cam.CFrame = stringACFrame(estadoGuardado.CFrame)
	cam.FieldOfView = estadoGuardado.FieldOfView

	player.CameraMode = Enum.CameraMode[estadoGuardado.CameraMode]
	player.CameraMinZoomDistance = estadoGuardado.CameraMinZoom
	player.CameraMaxZoomDistance = estadoGuardado.CameraMaxZoom

	print("✅ Cámara restaurada correctamente.")
end

--// Función 3: Sentarse en MaximGun
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

--// Función 4: Ir al tren y hacer Tween hasta el asiento
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

--// Función 5: Movimiento como autoBonos
local function moverComoAutoBonos(destino: CFrame)
	local HRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not HRP then return end

	local tween = TweenService:Create(HRP, TweenInfo.new(17, Enum.EasingStyle.Quad), {
		CFrame = destino
	})
	tween:Play()

	if not HRP:FindFirstChild("VelocityHandler") then
		local bv = Instance.new("BodyVelocity")
		bv.Name = "VelocityHandler"
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.P = 3000
		bv.Parent = HRP
	end

	tween.Completed:Wait()

	if HRP:FindFirstChild("VelocityHandler") then
		HRP.VelocityHandler:Destroy()
	end

	if player.Character.Humanoid.Sit then
		player.Character.Humanoid.Sit = false
	end

	print("✅ Movimiento estilo autoBonos terminado.")
end

--// FUNCIÓN PRINCIPAL: Orquestador
local function inicializarSistema()
	if not game:IsLoaded() then game.Loaded:Wait() end
	repeat task.wait() until player.Character and not player.PlayerGui:FindFirstChild("LoadingScreenPrefab")

	ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EndDecision"):FireServer(false)

	configurarCamara()
	task.wait(2)

	sentarseEnMaximGun()
	task.wait(2)

	moverComoAutoBonos(CFrame.new(-428.9302978515625, 28.000032424926758, -49043.328125))
	task.wait(1)

	restaurarCamara()
end

--// EJECUTAR SISTEMA
inicializarSistema()
