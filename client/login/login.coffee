bitcamp = angular.module("bitcampApp")

  .controller "LoginCtrl", ($http, $scope, $rootScope, $stateParams, $state, $cookieStore) ->
    $scope.email    = ""
    $scope.password = ""
    $scope.token    = $stateParams.token

    if $cookieStore.get "auth"
      $state.go "main"

    $scope.login = (email, password, token) ->
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
    null
