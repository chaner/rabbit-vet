#= require runfirst.coffee
#= require_tree ./directives
#= require_tree ./modules
#= require_tree ./services

app = angular.module 'app', [
  'ui.router'
]

init app for init in window.Inits
