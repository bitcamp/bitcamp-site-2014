bitcamp = angular.module("bitcampApp")

  .controller "RegisterCtrl", ($scope, $rootScope, $location, $cookieStore, $timeout) ->
    $rootScope.api_messages = []

    $scope.email    = ""
    $scope.password = ""
    $scope.confirm  = ""
    $rootScope.$on "register", ->
      $timeout ->
        $scope.email    = ""
        $scope.password = ""
        $scope.confirm  = ""
      , 3000

    $scope.profile  = {}

    $scope.profile_fields = [
        field: "first"
        label: "first name"
      ,
        field: "last"
        label: "last name"
      ,
        field: "school"
        label: "school"
      ,
        field: "transportation"
        label: "mode of transportation"
      ,
        field: "stipend"
        label: "travel stipend"
      ,
        field: "dietary_restrictions"
        label: "dietary restrictions"
      ,
        field: "tshirt_size"
        label: "t-shirt size"
      ,
        field: "github"
        label: "github username"
      ,
        field: "website"
        label: "website url"
      ,
        field: "blurb"
        label: "hopes and dreams"
    ]

    if $cookieStore.get "auth"
      $rootScope._profile.get()
        .$promise.then (data) ->
          $scope.profile = data

    $rootScope.apiErr = (name, errObj) ->
      if errObj[name]
        m = "#{name} #{errObj[name][errObj[name].length-1]}"
        $rootScope.api_messages.push m
        console.log m
        m
      else false

    null

  .controller "RegisterCtrl_1", ($rootScope, $scope, $http, colors, $cookieStore, $state, $timeout) ->
    $rootScope.navBubbles = [true, false, false, false]
    $rootScope.bodyCSS["background-color"] = colors["green-light"]

    $rootScope.$on "register", ->
      $timeout ->
        $scope.emailErr     = ""
        $scope.passwordErr  = ""
        $scope.confirmErr   = ""
      , 3000

    if $cookieStore.get "auth"
      $state.go "register.two"

    $scope.register = ->
      $http.post("/api/register", {
        email:    $scope.email
        password: $scope.password
        confirm:  $scope.confirm
      })
        .success (data) ->
          $rootScope.api_messages = []
          $rootScope.$emit "register", null, data
          console.log data
          null
        .error (err) ->
          $rootScope.$emit "register", err
          $rootScope.api_messages = []
          console.log err
          $scope.emailErr    = $rootScope.apiErr "email", err
          $scope.passwordErr = $rootScope.apiErr "password", err
          $scope.confirmErr  = $scope.password isnt $scope.confirm

          if $scope.confirmErr
            err.confirm = ["that your passwords match"]
            $scope.passwordErr = $rootScope.apiErr "confirm", err


  .controller "RegisterCtrl_2", ($rootScope, colors, $cookieStore, $state) ->
    $rootScope.navBubbles = [true, true, false, false]
    $rootScope.bodyCSS["background-color"] = colors["blue-light"]

  .controller "RegisterCtrl_3", ($rootScope, colors, $cookieStore, $state) ->
    $rootScope.navBubbles = [true, true, true, false]
    $rootScope.bodyCSS["background-color"] = colors["orange-dark"]

  .controller "RegisterCtrl_4", ($rootScope, colors, $cookieStore, $state) ->
    $rootScope.navBubbles = [true, true, true, true]
    $rootScope.bodyCSS["background-color"] = colors["blue-darker"]

