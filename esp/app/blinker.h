#ifndef BLINKER_H
#define BLINKER_H

#include <user_config.h>
#include <SmingCore/SmingCore.h>

enum Status
{
	status_ok = 0,
	status_wifiError,
	status_connectionError,
	status_otherError,
	status_unknown
};


class Blinker
{
public:
	Blinker(uint8_t pin) : ledPin(pin)
	{
		deviceStatus = status_unknown;
		state = true;
		pinMode(pin, OUTPUT);
	}

	void setStatus(Status stat);
private:
	Status deviceStatus;
	void blink();
	Timer procTimer;
	bool state;
	uint8_t ledPin;

};

#endif
