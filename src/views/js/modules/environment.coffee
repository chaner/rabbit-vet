class EnvironmentCtrl
  constructor: ($stateParams, $scope, localstorage, $http) ->
    $scope.name = $stateParams.id
    $scope.environment = JSON.parse(localstorage.get('environments'))[$stateParams.id]
    $scope.hosts = {}
    $http({
      url: "/channels?domain=#{$scope.environment.domain}",
      method: 'GET',
      headers: {authorization: $scope.environment.authorization}
      }).then (data) ->
        $scope.channels = ({host: key, count: val} for key, val of data.data)
        $scope.channel_count = $scope.channels.reduce ((total, item) -> total + item.count), 0
    $http({
      url: "/connections?domain=#{$scope.environment.domain}",
      method: 'GET',
      headers: {authorization: $scope.environment.authorization}
      }).then (data) ->
        $scope.connections = data.data
        $scope.connection_count = (val for key, val of data.data).reduce ((total, item) -> total + item), 0

EnvironmentCtrl.$inject = ['$stateParams', '$scope', 'localstorage', '$http']
window.Inits.push (app) ->
  app.controller 'EnvironmentCtrl', EnvironmentCtrl
