#include <user_config.h>
#include <SmingCore/SmingCore.h>

#include <Libraries/OneWire/OneWire.h>
#include <Libraries/DS18S20/ds18s20.h>
#include <Libraries/DHT/DHT.h>



#ifndef WIFI_SSID
	#define WIFI_SSID "updaon" // Put you SSID and Password here
	#define WIFI_PWD "januchtokutas"
#endif

HttpServer server;
int totalActiveSockets = 0;
DS18S20 ReadTemp;
Timer procTimer;
FTPServer ftp;
DHT dht(14, DHT11);
MqttClient mqtt("m10.cloudmqtt.com", 12398);

void publishMessage(String msg)
{
	if (mqtt.getConnectionState() != eTCS_Connected)
		mqtt.connect("esp8266", "rodnztwb", "zEZoYjf0KfX-");

	mqtt.publish("sensors", msg); // or publishWithQoS
}

void readData()
{
	WebSocketsList &clients = server.getActiveWebSockets();

	uint8_t a;
	uint64_t info;
	float h = dht.readHumidity();
	float t = dht.readTemperature();

	publishMessage(String(t));

	for (int i = 0; i < clients.count(); i++)
		clients[i].sendString("DHT11: " + String(t) + "*C wilgotnosc: " + String(h) + "%");

	if (!ReadTemp.MeasureStatus())  // the last measurement completed
	{
      if (ReadTemp.GetSensorsCount())   // is minimum 1 sensor detected ?
		Serial.println("******************************************");
	    Serial.println(" Reding temperature DEMO");
	    for(a=0;a<ReadTemp.GetSensorsCount();a++)   // prints for all sensors
	    {
	      Serial.print(" T");
	      Serial.print(a+1);
	      Serial.print(" = ");
	      if (ReadTemp.IsValidTemperature(a))   // temperature read correctly ?
	        {

	    		for (int i = 0; i < clients.count(); i++)
	    			clients[i].sendString("DS18B20: " + String(ReadTemp.GetCelsius(a)) + "*C");
	    	  Serial.print(ReadTemp.GetCelsius(a));
	    	  Serial.print(" Celsius, (");
	    	  Serial.print(ReadTemp.GetFahrenheit(a));
	    	  Serial.println(" Fahrenheit)");
	        }
	      else
	    	  Serial.println("Temperature not valid");

	      Serial.print(" <Sensor id.");

	      info=ReadTemp.GetSensorID(a)>>32;
	      Serial.print((uint32_t)info,16);
	      Serial.print((uint32_t)ReadTemp.GetSensorID(a),16);
	      Serial.println(">");
	    }
		Serial.println("******************************************");
		ReadTemp.StartMeasure();  // next measure, result after 1.2 seconds * number of sensors
	}
	else
		Serial.println("No valid Measure so far! wait please");


}

void onIndex(HttpRequest &request, HttpResponse &response)
{
	TemplateFileStream *tmpl = new TemplateFileStream("index.html");
	auto &vars = tmpl->variables();
	//vars["counter"] = String(counter);
	response.sendTemplate(tmpl); // this template object will be deleted automatically
}

void onFile(HttpRequest &request, HttpResponse &response)
{
	String file = request.getPath();
	if (file[0] == '/')
		file = file.substring(1);

	if (file[0] == '.')
		response.forbidden();
	else
	{
		response.setCache(86400, true); // It's important to use cache for better performance.
		response.sendFile(file);
	}
}

void startWebServer()
{
	server.listen(80);
	server.addPath("/", onIndex);
	server.setDefaultHandler(onFile);

	// Web Sockets configuration
	server.enableWebSockets(true);
	Serial.println("\r\n=== WEB SERVER STARTED ===");
	Serial.println(WifiStation.getIP());
	Serial.println("==============================\r\n");
}

void startFTP()
{
	ftp.listen(21);
	ftp.addUser("me", "123"); // FTP account
}

// Will be called when WiFi station was connected to AP
void connectOk()
{
	Serial.println("I'm CONNECTED");
	startWebServer();
	startFTP();
	mqtt.connect("esp8266", "rodnztwb", "zEZoYjf0KfX-");

	procTimer.initializeMs(10000, readData).start();
}

void init()
{
	spiffs_mount(); // Mount file system, in order to work with files

	Serial.begin(SERIAL_BAUD_RATE); // 115200 by default
	Serial.systemDebugOutput(false); // Enable debug output to serial

	ReadTemp.Init(16);  			// select PIN It's required for one-wire initialization!
	ReadTemp.StartMeasure(); // first measure start,result after 1.2 seconds * number of sensors

	WifiStation.enable(true);
	WifiStation.config(WIFI_SSID, WIFI_PWD);
	WifiAccessPoint.enable(false);

//	// Run our method when station was connected to AP
	WifiStation.waitConnection(connectOk);
}
