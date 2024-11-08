using Godot;
using System.IO.Ports;

public partial class Area2d : Area2D
{
	private const string PORT_NAME = "COM8"; // Cambia esto al puerto correcto
	private const int BAUD_RATE = 9600;

	private SerialPort serialPort;
	private bool minigameSuccessful = false;
	private bool responseReceived = false;
	private Node characterBody; // Almacena el cuerpo del personaje
	private Timer gameTimer; // Temporizador del minijuego
	private float gameDuration = 20.0f; // Duración del minijuego en segundos

	public override void _Ready()
	{
		// Conectar la señal
		this.BodyEntered += OnBodyEntered;

		// Abrir el puerto serial
		OpenSerialPort();

		// Inicializar el temporizador
		gameTimer = new Timer();
		AddChild(gameTimer);
		gameTimer.WaitTime = gameDuration; // Tiempo para el minijuego
		gameTimer.OneShot = true; // El temporizador solo se ejecuta una vez
		gameTimer.Timeout += OnGameTimeout; // Conectar la señal de tiempo agotado
	}

	private void OpenSerialPort()
	{
		try
		{
			serialPort = new SerialPort(PORT_NAME, BAUD_RATE);
			serialPort.DataReceived += OnDataReceived; // Escucha las respuestas de Arduino
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
		characterBody = body; // Almacena la referencia al cuerpo del personaje

		// Iniciar el minijuego
		SendArduinoMessage("Iniciar");
		gameTimer.Start(); // Inicia el temporizador

		// Ocultar la bomba
		Hide();
	}

	private void OnDataReceived(object sender, SerialDataReceivedEventArgs e)
	{
		string response = serialPort.ReadLine().Trim(); // Lee la respuesta del Arduino

		// Solo procesar la respuesta si no se ha recibido previamente
		if (!responseReceived)
		{
			responseReceived = true;

			if (response == "R")
			{
				minigameSuccessful = true;
				GD.Print("correcto"); // Imprime "correcto" en caso de éxito
				SendArduinoMessage("Resuelto");
				gameTimer.Stop(); // Detener el temporizador al resolver correctamente
			}
			else if (response == "F")
			{
				minigameSuccessful = false;
				GD.Print("incorrecto"); // Imprime "incorrecto" en caso de fallo
				HandleMinigameResult(characterBody); // Manejar el resultado de fallo inmediatamente
			}
		}
	}

	private void HandleMinigameResult(Node body)
	{
		if (minigameSuccessful)
		{
			GD.Print("Minijuego completado exitosamente, el personaje no muere.");
			return; // No hacer nada si se resolvió correctamente
		}

		// Si el minijuego falló
		GD.Print("El minijuego falló, se modifica la vida del personaje.");
		if (body is CharacterBody2D characterBody)
		{
			characterBody.Set("vida", 0); // Establecer la propiedad 'vida' a 0
			GD.Print("Vida del personaje modificada a 0.");
		}
		else
		{
			GD.Print("El cuerpo no tiene la propiedad 'vida' o no es del tipo correcto.");
		}

		SendArduinoMessage("Fallo");
	}

	private void OnGameTimeout()
	{
		GD.Print("Tiempo agotado"); // Mensaje en la consola
		if (!minigameSuccessful) // Solo si no se ha resuelto correctamente
		{
			GD.Print("El minijuego falló por tiempo agotado.");
			HandleMinigameResult(characterBody); // Manejar la muerte del personaje
		}
		else
		{
			GD.Print("Minijuego completado exitosamente antes del tiempo."); // Mensaje de éxito
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
