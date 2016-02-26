request = require 'superagent'

module.exports =
  channels: (req, res) ->
    request.get("https://#{req.query.domain}/api/channels")
    .set('Accept', 'application/json')
    .set('Authorization', req.headers.authorization)
    .end (err, response) ->
      return res.json err if err
      host_map = {}
      response?.body.map (connection) ->
        key = "#{connection.connection_details.peer_host}:#{connection.connection_details.peer_port}"
        host_map[key] ||= 0
        host_map[key]++
      res.json host_map
  connections: (req, res) ->
    request.get("https://#{req.query.domain}/api/connections")
    .set('Accept', 'application/json')
    .set('Authorization', req.headers.authorization)
    .end (err, response) ->
      return res.json err if err
      host_map = {}
      response?.body.map (connection) ->
        key = "#{connection.peer_host}:#{connection.peer_port}"
        host_map[key] ||= 0
        host_map[key]++
      res.json host_map
