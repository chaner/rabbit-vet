localstorage = ->
  get: (key) ->
    localStorage.getItem key
  set: (key, val) ->
    localStorage.setItem key, val

window.Inits.push (app) ->
  app.factory 'localstorage', localstorage
