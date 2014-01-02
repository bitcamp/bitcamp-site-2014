'use strict'

bitcamp = angular.module('bitcampApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
])
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'partials/main'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
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
  minFont   : 10,
  maxFont   : 20,
  fontRatio : 60,
  lineRatio : 1.45
