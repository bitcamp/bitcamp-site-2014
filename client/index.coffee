bitcamp = angular.module('bitcampApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
  'ngAnimate'
])

  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'main/index.html'
        controller: 'MainCtrl'
      .when '/fireside',
        templateUrl: 'fireside/index.html'
        controller: 'FiresideCtrl'
      .when '/faq',
        templateUrl: 'faq/index.html'
        controller: 'FaqCtrl'
      .when '/faq/sponsors',
        templateUrl: 'faq/sponsors.html'
        controller: 'FaqCtrl'
      .when '/404',
        templateUrl: 'layout/404/index.html'
        controller: '404Ctrl'
      .otherwise
        redirectTo: '/404'
    $locationProvider.html5Mode(true)

  .directive "scrollTo", ->
    (scope, element, attrs) ->
      element.bind "click", (event) ->
        event.stopPropagation()
        scope.$on "$locationChangeStart", (e) -> e.preventDefault()
        location = attrs.scrollTo
        $.scrollTo location, 800


  .controller "BodyCtrl", ($http, $scope, $rootScope, $timeout) ->
    $rootScope.isLoaded = true
    $scope.animClass = ''
    $scope.animReady = false

    $http.get('/api/bitcamp')
      .success (data) ->
        $timeout ->
          $scope.animClass = "bitcamp-view"
          $scope.animReady = true
        , 10
      .error (data) ->
        null

    $rootScope.$on "$locationChangeStart", (e, next, current) ->
      $.scrollTo "#wrapper", 600

    $('body').flowtype
      minimum   : 320
      maximum   : 1200
      minFont   : 17
      maxFont   : 22
      fontRatio : 40
      lineRatio : 1.45
