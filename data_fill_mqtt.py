import paho.mqtt.client as mqtt
import time
from random import randint


def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect("127.0.0.1", 1883, 60)

while True:
  time.sleep(10)
  client.publish('21c948b6d5a0c279fea250bb8514bf', '{"id": 1, "name":"Temperatura zewnetrzna", "unit" : "*C", "value": %d}' % randint(20,30))
  client.publish('854c381b32db9eab5d9ecd7b6858a0', '{"id": 1, "name":"Temperatura piwka", "unit" : "*C", "value": %d}'  % randint(10,16))


