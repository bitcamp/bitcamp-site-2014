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

  .directive "scrollOnClick", ->
    restrict: "A"
    link: (scope, $elm, attrs) ->
      idToScroll = attrs.href
      $elm.on "click", ->
        $target = undefined
        if idToScroll
          $target = $(idToScroll)
        else
          $target = $elm
        $("body").animate
          scrollTop: $target.offset().top
        , "slow"
