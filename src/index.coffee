express = require 'express'
routes = require './routes'
path = require 'path'
config = require 'config'
{ logger } = require './middleware'
{ assets, publicdir, compile } = require './assets'
assets = assets()
app = express()

# Setup configuration

app.use assets.assets()
app.use logger.app app
app.set('views', path.join __dirname, 'views')
app.set('view engine', 'jade')

if config.production
  app.use '/assets', express.static path.join(publicdir, 'assets'), maxAge: '1 year'
  app.use express.static publicdir, maxAge: '1 day'
else
  app.use '/assets', assets.createServer()

# App Routes
app.get '/', (req, res) ->
  res.render 'index', {}
app.use '/channels', routes.channels
app.use '/connections', routes.connections

# Listen
app.logger.info "Attempting to bind to port %d", config.port
app.listen config.port
app.logger.info "Listening on port %d", config.port

module.exports = app
