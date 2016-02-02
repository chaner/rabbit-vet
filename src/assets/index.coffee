MincerConnect = require 'connect-mincer'
Mincer = require 'mincer'
path = require 'path'
config = require 'config'

rootdir = path.join __dirname, '../..'
publicdir = path.join rootdir, 'public'

assetPaths = [
  'bower_components/angular-ui-router/release'
  'bower_components/angular'
  'bower_components/bootstrap/dist/css'
  'src/views/css'
  'src/views/js'
]

module.exports =
  assets: ->
    new MincerConnect
      root: rootdir
      production: config.production
      mountPoint: '/assets'
      assetHost: config.assets.host
      manifestFile: path.join publicdir, 'assets', 'manifest.json'
      paths: assetPaths
  publicdir: publicdir
  compile: ->
    env = new Mincer.Environment rootdir
    for assetPath in assetPaths
      env.appendPath assetPath
    env.cssCompressor = 'csso'
    # env.jsCompressor = 'uglify' #throws a parse error, no time to fix.
    manifest = new Mincer.Manifest env, path.join publicdir, 'assets'
    manifest.compile ['*', '*/**'], (err, data) ->
      console.info 'Finished precompile:'
      console.dir data
