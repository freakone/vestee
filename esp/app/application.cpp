#include <user_config.h>
#include <SmingCore/SmingCore.h>

#include <Libraries/OneWire/OneWire.h>
#include <Libraries/DS18S20/ds18s20.h>
#include <Libraries/DHT/DHT.h>

#ifndef WIFI_SSID
	#define WIFI_SSID "updaon" // Put you SSID and Password here
	#define WIFI_PWD "januchtokutas"
	#define DEVICE_ID ""
#endif

HttpServer server;
int totalActiveSockets = 0;
DS18S20 ds18;
Timer procTimer;
FTPServer ftp;
DHT dht(14, DHT11);
MqttClient mqtt("vestee.herokuapp.com", 1883);
DynamicJsonBuffer jsonBuffer;

void publishMessage(String msg)
{
	if (mqtt.getConnectionState() != eTCS_Connected)
		mqtt.connect(DEVICE_ID);

	mqtt.publish(DEVICE_ID, msg);
}

void readDHT()
{
	JsonObject& root = jsonBuffer.createObject();
	root["id"] = 1;
	root["name"] = "Temperatura zewnetrzna";
	root["unit"] = "*C";
	root["value"] = 22.5;

	float dhtHumid, dhtTemp;

	for(int i = 0; i < 5; i++)
	{
		dhtHumid = dht.readHumidity();
		if(dhtHumid)
			break;
	}

	for(int i = 0; i < 5; i++)
	{
		dhtTemp = dht.readTemperature();
		if(dhtTemp)
			break;
	}

	root["value"] = dhtTemp;

	publishMessage(root.toJsonString());

	root["id"] = 2;
	root["name"] = "Wilgotnosc zewnetrzna";
	root["unit"] = "*C";
	root["value"] = 22.5;



}

void readData()
{
	JsonObject& root = jsonBuffer.createObject();
	root["id"] = "gps";
	root["name"] = "Temperatura zewnetrzna";
	root["unit"] = "*C";
	root["value"] = 22.5;

	WebSocketsList &clients = server.getActiveWebSockets();

	uint8_t a;
	uint64_t info;
	float dhtHumid = dht.readHumidity();
	float dhtTemp = dht.readTemperature();

	while(!dhtHumid)
	{
		dhtHumid = dht.readHumidity();
	}

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

void connectOk()
{
	Serial.println("I'm CONNECTED");
	startWebServer();
	mqtt.connect(DEVICE_ID);

	procTimer.initializeMs(10000, readData).start();
}

void init()
{
	spiffs_mount();

	Serial.begin(SERIAL_BAUD_RATE);
	Serial.systemDebugOutput(false);

	ReadTemp.Init(16);
	ReadTemp.StartMeasure();

	WifiStation.enable(true);
	WifiStation.config(WIFI_SSID, WIFI_PWD);
	WifiAccessPoint.enable(false);

	WifiStation.waitConnection(connectOk);
}
