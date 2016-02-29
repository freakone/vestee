import paho.mqtt.client as mqtt


def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    # client.subscribe("$SYS/#")

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect("vestee.herokuapp.com", 1883, 60)
client.publish('bb5269ee02cead865e40f97033b92a', "{'id': 1, 'name':'test', 'unit' : '*C', 'value': 23}")
client.loop_forever()
