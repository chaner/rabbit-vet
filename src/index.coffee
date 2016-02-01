express = require 'express'
routes = require './routes'
app = express()

# Setup configuration
# app.use express.static(__dirname + '/public')
# app.set 'view engine', 'jade'

# App Routes
app.use '/channels', routes.channels
app.use '/connections', routes.connections

# Listen
app.listen process.env.PORT || 3001
module.exports = app
