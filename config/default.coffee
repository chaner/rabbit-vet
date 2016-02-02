module.exports =

  secure: true
  port: process.env.PORT
  production: process.env.NODE_ENV=='production' or true
  log:
    verbosity: process.env.VERBOSITY or 'info'
    access: process.env.LOG_ACCESS isnt 'false'
  assets:
    host: process.env.ASSET_HOST or ''
