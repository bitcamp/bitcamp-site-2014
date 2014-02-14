bitcamp = angular.module('bitcampApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
  'ngAnimate'
])

  .config ($routeProvider, $locationProvider) ->
    console.log "Looking for this? http://github.com/bitcamp/bitca.mp"

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
        location = attrs.scrollTo
        $.scrollTo location, +attrs.scrollSpeed or 300

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

    $rootScope.$on "$routeChangeStart", (e, next, current) ->
      null

    $('body').flowtype
      minimum   : 320
      maximum   : 1200
      minFont   : 17
      maxFont   : 22
      fontRatio : 40
      lineRatio : 1.45
