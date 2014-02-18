bitcamp = angular.module('bitcampApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
  'ngAnimate'
])


  .config ($routeProvider, $locationProvider) ->

    $locationProvider.html5Mode(true)

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

    $('body').flowtype
      minimum   : 320
      maximum   : 1200
      minFont   : 17
      maxFont   : 22
      fontRatio : 40
      lineRatio : 1.45

    console.log "Looking for this? http://github.com/bitcamp/bitca.mp"


  .directive "scrollTo", ->
    (scope, element, attrs) ->
      element.bind "click", (event) ->
        location = attrs.scrollTo
        $.scrollTo location, +attrs.scrollSpeed or 300


  .controller "BodyCtrl", ($http, $scope, $rootScope, $window, $location) ->
    $rootScope.isLoaded = true

    $scope.animClass = ''
    $scope.animReady = false

    $http.get('/api/bitcamp')
      .success ->
        $scope.animClass = "bitcamp-view"
        $scope.animReady = true
      .error (data) ->
        null

    $rootScope.$on "$routeChangeSuccess", ->
      $window._gaq?.push ['_trackPageview', $location.path()]
      null

