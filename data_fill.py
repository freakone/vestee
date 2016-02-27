from DDPClient import DDPClient
import time
from random import randint

client = DDPClient("ws://127.0.0.1:3000/websocket")
client.connect()

while True:
  api = "a72cc00489d7acda461724ae01ab2d"
  client.call('add_data', [api, 1, 'Temperatura zewnetrzna', '*C', randint(20,30)], [])
  client.call('add_data', [api, 2, 'Temperatura piwka', '*C', randint(10, 20)], [])
  client.call('add_data', [api, 3, 'Wilgotnosc', '%', randint(20,80)], [])

  time.sleep(2)
