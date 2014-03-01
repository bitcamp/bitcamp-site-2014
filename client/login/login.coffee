bitcamp = angular.module("bitcampApp")

  .controller "LoginCtrl", ($http, $scope, $rootScope, $stateParams, $state, $cookieStore) ->
    $scope.email    = ""
    $scope.password = ""
    $scope.token    = $stateParams.token

    $rootScope.api_messages = []

    $scope.apiErr = (name, errObj) ->
      if errObj[name]
        m = "#{name} #{errObj[name][errObj[name].length-1]}"
        console.log m
        m
      else false

    if $cookieStore.get "auth"
      $state.go "main"

    $scope.login = (email, password, token) ->
      $scope.emailErr    = false
      $scope.passwordErr = false
      $http.post("/api/login", {
        email:    $scope.email,
        password: $scope.password,
        token:    $scope.token
      })
        .success (cookie) ->
          $rootScope.cookie = cookie
          $cookieStore.put "auth", cookie
          $http.defaults.headers.common["Authorization"] = "Token token=\"#{cookie.token}\""
          if $scope.token
            $state.go("register.two")
          else
            $state.go("main")
        .error (err) ->
          console.log err
          $scope.emailErr    = true
          $scope.passwordErr = true
