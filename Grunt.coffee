env = (environment='development') ->
  process.env.NODE_ENV = environment
  require 'config'

module.exports = (grunt) ->

  spawn = (cmd, cwd, args..., done) ->
    proc = grunt.util.spawn {cmd, args, opts: {cwd}}, (err) ->
      done not err?
    proc.stdout.pipe process.stdout
    proc.stderr.pipe process.stderr

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      bin: [ 'bin' ]
      dist: [ 'dist' ]
    copy:
      dist:
        files: [
          { expand: true, cwd: 'bin', src: [ 'lib/**', 'config/**' ], dest: 'dist' }
          { expand: true, src: 'package.json', dest: 'dist' }
        ]
    coffee:
      lib:
        expand: true
        cwd: 'src'
        src: '**/*.coffee'
        dest: 'bin/lib'
        ext: '.js'
      config:
        expand: true
        cwd: 'config'
        src: '**/*.coffee'
        dest: 'bin/config'
        ext: '.js'
      test:
        expand: true
        cwd: 'test'
        src: '**/*.coffee'
        dest: 'bin/test'
        ext: '.js'
    mochaTest:
      test:
        options:
          require: [
            'coffee-script/register'
            'test/setup.coffee'
          ]
        src: [ 'test/unit/server/**/*.coffee' ]
      queue:
        options:
          require: [
            'coffee-script/register'
            'test/setup.coffee'
          ]
        src: [ 'test/queue/**/*.coffee' ]
      integration:
        options:
          require: [
            'coffee-script/register'
            'test/setup.coffee'
          ]
        src: [ 'test/integration/**/*.coffee' ]
      coverage:
        options:
          reporter: 'html-cov'
          quiet: true
          captureFile: 'coverage.html'
          require: [
            'coffee-script/register'
            'test/coverage.coffee'
            'test/setup.coffee'
          ]
        src: [ 'test/unit/**/*.coffee' ]
  grunt.registerTask 'test', ['coffee', 'mochaTest:test']
  grunt.registerTask 'integration', ['coffee', 'mochaTest:integration']
  grunt.registerTask 'queue', ['coffee', 'mochaTest:queue']
  grunt.registerTask 'testall', ['coffee', 'mochaTest']

  grunt.registerTask 'procfile', 'Generate procfile', (dir) ->
    grunt.file.write "#{dir}/Procfile", 'web: node lib'

  grunt.registerTask 'shrinkwrap', 'Generate npm shrinkwrap file', (dest) ->
    done = @async()
    spawn 'npm', '.', 'shrinkwrap', (success) ->
      return done false unless success
      grunt.file.copy 'npm-shrinkwrap.json', "#{dest}/npm-shrinkwrap.json"
      grunt.file.delete 'npm-shrinkwrap.json'
      done()

  grunt.registerTask 'dist', ['coffee:lib', 'coffee:config', 'copy:dist', 'procfile:dist', 'shrinkwrap:dist']

  grunt.registerTask 'deploy', 'Deploy to heroku', (remote) ->
    aliases =
      prod: 'iddentity-greeter'
    unless aliases[remote]?
      grunt.log.error "Invalid remote provided.  Must be one of [#{(name for name, it of aliases).join(', ')}]."
      return false
    grunt.task.requires 'dist'
    done = @async()
    git = (args..., callback) ->
      spawn 'git', 'dist', args..., (success) ->
        return done false unless success
        callback()
    grunt.file.delete 'dist/.git'
    git 'init', ->
      git 'add', '.', ->
        git 'commit', '--allow-empty', '-m', "Deploying to #{aliases[remote]}.", ->
          git 'remote', 'add', '-f', remote, "git@heroku.com:#{aliases[remote]}.git", ->
            git 'push', '-f', remote, 'master', done
