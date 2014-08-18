bitcamp = angular.module("bitcampApp", [
  "ngAnimate"

  "ui.router"

  "angulartics"
  "angulartics.google.analytics"
])


.config (
  $stateProvider,
  $urlRouterProvider,
  $locationProvider,
  $httpProvider
) ->

  $locationProvider.html5Mode(true)

  $urlRouterProvider.otherwise "/404"

  $stateProvider
    .state "main",
      url: "/?hh"
      templateUrl: "main/index.html"
      controller: "MainCtrl"
    .state "404",
      url: "/404"
      templateUrl: "layout/404/index.html"
      controller: "404Ctrl"


.directive "scrollTo", ->
  (scope, element, attrs) ->
    element.bind "click", (event) ->
      $(attrs.scrollTo)[0].scrollIntoView(true)


.controller "BodyCtrl", (
  $http,
  $scope,
  $rootScope,
  $window,
  $location,
  $timeout,
  $state) ->

  $rootScope.isLoaded = true

  $rootScope.bowser = $window.bowser

  $rootScope.bodyCSS = {
    "transition": "background-color 0.4s ease-out"
  }

  $rootScope.ready = false
  $http.get("/api/bitcamp")
    .success ->
      console.log "Looking for this? http://github.com/bitcamp/bitca.mp"
      $rootScope.ready = true
      $("body").flowtype
        minFont   : 14
        maxFont   : 24
        fontRatio : 38
    .error (data) ->
      null

  $rootScope.$on "$stateChangeSuccess", ->
    $window.scrollTo 0, 0

  $rootScope.logout = ->
    $http.get("/api/logout")
      .success (data) ->
        null
      .error (err) ->
        console.log err
      .finally ->
        $rootScope._logout()

  $rootScope.treetentClick = ->
    $rootScope.$emit "treetent:click"

