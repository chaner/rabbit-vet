window.Routing =
  otherwise: ($injector, $location) ->
    '/environments'

window.Inits.push (app) ->

  app.config ['$urlMatcherFactoryProvider', ($urlMatcherFactoryProvider) ->
    $urlMatcherFactoryProvider.strictMode false
  ]

  app.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise window.Routing.otherwise

    $stateProvider
    .state 'environments',
      url: '/environments'
      templateUrl: 'environments'
      controller: EnvironmentsCtrl
    .state 'environment',
      url: '/environment/:id'
      templateUrl: 'environment'
      controller: EnvironmentCtrl
  ]
