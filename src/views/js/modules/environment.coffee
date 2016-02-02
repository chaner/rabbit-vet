class EnvironmentCtrl
  constructor: ($stateParams, $scope, localstorage, $http) ->
    $scope.name = $stateParams.id
    $scope.environment = JSON.parse(localstorage.get('environments'))[$stateParams.id]
    $http({
      url: "/channels?subdomain=#{$scope.environment.subdomain}",
      method: 'GET',
      headers: {authorization: $scope.environment.authorization}
      }).then (data) ->
        $scope.channels = data.data
    $http({
      url: "/connections?subdomain=#{$scope.environment.subdomain}",
      method: 'GET',
      headers: {authorization: $scope.environment.authorization}
      }).then (data) ->
        $scope.connections = data.data

EnvironmentCtrl.$inject = ['$stateParams', '$scope', 'localstorage', '$http']
window.Inits.push (app) ->
  app.controller 'EnvironmentCtrl', EnvironmentCtrl
