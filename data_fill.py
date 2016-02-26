from DDPClient import DDPClient
import time
from random import randint

client = DDPClient("ws://vestee.herokuapp.com/websocket")
client.connect()

while True:
  client.call('add_data', ['01a66de93638c40cd87786cf2c9647', 1, 'Temperatura zewnetrzna', '*C', randint(20,30)], [])
  client.call('add_data', ['01a66de93638c40cd87786cf2c9647', 2, 'Temperatura piwka', '*C', randint(10, 20)], [])
  client.call('add_data', ['01a66de93638c40cd87786cf2c9647', 3, 'Wilgotnosc', '%', randint(20,80)], [])

  time.sleep(2)
