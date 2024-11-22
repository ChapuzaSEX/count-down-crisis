using Godot;
using System.Collections.Generic;
using System.IO.Ports;

public partial class Indicaciones : Control
{
	private RichTextLabel pistasLabel; // Referencia al RichTextLabel
	private List<string> pistas; // Lista de pistas
	private int indicePista; // Índice de la pista actual
	private SerialPort serialPort;

	public override void _Ready()
	{
		// Referencia al nodo RichTextLabel
		pistasLabel = GetNode<RichTextLabel>("RichTextLabel");

		// Asegúrate de que el RichTextLabel sea visible
		pistasLabel.Visible = true;


		// Crear el temporizador
		Timer timer = new Timer();
		timer.WaitTime = 1.0f; // El tiempo en segundos entre actualizaciones
		timer.OneShot = false; // El temporizador se repetirá
		timer.Timeout += OnTimerTimeout;
		AddChild(timer);
		timer.Start();

		// Inicializar lista de pistas
		pistas = new List<string>
		
{
	"¡Atención! Estás a punto de desarmar la bomba.\n" +"\n"+
	"Instrucciones:\n" +"\n"+
	"1. Memoriza el patrón que aparecerá en la pantalla.\n" + "\n"+
	"2. Presiona los botones en el orden exacto para desactivarla.\n" + "\n"+
	"¡Cuidado! Un error puede ser fatal. ¡Hazlo con precisión!"
};

		

		indicePista = 0; // Comenzar con la primera pista

		// Mostrar la primera pista
		MostrarPista();

		// Conectar al puerto serial
		OpenSerialPort();
	}

	private void MostrarPista()
	{
		// Mostrar la pista actual
		if (indicePista < pistas.Count)
		{
			GD.Print("Asignando pista: " + pistas[indicePista]);

			// Cambiar el tamaño de la fuente
			pistasLabel.AddThemeFontSizeOverride("font_size", 60 + (indicePista * 5)); // Aumenta el tamaño de la fuente progresivamente

			// Cambiar la fuente si deseas usar una personalizada
			pistasLabel.AddThemeFontOverride("font", GD.Load<Font>("res://letras/letra.tres"));

			// Efecto máquina de escribir
			TweenMachineEffect(pistasLabel, pistas[indicePista]);

			indicePista++;
		}
	}

	// Efecto de máquina de escribir (muestra el texto carácter por carácter)
	private void TweenMachineEffect(RichTextLabel label, string texto)
	{
		// Limpia el contenido anterior
		label.Clear();

		// Usar un temporizador único para ir mostrando el texto carácter por carácter
		int longitudTexto = texto.Length;
		int i = 0;

		Timer timer = new Timer();
		timer.WaitTime = 0.02f; // Tiempo entre cada carácter
		timer.OneShot = false;
		timer.Timeout += () =>
		{
			if (i <= longitudTexto)
			{
				label.Text = texto.Substring(0, i);
				i++;
			}
			else
			{
				timer.Stop(); // Detener el temporizador cuando se haya mostrado todo el texto
			}
		};
		AddChild(timer);
		timer.Start();
	}

	private void OpenSerialPort()
	{
		try
		{
			serialPort = new SerialPort("COM8", 9600);
			serialPort.DataReceived += OnDataReceived;
			serialPort.Open();
			GD.Print("Puerto serial abierto");
		}
		catch (System.Exception e)
		{
			GD.Print("Error al abrir el puerto serial: " + e.Message);
		}
	}

	private void OnDataReceived(object sender, SerialDataReceivedEventArgs e)
	{
		string response = serialPort.ReadLine().Trim();

		// Si Arduino envía "correcto" o "incorrecto", mostrar la siguiente pista
		if (response == "R" || response == "F")
		{
			MostrarPista(); // Mostrar la siguiente pista
		}
	}

	// Método que se ejecuta cada frame en Godot 4.x
	private void OnTimerTimeout()
	{
		// Código que se ejecutará en cada "tick" del temporizador
	}
}
