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
    $httpProvider) ->

    $locationProvider.html5Mode(true)

    $urlRouterProvider.otherwise "/404"

    $stateProvider
      .state "main",
        url: "/"
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
        $rootScope.ready = true
      .error (data) ->
        null
      .finally ->
        console.log "Looking for this? http://github.com/bitcamp/2014.bit.camp"
        $("body").flowtype
          minFont   : 14
          maxFont   : 24
          fontRatio : 38


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

  .factory "colors", ->
    "white"        : "#ffffff"
    "black"        : "#000000"
    "grey-light"   : "#e5d8cf"
    "grey"         : "#a58c7c"
    "grey-dark"    : "#7f6c60"
    "orange"       : "#ff6d40"
    "orange-dark"  : "#dd773d"
    "yellow"       : "#ffec40"
    "orangeyellow" : "#ffad40"
    "red"          : "#ff404a"
    "blue-light"   : "#ccf3ff"
    "blue-dark"    : "#1A2D33"
    "blue-darker"  : "#1a2e3c"
    "green"        : "#53a559"
    "green-light"  : "#40997c"

