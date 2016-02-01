env = (environment='development') ->
  process.env.NODE_ENV = environment
  require 'config'
