class EnvironmentsCtrl
  constructor: ($scope, localstorage) ->
    $scope.load = ->
      $scope.environments = JSON.parse localstorage.get 'environments'
    $scope.save = ->
      localstorage.set 'environments', $scope.import_data
      $scope.load()
    $scope.load()

EnvironmentsCtrl.$inject = ['$scope', 'localstorage']
window.Inits.push (app) ->
  app.controller 'EnvironmentsCtrl', EnvironmentsCtrl
