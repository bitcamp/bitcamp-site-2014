bitcamp = angular.module("bitcampApp")

  .controller "LoginCtrl", (
    $http,
    $scope,
    $rootScope,
    $stateParams,
    $state,
    $cookieStore,
    colors,
    $timeout) ->

    $rootScope.bodyCSS["background-color"] = colors["blue-light"]

    $scope.title     = ""

    $scope.$on "login:title", (ev, title) ->
      $scope.title = title


  .controller "LoginCtrl.main", (
    $http,
    $scope,
    $rootScope,
    $stateParams,
    $state,
    $cookieStore,
    colors,
    $timeout) ->

    $scope.$emit "login:title", "bitcamper login"

    $scope.email    = ""
    $scope.password = ""
    $scope.confirm  = ""

    $scope.token = $stateParams.token

    $scope.loginB_CSS = {
      "transition": "background-color 0.3s ease-out"
    }

    $scope.apiErr = (name, errObj) ->
      if errObj[name]
        m = "#{name} #{errObj[name][errObj[name].length-1]}"
        console.log m
        m
      else false

    if $cookieStore.get "auth"
      $state.go "main"

    $scope.loggingIn = false
    $scope.loginF = (email, password, token) ->
      $scope.loggingIn   = true
      $http.post("/api/login", {
        email:    $scope.email,
        password: $scope.password,
        token:    $scope.token
      })

        .success (cookie) ->
          $rootScope._login(cookie)
          if $stateParams.redirect
          then $state.go(decodeURIComponent $stateParams.redirect)
          else $state.go("main")

        .error ->
          $scope.loginB_CSS["background-color"] = colors["red"]
          $scope.emailErr    = true
          $scope.passwordErr = true
          ($timeout (->
            $scope.loggingIn = false
            delete $scope.loginB_CSS["background-color"]
            $("#login-password").focus()
            $scope.emailErr    = false
            $scope.passwordErr = false
          ), 1000)


  .controller "LoginCtrl.reset", ($http, $scope, $rootScope, $state, $stateParams, $cookieStore, colors, $timeout) ->
    $scope.$emit "login:title", "password reset"

    $scope.token = $stateParams.token

    $scope.email    = ""
    $scope.password = ""
    $scope.confirm  = ""

    $scope.resetting = false

    $scope.resetRequest = ->
      $scope.resetting = true
      console.log $scope.email
      console.log $scope
      $scope.emailErr    = false
      $scope.passwordErr = false
      $http.put("/api/login/reset", {
        email: $scope.email
      })
        .success (cookie) ->
          # FIXME: $rootScope._login(cookie)
          $scope.isReset = true
          $scope.email = ""
        .error ->
          ($timeout (->
            $scope.resetting    = false
          ), 1000)
          $scope.emailErr    = true
          $scope.passwordErr = true

    $scope.resetResponse = ->
      $scope.resetting = true
      console.log $scope.email
      console.log $scope
      $scope.emailErr    = false
      $scope.passwordErr = false
      $http.post("/api/login/reset", {
        password: $scope.password,
        confirm:  $scope.confirm,
        token:    $scope.token,
      })
        .success (cookie) ->
          # FIXME: $rootScope._login(cookie)
          $scope.isReset = true
          $scope.email = ""
        .error ->
          ($timeout (->
            $scope.resetting    = false
          ), 1000)
          $scope.emailErr    = true
          $scope.passwordErr = true

