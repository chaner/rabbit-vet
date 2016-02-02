module.exports =

  secure: false
  port: process.env.PORT or 3001
  production: process.env.NODE_ENV=='production' or false
  log:
    verbosity: process.env.VERBOSITY or 'debug'
