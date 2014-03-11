bitcamp = angular.module("bitcampApp", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngAnimate"

  "ui.router"
  "ui.bootstrap"
])


  .config (
    $stateProvider,
    $urlRouterProvider,
    $locationProvider,
    $httpProvider) ->

    $httpProvider.responseInterceptors.push ["$location", "$q", "$injector"
      ($location, $q, $injector) -> (promise) ->
        promise.then ((x) -> x), (response) ->
          isRegister = response.config.url is "/api/register"
          isLogin    = response.config.url is "/api/login"
          isLogout   = response.config.url is "/api/logout"
          isReset    = response.config.url is "/api/login/reset"
          if response.status is 401 and
            not isRegister and
            not isLogin and
            not isLogout and
            not isReset
              $state = $injector.get("$state")
              $state.go "login.main",
                redirect: encodeURIComponent($state.$current.name)
          $q.reject response
    ]

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
        url: "?token&redirect"
        templateUrl: "login/login.html"
        controller: "LoginCtrl.main"
      .state "login.reset",
        url: "/reset?token"
        templateUrl: "login/reset.html"
        controller: "LoginCtrl.reset"

      .state "colorwar",
        url: "/colorwar"
        templateUrl: "color/index.html"
        controller: "ColorCtrl"        

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
        templateUrl: "register/one.html"
        controller: "RegisterCtrl.one"
      .state "register.two",
        url: "/two"
        templateUrl: "register/two.html"
        controller: "RegisterCtrl.two"
      .state "register.three",
        url: "/three"
        templateUrl: "register/three.html"
        controller: "RegisterCtrl.three"
      .state "register.four",
        url: "/four"
        templateUrl: "register/four.html"
        controller: "RegisterCtrl.four"

      .state "404",
        url: "/404"
        templateUrl: "layout/404/index.html"
        controller: "404Ctrl"


  .directive "scrollTo", ->
    (scope, element, attrs) ->
      element.bind "click", (event) ->
        location = attrs.scrollTo
        $.scrollTo location, +attrs.scrollSpeed or 300


  .controller "BodyCtrl", (
    $http,
    $scope,
    $rootScope,
    $window,
    $location,
    $timeout,
    $cookieStore,
    $resource,
    $state) ->

    $rootScope.isLoaded = true

    $rootScope.bodyCSS = {
      "transition": "background-color 0.4s ease-out"
    }

    $rootScope._login = (cookie) ->
      $rootScope.cookie = cookie
      $cookieStore.put "auth", cookie
      $http.defaults.headers
        .common["Authorization"] = "Token token=\"#{cookie.token}\""

    $rootScope._logout = ->
      $rootScope.cookie = null
      $cookieStore.put "auth", null
      delete $http.defaults.headers.common["Authorization"]

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

    $rootScope.$on "$stateChangeSuccess", ->
      $window.scrollTo 0, 0
      $window.ga? "set", "page", $location.path()
      $window.ga? "send", "pageview"

    $rootScope.logout = ->
      $http.get("/api/logout")
        .success (data) ->
          null
        .error (err) ->
          console.log err
        .finally ->
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


  .factory "profile", ($resource) ->
    $resource("/api/profile", {}, {
      save:
        method: 'PUT'
    })

