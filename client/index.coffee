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
        abstract: true
        url: "/register"
        templateUrl: "register/index.html"
        controller: "RegisterCtrl"
      .state "register.one",
        url: "/one"
        templateUrl: "register/1.html"
        controller: "RegisterCtrl_1"
      .state "register.two",
        url: "/two"
        templateUrl: "register/2.html"
        controller: "RegisterCtrl_2"
      .state "register.three",
        url: "/three"
        templateUrl: "register/3.html"
        controller: "RegisterCtrl_3"
      .state "register.four",
        url: "/four"
        templateUrl: "register/4.html"
        controller: "RegisterCtrl_4"

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

    $rootScope.$on "$stateChangeSuccess", ->
      $window.scrollTo 0, 0
      $window.ga? "set", "page", $location.path()
      $window.ga? "send", "pageview"


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
    "blue-dark"    : "#538ca5"
    "blue-darker"  : "#1a2e3c"
    "green"        : "#53a559"
    "green-light"  : "#40997c"
