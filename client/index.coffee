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

      .state "login",
        abstract: true
        url: "/login"
        templateUrl: "login/index.html"
        controller: "LoginCtrl"
      .state "login.main",
        url: "?token"
        templateUrl: "login/login.html"
        controller: "LoginCtrl.main"
      .state "login.reset",
        url: "/reset"
        templateUrl: "login/reset.html"
        controller: "LoginCtrl.reset"

      .state "confirm",
        url: "/confirm?token"
        controller: ($stateParams, $state) ->
          $state.go("login.main", $stateParams)

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
        auth: false
      .state "register.two",
        url: "/two"
        templateUrl: "register/2.html"
        controller: "RegisterCtrl_2"
        auth: true
      .state "register.three",
        url: "/three"
        templateUrl: "register/3.html"
        controller: "RegisterCtrl_3"
        auth: true
      .state "register.four",
        url: "/four"
        templateUrl: "register/4.html"
        controller: "RegisterCtrl_4"
        auth: true


      .state "404",
        url: "/404"
        templateUrl: "layout/404/index.html"
        controller: "404Ctrl"

  .directive "scrollTo", ->
    (scope, element, attrs) ->
      element.bind "click", (event) ->
        location = attrs.scrollTo
        $.scrollTo location, +attrs.scrollSpeed or 300


  .controller "BodyCtrl", ($http, $scope, $rootScope, $window, $location, $timeout, $cookieStore, $resource, $state) ->
    $rootScope.isLoaded = true

    $rootScope.bodyCSS = {
      "transition": "background-color 0.4s ease-out"
    }

    $rootScope.profile$  = {}

    $rootScope._login = (cookie) ->
      $rootScope.cookie   = cookie
      $rootScope._profile = $resource("/api/profile")
      $cookieStore.put "auth", cookie
      $http.defaults.headers
        .common["Authorization"] = "Token token=\"#{cookie.token}\""

    $rootScope._logout = ->
      $rootScope.profile$    = {}
      $rootScope._profile    = null
      $rootScope.cookie      = null
      $cookieStore.put "auth", null
      cookie = $cookieStore.get "auth"
      delete $http.defaults.headers.common["Authorization"]

    if $rootScope.cookie
      #$rootScope._profile.get()
      $http.get("/api/profile")
        .success (data) ->
          console.log data
        .error (err) ->
          console.log err

    $http.get("/api/bitcamp")
      .success ->
        console.log "Looking for this? http://github.com/bitcamp/bitca.mp"
        $("body").flowtype
          minimum   : 320
          maximum   : 1200
          minFont   : 17
          maxFont   : 22
          fontRatio : 40
          lineRatio : 1.45
      .error (data) ->
        null

    $rootScope.$on "$stateChangeStart", (ev, state) ->
      cookie = $cookieStore.get "auth"
      if cookie
        if moment(cookie.expires).diff(moment()) <= 0
          $rootScope._logout()
        else
          $rootScope._login(cookie)
      if state.auth is true and not cookie
        ev.preventDefault()
        $state.go "login.main"

    $rootScope.$on "$stateChangeSuccess", ->
      $window.scrollTo 0, 0
      $window.ga? "set", "page", $location.path()
      $window.ga? "send", "pageview"

    $rootScope.logout = ->
      # call the logout function after the logout get request
      $http.get("/api/logout")
        .success (data) ->
          console.log "logged out!"
        .error (err) ->
          console.log err
      $rootScope._logout()

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
