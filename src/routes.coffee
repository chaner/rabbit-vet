request = require 'superagent'

module.exports =
  channels: (req, res) ->
    request.get("https://#{req.query.subdomain}.rmq.cloudamqp.com/api/channels")
    .set('Accept', 'application/json')
    .set('Authorization', req.headers.authorization)
    .end (err, response) ->
      return res.json err if err
      host_map = {}
      response?.body.map (connection) ->
        host_map[connection.connection_details.peer_host] ||= 0
        host_map[connection.connection_details.peer_host] += connection.number
      res.json host_map
  connections: (req, res) ->
    request.get("https://#{req.query.subdomain}.rmq.cloudamqp.com/api/connections")
    .set('Accept', 'application/json')
    .set('Authorization', req.headers.authorization)
    .end (err, response) ->
      return res.json err if err
      host_map = {}
      response?.body.map (connection) ->
        host_map[connection.peer_host] ||= 0
        host_map[connection.peer_host]++

      res.json host_map
