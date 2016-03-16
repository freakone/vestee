#include <user_config.h>
#include <SmingCore/SmingCore.h>

#include <Libraries/OneWire/OneWire.h>
#include <Libraries/DS18S20/ds18s20.h>
#include <Libraries/DHT/DHT.h>
#include <sstream>

#ifndef WIFI_SSID
	#define WIFI_SSID "" // Put you SSID and Password here
	#define WIFI_PWD ""
	#define DEVICE_ID "2cab02b2662973418cf7b765dbf962"
#endif

HttpServer server;
int totalActiveSockets = 0;
DS18S20 ds18;
Timer procTimer;
FTPServer ftp;
DHT dht(14, DHT11);
MqttClient mqtt("vestee.freakone.pl", 1883);
DynamicJsonBuffer jsonBuffer;
String s, s2;
JsonObject& root = jsonBuffer.createObject();

void publishMessage(String msg)
{
	if (mqtt.getConnectionState() != eTCS_Connected)
		mqtt.connect(DEVICE_ID);

	mqtt.publish(DEVICE_ID, msg);
	Serial.println(msg);
}

void readDHT()
{
	root["id"] = 1;
	root["name"] = "Temperatura zewnetrzna";
	root["unit"] = "*C";

	TempAndHumidity res;
	if(dht.readTempAndHumidity(res))
	{
		root["value"] = res.temp;
		s = "";
		root.printTo(s);
		publishMessage(s);

		root["id"] = 2;
		root["name"] = "Wilgotnosc zewnetrzna";
		root["unit"] = "%";
		root["value"] = res.humid;
		s = "";
		root.printTo(s);
		publishMessage(s);
	}

}

void readDS()
{

	root["id"] = "3";
	root["name"] = "Temperatura piwka";
	root["unit"] = "*C";
	root["value"] = 22.5;

	for(int i = 0; i < 5; i++)
	{
		if(ds18.MeasureStatus() || ds18.GetSensorsCount() < 1)
			continue;

		    for(int a=0; a < ds18.GetSensorsCount(); a++)
		    {
		        if (ds18.IsValidTemperature(a))   // temperature read correctly ?
				{
		        	root["value"] = ds18.GetCelsius(a);
		        	s = "Termometr ";
		        	s += a+1;
		        	root["name"] = s.c_str();
					root["id"] = a+3;

					s2 = "";
					root.printTo(s2);
					publishMessage(s2);
				}
		    }
			ds18.StartMeasure();  // next measure, result after 1.2 seconds * number of sensors
			break;
	}
}

void readData()
{
	digitalWrite(2, 1);
	readDS();
	readDHT();
	digitalWrite(2, 0);
}

void connectOk()
{
	Serial.println("I'm CONNECTED");
	mqtt.connect(DEVICE_ID);
	procTimer.initializeMs(60000 * 5, readData).start();
}

void init()
{
	spiffs_mount();

	Serial.begin(SERIAL_BAUD_RATE);
	Serial.systemDebugOutput(false);

	ds18.Init(16);
	ds18.StartMeasure();

	pinMode(2, OUTPUT);
	digitalWrite(2, 0);

	WifiStation.enable(true);
	WifiStation.config(WIFI_SSID, WIFI_PWD);
	WifiAccessPoint.enable(false);

	WifiStation.waitConnection(connectOk);

}
