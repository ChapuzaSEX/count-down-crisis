using Godot;
using System.IO.Ports;

public partial class Area2d : Area2D
{
	private const string PORT_NAME = "COM8"; // Cambia esto al puerto correcto
	private const int BAUD_RATE = 9600;

	private SerialPort serialPort;
	private bool minigameSuccessful = false;
	private bool responseReceived = false;
	private Node characterBody;
	private Timer gameTimer;
	private float gameDuration = 20.0f;

	public override void _Ready()
	{
		// Conectar la señal de colisión
		this.BodyEntered += OnBodyEntered;

		// Abrir el puerto serial
		OpenSerialPort();

		// Inicializar el temporizador
		gameTimer = new Timer();
		AddChild(gameTimer);
		gameTimer.WaitTime = gameDuration;
		gameTimer.OneShot = true;
		gameTimer.Timeout += OnGameTimeout;
	}

	private void OpenSerialPort()
	{
		try
		{
			serialPort = new SerialPort(PORT_NAME, BAUD_RATE);
			serialPort.DataReceived += OnDataReceived;
			serialPort.Open();
			GD.Print("Puerto serial abierto: " + PORT_NAME);
		}
		catch (System.Exception e)
		{
			GD.Print("Error al abrir el puerto serial: " + e.Message);
		}
	}

	private void OnBodyEntered(Node body)
	{
		characterBody = body;
		if (body.Name == "CharacterBody2D")
		{
			// Cambiar a la escena de indicaciones
			GetTree().ChangeSceneToFile("res://ecenas/indicaciones.tscn");
			
			// Enviar mensaje a Arduino para iniciar
			SendArduinoMessage("Iniciar");
			gameTimer.Start();
			Hide();  // Ocultar la bomba
		}
	}

	private void OnDataReceived(object sender, SerialDataReceivedEventArgs e)
	{
		string response = serialPort.ReadLine().Trim();
		if (!responseReceived)
		{
			responseReceived = true;
			if (response == "R")
			{
				minigameSuccessful = true;
				GD.Print("correcto");
				SendArduinoMessage("Resuelto");
				gameTimer.Stop();
			}
			else if (response == "F")
			{
				minigameSuccessful = false;
				GD.Print("incorrecto");
				HandleMinigameResult(characterBody);
			}
		}
	}

	private void HandleMinigameResult(Node body)
	{
		if (minigameSuccessful)
		{
			GD.Print("Minijuego completado exitosamente, el personaje no muere.");
			return;
		}

		if (body is CharacterBody2D characterBody)
		{
			characterBody.Set("vida", 0); // Modificar vida a 0
			GD.Print("Vida del personaje modificada a 0.");
		}

		SendArduinoMessage("Fallo");
	}

	private void OnGameTimeout()
	{
		GD.Print("Tiempo agotado");
		if (!minigameSuccessful)
		{
			GD.Print("El minijuego falló por tiempo agotado.");
			HandleMinigameResult(characterBody);
		}
	}

	private void SendArduinoMessage(string message)
	{
		if (serialPort != null && serialPort.IsOpen)
		{
			serialPort.WriteLine(message);
		}
	}
}
