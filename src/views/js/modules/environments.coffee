class EnvironmentsCtrl
  constructor: ($scope, localstorage) ->
    $scope.environments = JSON.parse localstorage.get 'environments'
    $scope.save = ->
      localstorage.set 'environments', $scope.import_data

EnvironmentsCtrl.$inject = ['$scope', 'localstorage']
window.Inits.push (app) ->
  app.controller 'EnvironmentsCtrl', EnvironmentsCtrl
