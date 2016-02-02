config = require 'config'
bunyan = require 'bunyan'

logger = bunyan.createLogger
  name: 'rabbit-vet'
  stream: process.stderr
  level: config.log.verbosity

module.exports = logger
