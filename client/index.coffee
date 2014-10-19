bitcamp = angular.module("bitcampApp", [
  "ngAnimate"

  "ui.router"
  "ui.utils"

  "angulartics"
  "angulartics.google.analytics"
])


bitcamp.config (
  $stateProvider
  $urlRouterProvider
  $locationProvider
  $httpProvider
  ngInject
) ->

  $locationProvider.html5Mode(true)

  $urlRouterProvider.otherwise "/404"

  $stateProvider
    .state "main",
      abstract: true
      url: "/"
      templateUrl: "main/index.html"
      controller: "main"
      resolve:
        starfieldShader: ngInject ($http) ->
          $http
            method: "GET"
            url: "main/starfield.glsl"
          .then ({data}) -> data
    .state "main.main",
      url: ""
      controller: "main.main"
    .state "main.hh",
      url: "hh"
      controller: "main.hh"
    .state "404",
      url: "/404"
      templateUrl: "layout/404/index.html"
      controller: "404Ctrl"


.directive "scrollTo", ->
  (scope, element, attrs) ->
    element.bind "click", (event) ->
      $(attrs.scrollTo)[0].scrollIntoView(true)


.controller "BodyCtrl", (
  $http
  $scope
  $rootScope
  $window
  $location
  $timeout
  $state
) ->

  window.$window = $window

  window.$state = $state

  $rootScope.ready = false

  $("body").flowtype
    minFont   : 14
    maxFont   : 24
    fontRatio : 38

  $scope.$on '$viewContentLoaded', ->
    $http.get("/api/bitcamp")
      .success ->
        $rootScope.ready = true
      .error (data) ->
        null

  $rootScope.$on "$stateChangeSuccess", ->
    $window.scrollTo 0, 0

  $rootScope.treetentClick = ($event) ->
    $rootScope.$broadcast "treetent:click", $event


bitcamp.constant("ngInject", angular.identity)


# Window and tab visibility.
.factory 'browserFocus', do ->
  vis = (->
    stateKey = undefined
    eventKey = undefined
    keys =
      hidden: "visibilitychange"
      webkitHidden: "webkitvisibilitychange"
      mozHidden: "mozvisibilitychange"
      msHidden: "msvisibilitychange"

    for stateKey of keys
      if stateKey of document
        eventKey = keys[stateKey]
        break
    (c) ->
      document.addEventListener eventKey, c if c
      not document[stateKey]
  )()

  focus = focus: null
  onFocus = ->
    focus.focus = true
    focus.blur  = false
  onBlur = ->
    focus.focus = false
    focus.blur  = true

  # check if current tab is active or not
  visCB = ->
    if vis() and document.hasFocus()
      setTimeout onFocus, 300
    else
      onBlur()
  vis visCB
  visCB()

  # check if browser window has focus
  notIE      = document.documentMode is undefined
  isChromium = window.chrome

  if notIE and not isChromium
    $(window)
      .on "focusin", ->
        setTimeout onFocus, 300
      .on "focusout", blur

  else
    # Is IE or Chromium.
    if window.addEventListener
      window.addEventListener "focus", ((event) ->
        setTimeout onFocus, 300
      ), false
      window.addEventListener "blur", onBlur, false

    else
      # bind focus event
      window.attachEvent "focus", (event) ->
        setTimeout onFocus, 300
      window.attachEvent "blur", onBlur

  -> focus

