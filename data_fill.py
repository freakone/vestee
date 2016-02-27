from DDPClient import DDPClient
import time
from random import randint

client = DDPClient("ws://vestee.herokuapp.com/websocket")
client.connect()

while True:
  # api = "a72cc00489d7acda461724ae01ab2d"
  api = "01a66de93638c40cd87786cf2c9647"
  client.call('add_data', [api, 1, 'Temperatura zewnetrzna', '*C', randint(20,30)], [])
  client.call('add_data', [api, 2, 'Temperatura piwka', '*C', randint(10, 20)], [])
  client.call('add_data', [api, 3, 'Wilgotnosc', '%', randint(20,80)], [])

  time.sleep(2)
