bunyan = require 'bunyan'
config = require 'config'
logger = require '../logger'

module.exports =
  app: (app) ->
    root = logger
    app.logger = app.locals.logger = root.child
      port: config.port
      service: config.app
      environment: config.env
      source: config.comp
      version: app.locals.version
    app.logger.debug 'Application logger initialized.'
    (req, res, next) ->
      req.logger = res.locals.logger = app.logger.child
        correlationid: req.correlation_id
        clientip: req.ip
      next()
