bitcamp = angular.module("bitcampApp", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngAnimate"

  "ui.router"
])


  .config ($stateProvider, $urlRouterProvider, $locationProvider) ->

    $locationProvider.html5Mode(true)

    $urlRouterProvider.otherwise "/404"

    $stateProvider
      .state "main",
        url: "/"
        templateUrl: "main/index.html"
        controller: "MainCtrl"

      .state "fireside",
        url: "/fireside"
        templateUrl: "fireside/index.html"
        controller: "FiresideCtrl"

      .state "faq",
        url: "/faq"
        templateUrl: "faq/index.html"
        controller: "FaqCtrl"
      .state "faq_sponsors",
        url: "/faq/sponsors"
        templateUrl: "faq/sponsors.html"
        controller: "FaqCtrl"

      .state "register",
        url: "/register"
        templateUrl: "register/index.html"
        controller: "RegisterCtrl"

      .state "404",
        url: "/404"
        templateUrl: "layout/404/index.html"
        controller: "404Ctrl"

    $("body").flowtype
      minimum   : 320
      maximum   : 1200
      minFont   : 17
      maxFont   : 22
      fontRatio : 40
      lineRatio : 1.45


  .directive "scrollTo", ->
    (scope, element, attrs) ->
      element.bind "click", (event) ->
        location = attrs.scrollTo
        $.scrollTo location, +attrs.scrollSpeed or 300


  .controller "BodyCtrl", ($http, $scope, $rootScope, $window, $location, $timeout) ->
    $rootScope.isLoaded = true

    $rootScope.bodyCSS = {}

    $http.get("/api/bitcamp")
      .success ->
        console.log "Looking for this? http://github.com/bitcamp/bitca.mp"
      .error (data) ->
        null

    $rootScope.$on "$routeChangeSuccess", ->
      $window.ga? "set", "page", $location.path()
      $window.ga? "send", "pageview"


  .factory "colors", ->
    "white"        : "#ffffff"
    "black"        : "#000000"
    "grey-light"   : "#e5d8cf"
    "grey"         : "#a58c7c"
    "grey-dark"    : "#7f6c60"
    "orange"       : "#ff6d40"
    "yellow"       : "#ffec40"
    "orangeyellow" : "#ffad40"
    "red"          : "#ff404a"
    "blue-light"   : "#ccf3ff"
    "blue-dark"    : "#538ca5"
    "green"        : "#53a559"
