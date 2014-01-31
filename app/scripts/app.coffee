'use strict'

bitcamp = angular.module('bitcampApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
  #'ui.autocomplete'
])
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'partials/main'
        controller: 'MainCtrl'
      .when '/fireside',
        templateUrl: 'partials/fireside'
        controller: 'FiresideCtrl'
      .when '/404',
        templateUrl: 'partials/404'
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
  fontRatio : 60,
  lineRatio : 1.45
