if Meteor.isServer
  clients = {}
  server = mqtt.Server Meteor.bindEnvironment (client) ->

    client.on 'connect', (packet) ->
      clients[packet.clientId] = client;
      client.id = packet.clientId;
      console.log("CONNECT: client id: " + client.id);
      client.subscriptions = [];
      client.connack({returnCode: 0});

    client.on 'subscribe', Meteor.bindEnvironment (packet) ->
      granted = []
      console.log("SUBSCRIBE(%s): %j", client.id, packet);
      for p in packet.subscriptions
        if Devices.findOne({key: p.topic})
          granted.push p.qos
          client.subscriptions.push new RegExp(p.topic.replace('+', '[^\/]+').replace('#', '.+') + '$')
        else
          granted.push 128
      client.suback {messageId: packet.messageId, granted: granted}

    client.on 'publish', Meteor.bindEnvironment (packet) ->
      params = JSON.parse packet.payload
      Meteor.call('add_data', packet.topic, params.id, params.name, params.unit, params.value)

      for c in Object.keys(clients)
        c = clients[c]
        for s in c.subscriptions
          if s.test packet.topic
            c.publish {topic: packet.topic, payload: packet.payload}
            break

    client.on 'pingreq', (packet) ->
      client.pingresp()

    client.on 'disconnect', (packet) ->
      client.stream.end()

    client.on 'close', (err) ->
      delete clients[client.id]

    client.on 'error', (err) ->
      return if not clients[client.id]
      client.stream.end();

  server.listen(1883)
