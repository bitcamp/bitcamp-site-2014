bitcamp = angular.module('bitcampApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
])
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main'
        controller: 'MainCtrl'
      .when '/fireside',
        templateUrl: 'views/fireside'
        controller: 'FiresideCtrl'
      .when '/404',
        templateUrl: 'layout/views/404'
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


$('body').flowtype
  minimum   : 320,
  maximum   : 960,
  minFont   : 12,
  maxFont   : 20,
  fontRatio : 55,
  lineRatio : 1.45
