/*
 * blinker.c
 *
 *  Created on: 28 lut 2016
 *      Author: ffrea_000
 */

#include "blinker.h"

void Blinker::blink()
{
	digitalWrite(ledPin, state);
	state = !state;
}

void Blinker::setStatus(Status stat)
{

}







